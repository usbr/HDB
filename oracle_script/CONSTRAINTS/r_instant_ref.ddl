alter table    r_instant
add
   constraint  r_instant_fk1
   foreign key (validation)
   references  hdb_validation(validation);

alter table    r_instant
add
   constraint  r_instant_fk2
   foreign key (site_datatype_id)
   references  hdb_site_datatype(site_datatype_id);

alter table    r_instant
add
   constraint  r_instant_fk3
   foreign key (source_id)
   references  hdb_data_source(source_id);

alter table    r_instant
add
   constraint  r_instant_fk4
   foreign key (overwrite_flag)
   references  hdb_overwrite_flag(overwrite_flag);

alter table    r_instant
add
   constraint  r_instant_fk5
   foreign key (method_id)
   references  hdb_method(method_id);

