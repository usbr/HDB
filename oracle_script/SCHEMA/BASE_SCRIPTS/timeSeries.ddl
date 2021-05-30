/* NOTE that all extents in this file assume *no* initial data load.
   If the table will have data, you must calculate accordingly or performance
   will be *bad*. Change table, PK and index creation statements only for
   those tables which will have an initial data load.

*/
     
set echo on
set feedback on
spool hdb_timeseries.out

create table m_day (                                        
model_run_id                   number(11) NOT NULL  ,      
site_datatype_id               number(11) NOT NULL  ,     
start_date_time                date NOT NULL,   
end_date_time                  date NOT NULL,   
value                          float NOT NULL           
)                                                      
pctfree 10
pctused 80
tablespace HDB_data
storage (initial 100k
         next    100k
         pctincrease 0)
;                       

ALTER TABLE m_day
      ADD ( CONSTRAINT m_day_pk
            PRIMARY KEY (model_run_id, site_datatype_id, start_date_time) using index storage (initial 80k next 80k pctincrease 0) tablespace hdb_idx);

create index m_day_date_idx
on m_day(start_date_time)
tablespace HDB_idx
storage(initial 70k next 70k pctincrease 0)
;

create table m_hour (                                            
model_run_id                   number(11) NOT NULL  ,           
site_datatype_id               number(11) NOT NULL  ,          
start_date_time                date NOT NULL,   
end_date_time                  date NOT NULL,   
value                          float NOT NULL                
)                                                           
pctfree 10
pctused 80
tablespace HDB_data
storage (initial 100k
         next    100k
         pctincrease 0)
;                       

ALTER TABLE m_hour    
      ADD ( CONSTRAINT m_hour_pk 
            PRIMARY KEY (model_run_id, site_datatype_id, start_date_time) using index storage (initial 80k next 80k pctincrease 0) tablespace hdb_idx);

create index m_hour_date_idx
on m_hour(start_date_time)
tablespace HDB_idx
storage(initial 70k next 70k pctincrease 0)
;

create table m_month (                                               
model_run_id                   number(11) NOT NULL  ,               
site_datatype_id               number(11) NOT NULL  ,              
start_date_time                date NOT NULL,   
end_date_time                  date NOT NULL,   
value                          float NOT NULL                    
)                                                               
pctfree 10
pctused 80
tablespace HDB_data
storage (initial 100k
         next    100k
         pctincrease 0)
;                       
ALTER TABLE m_month       
      ADD ( CONSTRAINT m_month_pk 
            PRIMARY KEY (model_run_id, site_datatype_id, start_date_time) using index storage (initial 80k next 80k pctincrease 0) tablespace hdb_idx); 

create index m_month_date_idx
on m_month(start_date_time)
tablespace HDB_idx
storage(initial 70k next 70k pctincrease 0)
;

create table m_monthrange (                 
model_run_id                   number(11) NOT NULL  ,   
site_datatype_id               number(11) NOT NULL  ,  
start_date_month               date NOT NULL  ,       
end_date_month                 date NOT NULL  ,      
value                          float NOT NULL       
)                                                  
pctfree 10
pctused 80
tablespace HDB_data
storage (initial 100k
         next    100k
         pctincrease 0)
;                        

ALTER TABLE m_monthrange               
      ADD ( CONSTRAINT m_monthrange_pk 
            PRIMARY KEY (model_run_id,site_datatype_id,
                         start_date_month) using index storage (initial 80k next 80k pctincrease 0) tablespace hdb_idx); 

create index m_monthrange_date_idx
on m_monthrange(start_date_month, end_date_month)
tablespace HDB_idx
storage(initial 70k next 70k pctincrease 0)
;

create table m_monthstat (                       
model_run_id                   number(11) NOT NULL  ,     
site_datatype_id               number(11) NOT NULL  ,    
month                          number(11) NOT NULL  ,   
value                          float NOT NULL          
)                                                     
pctfree 10
pctused 80
tablespace HDB_data
storage (initial 100k
         next    100k
         pctincrease 0)
;                        

ALTER TABLE m_monthstat
      ADD ( CONSTRAINT m_monthstat_pk
            PRIMARY KEY (model_run_id,site_datatype_id,month ) using index storage (initial 80k next 80k pctincrease 0) tablespace hdb_idx); 

create index m_monthstat_date_idx
on m_monthstat(month)
tablespace HDB_idx
storage(initial 70k next 70k pctincrease 0)
;

create table m_wy (                                  
model_run_id                   number(11) NOT NULL  ,      
site_datatype_id               number(11) NOT NULL  ,     
start_date_time                date NOT NULL,   
end_date_time                  date NOT NULL,   
value                          float NOT NULL          
)                                                     
pctfree 10
pctused 80
tablespace HDB_data
storage (initial 100k
         next    100k
         pctincrease 0)
;                        

ALTER TABLE m_wy                         
      ADD ( CONSTRAINT m_wy_pk
            PRIMARY KEY (model_run_id, site_datatype_id, start_date_time) using index storage (initial 80k next 80k pctincrease 0) tablespace hdb_idx);

create index m_wy_date_idx
on m_wy(start_date_time)
tablespace HDB_idx
storage(initial 70k next 70k pctincrease 0)
;

create table m_year (                                          
model_run_id                   number(11) NOT NULL  ,         
site_datatype_id               number(11) NOT NULL  ,        
start_date_time                date NOT NULL,   
end_date_time                  date NOT NULL,   
value                          float NOT NULL              
)                                                         
pctfree 10
pctused 80
tablespace HDB_data
storage (initial 100k
         next    100k
         pctincrease 0)
;                        

ALTER TABLE m_year
      ADD ( CONSTRAINT m_year_pk
            PRIMARY KEY (model_run_id, site_datatype_id, start_date_time) using index storage (initial 80k next 80k pctincrease 0) tablespace hdb_idx);  

create index m_year_date_idx
on m_year(start_date_time)
tablespace HDB_idx
storage(initial 70k next 70k pctincrease 0)
;

create table r_base
   (site_datatype_id             number NOT NULL,
    interval                     varchar2(16) NOT NULL,
    start_date_time              date NOT NULL,
    end_date_time                date NOT NULL,
    value                        float NOT NULL,
    agen_id                      number NOT NULL,
    overwrite_flag               varchar2(1),
    date_time_loaded             date,
    validation                   char(1),
    collection_system_id         number NOT NULL,
    loading_application_id       number NOT NULL,
    method_id                    number NOT NULL,
    computation_id               number NOT NULL,
    data_flags                   varchar2(20)
   )
pctfree 10
pctused 80
tablespace HDB_data
storage (initial 100k
         next    100k
         pctincrease 0)
;                       

alter table r_base add (constraint
    r_base_pk
    primary key (site_datatype_id, interval,
                 start_date_time,end_date_time)
using index storage(initial 70k next 70k pctincrease 0) tablespace HDB_idx);


create index r_base_date_idx
on r_base(start_date_time)
tablespace HDB_idx
storage(initial 70k next 70k pctincrease 0)
;

create index r_base_enddate_idx
on r_base(end_date_time)
tablespace HDB_idx
storage(initial 70k next 70k pctincrease 0)
;
 
create table r_base_archive
   (site_datatype_id             number NOT NULL,
    interval                     varchar2(16) NOT NULL,
    start_date_time              date NOT NULL,
    end_date_time                date NOT NULL,
    value                        number NOT NULL,
    agen_id                      number,
    overwrite_flag               varchar2(1),
    date_time_loaded             date,
    validation                   char(1),
    collection_system_id         number,
    loading_application_id       number,
    method_id                    number,
    computation_id               number,
    archive_reason               varchar2(10) not null,
    date_time_archived           date not null,
    data_flags                   varchar2(20)
   );

create index r_base_archive_idx
on r_base_archive(site_datatype_id,interval,start_date_time,end_date_time)
tablespace HDB_idx
storage(initial 70k next 70k pctincrease 0)
;


/* removed 2008 for cp project
-- rem create table r_base_update
   (site_datatype_id             number NOT NULL,
    interval                     varchar2(16) NOT NULL,
    start_date_time              date NOT NULL,
    end_date_time                date NOT NULL,
    overwrite_flag               varchar2(1),
    ready_for_delete             varchar2(1)
   );
-- rem alter table r_base_update add (constraint
    r_base_update_pk
    primary key (site_datatype_id, interval,
                 start_date_time,end_date_time)
using index storage(initial 70k next 70k pctincrease 0) tablespace HDB_idx);
*/

create table r_day (                           
site_datatype_id               number(11) NOT NULL,
start_date_time                date NOT NULL,   
end_date_time                  date NOT NULL,   
date_time_loaded               date NOT NULL,
value                          float NOT NULL, 
source_id                      number(11),  
validation                     char(1), 
overwrite_flag                 varchar2(1),
method_id                      number,
derivation_flags               varchar2(20)
)                                                    
pctfree 10
pctused 80
tablespace HDB_data
storage (initial 100k
         next    100k
         maxextents unlimited
         pctincrease 0)
;                       

ALTER TABLE r_day
      ADD ( CONSTRAINT r_day_pk
            PRIMARY KEY (site_datatype_id,start_date_time) using index storage (initial 80k next 80k pctincrease 0) tablespace hdb_idx);  

create index r_day_date_idx
on r_day(start_date_time)
tablespace HDB_idx
storage(initial 70k next 70k pctincrease 0)
;

create table r_daystat (                                           
site_datatype_id               number(11) NOT NULL  ,             
day                            number(11) NOT NULL  ,            
value                          float NOT NULL  ,                
source_id                      number(11) NOT NULL             
)                                                             
pctfree 10
pctused 80
tablespace HDB_data
storage (initial 100k
         next    100k
         pctincrease 0)
;                        

ALTER TABLE r_daystat
      ADD ( CONSTRAINT r_daystat_pk
            PRIMARY KEY (site_datatype_id,day) using index storage (initial 80k next 80k pctincrease 0) tablespace hdb_idx);  

create index r_daystat_date_idx
on r_daystat(day)
tablespace HDB_idx
storage(initial 70k next 70k pctincrease 0)
;

create table r_hour (                           
site_datatype_id               number(11) NOT NULL,
start_date_time                date NOT NULL,   
end_date_time                  date NOT NULL,   
date_time_loaded               date NOT NULL,
value                          float NOT NULL, 
source_id                      number(11),  
validation                     char(1), 
overwrite_flag                 varchar2(1),
method_id                      number,
derivation_flags               varchar2(20)
)                                                    
pctfree 10
pctused 80
tablespace HDB_data
storage (initial 100k
         next    100k
         maxextents unlimited
         pctincrease 0)
;                       

ALTER TABLE r_hour
      ADD ( CONSTRAINT r_hour_pk
            PRIMARY KEY (site_datatype_id,start_date_time) using index storage (initial 80k next 80k pctincrease 0) tablespace hdb_idx);

create index r_hour_date_idx
on r_hour(start_date_time)
tablespace HDB_idx
storage(initial 70k next 70k pctincrease 0)
;

create table r_hourstat (                             
site_datatype_id               number(11) NOT NULL  ,
hour                           number(11) NOT NULL  ,    
value                          float NOT NULL  ,        
source_id                      number(11) NOT NULL     
)                                                     
pctfree 10
pctused 80
tablespace HDB_data
storage (initial 100k
         next    100k
         pctincrease 0)
;                       

ALTER TABLE r_hourstat   
      ADD ( CONSTRAINT r_hourstat_pk
            PRIMARY KEY (site_datatype_id,hour) using index storage (initial 80k next 80k pctincrease 0) tablespace hdb_idx); 

create index r_hourstat_date_idx
on r_hourstat(hour)
tablespace HDB_idx
storage(initial 70k next 70k pctincrease 0)
;

create table r_instant (                           
site_datatype_id               number(11) NOT NULL,
start_date_time                date NOT NULL,   
end_date_time                  date NOT NULL,   
date_time_loaded               date NOT NULL,
value                          float NOT NULL, 
source_id                      number(11),  
validation                     char(1), 
overwrite_flag                 varchar2(1),
method_id                      number,
derivation_flags               varchar2(20)
)                                                    
pctfree 10
pctused 80
tablespace HDB_data
storage (initial 1024k
         next    1024k
         pctincrease 0)
;                       

ALTER TABLE r_instant
      ADD ( CONSTRAINT r_instant_pk
            PRIMARY KEY (site_datatype_id, start_date_time)
            using index storage (initial 80k next 80k pctincrease 0)
            tablespace hdb_idx); 

create index r_instant_date_idx
on r_instant(start_date_time)
tablespace HDB_idx
storage(initial 70k next 70k pctincrease 0)
;


create table r_month (                           
site_datatype_id               number(11) NOT NULL,
start_date_time                date NOT NULL,   
end_date_time                  date NOT NULL,   
date_time_loaded               date NOT NULL,
value                          float NOT NULL, 
source_id                      number(11),  
validation                     char(1), 
overwrite_flag                 varchar2(1),
method_id                      number,
derivation_flags               varchar2(20)
)                                                    
pctfree 10
pctused 80
tablespace HDB_data
storage (initial 100k
         next    100k
         maxextents unlimited
         pctincrease 0)
;                       
ALTER TABLE r_month      
      ADD ( CONSTRAINT r_month_pk
            PRIMARY KEY (site_datatype_id,start_date_time) using index storage (initial 80k next 80k pctincrease 0) tablespace hdb_idx);   

create index r_month_date_idx
on r_month(start_date_time)
tablespace HDB_idx
storage(initial 70k next 70k pctincrease 0)
;

create table r_monthstat (                              
site_datatype_id               number(11) NOT NULL  ,  
month                          number(11) NOT NULL  , 
value                          float NOT NULL  ,     
source_id                      number(11) NOT NULL  
)                                                  
pctfree 10
pctused 80
tablespace HDB_data
storage (initial 100k
         next    100k
         pctincrease 0)
;                       

ALTER TABLE r_monthstat
      ADD ( CONSTRAINT r_monthstat_pk
            PRIMARY KEY (site_datatype_id,month ) using index storage (initial 80k next 80k pctincrease 0) tablespace hdb_idx);

create index r_monthstat_date_idx
on r_monthstat(month)
tablespace HDB_idx
storage(initial 70k next 70k pctincrease 0)
;

create table r_monthstatrange (                       
site_datatype_id               number(11) NOT NULL  ,
start_month                    number(11) NOT NULL  ,     
end_month                      number(11) NOT NULL  ,    
value                          float NOT NULL  ,        
source_id                      number(11) NOT NULL     
)                                                     
pctfree 10
pctused 80
tablespace HDB_data
storage (initial 100k
         next    100k
         pctincrease 0)
;                       

ALTER TABLE r_monthstatrange         
      ADD ( CONSTRAINT r_monthstatrange_pk
          PRIMARY KEY (site_datatype_id,start_month,end_month) using index storage (initial 80k next 80k pctincrease 0) tablespace hdb_idx);  

create index r_monthstatrange_date_idx
on r_monthstatrange(start_month, end_month)
tablespace HDB_idx
storage(initial 70k next 70k pctincrease 0)
;

create table r_wy (                           
site_datatype_id               number(11) NOT NULL,
start_date_time                date NOT NULL,   
end_date_time                  date NOT NULL,   
date_time_loaded               date NOT NULL,
value                          float NOT NULL, 
source_id                      number(11),  
validation                     char(1), 
overwrite_flag                 varchar2(1),
method_id                      number,
derivation_flags               varchar2(20)
)                                                    
pctfree 10
pctused 80
tablespace HDB_data
storage (initial 100k
         next    100k
         maxextents unlimited
         pctincrease 0)
;                       

ALTER TABLE r_wy    
      ADD ( CONSTRAINT r_wy_pk 
            PRIMARY KEY (site_datatype_id,start_date_time) using index storage (initial 80k next 80k pctincrease 0) tablespace hdb_idx);   

create index r_wy_date_idx
on r_wy(start_date_time)
tablespace HDB_idx
storage(initial 70k next 70k pctincrease 0)
;

create table r_wystat (                                         
site_datatype_id               number(11) NOT NULL  ,          
wy                             number(11) NOT NULL  ,         
value                          float NOT NULL  ,             
source_id                      number(11) NOT NULL          
)                                                          
pctfree 10
pctused 80
tablespace HDB_data
storage (initial 100k
         next    100k
         pctincrease 0)
;                      

ALTER TABLE r_wystat
      ADD ( CONSTRAINT r_wystat_pk
            PRIMARY KEY (site_datatype_id,wy) using index storage (initial 70k next 80k pctincrease 0) tablespace hdb_idx); 

create index r_wystat_date_idx
on r_wystat(wy)
tablespace HDB_idx
storage(initial 70k next 70k pctincrease 0)
;


create table r_year (                           
site_datatype_id               number(11) NOT NULL,
start_date_time                date NOT NULL,   
end_date_time                  date NOT NULL,   
date_time_loaded               date NOT NULL,
value                          float NOT NULL, 
source_id                      number(11),  
validation                     char(1), 
overwrite_flag                 varchar2(1),
method_id                      number,
derivation_flags               varchar2(20)
)                                                    
pctfree 10
pctused 80
tablespace HDB_data
storage (initial 100k
         next    100k
         maxextents unlimited
         pctincrease 0)
;                       

ALTER TABLE r_year
      ADD ( CONSTRAINT r_year_pk 
            PRIMARY KEY (site_datatype_id,start_date_time) using index storage (initial 80k next 80k pctincrease 0) tablespace hdb_idx);  

create index r_year_date_idx
on r_year(start_date_time)
tablespace HDB_idx
storage(initial 70k next 70k pctincrease 0)
;

create table r_yearstat (                                    
site_datatype_id               number(11) NOT NULL  ,       
year                           number(11) NOT NULL  ,      
value                          float NOT NULL  ,          
source_id                      number(11) NOT NULL       
)                                                       
pctfree 10
pctused 80
tablespace HDB_data
storage (initial 100k
         next    100k
         pctincrease 0)
;                        

ALTER TABLE r_yearstat
      ADD ( CONSTRAINT r_yearstat_pk
            PRIMARY KEY (site_datatype_id,year) using index storage (initial 80k next 80k pctincrease 0) tablespace hdb_idx);  

create index r_yearstat_date_idx
on r_yearstat(year)
tablespace HDB_idx
storage(initial 70k next 70k pctincrease 0)
;

create table r_other (                           
site_datatype_id               number(11) NOT NULL,
start_date_time                date NOT NULL,   
end_date_time                  date NOT NULL,   
date_time_loaded               date NOT NULL,
value                          float NOT NULL, 
source_id                      number(11),  
validation                     char(1), 
overwrite_flag                 varchar2(1),
method_id                      number,
derivation_flags               varchar2(20)
)                                                    
pctfree 10
pctused 80
tablespace HDB_data
storage (initial 1024k
         next    1024k
         pctincrease 0)
;                       

ALTER TABLE r_other
      ADD ( CONSTRAINT r_other_pk
            PRIMARY KEY (site_datatype_id, start_date_time, end_date_time)
            using index storage (initial 80k next 80k pctincrease 0)
            tablespace hdb_idx); 

create index r_other_date_idx
on r_other(start_date_time)
tablespace HDB_idx
storage(initial 70k next 70k pctincrease 0)
;


spool off
exit;
