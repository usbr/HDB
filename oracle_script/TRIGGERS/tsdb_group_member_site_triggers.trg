
CREATE OR REPLACE TRIGGER TSDB_GMSITE_CUD_TRIG 
after INSERT OR UPDATE OR DELETE 
ON TSDB_GROUP_MEMBER_SITE
FOR EACH ROW 
declare
  l_group_id   NUMBER;
  BEGIN 
    
    /* create by M. Bogner May 15 2012 for the CP upgrade Phase 3.0  */
    /*
    the purpose of this trigger is to:
     Modify the parent tsdb_group record to signal a computation group record change/creation/deletion
     to the cp_depends_notify table
    */

 	IF inserting  OR updating THEN
	      l_group_id := :NEW.group_id;
    ELSIF deleting THEN 
	      l_group_id := :OLD.group_id;
    END IF;   
  
  /* for PHASE 3.0 a change in a TSDB_GROUP_MEMBER_SITE will modify the parent TSDB_GROUP table in order
     to trigger a notification to the CP_DEPENDS_NOTIFY table */
    begin
     /* update the parent table if it exists */
     update TSDB_GROUP set db_office_code = db_office_code where group_id = l_group_id; 
     exception when others then null;
    end;
    
END;                                                                                         
.
/