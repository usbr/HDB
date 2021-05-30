create or replace package CP_PROCESSOR as
/*  PACKAGE CP_PROCESSOR is the package designed to contain all
    the procedures and functions for general CP_PROCESSOR use.
    
    Created by M. Bogner April 2012   
*/


/*  DECLARE ALL GLOBAL variables  */
/*  For HDB we will use a datatype_standard set to 'hdb'   */
    DATATYPE_STANDARD VARCHAR2(5) := 'hdb';

-- This function returns the ts_id for an existing record in table CP_TS_ID; retruns a -99 if it doesn't exist
  FUNCTION GET_TS_ID(P_SDI NUMBER, P_INTERVAL VARCHAR2, P_TABLE_SELECTOR VARCHAR2, P_MODEL_ID NUMBER)
   RETURN NUMBER;

-- This procedure insures a record is in table CP_TS_ID with the input Parameters via a merge statement
  PROCEDURE CREATE_TS_ID(P_SDI NUMBER, P_INTERVAL VARCHAR2, P_TABLE_SELECTOR VARCHAR2, P_MODEL_ID NUMBER,
  P_TS_ID IN OUT NUMBER);

-- This procedure insures a record is in table POPULATE_CP_COMP_DEPENDS with the input Parameters via a merge statement
  PROCEDURE POPULATE_CP_COMP_DEPENDS(P_TS_ID NUMBER, P_COMPUTATION_ID NUMBER);

-- This procedure creates records CP_COMP_DEPENDS table from input SDI's exiting non-group computations  
  PROCEDURE PRE_POPULATE_COMP_DEPENDS;

  -- Procedure NOTIFY_TSCREATED is a procedure originally written for the CWMS version of the CP application
  -- The signature was modified since the TS_ID and TS_CODE columns storage datatypes were switched
  --  PROCEDURE NOTIFY_TSCREATED (P_TSID INTEGER, P_TS_CODE VARCHAR2); 
  
  PROCEDURE TEST_PACKAGE(P_SDI NUMBER, P_INTERVAL VARCHAR2, P_TABLE_SELECTOR VARCHAR2, P_MODEL_ID NUMBER);
 		
    
END CP_PROCESSOR;
.
/

create or replace public synonym CP_PROCESSOR for CP_PROCESSOR;
grant execute on CP_PROCESSOR to app_role;
grant execute on CP_PROCESSOR to savoir_faire;
