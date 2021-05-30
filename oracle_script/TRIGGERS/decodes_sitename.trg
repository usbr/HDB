
CREATE OR REPLACE TRIGGER DECODES_SITENAME_UPDATE
 instead of update on SITE_TO_DECODES_NAME_VIEW 
referencing old as old new as new 
for each row
declare
 TEMP_SCS_ID number;
begin
  /* nametypes of "HDB" removed fromm procesing as of new view and per A. Gilmore 2/07/07  */
  if (:new.nametype <> 'hdb') then
   select ext_site_code_sys_id into TEMP_SCS_ID
   from hdb_ext_site_code_sys 
   where ext_site_code_sys_name = :new.nametype;
   
   update hdb_ext_site_code
   set
     primary_site_code = :new.sitename,
     secondary_site_code = :new.dbnum||'|'||:new.agency_cd
     where
     ext_site_code_sys_id = TEMP_SCS_ID and
     hdb_site_id = :new.siteid;
  end if;
end;
.
/

create or replace trigger decodes_sitename_delete
instead of delete on site_to_decodes_name_view 
declare
 TEMP_COUNT number;

begin


/* first go find if there are any records in the exhdb_ext_site_code table  */
select count(*)  into temp_count from hdb_ext_site_code where hdb_site_id = :old.siteid;

if (temp_count > 0 and :old.nametype <> 'hdb') then
  delete from hdb_ext_site_code where hdb_site_id = :old.siteid and primary_site_code = :old.sitename;
end if;


END;
.
/
create or replace trigger decodes_sitename_insert
instead of insert on site_to_decodes_name_view 
for each row
declare
 TEMP_SCS_ID number;
begin
  /* nametypes of "HDB" removed fromm procesing as of new view and per A. Gilmore 2/07/07  */
  if (:new.nametype <> 'hdb') then
   select ext_site_code_sys_id into TEMP_SCS_ID from hdb_ext_site_code_sys where ext_site_code_sys_name = :new.nametype;
   insert into hdb_ext_site_code ( ext_site_code_sys_id,primary_site_code,secondary_site_code,hdb_site_id)
   values (TEMP_SCS_ID,:new.sitename,:new.dbnum||'|'||:new.agency_cd,:new.siteid);
  end if;
END;
.
/
