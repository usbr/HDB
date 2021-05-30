alter table REF_INTERVAL_COPY_LIMITS
add constraint RICL_INTERVAL_FK
foreign key   (INTERVAL)
references    HDB_INTERVAL (INTERVAL_NAME)
;

alter table REF_INTERVAL_COPY_LIMITS
add constraint RICL_SITE_DATATYPE_ID_FK
foreign key   (SITE_DATATYPE_ID)
references    HDB_SITE_DATATYPE (SITE_DATATYPE_ID)
;
