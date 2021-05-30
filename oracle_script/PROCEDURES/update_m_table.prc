PROMPT CREATE OR REPLACE PROCEDURE update_m_table;

CREATE OR REPLACE PROCEDURE update_m_table (
        MODEL_RUN_ID_IN NUMBER,
        SITE_DATATYPE_ID_IN NUMBER,
        START_DATE_TIME_IN DATE,
        VALUE_IN FLOAT,
        INTERVAL_IN VARCHAR2)
   IS
       
   rowcount_new NUMBER;

   BEGIN

   IF INTERVAL_IN = 'hour' THEN 
         SELECT count ( * )
           INTO rowcount_new
           FROM m_hour
          WHERE model_run_id = MODEL_RUN_ID_IN
            AND site_datatype_id = SITE_DATATYPE_ID_IN
            AND start_date_time = START_DATE_TIME_IN;
   ELSIF INTERVAL_IN = 'day' THEN 
         SELECT count ( * )
           INTO rowcount_new
           FROM m_day
          WHERE model_run_id = MODEL_RUN_ID_IN
            AND site_datatype_id = SITE_DATATYPE_ID_IN
            AND start_date_time = START_DATE_TIME_IN;
   ELSIF INTERVAL_IN = 'month' THEN 
         SELECT count ( * )
           INTO rowcount_new
           FROM m_month
          WHERE model_run_id = MODEL_RUN_ID_IN
            AND site_datatype_id = SITE_DATATYPE_ID_IN
            AND start_date_time = START_DATE_TIME_IN;
   ELSIF INTERVAL_IN = 'wy' THEN 
         SELECT count ( * )
           INTO rowcount_new
           FROM m_wy
          WHERE model_run_id = MODEL_RUN_ID_IN
            AND site_datatype_id = SITE_DATATYPE_ID_IN
            AND start_date_time = START_DATE_TIME_IN;
   ELSIF INTERVAL_IN = 'year' THEN 
         SELECT count ( * )
           INTO rowcount_new
           FROM m_year
          WHERE model_run_id = MODEL_RUN_ID_IN
            AND site_datatype_id = SITE_DATATYPE_ID_IN
            AND start_date_time = START_DATE_TIME_IN;
   END IF;

   IF rowcount_new < 1 THEN
      DENY_ACTION('UPDATE FAILED. RECORD with MRI: ' || to_char(MODEL_RUN_ID_IN) || 
                  ' SDI: ' || to_char(SITE_DATATYPE_ID_IN) || ' INTERVAL: ' || INTERVAL_IN ||
                  ' START_DATE_TIME: ' || to_char(start_date_time_IN,'dd-MON-yyyy HH24:MI:SS') || ' DOES NOT EXIST.');
   ELSIF rowcount_new > 1 THEN
      DENY_ACTION('UPDATE FAILED. RECORD with MRI: ' || to_char(MODEL_RUN_ID_IN) || 
                  ' SDI: ' || to_char(SITE_DATATYPE_ID_IN) || ' INTERVAL: ' || INTERVAL_IN ||
                  ' START_DATE_TIME: ' || to_char(start_date_time_IN,'dd-MON-yyyy HH24:MI:SS') || ' HAS MULTIPLE ENTRIES. DANGER! DANGER! DANGER!.' );
   END IF;

/* These are duplicated for speed, see comments in insert_m_table and modify_m_table */
   UPDATE_M_TABLE_RAW (
        MODEL_RUN_ID_IN,
        SITE_DATATYPE_ID_IN,
        START_DATE_TIME_IN,
        VALUE_IN,
        INTERVAL_IN
);
   END;
/

 show errors;
/

create or replace public synonym update_m_table for update_m_table;
grant execute on update_m_table to app_role;
grant execute on update_m_table to savoir_faire;
grant execute on update_m_table to model_priv_role;

/
