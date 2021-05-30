--  foreign key for table REF_ENSEMBLE_KEYVAL on ensemble_id from REF_ENSEMBLE
alter table REF_ENSEMBLE_KEYVAL add constraint ENSEMBLE_KEY_ENSEMBLE_ID_FK 
foreign key (ensemble_id) 
references REF_ENSEMBLE (ensemble_id) on delete cascade;
