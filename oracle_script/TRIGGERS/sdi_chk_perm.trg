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
show errors trigger sdi_chk_perm;
/
