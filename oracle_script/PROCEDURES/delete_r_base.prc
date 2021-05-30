CREATE OR REPLACE PROCEDURE delete_r_base ( SITE_DATATYPE_ID_IN NUMBER,                       
			  INTERVAL_IN VARCHAR2,                                                      
			  START_DATE_TIME_IN DATE,                                                   
			  END_DATE_TIME_IN DATE,                                                     
			  AGEN_ID_IN NUMBER,                                                         
			  LOADING_APPLICATION_ID_IN NUMBER)                                                 
IS                                                                              
old_agen_id NUMBER;   
old_loading_application_id NUMBER;
old_priority number := 0;                                                       
new_priority NUMBER := 0;
old_overwrite_flag VARCHAR2(1);
                                                       
BEGIN                                                                           

/* The calling procedure must check that a delete is required */
/* modified 29-November-2007 by M. Bogner to take out manual editing feature
   and to not raise exception if a delete was issued and no record existed  */
/* Modified 10-AUG-2011 by M. Bogner to not allow any deletion for a record 
   with the overwrite flag set  */
                                                                                
/* Data priority determination - delete the database row only if
   --  (both old and new rows have priority, and new is higher (closer to 0)
   --   OR new row has the same agen_id as the old row)) */

                                                                                
    BEGIN
	select nvl(priority_rank,0)
          into new_priority                                                     
	  from ref_source_priority                                                     
	 where site_datatype_id = SITE_DATATYPE_ID_IN                                  
	   and agen_id = AGEN_ID_IN;                                                   
 	exception when others THEN null; /*not an error to not have entry for this agency and sdi*/                                                                   
                                                                                
    end;                                                                        

    begin /* get the old agency and priority and the overwrite flag` */ 
          /* if overrwite flag is null then return a 'N'             */                        
        SELECT nvl(b.priority_rank,0), a.agen_id, a.loading_application_id, nvl(a.overwrite_flag,'N')
    	  INTO old_priority, old_agen_id, old_loading_application_id, old_overwrite_flag
    	  FROM r_base a, ref_source_priority b                                     
    	 WHERE a.site_datatype_id = site_datatype_id_in                            
    	   AND a.INTERVAL = interval_in                                            
    	   AND a.start_date_time = start_date_time_in                              
    	   and a.end_date_time = END_DATE_TIME_IN                                  
    	   and a.agen_id = b.agen_id(+)                                            
    	   and a.site_datatype_id = b.site_datatype_id(+);                         
       exception when others THEN null; /*not an error to attempt to delete something that doesn't exist  */
    end;                                                                        
	
                                                                        
/* DO THE DELETE IF:*/                                                          
	 IF (( old_overwrite_flag = 'N') AND (((old_priority >= new_priority) AND (old_priority > 0 and new_priority > 0)) OR 
 	   (agen_id_in = old_agen_id)))
     THEN
	 BEGIN
      DELETE FROM R_BASE                                                               
      WHERE site_datatype_id = SITE_DATATYPE_ID_IN                               
       AND interval = INTERVAL_IN                                              
       AND start_date_time = START_DATE_TIME_IN                                 
       and end_date_time = END_DATE_TIME_IN;                                    
      exception when others THEN null; /*not an error to attempt to delete something that doesn't exist  */
     END;  /* begin of the delete statement */

    ELSE                                                                        
	NULL; /* delete was not done*/                                                 
    END IF;                                                                     
                                                                                
END;
/
 
show errors;
/
create or replace public synonym delete_r_base for delete_r_base;
grant execute on delete_r_base to app_role;
 