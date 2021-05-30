
alter table ref_loading_application_prop
add  constraint ref_loading_application_id_fk foreign key (loading_application_id)
references hdb_loading_application (loading_application_id);

