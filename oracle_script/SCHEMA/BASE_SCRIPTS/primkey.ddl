set echo on
set feedback on
spool hdb_primkeys.out

ALTER user DBA 
default tablespace hdb_idx
quota unlimited on hdb_idx;

ALTER TABLE hdb_agen 
      ADD ( CONSTRAINT hdb_agen_pk
            PRIMARY KEY (agen_id) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));  
ALTER TABLE hdb_attr
   ADD ( CONSTRAINT hdb_attr_pk
         PRIMARY KEY (attr_id) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0)); 

ALTER TABLE hdb_attr_feature
      ADD ( CONSTRAINT hdb_attr_feature_pk
            PRIMARY KEY (attr_id, feature_class_id) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));  


ALTER TABLE hdb_collection_system
      ADD ( CONSTRAINT hdb_collection_system_pk
            PRIMARY KEY (collection_system_id)
            using index storage (initial 50k next 50k pctincrease 0)
            tablespace hdb_idx); 

-- removed for computation processor
-- ALTER TABLE hdb_computed_datatype 
--       ADD ( CONSTRAINT hdb_computed_datatype_pk
--       PRIMARY KEY (computation_id) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));  
-- 

/*
ALTER TABLE hdb_computed_datatype_component
      ADD ( CONSTRAINT hdb_computed_datatype_component_pk
      PRIMARY KEY (computation_id, order) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));  
*/

ALTER TABLE hdb_damtype
      ADD ( CONSTRAINT hdb_damtype_pk
            PRIMARY KEY (damtype_id) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));

ALTER TABLE hdb_data_source           
      ADD ( CONSTRAINT hdb_data_source_pk
            PRIMARY KEY (source_id) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));    

ALTER TABLE hdb_datatype 
      ADD ( CONSTRAINT hdb_datatype_pk
      PRIMARY KEY (datatype_id) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));  
ALTER TABLE hdb_datatype
      ADD ( CONSTRAINT hdb_datatype_uk1
            UNIQUE (datatype_name) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));

ALTER TABLE hdb_datatype_feature
      ADD ( CONSTRAINT hdb_datatype_feature_pk
            PRIMARY KEY (datatype_id, feature_class_id) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));  

ALTER TABLE hdb_date_time_unit
      ADD ( CONSTRAINT hdb_date_time_unit_pk
      PRIMARY KEY (date_time_unit) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));  

/* removed for CP project
-- alter table hdb_derivation_flag add constraint
--     hdb_derivation_flag_pk
--     primary key (derivation_flag) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0);
*/

ALTER TABLE hdb_divtype
      ADD ( CONSTRAINT hdb_divtype_pk
            PRIMARY KEY (divtype) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));  
ALTER TABLE hdb_dmi_unit_map            
      ADD ( CONSTRAINT hdb_dmi_unit_map_pk
            PRIMARY KEY (pr_unit_name,unit_id) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0)); 

alter table hdb_ext_site_code_sys
add constraint hdb_ext_site_code_sys_pk
primary key (ext_site_code_sys_id)
using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0);  

alter table hdb_ext_site_code_sys
add constraint hdb_ext_site_code_sys_uk
unique (ext_site_code_sys_name)
using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0);  

alter table hdb_ext_site_code
add constraint hdb_ext_site_code_pk
primary key (ext_site_code_sys_id, primary_site_code, hdb_site_id)
using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0);  

alter table hdb_ext_data_code_sys
add constraint hdb_ext_data_code_sys_pk
primary key (ext_data_code_sys_id)
using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0);  

alter table hdb_ext_data_code_sys
add constraint hdb_ext_data_code_sys_uk
unique (ext_data_code_sys_name)
using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0);  

alter table hdb_ext_data_code
add constraint hdb_ext_data_code_pk
primary key (ext_data_code_sys_id, primary_data_code, hdb_datatype_id)
using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0);  

alter table hdb_ext_data_source
add constraint hdb_ext_data_source_pk
primary key (ext_data_source_id)
using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0);  

alter table hdb_ext_data_source
add constraint hdb_ext_data_source_uk
unique (ext_data_source_name)
using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0);  

ALTER TABLE hdb_feature
      ADD ( CONSTRAINT hdb_feature_pk
            PRIMARY KEY (feature_id) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));  

ALTER TABLE hdb_feature
      ADD ( CONSTRAINT hdb_feature_uk
            UNIQUE (feature_class_id, feature_id) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));  

ALTER TABLE hdb_feature_class
      ADD ( CONSTRAINT hdb_feature_class_pk
            PRIMARY KEY (feature_class_id) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));  

ALTER TABLE hdb_feature_property
   ADD ( CONSTRAINT hdb_feature_property_pk
         PRIMARY KEY (feature_id, property_id)
         using index tablespace hdb_idx storage 
          (initial 50k next 50k pctincrease 0)); 

ALTER TABLE hdb_gagetype                
      ADD ( CONSTRAINT hdb_gagetype_pk
            PRIMARY KEY (gagetype_id) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0)); 

ALTER TABLE hdb_interval
      ADD ( CONSTRAINT hdb_interval_pk
      PRIMARY KEY (interval_name) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));  

ALTER TABLE hdb_loading_application
      ADD ( CONSTRAINT hdb_loading_application_pk
            PRIMARY KEY (loading_application_id)
            using index storage (initial 50k next 50k pctincrease 0)
            tablespace hdb_idx); 

ALTER TABLE hdb_method
      ADD ( CONSTRAINT hdb_method_pk
      PRIMARY KEY (method_id) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));  

ALTER TABLE hdb_method_class
      ADD ( CONSTRAINT hdb_method_class_pk
      PRIMARY KEY (method_class_id) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));  

ALTER TABLE hdb_method_class_type
      ADD ( CONSTRAINT hdb_method_class_type_pk
      PRIMARY KEY (method_class_type) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));  

ALTER TABLE hdb_model 
      ADD ( CONSTRAINT hdb_model_pk
            PRIMARY KEY (model_id) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));

ALTER TABLE hdb_modeltype
      ADD ( CONSTRAINT hdb_modeltype_pk
            PRIMARY KEY (modeltype) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));

ALTER TABLE hdb_model_coord
      ADD ( CONSTRAINT hdb_model_coord_pk
            PRIMARY KEY (model_id, db_site_code) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));

ALTER TABLE hdb_objecttype        
      ADD ( CONSTRAINT hdb_objecttype_pk
      PRIMARY KEY (objecttype_id) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));

ALTER TABLE hdb_operator
      ADD ( CONSTRAINT hdb_operator_pk
      PRIMARY KEY (operator) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));  

alter table hdb_overwrite_flag add constraint
    hdb_overwrite_flag_pk
    primary key (overwrite_flag) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0);

ALTER TABLE hdb_property
   ADD ( CONSTRAINT hdb_property_pk
         PRIMARY KEY (property_id) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0)); 

alter table hdb_rating_algorithm
add  constraint hdb_rating_algorithm_pk 
     primary key (rating_algorithm) 
     using index tablespace hdb_idx storage
     (initial 64k next 100k pctincrease 0);

alter table hdb_rating_type
add  constraint hdb_rating_type_pk 
     primary key (rating_type_common_name) 
     using index tablespace hdb_idx storage
     (initial 64k next 100k pctincrease 0);

ALTER TABLE hdb_river 
      ADD ( CONSTRAINT hdb_river_pk
            PRIMARY KEY (river_id) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));

ALTER TABLE hdb_river_reach 
      ADD ( CONSTRAINT hdb_river_reach_pk
            PRIMARY KEY (hydrologic_unit,segment_no) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0)); 

ALTER TABLE hdb_site
      ADD ( CONSTRAINT hdb_site_pk
            PRIMARY KEY (site_id) using index tablespace hdb_idx storage (initial 60k next 60k pctincrease 0));

ALTER TABLE DECODES_Site_ext
      ADD ( CONSTRAINT decodes_site_ext_pk
            PRIMARY KEY (SITE_ID) using index tablespace hdb_idx storage (initial 60k next 60k pctincrease 0));

ALTER TABLE hdb_site_datatype 
      ADD ( CONSTRAINT hdb_site_datatype_pk
      PRIMARY KEY (site_datatype_id) using index tablespace hdb_idx storage (initial 100k next 100k pctincrease 0));   

ALTER TABLE hdb_site_datatype 
      ADD ( CONSTRAINT hdb_site_datatype_uk
      UNIQUE(site_id,datatype_id) using index tablespace hdb_idx storage (initial 100k next 100k pctincrease 0));   

ALTER TABLE hdb_state
      ADD ( CONSTRAINT hdb_state_pk
            PRIMARY KEY (state_id) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));   

ALTER TABLE hdb_usbr_off
      ADD ( CONSTRAINT hdb_usbr_off_pk
            PRIMARY KEY (off_id) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));

ALTER TABLE hdb_validation            
      ADD ( CONSTRAINT hdb_validation_pk
            PRIMARY KEY (validation) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));

ALTER TABLE hm_temp_data  
      ADD ( CONSTRAINT hm_temp_data_pk
            PRIMARY KEY (site_datatype_id,date_date) using index tablespace hdb_idx storage (initial 100k next 100k pctincrease 0));

ALTER TABLE ref_agg_disagg
      ADD ( CONSTRAINT ref_agg_disagg_pk
            PRIMARY KEY (agg_disagg_id) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));

ALTER TABLE ref_app_data_source      
      ADD ( CONSTRAINT ref_app_data_source_pk
            PRIMARY KEY (executable_name) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0)); 

ALTER TABLE ref_auth_site
      ADD ( CONSTRAINT ref_auth_site_pk
            PRIMARY KEY (role, site_id) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));

ALTER TABLE ref_auth_site_datatype
      ADD ( CONSTRAINT ref_auth_sdi_pk
            PRIMARY KEY (role, site_datatype_id) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));

ALTER TABLE REF_DB_GENERIC_LIST
      ADD CONSTRAINT REF_DB_GENERIC_LIST_PK 
         PRIMARY KEY (RECORD_ID) 
         using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0);

ALTER TABLE ref_db_list   
      ADD ( CONSTRAINT ref_db_list_pk
            PRIMARY KEY (session_no) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));

ALTER TABLE ref_db_list
      ADD ( CONSTRAINT ref_db_list_uniq
            UNIQUE (db_site_code) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));

/* removed for CP project
--  alter table ref_derivation_source add constraint
--      ref_derivation_source_pk
--      primary key (site_datatype_id) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0);
*/

/* removed for CP Project
--  alter table ref_derivation_destination add constraint
--      ref_derivation_destination_pk
--      primary key (dest_site_datatype_id) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0);
*/


ALTER TABLE ref_div  
      ADD ( CONSTRAINT ref_div_pk
            PRIMARY KEY (divtype,site_id) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0)); 

ALTER TABLE ref_dmi_data_map    
      ADD ( CONSTRAINT ref_dmi_data_map_pk
            PRIMARY KEY (model_id, object_name, data_name) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));

ALTER TABLE REF_ENSEMBLE  add constraint REF_ENSEMBLE_PK
primary key (ensemble_id) 
using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0);
 
ALTER TABLE REF_ENSEMBLE_KEYVAL add constraint REF_ENSEMBLE_KEYVAL_PK
primary key (ensemble_id,key_name) 
using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0);

ALTER TABLE REF_ENSEMBLE_TRACE  add constraint REF_ENSEMBLE_TRACE_PK 
primary key (ensemble_id,trace_id,model_run_id) 
using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0);

alter table ref_ext_site_data_map
add constraint ref_ext_site_data_map_pk
primary key (mapping_id)  
using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0);  

alter table ref_ext_site_data_map_keyval
add constraint site_datatype_map_keyval_pk
primary key (mapping_id, key_name, key_value)
using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0);  

ALTER TABLE ref_hm_filetype         
      ADD ( CONSTRAINT ref_hm_filetype_pk
            PRIMARY KEY (hm_filetype) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));    

ALTER TABLE ref_hm_pcode           
      ADD ( CONSTRAINT ref_hm_pcode_pk
            PRIMARY KEY (hm_pcode) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));
ALTER TABLE ref_hm_pcode_objecttype       
      ADD ( CONSTRAINT ref_hm_pcode_ob_pk
            PRIMARY KEY (hm_pcode,objecttype_id) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));

ALTER TABLE ref_hm_site
      ADD ( CONSTRAINT ref_hm_site_pk
            PRIMARY KEY (hm_site_code) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));

ALTER TABLE ref_hm_site_datatype 
      ADD ( CONSTRAINT ref_hm_site_dat_pk
            PRIMARY KEY (site_datatype_id) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));  

ALTER TABLE ref_hm_site_hdbid          
      ADD ( CONSTRAINT ref_hm_site_hdb_pk
            PRIMARY KEY (hm_site_code,objecttype_id) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0)); 

ALTER TABLE ref_hm_site_pcode    
      ADD ( CONSTRAINT ref_hm_site_pcode_pk
            PRIMARY KEY (hm_site_code,hm_pcode, hm_filetype) using index tablespace hdb_idx storage (initial 150k next 150k pctincrease 0));

alter table ref_interval_copy_limits  
      ADD ( CONSTRAINT ricl_sdi_interval_pk
            PRIMARY key (site_datatype_id,interval,EFFECTIVE_START_DATE_TIME)
            using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));

alter table ref_interval_redefinition add constraint
    r_interval_redefinition_pk
    primary key (interval) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0);

ALTER TABLE ref_model_run 
      ADD ( CONSTRAINT ref_model_run_pk
            PRIMARY KEY (model_run_id) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));

ALTER TABLE ref_model_run_keyval 
      ADD ( CONSTRAINT ref_model_run_keyval_pk
            PRIMARY KEY (model_run_id, key_name) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));

alter table ref_rating  add ( constraint ref_rating_pk 
     primary key (rating_id, independent_value) 
     using index tablespace hdb_idx storage
     (initial 64k next 100k pctincrease 0));

ALTER TABLE ref_res      
      ADD ( CONSTRAINT ref_res_pk  
            PRIMARY KEY (site_id) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));  
ALTER TABLE ref_res_flowlu            
      ADD ( CONSTRAINT ref_res_flowlu_pk   
            PRIMARY KEY (site_id,flow) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0)); 

ALTER TABLE ref_res_wselu
      ADD ( CONSTRAINT ref_res_wselu_pk
            PRIMARY KEY (site_id) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));         

ALTER TABLE ref_site_attr
   ADD ( CONSTRAINT ref_site_attr_pk
         PRIMARY KEY (site_id, attr_id, effective_start_date_time)
	 using index tablespace hdb_idx storage 
	  (initial 50k next 50k pctincrease 0)); 
	  
alter table ref_site_rating
add  constraint ref_site_rating_pk 
     primary key (rating_id) 
     using index tablespace hdb_idx storage
     (initial 64k next 100k pctincrease 0);

ALTER TABLE ref_site_coef
      ADD ( CONSTRAINT ref_site_coef_pk
            PRIMARY KEY (site_id,attr_id,coef_idx,effective_start_date_time) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));

ALTER TABLE ref_site_coef_day 
      ADD ( CONSTRAINT ref_site_coef_day_pk
            PRIMARY KEY (site_id,attr_id,day,coef_idx,effective_start_date_time) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));          

ALTER TABLE ref_site_coef_month 
      ADD ( CONSTRAINT ref_site_coef_month_pk
            PRIMARY KEY (site_id,attr_id,month ,coef_idx,effective_start_date_time) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));          

ALTER TABLE ref_site_coeflu
      ADD ( CONSTRAINT ref_site_coeflu_pk
            PRIMARY KEY (site_id,lu_attr_id,lu_value,attr_id,coef_idx,effective_start_date_time) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));    

ALTER TABLE ref_source_priority
      ADD ( CONSTRAINT ref_source_priority_pk
            PRIMARY KEY (site_datatype_id, agen_id, priority_rank)
            using index storage (initial 50k next 50k pctincrease 0) tablespace hdb_idx); 

ALTER TABLE ref_str
      ADD ( CONSTRAINT ref_str_pk
            PRIMARY KEY (site_id) using index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));    


ALTER TABLE ref_loading_application_prop
      ADD ( CONSTRAINT ref_loading_application_p_pk
            PRIMARY KEY (loading_application_id,prop_name) using index tablespace hdb_idx
            storage (initial 50k next 50k pctincrease 0));


ALTER TABLE ref_spatial_relation
      ADD ( CONSTRAINT ref_spatial_relation_pk
            PRIMARY KEY (a_site_id, b_site_id, attr_id, effective_start_date_time) using 
      index tablespace hdb_idx storage (initial 50k next 50k pctincrease 0));  


ALTER TABLE REF_USER_GROUPS ADD CONSTRAINT REF_USER_GROUPS_PK PRIMARY KEY (USER_NAME,GROUP_NAME) ENABLE;


ALTER user DBA 
default tablespace hdb_data
quota unlimited on hdb_data;

spool off
exit

