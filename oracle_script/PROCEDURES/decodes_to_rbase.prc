create or replace PROCEDURE DECODES_TO_RBASE (
			      SITE_ID          NUMBER,
			      DATATYPE_ID      NUMBER,
			      SAMPLE_DATE_TIME DATE,
			      SAMPLE_VALUE     FLOAT
)  IS

/*  This procedure was written to be the generic interface to 
    R_BASE from the DECODES application                       
    this procedure written by Mark Bogner   June 2005          */

    /*  first declare all internal variables need for call to modify_r_base_raw  */
    SITE_DATATYPE_ID       R_BASE.SITE_DATATYPE_ID%TYPE;
    INTERVAL               R_BASE.INTERVAL%TYPE;
    START_DATE_TIME        R_BASE.START_DATE_TIME%TYPE;
    END_DATE_TIME          R_BASE.END_DATE_TIME%TYPE;
    VALUE                  R_BASE.VALUE%TYPE;
    AGEN_ID                R_BASE.AGEN_ID%TYPE;
    OVERWRITE_FLAG         R_BASE.OVERWRITE_FLAG%TYPE;
    VALIDATION             R_BASE.VALIDATION%TYPE;
    COLLECTION_SYSTEM_ID   R_BASE.COLLECTION_SYSTEM_ID%TYPE;
    LOADING_APPLICATION_ID R_BASE.LOADING_APPLICATION_ID%TYPE;
    METHOD_ID              R_BASE.METHOD_ID%TYPE;
    COMPUTATION_ID         R_BASE.COMPUTATION_ID%TYPE;

    /* some temp variables for use in this procedures internal queries  */
    TEMP_NUMBER     NUMBER;
    TEMP_SITEID     NUMBER;
    TEMP_DATATYPEID NUMBER;
BEGIN

    /*  First check for any required fields that where passed in as NULL  */
    IF SITE_ID IS NULL THEN DENY_ACTION ( 'INVALID <NULL> SITE_ID' );
	ELSIF DATATYPE_ID IS NULL THEN DENY_ACTION ( 'INVALID <NULL> DATATYPE_ID' );
	ELSIF SAMPLE_DATE_TIME IS NULL THEN DENY_ACTION ( 'INVALID <NULL> SAMPLE_DATE_TIME' );
	ELSIF SAMPLE_VALUE IS NULL THEN DENY_ACTION ( 'INVALID <NULL> SAMPLE_VALUE' );
    END IF;

    /*  now set the variables for the data input parameters     */
    START_DATE_TIME := SAMPLE_DATE_TIME;
    VALUE := SAMPLE_VALUE;
    TEMP_SITEID := SITE_ID;
    TEMP_DATATYPEID := DATATYPE_ID;

      BEGIN
      /* go get the site_datatype_id for the site/datatype combination that was passed in as 
         input parameteres                                                                    */
      select site_datatype_id into site_datatype_id from hdb_site_datatype 
           where site_id = temp_siteid 
           and datatype_id = temp_datatypeid;

      /* if there is no site_datatype_Id then no reason to continue  */
      EXCEPTION
        WHEN NO_DATA_FOUND THEN  
         DENY_ACTION ( 'NO SITE_DATATYPE_ID FOR SITE_ID: '|| to_char(SITE_ID) || ' DATATYPE_ID: ' || to_char(datatype_id) );
      END;

      BEGIN
      /*  go get the interval, method, and computation id's if the users decided to define 
          them and use the generic mapping table for these data      */
      select a.hdb_interval_name,a.hdb_method_id,a.hdb_computation_id
            into INTERVAL,METHOD_ID,COMPUTATION_ID
      	  from ref_ext_site_data_map a, hdb_ext_data_source b
          where a.hdb_site_datatype_id = site_datatype_id
            and a.ext_data_source_id = b.ext_data_source_id
            and upper(b.ext_data_source_name) = 'DECODES';
 
      EXCEPTION
        WHEN NO_DATA_FOUND THEN  /* don't care, will use defaults.. so do nothing  */  
        TEMP_NUMBER := 0;
      END;

      BEGIN
      /*  go get the agen_id from the generic mapping tables  since decodes must use these 
          tables data to get the site data anyway  But it may be null so its set later as a
          default if  that is the case                                                        */
      select min(agen_id) into agen_id from  hdb_ext_site_code a , hdb_ext_site_code_sys  b
        where a.hdb_site_id = temp_siteid and a.ext_site_code_sys_id = b.ext_site_code_sys_id;
 
      EXCEPTION
        WHEN NO_DATA_FOUND THEN    /* don't care, will use defaults.. so do nothing  */
        TEMP_NUMBER := 0;
      END;

    /*  set all the default system and agency ids for this application 
        since they will be known.  IT was decided to hardcode these to be site 
        specific to reduce the number of queries necessary to put in a R_base record  
        These default settings may need to be changed based on the values at each 
        specific HDB installation  */

    /*  Interval query above gives the installation the chance to define a different 
        interval for a particular site if they want it, otherwise default the interval 
        to instant                 */                                          
    IF INTERVAL is NULL THEN 
       INTERVAL := 'instant';
    END IF;

    IF AGEN_ID is NULL THEN  /*  see query above if there is a problem here  */
       AGEN_ID := 33;             /*  See Loading application  */
    END IF;

    COLLECTION_SYSTEM_ID := 13;    /*  see loading application  */
    LOADING_APPLICATION_ID := 41;  /*  whatever DECODES loading applications number is   */
    
    IF METHOD_ID is NULL THEN    /*  possibly already set if user defined method for this SDI  */
       METHOD_ID := 18;               /* unknown  */
    END IF;

    IF COMPUTATION_ID is NULL THEN    /*  possibly already set if user defined computation_id for this SDI  */
       COMPUTATION_ID := 2;           /*  N/A  */
    END IF;


    /*  now we should have passed all the logic and validity checks so
    just call the normal procedure to put data into r_base          */

    modify_r_base_raw ( SITE_DATATYPE_ID,
                        INTERVAL,
			START_DATE_TIME,
			END_DATE_TIME,
			VALUE,
                        AGEN_ID,
			OVERWRITE_FLAG,
			VALIDATION,
                        COLLECTION_SYSTEM_ID,
                        LOADING_APPLICATION_ID,
                        METHOD_ID,
                        COMPUTATION_ID,
                        'Y');

END;  /* end of the procedure  */
.
/

show errors;
/
create public synonym decodes_to_rbase for decodes_to_rbase;
grant execute on decodes_to_rbase to app_role;
grant execute on decodes_to_rbase to savoir_faire;
