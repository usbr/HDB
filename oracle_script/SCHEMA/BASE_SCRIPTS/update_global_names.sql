set echo on
spool hdb_global_names_update.out

update ref_db_parameter set global_name = (select global_name from global_name);
commit;

spool off
exit;

