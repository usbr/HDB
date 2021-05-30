PROMPT CREATE or REPLACE PROCEDURE update_r_base_raw

create or replace PROCEDURE update_r_base_raw ( SITE_DATATYPE_ID_IN NUMBER,
			  INTERVAL_IN VARCHAR2,
			  START_DATE_TIME_IN DATE,
			  END_DATE_TIME_IN DATE,
			  VALUE_IN FLOAT,
			  AGEN_ID_IN NUMBER,
			  OVERWRITE_FLAG_IN VARCHAR2,
			  VALIDATION_IN CHAR,
			  COLLECTION_SYSTEM_ID_IN NUMBER,
			  LOADING_APPLICATION_ID_IN NUMBER,
			  METHOD_ID_IN NUMBER,
			  COMPUTATION_ID_IN NUMBER,
			  DATA_FLAGS_IN VARCHAR2,
			  DATE_TIME_IN DATE )
IS
old_priority number := 0;
new_priority NUMBER := 0;
old_value FLOAT := 0;
old_overwrite_flag VARCHAR2 (1);
old_validation CHAR;
old_collection_system_id NUMBER;
old_loading_application_id NUMBER;
old_method_id NUMBER;
old_computation_id NUMBER;
old_data_flags R_BASE.DATA_FLAGS%TYPE;
epsilon FLOAT := 1E-7;
do_update boolean := false;
data_changed boolean := false;
BEGIN
    /*  Modified by M.  Bogner  6/21/07  to add the data quality flags column to r_base */
    /*  Modified by M.  Bogner  11/19/07  to remove the manual edit criteria */
    /*  Modified by M.  Bogner  05/22/08  to keep old records from update when previous data coming in  */
    /*  Modified by M.  Bogner  07/28/08  to allow overwrites to go in regardless  */
    /*  Modified by M.  Bogner  10/26/08  to allow overwrites to to be removed by same application  */
    
/* The calling procedure must check that an update is required, and that only one row is affected. */
/* Data priority determination. */
/* Old and new priorities default to 0, if no priorities are found in the following queries,
   then the priority of the old data and new data will be considered equal.
   This means that data from an agency with a defined priority will not overwrite data from an agency without priority.
*/
    begin
	select nvl(priority_rank,0)
          into new_priority
	  from ref_source_priority
	 where site_datatype_id = SITE_DATATYPE_ID_IN
	   and agen_id = AGEN_ID_IN;
 	exception when others THEN new_priority := 0; /*not an error to not have entry for this agency and sdi*/
    end;

    begin /* get the old foreign keys and priorities */
        SELECT nvl(priority_rank,0), a.value, nvl(a.overwrite_flag,'N'),
               nvl(a.validation,'x'), a.collection_system_id, a.loading_application_id,
               a.method_id, a.computation_id, nvl(a.data_flags,'x')
    	  INTO old_priority, old_value, old_overwrite_flag,
    	       old_validation, old_collection_system_id, old_loading_application_id,
    	       old_method_id, old_computation_id, old_data_flags
    	  FROM r_base a, ref_source_priority b
    	 WHERE a.site_datatype_id = site_datatype_id_in
    	   AND a.INTERVAL = interval_in
    	   AND a.start_date_time = start_date_time_in
    	   and a.end_date_time = END_DATE_TIME_IN
    	   and a.agen_id = b.agen_id(+)
    	   and a.site_datatype_id = b.site_datatype_id(+);
    end;

   /* check to see if any real major data columns have been modified */
   IF ( abs(old_value - value_in) > epsilon    -- and value is different (difference larger than epsilon!
        or nvl(overwrite_flag_in,'N') != old_overwrite_flag  -- or one of the foreign keys (except agen_id) is different
        or collection_system_id_in != old_collection_system_id
        or loading_application_id_in != old_loading_application_id
        or method_id_in != old_method_id
        or computation_id_in != old_computation_id ) then
     data_changed := true;  
   END IF;                          

/* DO THE UPDATE IF:*/
    IF (nvl(overwrite_flag_in,'N') = 'O'                    -- the new record is now an overwrite
    OR  (old_overwrite_flag = 'N'                           -- the old was not
	    and ((new_priority < old_priority                   -- and the new priority is higher (closer to 0) than the old
                  and new_priority > 0)                         -- but not 0, since 0 is default or no priority
                 or (new_priority = old_priority                -- or agencies have same priority
                     AND ( data_changed
                          or nvl(validation_in,'x') != old_validation
                          or nvl(data_flags_in,'x') != old_data_flags )
                    )
                )
        )
       )         
    then
      do_update := true;
    END IF;

   /* check to see if this is just a call from the same application to change the overwrite flag */
   IF ( data_changed                                         -- obviously something is different record 
		and NOT do_update                                    -- but did not pass all the overwirites and priorities
        and abs(old_value - value_in) <= epsilon             -- and the value is the same
        and nvl(overwrite_flag_in,'N') != old_overwrite_flag  -- only the overwrite_flag is different
        and collection_system_id_in = old_collection_system_id -- and the rest of the identifiers are the same
        and loading_application_id_in = old_loading_application_id
        and method_id_in = old_method_id
        and computation_id_in = old_computation_id 
        and nvl(overwrite_flag_in,'N') != 'O' )
      then
     /* then this is a call to just change the overwrite flag back to nothing, so allow it */
     do_update := true;
   END IF;                          

/* now check to see if the only difference coming in was based on Hydromet data movements and the
   validation code may have changed via validation. This modification done 22 May 2008 to fix
   issues where we were updating r_base but the only reason was we previously validated, or moved the 
   hydromet codes to the data_flags column when really the exact same input data was received  */
/*   
  IF ( do_update 
       and abs(old_value - value_in) <= epsilon
       and NOT data_changed 
       and nvl(validation_in,'x') in ('Z','E','+','-','w','n','|','^','~','x')
       and old_validation in ('V','F','L','H','x'))  THEN
     do_update := false;
  END IF;*/   

  /* after all the checks above then do update if do_update boolean is still true  */
  IF (do_update) THEN
    UPDATE R_BASE
       SET value = VALUE_IN,
	   agen_id = AGEN_ID_IN,
	   overwrite_flag = OVERWRITE_FLAG_IN,
	   validation = VALIDATION_IN,
	   collection_system_id = COLLECTION_SYSTEM_ID_IN,
	   loading_application_id = LOADING_APPLICATION_ID_IN,
	   method_id = METHOD_ID_IN,
	   computation_id = COMPUTATION_ID_IN,
	   data_flags = DATA_FLAGS_IN,
	   date_time_loaded = DATE_TIME_IN
     WHERE site_datatype_id = SITE_DATATYPE_ID_IN
       AND interval = INTERVAL_IN
       AND start_date_time = START_DATE_TIME_IN
       and end_date_time = END_DATE_TIME_IN;
   END IF;

END;
/

/* This procedure does not have execute permissions granted on purpose
   Only modify_r_base_raw should call it.  */

show errors;


