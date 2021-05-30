alter table ref_site_rating
add constraint rsr_date_sanity_ck1
check(effective_start_date_time is null or effective_end_date_time is null 
or effective_start_date_time <= effective_end_date_time);

alter table ref_site_rating
add constraint rsr_rating_type_common_name_fk 
foreign key (rating_type_common_name)
references hdb_rating_type (rating_type_common_name);

alter table ref_site_rating
add constraint REF_SITE_RATING_SANITY_UK 
UNIQUE ("INDEP_SITE_DATATYPE_ID","RATING_TYPE_COMMON_NAME","EFFECTIVE_START_DATE_TIME","EFFECTIVE_END_DATE_TIME");
