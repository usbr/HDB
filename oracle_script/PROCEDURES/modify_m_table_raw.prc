PROMPT CREATE OR REPLACE PROCEDURE modify_m_table_raw;

CREATE OR REPLACE PROCEDURE modify_m_table_raw  ( 
                              MODEL_RUN_ID_IN NUMBER,
                              SITE_DATATYPE_ID_IN NUMBER,
                              START_DATE_TIME_IN DATE,
                              END_DATE_TIME IN OUT DATE,
                              VALUE FLOAT,
                              INTERVAL_IN VARCHAR2,
                              DO_UPDATE_Y_OR_N VARCHAR2 )
IS
    ROWCOUNT NUMBER;
    l_ts_id NUMBER;
    l_model_id NUMBER;
    END_DATE_TIME_NEW DATE;
BEGIN
	/*  Modified by M.  Bogner  05/23/2012 to add Phase 3.0 mod to add entry to CP_TS_ID Table */ 
	
    /*  First check for any null field that were passed  */
    IF MODEL_RUN_ID_IN IS NULL THEN DENY_ACTION ( 'INVALID <NULL> MODEL_RUN_ID' );
        ELSIF SITE_DATATYPE_ID_IN IS NULL THEN DENY_ACTION ( 'INVALID <NULL> SITE_DATATYPE_ID' );
        ELSIF INTERVAL_IN IS NULL THEN DENY_ACTION ( 'INVALID <NULL> INTERVAL' );
        ELSIF START_DATE_TIME_IN IS NULL THEN DENY_ACTION ( 'INVALID <NULL> START_DATE_TIME' );
        ELSIF VALUE IS NULL THEN DENY_ACTION ( 'INVALID <NULL> VALUE' );
    END IF;

    /* for phase 3.0 add this record to the CP_TS_ID table if it isn't already there  */
    /* this procedure call added for Phase 3.0 project                                */
      SELECT model_id
        INTO l_model_id
        FROM ref_model_run
       WHERE model_run_id = MODEL_RUN_ID_IN;
    CP_PROCESSOR.create_ts_id (SITE_DATATYPE_ID_IN,INTERVAL_IN,'M_',l_model_id,l_ts_id);

    /*  if user did not pass an end_date time, set the end date TIME based on START_DATE_TIME AND THE INTERVAL */
    END_DATE_TIME_NEW := END_DATE_TIME;
    IF END_DATE_TIME IS NULL THEN
        IF INTERVAL_IN = 'hour' THEN END_DATE_TIME_NEW := START_DATE_TIME_IN + 1 / 24;
        ELSIF INTERVAL_IN = 'day' THEN END_DATE_TIME_NEW := START_DATE_TIME_IN + 1;
        ELSIF INTERVAL_IN = 'month' THEN END_DATE_TIME_NEW := ADD_MONTHS ( START_DATE_TIME_IN,
                                                                            1 );
        ELSIF INTERVAL_IN ='year' OR INTERVAL_IN = 'wy' THEN END_DATE_TIME_NEW := ADD_MONTHS ( START_DATE_TIME_IN,
                                                                                              12 );
        ELSE
            DENY_ACTION ( INTERVAL_IN || ' IS AN INVALID INTERVAL WITH A NULL END DATE TIME.' );
        END IF;

        END_DATE_TIME := END_DATE_TIME_NEW;
    END IF;

    /*  go see if a record already exists ; if not do an insert otherwise do an update as long as upper(do_update_y_or_n) = 'Y'  
        we could do this with dynamic sql, but that is probably slower */

   IF INTERVAL_IN = 'hour' THEN 
      SELECT count ( * )
        INTO rowcount
        FROM m_hour
       WHERE model_run_id = MODEL_RUN_ID_IN
         AND site_datatype_id = SITE_DATATYPE_ID_IN
         AND start_date_time = START_DATE_TIME_IN;
   ELSIF INTERVAL_IN = 'day' THEN 
      SELECT count ( * )
        INTO rowcount
        FROM m_day
       WHERE model_run_id = MODEL_RUN_ID_IN
         AND site_datatype_id = SITE_DATATYPE_ID_IN
         AND start_date_time = START_DATE_TIME_IN;
   ELSIF INTERVAL_IN = 'month' THEN 
      SELECT count ( * )
        INTO rowcount
        FROM m_month
       WHERE model_run_id = MODEL_RUN_ID_IN
         AND site_datatype_id = SITE_DATATYPE_ID_IN
         AND start_date_time = START_DATE_TIME_IN;
   ELSIF INTERVAL_IN = 'wy' THEN 
      SELECT count ( * )
        INTO rowcount
        FROM m_wy
       WHERE model_run_id = MODEL_RUN_ID_IN
         AND site_datatype_id = SITE_DATATYPE_ID_IN
         AND start_date_time = START_DATE_TIME_IN;
   ELSIF INTERVAL_IN = 'year' THEN 
      SELECT count ( * )
        INTO rowcount
        FROM m_year
       WHERE model_run_id = MODEL_RUN_ID_IN
         AND site_datatype_id = SITE_DATATYPE_ID_IN
         AND start_date_time = START_DATE_TIME_IN;
   ELSE
        DENY_ACTION('INVALID INTERVAL');
   END IF;
     /*    DENY_ACTION(to_char(MODEL_RUN_ID_IN)||to_char(SITE_DATATYPE_ID_IN)||INTERVAL_IN||TO_CHAR(START_DATE_TIME_IN)||'  REC COUNT:'||TO_CHAR(rowcount)); */

    IF rowcount = 0 THEN
        /* insert the data into the database  */
        INSERT_M_TABLE (MODEL_RUN_ID_IN, 
                        SITE_DATATYPE_ID_IN,
                        START_DATE_TIME_IN,
                        END_DATE_TIME_NEW,
                        VALUE,
                        INTERVAL_IN);
  /*  update the data into the database, if desired */
        ELSIF rowcount > 1 THEN
              DENY_ACTION ( 'RECORD with with MRI: ' || to_char(MODEL_RUN_ID_IN) || 
              ' SDI: ' || to_char ( SITE_DATATYPE_ID_IN ) ||
              ' INTERVAL: ' || INTERVAL_IN || ' START_DATE_TIME: ' || to_char ( START_DATE_TIME_IN,
              'dd-MON-yyyy HH24:MI:SS' ) || ' HAS MULTIPLE ENTRIES. DANGER! DANGER! DANGER!.' );
        ELSIF UPPER ( NVL ( DO_UPDATE_Y_OR_N,           
                            'Y' ) ) = 'Y' THEN UPDATE_M_TABLE_RAW ( 
                                                                    MODEL_RUN_ID_IN, 
                                                                    SITE_DATATYPE_ID_IN,
                                                                    START_DATE_TIME_IN,
                                                                    VALUE,
	                                                            INTERVAL_IN);
    END IF;

END;
/

 show errors;
/

create or replace public synonym modify_m_table_raw for modify_m_table_raw;
grant execute on modify_m_table_raw to app_role;
grant execute on modify_m_table_raw to savoir_faire;
grant execute on modify_m_table_raw to model_priv_role;

/

