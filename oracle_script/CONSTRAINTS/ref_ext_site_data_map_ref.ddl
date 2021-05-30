alter table ref_ext_site_data_map
add
  constraint ref_ext_site_data_map_fk1
  foreign key (ext_data_source_id)
  references  hdb_ext_data_source(ext_data_source_id);

alter table ref_ext_site_data_map
add
  constraint ref_ext_site_data_map_fk2
  foreign key (hdb_site_datatype_id)
  references  hdb_site_datatype(site_datatype_id);

alter table ref_ext_site_data_map
add
  constraint ref_ext_site_data_map_fk3
  foreign key (hdb_interval_name)
  references  hdb_interval(interval_name);

alter table ref_ext_site_data_map
add
  constraint ref_ext_site_data_map_fk4
  foreign key (hdb_method_id)
  references  hdb_method(method_id);

alter table ref_ext_site_data_map
add
  constraint ref_ext_site_data_map_fk6
  foreign key (hdb_agen_id)
  references  hdb_agen(agen_id);

alter table ref_ext_site_data_map
add 
  constraint check_extra_keys_y_n
  check (extra_keys_y_n in ('y', 'Y', 'n', 'N'));

alter table ref_ext_site_data_map
add 
  constraint check_is_active_y_n
  check (is_active_y_n in ('y', 'Y', 'n', 'N'));

alter table ref_ext_site_data_map 
  add constraint ref_esdm_computation_id_fk
  foreign key (hdb_computation_id) references cp_computation (computation_id);


