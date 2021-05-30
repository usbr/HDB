set echo on
set feedback on
spool local_user.out

/* Tom */
/* create user tom identified by tom */
/* default tablespace HDB_user quota unlimited on HDB_user */
/* temporary tablespace HDB_temp quota unlimited on HDB_temp; */

/* grant connect to tom; */
/* grant savoir_faire to tom; */
/* grant app_role to tom; */
/* grant hdb_meta_role to tom; */
/* grant ref_meta_role to tom; */
/* grant model_role to tom; */
/* alter user tom */
/* default role connect, savoir_faire; */

/* read only */
/* create user coroneos identified by coroneos */
/* default tablespace HDB_user quota unlimited on HDB_user */
/* temporary tablespace HDB_temp quota unlimited on HDB_temp; */
/* grant connect to coroneos; */


spool off

exit;

