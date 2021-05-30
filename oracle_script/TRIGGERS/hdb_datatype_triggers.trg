CREATE OR REPLACE TRIGGER HDB_DATATYPE_PK_TRIG 
BEFORE INSERT OR UPDATE 
ON HDB_DATATYPE 
FOR EACH ROW 
BEGIN 
	IF inserting THEN 
	   IF populate_pk.pkval_pre_populated = FALSE THEN 
	      :new.DATATYPE_ID := populate_pk.get_pk_val( 'HDB_DATATYPE', FALSE );  
	   END IF;
       /* modified by M. Bogner, Sutron Corporation on 17-June_2011 to automatically 
          insert any new datatypes into the decodes datatype table to keep 
          datatype tables concurrent
       */   
       
       /* insert record into decodes.datatype table if record does not exist  */
       insert into datatype
       select :new.datatype_id,'HDB',:new.datatype_id from dual 
       minus select id,standard,id from datatype where standard = 'HDB';

    ELSIF updating THEN 
     :new.DATATYPE_ID := :old.DATATYPE_ID; 
    END IF; 
END;         
                                                                                
.
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
sys_context('USERENV', 'SESSION_USER')
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
sys_context('USERENV', 'SESSION_USER')
); 
end;                                                                    
/                                                                                                                       
show errors trigger hdb_datatype_archive_delete;  
/