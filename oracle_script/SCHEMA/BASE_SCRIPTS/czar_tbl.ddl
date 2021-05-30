/* Create tables that are only at czar */
create table ref_hdb_installation (                     
db_site_db_name            varchar2(25) NOT NULL,
db_site_code               varchar2(3) NOT NULL,
is_czar_db                 varchar2(1) NOT NULL
)                                                      
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

create table ref_phys_quan_refresh_monitor (
db_site_db_name            varchar2(25),
message                    varchar2(1000),
success_code               number(1)
)                                                      
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

/* Create tables that are snapshots on slave */
create table hdb_physical_quantity (
physical_quantity_name     varchar2(64) NOT NULL,
dimension_id               number(11) NOT NULL,
customary_unit_id          number(11) NOT NULL
)                                                      
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

/* Changed 9/8 to work with DECODES: common_name to 24, add family */
create table hdb_unit (                              
unit_id                        number(11) NOT NULL  ,   
unit_name                      varchar2(32) NOT NULL  ,  
unit_common_name               varchar2(24)  NOT NULL, 
dimension_id                   number(11) NOT NULL  ,    
base_unit_id                   number(11) NOT NULL  ,   
month_year                     char(1) NULL      ,     
over_month_year                char(1) NULL      ,    
is_factor                      number(11) NOT NULL  ,
mult_factor                    float NULL      ,    
from_stored_expression         varchar2(64) NULL      ,    
to_stored_expression           varchar2(64) NULL          ,
family                         varchar2(24) NULL
)                                                        
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);


create table hdb_dimension (              
dimension_id                   number(11) NOT NULL  ,    
dimension_name                 varchar2(32) NOT NULL    
)                                                      
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 50k
         next 50k
         pctincrease 0);

