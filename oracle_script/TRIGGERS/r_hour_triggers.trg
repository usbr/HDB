
create or replace trigger r_hour_before_insert_update
before             insert OR update 
on                r_hour
for   each row
declare
  v_manual_edit   varchar2(1);
begin
    
    /* modified by M.  Bogner 08/31/07  */
    /*
    the purpose of this trigger is to check to see if the
    insert or the update to this table was a result of a manual sql command or
    through the normal r_base triggers route. if it is a manual edit then the 
    M is appended to  the derivatiuon flag and the date_time_loaded is modified
    to sysdate
    */
    
    v_manual_edit := hdb_utilities.get_manual_edit();
    
    if (v_manual_edit = 'Y') then
      :new.derivation_flags := substr(:new.derivation_flags,1,19) || 'M';
      :new.date_time_loaded := sysdate;
    end if;

end;
/
show errors trigger r_hour_before_insert_update;


CREATE OR REPLACE TRIGGER r_hour_after_insert_update
AFTER INSERT OR UPDATE ON R_HOUR FOR EACH ROW 
declare      
  l_count	NUMBER;
  l_db_link VARCHAR2(128);
  l_model_run_id NUMBER := 0;
  l_table_name VARCHAR2(10) := 'R_HOUR';
  l_interval VARCHAR2(16) := 'hour';
  l_delete_flag VARCHAR2(1) := 'N';
                                                                    
  CURSOR is_rec_a_parameter(sdi NUMBER, sdt DATE) IS  
  select site_datatype_id, loading_application_id, interval, table_selector,
  model_id, computation_id,computation_name,algorithm_id,algorithm_name
  from cp_active_sdi_tsparm_view
  where site_datatype_id = sdi
  and table_selector = 'R_'
  and interval = 'hour'
  and sdt between effective_start_date_time and effective_end_date_time;
                                                                                 
BEGIN                                                                           

  /*  this trigger written by M. Bogner  APRIL 2006
      the purpose of this trigger is to place rows into the cp_comp_tasklist table when
      Data has been received into this interval table 
      and this data is defined as an input parameter of an
      active calculation  */

  /* modified by M. Bogner Jan 2008 to add procedure call to do additional processing  */
  /* modified by M. Bogner May 2010 to add procedure call to do remote calc processing  */   

/*  now go see if there are any active computation definitions for this record      */
/*  if there are records from this cursor then put all records from the cursor
    into the cp_comp_task_list table                                                */

  FOR p1 IN is_rec_a_parameter(:new.site_datatype_id, :new.start_date_time) LOOP
    
    insert into cp_comp_tasklist(
    record_num, loading_application_id,
    site_datatype_id,interval,table_selector,
    value,date_time_loaded,start_date_time,delete_flag,model_run_id,validation,data_flags
    )
    values (
    cp_tasklist_sequence.nextval,p1.loading_application_id,
    p1.site_datatype_id,p1.interval,p1.table_selector,
    :new.value,sysdate,:new.start_date_time,'N',0,:new.validation,:new.derivation_flags
    );

   /* now run the procedure to do additional processing for computations  */
   hdb_utilities.COMPUTATIONS_PROCESSING
           (p1.loading_application_id, p1.site_datatype_id, p1.interval, :new.start_date_time, 
            p1.table_selector, p1.computation_id, p1.computation_name, p1.algorithm_id, 
            p1.algorithm_name, 0, 'N', :new.derivation_flags);
        
   END LOOP;
   
  /* check for remote computation triggering if this is a remote computation */
  /* then call the procedure to trigger the remote computation               */
  select count(*), min(db_link) into l_count, l_db_link 
  from cp_active_remote_sdi_view
	where site_datatype_id = :new.site_datatype_id 
	  and table_name = l_table_name 
	  and :new.start_date_time between effective_start_date_time and effective_end_date_time;

  IF l_count > 0 THEN
    cp_remote_trigger.trigger_remote_cp(l_db_link,:new.site_datatype_id,l_interval,:new.start_date_time,
		l_model_run_id,:new.value,:new.validation,:new.derivation_flags,l_delete_flag);   
  END IF;
   
END;  /*  end of insert update interval table trigger  */                                                                            
/                                                                               
show errors trigger r_hour_after_insert_update;

CREATE OR REPLACE TRIGGER r_hour_after_delete
AFTER DELETE ON R_HOUR FOR EACH ROW 
declare      
  l_count	NUMBER;
  l_db_link VARCHAR2(128);
  l_model_run_id NUMBER := 0;
  l_table_name VARCHAR2(10) := 'R_HOUR';
  l_interval VARCHAR2(16) := 'hour';
  l_delete_flag VARCHAR2(1) := 'Y';
                                                                    
  CURSOR is_rec_a_parameter(sdi NUMBER, sdt DATE) IS  
  select site_datatype_id, loading_application_id, interval, table_selector,
  model_id, computation_id,computation_name,algorithm_id,algorithm_name
  from cp_active_sdi_tsparm_view
  where site_datatype_id = sdi
  and table_selector = 'R_'
  and interval = 'hour'
  and sdt between effective_start_date_time and effective_end_date_time;
                                                                                 
BEGIN                                                                           

  /*  this trigger written by M. Bogner  APRIL 2006
      the purpose of this trigger is to place rows into the cp_comp_tasklist table when
      a row in this interval table has been deleted 
      and this data is defined as an input parameter of an
      active calculation  */

  /* modified by M. Bogner Jan 2008 to add procedure call to do additional processing  */
  /* modified by M. Bogner May 2010 to add procedure call to do remote calc processing  */
      
/*  now go see if there are any active computation definitions for this record      */
/*  if there are records from this cursor then put all records from the cursor
    into the cp_comp_task_list table                                                */

  FOR p1 IN is_rec_a_parameter(:old.site_datatype_id, :old.start_date_time) LOOP
    
    insert into cp_comp_tasklist(
    record_num, loading_application_id,
    site_datatype_id,interval,table_selector,
    value,date_time_loaded,start_date_time,delete_flag,model_run_id,validation,data_flags
    )
    values (
    cp_tasklist_sequence.nextval,p1.loading_application_id,
    p1.site_datatype_id,p1.interval,p1.table_selector,
    :old.value,sysdate,:old.start_date_time,'Y',0,:old.validation,:old.derivation_flags
    );
    
   /* now run the procedure to do additional processing for computations  */
   hdb_utilities.COMPUTATIONS_PROCESSING
           (p1.loading_application_id, p1.site_datatype_id, p1.interval, :old.start_date_time, 
            p1.table_selector, p1.computation_id, p1.computation_name, p1.algorithm_id, 
            p1.algorithm_name, 0, 'Y', :old.derivation_flags);
    
   END LOOP;
   
  /* check for remote computation triggering if this is a remote computation */
  /* then call the procedure to trigger the remote computation               */
  select count(*), min(db_link) into l_count, l_db_link 
  from cp_active_remote_sdi_view
	where site_datatype_id = :old.site_datatype_id 
	  and table_name = l_table_name 
	  and :old.start_date_time between effective_start_date_time and effective_end_date_time;

  IF l_count > 0 THEN
    cp_remote_trigger.trigger_remote_cp(l_db_link,:old.site_datatype_id,l_interval,:old.start_date_time,
		l_model_run_id,:old.value,:old.validation,:old.derivation_flags,l_delete_flag);   
  END IF;
    
END;  /*  end of delete interval table trigger  */                                                                            
/                                                                               
show errors trigger r_hour_after_delete;


