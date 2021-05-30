set echo on

create or replace trigger role_psswd_fk
after             insert or update of role
on                role_psswd
for   each row
begin
     check_valid_role_name
 (:new.role);
end;
/
show errors trigger unit_chk_val_spec;

exit;
