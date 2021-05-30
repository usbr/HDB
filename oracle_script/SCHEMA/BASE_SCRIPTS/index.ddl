set echo on
set feedback on
spool hdb_indexes.out

create index site_datatype_dt_idx
       on hdb_site_datatype   (datatype_id)        
pctfree 60
tablespace HDB_idx
storage(initial 150k next 150k pctincrease 0)   
;
Rem create index ixd252  
create index ref_auth_site_datatype_idx
       on ref_auth_site_datatype (role) 
pctfree 60
tablespace HDB_idx
storage(initial 30k next 30k pctincrease 0)   
;                                         
Rem create index ixd253
create index ref_auth_site_idx
       on ref_auth_site(role) 
pctfree 60
tablespace HDB_idx
storage(initial 30k next 30k pctincrease 0)   
;                               
Rem create index hdb_ext_site_code_siteid
create index hdb_ext_site_code_siteid
       on hdb_ext_site_code(hdb_site_id) 
pctfree 60
tablespace HDB_idx
storage(initial 30k next 30k pctincrease 0)   
;                               
rem create index REF_ENSEMBLE_NAME_UIDX for table REF_ENSEMBLE
CREATE UNIQUE INDEX REF_ENSEMBLE_NAME_UIDX 
       ON REF_ENSEMBLE(ensemble_name)
pctfree 60
tablespace HDB_idx
storage(initial 30k next 30k pctincrease 0)   
;

Rem create unique index ref_site_rating_sanity_uk
create unique index ref_site_rating_sanity_uk
 on ref_site_rating (indep_site_datatype_id,rating_type_common_name, effective_start_date_time,effective_end_date_time)
pctfree 10
tablespace HDB_idx
storage(initial 64k next 100k pctincrease 0)   
;                               

create unique index unit_abbr 
on hdb_unit (UNIT_COMMON_NAME) 
pctfree 10
tablespace hdb_idx
storage(initial 64k next 100k pctincrease 0)   
;


spool off
exit;

