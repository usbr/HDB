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
show errors;
/
grant execute on check_sdi_auth to public;
/
