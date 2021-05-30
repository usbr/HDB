set echo on
set feedback on
spool create_app_user.out

--drop user app_user;

create user app_user identified by &1
default tablespace HDB_user quota unlimited on HDB_user
temporary tablespace HDB_temp;

grant create session to app_user;
grant app_role to app_user;
grant ref_meta_role to app_user;
grant hdb_meta_role to app_user;
grant model_priv_role to app_user;

alter user app_user default role none;
/* supposidely removed by C.  Marra during Model Run Project
grant model_role to app_user;
*/
/* removed for CP project
grant derivation_role to app_user;
*/

spool off

exit;
