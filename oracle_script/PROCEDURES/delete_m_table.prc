CREATE OR REPLACE PROCEDURE delete_m_table ( MODEL_RUN_ID_IN NUMBER,
			  SITE_DATATYPE_ID_IN NUMBER,                       
			  START_DATE_TIME_IN DATE,                                                   
			  END_DATE_TIME_IN DATE,
			  INTERVAL_IN VARCHAR2)
IS                                                                              
BEGIN                                                                           
/* The calling procedure must check that a delete is required */
   
     IF interval_in = 'hour' THEN                                                                      
       DELETE FROM M_HOUR                                                               
       WHERE model_run_id = model_run_id_in
         AND site_datatype_id = SITE_DATATYPE_ID_IN                               
         AND start_date_time = START_DATE_TIME_IN                                 
         and end_date_time = END_DATE_TIME_IN;                                    
     ELSIF interval_in = 'day' THEN                                                                      
       DELETE FROM M_DAY                                                            
       WHERE model_run_id = model_run_id_in
         AND site_datatype_id = SITE_DATATYPE_ID_IN                               
         AND start_date_time = START_DATE_TIME_IN                                 
         and end_date_time = END_DATE_TIME_IN;                                    
	NULL; 
     ELSIF interval_in = 'month' THEN                                                                      
       DELETE FROM M_MONTH                                                          
       WHERE model_run_id = model_run_id_in
         AND site_datatype_id = SITE_DATATYPE_ID_IN                               
         AND start_date_time = START_DATE_TIME_IN                                 
         and end_date_time = END_DATE_TIME_IN;                                    
	NULL; 
     ELSIF interval_in = 'wy' THEN                                                                      
       DELETE FROM M_WY                                                           
       WHERE model_run_id = model_run_id_in
         AND site_datatype_id = SITE_DATATYPE_ID_IN                               
         AND start_date_time = START_DATE_TIME_IN                                 
         and end_date_time = END_DATE_TIME_IN;                                    
	NULL; 
     ELSIF interval_in = 'year' THEN                                                                      
       DELETE FROM M_YEAR                                                          
       WHERE model_run_id = model_run_id_in
         AND site_datatype_id = SITE_DATATYPE_ID_IN                               
         AND start_date_time = START_DATE_TIME_IN                                 
         and end_date_time = END_DATE_TIME_IN;                                    
	NULL; 
     ELSE
       DENY_ACTION ('INVALID INTERVAL');
    END IF;                                                                     
END;
/

show errors;
/
create or replace public synonym delete_m_table for delete_m_table;
grant execute on delete_m_table to app_role;
grant execute on delete_m_table to savoir_faire;
grant execute on delete_m_table to model_priv_role;
