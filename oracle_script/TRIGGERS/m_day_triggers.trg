CREATE OR REPLACE TRIGGER m_day_after_insert_update
AFTER INSERT OR UPDATE ON M_DAY FOR EACH ROW 
declare       
  l_count	NUMBER;
  l_db_link VARCHAR2(128);
  l_model_run_id NUMBER := 0;
  l_table_name VARCHAR2(10) := 'M_DAY';
  l_interval VARCHAR2(16) := 'day';
  l_delete_flag VARCHAR2(1) := 'N';
                                                                    
  CURSOR is_rec_a_parameter(sdi NUMBER, sdt DATE, mri NUMBER) IS  
  select site_datatype_id, loading_application_id, interval, table_selector,
  model_id, computation_id,computation_name,algorithm_id,algorithm_name
  from cp_active_sdi_tsparm_view
  where site_datatype_id = sdi
  and table_selector = 'M_'
  and interval = 'day'
  and sdt between effective_start_date_time and effective_end_date_time
  and model_id in (select model_id from ref_model_run where model_run_id = mri);
                                                                                 
BEGIN                                                                           

  /*  this trigger written by M. Bogner  APRIL 2006
      the purpose of this trigger is to place rows into the cp_comp_tasklist table when
      Model Data has been received into this interval table 
      and this data is defined as an input parameter of an
      active calculation  */

  /* modified by M. Bogner Jan 2008 to add procedure call to do additional processing  */
  /* modified by M. Bogner May 2010 to add procedure call to do remote calc processing  */
    
/*  now go see if there are any active computation definitions for this record      */
/*  if there are records from this cursor then put all records from the cursor
    into the cp_comp_task_list table                                                */

  FOR p1 IN is_rec_a_parameter(:new.site_datatype_id, :new.start_date_time, :new.model_run_id) LOOP
    
    insert into cp_comp_tasklist(
    record_num, loading_application_id,
    site_datatype_id,interval,table_selector,
    value,date_time_loaded,start_date_time,delete_flag,model_run_id
    )
    values (
    cp_tasklist_sequence.nextval,p1.loading_application_id,
    p1.site_datatype_id,p1.interval,p1.table_selector,
    :new.value,sysdate,:new.start_date_time,'N',:new.model_run_id
    );
   
   /* now run the procedure to do additional processing for computations  */
   hdb_utilities.COMPUTATIONS_PROCESSING
           (p1.loading_application_id, p1.site_datatype_id, p1.interval, :new.start_date_time, 
            p1.table_selector, p1.computation_id, p1.computation_name, p1.algorithm_id, 
            p1.algorithm_name, :new.model_run_id, 'N', '');
    
   END LOOP;
 
  l_model_run_id := :new.model_run_id;
  /* check for remote computation triggering if this is a remote computation */
  /* then call the procedure to trigger the remote computation               */
  select count(*), min(db_link) into l_count, l_db_link 
  from cp_active_remote_sdi_view
	where site_datatype_id = :new.site_datatype_id 
	  and table_name = l_table_name 
	  and :new.start_date_time between effective_start_date_time and effective_end_date_time;

  IF l_count > 0 THEN
    cp_remote_trigger.trigger_remote_cp(l_db_link,:new.site_datatype_id,l_interval,:new.start_date_time,
		l_model_run_id,:new.value,null,null,l_delete_flag);   
  END IF;
   
END;  /*  end of insert update interval table trigger  */                                                                            
/                                                                               
show errors trigger m_day_after_insert_update;

CREATE OR REPLACE TRIGGER m_day_after_delete
AFTER DELETE ON M_DAY FOR EACH ROW 
declare       
  l_count	NUMBER;
  l_db_link VARCHAR2(128);
  l_model_run_id NUMBER := 0;
  l_table_name VARCHAR2(10) := 'M_DAY';
  l_interval VARCHAR2(16) := 'day';
  l_delete_flag VARCHAR2(1) := 'Y';
                                                                    
  CURSOR is_rec_a_parameter(sdi NUMBER, sdt DATE, mri NUMBER) IS  
  select site_datatype_id, loading_application_id, interval, table_selector,
  model_id, computation_id,computation_name,algorithm_id,algorithm_name
  from cp_active_sdi_tsparm_view
  where site_datatype_id = sdi
  and table_selector = 'M_'
  and interval = 'day'
  and sdt between effective_start_date_time and effective_end_date_time
  and model_id in (select model_id from ref_model_run where model_run_id = mri);
  
                                                                                 
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

  FOR p1 IN is_rec_a_parameter(:old.site_datatype_id, :old.start_date_time, :old.model_run_id) LOOP
    
    insert into cp_comp_tasklist(
    record_num, loading_application_id,
    site_datatype_id,interval,table_selector,
    value,date_time_loaded,start_date_time,delete_flag,model_run_id
    )
    values (
    cp_tasklist_sequence.nextval,p1.loading_application_id,
    p1.site_datatype_id,p1.interval,p1.table_selector,
    :old.value,sysdate,:old.start_date_time,'Y',:old.model_run_id
    );
   
   /* now run the procedure to do additional processing for computations  */
   hdb_utilities.COMPUTATIONS_PROCESSING
           (p1.loading_application_id, p1.site_datatype_id, p1.interval, :old.start_date_time, 
            p1.table_selector, p1.computation_id, p1.computation_name, p1.algorithm_id, 
            p1.algorithm_name, :old.model_run_id, 'Y', '');
    
   END LOOP;
 
  l_model_run_id := :old.model_run_id;   
  /* check for remote computation triggering if this is a remote computation */
  /* then call the procedure to trigger the remote computation               */
  select count(*), min(db_link) into l_count, l_db_link 
  from cp_active_remote_sdi_view
	where site_datatype_id = :old.site_datatype_id 
	  and table_name = l_table_name 
	  and :old.start_date_time between effective_start_date_time and effective_end_date_time;

  IF l_count > 0 THEN
    cp_remote_trigger.trigger_remote_cp(l_db_link,:old.site_datatype_id,l_interval,:old.start_date_time,
		l_model_run_id,:old.value,null,null,l_delete_flag);   
  END IF;
    
END;  /*  end of delete interval table trigger  */                                                                            
/                                                                               
show errors trigger m_day_after_delete;
