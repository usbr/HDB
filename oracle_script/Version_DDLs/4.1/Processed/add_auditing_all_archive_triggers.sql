create or replace TRIGGER cp_algorithm_delete
after delete on cp_algorithm
for each row
begin
/*  This trigger created by M.  Bogner  04/04/2006
    This trigger archives any deletes to the table
    cp_algorithm.
*/
insert into cp_algorithm_archive (
ALGORITHM_ID,
ALGORITHM_NAME,
EXEC_CLASS,
CMMNT,
ARCHIVE_REASON,
DATE_TIME_ARCHIVED,
ARCHIVE_CMMNT
)
values (
:old.ALGORITHM_ID,
:old.ALGORITHM_NAME,
:old.EXEC_CLASS,
:old.CMMNT,
'DELETE',
sysdate,
coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         )
 );
end;
/

create or replace TRIGGER cp_algorithm_update
after update on cp_algorithm
for each row
begin
/*  This trigger created by M.  Bogner  04/04/2006
    This trigger archives any updates to the table
    cp_algorithm.
*/
insert into cp_algorithm_archive (
ALGORITHM_ID,
ALGORITHM_NAME,
EXEC_CLASS,
CMMNT,
ARCHIVE_REASON,
DATE_TIME_ARCHIVED,
ARCHIVE_CMMNT
)
values (
:old.ALGORITHM_ID,
:old.ALGORITHM_NAME,
:old.EXEC_CLASS,
:old.CMMNT,
'UPDATE',
sysdate,
coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         )
);
end;
/

create or replace TRIGGER cp_algo_property_delete
after delete on cp_algo_property
for each row
begin
/*  This trigger created by M.  Bogner  04/04/2006
    This trigger archives any deletes to the table
    cp_algo_property.
*/
insert into cp_algo_property_archive (
ALGORITHM_ID,
PROP_NAME,
PROP_VALUE,
ARCHIVE_REASON,
DATE_TIME_ARCHIVED,
ARCHIVE_CMMNT
)
values (
:old.ALGORITHM_ID,
:old.PROP_NAME,
:old.PROP_VALUE,
'DELETE',
sysdate,
coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         )
);
end;
/

create or replace TRIGGER cp_algo_property_update
after update on cp_algo_property
for each row
begin
/*  This trigger created by M.  Bogner  04/04/2006
    This trigger archives any updates to the table
    cp_algo_property.
*/
insert into cp_algo_property_archive (
ALGORITHM_ID,
PROP_NAME,
PROP_VALUE,
ARCHIVE_REASON,
DATE_TIME_ARCHIVED,
ARCHIVE_CMMNT
)
values (
:old.ALGORITHM_ID,
:old.PROP_NAME,
:old.PROP_VALUE,
'UPDATE',
sysdate,
coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         )
);
end;
/

create or replace TRIGGER cp_algo_ts_parm_delete
after delete on cp_algo_ts_parm
for each row
begin
/*  This trigger created by M.  Bogner  04/04/2006
    This trigger archives any deletes to the table
    cp_algo_ts_parm.
*/
insert into cp_algo_ts_parm_archive (
ALGORITHM_ID,
ALGO_ROLE_NAME,
PARM_TYPE,
ARCHIVE_REASON,
DATE_TIME_ARCHIVED,
ARCHIVE_CMMNT
)
values (
:old.ALGORITHM_ID,
:old.ALGO_ROLE_NAME,
:old.PARM_TYPE,
'DELETE',
sysdate,
coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         )
);
end;
/


create or replace TRIGGER cp_algo_ts_parm_update
after update on cp_algo_ts_parm
for each row
begin
/*  This trigger created by M.  Bogner  04/04/2006
    This trigger archives any updates to the table
    cp_algo_ts_parm.
*/
insert into cp_algo_ts_parm_archive (
ALGORITHM_ID,
ALGO_ROLE_NAME,
PARM_TYPE,
ARCHIVE_REASON,
DATE_TIME_ARCHIVED,
ARCHIVE_CMMNT
)
values (
:old.ALGORITHM_ID,
:old.ALGO_ROLE_NAME,
:old.PARM_TYPE,
'UPDATE',
sysdate,
coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         )
);
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
   coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         ),
   :old.GROUP_ID,
   :old.DB_OFFICE_CODE);
-- the following removed from the archive insert and replaced with simple sysdate
--   hdb_utilities.mod_date_for_time_zone(sysdate,hdb_utilities.get_db_parameter('SERVER_TIME_ZONE')),
end;
/

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
   coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         ),
   :old.GROUP_ID,
   :old.DB_OFFICE_CODE);
-- the following removed from the archive insert and replaced with simple sysdate
--   hdb_utilities.mod_date_for_time_zone(sysdate,hdb_utilities.get_db_parameter('SERVER_TIME_ZONE')),

end;
/

create or replace TRIGGER cp_comp_property_delete
after delete on cp_comp_property
for each row
begin
/*  This trigger created by M.  Bogner  04/05/2006
    This trigger archives any deletes to the table
    cp_comp_property.
*/
insert into cp_comp_property_archive (
   COMPUTATION_ID,
   PROP_NAME,
   PROP_VALUE,
   ARCHIVE_REASON,
   DATE_TIME_ARCHIVED,
   ARCHIVE_CMMNT
)
values (
   :old.COMPUTATION_ID,
   :old.PROP_NAME,
   :old.PROP_VALUE,
   'DELETE',
   sysdate,
   coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         )
);

/* now update parent table's date_time_loaded for sql statements issued on this table */
hdb_utilities.touch_cp_computation(:old.computation_id);

end;
/

create or replace TRIGGER cp_comp_property_update
after insert or update on cp_comp_property
for each row
DECLARE
temp_computation_id cp_computation.computation_id%TYPE;

begin
/*  This trigger created by M.  Bogner  04/05/2006
    This trigger archives any updates to the table
    cp_comp_property.
*/

temp_computation_id := :new.computation_id;

IF (UPDATING) THEN
 temp_computation_id := :old.computation_id;
 insert into cp_comp_property_archive (
   COMPUTATION_ID,
   PROP_NAME,
   PROP_VALUE,
   ARCHIVE_REASON,
   DATE_TIME_ARCHIVED,
   ARCHIVE_CMMNT
)
values (
   :old.COMPUTATION_ID,
   :old.PROP_NAME,
   :old.PROP_VALUE,
   'UPDATE',
   sysdate,
   coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         )
);
END IF;

/* now update parent table's date_time_loaded for sql statements issued on this table */
hdb_utilities.touch_cp_computation(temp_computation_id);

end;
/

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
  coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         ),
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
  coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         ),
  :old.DATATYPE_ID,
  :old.DELTA_T_UNITS,
  :old.SITE_ID);
END IF;

/* now update parent table's date_time_loaded for sql statements issued on this table */
  hdb_utilities.touch_cp_computation(temp_computation_id);

end;
/

create or replace TRIGGER hdb_ext_data_code_arch_del
after delete on hdb_ext_data_code
for each row
begin
insert into hdb_ext_data_code_archive (
EXT_DATA_CODE_SYS_ID,
PRIMARY_DATA_CODE,
SECONDARY_DATA_CODE,
HDB_DATATYPE_ID,
DATE_TIME_LOADED,
ARCHIVE_REASON,
DATE_TIME_ARCHIVED,
ARCHIVE_CMMNT) values (
:old.EXT_DATA_CODE_SYS_ID,
:old.PRIMARY_DATA_CODE,
:old.SECONDARY_DATA_CODE,
:old.HDB_DATATYPE_ID,
:old.date_time_loaded,
'DELETE',
sysdate,
coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         )
);
end;
/

create or replace TRIGGER hdb_ext_data_code_arch_upd
after update on hdb_ext_data_code
for each row
begin
insert into hdb_ext_data_code_archive (
EXT_DATA_CODE_SYS_ID,
PRIMARY_DATA_CODE,
SECONDARY_DATA_CODE,
HDB_DATATYPE_ID,
DATE_TIME_LOADED,
ARCHIVE_REASON,
DATE_TIME_ARCHIVED,
ARCHIVE_CMMNT)
values (
:old.EXT_DATA_CODE_SYS_ID,
:old.PRIMARY_DATA_CODE,
:old.SECONDARY_DATA_CODE,
:old.HDB_DATATYPE_ID,
:old.date_time_loaded,
'UPDATE',
sysdate,
coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         )
);
end;
/

create or replace TRIGGER hdb_ext_data_source_arch_del
after delete on hdb_ext_data_source
for each row
begin
insert into hdb_ext_data_source_archive (
EXT_DATA_SOURCE_ID,
EXT_DATA_SOURCE_NAME,
AGEN_ID,
MODEL_ID,
EXT_SITE_CODE_SYS_ID,
EXT_DATA_CODE_SYS_ID,
COLLECTION_SYSTEM_ID,
DATA_QUALITY,
DESCRIPTION,
DATE_TIME_LOADED,
ARCHIVE_REASON,
DATE_TIME_ARCHIVED,
ARCHIVE_CMMNT)
values (
:old.EXT_DATA_SOURCE_ID,
:old.EXT_DATA_SOURCE_NAME,
:old.AGEN_ID,
:old.MODEL_ID,
:old.EXT_SITE_CODE_SYS_ID,
:old.EXT_DATA_CODE_SYS_ID,
:old.COLLECTION_SYSTEM_ID,
:old.DATA_QUALITY,
:old.DESCRIPTION,
:old.date_time_loaded,
'DELETE',
sysdate,
coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         )
);
end;
/

create or replace TRIGGER hdb_ext_data_source_arch_upd
after update on hdb_ext_data_source
for each row
begin
insert into hdb_ext_data_source_archive (
EXT_DATA_SOURCE_ID,
EXT_DATA_SOURCE_NAME,
AGEN_ID,
MODEL_ID,
EXT_SITE_CODE_SYS_ID,
EXT_DATA_CODE_SYS_ID,
COLLECTION_SYSTEM_ID,
DATA_QUALITY,
DESCRIPTION,
DATE_TIME_LOADED,
ARCHIVE_REASON,
DATE_TIME_ARCHIVED,
ARCHIVE_CMMNT)
values (
:old.EXT_DATA_SOURCE_ID,
:old.EXT_DATA_SOURCE_NAME,
:old.AGEN_ID,
:old.MODEL_ID,
:old.EXT_SITE_CODE_SYS_ID,
:old.EXT_DATA_CODE_SYS_ID,
:old.COLLECTION_SYSTEM_ID,
:old.DATA_QUALITY,
:old.DESCRIPTION,
:old.date_time_loaded,
'UPDATE',
sysdate,
coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         )
);
end;
/

create or replace TRIGGER hdb_ext_site_code_arch_del
after delete on hdb_ext_site_code
for each row
begin
insert into hdb_ext_site_code_archive (
EXT_SITE_CODE_SYS_ID,
PRIMARY_SITE_CODE,
SECONDARY_SITE_CODE,
HDB_SITE_ID,
DATE_TIME_LOADED,
ARCHIVE_REASON,
DATE_TIME_ARCHIVED,
ARCHIVE_CMMNT)
values (
:old.EXT_SITE_CODE_SYS_ID,
:old.PRIMARY_SITE_CODE,
:old.SECONDARY_SITE_CODE,
:old.HDB_SITE_ID,
:old.date_time_loaded,
'DELETE',
sysdate,
coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         )
);
end;
/

create or replace TRIGGER hdb_ext_site_code_arch_upd
after update on hdb_ext_site_code
for each row
begin
insert into hdb_ext_site_code_archive (
EXT_SITE_CODE_SYS_ID,
PRIMARY_SITE_CODE,
SECONDARY_SITE_CODE,
HDB_SITE_ID,
DATE_TIME_LOADED,
ARCHIVE_REASON,
DATE_TIME_ARCHIVED,
ARCHIVE_CMMNT)
values (
:old.EXT_SITE_CODE_SYS_ID,
:old.PRIMARY_SITE_CODE,
:old.SECONDARY_SITE_CODE,
:old.HDB_SITE_ID,
:old.date_time_loaded,
'UPDATE',
sysdate,
coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         )
);
end;
/

create or replace TRIGGER ref_ext_site_data_map_arch_del
after delete on ref_ext_site_data_map
for each row
begin
-- archive the row that was changed
  insert into ref_ext_site_data_map_archive
   (mapping_id,
    ext_data_source_id,
    primary_site_code,
    primary_data_code,
    extra_keys_y_n,
    hdb_site_datatype_id,
    hdb_interval_name,
    hdb_method_id,
    hdb_computation_id,
    hdb_agen_id,
    is_active_y_n,
    cmmnt,
    date_time_loaded,
    archive_reason,
    date_time_archived,
    archive_cmmnt              )
  values
   (:old.mapping_id,
    :old.ext_data_source_id,
    :old.primary_site_code,
    :old.primary_data_code,
    :old.extra_keys_y_n,
    :old.hdb_site_datatype_id,
    :old.hdb_interval_name,
    :old.hdb_method_id,
    :old.hdb_computation_id,
    :old.hdb_agen_id,
    :old.is_active_y_n,
    :old.cmmnt,
    :old.date_time_loaded,
     'DELETE',
     sysdate,
    coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         )
);
end;
/

create or replace TRIGGER ref_ext_site_data_map_arch_upd
after update on ref_ext_site_data_map
for each row
begin
-- archive the row that was changed
  insert into ref_ext_site_data_map_archive
   (mapping_id,
    ext_data_source_id,
    primary_site_code,
    primary_data_code,
    extra_keys_y_n,
    hdb_site_datatype_id,
    hdb_interval_name,
    hdb_method_id,
    hdb_computation_id,
    hdb_agen_id,
    is_active_y_n,
    cmmnt,
    date_time_loaded,
    archive_reason,
    date_time_archived,
    archive_cmmnt              )
  values
   (:old.mapping_id,
    :old.ext_data_source_id,
    :old.primary_site_code,
    :old.primary_data_code,
    :old.extra_keys_y_n,
    :old.hdb_site_datatype_id,
    :old.hdb_interval_name,
    :old.hdb_method_id,
    :old.hdb_computation_id,
    :old.hdb_agen_id,
    :old.is_active_y_n,
    :old.cmmnt,
    :old.date_time_loaded,
     'UPDATE',
     sysdate,
    coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         )
);
end;
/


create or replace TRIGGER ref_interval_cp_limits_delete
after delete on ref_interval_copy_limits
for each row
begin
/*  This trigger created by M.  Bogner  11/19/2007
    This trigger archives any updates to the table
    ref_interval_copy_limits.

    modified by M. Bogner 27 Oct 2008 to account for
    new preprocessor columns
*/
insert into  ref_inter_copy_limits_archive (
SITE_DATATYPE_ID,
INTERVAL,
MIN_VALUE_EXPECTED,
MIN_VALUE_CUTOFF,
MAX_VALUE_EXPECTED,
MAX_VALUE_CUTOFF,
TIME_OFFSET_MINUTES,
DATE_TIME_LOADED,
ARCHIVE_REASON,
DATE_TIME_ARCHIVED,
ARCHIVE_CMMNT,
EFFECTIVE_START_DATE_TIME,
EFFECTIVE_END_DATE_TIME,
PREPROCESSOR_EQUATION
)
VALUES (
:old.SITE_DATATYPE_ID,
:old.INTERVAL,
:old.MIN_VALUE_EXPECTED,
:old.MIN_VALUE_CUTOFF,
:old.MAX_VALUE_EXPECTED,
:old.MAX_VALUE_CUTOFF,
:old.TIME_OFFSET_MINUTES,
:old.DATE_TIME_LOADED,
'DELETE',
sysdate,
coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         ),
:old.EFFECTIVE_START_DATE_TIME,
:old.EFFECTIVE_END_DATE_TIME,
:old.PREPROCESSOR_EQUATION
);
end;
/

create or replace TRIGGER ref_interval_cp_limits_update
after update on  ref_interval_copy_limits
for each row
begin
/*  This trigger created by M.  Bogner  11/19/2007
    This trigger archives any updates to the table
    ref_interval_copy_limits.

    modified by M. Bogner 27 Oct 2008 to account for
    new preprocessor columns
*/
insert into  ref_inter_copy_limits_archive (
SITE_DATATYPE_ID,
INTERVAL,
MIN_VALUE_EXPECTED,
MIN_VALUE_CUTOFF,
MAX_VALUE_EXPECTED,
MAX_VALUE_CUTOFF,
TIME_OFFSET_MINUTES,
DATE_TIME_LOADED,
ARCHIVE_REASON,
DATE_TIME_ARCHIVED,
ARCHIVE_CMMNT,
EFFECTIVE_START_DATE_TIME,
EFFECTIVE_END_DATE_TIME,
PREPROCESSOR_EQUATION
)
VALUES (
:old.SITE_DATATYPE_ID,
:old.INTERVAL,
:old.MIN_VALUE_EXPECTED,
:old.MIN_VALUE_CUTOFF,
:old.MAX_VALUE_EXPECTED,
:old.MAX_VALUE_CUTOFF,
:old.TIME_OFFSET_MINUTES,
:old.DATE_TIME_LOADED,
'UPDATE',
sysdate,
coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         ),
:old.EFFECTIVE_START_DATE_TIME,
:old.EFFECTIVE_END_DATE_TIME,
:old.PREPROCESSOR_EQUATION
);
end;
/

create or replace TRIGGER ref_interval_redef_arch_delete
after delete on ref_interval_redefinition
for each row
begin
-- archive the row that was changed
  insert into ref_interval_redef_archive
   (interval                  ,
    time_offset               ,
    offset_units              ,
    date_time_loaded          ,
    archive_reason            ,
    date_time_archived        ,
    archive_cmmnt              )
  values
   (:old.interval                  ,
    :old.time_offset               ,
    :old.offset_units              ,
    :old.date_time_loaded          ,
     'DELETE',
     sysdate,
    coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         )
);
end;
/

create or replace TRIGGER ref_interval_redef_arch_update
after update on ref_interval_redefinition
for each row
begin
-- archive the row that was changed
  insert into ref_interval_redef_archive
   (interval                  ,
    time_offset               ,
    offset_units              ,
    date_time_loaded          ,
    archive_reason            ,
    date_time_archived        ,
    archive_cmmnt              )
  values
   (:old.interval                  ,
    :old.time_offset               ,
    :old.offset_units              ,
    :old.date_time_loaded          ,
     'UPDATE',
     sysdate,
    coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         )
);
end;
/

create or replace TRIGGER ref_rating_arch_del
after delete on ref_rating for each row
begin
insert into ref_rating_archive (
RATING_ID,
INDEPENDENT_VALUE,
DEPENDENT_VALUE,
DATE_TIME_LOADED, ARCHIVE_REASON, DATE_TIME_ARCHIVED, ARCHIVE_CMMNT) values (
:old.RATING_ID,
:old.INDEPENDENT_VALUE,
:old.DEPENDENT_VALUE,
:old.date_time_loaded,'DELETE', sysdate, 
coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         )
);
end;
/

create or replace TRIGGER ref_rating_arch_upd
after update on ref_rating for each row
begin
insert into ref_rating_archive (
RATING_ID,
INDEPENDENT_VALUE,
DEPENDENT_VALUE,
DATE_TIME_LOADED, ARCHIVE_REASON, DATE_TIME_ARCHIVED, ARCHIVE_CMMNT) values (
:old.RATING_ID,
:old.INDEPENDENT_VALUE,
:old.DEPENDENT_VALUE,
:old.date_time_loaded,'UPDATE', sysdate, 
coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         )
);
end;
/

create or replace TRIGGER REF_SITE_ATTR_ARCH_DELETE
  AFTER DELETE ON REF_SITE_ATTR
  REFERENCING FOR EACH ROW
  DECLARE
temp_num NUMBER;
begin

    /* Added by M.  Bogner 10/01/11 for ACL II project */

    /*
    the purpose of this part of the trigger is to make sure that the user has permissions
    to modify this table since only DBA or DBA ACLII people can modify this table if ACL
    VERSION II is an active feature
    */

	/* see if ACL PROJECT II is enabled and if this is a group attribute if user is permitted */
	IF (hdb_utilities.is_feature_activated('ACCESS CONTROL LIST GROUP VERSION II') = 'Y'
	    AND hdb_utilities.GET_SITE_ACL_ATTR = :old.attr_id ) THEN
	  begin
	    temp_num := 0;
		/* see if user account is an active DBA or ACLII ACCOUNT */
		select count(*) into temp_num  from ref_user_groups
		where user_name = user and group_name in ('DBA','DBA ACLII');
		exception when others then
--		DENY_ACTION(SQLERRM);
		temp_num := -1;
	  end;

	  IF (temp_num < 1) THEN
		DENY_ACTION('ILLEGAL ACL VERSION II REF_SITE_ATTR DATABASE OPERATION -- No Permissions');
	  END IF;

	END IF;

/* now if the delete was allowed; then archive the old data  */

  insert into ref_site_attr_archive
   (site_id,
    attr_id,
    effective_start_date_time,
    effective_end_date_time,
    value,
    string_value,
    date_value,
    date_time_loaded,
    archive_reason,
    date_time_archived,
    archive_cmmnt)
  values
   (:old.site_id,
    :old.attr_id,
    :old.effective_start_date_time,
    :old.effective_end_date_time,
    :old.value,
    :old.string_value,
    :old.date_value,
    :old.date_time_loaded,
    'DELETE',
     sysdate,
    coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         )
);
end;
/

create or replace TRIGGER ref_site_attr_arch_update
after update on ref_site_attr
REFERENCING NEW AS NEW OLD AS OLD
for each row
begin
  insert into ref_site_attr_archive
   (site_id,
    attr_id,
    effective_start_date_time,
    effective_end_date_time,
    value,
    string_value,
    date_value,
    date_time_loaded,
    archive_reason,
    date_time_archived,
    archive_cmmnt)
  values
   (:old.site_id,
    :old.attr_id,
    :old.effective_start_date_time,
    :old.effective_end_date_time,
    :old.value,
    :old.string_value,
    :old.date_value,
    :old.date_time_loaded,
     'UPDATE',
     sysdate,
    coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         )
);
end;
/

create or replace TRIGGER ref_site_rating_arch_del
after delete on ref_site_rating for each row
begin
insert into ref_site_rating_archive (
RATING_ID,
INDEP_SITE_DATATYPE_ID,
RATING_TYPE_COMMON_NAME,
EFFECTIVE_START_DATE_TIME,
EFFECTIVE_END_DATE_TIME,
DATE_TIME_LOADED,
AGEN_ID,
DESCRIPTION,
ARCHIVE_REASON, DATE_TIME_ARCHIVED, ARCHIVE_CMMNT) values (
:old.RATING_ID,
:old.INDEP_SITE_DATATYPE_ID,
:old.RATING_TYPE_COMMON_NAME,
:old.EFFECTIVE_START_DATE_TIME,
:old.EFFECTIVE_END_DATE_TIME,
:old.DATE_TIME_LOADED,
:old.AGEN_ID,
:old.DESCRIPTION,
'DELETE', sysdate, 
coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         )
);
end;
/

create or replace TRIGGER ref_site_rating_arch_upd
after update on ref_site_rating for each row
begin
insert into ref_site_rating_archive (
RATING_ID,
INDEP_SITE_DATATYPE_ID,
RATING_TYPE_COMMON_NAME,
EFFECTIVE_START_DATE_TIME,
EFFECTIVE_END_DATE_TIME,
DATE_TIME_LOADED,
AGEN_ID,
DESCRIPTION,
ARCHIVE_REASON, DATE_TIME_ARCHIVED, ARCHIVE_CMMNT) values (
:old.RATING_ID,
:old.INDEP_SITE_DATATYPE_ID,
:old.RATING_TYPE_COMMON_NAME,
:old.EFFECTIVE_START_DATE_TIME,
:old.EFFECTIVE_END_DATE_TIME,
:old.DATE_TIME_LOADED,
:old.AGEN_ID,
:old.DESCRIPTION,
'UPDATE', sysdate, 
coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         )
);
 end;
/

create or replace TRIGGER ref_src_priority_arch_delete
after delete on ref_source_priority
for each row
begin
-- archive the row that was changed
  insert into ref_source_priority_archive
   (site_datatype_id           ,
    agen_id     ,
    priority_rank              ,
    date_time_loaded          ,
    archive_reason            ,
    date_time_archived        ,
    archive_cmmnt              )
  values
   (:old.site_datatype_id          ,
    :old.agen_id    ,
    :old.priority_rank             ,
    :old.date_time_loaded          ,
     'DELETE',
     sysdate,
    coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         )
);
end;
/

create or replace TRIGGER ref_src_priority_arch_update
after update on ref_source_priority
REFERENCING NEW AS NEW OLD AS OLD
for each row
begin
-- archive the row that was changed
  insert into ref_source_priority_archive
   (site_datatype_id           ,
    agen_id     ,
    priority_rank              ,
    date_time_loaded          ,
    archive_reason            ,
    date_time_archived        ,
    archive_cmmnt              )
  values
   (:old.site_datatype_id          ,
    :old.agen_id    ,
    :old.priority_rank             ,
    :old.date_time_loaded          ,
     'UPDATE',
     sysdate,
    coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         )
);
end;
/

create or replace TRIGGER site_data_map_keyval_arch_del
after delete on ref_ext_site_data_map_keyval
for each row
begin
insert into ref_ext_site_data_map_key_arch (
MAPPING_ID,
KEY_NAME,
KEY_VALUE,
DATE_TIME_LOADED,
ARCHIVE_REASON,
DATE_TIME_ARCHIVED,
ARCHIVE_CMMNT)
values (
:old.MAPPING_ID,
:old.KEY_NAME,
:old.KEY_VALUE,
:old.date_time_loaded,
'DELETE',
sysdate,
coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         )
);
end;
/

create or replace TRIGGER site_data_map_keyval_arch_upd
after update on ref_ext_site_data_map_keyval
for each row
begin
insert into ref_ext_site_data_map_key_arch (
MAPPING_ID,
KEY_NAME,
KEY_VALUE,
DATE_TIME_LOADED,
ARCHIVE_REASON,
DATE_TIME_ARCHIVED,
ARCHIVE_CMMNT)
values (
:old.MAPPING_ID,
:old.KEY_NAME,
:old.KEY_VALUE,
:old.date_time_loaded,
'UPDATE',
sysdate,
coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         )
);
end;
/



-- ----- ENSEMBLES Archives ------------
create or replace TRIGGER ref_ensemble_del
after delete on ref_ensemble for each row begin
insert into ref_ensemble_archive (
ENSEMBLE_ID,
ENSEMBLE_NAME,
AGEN_ID,
TRACE_DOMAIN,
CMMNT,
ARCHIVE_REASON, DATE_TIME_ARCHIVED, ARCHIVE_CMMNT) values (
:old.ENSEMBLE_ID,
:old.ENSEMBLE_NAME,
:old.AGEN_ID,
:old.TRACE_DOMAIN,
:old.CMMNT,
'DELETE', sysdate, 
coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         )
 ); end;
/

create or replace TRIGGER ref_ensemble_keyval_del
after delete on ref_ensemble_keyval for each row begin
insert into ref_ensemble_keyval_archive (
ENSEMBLE_ID,
KEY_NAME,
KEY_VALUE,
DATE_TIME_LOADED,
ARCHIVE_REASON, DATE_TIME_ARCHIVED, ARCHIVE_CMMNT) values (
:old.ENSEMBLE_ID,
:old.KEY_NAME,
:old.KEY_VALUE,
:old.DATE_TIME_LOADED,
'DELETE', sysdate, 
coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         )
); end;
/

create or replace TRIGGER ref_ensemble_keyval_upd
after update on ref_ensemble_keyval for each row begin
insert into ref_ensemble_keyval_archive (
ENSEMBLE_ID,
KEY_NAME,
KEY_VALUE,
DATE_TIME_LOADED,
ARCHIVE_REASON, DATE_TIME_ARCHIVED, ARCHIVE_CMMNT) values (
:old.ENSEMBLE_ID,
:old.KEY_NAME,
:old.KEY_VALUE,
:old.DATE_TIME_LOADED,
'UPDATE', sysdate, 
coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         )
); end;
/

create or replace TRIGGER ref_ensemble_trace_del
after delete on REF_ENSEMBLE_TRACE for each row begin
insert into REF_ENSEMBLE_TRACE_ARCHIVE(
ENSEMBLE_ID,
TRACE_ID,
TRACE_NUMERIC,
TRACE_NAME,
MODEL_RUN_ID,
ARCHIVE_REASON, DATE_TIME_ARCHIVED, ARCHIVE_CMMNT) values (
:old.ENSEMBLE_ID,
:old.TRACE_ID,
:old.TRACE_NUMERIC,
:old.TRACE_NAME,
:old.MODEL_RUN_ID,
'DELETE', sysdate, 
coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         )
); end;
/

create or replace TRIGGER ref_ensemble_trace_upd
after update on REF_ENSEMBLE_TRACE for each row begin
insert into REF_ENSEMBLE_TRACE_ARCHIVE (
ENSEMBLE_ID,
TRACE_ID,
TRACE_NUMERIC,
TRACE_NAME,
MODEL_RUN_ID,
ARCHIVE_REASON, DATE_TIME_ARCHIVED, ARCHIVE_CMMNT) values (
:old.ENSEMBLE_ID,
:old.TRACE_ID,
:old.TRACE_NUMERIC,
:old.TRACE_NAME,
:old.MODEL_RUN_ID,
'UPDATE', sysdate, 
coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         )
); end;
/

create or replace TRIGGER ref_ensemble_upd
after update on ref_ensemble for each row begin
insert into ref_ensemble_archive (
ENSEMBLE_ID,
ENSEMBLE_NAME,
AGEN_ID,
TRACE_DOMAIN,
CMMNT,
ARCHIVE_REASON, DATE_TIME_ARCHIVED, ARCHIVE_CMMNT) values (
:old.ENSEMBLE_ID,
:old.ENSEMBLE_NAME,
:old.AGEN_ID,
:old.TRACE_DOMAIN,
:old.CMMNT,
'UPDATE', sysdate, 
coalesce(
          sys_context('APEX$SESSION','app_user')
          ,sys_context('userenv','session_user')
         )
); end;
/

--update version table
INSERT INTO TSDB_PROPERTY (PROP_NAME, PROP_VALUE) VALUES ('4.1.2', 'HDB 4.1.2-archives_cmmnt column used for session audits for all archive tables');
/

--Commit
commit;

