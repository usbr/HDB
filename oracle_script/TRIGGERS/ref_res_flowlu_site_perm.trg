create or replace trigger ref_res_flowlu_site_perm
after             insert OR update OR delete
on                ref_res_flowlu
for   each row
begin
     if not (DBMS_SESSION.Is_Role_Enabled ('SAVOIR_FAIRE')
             OR DBMS_SESSION.Is_Role_Enabled ('REF_META_ROLE')) then
	   check_site_id_auth (:new.site_id);
	end if;
end;
/
show errors trigger ref_res_flowlu_site_perm;
/