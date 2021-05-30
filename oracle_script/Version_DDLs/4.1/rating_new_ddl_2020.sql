
##### DO NOT FORGET GRANT PRIVILEGES for new TABLES #######

update ref_rating_table
set description=
(select ref_site_rating.description from ref_site_rating where ref_site_rating.site_rating_id = ref_rating_table.rating_id )
;

ALTER TABLE ref_site_rating DROP COLUMN description;
ALTER TABLE ref_site_rating_archive DROP COLUMN description;

create or replace TRIGGER ref_site_rating_arch_upd
after update on ref_site_rating for each row begin insert into ref_site_rating_archive (
SITE_RATING_ID,
INDEP_SITE_DATATYPE_ID,
RATING_TYPE_COMMON_NAME,
EFFECTIVE_START_DATE_TIME,
EFFECTIVE_END_DATE_TIME,
DATE_TIME_LOADED,
AGEN_ID,
RATING_ID,
ARCHIVE_REASON, DATE_TIME_ARCHIVED, ARCHIVE_CMMNT) values (
:old.SITE_RATING_ID,
:old.INDEP_SITE_DATATYPE_ID,
:old.RATING_TYPE_COMMON_NAME,
:old.EFFECTIVE_START_DATE_TIME,
:old.EFFECTIVE_END_DATE_TIME,
:old.DATE_TIME_LOADED,
:old.AGEN_ID,
:old.RATING_ID,
'UPDATE', sysdate, NULL); end;
/

create or replace TRIGGER ref_site_rating_arch_del
after delete on ref_site_rating for each row begin insert into ref_site_rating_archive (
SITE_RATING_ID,
INDEP_SITE_DATATYPE_ID,
RATING_TYPE_COMMON_NAME,
EFFECTIVE_START_DATE_TIME,
EFFECTIVE_END_DATE_TIME,
DATE_TIME_LOADED,
AGEN_ID,
RATING_ID,
ARCHIVE_REASON, DATE_TIME_ARCHIVED, ARCHIVE_CMMNT) values (
:old.SITE_RATING_ID,
:old.INDEP_SITE_DATATYPE_ID,
:old.RATING_TYPE_COMMON_NAME,
:old.EFFECTIVE_START_DATE_TIME,
:old.EFFECTIVE_END_DATE_TIME,
:old.DATE_TIME_LOADED,
:old.AGEN_ID,
:old.RATING_ID,
'DELETE', sysdate, NULL); end;
/

--new archive Table 
create table ref_rating_table_archive (                                  
RATING_ID NUMBER NOT NULL ENABLE,            
DESCRIPTION VARCHAR2(1000 BYTE),           
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

--Public synonyms
CREATE OR REPLACE PUBLIC SYNONYM ref_rating_table_archive FOR ref_rating_table_archive;
CREATE OR REPLACE PUBLIC SYNONYM ref_rating_table FOR ref_rating_table;
/

--Grants to Public
GRANT SELECT ON  ref_rating_table_archive to PUBLIC;
GRANT SELECT ON  ref_rating_table to PUBLIC;
/

commit;
/

--TRIGGERS
create or replace trigger ref_rating_table_arch_update                                                                    
after update on ref_rating_table 
for each row 
begin 
insert into ref_rating_table_archive (  
RATING_ID,
DESCRIPTION,
ARCHIVE_REASON, 
DATE_TIME_ARCHIVED, 
ARCHIVE_CMMNT) 
values (                                           
:old.RATING_ID,                                                                                              
:old.DESCRIPTION,                                                                                                                                                                                                                                                                                             
'UPDATE', 
sysdate, 
coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         )
); 
end;                                                                    
/                                                                                                                       
show errors trigger ref_rating_table_arch_update;                                                                         
/
                                                                                                                        
create or replace trigger ref_rating_table_arch_delete                                                                    
after delete on ref_rating_table 
for each row 
begin 
insert into ref_rating_table_archive (                     
RATING_ID,
DESCRIPTION,
ARCHIVE_REASON, 
DATE_TIME_ARCHIVED, 
ARCHIVE_CMMNT) values (                                           
:old.RATING_ID,                                                                                              
:old.DESCRIPTION,                                                                                                 
'DELETE', 
sysdate, 
coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         )
); 
end;                                                                    
/                                                                                                                       
show errors trigger ref_rating_table_arch_delete;      
/