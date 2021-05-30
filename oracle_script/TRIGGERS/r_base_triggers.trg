-- install the triggers to load a row to r_base_update that
-- notifies derivation application of data to process
-- 10/02/01  
--
-- Modified 2006 by C. Marra to accomodate new datatype management
-- Modified JANuary 2007 by M.bogner for derivation application retirement plan
-- Modified August 2007 by M.bogner for new commitee decisions regarding overwrite
-- Modified November 2007 by M. Bogner to insure usage of stored procedure  and move invalid flags
-- Modified March 2008 by M. Bogner to not require validation and only keep failed records from merging
-- Modified April 2008 by M. Bogner to pass along the method_id and toindicate the data may have come from the CP
-- Modified October 2008 by M. Bogner for change in validate proc for preprocessor project
-- Modified May 2009 by M. Bogner to handle unknown and wierd error of a blank validation '' as an ascii 32

create or replace trigger r_base_before_insert_update
before insert or update
on r_base
for each row
declare
  v_count            number;
  v_source_entry     number;
  v_invalid_interval number;
  e_bad_row          exception;
  text               varchar2(200);
begin

   if not (is_role_granted ('SAVOIR_FAIRE')) then
      check_sdi_auth (:new.site_datatype_id);
   end if;

   if (trunc(:new.start_date_time) > trunc(SYSDATE + 2/24)  ) then
      text := 'No future dates allowed in r_base tables';
      deny_action(text);
   end if;

  if :new.validation in ('E','+','-','w','n','|','^','~',chr(32)) then
     :new.data_flags := :new.validation || substr(:new.data_flags,1,19);
     :new.validation := NULL;
  end if;


  /* logic below added to attempt to foil Stored Procedures non-utilization  */
  if :new.date_time_loaded <> to_date('10-DEC-1815','dd-MON-yyyy') then
    :new.validation := 'F';
    :new.data_flags := 'Bad Load: Use Proc.';
  end if;

  :new.date_time_loaded:=sysdate;

  /* Start and end date must be equal for instant data.
     Datatype's allowable intervals must be either or instant
     for instant data */
  if (:new.interval = 'instant') then

     if ( :new.start_date_time <> :new.end_date_time) then
        text := 'Instant interval start and end date times must be equal';
        deny_action(text);
     end if;

     select count(*) into v_count
     from hdb_datatype dt, hdb_site_datatype sd
     where dt.allowable_intervals in ('instant','either')
       and sd.site_datatype_id = :new.site_datatype_id
       and sd.datatype_id = dt.datatype_id;

     if (v_count = 0) then
        text := 'Invalid Interval for this datatype';
        deny_action(text);
     end if;

  end if;

  /* Start date must be < end date for non-instant data.
     Datatype's allowable intervals must be either or non-instant
     for non-instant data */
  if (:new.interval <> 'instant') then

     if ( :new.start_date_time > :new.end_date_time) then
        text := 'Non-instant interval start date time must be less than the end date time';
        deny_action(text);
     end if;
     if ( :new.start_date_time = :new.end_date_time) then
        text := 'Non-instant interval start and end date times cannot be equal';
        deny_action(text);
     end if;

     select count(*) into v_count
     from hdb_datatype dt, hdb_site_datatype sd
     where dt.allowable_intervals in ('non-instant','either')
       and sd.site_datatype_id = :new.site_datatype_id
       and sd.datatype_id = dt.datatype_id;

     if (v_count = 0) then
        text := 'Invalid Interval for this datatype';
        deny_action(text);
     end if;

  end if;

  /* Validate record's agen_id against the datatype's agen_id
     (if there is one). */
  select count(*) into v_count
  from hdb_datatype dt, hdb_site_datatype sd
  where dt.agen_id is not null
    and sd.site_datatype_id = :new.site_datatype_id
    and sd.datatype_id = dt.datatype_id;

  if (v_count > 0) then
    select count(*) into v_count
    from hdb_datatype dt, hdb_site_datatype sd
    where dt.agen_id = :new.agen_id
      and sd.site_datatype_id = :new.site_datatype_id
      and sd.datatype_id = dt.datatype_id;

    if (v_count = 0) then
       text := 'Invalid Agency for this datatype';
       deny_action(text);
    end if;

  end if;

--  now validate the record before it goes into the table
--  old logic for validation removed because of business rule that modify_r_base_RAW will be used always
--  if (INSERTING and nvl(:new.validation,'Z') in ('Z')) or UPDATING then
  if (nvl(:new.validation,'Z') in ('Z')) then
    hdb_utilities.validate_r_base_record
      (:new.site_datatype_id,
       :new.interval,
       :new.start_date_time,
       :new.value,
       :new.validation);
  end if;

end;
/
show errors trigger r_base_before_insert_update;




create or replace trigger r_base_after_insert
after insert on r_base
for each row
declare
  v_count            number;
begin
-- Modified August 2007 by M.bogner for decision to force overwrites to be validated
-- and to add the new data_flags column
-- Modified March 2008 by M. Bogner for decision to to remove Validation requirement
-- As of March 2008 only keep data from being merged if it has an F (failed) validation

--  if nvl(:new.validation,'F') not in ('F','Z') or :new.overwrite_flag='O' then 
--  if nvl(:new.validation,'F') not in ('F','Z') then 
--    select count(*) into v_count from ref_interval_copy_limits
--      where :new.site_datatype_id=site_datatype_id
--        and :new.interval=interval;
--    only if there's a derivation spec
--      if v_count!=0 or :new.overwrite_flag='O' then
--   above logic removed for derivation replacement project
--      if v_count!=0 then

      if nvl(:new.validation,'x') not in ('F') then
          hdb_utilities.merge_into_r_interval(
            :new.site_datatype_id,
            :new.interval,
            :new.start_date_time,
            :new.end_date_time,
            :new.value,
            :new.validation,
            :new.overwrite_flag,
            :new.method_id,
            :new.data_flags,
            :new.date_time_loaded      
           );
      end if;
end;
/
show errors trigger r_base_after_insert;


create or replace trigger r_base_after_update
after update on r_base
for each row
declare
  v_count            number;
begin

-- archive the row that was changed
  insert into r_base_archive
    (site_datatype_id,
     interval,
     start_date_time,
     end_date_time,
     value,
     agen_id,
     overwrite_flag,
     date_time_loaded,
     validation,
     collection_system_id,
     loading_application_id,
     method_id,
     computation_id,
     archive_reason,
     date_time_archived,
     data_flags)
  values
    (:old.site_datatype_id,
     :old.interval,
     :old.start_date_time,
     :old.end_date_time,
     :old.value,
     :old.agen_id,
     :old.overwrite_flag,
     :old.date_time_loaded,
     :old.validation,
     :old.collection_system_id,
     :old.loading_application_id,
     :old.method_id,
     :old.computation_id,
     'UPDATE',
     sysdate,
     :old.data_flags
     );
-- removed overwrite flag logic August 2007 by M. Bogner due to HDB committee decision
-- removed validation logic March 2008 by M. Bogner due to HDB committee decision
-- As of March 2008 only keep data from being merged if it has an F (failed) validation

--  if nvl(:new.validation,'F') not in ('F','Z') or :new.overwrite_flag='O' then 
--  if nvl(:new.validation,'F') not in ('F','Z') then 
--    select count(*) into v_count from ref_interval_copy_limits
--      where :new.site_datatype_id=site_datatype_id
--        and :new.interval=interval;
--    only if there's a derivation spec or it's a forced 'O'verwrite
--      if v_count!=0 or :new.overwrite_flag='O' then
      if nvl(:new.validation,'x') not in ('F') then
          hdb_utilities.merge_into_r_interval(
            :new.site_datatype_id,
            :new.interval,
            :new.start_date_time,
            :new.end_date_time,
            :new.value,
            :new.validation,
            :new.overwrite_flag, 
            :new.method_id,
            :new.data_flags,  
            :new.date_time_loaded   
           );
      end if;
end;
/
show errors trigger r_base_after_update;

create or replace trigger r_base_before_delete
before delete on r_base
for each row
declare
  v_count            number;
begin

   if not (is_role_granted ('SAVOIR_FAIRE')) then
      check_sdi_auth (:old.site_datatype_id);
   end if;

end;
/
show errors trigger r_base_before_delete;


create or replace trigger r_base_after_delete
after delete on r_base
for each row
declare
  v_count              number;
  mod_start_date_time  date;
  mod_end_date_time    date;
  window_indicator     boolean;
begin

-- archive the row that was deleted
  insert into r_base_archive
    (site_datatype_id,
     interval,
     start_date_time,
     end_date_time,
     value,
     agen_id,
     overwrite_flag,
     date_time_loaded,
     validation,
     collection_system_id,
     loading_application_id,
     method_id,
     computation_id,
     archive_reason,
     date_time_archived,
     data_flags)
  values
    (:old.site_datatype_id,
     :old.interval,
     :old.start_date_time,
     :old.end_date_time,
     :old.value,
     :old.agen_id,
     :old.overwrite_flag,
     :old.date_time_loaded,
     :old.validation,
     :old.collection_system_id,
     :old.loading_application_id,
     :old.method_id,
     :old.computation_id,
     'DELETE',
     sysdate,
     :old.data_flags);


/*  now delete from the interval table if it exists  the thought was just try the delete
    if it works then OK otherwise a query to do the count and then do the delete seems
    to do twice the amount of work   

*/
--  modified the delete August 2007 by M.  Bogner to delete regardless of date_time_loaded
--  decided to keep it simple and don't over complicate it ,  for now...
--  modified the delete December 2007 by M.  Bogner to delete with respect to date_time_loaded
--  we just can't make up our minds...
        hdb_utilities.delete_from_interval(
         :old.site_datatype_id,
         :old.interval,
         :old.start_date_time,
         :old.end_date_time,
         :old.date_time_loaded);

end;
/
show errors trigger r_base_after_delete;
/
