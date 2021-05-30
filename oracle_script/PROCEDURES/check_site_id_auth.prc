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
show errors;
/
grant execute on check_site_id_auth to public;
/
