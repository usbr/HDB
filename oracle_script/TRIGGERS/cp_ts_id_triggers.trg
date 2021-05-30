CREATE OR REPLACE TRIGGER CP_TSID_PK_TRIG 
BEFORE INSERT OR UPDATE 
ON CP_TS_ID
FOR EACH ROW 
declare
  l_count            number;
  l_text               varchar2(200);
BEGIN 
    
    /* create by M. Bogner May 2012 for the CP upgrade Phase 3.0  */
    /* modified by M. Bogner July 2012 for the sanity check and valid intervals checks */
    /*
    the purpose of this trigger is to:
    
     check to see if the row is a possible valid interval for the datatype used
     check to see if the entries are valid based on table_selector
     populate the primary key through a sequence 
     update the date_time_loaded column
     Modified July 23 2012 by M. Bogner to use a sysdate modified to the DB time zone

/* update the PK from the sequence for a new record insertion  */
	IF inserting THEN
	      SELECT CP_TS_ID_SEQUENCE.NEXTVAL INTO :NEW.TS_ID FROM DUAL;
    ELSIF updating THEN 
     /*  do nothing as of now  */
     null;
    END IF; 
  
  /* set the date_time_loaded column for this record to the sysdate modified to the databases time zone */
/* modified the date_time_loaded function to go back to using the simple sysdate  
--  :new.date_time_loaded := hdb_utilities.mod_date_for_time_zone(sysdate,hdb_utilities.get_db_parameter('SERVER_TIME_ZONE'));
*/
   :new.date_time_loaded := sysdate;
 

   if (:new.table_selector = 'M_' and :new.model_id < 1) then
      deny_action ('Invalid model_id: ' || to_char(:new.model_id) || '  for MODELED TS Identifier');
   end if;
 
   if (:new.table_selector = 'R_' and :new.model_id > 0 ) then
      deny_action ('Invalid model_id: ' || to_char(:new.model_id) || '   for REAL TS Identifier');
   end if;

  
   
END;                                                                                         
.
/

CREATE OR REPLACE TRIGGER CP_TSID_CUD_TRIG 
after INSERT OR UPDATE OR DELETE 
ON CP_TS_ID
FOR EACH ROW 
declare
  l_ts_id   NUMBER;
  BEGIN 
    
    /* create by M. Bogner May 2012 for the CP upgrade Phase 3.0  */
    /*
    the purpose of this trigger is to:
     insert a record into cp_notify depends to signal a time series record change/creation/deletion
    */

 	IF inserting  OR updating THEN
	      l_ts_id := :NEW.ts_id;
    ELSIF deleting THEN 
	      l_ts_id := :OLD.ts_id;
    END IF;   
  
  /* for PHASE 3.0 a change in a TIME SERIES will trigger a notification to address CP_COMP_DEPENDS */
  insert into cp_depends_notify (record_num,event_type,key,date_time_loaded) values (-1,'T',l_ts_id,sysdate);
  /* moved back to using a simplified sysdate for date_time_loaded on 28-AUG-2012
    hdb_utilities.mod_date_for_time_zone(sysdate,hdb_utilities.get_db_parameter('SERVER_TIME_ZONE')));
  */
END;                                                                                         
.
/
