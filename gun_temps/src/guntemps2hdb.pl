#!/usr/local/bin/perl -w

use Date::Calc qw(:all);
use DBI;
#use DBD::Oracle;

my ($dbh, @cur_sdi, @value_date, @data_date);

my($psswd_dbh);

sub mydie {
  $dbh->disconnect;
  die @_;
}

sub passdie {
    $psswd_dbh->disconnect;
    die @_;
}
    
#sites and datatypes desired. Not all site_ids and site_datatype_ids
# have been created, yet.

%siteid_hash = ('PARK CONE           ', 28, "IDARADO             ", 133, 
		"BUTTE               ", 22, "SCHOFIELD PASS      ", 32,
		"PORPHYRY CREEK      ", 30, "SLUMGULLION         ", 33,
		"BRUMLEY             ", 1064, "NORTH LOST TRAIL    ", 72);

%datatype_hash = ("max temp", 9, "ave temp", 8, "min temp", 11,
		  "precip total", 5, "total wy precip", 72);

%site_datatype_hash = ("max temp", undef, "ave temp", undef, "min temp", undef,
		       "precip total", undef, "total wy precip", undef);

%value_hash = ("max temp", undef, "ave temp", undef, "min temp", undef,
		       "precip total", undef, "total wy precip", undef);

#check to see command line usage.
if (scalar(@ARGV) <3)
  {
    my $progname = `basename $0`;
    chop $progname;
    print "$progname -- program to put gunnison climate data into HDB.\n";
    print "Usage: $progname <filename> <hdbusername> <hdbpassword>\n";
    exit (1);

  }

#create connection to database
connect_to_db($ARGV[1], $ARGV[2]);

#$statement = "select * from hdb_data_source ";

$get_site_datatype_statement = "select site_datatype_id from hdb_site_datatype where site_id = ? and datatype_id = ? ";

$insert_data_statement = "insert into r_day values(?,?,?,2,'Z') ";

$update_data_statement = "update r_day SET (value) = ( ?) where (site_datatype_id = ? and date_day = ?) ";

$check_data_statement = "select value from r_day where date_day = ? and site_datatype_id = ? ";

$find_data_statement = "select a.value from r_day a where
a.site_datatype_id = ? and
a.date_day = (select max(date_day) from r_day a where
a.site_datatype_id = ? and
a.date_day < ? )
";

#input file is opened 4 different times.
# get date on input file
open (INFILE, "$ARGV[0]") || mydie "Error: couldn't open input file $ARGV[0]";
# skip past opening junk
for ($i = 0; $i < 6; $i++)
  { $line = <INFILE>; }

# get date of data
$line = <INFILE>;
$datestr = substr $line, 33, 8;

(@data_date = Decode_Date_US($datestr)) ||
  die "There was an error parsing the date in the datafile!.\n";

print "@data_date\n";

#skip past header
for ($i = 0; $i < 6; $i++)
  { $line = <INFILE>; }

READ: while ($line = <INFILE>)
{
  chomp($line);
  #end data if line is really short, or contains 78 dashes ('-')
  last READ if (length($line) < 5 || $line =~ m/-{78}/) ;

  #check to see if the site changed
  $cur_site_name = substr $line, 0, 20;
  if ($cur_site_name =~ /\S/g)
    { # if so, go get new site datatype ids
      $site_id = $siteid_hash{$cur_site_name};
      get_SDI($site_id)      if $site_id;
    }
#chop out the pieces of the line that are interesting, date, precip,
# and 3 temperatures, max, min, and average
  $monthdaystr = substr $line, 22, 5;
  $value_hash{"total wy precip"} = substr $line, 44, 6;
  $value_hash{"max temp"}        = substr $line, 61, 6;
  $value_hash{"min temp"}        = substr $line, 67, 6;
  $value_hash{"ave temp"}        = substr $line, 73, 6;

  $value_hash{"total wy precip"} =~ s/\s//g;
  $value_hash{"max temp"} =~ s/\s//g;
  $value_hash{"min temp"} =~ s/\s//g;
  $value_hash{"ave temp"} =~ s/\s//g;

  $value_date[1] = substr $monthdaystr, 0, 2;
  $value_date[2] = substr $monthdaystr, 3, 2;

#handle finding year value, if value is for a month after the date on the
#file, the year for the value is the previous year
  if ($value_date[1] > $data_date[1]) {
    $value_date[0] = $data_date[0] - 1;
  }
  else {
    $value_date[0] = $data_date[0];
  }

# fix the fact that the data is reported for the next day!
  @value_date = Add_Delta_Days(@value_date, -1);

  if ($value_hash{"total wy precip"} == -99.9 ) {
    $value_hash{"total wy precip"} = undef;
  }
  if ($value_hash{"max temp"} == -99.9 ) {
    $value_hash{"max temp"} = undef;
  }
  if ($value_hash{"min temp"} == -99.9 ) {
    $value_hash{"min temp"} = undef;
  }
  if ($value_hash{"ave temp"} == -99.9 ) {
    $value_hash{"ave temp"} = undef;
  }

  if ($site_id) {
    insert_values(@value_date);
  }
}

$dbh->disconnect();

#End main program, subroutines below

sub check_value
  {
    my($check_date)=$_[0];
    my($site_datatype_id)=$_[1];
    my($sth);
    my($myval);

    $sth = $dbh->prepare($check_data_statement) || mydie $sth->errstr;
    $sth->bind_param(1,$check_date);
    $sth->bind_param(2,$site_datatype_id);
    $sth->execute || mydie $sth->errstr;
    $sth->bind_col(1,\$myval);
    $sth->fetch;
#    DBI::dump_results($sth)|| mydie $DBI::errstr;;
    $sth->finish();
#    print $myval;
    return $myval;
  }

sub last_value
{
    my($prev_date) = $_[0];
    my($site_datatype_id)=$_[1];
    my($myval);

    my($sth);
    $sth = $dbh->prepare($find_data_statement) || mydie $sth->errstr;

    $sth->bind_param(1,$site_datatype_id);
    $sth->bind_param(2,$prev_date);
    $sth->bind_param(3,$site_datatype_id);
    $sth->execute || mydie $sth->errstr;
    $sth->bind_col(1,\$myval);
    $sth->fetch;
#    DBI::dump_results($sth)|| mydie $DBI::errstr;;
    $sth->finish();
#    print $myval;
    return $myval;
}

sub insert_values
  {
    my(@value_date) = @_[0,1,2];
    my($cum_precip) = $value_hash{"total wy precip"};

    my($insth, $upsth);
    my($day_precip) = undef;
#    print @_;

    $datestr = sprintf("%02d-%.3s-%4d",$value_date[2],
			   Month_to_Text($value_date[1]), $value_date[0]); 

    eval {
      $insth = $dbh->prepare($insert_data_statement) || mydie $insth->errstr;
      $upsth = $dbh->prepare($update_data_statement) || mydie $upsth->errstr;
      
# do precip, if the data are listed from 10/01 ( cumulative till midnight of 9/30), the cumulative counter resets.
      if ($value_date[1] == 9 && $value_date[2] == 30) {
	$day_precip = $cum_precip;
      }
      else {
	my @prev_date =  Add_Delta_Days(@value_date, -1);
	my $prevdatestr = sprintf("%02d-%.3s-%4d",$prev_date[2],
			   Month_to_Text($prev_date[1]), $prev_date[0]); 
	my $prev_cum_precip = check_value($prevdatestr,
				       $site_datatype_hash{"total wy precip"});
	#assume data is coming in order of date, earlier first.
	#if prev data is not there, set day's to undef, won't insert
	if (!defined($cum_precip)) {
	} elsif (!defined($prev_cum_precip)) {
	  $prev_cum_precip = last_value($prevdatestr,
				 $site_datatype_hash{"total wy precip"});
	  if (!defined($prev_cum_precip)) {
	    $day_precip = undef; #still can not find it.
	  } else {
	    $day_precip = sprintf("%.1f",$cum_precip - $prev_cum_precip);
	  }
	} else {
	  $day_precip = sprintf("%.1f",$cum_precip - $prev_cum_precip);
	  $day_precip = 0 if $day_precip < 0 ;
	}
      }
      # add one more value to the end of the values array to represent the
      # day's precip
      $value_hash{"precip total"} = $day_precip;

# insert data;
      foreach $datatype ( keys %site_datatype_hash )
	{
	  undef $old_val;
# skip butte max temps, because they are broken. UG. ME HACK.
          next if $site_datatype_hash{$datatype} == 884;
	  $old_val = check_value($datestr, $site_datatype_hash{$datatype});
	  if (!defined $value_hash{$datatype}) {
	    #delete data if data is -99.9, otherwise do nothing.
	    if ($old_val && $old_val == -99.9) {
	      print "deleting bad data for $site_datatype_hash{$datatype}, date $datestr, value undefined, old_val = $old_val\n";
	      $dbh->do("delete from r_day where site_datatype_id = $site_datatype_hash{$datatype} and date_day = '$datestr'")|| mydie DBI::errstr;
	    }
	  }
	  elsif (!defined($old_val)) {
	    print "inserting for $site_datatype_hash{$datatype}, date $datestr, value $value_hash{$datatype}, old_val = undefined\n";
	    
	    $insth->bind_param(1,$site_datatype_hash{$datatype});
	    $insth->bind_param(2,$datestr);
	    $insth->bind_param(3,$value_hash{$datatype});
	    $insth->execute|| mydie $insth->errstr;
	  }
	  elsif ($old_val == $value_hash{$datatype}) {
	    next;
	  }
	  elsif ($old_val != $value_hash{$datatype}) {
	    print "updating for $site_datatype_hash{$datatype}, date $datestr, value $value_hash{$datatype}, old_val = $old_val\n";
	    #update instead of insert
	    $upsth->bind_param(1,$value_hash{$datatype});
	    $upsth->bind_param(2,$site_datatype_hash{$datatype});
	    $upsth->bind_param(3,$datestr);
	    $upsth->execute|| mydie $upsth->errstr;
	  }
	}
      
      $upsth->finish;
      $insth->finish;
    };
    if ($@) {
      $dbh->rollback;
      print "$DBI::errstr, $@\n";
      mydie "Errors occurred during insert/update/deletion of data. Rolled back any database manipulation.";
    }
    else {
      $dbh->commit;
    }
}


sub get_SDI
  {
    $cur_site= $_[0];
    $sth = $dbh->prepare($get_site_datatype_statement) || mydie $sth->errstr;
    $sth->bind_param(1,$cur_site);

    foreach $datatype (keys %datatype_hash) 
      {
	$sth->bind_param(2,$datatype_hash{$datatype});
	$sth->execute|| mydie $sth->errstr;
	$sth->bind_col(1,\$site_datatype_hash{$datatype});
#should check here if there are any rows. if not, no SDI exists for this combo.
	$sth->fetch;
      }
    
    $sth->finish;
  }

# HDB does something interesting with the app_user 
# app_user has the permission to insert into the database, but only
# if the app_role is enabled, which is not by default
# the applications get around this by connecting to the database as 
# psswd_user (from the environment) and getting the password to 
# turn on this role, and then connecting as app_user and 
# enabling this role.
# This code does that, while also taking the name of the database
# from the environment, and the app_user name and password from the
# command line
sub connect_to_db
  {
    my $user=$_[0];
    my $pass=$_[1];
    my $approlepass;

    if (!defined($psswduser = $ENV{PSSWD_USER})) {
      die "Environment variable PSSWD_USER not set...\n";
    }
    if (!defined($dbname = $ENV{HDB_LOCAL})) {
      die "Environment variable HDB_LOCAL not set...\n";
    }
    if (!defined($approle = $ENV{APP_ROLE})) {
      die "Environment variable APP_ROLE not set...\n";
    }

# create connections, exceptions on error, no autocommit

    $psswd_dbh = DBI->connect("dbi:Oracle:$dbname", $psswduser, $dbname,
			{ RaiseError => 1, AutoCommit => 0 })|| mydie $DBI::errstr;
    $psswd_statement = "select psswd from role_psswd where UPPER(ROLE) = UPPER('$approle')";

    $psswdsth = $psswd_dbh->prepare($psswd_statement) || passdie $psswdsth->errstr;
    $psswdsth->execute || passdie $psswdsth->errstr;
    $psswdsth->bind_col(1,\$approlepass);
    $psswdsth->fetch;
    $psswdsth->finish;
    $psswd_dbh->disconnect;

    $dbh = DBI->connect("dbi:Oracle:$dbname", $user, $pass,
			{ RaiseError => 1, AutoCommit => 0 })|| mydie $DBI::errstr;

    $dbh->do("set role $approle identified by $approlepass")|| mydie $DBI::errstr;
  }
