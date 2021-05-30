--This DDL fixes missing columns in CP archive tables
--created by IsmailO on 08/2019

--add new columns for CP_COMPUTATION_ARCHIVE
ALTER TABLE CP_COMPUTATION_ARCHIVE  ADD GROUP_ID	NUMBER(38,0);
ALTER TABLE CP_COMPUTATION_ARCHIVE  ADD DB_OFFICE_CODE	NUMBER(38,0);
/

--add new columns for CP_COMP_TS_PARM_ARCHIVE
ALTER TABLE CP_COMP_TS_PARM_ARCHIVE  ADD DATATYPE_ID	NUMBER(38,0);
ALTER TABLE CP_COMP_TS_PARM_ARCHIVE  ADD DELTA_T_UNITS	VARCHAR2(24 BYTE);
ALTER TABLE CP_COMP_TS_PARM_ARCHIVE  ADD SITE_ID	NUMBER(38,0);
/

--add new columns for CP_ALGORITHM_ARCHIVE
ALTER TABLE CP_ALGORITHM_ARCHIVE  ADD DB_OFFICE_CODE NUMBER(38,0);



--update triggers for cp_computation

create or replace TRIGGER cp_computation_update
after update on cp_computation
for each row
begin
/*  This trigger created by M.  Bogner  04/05/2006
    modified by M. Bogner 05/11/2012 to add the cp_depends_notify logic
    This trigger archives any updates to the table
    cp_computation.
    Modified August 28 2012 to adjust the date time loaded back to a simple sysdate
    
    updated to add GROUP_ID,DB_OFFICE_CODE columns in archive table by IsmailO. 08/26/2019
*/

/* for PHASE 3.0 a change in computation will trigger a notification to adress CP_COMP_DEPENDS */
insert into cp_depends_notify (record_num,event_type,key,date_time_loaded) values (-1,'C',:NEW.COMPUTATION_ID,sysdate);
-- hdb_utilities.mod_date_for_time_zone(sysdate,hdb_utilities.get_db_parameter('SERVER_TIME_ZONE')));
-- removed Aug 2012 to change back to a simpel sysdate

insert into cp_computation_archive (
   COMPUTATION_ID,
   COMPUTATION_NAME,
   ALGORITHM_ID,
   CMMNT,
   LOADING_APPLICATION_ID,
   DATE_TIME_LOADED,
   ENABLED,
   EFFECTIVE_START_DATE_TIME,
   EFFECTIVE_END_DATE_TIME,
   ARCHIVE_REASON,
   DATE_TIME_ARCHIVED,
   ARCHIVE_CMMNT,
   GROUP_ID,
   DB_OFFICE_CODE
   
)
values (
   :old.COMPUTATION_ID,
   :old.COMPUTATION_NAME,
   :old.ALGORITHM_ID,
   :old.CMMNT,
   :old.LOADING_APPLICATION_ID,
   :old.DATE_TIME_LOADED,
   :old.ENABLED,
   :old.EFFECTIVE_START_DATE_TIME,
   :old.EFFECTIVE_END_DATE_TIME,
   'UPDATE',
   sysdate,
   NULL,
   :old.GROUP_ID,
   :old.DB_OFFICE_CODE);
-- the following removed from the archive insert and replaced with simple sysdate
--   hdb_utilities.mod_date_for_time_zone(sysdate,hdb_utilities.get_db_parameter('SERVER_TIME_ZONE')),

end;
/

create or replace TRIGGER cp_computation_delete
after delete on cp_computation
for each row
begin
/*  This trigger created by M.  Bogner  04/05/2006
    modified by M. Bogner 05/15/2012 to add the cp_depends_notify logic
    This trigger archives any deletes to the table
    cp_computation.
    Modified August 28 2012 to adjust the date time loaded back to a simple sysdate
    
    updated to add GROUP_ID,DB_OFFICE_CODE columns in archive table by IsmailO. 08/26/2019
*/

  /* for PHASE 3.0 a change in Computation will trigger a notification to address CP_COMP_DEPENDS */
  insert into cp_depends_notify (record_num,event_type,key,date_time_loaded) values (-1,'C',:OLD.COMPUTATION_ID,sysdate);
-- the following removed from the archive insert and replaced with simple sysdate
--  hdb_utilities.mod_date_for_time_zone(sysdate,hdb_utilities.get_db_parameter('SERVER_TIME_ZONE')));

insert into cp_computation_archive (
   COMPUTATION_ID,
   COMPUTATION_NAME,
   ALGORITHM_ID,
   CMMNT,
   LOADING_APPLICATION_ID,
   DATE_TIME_LOADED,
   ENABLED,
   EFFECTIVE_START_DATE_TIME,
   EFFECTIVE_END_DATE_TIME,
   ARCHIVE_REASON,
   DATE_TIME_ARCHIVED,
   ARCHIVE_CMMNT,
   GROUP_ID,
   DB_OFFICE_CODE
)
values (
   :old.COMPUTATION_ID,
   :old.COMPUTATION_NAME,
   :old.ALGORITHM_ID,
   :old.CMMNT,
   :old.LOADING_APPLICATION_ID,
   :old.DATE_TIME_LOADED,
   :old.ENABLED,
   :old.EFFECTIVE_START_DATE_TIME,
   :old.EFFECTIVE_END_DATE_TIME,
   'DELETE',
   sysdate,
   NULL,
   :old.GROUP_ID,
   :old.DB_OFFICE_CODE);
-- the following removed from the archive insert and replaced with simple sysdate
--   hdb_utilities.mod_date_for_time_zone(sysdate,hdb_utilities.get_db_parameter('SERVER_TIME_ZONE')),
end;
/





--update triggers for CP_COMP_TS_PARM_ARCHIVE
create or replace TRIGGER  cp_comp_ts_parm_delete
after delete on cp_comp_ts_parm
for each row
begin
/*  This trigger created by M.  Bogner  04/05/2006
    This trigger archives any deletes to the table
    cp_comp_ts_parm.

    updated 5/19/2008 by M. Bogner to update the date_time_loaded
    collumn of cp_computation table
    
    updated to add DATATYPE_ID,DELTA_T_UNITS,SITE_ID columns in archive table by IsmailO. 08/27/2019
*/
insert into cp_comp_ts_parm_archive (
   COMPUTATION_ID,
   ALGO_ROLE_NAME,
   SITE_DATATYPE_ID,
   INTERVAL,
   TABLE_SELECTOR,
   DELTA_T,
   MODEL_ID,
   ARCHIVE_REASON,
   DATE_TIME_ARCHIVED,
   ARCHIVE_CMMNT,
   DATATYPE_ID,
   DELTA_T_UNITS,
   SITE_ID
)
values (
  :old.COMPUTATION_ID,
  :old.ALGO_ROLE_NAME,
  :old.SITE_DATATYPE_ID,
  :old.INTERVAL,
  :old.TABLE_SELECTOR,
  :old.DELTA_T,
  :old.MODEL_ID,
  'DELETE',
  sysdate,
  NULL,
  :old.DATATYPE_ID,
  :old.DELTA_T_UNITS,
  :old.SITE_ID);

/* now update parent table's date_time_loaded for sql statements issued on this table */
  hdb_utilities.touch_cp_computation(:old.computation_id);
end;
/



create or replace TRIGGER cp_comp_ts_parm_update
after update or update on cp_comp_ts_parm
for each row
DECLARE
temp_computation_id cp_computation.computation_id%TYPE;
begin
/*  This trigger created by M.  Bogner  04/05/2006
    This trigger archives any updates to the table
    cp_comp_ts_parm.

    updated 5/19/2008 by M. Bogner to update the date_time_loaded
    column of cp_computation table
    
    updated to add DATATYPE_ID,DELTA_T_UNITS,SITE_ID columns in archive table by IsmailO. 08/27/2019
*/
temp_computation_id := :new.computation_id;

IF (UPDATING) THEN
  temp_computation_id := :old.computation_id;

  insert into cp_comp_ts_parm_archive (
   COMPUTATION_ID,
   ALGO_ROLE_NAME,
   SITE_DATATYPE_ID,
   INTERVAL,
   TABLE_SELECTOR,
   DELTA_T,
   MODEL_ID,
   ARCHIVE_REASON,
   DATE_TIME_ARCHIVED,
   ARCHIVE_CMMNT,
   DATATYPE_ID,
   DELTA_T_UNITS,
   SITE_ID
)
values (
  :old.COMPUTATION_ID,
  :old.ALGO_ROLE_NAME,
  :old.SITE_DATATYPE_ID,
  :old.INTERVAL,
  :old.TABLE_SELECTOR,
  :old.DELTA_T,
  :old.MODEL_ID,
  'UPDATE',
  sysdate,
  NULL,
  :old.DATATYPE_ID,
  :old.DELTA_T_UNITS,
  :old.SITE_ID);
END IF;

/* now update parent table's date_time_loaded for sql statements issued on this table */
  hdb_utilities.touch_cp_computation(temp_computation_id);

end;
/


--update CP_ALGORITHM_ARCHIVE triggers
create or replace TRIGGER cp_algorithm_update
after update on cp_algorithm
for each row
begin
/*  This trigger created by M.  Bogner  04/04/2006
    This trigger archives any updates to the table
    cp_algorithm.
    
    updated to add DB_OFFICE_CODE column in archive table by IsmailO. 08/26/2019
*/
insert into cp_algorithm_archive (
ALGORITHM_ID,
ALGORITHM_NAME,
EXEC_CLASS,
CMMNT,
ARCHIVE_REASON,
DATE_TIME_ARCHIVED,
ARCHIVE_CMMNT,
DB_OFFICE_CODE
)
values (
:old.ALGORITHM_ID,
:old.ALGORITHM_NAME,
:old.EXEC_CLASS,
:old.CMMNT,
'UPDATE',
sysdate,
NULL,
:old.DB_OFFICE_CODE);
end;
/


create or replace TRIGGER cp_algorithm_delete
after delete on cp_algorithm
for each row
begin
/*  This trigger created by M.  Bogner  04/04/2006
    This trigger archives any deletes to the table
    cp_algorithm.
    
    updated to add DB_OFFICE_CODE column in archive table by IsmailO. 08/26/2019    
*/
insert into cp_algorithm_archive (
ALGORITHM_ID,
ALGORITHM_NAME,
EXEC_CLASS,
CMMNT,
ARCHIVE_REASON,
DATE_TIME_ARCHIVED,
ARCHIVE_CMMNT,
DB_OFFICE_CODE
)
values (
:old.ALGORITHM_ID,
:old.ALGORITHM_NAME,
:old.EXEC_CLASS,
:old.CMMNT,
'DELETE',
sysdate,
NULL,
:old.DB_OFFICE_CODE);
end;
/


commit;
/

--Compile triggers

ALTER TRIGGER cp_computation_update COMPILE;
ALTER TRIGGER cp_computation_delete COMPILE;
ALTER TRIGGER cp_comp_ts_parm_delete COMPILE;
ALTER TRIGGER cp_comp_ts_parm_update COMPILE;
ALTER TRIGGER cp_algorithm_update COMPILE;
ALTER TRIGGER cp_algorithm_delete COMPILE;
/

--update version table
INSERT INTO TSDB_PROPERTY (PROP_NAME, PROP_VALUE) VALUES ('MissingColCPArchives', 'Y');
/

--Commit
commit;
