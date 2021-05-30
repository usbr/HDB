create or replace package HDB_POET as
/*  PACKAGE HDB_POET is the package designed to contain all
    the procedures and functions for general HDB_POET use.
    
    Created by M. Bogner NOVEMBER 2008   
*/

/*  DECLARE ALL GLOBAL variables  */
/*  none so far */


  PROCEDURE CALCULATE_SERIES(SITE_DATATYPE_ID NUMBER, INTERVAL VARCHAR2, START_TIME DATE, TIME_ZONE VARCHAR2 DEFAULT NULL);
  
    
END HDB_POET;
.
/

create or replace public synonym HDB_POET for HDB_POET;
grant execute on HDB_POET to app_role;
