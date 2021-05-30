CREATE OR REPLACE PACKAGE populate_pk IS
   pkval_pre_populated	BOOLEAN := FALSE;
   FUNCTION get_pk_val ( table_name IN  VARCHAR2, set_pkval IN BOOLEAN ) RETURN number;
-- This procedure added by M. Bogner May 2012 to keep site_id from being updated via trigger
   PROCEDURE SET_PRE_POPULATED ( P_SET_VALUE IN NUMBER);
END;
/

GRANT EXECUTE ON populate_pk TO PUBLIC
/
