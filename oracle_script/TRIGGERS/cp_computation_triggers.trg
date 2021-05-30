
create or replace trigger cp_comp_insertupdate                                                                    
before insert or update on cp_computation 
for each row 
begin 
/*  This trigger created by M.  Bogner  05/11/2012
    This trigger the cp_comp_depends notification for any
    inserts to the table cp_computation.
    Modified July 23 2012 to adjust the date time loaded to the DB time zone
    Modified August 28 2012 to adjust the date time loaded back to a simple sysdate
*/
--   :NEW.DATE_TIME_LOADED := hdb_utilities.mod_date_for_time_zone(sysdate,hdb_utilities.get_db_parameter('SERVER_TIME_ZONE'));
     :NEW.DATE_TIME_LOADED := sysdate;
   
end;
/

create or replace trigger cp_computation_insert                                                                    
after insert on cp_computation 
for each row 
begin 
/*  This trigger created by M.  Bogner  05/11/2012
    This trigger the cp_comp_depends notification for any
    inserts to the table cp_computation.
    Modified August 28 2012 to adjust the date time loaded back to a simple sysdate
*/

  /* for PHASE 3.0 a change in Computation will trigger a notification to address CP_COMP_DEPENDS */
  insert into cp_depends_notify (record_num,event_type,key,date_time_loaded) values (-1,'C',:NEW.COMPUTATION_ID,sysdate);
--  hdb_utilities.mod_date_for_time_zone(sysdate,hdb_utilities.get_db_parameter('SERVER_TIME_ZONE')));
-- removed Aug 2012 to change back to a simpel sysdate

end;
/

create or replace trigger cp_computation_update                                                                    
after update on cp_computation 
for each row 
begin 
/*  This trigger created by M.  Bogner  04/05/2006
    modified by M. Bogner 05/11/2012 to add the cp_depends_notify logic
    This trigger archives any updates to the table
    cp_computation.
    Modified August 28 2012 to adjust the date time loaded back to a simple sysdate
	    
    updated to add GROUP_ID,DB_OFFICE_CODE columns in archive table by IsmailO. 08/26/2019
*/

/* for PHASE 3.0 a change in computation will trigger a notification to adress CP_COMP_DEPENDS */
insert into cp_depends_notify (record_num,event_type,key,date_time_loaded) values (-1,'C',:NEW.COMPUTATION_ID,sysdate);
-- hdb_utilities.mod_date_for_time_zone(sysdate,hdb_utilities.get_db_parameter('SERVER_TIME_ZONE')));
-- removed Aug 2012 to change back to a simpel sysdate

insert into cp_computation_archive (                     
   COMPUTATION_ID,
   COMPUTATION_NAME,
   ALGORITHM_ID,
   CMMNT,
   LOADING_APPLICATION_ID,
   DATE_TIME_LOADED,
   ENABLED,
   EFFECTIVE_START_DATE_TIME,
   EFFECTIVE_END_DATE_TIME,
   ARCHIVE_REASON,
   DATE_TIME_ARCHIVED,
   ARCHIVE_CMMNT,
   GROUP_ID,
   DB_OFFICE_CODE
) 
values (                                           
   :old.COMPUTATION_ID,
   :old.COMPUTATION_NAME,
   :old.ALGORITHM_ID,
   :old.CMMNT,
   :old.LOADING_APPLICATION_ID,
   :old.DATE_TIME_LOADED,
   :old.ENABLED,
   :old.EFFECTIVE_START_DATE_TIME,
   :old.EFFECTIVE_END_DATE_TIME,
   'UPDATE', 
   sysdate,
   NULL,
   :old.GROUP_ID,
   :old.DB_OFFICE_CODE); 
-- the following removed from the archive insert and replaced with simple sysdate
--   hdb_utilities.mod_date_for_time_zone(sysdate,hdb_utilities.get_db_parameter('SERVER_TIME_ZONE')), 

end;                                                                    
/                                                                                                                       
show errors trigger cp_computation_update;                                                                         

                                                                                                                        
create or replace trigger cp_computation_delete                                                                    
after delete on cp_computation 
for each row 
begin 
/*  This trigger created by M.  Bogner  04/05/2006
    modified by M. Bogner 05/15/2012 to add the cp_depends_notify logic
    This trigger archives any deletes to the table
    cp_computation.
    Modified August 28 2012 to adjust the date time loaded back to a simple sysdate
	
    updated to add GROUP_ID,DB_OFFICE_CODE columns in archive table by IsmailO. 08/26/2019
*/

  /* for PHASE 3.0 a change in Computation will trigger a notification to address CP_COMP_DEPENDS */
  insert into cp_depends_notify (record_num,event_type,key,date_time_loaded) values (-1,'C',:OLD.COMPUTATION_ID,sysdate);
-- the following removed from the archive insert and replaced with simple sysdate
--  hdb_utilities.mod_date_for_time_zone(sysdate,hdb_utilities.get_db_parameter('SERVER_TIME_ZONE')));

insert into cp_computation_archive (                     
   COMPUTATION_ID,
   COMPUTATION_NAME,
   ALGORITHM_ID,
   CMMNT,
   LOADING_APPLICATION_ID,
   DATE_TIME_LOADED,
   ENABLED,
   EFFECTIVE_START_DATE_TIME,
   EFFECTIVE_END_DATE_TIME,
   ARCHIVE_REASON,
   DATE_TIME_ARCHIVED,
   ARCHIVE_CMMNT,
   GROUP_ID,
   DB_OFFICE_CODE
) 
values (                                           
   :old.COMPUTATION_ID,
   :old.COMPUTATION_NAME,
   :old.ALGORITHM_ID,
   :old.CMMNT,
   :old.LOADING_APPLICATION_ID,
   :old.DATE_TIME_LOADED,
   :old.ENABLED,
   :old.EFFECTIVE_START_DATE_TIME,
   :old.EFFECTIVE_END_DATE_TIME,
   'DELETE',
   sysdate, 
   NULL,
   :old.GROUP_ID,
   :old.DB_OFFICE_CODE); 
-- the following removed from the archive insert and replaced with simple sysdate
--   hdb_utilities.mod_date_for_time_zone(sysdate,hdb_utilities.get_db_parameter('SERVER_TIME_ZONE')), 
end;                                                                    
/                                                                                                                       
show errors trigger cp_computation_delete;                                                                         

