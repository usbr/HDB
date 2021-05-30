set echo on
set feedback on
spool hdb_users.out
-- DBA was granted to the HDBDBA for 11i compatibility and to ease the # of scripts that needed modified
-- sysdba granting was done by M. Bogner, Sutron Corporation 03-June-2011

create user DBA identified by PASSWD
default tablespace HDB_data quota unlimited on HDB_data
quota unlimited on HDB_idx
temporary tablespace HDB_temp;
grant sysdba to DBA;
grant dba to DBA;
grant savoir_faire to DBA;
grant create session to DBA;
grant connect  to DBA;
alter user DBA default role all;

create user decodes identified by decodes
default tablespace HDB_data quota unlimited on HDB_data
quota unlimited on HDB_idx
temporary tablespace HDB_temp;

grant decodes_role to decodes;
grant create session to decodes;
grant resource to decodes;
grant connect  to decodes;
grant dba  to decodes;
alter user decodes default role all;

create user cp_process identified by cp_process
default tablespace HDB_user quota 5M on HDB_user
temporary tablespace HDB_temp;
grant create session to cp_process;
grant connect  to cp_process;
grant app_role to cp_process;
grant decodes_role to cp_process;
grant calc_definition_role to cp_process;
alter user cp_process default role app_role,decodes_role,calc_definition_role;

spool off
exit;

