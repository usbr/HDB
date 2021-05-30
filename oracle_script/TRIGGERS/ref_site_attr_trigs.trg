-- install the triggers to:
-- set the effective_start_date_time and check attr value type
-- load a row to ref_site_attr_archive
-- 10/02/01
--

  CREATE OR REPLACE TRIGGER REF_SITE_ATTR_DT_LOAD_CHK_VAL
  BEFORE INSERT OR UPDATE ON REF_SITE_ATTR
  REFERENCING FOR EACH ROW
  DECLARE
temp_num NUMBER;
begin
     check_valid_attr_value(:new.attr_id, :new.value, :new.string_value, :new.date_value);
     :new.date_time_loaded := SYSDATE;

    /* Added by M.  Bogner 10/01/11 for ACL II project */

    /*
    the purpose of this part of the trigger is to make sure that the user has permissions
    to modify this table since only DBA or DBA ACLII people can modify this table if ACL
    VERSION II is an active feature
    */

	/* see if ACL PROJECT II is enabled and if this is a group attribute if user is permitted */
	IF (hdb_utilities.is_feature_activated('ACCESS CONTROL LIST GROUP VERSION II') = 'Y'
	    AND hdb_utilities.GET_SITE_ACL_ATTR = :new.attr_id ) THEN
	  begin
	    temp_num := 0;
		/* see if user account is an active DBA or ACLII ACCOUNT */
		select count(*) into temp_num  from ref_user_groups
		where user_name = user and group_name in ('DBA','DBA ACLII');
		exception when others then
--		DENY_ACTION(SQLERRM);
		temp_num := -1;
	  end;

	  IF (temp_num < 1) THEN
		DENY_ACTION('ILLEGAL ACL VERSION II REF_SITE_ATTR DATABASE OPERATION -- No Permissions');
	  END IF;

	END IF;

end;
/
show errors trigger ref_site_attr_dt_load_chk_val;


create or replace trigger ref_site_attr_arch_update
after update on ref_site_attr
REFERENCING NEW AS NEW OLD AS OLD
for each row
begin
  insert into ref_site_attr_archive
   (site_id,
    attr_id,
    effective_start_date_time,
    effective_end_date_time,
    value,
    string_value,
    date_value,
    date_time_loaded,
    archive_reason,
    date_time_archived,
    archive_cmmnt)
  values
   (:old.site_id,
    :old.attr_id,
    :old.effective_start_date_time,
    :old.effective_end_date_time,
    :old.value,
    :old.string_value,
    :old.date_value,
    :old.date_time_loaded,
     'UPDATE',
     sysdate,
    NULL);
end;
/
show errors trigger ref_site_attr_arch_update;

  CREATE OR REPLACE TRIGGER REF_SITE_ATTR_ARCH_DELETE
  AFTER DELETE ON REF_SITE_ATTR
  REFERENCING FOR EACH ROW
  DECLARE
temp_num NUMBER;
begin

    /* Added by M.  Bogner 10/01/11 for ACL II project */

    /*
    the purpose of this part of the trigger is to make sure that the user has permissions
    to modify this table since only DBA or DBA ACLII people can modify this table if ACL
    VERSION II is an active feature
    */

	/* see if ACL PROJECT II is enabled and if this is a group attribute if user is permitted */
	IF (hdb_utilities.is_feature_activated('ACCESS CONTROL LIST GROUP VERSION II') = 'Y'
	    AND hdb_utilities.GET_SITE_ACL_ATTR = :old.attr_id ) THEN
	  begin
	    temp_num := 0;
		/* see if user account is an active DBA or ACLII ACCOUNT */
		select count(*) into temp_num  from ref_user_groups
		where user_name = user and group_name in ('DBA','DBA ACLII');
		exception when others then
--		DENY_ACTION(SQLERRM);
		temp_num := -1;
	  end;

	  IF (temp_num < 1) THEN
		DENY_ACTION('ILLEGAL ACL VERSION II REF_SITE_ATTR DATABASE OPERATION -- No Permissions');
	  END IF;

	END IF;

/* now if the delete was allowed; then archive the old data  */

  insert into ref_site_attr_archive
   (site_id,
    attr_id,
    effective_start_date_time,
    effective_end_date_time,
    value,
    string_value,
    date_value,
    date_time_loaded,
    archive_reason,
    date_time_archived,
    archive_cmmnt)
  values
   (:old.site_id,
    :old.attr_id,
    :old.effective_start_date_time,
    :old.effective_end_date_time,
    :old.value,
    :old.string_value,
    :old.date_value,
    :old.date_time_loaded,
    'DELETE',
     sysdate,
    NULL);
end;
/
show errors trigger ref_site_attr_arch_delete;


