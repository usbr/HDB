  CREATE OR REPLACE TRIGGER HDB_SITE_DATATYPE_PK_TRIG
  BEFORE INSERT OR UPDATE ON HDB_SITE_DATATYPE
  REFERENCING FOR EACH ROW
  BEGIN IF inserting THEN IF populate_pk.pkval_pre_populated = FALSE THEN :new.SITE_DATATYPE_ID := populate_pk.get_pk_val( 'HDB_SITE_DATATYPE', FALSE );  END IF; ELSIF updating THEN :new.SITE_DATATYPE_ID := :old.SITE_DATATYPE_ID; END IF; END;
/

show errors trigger HDB_SITE_DATATYPE_PK_TRIG;
/

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
sys_context('USERENV', 'SESSION_USER')
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
sys_context('USERENV', 'SESSION_USER')
); 
end;                                                                    
/                                                                                                                       
show errors trigger hdb_site_datatype_arch_delete;  
/
