--  foreign key for table REF_ENSEMBLE_TRACE on ensemble_id from ref_ensemble
alter table REF_ENSEMBLE_TRACE add constraint ensemble_tr_ensemble_id_fk 
foreign key (ensemble_id) 
references ref_ensemble (ensemble_id) on delete cascade;

--  foreign key for table REF_ENSEMBLE_TRACE on site_datatype_id from hdb_site_datatype
alter table REF_ENSEMBLE_TRACE add constraint ensemble_model_run_id_fk 
foreign key (model_run_id) 
references ref_model_run (model_run_id) on delete cascade;
