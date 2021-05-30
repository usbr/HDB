-- This DDL creates archive tables for HDB_SITE_ARCHIVE, HDB_DATATYPE_ARCHIVE and HDB_SITE_DATATYPE_ARCHIVE
-- along with other necessary objects/grants 

--Tables 
create table hdb_site_datatype_archive (                                  
site_id                        number(11) NOT NULL  ,            
datatype_id                    number(11) NOT NULL  ,           
site_datatype_id               number(11) NOT NULL  ,
ARCHIVE_REASON		       VARCHAR2(10)     NOT NULL,  
DATE_TIME_ARCHIVED	       DATE             NOT NULL,        
ARCHIVE_CMMNT		       VARCHAR2(1000)           
)                                                             
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 100k
         next 100k
         pctincrease 0);
/		 

create table hdb_site_archive (                           
site_id                        number(11) NOT NULL  ,  
site_name                      varchar2(240) NOT NULL  , 
site_common_name               varchar2(240)  NOT NULL, 
objecttype_id                  number(11) NOT NULL  ,  
parent_site_id                 number(11) NULL      , 
parent_objecttype_id           number(11) NULL      ,
state_id                       number(11) NULL      , 
basin_id                       number(11) NULL      ,  
lat                            varchar2(24) NULL      ,
longi                           varchar2(24) NULL      ,
hydrologic_unit                varchar2(20) NULL     ,
segment_no                     number(11) NULL      ,
river_mile                     float NULL      ,    
elevation                      float NULL      ,   
description                    varchar2(560) NULL      ,   
nws_code                       varchar2(10) NULL      ,   
scs_id                         varchar2(10) NULL      ,  
shef_code                      varchar2(8) NULL      ,  
usgs_id                        varchar2(10) NULL       ,
db_site_code                   varchar2(3) NOT NULL     ,
ARCHIVE_REASON		       VARCHAR2(10)     NOT NULL,  
DATE_TIME_ARCHIVED	       DATE             NOT NULL,        
ARCHIVE_CMMNT		       VARCHAR2(1000)       
)                                                     
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 60k
         next 60k
         pctincrease 0);
/

create table hdb_datatype_archive (                     
datatype_id                    number(11) NOT NULL  ,     
datatype_name                  varchar2(240) NOT NULL  ,  
datatype_common_name           varchar2(64) NOT NULL, 
physical_quantity_name         varchar2(64) NOT NULL, 
unit_id                        number(11) NOT NULL  , 
allowable_intervals            varchar2(16) NOT NULL,
agen_id                        number(11),
cmmnt                          varchar2(1000),
ARCHIVE_REASON		       VARCHAR2(10)     NOT NULL,  
DATE_TIME_ARCHIVED	       DATE             NOT NULL,        
ARCHIVE_CMMNT		       VARCHAR2(1000)
)                                                   
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);
/

--Public synonyms
CREATE OR REPLACE PUBLIC SYNONYM HDB_SITE_ARCHIVE FOR HDB_SITE_ARCHIVE;
CREATE OR REPLACE PUBLIC SYNONYM HDB_DATATYPE_ARCHIVE FOR HDB_DATATYPE_ARCHIVE;
CREATE OR REPLACE PUBLIC SYNONYM HDB_SITE_DATATYPE_ARCHIVE FOR HDB_SITE_DATATYPE_ARCHIVE;
/

--Grants to Public
GRANT SELECT ON  HDB_SITE_ARCHIVE to PUBLIC;
GRANT SELECT ON  HDB_DATATYPE_ARCHIVE to PUBLIC;
GRANT SELECT ON  HDB_SITE_DATATYPE_ARCHIVE to PUBLIC;
/

commit;
/

--TRIGGERS
create or replace trigger hdb_site_datatype_arch_update                                                                    
after update on hdb_site_datatype 
for each row 
begin 
insert into hdb_site_datatype_archive (  
SITE_ID,
DATATYPE_ID,
SITE_DATATYPE_ID,     
ARCHIVE_REASON, 
DATE_TIME_ARCHIVED, 
ARCHIVE_CMMNT) 
values (                                           
:old.SITE_ID,                                                                                              
:old.DATATYPE_ID,                                                                                                 
:old.SITE_DATATYPE_ID,                                                                                                                                                                                                
'UPDATE', 
sysdate, 
coalesce(
          sys_context('APEX$SESSION','app_user')
         ,regexp_substr(sys_context('userenv','client_identifier'),'^[^:]*')
         ,sys_context('userenv','session_user')
         )
); 
end;                                                                    
/                                                                                                                       
show errors trigger hdb_site_datatype_arch_update;                                                                         
/
                                                                                                                        
create or replace trigger hdb_site_datatype_arch_delete                                                                    
after delete on hdb_site_datatype 
for each row 
begin 
insert into hdb_site_datatype_archive (                     
SITE_ID,
DATATYPE_ID,
SITE_DATATYPE_ID, 
ARCHIVE_REASON, 
DATE_TIME_ARCHIVED, 
ARCHIVE_CMMNT) values (                                           
:old.SITE_ID,                                                                                              
:old.DATATYPE_ID,                                                                                                 
:old.SITE_DATATYPE_ID,
'DELETE', 
sysdate, 
coalesce(
          sys_context('APEX$SESSION','app_user')
         ,regexp_substr(sys_context('userenv','client_identifier'),'^[^:]*')
         ,sys_context('userenv','session_user')
         )
); 
end;                                                                    
/                                                                                                                       
show errors trigger hdb_site_datatype_arch_delete;      
/


create or replace trigger hdb_datatype_archive_update                                                                    
after update on hdb_datatype 
for each row 
begin 
insert into hdb_datatype_archive (  
DATATYPE_ID,
DATATYPE_NAME,
DATATYPE_COMMON_NAME,
PHYSICAL_QUANTITY_NAME,
UNIT_ID,
ALLOWABLE_INTERVALS,
AGEN_ID,
CMMNT,
ARCHIVE_REASON,
DATE_TIME_ARCHIVED,
ARCHIVE_CMMNT) 
values (                                           
:old.DATATYPE_ID,                                                                                              
:old.DATATYPE_NAME,                                                                                                 
:old.DATATYPE_COMMON_NAME,
:old.PHYSICAL_QUANTITY_NAME,
:old.UNIT_ID,
:old.ALLOWABLE_INTERVALS,
:old.AGEN_ID,
:old.CMMNT,                                                                                                                                                                                                
'UPDATE', 
sysdate, 
coalesce(
          sys_context('APEX$SESSION','app_user')
         ,regexp_substr(sys_context('userenv','client_identifier'),'^[^:]*')
         ,sys_context('userenv','session_user')
         )
); 
end;                                                                    
/                                                                                                                       
show errors trigger hdb_datatype_archive_update;                                                                         
/
                                                                                                                        
create or replace trigger hdb_datatype_archive_delete                                                                    
after delete on hdb_datatype 
for each row 
begin 
insert into hdb_datatype_archive (                     
DATATYPE_ID,
DATATYPE_NAME,
DATATYPE_COMMON_NAME,
PHYSICAL_QUANTITY_NAME,
UNIT_ID,
ALLOWABLE_INTERVALS,
AGEN_ID,
CMMNT,
ARCHIVE_REASON,
DATE_TIME_ARCHIVED,
ARCHIVE_CMMNT
) values (                                           
:old.DATATYPE_ID,                                                                                              
:old.DATATYPE_NAME,                                                                                                 
:old.DATATYPE_COMMON_NAME,
:old.PHYSICAL_QUANTITY_NAME,
:old.UNIT_ID,
:old.ALLOWABLE_INTERVALS,
:old.AGEN_ID,
:old.CMMNT,  
'DELETE', 
sysdate, 
coalesce(
          sys_context('APEX$SESSION','app_user')
         ,regexp_substr(sys_context('userenv','client_identifier'),'^[^:]*')
         ,sys_context('userenv','session_user')
         )
); 
end;                                                                    
/                                                                                                                       
show errors trigger hdb_datatype_archive_delete;    
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
coalesce(
          sys_context('APEX$SESSION','app_user')
         ,regexp_substr(sys_context('userenv','client_identifier'),'^[^:]*')
         ,sys_context('userenv','session_user')
         )
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
coalesce(
          sys_context('APEX$SESSION','app_user')
         ,regexp_substr(sys_context('userenv','client_identifier'),'^[^:]*')
         ,sys_context('userenv','session_user')
         )
); 
end;                                                                    
/                                                                                                                       
show errors trigger hdb_site_archive_delete;    
/

commit;
/

--update version table
INSERT INTO TSDB_PROPERTY (PROP_NAME, PROP_VALUE) VALUES ('Archive_SITE-DATAYPE', 'Y');
/

--Commit
commit;