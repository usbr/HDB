--  foreign key for table REF_ENSEMBLE on agen_id from hdb_agen
alter table REF_ENSEMBLE add constraint REF_ENSEMBLE_AGEN_ID_FK 
foreign key (agen_id) 
references hdb_agen (agen_id) on delete cascade;
