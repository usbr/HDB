CREATE OR REPLACE PROCEDURE MODIFY_SITE_COEF ( SITE_ID_IN NUMBER,
                              ATTR_ID_IN NUMBER,
                              COEF_IDX_IN NUMBER,
                              EFFECTIVE_START_DATE_TIME_IN DATE,
                              EFFECTIVE_END_DATE_TIME_IN DATE,
                              COEF_IN FLOAT ) IS
    TEMP_SITE REF_SITE_COEF.SITE_ID%TYPE;
    TEMP_ATTR REF_SITE_COEF.ATTR_ID%TYPE;
    TEMP_SDT REF_SITE_COEF.EFFECTIVE_START_DATE_TIME%TYPE;
    ROWCOUNT NUMBER;
    END_DATE_TIME_NEW DATE;
BEGIN

    /*  First check for any null field that where passed  */

    IF SITE_ID_IN IS NULL THEN DENY_ACTION ( 'INVALID <NULL> SITE_ID' );
	ELSIF ATTR_ID_IN IS NULL THEN DENY_ACTION ( 'INVALID <NULL> ATTR_ID' );
	ELSIF EFFECTIVE_START_DATE_TIME_IN IS NULL THEN DENY_ACTION ( 'INVALID <NULL> EFFECTIVE_START_DATE_TIME' );
	ELSIF COEF_IDX_IN IS NULL THEN DENY_ACTION ( 'INVALID <NULL> COEF_IDX' );
    END IF;

    TEMP_SITE := SITE_ID_IN;
    TEMP_ATTR := ATTR_ID_IN;
    TEMP_SDT := EFFECTIVE_START_DATE_TIME_IN;

    /*  Determine if a record already exists ; if not do an insert otherwise do an update as long as do_update <> 'N'  */

    SELECT count ( * )
      INTO rowcount
      FROM ref_site_coef
      WHERE site_id = TEMP_SITE
       AND attr_id = TEMP_ATTR
       AND effective_start_date_time = TEMP_SDT;

    /* Insert the data into the database  */

    IF rowcount = 0 THEN
	insert into ref_site_coef values
                      ( SITE_ID_IN,
			ATTR_ID_IN,
                        COEF_IDX_IN,
			EFFECTIVE_START_DATE_TIME_IN,
			EFFECTIVE_END_DATE_TIME_IN,
			COEF_IN);

  /*  Update the data into the database, if desired */

        ELSIF rowcount = 1 THEN

	update ref_site_coef set
	effective_end_date_time = EFFECTIVE_END_DATE_TIME_IN,
	coef = COEF_IN
        where site_id = SITE_ID_IN and
        attr_id = ATTR_ID_IN and
        coef_idx = COEF_IDX_IN and
        effective_start_date_time = EFFECTIVE_START_DATE_TIME_IN;

  /*  In case the primary key constraint was disabled */

	ELSIF rowcount > 1 THEN
           DENY_ACTION ( 'RECORD with SITE_ID: ' || to_char ( SITE_ID_IN ) ||
           ' ATTR_ID: ' || ATTR_ID_IN || ' EFFECTIVE_START_DATE_TIME: ' || to_char ( EFFECTIVE_start_date_time_IN,
           'dd-MON-yyyy HH24:MI:SS' ) ||
           ' HAS MULTIPLE ENTRIES. DANGER! DANGER! DANGER!.' );

    END IF;

END;
/

show errors;

create or replace public synonym MODIFY_SITE_COEF for MODIFY_SITE_COEF;
grant execute on MODIFY_SITE_COEF to app_role;
grant execute on MODIFY_SITE_COEF to savoir_faire;
