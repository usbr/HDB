create or replace trigger ref_site_coeflu_site_perm
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
show errors trigger ref_site_coeflu_site_perm;
/
