set echo off
set heading off
set feedback off
set pagesize 0
set linesize 120
set verify off

spool ./recompile_script.sql
select distinct 'ALTER  '|| object_type || ' ' || object_name || ' compile;'
from user_objects where object_type in ('FUNCTION','PROCEDURE','PACKAGE')
and status <> 'VALID'
/
 
spool off;

set echo on
set feedback on
spool hdb_recompiles.out

@./recompile_script.sql

spool off
exit;
