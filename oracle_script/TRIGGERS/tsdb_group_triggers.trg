
CREATE OR REPLACE TRIGGER TSDB_GROUP_CUD_TRIG 
after INSERT OR UPDATE OR DELETE 
ON TSDB_GROUP
FOR EACH ROW 
declare
  l_group_id   NUMBER;
  BEGIN 
    
    /* create by M. Bogner May 15 2012 for the CP upgrade Phase 3.0  */
    /*
    the purpose of this trigger is to:
     insert a record into cp_notify depends to signal a computation group record change/creation/deletion
    Modified July 23 2012 By M. Bogner to mod the sysdate to the DB time zone.
    */

 	IF inserting  OR updating THEN
	      l_group_id := :NEW.group_id;
    ELSIF deleting THEN 
	      l_group_id := :OLD.group_id;
    END IF;   
  
  /* for PHASE 3.0 a change in a TSDB_GROUP will trigger a notification to address CP_COMP_DEPENDS */
  insert into cp_depends_notify (record_num,event_type,key,date_time_loaded) values (-1,'G',l_group_id,
  hdb_utilities.mod_date_for_time_zone(sysdate,hdb_utilities.get_db_parameter('SERVER_TIME_ZONE')));

END;                                                                                         
.
/