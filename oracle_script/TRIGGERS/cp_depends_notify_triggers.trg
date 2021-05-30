CREATE OR REPLACE TRIGGER CP_DN_PK_TRIG 
BEFORE INSERT OR UPDATE 
ON CP_DEPENDS_NOTIFY 
FOR EACH ROW 
BEGIN 
    
    /* create by M. Bogner May 2012 for the CP upgrade Phase 3.0  */
    /*
    the purpose of this trigger is to:
    
     populate the primary key through a sequence 
     update the date_time_loaded column
    
    Modified by M. Bogner July 2012 to put date_time_loaded time into same DB Time_ZONE instead of
    the system time
    Modified August 28 2012 to adjust the date time loaded back to a simple sysdate
    */

	IF inserting THEN
          /*  get the next sequence for the primary key  */
	      SELECT CP_NOTIFY_SEQUENCE.NEXTVAL INTO :NEW.RECORD_NUM FROM DUAL;
    ELSIF updating THEN 
     /*  do nothing as of now  */
     null;
    END IF; 
/* update the date_time_loaded field to a DB time_zone corrected value*/
--   :NEW.DATE_TIME_LOADED := hdb_utilities.mod_date_for_time_zone(sysdate,hdb_utilities.get_db_parameter('SERVER_TIME_ZONE'));
     :NEW.DATE_TIME_LOADED := sysdate;
END;         
                                                                                
.
/
