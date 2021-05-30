create or replace package ENSEMBLE as
/*  PACKAGE ENSEMBLE is the package designed to contain all
    the procedures and functions for general ENSEMBLE use.
    
    Created by M. Bogner January 2013 for work to make TSTool 
    able to write ensembles to the ECAO HDB database
    Modified April 2014 to add the P_AGEN_ID to the procedure call to set AGEN_ID in REF_ENSEMBLE table   
*/

/*  DECLARE ALL GLOBAL variables  */
/*  For HDB and TSTool we will use a trace_domain standard set to 'TRACE NUMBER'   */
    G_TRACE_DOMAIN_STANDARD VARCHAR2(15) := 'TRACE NUMBER';
    G_DEFAULT_CMMNT VARCHAR2(100) := 'DEFAULT COMMENT ADDED BY ENSEMBLE PACKAGE VIA CREATE PROCEDURE CALL';
    G_MODEL_ID NUMBER := -999;
    G_MODEL_RUN_ID NUMBER := -999;
    G_ENSEMBLE_ID NUMBER := -999;
    G_TRACE_ID NUMBER := -999;
    
-- This procedure is the interface to TSTool in managing ensembles and returning the model_run_id for a
-- particular ensemble and trace number
PROCEDURE GET_TSTOOL_ENSEMBLE_MRI(
  OP_MODEL_RUN_ID OUT NUMBER, P_ENSEMBLE_NAME VARCHAR2, P_TRACE_NUMBER NUMBER, P_MODEL_NAME VARCHAR2,
  P_RUN_DATE DATE DEFAULT sysdate, P_IS_RUNDATE_KEY VARCHAR2 DEFAULT 'N', P_AGEN_ID NUMBER DEFAULT NULL);  		
   
END ENSEMBLE;
.
/

create or replace public synonym ENSEMBLE for ENSEMBLE;
grant execute on ENSEMBLE to app_role;
grant execute on ENSEMBLE to savoir_faire;
