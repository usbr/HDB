alter table ref_site_coef_day
add constraint ref_site_coef_day_ck1
check (day between '0' and '366');

alter table ref_site_coef_day
add constraint ref_site_coef_day_fk1
foreign key   (site_id)
references    hdb_site (site_id)
;

alter table ref_site_coef_day
add constraint ref_site_coef_day_fk2
foreign key   (attr_id)
references    hdb_attr (attr_id)
;
