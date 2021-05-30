CREATE OR REPLACE PACKAGE TS_XFER as
/*  PACKAGE TS_XFER is designed to contain fast methods for timeseries
    writing and retrieval

    Created by A. Gilmore October 2015
*/
	/* declare the associative array table types for this package   */

--TYPE number_array is table of NUMBER;
--TYPE date_array is table of DATE; -- overriding main date_array date object array


procedure GET_REAL_DATA 
(
  sdi IN NUMBER 
, start_date IN DATE 
, end_date IN DATE
, interval IN HDB_INTERVAL.INTERVAL_NAME%type 
, dates OUT datearray
, ts_values OUT number_array
, inst_interval IN NUMBER DEFAULT 15 --interval for r_instant data
);

procedure GET_MODEL_DATA
(
  sdi IN NUMBER 
, start_date IN DATE 
, end_date IN DATE
, interval in HDB_INTERVAL.INTERVAL_NAME%type
, dates OUT datearray
, ts_values OUT number_array
, mri in REF_MODEL_RUN.MODEL_RUN_ID%type
);

-- the above two do little or no validation, as it would repeat what is in get_data
-- calling the above directly will be a bit faster as they avoid sdi. interval.
-- and mri table lookups.

-- get_date
-- given site_datatype_id, begin and end dates, an interval,
--       optional real or modeled indicator, and timeseries interval in minutes
-- return a correlated array of dates and values containing all the dates in 
-- the range, and any missing values as null
--
-- checks for valid site_datatype_id, end date after begin date,
-- interval, and model_run_id if modeled data


procedure GET_DATA
(
  sdi IN NUMBER 
, start_date IN DATE 
, end_date IN DATE
, interval in HDB_INTERVAL.INTERVAL_NAME%type
, dates OUT datearray
, ts_values OUT number_array
, real_or_model IN VARCHAR2 default 'R_'
, mri_or_interval in NUMBER default 15
);

-- Write data procedures for 2016 HDB Support Task
-- initially written by Andrew Gilmore Dec 2016

procedure WRITE_REAL_DATA
(
  sdi IN NUMBER
, INTERVAL IN hdb_interval.interval_name%TYPE
, dates IN datearray
, ts_values IN number_array
, agen_id NUMBER
, overwrite_flag VARCHAR2
, VALIDATION CHAR
, COLLECTION_SYSTEM_ID NUMBER
, LOADING_APPLICATION_ID NUMBER
, METHOD_ID NUMBER
, computation_id NUMBER
, do_update_y_n VARCHAR2
, data_flags IN VARCHAR2 DEFAULT NULL
, TIME_ZONE IN VARCHAR2 DEFAULT NULL
);

procedure WRITE_MODEL_DATA
(
  sdi IN NUMBER
, INTERVAL IN hdb_interval.interval_name%TYPE
, dates IN datearray
, ts_values IN number_array
, model_run_id IN NUMBER
, do_update_y_n IN VARCHAR2
);


END TS_XFER;
/
