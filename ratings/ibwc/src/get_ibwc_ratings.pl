#!/usr/bin/perl

use warnings;
use strict;

#use libraries from HDB environment (Solaris only except for HDB.pm)
# the following line was changed by M. Bogner 3/3/2011 to use the new PERL Environment
# this Perl variable is set in .cshrc_hdb_app
use lib "$ENV{HDB_ENV}/perlLib/lib";

use Hdb;

use LWP::UserAgent;
use File::Basename;
use Data::Dumper;

#Version Information
my $verstring = '$Revision$';
$verstring =~ s/^\$Revision: //;
$verstring =~ s/ \$//;

#check to see command line usage.
my $progname = basename($0);    
chomp $progname;

my ( $accountfile, $hdbuser, $hdbpass, $debug, $sitearg, $readfile );

#store decodes dir of HDB environment for use
my $decdir = "$ENV{HDB_ENV}/ratings/ibwc/src";

#the ugly globals...
my $agen_abbrev      = 'IBWC';
my $data_source      = 'IBWC Unit Values (Realtime)';
my $usgs_rating_type = 'Shift Adjusted Stage Flow';

main();  #at end of file to allow all subroutines to be prototyped.

# currently depend on the Realtime website download
# specifications to determine the sites to
# retrieve ratings for.
# FIXME: JUST USGS sites from telemetry, instead of Realtime web loader
# fix to only get sites that have an SDI for STAGE by M Bogner 16 Feb 2011
# This is copy from the original get_usgs_ratings.pl made to work
# with the IBWC website 
sub read_usgs_sites ($) {
  my $hdb = shift;

#  this query was change by M. Bogner 16-FEB-2011 to only get sites that have SDIs for STAGE
#  this quy uses a hard coded 65 datatype_id
  my $sites = $hdb->dbh->selectcol_arrayref(
    "select distinct a.primary_site_code siteno
from ref_ext_site_data_map a, hdb_ext_data_source b,
hdb_site_datatype c, hdb_site_datatype d
where
b.ext_data_source_name = '$data_source' and
b.ext_data_source_id = a.ext_data_source_id and
a.hdb_site_datatype_id = c.site_datatype_id and
d.site_id = c.site_id and
d.datatype_id = 65 and
a.is_active_y_n = 'Y'
order by siteno"
  );

  return $sites;
}

# in a loop over the list of sites
# get the rating table and process it.
sub process_usgs_sites ($$) {
  my $hdb   = shift;
  my $sites = shift;

  if ($readfile) {
    my $site = $$sites[0]; #use first site
    my $ratarr = open_rating_table();
    my $content = join ('',@$ratarr); #turn array read in from file into string again
    my $rating = process_rating($hdb, $site, $content) unless $debug;
    print "$0: $readfile read successfully: rating_id $rating updated successfully.\n" unless $debug;
  } else {
    my ( $ua, $request ) = build_web_request();

    foreach my $site (@$sites) {
      my $response = retrieve_rating_table( $site, $ua, $request );
      if ( $response->is_success ) {
        process_rating( $hdb, $site, $response->content) unless $debug;
      } else {
        die("Error reading from $agen_abbrev web page, cannot continue\n");
      }
    }
  }
}

#open the rating file
sub open_rating_table () {
  open NEWRAT, "<", $readfile or die "Could not open file $readfile";
  my @response = <NEWRAT>;
  close NEWRAT;

  return \@response;
}

#download the rating file
sub retrieve_rating_table ($$$) {
  my $site    = shift;
  my $ua      = shift;
  my $request = shift;

  my $file = $site . ".rdb";
#  my $url  = "ftp://guest8:guest8\@66.85.17.138/PUBLICWAD/rdb_files/$file";
#  my $url  = "ftp://WAD_User:US!bwcW@d\@63.96.218.88/PUBLICWAD/rdb_files/$file";
  my $userPass  = 'BoR_User:wr!\?THIu';
#  my $url  =  "ftp://" . $userPass . "\@63.96.218.8/IBWC/rdb/$file";
  my $url  =  "ftp://63.96.218.8/IBWC/rdb/$file";

print "URL: $url \n";

  $request->uri($url);
  $request->authorization_basic( 'BoR_User','wr!?THIu' );
  # this next function actually gets the data
  my $response = $ua->simple_request($request);

  # check result
  if ( $response->is_success ) {
    my $status = $response->status_line;
    print "Data read from $agen_abbrev for site $site: $status\n";
  } else {    # ($response->is_error)
    printf STDERR $response->error_as_HTML;
  }
  return $response;
}

# setup the request.
sub build_web_request () {
  my $ua = LWP::UserAgent->new;
  $ua->agent('IBWC Rating Table Retrieval for US Bureau of Reclamation HDB: '); #will append lwp version to this with space
  $ua->from('agilmore@uc.usbr.gov');
  $ua->timeout(600);
  my $request = HTTP::Request->new();
  $request->method('GET');
  return ( $ua, $request );
}

#check the returned rating against filesystem stored version
# and update the database and write a new file if different.
# have to compare the actual table rather than header on the
# table because it changes (at least the shifted date) every day
# FIXME: compare new rating against database stored version instead
sub process_rating ($$$) {
  my $hdb      = shift;
  my $site     = shift;
  my $content  = shift;

  #write out new file, regardless of any real changes.
  open NEWRAT, ">$decdir/data/$site.rdb";
  print NEWRAT $content;
  close NEWRAT;

  my @newrat = split /\n/, $content;
  my @barerat = grep( !/^#/, @newrat );

  my $rating = find_rating( $hdb, $site );    

  if ($rating) {
    if (compare_rating($hdb, $rating, \@barerat )) {
      #actual ratings are the same, no update required, we're done;
      print "No change in rating for $site\n";
      return $rating;
    } else {
      #clean up old rating
      delete_rating_points($hdb,$rating);
    }
  } else {
     $rating = create_site_rating( $hdb, $site);
  }
  #update database, pass in already split rating with comments
  update_rating( $hdb, $rating, \@newrat );
  return $rating;
}

#delete old rating data
sub delete_rating_points ($$) {
  my $hdb=shift;
  my $rating=shift;
  
  eval {
    my $sth = $hdb->dbh->prepare(
    "begin
       ratings.delete_rating_points(?);
     end;");
    $sth->bind_param(1,$rating);
    $sth->execute;
  };
 
  if (@$) { #errors
    $hdb->dbh->rollback;
    $hdb->hdbdie("Deletion of rating_id $rating failed! $!\n");
  } else {
    $hdb->dbh->commit;
  }
}

# rating table is different, so update the database
# run through the headers, saving certain lines
# skip the header and column defs
# create a new rating record if required, 
# update description if rating record already exists
# then run through table and write to database.
sub update_rating ($$$) {
  my $hdb  = shift;
  my $rating = shift;
  my $rat  = shift;

  my @rating_info;
  my %seen = ();

  foreach (@$rat) {
    chomp;
#   print STDERR "$_\n";
# since this is a windows file there are carraige returns in it
# add sed command to remove carraige return  by M. Bogner 04222010
    s/\r//;

    if (/^#/) {
      next unless /DATABASE|STATION|RATING|SHIFT/;    #ignore all other rows in header
      next unless
        /NAME|NUMBER|ID|REMARKS|COMMENT|PREV BEGIN|PREV STAGE/;    #only pick these rows out of header
      s/^# \/\///;                          # get rid of leading '# //' text
      push @rating_info,$_ unless $seen{$_}++; #avoid duplicate entries... after perldoc -q dup
    } elsif (/^INDEP/) {
      #header finished
      my $desc = join "\n", @rating_info;
      #update description
      update_rating_info( $hdb, $rating, $desc );
    } elsif (/[[:upper:]]/) {    # match any uppercase character.
          # this discards the "16N\t16N\t16N\t1S" string after the header.
      ;
    } elsif (/[^\d\s*.-]/) {
      $hdb->hdbdie("malformed rdb file! $_\n");
    } else {    #now handle actual rating
      modify_rating_point( $hdb, $rating, split );
      # this line changed by M Bogner 7-March-2011 because the file seemed to change the whitespace
      #modify_rating_point( $hdb, $rating, split /\t/ );
    }
  }
}

# attempt to find rating id for site
sub find_rating ($$) {
  my $hdb  = shift;
  my $site = shift;
  my $rating_id;

  my $sdi; 
  ( undef, $sdi ) = find_agen_sdi( $hdb, $site );

  eval {
    $rating_id =
      $hdb->dbh->selectcol_arrayref( #ugly global var here...
            "select ratings.find_site_rating('$usgs_rating_type',$sdi,null) from dual")->[0];
  };

  if (@$)    #error occurred
  {
    $hdb->hdbdie("Query of site $site for ratings failed! $!\n");
  }

  return $rating_id;
}

# find agency and sdi from ext_data_map
# FIXME: decoded telemetry site list instead
sub find_agen_sdi ($$) {
  my $hdb  = shift;
  my $site = shift;

  my $querysql = "select b.agen_id, d.site_datatype_id
  from ref_ext_site_data_map a, hdb_ext_data_source b,
  hdb_site_datatype c, hdb_site_datatype d
  where primary_site_code = '$site' and
  b.ext_data_source_id = a.ext_data_source_id and
  b.ext_data_source_name = '$data_source' and
  a.hdb_site_datatype_id = c.site_datatype_id and
  d.site_id = c.site_id and
  d.datatype_id = 65"; #hardcoded Gage Height here, UG!

  my ( $agen_id, $sdi);

#print "SQL: $querysql \n";

  eval {
    my $result = $hdb->dbh->selectall_arrayref($querysql);
# a bit hairy here, see DBI docs for return value
    ( $agen_id, $sdi) = @{$result->[0]};
  };

  if (@$)    #error occurred
  {
    $hdb->hdbdie("Query of site $site for ext_data_map failed!\n");
  }

  return ( $agen_id, $sdi );
}

# update the description and delete the old rating points
sub update_rating_info ($$$) {
  my $hdb    = shift;
  my $rating = shift;
  my $desc   = shift;

  eval {
    my $sth = $hdb->dbh->prepare(
    "begin
       ratings.update_rating_desc (?,?);
     end;");
    $sth->bind_param(1,$rating);
    $sth->bind_param(2,substr($desc,0,1000)); #description in DB has 1000 char limit
    $sth->execute;
  };    # semicolon here because of use of eval

  if (@$)    #error occurred
  {
    $hdb->dbh->rollback;
    $hdb->hdbdie("Update of rating id $rating failed!\n");
  } else {
    $hdb->dbh->commit or $hdb->hdbdie( $hdb->dbh->errstr );
  }
}

# make a new site rating record
sub create_site_rating ($$) {
  my $hdb  = shift;
  my $site = shift;
  my $desc = shift;
  my $rating_id;

  # get data for creation
  my ( $agen, $sdi );
  ($agen,$sdi) = find_agen_sdi( $hdb, $site );
  
  eval {
    my $sth = $hdb->dbh->do( "
      begin ratings.create_site_rating($sdi,
            '$usgs_rating_type',null,null,$agen,null);
      end;" );

    $rating_id =
      $hdb->dbh->selectcol_arrayref(
            "select ratings.find_site_rating('$usgs_rating_type',$sdi,null) from dual")->[0];
  };    # semicolon here because of use of eval

  if ( @$ or !defined($rating_id) )    #error occurred
  {
    $hdb->dbh->rollback;
    $hdb->hdbdie("Creation of rating failed for site $site! $@\n");
  } else {
    $hdb->dbh->commit or $hdb->hdbdie( $hdb->dbh->errstr );
  }

  return $rating_id;
}

{
my $sth; #make static so prepare statement can be done once.
sub modify_rating_point ($$@) {
  my $hdb    = shift;
  my $rating = shift;

  #rest of data is INDEP, SHIFT, DEP, and STOR from the file. We store in
  # the database just INDEP and DEP, since SHIFT is meaningless with a
  # shift adjusted rating table

  eval {
    if (!defined ($sth)) {
      $sth = $hdb->dbh->prepare( "
         begin ratings.modify_rating_point(?,?,?);
         end;" );
    }
    my $param2 = substr($_[0],0);
    my $param3 = substr($_[2],0);
#    print STDERR "RATING=$rating 2=$param2 3=$param3\n";
    $sth->bind_param(1,$rating);
    $sth->bind_param(2,$param2);    
    $sth->bind_param(3,$param3);
#    $sth->bind_param(2,$_[0]);    
#    $sth->bind_param(3,$_[2]);
    $sth->execute;
  };    # semicolon here because of use of eval

  if (@$)    #error occurred
  {
    $hdb->dbh->rollback;
    $hdb->hdbdie(
                "Modification for rating $rating, indep value $_[0] failed!\n");
  } else {
    $hdb->dbh->commit or $hdb->hdbdie( $hdb->dbh->errstr );
  }
}
}

# compare rating from web with db
# more expensive than comparison with filesystem, but best to make sure
# database is in sync
sub compare_rating ($$$) {    #returns 1 if arrays are equal, 0 if not
  my $hdb    = shift;
  my $rating    = shift;
  my @newrat = @{shift()};
  splice(@newrat,0,2); #cut off top two lines, which are column name and type definitions.
  
  
  my $dbrat;
  #retrieve entire rating from db
  
  eval {
    $dbrat = $hdb->dbh->selectall_arrayref("
    select * from ref_rating where rating_id = $rating
     order by independent_value");
  };
  
  if (@$) {
    $hdb->dbh->rollback;
    $hdb->hdbdie("Failed to select rating table $rating from db! $!\n")  
  
  }
  
  # after perldoc -f splice
  return 0 unless @newrat == @$dbrat;    # same len?
  while (@newrat) {
    my ($db_indep, $db_dep) = @{pop(@$dbrat)}[1,2]; # hoorah for perl ref and array syntax!
 #  print STDERR "DBDEP: $db_indep DB_DEPEND: $db_dep \n";
    #my ($web_indep, $web_dep) = (split '\t', pop(@newrat))[0,2]; # same!
# changed by M bogner 03-07/2011 because the format changed from tab to spaces
    my ($web_indep, $web_dep) = (split ' ', pop(@newrat))[0,2]; # same!
 #  print STDERR "INDEP: $web_indep DEPEND: $web_dep \n";
    return 0 if $web_indep != $db_indep or $web_dep != $db_dep; #possible floating point issues
  }
  return 1;
}

sub process_args (@) {
  my $mode;

  #scalar and array versions, the scalars are a string of the arrays

  while (@_) {
    my $arg = shift;
    if ( $arg =~ /-h/ ) {    # print help
      usage();
    } elsif ( $arg =~ /-v/ ) {    # print version
      version();
    } elsif ( $arg =~ /-f/ ) {    # get file to read from
      $readfile = shift;
      if ( !-r $readfile ) {
        print "file not found or unreadable: $readfile\n";
        exit 1;
      }
    } elsif ( $arg =~ /-a/ ) {    # get database login file
      $accountfile = shift;
      if ( !-r $accountfile ) {
        print "file not found or unreadable: $accountfile\n";
        exit 1;
      }
    } elsif ( $arg =~ /-d/ ) {    # get debug flag
      $debug = 1;
    } elsif ( $arg =~ /-i/ ) {    # get debug flag
      if ( defined($sitearg) ) {
        print STDERR "only one -i site allowed!\n";
        &usage;
      }
      $sitearg = shift;
    } elsif ( $arg =~ /-u/ ) {    # get hdb user
      $hdbuser = shift;
    } elsif ( $arg =~ /-p/ ) {    # get hdb passwd
      $hdbpass = shift;
    } elsif ( $arg =~ /-.*/ ) {    # Unrecognized flag, print help.
      print STDERR "Unrecognized flag: $arg\n";
      &usage;
    } else {
      print STDERR "Unrecognized command line argument: $arg\n";
      &usage;
    }
  }

  if ( defined($readfile) and !defined($sitearg) )
  {
    print STDERR "Error: Must specify site when reading file!\n";
    usage();
  }
  
  if ( !defined($accountfile)
       and ( !defined($hdbuser) || !defined($hdbpass) ) )
  {
    print STDERR
      "ERROR: Required: accountfile (-a) or HDB username and password(-u -p)\n";
    usage();
  }

  return;
}

# Perl trim function to remove whitespace from the start and end of the string
sub trim($)
{
	my $string = shift;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}

sub usage {
  print STDERR <<"ENDHELP";
$progname $verstring [ -h | -v ] | [ options ]
Script to retrieve USGS ratings files from USGS website
Example: $progname -a <accountfile> 

  -h               : This help
  -v               : Version
  -a <accountfile> : HDB account access file (REQUIRED or both below)
  -u <hdbusername> : HDB application user name (account file or REQUIRED)
  -p <hdbpassword> : HDB password (account file or REQUIRED)
  -d               : Debugging output
  -f <filename>    : File to read from
  -i <ibwcno>      : Get rating for one site (REQUIRED when using -f)
ENDHELP

  exit(1);
}

sub version {
  print "$progname version $verstring\n";
  exit 1;
}

sub main {

  #parse arguments
  my $mode = process_args(@ARGV);    # uses globals, bad!

  #HDB database interface
  my $hdb = Hdb->new;

  #connect to database
  if ( defined($accountfile) ) {
    $hdb->connect_from_file($accountfile);
  } else {
    my $dbname;
    if ( !defined( $dbname = $ENV{HDB_LOCAL} ) ) {
      $hdb->hdbdie("Environment variable HDB_LOCAL not set...\n");
    }

    #create connection to database
    $hdb->connect_to_db( $dbname, $hdbuser, $hdbpass );
  }
  my $sites;
  if ($sitearg) {
    $sites->[0] = $sitearg;
  } else {
    $sites = read_usgs_sites ($hdb);
  }

  process_usgs_sites ($hdb, $sites) ;
}
