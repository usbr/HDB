set echo on
spool additional_db_mods.out

update DECODES.datatype set standard='HDB' where standard = 'hdb';
commit;

-- do the daily_ops procedure to update the DECODES.datatypes
  execute hdb_utilities.daily_ops;

commit;

spool off
exit;

