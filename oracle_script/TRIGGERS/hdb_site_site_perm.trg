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
show errors trigger hdb_site_site_perm;
/

create or replace trigger hdb_site_archive_update                                                                    
after update on hdb_site 
for each row 
begin 
insert into hdb_site_archive (  
SITE_ID,
SITE_NAME,
SITE_COMMON_NAME,
OBJECTTYPE_ID,
PARENT_SITE_ID,
PARENT_OBJECTTYPE_ID,
STATE_ID,
BASIN_ID,
LAT,
LONGI,
HYDROLOGIC_UNIT,
SEGMENT_NO,
RIVER_MILE,
ELEVATION,
DESCRIPTION,
NWS_CODE,
SCS_ID,
SHEF_CODE,
USGS_ID,
DB_SITE_CODE,
ARCHIVE_REASON,
DATE_TIME_ARCHIVED,
ARCHIVE_CMMNT) 
values (                                           
:old.SITE_ID,
:old.SITE_NAME,
:old.SITE_COMMON_NAME,
:old.OBJECTTYPE_ID,
:old.PARENT_SITE_ID,
:old.PARENT_OBJECTTYPE_ID,
:old.STATE_ID,
:old.BASIN_ID,
:old.LAT,
:old.LONGI,
:old.HYDROLOGIC_UNIT,
:old.SEGMENT_NO,
:old.RIVER_MILE,
:old.ELEVATION,
:old.DESCRIPTION,
:old.NWS_CODE,
:old.SCS_ID,
:old.SHEF_CODE,
:old.USGS_ID,
:old.DB_SITE_CODE,                                                                                                                                                                                                
'UPDATE', 
sysdate, 
sys_context('USERENV', 'SESSION_USER')
); 
end;                                                                    
/                                                                                                                       
show errors trigger hdb_site_archive_update;                                                                         
/
                                                                                                                        
create or replace trigger hdb_site_archive_delete                                                                    
after delete on hdb_site 
for each row 
begin 
insert into hdb_site_archive (                     
SITE_ID,
SITE_NAME,
SITE_COMMON_NAME,
OBJECTTYPE_ID,
PARENT_SITE_ID,
PARENT_OBJECTTYPE_ID,
STATE_ID,
BASIN_ID,
LAT,
LONGI,
HYDROLOGIC_UNIT,
SEGMENT_NO,
RIVER_MILE,
ELEVATION,
DESCRIPTION,
NWS_CODE,
SCS_ID,
SHEF_CODE,
USGS_ID,
DB_SITE_CODE,
ARCHIVE_REASON,
DATE_TIME_ARCHIVED,
ARCHIVE_CMMNT
) values (                                           
:old.SITE_ID,
:old.SITE_NAME,
:old.SITE_COMMON_NAME,
:old.OBJECTTYPE_ID,
:old.PARENT_SITE_ID,
:old.PARENT_OBJECTTYPE_ID,
:old.STATE_ID,
:old.BASIN_ID,
:old.LAT,
:old.LONGI,
:old.HYDROLOGIC_UNIT,
:old.SEGMENT_NO,
:old.RIVER_MILE,
:old.ELEVATION,
:old.DESCRIPTION,
:old.NWS_CODE,
:old.SCS_ID,
:old.SHEF_CODE,
:old.USGS_ID,
:old.DB_SITE_CODE,  
'DELETE', 
sysdate, 
sys_context('USERENV', 'SESSION_USER')
); 
end;                                                                    
/                                                                                                                       
show errors trigger hdb_site_archive_delete;   
/