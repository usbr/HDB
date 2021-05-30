CREATE OR REPLACE PROCEDURE update_r_base ( SITE_DATATYPE_ID_IN NUMBER,
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
			  DATA_FLAGS_IN VARCHAR2 DEFAULT NULL,
			  DATE_TIME_IN DATE DEFAULT SYSDATE ) IS
    rowcount NUMBER;
BEGIN
    SELECT count ( * )
      INTO rowcount
      FROM r_base
     WHERE site_datatype_id = site_datatype_id_in
       AND INTERVAL = interval_in
       AND start_date_time = start_date_time_in
       and end_date_time = end_date_time_in;
    IF rowcount < 1 THEN
	DENY_ACTION ( 'UPDATE FAILED. RECORD with SDI: ' || to_char ( SITE_DATATYPE_ID_IN ) ||
      ' INTERVAL: ' || INTERVAL_IN || ' START_DATE_TIME: ' || to_char ( start_date_time_IN,
      'dd-MON-yyyy HH24:MI:SS' ) || ' DOES NOT EXIST.' );
    ELSIF  rowcount > 1 THEN
	DENY_ACTION ( 'UPDATE FAILED. RECORD with SDI: ' || to_char ( SITE_DATATYPE_ID_IN ) ||
      ' INTERVAL: ' || INTERVAL_IN || ' START_DATE_TIME: ' || to_char ( start_date_time_IN,
      'dd-MON-yyyy HH24:MI:SS' ) || ' END_DATE_TIME: '|| to_char ( end_date_time_IN,
      'dd-MON-yyyy HH24:MI:SS' ) || ' HAS MULTIPLE ENTRIES. DANGER! DANGER! DANGER!.' );
    END IF;

/*  Modified by M. Bogner for compatibility for derivation replacement coding  */

    UPDATE_R_BASE_RAW(SITE_DATATYPE_ID_IN,
		       INTERVAL_IN,
		       START_DATE_TIME_IN,
		       END_DATE_TIME_IN,
		       VALUE_IN,
		       AGEN_ID_IN,
		       OVERWRITE_FLAG_IN,
		       VALIDATION_IN,
        	       COLLECTION_SYSTEM_ID_IN,
		       LOADING_APPLICATION_ID_IN,
		       METHOD_ID_IN,
		       COMPUTATION_ID_IN,
		       DATA_FLAGS_IN,
		       DATE_TIME_IN );
END;
/

show errors;

create or replace public synonym update_r_base for update_r_base;
grant execute on update_r_base to app_role;
