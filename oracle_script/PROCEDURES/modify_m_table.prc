PROMPT CREATE OR REPLACE PROCEDURE modify_m_table;

CREATE OR REPLACE PROCEDURE MODIFY_M_TABLE (
                              MODEL_RUN_ID NUMBER,
                              SITE_DATATYPE_ID NUMBER,
			      START_DATE_TIME DATE,
			      END_DATE_TIME DATE,
			      VALUE FLOAT,
			      INTERVAL VARCHAR2,
			      DO_UPDATE_Y_OR_N VARCHAR2 ) IS
 END_DATE_TIME_NEW DATE;
BEGIN
    /*  set the end_date_time variable to the value passed in, this gets around the issue if you pass in a null */
    END_DATE_TIME_NEW := END_DATE_TIME;

    MODIFY_M_TABLE_RAW (
                        MODEL_RUN_ID,
                        SITE_DATATYPE_ID,
			START_DATE_TIME,
			END_DATE_TIME_NEW,
			VALUE,
			INTERVAL,
			DO_UPDATE_Y_OR_N );

END;
/

 show errors;
/

create or replace public synonym modify_m_table for modify_m_table;
grant execute on modify_m_table to app_role;
grant execute on modify_m_table to savoir_faire;
grant execute on modify_m_table to model_priv_role;

/

