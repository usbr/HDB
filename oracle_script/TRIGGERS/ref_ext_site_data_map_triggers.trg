create or replace trigger ref_ext_site_data_map_check
before insert or update
on ref_ext_site_data_map
for each row
declare
  count_0_keys   number;
begin
  if (lower(:new.extra_keys_y_n) = 'n' and lower(:old.extra_keys_y_n) = 'y') then
    deny_action ('Updating from extra keys to no extra keys is not allowed. Delete old mapping record and create a new one.');
  elsif (lower(:new.extra_keys_y_n) = 'n' and lower(:old.extra_keys_y_n) is null) then
    select count(*) 
    into count_0_keys
    from ref_ext_site_data_map
    where ext_data_source_id = :new.ext_data_source_id
      and primary_site_code = :new.primary_site_code
      and primary_data_code = :new.primary_data_code
      and lower(extra_keys_y_n) = 'n'
      and mapping_id <> nvl(:new.mapping_id,-9999);
 
    if (count_0_keys > 0) then
      deny_action ('There is already a mapping for this source/site/data code with no extra keys.');
    end if;

  end if;
end;
/
show errors;



create or replace trigger ref_ext_site_data_map_dt_load
before insert or update on ref_ext_site_data_map
for each row
begin
  :new.date_time_loaded := sysdate;
end;
/
show errors trigger ref_ext_site_data_map_dt_load;


create or replace trigger ref_ext_site_data_map_arch_upd
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
    NULL);
end;
/
show errors trigger ref_ext_site_data_map_arch_upd;


create or replace trigger ref_ext_site_data_map_arch_del
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
    NULL);
end;
/
show errors trigger ref_ext_site_data_map_arch_del;

