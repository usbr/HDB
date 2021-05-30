alter table ref_rating 
add  constraint ref_rating_rating_id_fk1 foreign key (rating_id)
references ref_site_rating (rating_id);
