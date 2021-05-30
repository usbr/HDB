create or replace PROCEDURE modify_r_base_raw ( SITE_DATATYPE_ID NUMBER,
			      INTERVAL VARCHAR2,
			      START_DATE_TIME DATE,
			      END_DATE_TIME IN OUT DATE,
			      VALUE FLOAT,
                  AGEN_ID NUMBER,
			      OVERWRITE_FLAG VARCHAR2,
			      VALIDATION CHAR,
                  COLLECTION_SYSTEM_ID NUMBER,
                  LOADING_APPLICATION_ID NUMBER,
                  METHOD_ID NUMBER,
                  COMPUTATION_ID NUMBER,
			      DO_UPDATE_Y_OR_N VARCHAR2,
			      DATA_FLAGS IN VARCHAR2 DEFAULT NULL,
			      TIME_ZONE        VARCHAR2 DEFAULT NULL ) IS
    TEMP_SDI R_BASE.SITE_DATATYPE_ID%TYPE;
    TEMP_INT R_BASE.INTERVAL%TYPE;
    TEMP_SDT R_BASE.START_DATE_TIME%TYPE;
    TEMP_EDT R_BASE.START_DATE_TIME%TYPE;
    START_DATE_TIME_NEW R_BASE.START_DATE_TIME%TYPE;
    END_DATE_TIME_NEW   R_BASE.END_DATE_TIME%TYPE;
    DATE_TIME_NEW       R_BASE.DATE_TIME_LOADED%TYPE;
    VALUE_NEW			R_BASE.VALUE%TYPE;
    VALIDATION_NEW		R_BASE.VALIDATION%TYPE;
    DATA_FLAGS_NEW		R_BASE.DATA_FLAGS%TYPE;
    ROWCOUNT NUMBER;
    db_timezone VARCHAR2(3);
    l_ts_id NUMBER;

BEGIN
    /*  Modified by M.  Bogner  6/21/07  to add the data quality flags column to r_base  */
    /*  Modified by M.  Bogner  8/28/07  to used the standardize dates procedure         */
    /*  Modified by M.  Bogner  10/27/08  to add the call to the pre-processor procedure */
	/*  Modified by M.  Bogner  06/01/2009 to add mods to accept different time_zone parameter */ 
	/*  Modified by M.  Bogner  10/01/2011 to add mods to check for ACL II permissions */ 
	/*  Modified by M.  Bogner  05/23/2012 to add Phase 3.0 mod to add entry to CP_TS_ID Table */ 
    /*  Modified by K. Cavalier 29-APR-2016 to move Validation and Data Flag Checking Code from R_BASE_BEFORE_INSERT_UPDATE Trigger to here to avoid unnecessary duplicate archives  */

  	/* see if ACL PROJECT II is enabled and if user is permitted */
	IF (hdb_utilities.is_feature_activated('ACCESS CONTROL LIST GROUP VERSION II') = 'Y' AND 
	    hdb_utilities.IS_SDI_IN_ACL(SITE_DATATYPE_ID) <> 'Y' ) THEN
   		DENY_ACTION('ILLEGAL ACL VERSION II MODIFY_R_BASE_RAW OPERATION -- No Permissions To Modify Data');
    END IF;
        
    /*  First check for any null field that where passed  */
    IF SITE_DATATYPE_ID IS NULL THEN DENY_ACTION ( 'INVALID <NULL> SITE_DATATYPE_ID' );
	ELSIF INTERVAL IS NULL THEN DENY_ACTION ( 'INVALID <NULL> INTERVAL' );
	ELSIF START_DATE_TIME IS NULL THEN DENY_ACTION ( 'INVALID <NULL> START_DATE_TIME' );
	ELSIF VALUE IS NULL THEN DENY_ACTION ( 'INVALID <NULL> VALUE' );
	ELSIF AGEN_ID IS NULL THEN DENY_ACTION ( 'INVALID <NULL> AGEN_ID' );
	ELSIF COLLECTION_SYSTEM_ID IS NULL THEN DENY_ACTION ( 'INVALID <NULL> COLLECTION_SYSTEM_ID' );
	ELSIF LOADING_APPLICATION_ID IS NULL THEN DENY_ACTION ( 'INVALID <NULL> LOADING_APPLICATION_ID' );
	ELSIF METHOD_ID IS NULL THEN DENY_ACTION ( 'INVALID <NULL> METHOD_ID' );
	ELSIF COMPUTATION_ID IS NULL THEN DENY_ACTION ( 'INVALID <NULL> COMPUTATION_ID' );
    END IF;

   /* for phase 3.0 add this record to the CP_TS_ID table if it isn't already there  */
   /* this procedure call added for Phase 3.0 project                                */
   CP_PROCESSOR.create_ts_id (SITE_DATATYPE_ID,INTERVAL,'R_',-1,l_ts_id);

   /* Now call the procedure to standardize the dates to one single date representation  */
   START_DATE_TIME_NEW := START_DATE_TIME;
   END_DATE_TIME_NEW := END_DATE_TIME;
   VALUE_NEW := VALUE;
   VALIDATION_NEW := VALIDATION;
   DATA_FLAGS_NEW := DATA_FLAGS;


/* get the databases default time zone  */
    BEGIN
      select param_value into db_timezone
        from ref_db_parameter, global_name
        where param_name = 'TIME_ZONE'
        and global_name.global_name = ref_db_parameter.global_name
        and nvl(active_flag,'Y') = 'Y';
       exception when others then 
       db_timezone := NULL;
    END;

   /* now convert the start_time to the database time if different, both exist, 
   and only for the instantaneous and hourly interval           */
   IF (TIME_ZONE <> db_timezone AND INTERVAL in ('instant','hour')) THEN
     
       START_DATE_TIME_NEW:= new_time(START_DATE_TIME_NEW,TIME_ZONE,db_timezone);
       END_DATE_TIME_NEW:= new_time(END_DATE_TIME_NEW,TIME_ZONE,db_timezone);
     
   END IF;

   HDB_UTILITIES.STANDARDIZE_DATES(
       SITE_DATATYPE_ID,
       INTERVAL,
       START_DATE_TIME_NEW,
       END_DATE_TIME_NEW);
 
    /* set the END_DATE_TIME for calling APPLICATION  */
    END_DATE_TIME := END_DATE_TIME_NEW;

	/* Call the preprocessor if the validation is not a "V"   */
	IF ( nvl(VALIDATION,'x') != 'V') THEN
		PRE_PROCESSOR.PREPROCESSOR ( 
			SITE_DATATYPE_ID,
			INTERVAL,
			START_DATE_TIME_NEW,
			VALUE_NEW,
			VALIDATION_NEW,
			DATA_FLAGS_NEW);
	END IF;

/* Moved Validation and Data Flag Checking Code from R_BASE_BEFORE_INSERT_UPDATE Trigger to here 
     to avoid unnecessary duplicate archives -kcavalier 29-APR-2016 */
  
  -- Moves legacy validation codes to data flags
  IF VALIDATION_NEW in ('E','+','-','w','n','|','^','~',chr(32)) then
     DATA_FLAGS_NEW := VALIDATION_NEW || substr(DATA_FLAGS_NEW,1,19);
     VALIDATION_NEW := NULL;
  end if;
  
  -- Validate the data before it goes into the table
  if (nvl(VALIDATION_NEW,'Z') in ('Z')) then
    hdb_utilities.validate_r_base_record
      (site_datatype_id,
       interval,
       START_DATE_TIME_NEW,
       VALUE_NEW,
       VALIDATION_NEW);
  end if;
  /* End of Move Validation Code */

    /*  go see if a record already exists ; if not do an insert otherwise do an update as long as do_update <> 'N'  */
    /*  Default date time of ADA Byron birthdate to indicate record came through procedures  */
    DATE_TIME_NEW := to_date('10-DEC-1815','dd-MON-yyyy');
    TEMP_SDI := SITE_DATATYPE_ID;
    TEMP_INT := INTERVAL;
    TEMP_SDT := START_DATE_TIME_NEW;
    TEMP_EDT := END_DATE_TIME_NEW;
    SELECT count ( * )
      INTO rowcount
      FROM r_base
     WHERE site_datatype_id = TEMP_SDI
       AND INTERVAL = TEMP_INT
       AND start_date_time = TEMP_SDT
       and end_date_time = TEMP_EDT;
    IF rowcount = 0 THEN
	/* insert the data into the database  */
	INSERT_R_BASE ( SITE_DATATYPE_ID,
			INTERVAL,
			START_DATE_TIME_NEW,
			END_DATE_TIME_NEW,
			VALUE_NEW,
			AGEN_ID,
			OVERWRITE_FLAG,
			VALIDATION_NEW,
			COLLECTION_SYSTEM_ID,
			LOADING_APPLICATION_ID,
			METHOD_ID,
			COMPUTATION_ID,
			DATA_FLAGS_NEW,
			DATE_TIME_NEW );
  /*  update the data into the database, if desired */
	ELSIF rowcount > 1 THEN
           DENY_ACTION ( 'RECORD with SDI: ' || to_char ( SITE_DATATYPE_ID ) ||
           ' INTERVAL: ' || INTERVAL || ' START_DATE_TIME: ' || to_char ( start_date_time,
           'dd-MON-yyyy HH24:MI:SS' ) || ' END_DATE_TIME: '|| to_char ( end_date_time_new,
           'dd-MON-yyyy HH24:MI:SS' ) || ' HAS MULTIPLE ENTRIES. DANGER! DANGER! DANGER!.' );
        ELSIF UPPER ( NVL ( DO_UPDATE_Y_OR_N,           
			    'Y' ) ) = 'Y' THEN UPDATE_R_BASE_RAW ( SITE_DATATYPE_ID,
							       INTERVAL,
							       START_DATE_TIME_NEW,
							       END_DATE_TIME_NEW,
							       VALUE_NEW,
							       AGEN_ID,
							       OVERWRITE_FLAG,
							       VALIDATION_NEW,
							       COLLECTION_SYSTEM_ID,
							       LOADING_APPLICATION_ID,
							       METHOD_ID,
							       COMPUTATION_ID,
							       DATA_FLAGS_NEW,
							       DATE_TIME_NEW );
    END IF;

END;
/


show errors;
/
create or replace public synonym modify_r_base_raw for modify_r_base_raw;
grant execute on modify_r_base_raw to app_role;
grant execute on modify_r_base_raw to savoir_faire;

