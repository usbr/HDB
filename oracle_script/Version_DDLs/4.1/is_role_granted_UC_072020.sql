create or replace FUNCTION IS_ROLE_GRANTED 
(
  ROLE_NAME IN VARCHAR2 
) RETURN BOOLEAN AS 
/*
   Replacement for the now-broken behavior of DBMS_SESSION.Is_Role_Enabled
   Per Oracle 12cR2 docs: "All roles are disabled in any named PL/SQL block that executes with definer's rights."
https://docs.oracle.com/en/database/oracle/oracle-database/12.2/dbseg/configuring-privilege-and-role-authorization.html#GUID-5C57B842-AF82-4462-88E9-5E9E8FD59874
   We can only check that the current user is granted the specified role as default, we cannot check if they have the role
   actually enabled!

    Written February 24, 2018 by Andrew Gilmore
*/
    is_valid_role   NUMBER;
BEGIN
    BEGIN
    SELECT
        COUNT(*)
    INTO        is_valid_role
    FROM        user_role_privs
    WHERE       default_role = 'YES'
        AND   granted_role IN (ROLE_NAME);
   return is_valid_role>0;
   EXCEPTION WHEN OTHERS THEN RETURN FALSE;  
   END;
END IS_ROLE_GRANTED;
/

create or replace procedure check_sdi_auth (sdi number)
IS
cur_site number;
cursor c1 (c_site NUMBER) is
    select role from ref_auth_site where site_id = c_site;
cursor c2 (c_sdi NUMBER) is
    select role from ref_auth_site_datatype where site_datatype_id = c_sdi;
result VARCHAR2(24);
BEGIN
    select site_id INTO cur_site FROM hdb_site_datatype
    where site_datatype_id = sdi;
    if (is_role_granted ('APP_ROLE')) then
        return;
    end if;
    if (is_role_granted ('SAVOIR_FAIRE')) then
        return;
    end if;
    for role_record IN c1(cur_site) LOOP
        result := role_record.role;
        if (is_role_granted (rtrim(result))) then
            return;
        end if;
    end LOOP;
    for role_record IN c2(sdi) LOOP
        result := role_record.role;
        if (is_role_granted (rtrim(result))) then
            return;
        end if;
    end LOOP;
    raise_application_error(-20001,'Error: Could not select from ref_auth_site_datatype with site_datatype_id = ' || sdi);
END;
/

create or replace procedure check_sdi_auth_with_site (sdi number, cur_site number)
IS
cursor c1 (c_site NUMBER) is
    select role from ref_auth_site where site_id = c_site;
cursor c2 (c_sdi NUMBER) is
    select role from ref_auth_site_datatype where site_datatype_id = c_sdi;
result VARCHAR2(24);
BEGIN
    if (is_role_granted ('APP_ROLE')) then
        return;
    end if;
    if (is_role_granted ('SAVOIR_FAIRE')) then
        return;
    end if;
    for role_record IN c1(cur_site) LOOP
        result := role_record.role;
        if (is_role_granted (rtrim(result))) then
            return;
        end if;
    end LOOP;
    for role_record IN c2(sdi) LOOP
        result := role_record.role;
        if (is_role_granted (rtrim(result))) then
            return;
        end if;
    end LOOP;
    raise_application_error(-20001,'Error: Could not select from ref_auth_site_datatype with site_datatype_id = ' || sdi);
END;
/

create or replace procedure check_site_id_auth (cur_site number,
	the_user VARCHAR2, the_app_user VARCHAR2)
IS
cursor c1 (c_site NUMBER) is
    select role from ref_auth_site where site_id = c_site;

result VARCHAR2(24);
is_valid_role NUMBER;
BEGIN
    if (is_role_granted ('APP_ROLE') OR
	is_role_granted ('SAVOIR_FAIRE')) then
        return;
    end if;

    for role_record IN c1(cur_site) LOOP
        result := role_record.role;

	if (the_user = 'APEX_PUBLIC_USER') then
	  select count(*)
	  into is_valid_role
	  from dba_role_privs
	  where grantee = the_app_user
	    and granted_role = result
            and default_role = 'YES';

  	  /* the user logged into APEX has permissions */
 	  if (is_valid_role > 0) then
	    return;
	  end if;
	else
  	  /* the user connected to the db has permissions;
	     could use the check from above, but this is a bit
	     better as it checks for what is active, not just granted */
          if (is_role_granted (rtrim(result))) then
              return;
          end if;
        end if;
    end LOOP;
    raise_application_error(-20001, 'Permission Failure: User '||the_app_user||' does not have role permissions to modify values for site_id = ' || cur_site);
END;
/

create or replace TRIGGER combined_ref_div_chk
after             insert or update
on                ref_div
for   each row

declare
  the_user varchar2(30);
  the_app_user varchar2(30);
  is_valid_role NUMBER;

begin
     check_valid_site_objtype ('div', :new.site_id);

     the_user := USER;
     if (the_user = 'APEX_PUBLIC_USER') then
       the_app_user := nvl(v('APP_USER'),USER);

       select count(*)
       into is_valid_role
       from dba_role_privs
       where grantee = the_app_user
	 and default_role = 'YES'
	 and granted_role in ('SAVOIR_FAIRE','REF_META_ROLE');
     else
	the_app_user := the_user;

   	if not (is_role_granted ('SAVOIR_FAIRE')
              OR is_role_granted ('REF_META_ROLE')) then
    	     is_valid_role := 0;
	  else
	     is_valid_role := 1;
	  end if;
     end if;

     if not (is_valid_role > 0) then
	   check_site_id_auth (:new.site_id, the_user, the_app_user);
     end if;
end;
/

create or replace TRIGGER combined_ref_res_chk
after             insert or update
on                ref_res
for   each row

declare
  the_user varchar2(30);
  the_app_user varchar2(30);
  is_valid_role NUMBER;

begin
     check_valid_site_objtype ('res', :new.site_id);

     the_user := USER;
     if (the_user = 'APEX_PUBLIC_USER') then
       the_app_user := nvl(v('APP_USER'),USER);

       select count(*)
       into is_valid_role
       from dba_role_privs
       where grantee = the_app_user
	 and default_role = 'YES'
	 and granted_role in ('SAVOIR_FAIRE','REF_META_ROLE');
     else
	the_app_user := the_user;

   	if not (is_role_granted ('SAVOIR_FAIRE')
              OR is_role_granted ('REF_META_ROLE')) then
    	     is_valid_role := 0;
	  else
	     is_valid_role := 1;
	  end if;
     end if;

     if not (is_valid_role > 0) then
	   check_site_id_auth (:new.site_id, the_user, the_app_user);
     end if;
end;
/

create or replace TRIGGER combined_ref_str_chk
after             insert or update
on                ref_str
for   each row

declare
  the_user varchar2(30);
  the_app_user varchar2(30);
  is_valid_role NUMBER;

begin
     check_valid_site_objtype ('str', :new.site_id);

     the_user := USER;
     if (the_user = 'APEX_PUBLIC_USER') then
       the_app_user := nvl(v('APP_USER'),USER);

       select count(*)
       into is_valid_role
       from dba_role_privs
       where grantee = the_app_user
	 and default_role = 'YES'
	 and granted_role in ('SAVOIR_FAIRE','REF_META_ROLE');
     else
	the_app_user := the_user;

   	if not (is_role_granted ('SAVOIR_FAIRE')
              OR is_role_granted ('REF_META_ROLE')) then
    	     is_valid_role := 0;
	  else
	     is_valid_role := 1;
	  end if;
     end if;

     if not (is_valid_role > 0) then
	   check_site_id_auth (:new.site_id, the_user, the_app_user);
     end if;
end;
/

create or replace TRIGGER hdb_site_site_perm
after             insert OR update OR delete
on                hdb_site
for   each row
declare
  the_user varchar2(30);
  the_app_user varchar2(30);
  is_valid_role NUMBER;
begin
     the_user := USER;
     if (the_user = 'APEX_PUBLIC_USER') then
       the_app_user := nvl(v('APP_USER'),USER);

       select count(*)
       into is_valid_role
       from dba_role_privs
       where grantee = the_app_user
	 and default_role = 'YES'
	 and granted_role in ('SAVOIR_FAIRE','HDB_META_ROLE');
     else
	the_app_user := the_user;
        if not (is_role_granted ('SAVOIR_FAIRE')
             OR is_role_granted ('HDB_META_ROLE')) then
    	  is_valid_role := 0;
	else
	  is_valid_role := 1;
	end if;
     end if;

--     raise_application_error (-20001,'THE USER: '|| the_user||'APP_USER: '||the_app_user||'ROLE VALID '||is_valid_role);

     if not (is_valid_role > 0) then
	   check_site_id_auth (:new.site_id, the_user, the_app_user);
     end if;
     
     /* populate the ref_db_generic_list table for the snapshot_manager  */
     /* added by M. Bogner April 2013  */
     snapshot_manager.snapshot_modified('HDB_SITE');
end;
/

create or replace TRIGGER r_base_before_delete
before delete on r_base
for each row
declare
  v_count            number;
begin

   if not (is_role_granted ('SAVOIR_FAIRE')) then
      check_sdi_auth (:old.site_datatype_id);
   end if;

end;
/

create or replace TRIGGER r_base_before_insert_update
before insert or update
on r_base
for each row
declare
  v_count            number;
  v_source_entry     number;
  v_invalid_interval number;
  e_bad_row          exception;
  text               varchar2(200);
begin

   if not (is_role_granted ('SAVOIR_FAIRE')) then
      check_sdi_auth (:new.site_datatype_id);
   end if;

   if (trunc(:new.start_date_time) > trunc(SYSDATE + 2/24)  ) then
      text := 'No future dates allowed in r_base tables';
      deny_action(text);
   end if;

  if :new.validation in ('E','+','-','w','n','|','^','~',chr(32)) then
     :new.data_flags := :new.validation || substr(:new.data_flags,1,19);
     :new.validation := NULL;
  end if;


  /* logic below added to attempt to foil Stored Procedures non-utilization  */
  if :new.date_time_loaded <> to_date('10-DEC-1815','dd-MON-yyyy') then
    :new.validation := 'F';
    :new.data_flags := 'Bad Load: Use Proc.';
  end if;

  :new.date_time_loaded:=sysdate;

  /* Start and end date must be equal for instant data.
     Datatype's allowable intervals must be either or instant
     for instant data */
  if (:new.interval = 'instant') then

     if ( :new.start_date_time <> :new.end_date_time) then
        text := 'Instant interval start and end date times must be equal';
        deny_action(text);
     end if;

     select count(*) into v_count
     from hdb_datatype dt, hdb_site_datatype sd
     where dt.allowable_intervals in ('instant','either')
       and sd.site_datatype_id = :new.site_datatype_id
       and sd.datatype_id = dt.datatype_id;

     if (v_count = 0) then
        text := 'Invalid Interval for this datatype';
        deny_action(text);
     end if;

  end if;

  /* Start date must be < end date for non-instant data.
     Datatype's allowable intervals must be either or non-instant
     for non-instant data */
  if (:new.interval <> 'instant') then

     if ( :new.start_date_time > :new.end_date_time) then
        text := 'Non-instant interval start date time must be less than the end date time';
        deny_action(text);
     end if;
     if ( :new.start_date_time = :new.end_date_time) then
        text := 'Non-instant interval start and end date times cannot be equal';
        deny_action(text);
     end if;

     select count(*) into v_count
     from hdb_datatype dt, hdb_site_datatype sd
     where dt.allowable_intervals in ('non-instant','either')
       and sd.site_datatype_id = :new.site_datatype_id
       and sd.datatype_id = dt.datatype_id;

     if (v_count = 0) then
        text := 'Invalid Interval for this datatype';
        deny_action(text);
     end if;

  end if;

  /* Validate record's agen_id against the datatype's agen_id
     (if there is one). */
  select count(*) into v_count
  from hdb_datatype dt, hdb_site_datatype sd
  where dt.agen_id is not null
    and sd.site_datatype_id = :new.site_datatype_id
    and sd.datatype_id = dt.datatype_id;

  if (v_count > 0) then
    select count(*) into v_count
    from hdb_datatype dt, hdb_site_datatype sd
    where dt.agen_id = :new.agen_id
      and sd.site_datatype_id = :new.site_datatype_id
      and sd.datatype_id = dt.datatype_id;

    if (v_count = 0) then
       text := 'Invalid Agency for this datatype';
       deny_action(text);
    end if;

  end if;

--  now validate the record before it goes into the table
--  old logic for validation removed because of business rule that modify_r_base_RAW will be used always
--  if (INSERTING and nvl(:new.validation,'Z') in ('Z')) or UPDATING then
  if (nvl(:new.validation,'Z') in ('Z')) then
    hdb_utilities.validate_r_base_record
      (:new.site_datatype_id,
       :new.interval,
       :new.start_date_time,
       :new.value,
       :new.validation);
  end if;

end;
/

create or replace TRIGGER  r_daystat_sdi_perm
after             insert OR update OR delete
on                r_daystat
for   each row
begin
	if not (is_role_granted ('SAVOIR_FAIRE')) then
	   check_sdi_auth (:new.site_datatype_id);
	end if;
end;
/

create or replace TRIGGER  r_hourstat_sdi_perm
after             insert OR update OR delete
on                r_hourstat
for   each row
begin
	if not (is_role_granted ('SAVOIR_FAIRE')) then
	   check_sdi_auth (:new.site_datatype_id);
	end if;
end;
/

create or replace TRIGGER  r_monthstat_sdi_perm
after             insert OR update OR delete
on                r_monthstat
for   each row
begin
	if not (is_role_granted ('SAVOIR_FAIRE')) then
	   check_sdi_auth (:new.site_datatype_id);
	end if;
end;
/

create or replace TRIGGER  r_monthstatrange_sdi_perm
after             insert OR update OR delete
on                r_monthstatrange
for   each row
begin
	if not (is_role_granted ('SAVOIR_FAIRE')) then
	   check_sdi_auth (:new.site_datatype_id);
	end if;
end;
/

create or replace TRIGGER  r_wystat_sdi_perm
after             insert OR update OR delete
on                r_wystat
for   each row
begin
	if not (is_role_granted ('SAVOIR_FAIRE')) then
	   check_sdi_auth (:new.site_datatype_id);
	end if;
end;
/

create or replace TRIGGER  r_yearstat_sdi_perm
after             insert OR update OR delete
on                r_yearstat
for   each row
begin
	if not (is_role_granted ('SAVOIR_FAIRE')) then
	   check_sdi_auth (:new.site_datatype_id);
	end if;
end;
/

create or replace TRIGGER ref_res_flowlu_site_perm
after             insert or update or delete
on                ref_res_flowlu
for   each row

declare
  the_user varchar2(30);
  the_app_user varchar2(30);
  is_valid_role NUMBER;

begin
     the_user := USER;
     if (the_user = 'APEX_PUBLIC_USER') then
       the_app_user := nvl(v('APP_USER'),USER);

       select count(*)
       into is_valid_role
       from dba_role_privs
       where grantee = the_app_user
	 and default_role = 'YES'
	 and granted_role in ('SAVOIR_FAIRE','REF_META_ROLE');
     else
	the_app_user := the_user;

   	if not (is_role_granted ('SAVOIR_FAIRE')
              OR is_role_granted ('REF_META_ROLE')) then
    	     is_valid_role := 0;
	  else
	     is_valid_role := 1;
	  end if;
     end if;

     if not (is_valid_role > 0) then
	   check_site_id_auth (:new.site_id, the_user, the_app_user);
     end if;
end;
/

create or replace TRIGGER ref_res_wselu_site_perm
after             insert or update or delete
on                ref_res_wselu
for   each row

declare
  the_user varchar2(30);
  the_app_user varchar2(30);
  is_valid_role NUMBER;

begin
     the_user := USER;
     if (the_user = 'APEX_PUBLIC_USER') then
       the_app_user := nvl(v('APP_USER'),USER);

       select count(*)
       into is_valid_role
       from dba_role_privs
       where grantee = the_app_user
	 and default_role = 'YES'
	 and granted_role in ('SAVOIR_FAIRE','REF_META_ROLE');
     else
	the_app_user := the_user;

   	if not (is_role_granted ('SAVOIR_FAIRE')
              OR is_role_granted ('REF_META_ROLE')) then
    	     is_valid_role := 0;
	  else
	     is_valid_role := 1;
	  end if;
     end if;

     if not (is_valid_role > 0) then
	   check_site_id_auth (:new.site_id, the_user, the_app_user);
     end if;
end;
/

create or replace TRIGGER ref_site_coef_day_site_perm
after             insert or update or delete
on                ref_site_coef_day
for   each row

declare
  the_user varchar2(30);
  the_app_user varchar2(30);
  is_valid_role NUMBER;

begin
     the_user := USER;
     if (the_user = 'APEX_PUBLIC_USER') then
       the_app_user := nvl(v('APP_USER'),USER);

       select count(*)
       into is_valid_role
       from dba_role_privs
       where grantee = the_app_user
	 and default_role = 'YES'
	 and granted_role in ('SAVOIR_FAIRE','REF_META_ROLE');
     else
	the_app_user := the_user;

   	if not (is_role_granted ('SAVOIR_FAIRE')
              OR is_role_granted ('REF_META_ROLE')) then
    	     is_valid_role := 0;
	  else
	     is_valid_role := 1;
	  end if;
     end if;

     if not (is_valid_role > 0) then
	   check_site_id_auth (:new.site_id, the_user, the_app_user);
     end if;
end;
/

create or replace TRIGGER ref_site_coef_month_site_perm
after             insert or update or delete
on                ref_site_coef_month
for   each row

declare
  the_user varchar2(30);
  the_app_user varchar2(30);
  is_valid_role NUMBER;

begin
     the_user := USER;
     if (the_user = 'APEX_PUBLIC_USER') then
       the_app_user := nvl(v('APP_USER'),USER);

       select count(*)
       into is_valid_role
       from dba_role_privs
       where grantee = the_app_user
	 and default_role = 'YES'
	 and granted_role in ('SAVOIR_FAIRE','REF_META_ROLE');
     else
	the_app_user := the_user;

   	if not (is_role_granted ('SAVOIR_FAIRE')
              OR is_role_granted ('REF_META_ROLE')) then
    	     is_valid_role := 0;
	  else
	     is_valid_role := 1;
	  end if;
     end if;

     if not (is_valid_role > 0) then
	   check_site_id_auth (:new.site_id, the_user, the_app_user);
     end if;
end;
/

create or replace TRIGGER ref_site_coef_site_perm
after             insert or update or delete
on                ref_site_coef
for   each row

declare
  the_user varchar2(30);
  the_app_user varchar2(30);
  is_valid_role NUMBER;

begin
     the_user := USER;
     if (the_user = 'APEX_PUBLIC_USER') then
       the_app_user := nvl(v('APP_USER'),USER);

       select count(*)
       into is_valid_role
       from dba_role_privs
       where grantee = the_app_user
	 and default_role = 'YES'
	 and granted_role in ('SAVOIR_FAIRE','REF_META_ROLE');
     else
	the_app_user := the_user;

   	if not (is_role_granted ('SAVOIR_FAIRE')
              OR is_role_granted ('REF_META_ROLE')) then
    	     is_valid_role := 0;
	  else
	     is_valid_role := 1;
	  end if;
     end if;

     if not (is_valid_role > 0) then
	   check_site_id_auth (:new.site_id, the_user, the_app_user);
     end if;
end;
/

create or replace TRIGGER ref_spatial_relation_site_perm
after             insert or update or delete
on                ref_spatial_relation
for   each row

declare
  the_user varchar2(30);
  the_app_user varchar2(30);
  is_valid_role NUMBER;

begin
     the_user := USER;
     if (the_user = 'APEX_PUBLIC_USER') then
       the_app_user := nvl(v('APP_USER'),USER);

       select count(*)
       into is_valid_role
       from dba_role_privs
       where grantee = the_app_user
	 and default_role = 'YES'
	 and granted_role in ('SAVOIR_FAIRE','REF_META_ROLE');
     else
	the_app_user := the_user;

   	if not (is_role_granted ('SAVOIR_FAIRE')
              OR is_role_granted ('REF_META_ROLE')) then
    	     is_valid_role := 0;
	  else
	     is_valid_role := 1;
	  end if;
     end if;

     if not (is_valid_role > 0) then
	   check_site_id_auth (:new.a_site_id, the_user, the_app_user);
	   check_site_id_auth (:new.b_site_id, the_user, the_app_user);
     end if;
end;
/

create or replace TRIGGER sdi_chk_perm
after             insert OR update OR delete
on                hdb_site_datatype
for   each row
declare
  the_user varchar2(30);
  the_app_user varchar2(30);
  is_valid_role NUMBER;
begin
     the_user := USER;
     if (the_user = 'APEX_PUBLIC_USER') then
       the_app_user := nvl(v('APP_USER'),USER);

       select count(*)
       into is_valid_role
       from dba_role_privs
       where grantee = the_app_user
	 and default_role = 'YES'
	 and granted_role in ('SAVOIR_FAIRE','HDB_META_ROLE');
     else
	the_app_user := the_user;

        if not (is_role_granted ('SAVOIR_FAIRE')
                OR is_role_granted ('HDB_META_ROLE')) then
    	  is_valid_role := 0;
	else
	  is_valid_role := 1;
	end if;
     end if;

--     raise_application_error (-20001,'THE USER: '|| the_user||'APP_USER: '||the_app_user||'ROLE VALID '||is_valid_role);

     if not (is_valid_role > 0) then
	   check_sdi_auth_with_site (:new.site_datatype_id, :new.site_id);
     end if;
      
     /* populate the ref_db_generic_list table for the snapshot_manager  */
     /* added by M. Bogner April 2013  */
     snapshot_manager.snapshot_modified('HDB_SITE_DATATYPE');
       
end;     
/

create or replace TRIGGER ref_site_coeflu_site_perm
after             insert OR update OR delete
on                ref_site_coeflu
for   each row
declare
  the_user varchar2(30);
  the_app_user varchar2(30);
  is_valid_role NUMBER;

begin
     the_user := USER;
     if (the_user = 'APEX_PUBLIC_USER') then
       the_app_user := nvl(v('APP_USER'),USER);

       select count(*)
       into is_valid_role
       from dba_role_privs
       where grantee = the_app_user
and default_role = 'YES'
and granted_role in ('SAVOIR_FAIRE','REF_META_ROLE');
     else
the_app_user := the_user;

    if not (is_role_granted ('SAVOIR_FAIRE')
              OR is_role_granted ('REF_META_ROLE')) then
        is_valid_role := 0;
 else
    is_valid_role := 1;
 end if;
     end if;

     if not (is_valid_role > 0) then
  check_site_id_auth (:new.site_id, the_user, the_app_user);
     end if;
end;
/

--update version table
INSERT INTO TSDB_PROPERTY (PROP_NAME, PROP_VALUE) VALUES ('IsRoleGranted', 'Y');
/

--grants, run as SYS
grant EXECUTE on IS_ROLE_GRANTED to PUBLIC ;
CREATE OR REPLACE PUBLIC SYNONYM IS_ROLE_GRANTED FOR IS_ROLE_GRANTED;
grant select on sys.dba_role_privs to SAVOIR_FAIRE;

--Commit
commit;
