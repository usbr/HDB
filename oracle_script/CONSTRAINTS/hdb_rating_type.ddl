alter table hdb_rating_type
add constraint hdb_rating_algorithm_fk1 
foreign key (rating_algorithm)
references hdb_rating_algorithm (rating_algorithm);
