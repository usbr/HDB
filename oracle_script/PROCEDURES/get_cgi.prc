create or replace PROCEDURE  GET_HDB_CGI_DATA
/*
Notes:
- This procedure gets data from HDB for use in the CGI program using a 
    specified set of inputs as described below:
      o_cursorOutput  Container for outputs        
      i_sdiList       List of SDI #'s as a CSV
                      example: '1930,2146,2101'
      i_tStep         Data timestep
                      Either 'INSTANT', 'HOUR', 'DAY', 'MONTH', or 'YEAR' only!
      i_startDate     Starting timestep in 'DD-MMM-YYY' format
                      example: '01-JAN-2014'
      i_endDate       Ending timestep in 'DD-MMM-YYY' format
                      example: '31-DEC-2014'            
      i_sourceTable   [Optional] Data table source, the program defaults to 'R'
                      Either 'R' for real, or 'M' for modeled
      i_modelRunIds   [Optional] Required only if i_sourceTable='M'
                      List of MRID #'s as a CSV
                      example: '2191,2054'
- Search for '[JR]' in this code file for areas that could use some work
- POC: Jon Rocha, USBR, jrocha@usbr.gov
 
Change Log:
23JAN2015 - Started program. Succesfully gets data from the 'R' tables
13FEB2015 - Fixed date sorting. Added capability to also get data from the 
            'M' tables
10APR2015 - Added capability to query the INSTANT tables
*/
(
  o_cursorOutput  OUT sys_refcursor,        
  i_sdiList       IN VARCHAR2,              
  i_tstep         IN VARCHAR2,              
  i_startDate     IN VARCHAR2,              
  i_endDate       IN VARCHAR2,              
  i_sourceTable   IN VARCHAR2 DEFAULT 'R',  
  i_modelRunIds   IN VARCHAR2 DEFAULT NULL  
) 
IS
  l_sqlStatement  VARCHAR2(32767);
  l_sdiList VARCHAR2(9999);
  l_startIdx BINARY_INTEGER;
  l_endIdx   BINARY_INTEGER;
  l_curValue VARCHAR2(9999);
  l_tstep VARCHAR2(10);
  l_periodEnd VARCHAR (20);
BEGIN
  l_sdilist := i_sdilist || ',';
  l_startIdx := 0;
  l_endIdx   := instr(l_sdilist, ','); 
  
  IF i_tstep = 'INSTANT' OR i_tstep = 'HOUR' THEN
    l_tstep := 'HOUR';
    l_periodEnd := 'END_DATE_TIME';
  ELSE
    l_tstep := i_tstep;
    l_periodEnd := 'START_DATE_TIME';
  END IF;
    
  -- BUILD OUTER SQL SEARCH STATEMENT
  IF i_sourceTable = 'M' THEN -- GET DATA FROM M TABLES
    l_sqlstatement := 'SELECT HDB_DATETIME, MODEL_RUN_ID, ';
  -- ELSE IF i_sourceTable = '?' THEN -- [JR] FOR BUILDING ADDITIONAL FUNCTIONALITY
  ELSE -- DEFAULT GET DATA FROM R TABLES
    l_sqlstatement := 'SELECT HDB_DATETIME, ';
  END IF;
  
  WHILE(l_endIdx > 0) LOOP -- Loop through each station
    l_curValue := substr(l_sdilist, l_startIdx+1, l_endIdx - l_startIdx - 1);
    l_sqlstatement := l_sqlstatement || 'MAX(CASE WHEN SITE_DATATYPE_ID = ' || 
      l_curValue || ' THEN HDB_VALUE ELSE NULL END) AS SDI_' || l_curValue || 
      ', ';
    l_startIdx := l_endIdx;
    l_endIdx := instr(l_sdilist, ',', l_startIdx + 1);  
  END LOOP;
  
  -- DELETE ENDING COMMA FROM THE LOOP ABOVE
  l_sqlstatement := SUBSTR(l_sqlstatement , 1, INSTR(l_sqlstatement , ',', -1)-1);
    
  -- BUILD INNER SQL SEARCH STATEMENT
  IF i_sourceTable = 'M' THEN -- GET DATA FROM M TABLES
    l_sqlstatement := l_sqlstatement || ' FROM (SELECT SITE_DATATYPE_ID, ' || 
    'MODEL_RUN_ID, ' || l_periodEnd || ' AS HDB_DATETIME, ' ||
    'CAST(VALUE AS VARCHAR(10)) AS HDB_VALUE FROM ' || i_sourcetable || '_' ||
    i_tstep || ' WHERE SITE_DATATYPE_ID IN (' || i_sdiList || 
    ') AND MODEL_RUN_ID IN (' || i_modelrunids || ') ' ||
    'ORDER BY SITE_DATATYPE_ID, ' || l_periodEnd || ') GROUP BY ' || 
    'HDB_DATETIME, MODEL_RUN_ID ORDER BY MODEL_RUN_ID, HDB_DATETIME';
  -- ELSE IF i_sourceTable = '?' THEN -- [JR] FOR BUILDING ADDITIONAL FUNCTIONALITY
  ELSE -- DEFAULT GET DATA FROM R TABLES
    l_sqlstatement := l_sqlstatement || ' FROM (SELECT SITE_DATATYPE_ID, ' || 
    
    -- [JR] NEXT 6 LINES DOES NOT FILL IN MISSING VALUES
    --l_periodEnd || ' AS HDB_DATETIME, ' ||
    --'CAST(VALUE AS VARCHAR(10)) AS HDB_VALUE FROM ' || i_sourcetable || '_' ||
    --i_tstep || ' WHERE SITE_DATATYPE_ID IN (' || i_sdiList || 
    --') AND ' || l_periodEnd || ' >= ''' || i_startdate || ''' AND ' || l_periodEnd || ' <= ''' ||
    --i_enddate || ''' ORDER BY SITE_DATATYPE_ID, ' || l_periodEnd || ') GROUP BY ' || 
    --'HDB_DATETIME ORDER BY HDB_DATETIME';
    
    -- [JR] NEXT 6 LINES FILLS IN MISSING VALUES WITH NULL
    't.DATE_TIME AS HDB_DATETIME, CAST(NVL(VALUE,NULL) AS VARCHAR(10)) AS HDB_VALUE ' ||
    'FROM (' || i_sourcetable || '_' || l_tstep || ') v PARTITION BY (v.SITE_DATATYPE_ID) ' ||
    'RIGHT OUTER JOIN TABLE(DATES_BETWEEN(''' || i_startdate || ''', ''' || i_enddate ||
    ''', LOWER(''' || l_tstep || '''))) t ON v.' || l_periodEnd || ' = t.DATE_TIME WHERE ' ||
    'v.SITE_DATATYPE_ID IN (' || i_sdiList || ')) ' ||
    'GROUP BY HDB_DATETIME ORDER BY HDB_DATETIME';
    
  END IF;
  
  -- EXECUTE
  OPEN o_cursoroutput FOR l_sqlstatement;
  --OPEN o_cursoroutput FOR SELECT l_sqlstatement FROM dual; -- Used for testing
  
  -- CATCH ERRORS
  EXCEPTION WHEN OTHERS THEN
    OPEN o_cursoroutput FOR SELECT 'QUERY ERROR' FROM dual;
    
END GET_HDB_CGI_DATA;
/
show errors;
/

create or replace public synonym get_hdb_cgi_data for get_hdb_cgi_data;
grant execute on get_hdb_cgi_data to app_role;
grant execute on get_hdb_cgi_data to savoir_faire;



create or replace PROCEDURE  GET_HDB_CGI_INFO 
/*
Notes:
- This procedure gets SDI information  from HDB for use in the external CGI 
    program using a specified set of inputs as described below:
      o_cursorOutput  Container for outputs        
      i_sdiList       List of SDI #'s as a CSV
                      example: '1930,2146,2101'
- Search for '[JR]' in this code file for areas that could use some work
- POC: Jon Rocha, USBR, jrocha@usbr.gov
 
Change Log:
13FEB2015 - Started. Succesfully gets SDI info from HDB
*/
(
  o_cursorOutput  OUT sys_refcursor,        
  i_sdiList       IN VARCHAR2
)
IS
  l_sqlStatement  VARCHAR2(32767);
BEGIN
  l_sqlstatement := 'SELECT HDB_SITE_DATATYPE.SITE_DATATYPE_ID, '||
  'HDB_SITE.SITE_NAME, HDB_DATATYPE.DATATYPE_NAME, HDB_UNIT.UNIT_COMMON_NAME, ' ||
  'HDB_SITE.LAT, HDB_SITE.LONGI, HDB_SITE.ELEVATION, ' || 
  'HDB_SITE.DB_SITE_CODE ' || 
  'FROM HDB_SITE ' ||
  'INNER JOIN HDB_SITE_DATATYPE ' || 
  'ON HDB_SITE.SITE_ID=HDB_SITE_DATATYPE.SITE_ID ' ||
  'INNER JOIN HDB_DATATYPE ' ||
  'ON HDB_SITE_DATATYPE.DATATYPE_ID=HDB_DATATYPE.DATATYPE_ID ' ||
  'INNER JOIN HDB_UNIT ' ||
  'ON HDB_DATATYPE.UNIT_ID=HDB_UNIT.UNIT_ID ' ||
  'WHERE HDB_SITE_DATATYPE.SITE_DATATYPE_ID IN (' || i_sdiList || ') ';

  -- EXECUTE
  OPEN o_cursoroutput FOR l_sqlstatement;
  
  -- CATCH ERRORS
  EXCEPTION WHEN OTHERS THEN
    OPEN o_cursoroutput FOR SELECT 'QUERY ERROR' FROM dual;
    
END GET_HDB_CGI_INFO;
/
show errors;
/

create or replace public synonym get_hdb_cgi_info for get_hdb_cgi_info;
grant execute on get_hdb_cgi_info to app_role;
grant execute on get_hdb_cgi_info to savoir_faire;

