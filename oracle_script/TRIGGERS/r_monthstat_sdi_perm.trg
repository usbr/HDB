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
show errors trigger r_monthstat_sdi_perm;
/
