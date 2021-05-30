20 00 * * * csh -c "source ~lchdba/.cshrc; cd /wrg/hdb/HDB_applications/scripts; ./DailyOps.sh" > /wrg/hdb/HDB_applications/log/dailyops.log

# DailyOps.sh
sqlplus lchdba/river555 @/wrg/hdb/HDB_applications/scripts/daily_ops.sql



spool daily_ops.out

 execute hdb_utilities.daily_ops;
 execute snapshot_manager.perfrom_refresh('%');

commit;
spool off

exit;

BEGIN

  UTL_MAIL.send(sender     => 'mbogner@ecahdb2.bor.doi.net',
                recipients => 'mbogner@sutron.com',
                subject    => 'Test UTL_MAIL.SEND Procedure',
               message    => 'If you are reading this it worked!');


END;

ORA-24247: network access denied by access control list (ACL)

BEGIN   
DBMS_NETWORK_ACL_ADMIN.CREATE_ACL (     acl          => 'mail_access.xml',
description  => 'Permissions to access e-mail server.',
principal    => 'PUBLIC',     is_grant     => TRUE,
privilege    => 'connect');
COMMIT; 
END;

BEGIN   
DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL (     acl          => 'mail_access.xml',
host         => 'localhost',
lower_port   => 25,
upper_port   => 25     );
COMMIT;
END; 


alter role APP_ROLE not identified;

BEGIN
  DBMS_NETWORK_ACL_ADMIN.create_acl (
    acl          => 'oraclemail.xml', 
    description  => 'ACL for ORACLE MAIL',
    principal    => 'APP_ROLE',
    is_grant     => TRUE, 
    privilege    => 'connect',
    start_date   => SYSTIMESTAMP,
    end_date     => NULL);

  COMMIT;
END;

BEGIN
   DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL (
    acl          => 'oraclemail.xml',                
    host         => 'localhost');
   COMMIT;

END;


BEGIN
  DBMS_NETWORK_ACL_ADMIN.add_privilege ( 
    acl         => 'oraclemail.xml', 
    principal   => 'LCHDBA',
    is_grant    => TRUE, 
    privilege   => 'connect', 
    position    => NULL, 
    start_date  => NULL,
    end_date    => NULL);

  COMMIT;
END;
/

select min(rating_id),count(*)
from ref_site_rating
where rating_type_common_name = 'Elevation Volume'
and indep_site_datatype_id = 2100
and sysdate between
      nvl(effective_start_date_time, to_date(1,'J'))
 and  nvl(effective_end_date_time, sysdate+365000);
 
 --@d:\phase3.1\ratings_pkg.spb

select ratings.find_site_rating('Elevation Volume',2100,sysdate) from dual;