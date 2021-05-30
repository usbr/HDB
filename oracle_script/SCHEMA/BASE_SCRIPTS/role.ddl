set echo on
set feedback on
spool hdb_roles.out

-- ALL ROLE PASSWORDS REMOVED By M. Bogner SUtron Corporation
-- June 2011 due to issues passworded roles have with ORACLE 11g
--create role app_role            identified by PASSWD;
-- create role derivation_role     identified by PASSWD;  removed by CP project
--create role hdb_meta_role       identified by PASSWD;
--create role ref_meta_role       identified by PASSWD;
--create role monthly             identified by PASSWD;   
--create role savoir_faire        identified by PASSWD;
--create role model_priv_role     identified by PASSWD;

create role app_role;
-- create role derivation_role
create role hdb_meta_role;
create role ref_meta_role;
create role monthly;
create role savoir_faire;
create role model_priv_role;

-- new roles for computation processor
create role decodes_role;
grant decodes_role to ref_meta_role;
grant app_role to decodes_role;

create role calc_definition_role;

spool off
exit;
