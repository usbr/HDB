alter table r_base add constraint
    r_base_fk1
    foreign key  (site_datatype_id)
    references hdb_site_datatype(site_datatype_id);
alter table r_base add constraint
    r_base_fk2
    foreign key  (interval)
    references hdb_interval(interval_name);
alter table r_base add constraint
    r_base_fk3
    foreign key  (agen_id)
    references hdb_agen(agen_id);
alter table r_base add constraint
    r_base_fk5
    foreign key  (method_id)
    references hdb_method(method_id);
alter table r_base add constraint
    r_base_fk6
    foreign key  (collection_system_id)
    references hdb_collection_system(collection_system_id);
alter table r_base add constraint
    r_base_fk7
    foreign key  (loading_application_id)
    references hdb_loading_application(loading_application_id);
alter table r_base add constraint
   r_base_fk8
   foreign key (overwrite_flag)
   references  hdb_overwrite_flag(overwrite_flag);
alter table r_base add constraint
   r_base_fk9
   foreign key (validation)
   references  hdb_validation(validation);

-- this added for the computation processor project
alter table r_base add constraint 
   r_base_computation_id_fk
   foreign key (computation_id) references cp_computation (computation_id);

