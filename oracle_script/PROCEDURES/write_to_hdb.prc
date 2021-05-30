CREATE OR REPLACE
PROCEDURE WRITE_TO_HDB (                                                        
			      SAMPLE_SDI            NUMBER,                                          
			      SAMPLE_DATE_TIME      DATE,                                            
			      SAMPLE_VALUE          FLOAT,                                           
                  SAMPLE_INTERVAL       VARCHAR2,                               
                  LOADING_APP_ID        NUMBER,                                 
                  COMPUTE_ID            NUMBER,                                 
                  MODELRUN_ID           NUMBER,                                 
                  VALIDATION_FLAG       CHAR,                                   
                  DATA_FLAGS            VARCHAR2,
                  TIME_ZONE				VARCHAR2 DEFAULT NULL,
                  OVERWRITE_FLAG	    VARCHAR2 DEFAULT NULL,
                  AGEN_ID				NUMBER   DEFAULT NULL, 
			      SAMPLE_END_DATE_TIME  DATE     DEFAULT NULL                                           
)  IS                                                                           
                                                                                
/*  This procedure was written to be the generic interface to                   
    HDB from the DECODES and the COMPUTATION application                        
    this procedure written by Mark Bogner   June 2005                           
                                                                                
    Modified June 2007 by M. Bogner for the new R_BASE data quality flags       
    Modified July 2007 by M. Bogner to add the validation_flag to procedure 
    call
    Modified April 2008 by M. Bogner for new use of method_id for the C.P.       
    Modified June 2009 by M. Bogner to default agen_id to 7 BOR, use time_zone...       
    Modified january 2013 by M. Bogner to add overwrite_flag and AGEN_ID as parameters
    Modified April 16 2013 by M. Bogner to add SAMPLE_END_DATE_TIME as parameter

*/                                                                         
                                                                                
                                                                                
    /*  first declare all internal variables need for call to modify_r_base_raw 
        and to modify m_tables_raw                                              
    */                                                                             
                                                                                
    SITE_DATATYPE_ID       R_BASE.SITE_DATATYPE_ID%TYPE;                        
    INTERVAL               R_BASE.INTERVAL%TYPE;                                
    START_DATE_TIME        R_BASE.START_DATE_TIME%TYPE;                         
    END_DATE_TIME          R_BASE.END_DATE_TIME%TYPE;                           
    VALUE                  R_BASE.VALUE%TYPE;                                   
--  following line Modified since AGEN_ID will be parameter as of Jan 2013
    L_AGEN_ID              R_BASE.AGEN_ID%TYPE;                                 
--  following line commented out since overwrite_flag will be parameter as of Jan 2013
--  OVERWRITE_FLAG         R_BASE.OVERWRITE_FLAG%TYPE;                          
    VALIDATION             R_BASE.VALIDATION%TYPE;                              
    COLLECTION_SYSTEM_ID   R_BASE.COLLECTION_SYSTEM_ID%TYPE;                    
    METHOD_ID              R_BASE.METHOD_ID%TYPE;                               
    COMPUTATION_ID         R_BASE.COMPUTATION_ID%TYPE;                          
    LOADING_APPLICATION_ID R_BASE.LOADING_APPLICATION_ID%TYPE;                  
    MODEL_RUN_ID           M_DAY.MODEL_RUN_ID%TYPE;                             
    QUALITY_FLAGS          R_BASE.DATA_FLAGS%TYPE;                              
	db_timezone		VARCHAR2(3);
                                                                                
    /* some temp variables for use in this procedures  for internal             
       processing and queries  */                                               
                                                                                
    TEMP_NUMBER     NUMBER;                                                     
    DEF_COMP_ID     NUMBER;                                                     
    DEF_METHOD_ID   NUMBER;                                                     
    DEF_COLLECTION_ID   NUMBER;                                                 
    DEF_AGEN_ID     NUMBER;                                                     
    DECODES_ID      NUMBER;                                                     
                                                                                
BEGIN                                                                           
                                                                                

    /*  set these default assignments according to the primary key values in your database  */                                                                  
                                                                                
    DEF_COMP_ID  := 2;    /*  N/A    */                                         
--    DEF_AGEN_ID  := 33;   /* Remove to agree with delete from HDB and all Users   see loading application  */                        
    DEF_AGEN_ID  := 7;   /* BOR if this is what the site wants  */                        
    DEF_METHOD_ID  := 18;   /* unknown  */                                      
    DEF_COLLECTION_ID  := 13;   /* see loading application  */                  
    DECODES_ID    :=  41;   /*  loading application_id for DECODES  */          
                                                                                
    /*  First check for any required fields that where passed in as NULL  */    
    IF SAMPLE_SDI IS NULL THEN DENY_ACTION ( 'INVALID <NULL> SAMPLE_SDI' );     
	ELSIF SAMPLE_DATE_TIME IS NULL THEN DENY_ACTION ( 'INVALID <NULL> SAMPLE_DATE_TIME' );                                                                         
	ELSIF SAMPLE_VALUE IS NULL THEN DENY_ACTION ( 'INVALID <NULL> SAMPLE_VALUE' ); 
	ELSIF SAMPLE_INTERVAL IS NULL THEN DENY_ACTION ( 'INVALID <NULL> SAMPLE_INTERVAL' );                                                                           
	ELSIF LOADING_APP_ID IS NULL THEN DENY_ACTION ( 'INVALID <NULL> LOADING_APP_ID');                                                                             
	ELSIF MODELRUN_ID IS NULL THEN DENY_ACTION ( 'INVALID <NULL> MODELRUN_ID' );   
    END IF;                                                                     

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
                                                                                
    /*  now set the variables for the data input parameters     */              
    SITE_DATATYPE_ID := SAMPLE_SDI;                                             

    START_DATE_TIME := SAMPLE_DATE_TIME;                                        
    VALUE := SAMPLE_VALUE;                                                      
    COMPUTATION_ID := COMPUTE_ID;                                               
    LOADING_APPLICATION_ID := LOADING_APP_ID;                                   
    MODEL_RUN_ID := MODELRUN_ID;                                                
    VALIDATION := VALIDATION_FLAG;                                              
    QUALITY_FLAGS := DATA_FLAGS;
    L_AGEN_ID := AGEN_ID;                                                
                                                                                
    /* the next two queries should be done only if the data is coming from the 
       DECODES application we will use the loading_application_id for this since 
       its the only indicator we have where the data is comming from                                                          
    */                                                  
                                                                                
    if LOADING_APPLICATION_ID = DECODES_ID THEN                                 
      BEGIN                                                                     
      /*  go get the interval and  method if the users decided to define        
          them and use the generic mapping table for these data      */         
      select a.hdb_interval_name,a.hdb_method_id                                
            into INTERVAL,METHOD_ID                                             
      	  from ref_ext_site_data_map a, hdb_ext_data_source b                    
          where a.hdb_site_datatype_id = site_datatype_id                       
            and a.ext_data_source_id = b.ext_data_source_id                     
            and upper(b.ext_data_source_name) = 'DECODES';                      
                                                                                
      EXCEPTION                                                                 
        WHEN NO_DATA_FOUND THEN  /* don't care, will use defaults.. so do nothing  */                                                                           
        TEMP_NUMBER := 0;                                                       
      END;                                                                      
                                                                                
     ELSIF UPPER(user) = 'CP_PROCESS' THEN  /* then its data from the Computation Processor  */
      BEGIN                                                                     
      /*  go get the method_id from the hdb_method table to indicate that this record came from
      the computation processor. Modified Jan 2013 since the CP should be run with user account CP_PROCESS
      */                                                                
                                                                                
      select method_id into method_id 
      from  hdb_method
      where lower(method_name) like 'computation processor%';
                                                                                
      EXCEPTION                                                                 
        WHEN NO_DATA_FOUND THEN 
        /* don't care, will use defaults.. so do nothing  */                                                                         
        NULL;                                                       
      END;                                                                      

                                                                                
    END IF;  /* the end of queries to do specific to the DECODES Application   */                                                                               

    /*  set all the default system and agency ids for this application          
        since they will be known.  IT was decided to hardcode these to be site  
        specific to reduce the number of queries necessary to put in a R_base 
        record These default settings may need to be changed based on the values 
        at each specific HDB installation  
    */                                           
                                                                                
    /*  Interval query above gives the installation the chance to define a different                                                                            
        interval for a particular site if they want it, otherwise default the interval
        to  to the passed in variable                
    */                         
                                                                                
    if INTERVAL is null THEN                                                    
       INTERVAL :=  SAMPLE_INTERVAL;                                            
    END IF;                                                                     
                                                                                
    IF L_AGEN_ID is NULL THEN  /*  see query above if there is a problem here  */ 
       L_AGEN_ID := DEF_AGEN_ID;         /* see loading application  */           
    END IF;                                                                     
                                                                                
    IF COLLECTION_SYSTEM_ID is NULL THEN                                        
      COLLECTION_SYSTEM_ID := DEF_COLLECTION_ID;    /*  see loading application  */                                                                             
    END IF;                                                                     
                                                                                
    IF METHOD_ID is NULL THEN    /*  possibly already set if user defined method for this SDI  */                                                               
       METHOD_ID := DEF_METHOD_ID;               /* unknown  */                 
    END IF;                                                                     

    IF COMPUTATION_ID is NULL THEN    /*  possibly already set if user defined computation_id for this SDI  */                                                  
       COMPUTATION_ID := DEF_COMP_ID;           /*  N/A  */                     
    END IF;                                                                     
 
 
  /* now convert the start_time to the database time if different, both exist, 
   and only for the instantaneous and hourly interval           */
   
   IF (TIME_ZONE <> db_timezone AND INTERVAL in ('instant','hour')) THEN
       START_DATE_TIME := new_time(START_DATE_TIME,TIME_ZONE,db_timezone);
       END_DATE_TIME := new_time(SAMPLE_END_DATE_TIME,TIME_ZONE,db_timezone);
	END IF;
                                                                                
    /*  now we should have passed all the logic and validity checks so          
    just call the normal procedure to put data into r_base or an M_ table       
    if model_run_id = 0 then insert record into R_BASE otherwise send it to the 
	model_ tables  
	*/                                                               
                                                                             
    IF MODEL_RUN_ID = 0 THEN                                                    
      modify_r_base_raw ( SITE_DATATYPE_ID,                                     
                          INTERVAL,                                             
      			          START_DATE_TIME,                                             
  			              END_DATE_TIME,                                               
			              VALUE,                                                         
                          L_AGEN_ID,                                              
			              OVERWRITE_FLAG,                                                
			              VALIDATION,                                                    
                          COLLECTION_SYSTEM_ID,                                 
                          LOADING_APPLICATION_ID,                               
                          METHOD_ID,                                            
                          COMPUTATION_ID,                                       
                          'Y',                                                  
                          QUALITY_FLAGS);                                       
     END IF;                                                                    
                                                                                
    IF MODEL_RUN_ID > 0 THEN                                                    
      modify_m_table_raw ( MODEL_RUN_ID,                                        
                          SITE_DATATYPE_ID,                                     
      			          START_DATE_TIME,                                             
  			              END_DATE_TIME,                                               
			              VALUE,                                                         
                          INTERVAL,                                             
                          'Y');                                                 
     END IF;                                                                    

                                                                                
END;  /* end of the procedure  */                                               
.
/

show errors;

create or replace public synonym WRITE_TO_HDB for WRITE_TO_HDB;
grant execute on WRITE_TO_HDB to app_role;
grant execute on WRITE_TO_HDB to savoir_faire;
