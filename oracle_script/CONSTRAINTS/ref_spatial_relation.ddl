
ALTER TABLE ref_spatial_relation
add constraint ref_spatial_relation_fk1
foreign key (a_site_id)
references hdb_site (site_id);

ALTER TABLE ref_spatial_relation
add constraint ref_spatial_relation_fk2
foreign key (b_site_id)
references hdb_site (site_id);

ALTER TABLE ref_spatial_relation
add constraint ref_spatial_relation_fk3
foreign key (attr_id)
references hdb_attr (attr_id);

