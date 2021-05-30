create or replace
PROCEDURE DELETE_FROM_HDB (
			      SAMPLE_SDI            NUMBER,
			      SAMPLE_DATE_TIME      DATE,
			      SAMPLE_END_TIME       DATE,
                  SAMPLE_INTERVAL       VARCHAR2,
                  LOADING_APP_ID        NUMBER,
                  MODELRUN_ID           NUMBER,
                  AGENCY_ID             NUMBER DEFAULT 33, /* see loading application */
				  TIME_ZONE				VARCHAR2 DEFAULT NULL
)  IS

/*  This procedure was written to be the generic interface to
    delete records from either r_BASE or the model tables in
    HDB from the COMPUTATION application
    this procedure written by Mark Bogner   November 2006          */

/* modified 8/28/07  by M.  Bogner to bring procedure up to date with stated goals  */
/* modified 11/21/07 by M. Bogner to use standardized dates on delete  */
/* modified 5/8/08   by A. Gilmore to use agency_id as parameter  */
/* Modified 06/01/09 by M. Bogner to add mods to accept different time_zone parameter */ 

    /*  first declare all internal variables need for call to delete_r_base
        and to delete_m_table                                               */
    SITE_DATATYPE_ID       R_BASE.SITE_DATATYPE_ID%TYPE;
    INTERVAL               R_BASE.INTERVAL%TYPE;
    START_DATE_TIME        R_BASE.START_DATE_TIME%TYPE;
    END_DATE_TIME          R_BASE.END_DATE_TIME%TYPE;
    AGEN_ID                R_BASE.AGEN_ID%TYPE;
    LOADING_APPLICATION_ID R_BASE.LOADING_APPLICATION_ID%TYPE;
    MODEL_RUN_ID           M_DAY.MODEL_RUN_ID%TYPE;
    db_timezone VARCHAR2(3);

BEGIN

    /*  First check for any required fields that where passed in as NULL  */
    IF SAMPLE_SDI IS NULL THEN DENY_ACTION ( 'INVALID <NULL> SAMPLE_SDI' );
	ELSIF SAMPLE_DATE_TIME IS NULL THEN DENY_ACTION ( 'INVALID <NULL> SAMPLE_DATE_TIME' );
--	ELSIF SAMPLE_END_TIME IS NULL THEN DENY_ACTION ( 'INVALID <NULL> SAMPLE_END_TIME' );
	ELSIF SAMPLE_INTERVAL IS NULL THEN DENY_ACTION ( 'INVALID <NULL> SAMPLE_INTERVAL' );
	ELSIF LOADING_APP_ID IS NULL THEN DENY_ACTION ( 'INVALID <NULL> LOADING_APP_ID' );
	ELSIF MODELRUN_ID IS NULL THEN DENY_ACTION ( 'INVALID <NULL> MODELRUN_ID' );
    END IF;

    /*  now set the variables for the data input parameters     */
    SITE_DATATYPE_ID := SAMPLE_SDI;
    START_DATE_TIME := SAMPLE_DATE_TIME;
    END_DATE_TIME := SAMPLE_END_TIME;
    LOADING_APPLICATION_ID := LOADING_APP_ID;
    MODEL_RUN_ID := MODELRUN_ID;
    INTERVAL :=  SAMPLE_INTERVAL;
    AGEN_ID := AGENCY_ID;

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
       START_DATE_TIME := new_time(START_DATE_TIME,TIME_ZONE,db_timezone);
       END_DATE_TIME := new_time(END_DATE_TIME,TIME_ZONE,db_timezone);
	END IF;
	
   /* Now call the procedure to standardize the dates to one single date representation  */
   HDB_UTILITIES.STANDARDIZE_DATES(
       SITE_DATATYPE_ID,
       INTERVAL,
       START_DATE_TIME,
       END_DATE_TIME);

    /*  now we should have passed all the logic and validity checks so
    just call the normal procedure to delete data from r_base or an M_ table
    if model_run_id = 0 then delete record from R_BASE otherwise delete it from the model_ tables  */

    IF MODEL_RUN_ID = 0 THEN
      delete_r_base ( SITE_DATATYPE_ID,
                      INTERVAL,
      		          START_DATE_TIME,
  		              END_DATE_TIME,
                      AGEN_ID,
                      LOADING_APPLICATION_ID);
     END IF;

    IF MODEL_RUN_ID > 0 THEN
      delete_m_table ( MODEL_RUN_ID,
                       SITE_DATATYPE_ID,
      		           START_DATE_TIME,
  		               END_DATE_TIME,
                       INTERVAL);
     END IF;

END;  /* end of the procedure  */
.
/

show errors;

create or replace public synonym DELETE_FROM_HDB for DELETE_FROM_HDB;
grant execute on DELETE_FROM_HDB to app_role;
grant execute on DELETE_FROM_HDB to savoir_faire;
