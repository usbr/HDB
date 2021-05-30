CREATE OR REPLACE TRIGGER DB_GENERIC_LIST_PK_TRIG 
BEFORE INSERT OR UPDATE 
ON REF_DB_GENERIC_LIST
FOR EACH ROW 
declare
  l_count            number;
  l_text               varchar2(200);
BEGIN 
    
    /* create by M. Bogner May 2013 for the UC SNAPSHOT_MANAGER project  */
    /*
    the purpose of this trigger is to:
    
     populate the primary key through a sequence 
     update the date_time_loaded column
 
/* update the PK from the sequence for a new record insertion  */
	IF inserting THEN
	      SELECT REF_DB_GENERIC_LIST_SEQUENCE.NEXTVAL INTO :NEW.RECORD_ID FROM DUAL;
    ELSIF updating THEN 
     /*  do nothing as of now  */
     null;
    END IF; 
  
   :new.date_time_loaded := sysdate;
END;                                                                                         
.
/
