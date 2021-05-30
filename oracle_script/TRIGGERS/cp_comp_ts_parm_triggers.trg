
create or replace trigger cp_comp_ts_parm_update                                                                    
after update or update on cp_comp_ts_parm 
for each row 
DECLARE 
temp_computation_id cp_computation.computation_id%TYPE;
begin 
/*  This trigger created by M.  Bogner  04/05/2006
    This trigger archives any updates to the table
    cp_comp_ts_parm.
    
    updated 5/19/2008 by M. Bogner to update the date_time_loaded
    column of cp_computation table
	
	updated to add DATATYPE_ID,DELTA_T_UNITS,SITE_ID columns in archive table by IsmailO. 08/27/2019
*/
temp_computation_id := :new.computation_id;

IF (UPDATING) THEN
  temp_computation_id := :old.computation_id;

  insert into cp_comp_ts_parm_archive (                     
   COMPUTATION_ID,
   ALGO_ROLE_NAME,
   SITE_DATATYPE_ID,
   INTERVAL,
   TABLE_SELECTOR,
   DELTA_T,
   MODEL_ID,
   ARCHIVE_REASON,
   DATE_TIME_ARCHIVED,
   ARCHIVE_CMMNT,
   DATATYPE_ID,
   DELTA_T_UNITS,
   SITE_ID
) 
values (                                           
  :old.COMPUTATION_ID,
  :old.ALGO_ROLE_NAME,
  :old.SITE_DATATYPE_ID,
  :old.INTERVAL,
  :old.TABLE_SELECTOR,
  :old.DELTA_T,
  :old.MODEL_ID,
  'UPDATE', 
  sysdate, 
  NULL,
  :old.DATATYPE_ID,
  :old.DELTA_T_UNITS,
  :old.SITE_ID); 
END IF;

/* now update parent table's date_time_loaded for sql statements issued on this table */ 
  hdb_utilities.touch_cp_computation(temp_computation_id);

end;                                                                    
/                                                                                                                       
show errors trigger cp_comp_ts_parm_update;                                                                         

                                                                                                                        
create or replace trigger cp_comp_ts_parm_delete                                                                    
after delete on cp_comp_ts_parm 
for each row 
begin 
/*  This trigger created by M.  Bogner  04/05/2006
    This trigger archives any deletes to the table
    cp_comp_ts_parm.
    
    updated 5/19/2008 by M. Bogner to update the date_time_loaded
    collumn of cp_computation table
	
	updated to add DATATYPE_ID,DELTA_T_UNITS,SITE_ID columns in archive table by IsmailO. 08/27/2019
*/
insert into cp_comp_ts_parm_archive (                     
   COMPUTATION_ID,
   ALGO_ROLE_NAME,
   SITE_DATATYPE_ID,
   INTERVAL,
   TABLE_SELECTOR,
   DELTA_T,
   MODEL_ID,
   ARCHIVE_REASON,
   DATE_TIME_ARCHIVED,
   ARCHIVE_CMMNT,
   DATATYPE_ID,
   DELTA_T_UNITS,
   SITE_ID
) 
values (                                           
  :old.COMPUTATION_ID,
  :old.ALGO_ROLE_NAME,
  :old.SITE_DATATYPE_ID,
  :old.INTERVAL,
  :old.TABLE_SELECTOR,
  :old.DELTA_T,
  :old.MODEL_ID,
  'DELETE', 
  sysdate, 
  NULL,
  :old.DATATYPE_ID,
  :old.DELTA_T_UNITS,
  :old.SITE_ID); 

/* now update parent table's date_time_loaded for sql statements issued on this table */ 
  hdb_utilities.touch_cp_computation(:old.computation_id);
end;                                                                    
/                                                                                                                       
show errors trigger cp_comp_ts_parm_delete;                                                                         

