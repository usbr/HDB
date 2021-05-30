set echo on

create or replace procedure
             check_valid_role_name
              (role      varchar2)
IS
      role_exists integer;
BEGIN
      SELECT count(*)
      INTO role_exists
      FROM sys.user$
      WHERE name = upper (role)
        AND type# = 0;
      if (role_exists = 0) then
            raise_application_error(-20002,' Integrity Failure: Illegal value for role = ' || role);
      end if;
end;
/
show errors;

grant execute on check_valid_role_name to public;

exit;
