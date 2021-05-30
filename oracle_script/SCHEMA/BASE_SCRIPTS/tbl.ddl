set echo on
set feedback on
spool hdb_tables.out

create table hdb_agen (                     
agen_id                        number(11) NOT NULL  ,    
agen_name                      varchar2(64) NOT NULL,
agen_abbrev                    varchar2(10)
)                                                      
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table hdb_attr (                   
attr_id                        number(11) NOT NULL  ,    
attr_name                      varchar2(64) NOT NULL  , 
attr_common_name               varchar2(64) NOT NULL, 
attr_value_type                varchar2(10) NOT NULL  ,
attr_code                      varchar2(16),
unit_id                        number(11)
)                                                        
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table hdb_collection_system (                           
collection_system_id           number NOT NULL,
collection_system_name         varchar2(64) NOT NULL,
cmmnt                          varchar2(1000)
)                                                    
pctfree 10
pctused 80
tablespace HDB_data
storage (initial 1024k
         next    1024k
         pctincrease 0);

/*  removed for computation processor
create table hdb_computed_datatype (  
computation_id                 number(11) NOT NULL  ,     
computation_name               varchar2(64) NOT NULL  ,  
datatype_id                    number(11) ,     
cmmnt                          varchar2(1000)
)                                                   
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);
*/

/*
create table hdb_computed_datatype_components (  
computation_id                 number(11) NOT NULL  ,   
order                          number(11) NOT NULL  ,   
component_type                 varchar2(16) NOT NULL,
component_token/ID                      NOT NULL,
timestep_offset                number(11) 
)                                                   
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);
*/                     

create table hdb_damtype (                        
damtype_id                     number(11) NOT NULL  ,  
damtype_name                   varchar2(32) NOT NULL      
)                                                    
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);
                       
create table hdb_data_source (           
source_id                      number(11) NOT NULL  ,     
source_name                    varchar2(64) NOT NULL  ,  
cmmnt                        varchar2(1000) NULL      
)                                                      
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table hdb_datatype (                     
datatype_id                    number(11) NOT NULL  ,     
datatype_name                  varchar2(240) NOT NULL  ,  
datatype_common_name           varchar2(64) NOT NULL, 
physical_quantity_name         varchar2(64) NOT NULL, 
unit_id                        number(11) NOT NULL  , 
allowable_intervals            varchar2(16) NOT NULL,
agen_id                        number(11),
cmmnt                          varchar2(1000)
)                                                   
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

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


create table hdb_date_time_unit (
date_time_unit                 varchar2(10) NOT NULL,
cmmnt                          varchar2(1000)
)
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

/* removed by CP project
--create table hdb_derivation_flag
--   (derivation_flag              varchar2(1) NOT NULL,
--    derivation_flag_name         varchar2(20) NOT NULL,
--    cmmnt                        varchar2(1000)
--)
--pctfree 10
--pctused 40
--tablespace HDB_data
--storage (initial 50k
--         next 50k
--         pctincrease 0);
*/

create table hdb_divtype (                
divtype                        char(1) NOT NULL  , 
divtype_name                   varchar2(10) NOT NULL 
)                                                   
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table hdb_dmi_unit_map (              
pr_unit_name                   varchar2(32) NOT NULL  , 
unit_id                        number(11) NOT NULL  ,  
scale                          number(11) NOT NULL    
)                                                    
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table hdb_ext_site_code_sys
(ext_site_code_sys_id         	number(11) not null,
 ext_site_code_sys_name        	varchar2(64) not null,
 agen_id                        number(11),
 model_id			number(11))
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table hdb_ext_site_code
(ext_site_code_sys_id         	number(11) not null,
 primary_site_code              varchar2(240) not null,
 secondary_site_code           	varchar2(64),
 hdb_site_id			number(11) not null,
 date_time_loaded               date not null)
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table hdb_ext_site_code_archive (  
EXT_SITE_CODE_SYS_ID           NUMBER(22)       NOT NULL, 
PRIMARY_SITE_CODE              VARCHAR2(240)    NOT NULL,  
SECONDARY_SITE_CODE            VARCHAR2(64)     ,
HDB_SITE_ID                    NUMBER(22)       NOT NULL, 
DATE_TIME_LOADED               DATE             NOT NULL,
ARCHIVE_REASON		       VARCHAR2(10)     NOT NULL,  
DATE_TIME_ARCHIVED	       DATE             NOT NULL,        
ARCHIVE_CMMNT		       VARCHAR2(1000))
pctfree 10 
pctused 40 
tablespace HDB_data                                                                               
storage (initial 50k 
         next 50k 
         pctincrease 0);                                                                           
                                                                                                                        
create table hdb_ext_data_code_sys
(ext_data_code_sys_id         	number(11) not null,
 ext_data_code_sys_name        	varchar2(64) not null,
 agen_id                        number(11),
 model_id			number(11))
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table hdb_ext_data_code
(ext_data_code_sys_id         	number(11) not null,
 primary_data_code              varchar2(64) not null,
 secondary_data_code           	varchar2(64),
 hdb_datatype_id		number(11) not null,
 date_time_loaded               date not null)
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table hdb_ext_data_code_archive ( 
EXT_DATA_CODE_SYS_ID           NUMBER(22)         NOT NULL, 
PRIMARY_DATA_CODE              VARCHAR2(64)       NOT NULL,
SECONDARY_DATA_CODE            VARCHAR2(64)       ,   
HDB_DATATYPE_ID                NUMBER(22)         NOT NULL, 
DATE_TIME_LOADED               DATE               NOT NULL,                                   
ARCHIVE_REASON		       VARCHAR2(10)       NOT NULL,       
DATE_TIME_ARCHIVED	       DATE               NOT NULL,           
ARCHIVE_CMMNT		       VARCHAR2(1000))    
pctfree 10 
pctused 40 
tablespace HDB_data      
storage (initial 50k 
         next 50k 
         pctincrease 0);                                                                           

create table hdb_ext_data_source
(ext_data_source_id         	number(11) not null,
 ext_data_source_name         	varchar2(64) not null,
 agen_id                        number(11),
 model_id			number(11),
 ext_site_code_sys_id		number(11),
 ext_data_code_sys_id		number(11),
 collection_system_id		number(11),
 data_quality			varchar2(16),
 description			varchar2(200),
 date_time_loaded               date not null)
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);
                                              
create table hdb_ext_data_source_archive ( 
EXT_DATA_SOURCE_ID             NUMBER(22)            NOT NULL, 
EXT_DATA_SOURCE_NAME           VARCHAR2(64)          NOT NULL, 
AGEN_ID                        NUMBER(22)            ,    
MODEL_ID                       NUMBER(22)            , 
EXT_SITE_CODE_SYS_ID           NUMBER(22)            , 
EXT_DATA_CODE_SYS_ID           NUMBER(22)            , 
COLLECTION_SYSTEM_ID           NUMBER(22)            ,  
DATA_QUALITY                   VARCHAR2(16)          ,  
DESCRIPTION                    VARCHAR2(200)         , 
DATE_TIME_LOADED               DATE                  NOT NULL,                                  
ARCHIVE_REASON		       VARCHAR2(10)          NOT NULL,                         
DATE_TIME_ARCHIVED	       DATE                  NOT NULL,                              
ARCHIVE_CMMNT		       VARCHAR2(1000))                             
pctfree 10 
pctused 40 
tablespace HDB_data                              
storage (initial 50k 
         next 50k 
         pctincrease 0);                                                                           

create table hdb_gagetype (                  
gagetype_id                    number(11) NOT NULL,     
gagetype_name                  varchar2(64) NOT NULL
)                                                       
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table hdb_interval (                     
interval_name                  varchar2(16) NOT NULL  ,  
interval_order                 number(11) NOT NULL,
previous_interval_name         varchar2(16) ,  
interval_unit                  varchar2(10) ,  
cmmnt                          varchar2(1000)
)                                                   
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table hdb_loading_application (                           
loading_application_id         number NOT NULL,
loading_application_name       varchar2(64) NOT NULL,
manual_edit_app	               CHAR(1) CONSTRAINT check_manual_edit_app CHECK (manual_edit_app in ('Y','N')),
cmmnt                          varchar2(1000)
)                                                    
pctfree 10
pctused 80
tablespace HDB_data
storage (initial 50k
         next    50k
         pctincrease 0);
                       
create table hdb_method (                     
method_id                      number(11) NOT NULL,
method_name                    varchar2(64) NOT NULL  ,
method_common_name             varchar2(64)  NOT NULL, 
method_class_id                number(11) NOT NULL,
cmmnt                          varchar2(1000)
)                                                   
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table hdb_method_class (                     
method_class_id                number(11) NOT NULL,
method_class_name              varchar2(64) NOT NULL  ,
method_class_common_name       varchar2(64) NOT NULL, 
method_class_type              varchar2(24) NOT NULL  ,
cmmnt                          varchar2(1000)
)                                                   
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);
               
create table hdb_method_class_type (
method_class_type                  varchar2(24) NOT NULL,
cmmnt                              varchar2(1000)
)
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table hdb_model (                      
model_id                       number(11) NOT NULL  ,    
model_name                     varchar2(64) NOT NULL  ,
coordinated                    varchar2(1) NOT NULL, 
cmmnt                          varchar2(1000) NULL     
)                                                     
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table hdb_model_coord (                      
model_id                       number(11) NOT NULL  ,    
db_site_code                   varchar2(3) NOT NULL
)                                                     
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table hdb_modeltype (                          
modeltype                      varchar2(1) NULL ,     
modeltype_name                 varchar2(32) NOT NULL
)                                                  
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table hdb_objecttype (                                 
objecttype_id                  number(11) NOT NULL  ,        
objecttype_name                varchar2(32) NOT NULL  ,     
objecttype_tag                 varchar2(5) NOT NULL  ,     
objecttype_parent_order        number(11) NOT NULL        
)                                                        
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table hdb_operator (
operator                       varchar2(16) NOT NULL,
cmmnt                          varchar2(1000)
)
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table hdb_overwrite_flag
   (overwrite_flag               varchar2(1) NOT NULL,
    overwrite_flag_name          varchar2(20) NOT NULL,
    cmmnt                        varchar2(1000)
)
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table hdb_river (                              
river_id                       number(11) NOT NULL  ,
river_name                     varchar2(32) NOT NULL         
)                                                             
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table hdb_river_reach (                       
hydrologic_unit                varchar2(10) NOT NULL  , 
segment_no                     number(11) NOT NULL  ,  
river_id                       number(11) NOT NULL    
)                                                    
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table hdb_site (                           
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
db_site_code                   varchar2(3) NOT NULL           
)                                                     
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 60k
         next 60k
         pctincrease 0);
		 

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


CREATE TABLE DECODES_Site_ext
(
  site_id      INTEGER NOT NULL,
  nearestCity  VARCHAR(64),
  state        VARCHAR(24),
  region       VARCHAR(64),
  timezone     VARCHAR(64),
  country      VARCHAR(64),
  elevUnitAbbr VARCHAR(24)
)
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 60k
         next 60k
         pctincrease 0);


create table hdb_site_datatype (                                  
site_id                        number(11) NOT NULL  ,            
datatype_id                    number(11) NOT NULL  ,           
site_datatype_id               number(11) NOT NULL             
)                                                             
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 100k
         next 100k
         pctincrease 0);
		 

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


create table hdb_state (                        
state_id                       number(11) NOT NULL  ,        
state_code                     varchar2(2) NOT NULL  ,      
state_name                     varchar2(32) NOT NULL       
)                                                         
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table hdb_usbr_off (                
off_id                         number(11) NOT NULL  ,         
off_name                       varchar2(64) NOT NULL             
)                                                           
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table hdb_validation (                              
validation                     char(1) NOT NULL  ,        
cmmnt                        varchar2(1000) NULL       
)                         
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table hm_temp_data (                   
site_datatype_id               number(11) NOT NULL  ,      
date_date                      date NOT NULL  ,           
value                          float NOT NULL  ,         
source_id                      number(11) NOT NULL  ,   
validation                     char(1) NOT NULL        
)                                                     
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 100k
         next 100k
         pctincrease 0);

create table ref_agg_disagg (                     
agg_disagg_id                  number(11) NOT NULL  ,      
source_datatype_id             number(11) NOT NULL  ,     
source_observation_interval    varchar2(16) NOT NULL  ,   
dest_datatype_unit_ind         varchar2(1) NOT NULL  ,  
dest_datatype_or_unit_id       number(11) NOT NULL  ,  
dest_observation_interval      varchar2(16) NOT NULL  ,
method_or_function             varchar2(1) NOT NULL  ,    
method_id                      number(11) NULL      ,   
agg_disagg_function_name       varchar2(32) NULL        
)                                                      
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table ref_app_data_source (            
executable_name                varchar2(32) NOT NULL  ,     
source_id                      number(11) NOT NULL         
)                                                         
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table ref_auth_site (                       
role                           varchar2 (30) NOT NULL,
site_id                        number(11) NOT NULL  
)                                                  
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table ref_auth_site_datatype (                          
role                           varchar2 (30) NOT NULL,
site_datatype_id               number(11) NOT NULL           
)                                                           
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table ref_db_list (                            
session_no                     number(11) NOT NULL  ,         
db_site_db_name                varchar2(25) NOT NULL  ,      
db_site_code                   varchar2(3) NOT NULL  ,      
min_coord_model_run_id         number(11) NULL      ,      
max_coord_model_run_id         number(11) NULL      
)                                                        
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

CREATE TABLE REF_DB_GENERIC_LIST
(
        RECORD_ID          NUMBER NOT NULL,
        RECORD_KEY         VARCHAR2(50) NOT NULL,               
        RECORD_KEY_VALUE1  VARCHAR2(512) NOT NULL,               
        RECORD_KEY_VALUE2  VARCHAR2(512),               
        DATE_TIME_LOADED DATE
)
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

CREATE TABLE REF_DB_PARAMETER
(
GLOBAL_NAME			VARCHAR2(100) NOT NULL,
PARAM_NAME			VARCHAR2(64) NOT NULL,
PARAM_VALUE			VARCHAR2(64) NOT NULL,
ACTIVE_FLAG			VARCHAR2(1)  DEFAULT 'Y' NOT NULL,
DESCRIPTION			VARCHAR2(400) NOT NULL,
EFFECTIVE_START_DATE_TIME	DATE,
EFFECTIVE_END_DATE_TIME		DATE
)
tablespace HDB_data;

create or replace public synonym REF_DB_PARAMETER for REF_DB_PARAMETER;
grant select on REF_DB_PARAMETER to public;

insert into REF_DB_PARAMETER
select global_name,'TIME_ZONE','MST','Y','DATABASES DEFAULT TIME SERIES TIME ZONE',
sysdate,null from global_name;

insert into REF_DB_PARAMETER
select global_name,'DB_RELEASE_VERSION','3.1','Y','DATABASES LATEST SOFTWARE RELEASE VERSION',
sysdate,null from global_name;

/* removed by CP Project
--create table ref_derivation_source
--   (site_datatype_id             number not null,
--    effective_start_date_time    date not null,
--    interval                     varchar2(16) not null,
--    first_destination_interval   varchar2(16),
--    min_value_expected           number,
--    min_value_cutoff             number,
--    max_value_expected           number,
--    max_value_cutoff             number,
--    time_offset_minutes          number
)
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);
*/


/* removed by CP project
--create table ref_derivation_source_archive
--   (site_datatype_id             number not null,
--    effective_start_date_time    date not null,
--    interval                     varchar2(16) not null,
--    first_destination_interval   varchar2(16),
--    min_value_expected           number,
--    min_value_cutoff             number,
--    max_value_expected           number,
--    max_value_cutoff             number,
--    time_offset_minutes          number,
--    archive_reason               varchar2(10) not null,
--    date_time_archived           date not null,
--    archive_cmmnt                varchar2(1000)
--)
--pctfree 10
--pctused 40
--tablespace HDB_data
--storage (initial 50k
--         next 50k
--         pctincrease 0);
*/

/* removed by CP Project
-- create table ref_derivation_destination
--    (base_site_datatype_id           number not null,
--     dest_site_datatype_id           number not null,
--     effective_start_date_time       date not null,
--     method_id                       number not null,
--     partial_calc                    varchar2(1),
--     compounding_source_sdi          number,
--     compounding_source_interval     varchar2(16),
--     hr_desired_eop_window           number,
--     hr_required_eop_window          number,
--     hr_desired_bop_window           number,
--     hr_required_bop_window          number,
--     hr_desired_number_source        number,
--     hr_required_number_source       number,
--     hr_window_unit                  varchar2(10),
--     day_desired_eop_window          number,
--     day_required_eop_window         number,
--     day_desired_bop_window          number,
--     day_required_bop_window         number,
--     day_desired_number_source       number,
--     day_required_number_source      number,
--     day_window_unit                 varchar2(10),
--     mon_desired_eop_window          number,
--     mon_required_eop_window         number,
--     mon_desired_bop_window          number,
--     mon_required_bop_window         number,
--     mon_desired_number_source       number,
--     mon_required_number_source      number,
--     mon_window_unit                 varchar2(10),
--     yr_desired_eop_window           number,
--     yr_required_eop_window          number,
--     yr_desired_bop_window           number,
--     yr_required_bop_window          number,
--     yr_desired_number_source        number,
--     yr_required_number_source       number,
--     yr_window_unit                  varchar2(10),
--     wy_desired_eop_window           number,
--     wy_required_eop_window          number,
--     wy_desired_bop_window           number,
--     wy_required_bop_window          number,
--     wy_desired_number_source        number,
--     wy_required_number_source       number,
--     wy_window_unit                  varchar2(10)
--    )
-- pctfree 10
-- pctused 40
-- tablespace HDB_data
-- storage (initial 50k
--          next 50k
--          pctincrease 0);
*/


/*  removed by CP project
-- create table ref_derivation_dest_archive
--   (base_site_datatype_id           number not null,
--    dest_site_datatype_id           number not null,
--    effective_start_date_time       date not null,
--    method_id                       number not null,
--    partial_calc                    varchar2(1),
--    compounding_source_sdi          number,
--    compounding_source_interval     varchar2(16),
--    hr_desired_eop_window           number,
--    hr_required_eop_window          number,
--    hr_desired_bop_window           number,
--    hr_required_bop_window          number,
--    hr_desired_number_source        number,
--    hr_required_number_source       number,
--    hr_window_unit                  varchar2(10),
--    day_desired_eop_window          number,
--    day_required_eop_window         number,
--    day_desired_bop_window          number,
--    day_required_bop_window         number,
--    day_desired_number_source       number,
----    day_required_number_source      number,
--    day_window_unit                 varchar2(10),
--    mon_desired_eop_window          number,
--    mon_required_eop_window         number,
--    mon_desired_bop_window          number,
--    mon_required_bop_window         number,
--    mon_desired_number_source       number,
--    mon_required_number_source      number,
--    mon_window_unit                 varchar2(10),
--    yr_desired_eop_window           number,
--    yr_required_eop_window          number,
--    yr_desired_bop_window           number,
--    yr_required_bop_window          number,
--    yr_desired_number_source        number,
--    yr_required_number_source       number,
--    yr_window_unit                  varchar2(10),
--    wy_desired_eop_window           number,
--    wy_required_eop_window          number,
--    wy_desired_bop_window           number,
--    wy_required_bop_window          number,
--    wy_desired_number_source        number,
--    wy_required_number_source       number,
--    wy_window_unit                  varchar2(10),
--    archive_reason                  varchar2(10) not null,
--    date_time_archived              date not null,
--    archive_cmmnt                   varchar2(1000)
--)
--pctfree 10
--pctused 40
--tablespace HDB_data
--storage (initial 50k
--         next 50k
--         pctincrease 0);
--*/


create table ref_div (                         
site_id                        number(11) NOT NULL  ,   
divtype                        char(1) NOT NULL        
)                                                     
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table ref_dmi_data_map (        
model_id                       number(11) NOT NULL,    
object_name                    varchar2(240) NOT NULL  ,          
data_name                      varchar2(64) NOT NULL  ,         
site_datatype_id               number(11) NOT NULL
)                                                            
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0)
;
------------------------------------------------------------------------------------
-- This REF_ENSEMBLE table
-- This table is for unique Ensembles that represent a particular suite run of a model
------------------------------------------------------------------------------------
CREATE TABLE REF_ENSEMBLE
(
	ENSEMBLE_ID    NUMBER NOT NULL,
	ENSEMBLE_NAME  VARCHAR2(256) NOT NULL,
	AGEN_ID        NUMBER,
	TRACE_DOMAIN   VARCHAR2(256),
	CMMNT           VARCHAR2(256)
)
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0)
;
------------------------------------------------------------------------------------
-- This REF_ENSEMBLE_KEYVAL table
-- This table is for unique Ensembles KEYS for a particular ENSEMBLE in REF_ENSEMBLE
------------------------------------------------------------------------------------
CREATE TABLE REF_ENSEMBLE_KEYVAL
(
	ENSEMBLE_ID      NUMBER NOT NULL,
	KEY_NAME         VARCHAR2(32) NOT NULL,
	KEY_VALUE        VARCHAR2(256) NOT NULL,
	DATE_TIME_LOADED DATE NOT NULL
)
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0)
;
------------------------------------------------------------------------------------
-- This table is for unique ensemle_ids/ trace_id's that point to a unique model_run_id
------------------------------------------------------------------------------------
CREATE TABLE REF_ENSEMBLE_TRACE
(
	ENSEMBLE_ID   NUMBER NOT NULL,
	TRACE_ID      NUMBER NOT NULL,
	TRACE_NUMERIC NUMBER,
	TRACE_NAME    VARCHAR2(256),
	MODEL_RUN_ID  NUMBER NOT NULL
)
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0)
;
------------------------------------------------------------------------------------
-- This REF_ENSEMBLE_ARCHIVE table
-- This table is for unique Ensembles that represent a particular suite run of a model
------------------------------------------------------------------------------------
CREATE TABLE REF_ENSEMBLE_ARCHIVE
(
	ENSEMBLE_ID         NUMBER NOT NULL,
	ENSEMBLE_NAME       VARCHAR2(256) NOT NULL,
	AGEN_ID             NUMBER,
	TRACE_DOMAIN        VARCHAR2(256),
	CMMNT                VARCHAR2(256),
	ARCHIVE_REASON	    VARCHAR2(10) NOT NULL,
        DATE_TIME_ARCHIVED	DATE NOT NULL,
        ARCHIVE_CMMNT		VARCHAR2(1000)
)
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0)
;
------------------------------------------------------------------------------------
-- This REF_ENSEMBLE_KEYVAL_ARCHIVE table
-- This table is for archiving the REF_ENSEMBLE_KEYVAL table
------------------------------------------------------------------------------------
CREATE TABLE REF_ENSEMBLE_KEYVAL_ARCHIVE
(
	ENSEMBLE_ID         NUMBER NOT NULL,
	KEY_NAME            VARCHAR2(32) NOT NULL,
	KEY_VALUE           VARCHAR2(256) NOT NULL,
	DATE_TIME_LOADED    DATE NOT NULL,
	ARCHIVE_REASON	    VARCHAR2(10) NOT NULL,
        DATE_TIME_ARCHIVED	DATE NOT NULL,
        ARCHIVE_CMMNT		VARCHAR2(1000)
)
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0)
;
------------------------------------------------------------------------------------
CREATE TABLE REF_ENSEMBLE_TRACE_ARCHIVE
(
	ENSEMBLE_ID         NUMBER NOT NULL,
	TRACE_ID            NUMBER NOT NULL,
	TRACE_NUMERIC       NUMBER,
	TRACE_NAME          VARCHAR2(256),
	MODEL_RUN_ID        NUMBER NOT NULL,
	ARCHIVE_REASON	    VARCHAR2(10) NOT NULL,
    DATE_TIME_ARCHIVED	DATE NOT NULL,
    ARCHIVE_CMMNT		VARCHAR2(1000)
)
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0)
;
------------------------------------------------------------------------------------
create table ref_ext_site_data_map
(mapping_id        		number(11) not null,
 ext_data_source_id         	number(11) not null,
 primary_site_code         	varchar2(240) not null,
 primary_data_code         	varchar2(64) not null,
 extra_keys_y_n    		varchar2(1) not null,
 hdb_site_datatype_id  		number(11) not null,
 hdb_interval_name          	varchar2(16) not null,
 hdb_method_id			number(11),
 hdb_computation_id		number(11),
 hdb_agen_id                    number(11),
 is_active_y_n                  varchar2(1) not null,
 cmmnt                          varchar2(500),
 date_time_loaded               date not null)
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table ref_ext_site_data_map_archive
(mapping_id        		number(11) not null,
 ext_data_source_id         	number(11) not null,
 primary_site_code         	varchar2(240) not null,
 primary_data_code         	varchar2(64) not null,
 extra_keys_y_n    		varchar2(1) not null,
 hdb_site_datatype_id  		number(11) not null,
 hdb_interval_name          	varchar2(16) not null,
 hdb_method_id			number(11),
 hdb_computation_id		number(11),
 hdb_agen_id                    number(11),
 is_active_y_n                  varchar2(1) not null,
 cmmnt                          varchar2(500),
 date_time_loaded               date not null,
 archive_reason			varchar2(10) not null,
 date_time_archived		date not null,
 archive_cmmnt			varchar2(1000))
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table ref_ext_site_data_map_keyval
(mapping_id         		number(11) not null,
 key_name           		varchar2(32) not null,
 key_value          		varchar2(32) not null,
 date_time_loaded               date not null)
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table ref_ext_site_data_map_key_arch ( 
MAPPING_ID                     NUMBER(22)         NOT NULL, 
KEY_NAME                       VARCHAR2(32)       NOT NULL,
KEY_VALUE                      VARCHAR2(32)       NOT NULL,
DATE_TIME_LOADED               DATE               NOT NULL,                          
ARCHIVE_REASON		       VARCHAR2(10)       NOT NULL,
DATE_TIME_ARCHIVED	       DATE               NOT NULL,  
ARCHIVE_CMMNT		       VARCHAR2(1000)) 
pctfree 10 
pctused 40 
tablespace HDB_data                                                                               
storage (initial 50k 
         next 50k 
         pctincrease 0);                                                                           
                                                                                                                        
create table ref_hm_filetype (               
hm_filetype                    char(1) NOT NULL  ,        
hm_filetype_name               varchar2(32) NOT NULL         
)                                                       
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table ref_hm_pcode (                               
hm_pcode                       varchar2(8) NOT NULL  ,   
hm_pcode_name                  varchar2(64) NOT NULL  , 
unit_id                        number(11) NOT NULL  ,  
scale                          number(11) NOT NULL    
)                                                    
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table ref_hm_pcode_objecttype (              
hm_pcode                       varchar2(8) NOT NULL,
objecttype_id                  number(11) NOT NULL 
)                                                 
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table ref_hm_site (                        
hm_site_code                   varchar2(8) NOT NULL  ,      
hm_site_name                   varchar2(64) NOT NULL       
)                                                         
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table ref_hm_site_datatype (             
site_datatype_id               number(11) NOT NULL  ,     
hourly                         char(1) NOT NULL  ,       
daily                          char(1) NOT NULL  ,      
weekly                         char(1) NOT NULL  ,     
crsp                           char(1) NOT NULL  ,    
hourly_delete                  char(1) NOT NULL  ,   
max_hourly_date                date NULL      ,     
max_daily_date                 date NULL,
cutoff_minute                  number(11) NOT NULL,
hour_offset                    number(11) NOT NULL
)                                                 
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table ref_hm_site_hdbid (              
hm_site_code                   varchar2(8) NOT NULL  ,      
objecttype_id                  number(11) NOT NULL  ,      
site_id                        number(11) NOT NULL        
)                                                        
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table ref_hm_site_pcode (              
hm_site_code                   varchar2(8) NOT NULL  ,          
hm_pcode                       varchar2(8) NOT NULL  ,         
hm_filetype                    char(1) NOT NULL  ,
site_datatype_id               number(11) NULL
)                                                           
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 150k
         next 150k
         pctincrease 0);


create table ref_interval_copy_limits
(
        SITE_DATATYPE_ID NUMBER NOT NULL,
        INTERVAL VARCHAR2(16) NOT NULL,
        MIN_VALUE_EXPECTED  NUMBER,
        MIN_VALUE_CUTOFF    NUMBER,
        MAX_VALUE_EXPECTED  NUMBER,
        MAX_VALUE_CUTOFF    NUMBER,
        TIME_OFFSET_MINUTES NUMBER,
        DATE_TIME_LOADED    DATE,
	EFFECTIVE_START_DATE_TIME DATE NOT NULL,
	EFFECTIVE_END_DATE_TIME DATE,
	PREPROCESSOR_EQUATION VARCHAR2(512)
)
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 150k
         next 150k
         pctincrease 0);

create table ref_inter_copy_limits_archive
(
        SITE_DATATYPE_ID    NUMBER NOT NULL,
        INTERVAL            VARCHAR2(16) NOT NULL,
        MIN_VALUE_EXPECTED  NUMBER,
        MIN_VALUE_CUTOFF    NUMBER,
        MAX_VALUE_EXPECTED  NUMBER,
        MAX_VALUE_CUTOFF    NUMBER,
        TIME_OFFSET_MINUTES NUMBER,
        DATE_TIME_LOADED    DATE,
	EFFECTIVE_START_DATE_TIME DATE,
	EFFECTIVE_END_DATE_TIME DATE,
	PREPROCESSOR_EQUATION VARCHAR2(512),
        ARCHIVE_REASON      VARCHAR2(10) NOT NULL,
        DATE_TIME_ARCHIVED  DATE NOT NULL,
        ARCHIVE_CMMNT       VARCHAR2(1000)
)
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 150k
         next 150k
         pctincrease 0);


create table ref_interval_redefinition
   (interval                     varchar2(16) not null,
    time_offset                  number not null,
    offset_units                 varchar2(10) not null,
    date_time_loaded             date not null
   )
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 150k
         next 150k
         pctincrease 0);

create table ref_interval_redef_archive
   (interval                     varchar2(16) not null,
    time_offset                  number not null,
    offset_units                 varchar2(10) not null,
    date_time_loaded             date not null,
    archive_reason               varchar2(10) not null,
    date_time_archived           date not null,
    archive_cmmnt                varchar2(1000)
   )
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 150k
         next 150k
         pctincrease 0);

create table ref_model_run (                                 
model_run_id                   number(11) NOT NULL  ,       
model_run_name                 varchar2(64) NOT NULL  ,    
model_id                       number(11) NOT NULL  ,     
date_time_loaded               date  default SYSDATE NOT NULL,
user_name                      varchar2(30) NOT NULL,
extra_keys_y_n                 varchar2(1) NOT NULL,
run_date                       date NOT NULL  ,          
start_date                     date NULL      ,      
end_date                       date NULL      ,     
hydrologic_indicator           varchar2(32) NULL,
modeltype                      varchar2(1) NULL      , 
time_step_descriptor           varchar2(128) NULL      ,    
cmmnt                          varchar2(1000) NULL         
)                                                         
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table ref_model_run_archive (                                 
model_run_id                   number(11) NOT NULL  ,       
model_run_name                 varchar2(64) NOT NULL  ,    
model_id                       number(11) NOT NULL  ,     
date_time_loaded               date NOT NULL,
user_name                      varchar2(30) NOT NULL,
extra_keys_y_n                 varchar2(1) NOT NULL,
run_date                       date NOT NULL  ,          
start_date                     date NULL      ,      
end_date                       date NULL      ,     
hydrologic_indicator           varchar2(32) NULL,
modeltype                      varchar2(1) NULL      , 
time_step_descriptor           varchar2(128) NULL      ,    
cmmnt                          varchar2(1000) NULL         ,
archive_reason                 varchar2(10) NOT NULL,
date_time_archived             date NOT NULL,
archive_cmmnt                  varchar2(1000) NULL
)                                                         
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table ref_model_run_keyval (                                 
model_run_id                   number(11) NOT NULL  ,       
key_name                       varchar2(32) NOT NULL,
key_value                      varchar2(32) NOT NULL,
date_time_loaded               date  default SYSDATE NOT NULL
)                                                         
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table ref_model_run_keyval_archive (                                 
model_run_id                   number(11) NOT NULL  ,       
key_name                       varchar2(32) NOT NULL,
key_value                      varchar2(32) NOT NULL,
date_time_loaded               date NOT NULL,
archive_reason                 varchar2(10) NOT NULL,
date_time_archived             date NOT NULL,
archive_cmmnt                  varchar2(1000) NULL
)                                                         
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table ref_res (                          
site_id                        number(11) NOT NULL  ,   
damtype_id                     number(11) NULL      ,  
agen_id                        number(11) NULL      , 
off_id                         number(11) NULL      ,
constn_prd                     varchar2(32) NULL      , 
close_date                     date NULL      ,        
areares                        float NULL      ,      
capact                         float NULL      ,     
capded                         float NULL      ,    
capinac                        float NULL      ,   
capjnt                         float NULL      ,  
capliv                         float NULL      , 
capsur                         float NULL      ,
captot                         float NULL      ,
chlcap                         float NULL      , 
cstln                          float NULL      , 
damvol                         float NULL      ,
elevcst                        float NULL      , 
elevminp                       float NULL      ,
elevtac                        float NULL      ,
elevtic                        float NULL      , 
elevtdc                        float NULL      ,
elevtjuc                       float NULL      ,       
elevsb                         float NULL      ,      
elevtef                        float NULL      ,     
fldctrl                        float NULL      ,    
relmax                         float NULL      ,   
relmin                         float NULL      ,  
relmaxo                        float NULL      , 
relmaxp                        float NULL      ,
splmax                         float NULL      ,           
splwslelev                     float NULL      ,          
strht                          float NULL      ,         
wsemax                         float NULL               
)                                                      
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table ref_res_flowlu (                             
site_id                        number(11) NOT NULL  ,    
flow                           float NOT NULL  ,        
elevtw                         float NULL              
)                  
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);
;                       
create table ref_res_wselu (                       
site_id                        number(11) NOT NULL  ,          
wse                            float NOT NULL  ,              
areares                        float NULL      ,             
cont                           float NULL      ,            
rel                            float NULL      ,           
spl                            float NULL                 
)                                                        
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);
;                                                       

create table ref_site_attr (
site_id                        number(11) NOT NULL  ,    
attr_id                        number(11) NOT NULL  ,    
effective_start_date_time      date NOT NULL,
effective_end_date_time        date,
value                          float,
string_value                   varchar2(200),
date_value                     date,
date_time_loaded               date NOT NULL
)                                                        
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table ref_site_attr_archive (
site_id                        number(11) NOT NULL  ,    
attr_id                        number(11) NOT NULL  ,    
effective_start_date_time      date NOT NULL,
effective_end_date_time        date,
value                          float,
string_value                   varchar2(200),
date_value                     date,
date_time_loaded               date not null,
archive_reason                 varchar2(10) not null,
date_time_archived             date not null,
archive_cmmnt                  varchar2(1000)
)                                                        
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table ref_site_coef (                               
site_id                        number(11) NOT NULL  ,     
attr_id                        number(11) NOT NULL  ,    
coef_idx                       number(11) NOT NULL  ,   
effective_start_date_time      date NOT NULL,
effective_end_date_time        date,
coef                           float NOT NULL          
)                                                     
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table ref_site_coef_day (                              
site_id                        number(11) NOT NULL  ,        
attr_id                        number(11) NOT NULL  ,       
day                            number(11) NOT NULL  ,      
coef_idx                       number(11) NOT NULL  ,     
effective_start_date_time      date NOT NULL,
effective_end_date_time        date,
coef                           float NOT NULL            
)                                                       
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table ref_site_coef_month (                 
site_id                        number(11) NOT NULL  ,  
attr_id                        number(11) NOT NULL  , 
month                          number(11) NOT NULL  ,
coef_idx                       number(11) NOT NULL  ,  
effective_start_date_time      date NOT NULL,
effective_end_date_time        date,
coef                           float NOT NULL         
)                                                    
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table ref_site_coeflu (
site_id                        number(11) NOT NULL  ,
lu_attr_id                     number(11) NOT NULL  ,
lu_value                       float(126) NOT NULL  ,
attr_id                        number(11) NOT NULL  ,
coef_idx                       number(11) NOT NULL  ,
effective_start_date_time      date NOT NULL,
effective_end_date_time        date,
coef                           float(126) NOT NULL
)
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

CREATE TABLE ref_source_priority
(   site_datatype_id	NUMBER			 NOT NULL
  , agen_id		NUMBER                   NOT NULL
  , priority_rank	NUMBER			 NOT NULL
  , date_time_loaded    DATE                     NOT NULL
)
/* ref_source_priority: 
 This table contains the prioritization order for agencies that are
 sources for the same sdi. If more than one series is desired in the database, differing
 sdis should be used. If only one series is needed, the order in which agencies are
 considered for updating r_base is defined in this table.
 Lowest priority wins, ie, priority 1 wins over priority 2. 
 Multiple agencies may have the same priority, in which case the
 last one in will win.
 Agencies that are not defined in this table will always lose
 over agencies that are defined in this table.
 This table is referenced by the update_r_base_raw procedure.
*/
PCTUSED             40
PCTFREE             10
STORAGE
(
  INITIAL           50k
  NEXT              50k
  PCTINCREASE       0
)
LOGGING
TABLESPACE          hdb_data;

create table ref_source_priority_archive
   (site_datatype_id    number not null,
    agen_id             number not null,
    priority_rank       number not null,
    date_time_loaded    date not null,
    archive_reason      varchar2(10) not null,
    date_time_archived  date not null,
    archive_cmmnt       varchar2(1000)
)
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table ref_str (                             
site_id                        number(11) NOT NULL  ,    
areabas                        number(11) NULL      ,   
gagetype_id                    number(11) NULL      ,  
owner_id                       number(11) NULL        
)                                                    
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

CREATE TABLE REF_USER_GROUPS
(
USER_NAME		VARCHAR2(30) NOT NULL,
GROUP_NAME		VARCHAR2(200) NOT NULL,
ACTIVE_FLAG		VARCHAR2(1)  DEFAULT 'Y' NOT NULL,
LAST_MODIFIED_DATE	DATE
)
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

/* FEATURES */
create table hdb_property (                     
property_id                        number(11) NOT NULL  ,    
property_name                      varchar2(64) NOT NULL  , 
property_common_name               varchar2(64) NOT NULL, 
property_value_type                varchar2(10) NOT NULL  ,
unit_id                            number(11)
)                                                        
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table hdb_feature_class (                     
feature_class_id                        number(11) NOT NULL  ,    
feature_class_name                      varchar2(64) NOT NULL
)                                                      
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table hdb_feature (                     
feature_id                        number(11) NOT NULL  ,    
feature_name                      varchar2(64) NOT NULL,
feature_class_id		  number(11) NOT NULL
)                                                      
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table hdb_attr_feature (                     
attr_id                        number(11) NOT NULL  ,    
feature_class_id               number(11) NOT NULL  ,    
feature_id   	               number(11) NOT NULL  
)                                                      
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table hdb_datatype_feature (                     
datatype_id                        number(11) NOT NULL  ,    
feature_class_id                   number(11) NOT NULL  ,    
feature_id   	                   number(11) NOT NULL  
)                                                      
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table hdb_feature_property (                     
feature_id                        number(11) NOT NULL  ,    
property_id                       number(11) NOT NULL  ,    
value                             float,
string_value                      varchar2(200),
date_value                        date
)                                                        
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table hdb_rating_type (  
	rating_type_common_name varchar2(32) not null, 
	rating_type_name varchar2(64) not null, 
	rating_algorithm varchar2(32) not null, 
	indep_datatype_id number(*,0) not null, 
	dep_datatype_id number(*,0) not null, 
	description varchar2(1000) 
) 
pctfree 10 
pctused 40 
tablespace HDB_data 
storage(initial 64k  
        next 100k 
        pctincrease 0);
        
create table hdb_rating_algorithm ( 
        rating_algorithm varchar2(64) not null,  
	procedure_name varchar2(32) not null, 
	description varchar2(1000) 
) 
pctfree 10 
pctused 40 
tablespace HDB_data 
storage(initial 64k  
        next 100k  
        pctincrease 0);

create table ref_rating ( 
        rating_id number(*,0) not null, 
	independent_value number not null, 
	dependent_value number not null, 
	date_time_loaded date NOT NULL  
)  
pctfree 10 
pctused 40 
tablespace HDB_data 
storage(initial 64k 
        next 100k 
        pctincrease 0);
        
create table ref_rating_archive ( 
	RATING_ID                  NUMBER NOT NULL, 
	INDEPENDENT_VALUE          NUMBER     NOT NULL, 
	DEPENDENT_VALUE            NUMBER     NOT NULL, 
	DATE_TIME_LOADED           DATE NOT NULL, 
	ARCHIVE_REASON		       VARCHAR2(10) NOT NULL, 
	DATE_TIME_ARCHIVED	       DATE NOT NULL, 
	ARCHIVE_CMMNT		       VARCHAR2(1000) 
) 
pctfree 10 
pctused 40 
tablespace HDB_data 
storage(initial 64k 
        next 100k 
        pctincrease 0);
        
create table ref_site_rating ( 
   	rating_id number(*,0) not null, 
	indep_site_datatype_id number(*,0) not null, 
	rating_type_common_name varchar2(32) not null,  
	effective_start_date_time date, 
	effective_end_date_time date, 
	date_time_loaded date not null, 
	agen_id number(*,0) not null, 
	description varchar2(1000) 
) 
pctfree 10 
pctused 40 
tablespace HDB_data 
storage(initial 64k 
        next 100k 
        pctincrease 0);
        
create table ref_site_rating_archive ( 
	rating_id                      number not null, 
	indep_site_datatype_id         number not null, 
	rating_type_common_name        varchar2(32) not null, 
	effective_start_date_time      date, 
	effective_end_date_time        date, 
	date_time_loaded               date not null, 
	agen_id                        number not null, 
	description                    varchar2(1000)                                ,
	archive_reason				   varchar2(10) not null, 
	date_time_archived	           date not null, 
	archive_cmmnt		           varchar2(1000) 
)
pctfree 10 
pctused 40 
tablespace HDB_data 
storage(initial 64k 
        next 100k 
        pctincrease 0);

/* new table for model table  */
create table ref_installation (
	meta_data_installation_type	varchar2(32) NOT NULL 
)
pctfree 10 
pctused 40 
tablespace HDB_data 
storage(initial 64k 
        next 100k 
        pctincrease 0);

create table ref_loading_application_prop
(  LOADING_APPLICATION_ID NUMBER NOT NULL,
   PROP_NAME VARCHAR2(64) NOT NULL,
   PROP_VALUE VARCHAR2(240)
)
pctfree 10
pctused 80
tablespace HDB_data
storage (initial 50k
         next    50k
         pctincrease 0);


create table ref_spatial_relation (                     
a_site_id                        number(11) NOT NULL  ,    
b_site_id                        number(11) NOT NULL  ,    
attr_id                          number(11) NOT NULL ,
effective_start_date_time        date NOT NULL,
effective_end_date_time          date,
value                            float
)                                                      
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

        
spool off
exit;

