ALTER TABLE m_day
      DROP CONSTRAINT m_day_pk
;
ALTER TABLE m_hour    
      DROP CONSTRAINT m_hour_pk 
;
ALTER TABLE m_month       
      DROP CONSTRAINT m_month_pk 
; 
ALTER TABLE m_monthrange               
      DROP CONSTRAINT m_monthrange_pk 
; 
ALTER TABLE m_monthstat
      DROP CONSTRAINT m_monthstat_pk
; 
ALTER TABLE m_wy                         
      DROP CONSTRAINT m_wy_pk
;
ALTER TABLE m_year
      DROP CONSTRAINT m_year_pk
;  

ALTER TABLE r_base
      DROP CONSTRAINT r_base_pk
;  
ALTER TABLE r_base_archive
      DROP CONSTRAINT r_base_archive_pk
;  
ALTER TABLE r_base_update
      DROP CONSTRAINT r_base_update_pk
;  
ALTER TABLE r_day
      DROP CONSTRAINT r_day_pk
;  
ALTER TABLE r_daystat
      DROP CONSTRAINT r_daystat_pk
;  
ALTER TABLE r_hour
      DROP CONSTRAINT r_hour_pk
;
ALTER TABLE r_hourstat   
      DROP CONSTRAINT r_hourstat_pk
; 
ALTER TABLE r_instant
      DROP CONSTRAINT r_instant_pk
; 
ALTER TABLE r_month      
      DROP CONSTRAINT r_month_pk
;   
ALTER TABLE r_monthstat
      DROP CONSTRAINT r_monthstat_pk
;
ALTER TABLE r_monthstatrange         
      DROP CONSTRAINT r_monthstatrange_pk
;  
ALTER TABLE r_other
      DROP CONSTRAINT r_other_pk
;  
ALTER TABLE r_wy    
      DROP CONSTRAINT r_wy_pk 
;   
ALTER TABLE r_wystat
      DROP CONSTRAINT r_wystat_pk
; 
ALTER TABLE r_year
      DROP CONSTRAINT r_year_pk 
;  
ALTER TABLE r_yearstat
      DROP CONSTRAINT r_yearstat_pk
;  

ALTER TABLE hm_temp_data  
      DROP CONSTRAINT hm_temp_data_pk
;

ALTER TABLE ref_agg_disagg
      DROP CONSTRAINT ref_agg_disagg_pk
;
ALTER TABLE ref_app_data_source      
      DROP CONSTRAINT ref_app_data_source_pk
; 
ALTER TABLE ref_db_generic_list
      DROP CONSTRAINT ref_db_generic_list_pk
;
ALTER TABLE ref_db_list   
      DROP CONSTRAINT ref_db_list_pk
;
ALTER TABLE ref_derivation_source
      DROP CONSTRAINT ref_derivation_source_pk
; 
ALTER TABLE ref_derivation_destination
      DROP CONSTRAINT ref_derivation_destination_pk
; 
ALTER TABLE ref_div  
      DROP CONSTRAINT ref_div_pk
; 
ALTER TABLE ref_dmi_data_map    
      DROP CONSTRAINT ref_dmi_data_map_pk
;
ALTER TABLE REF_ENSEMBLE  drop constraint REF_ENSEMBLE_PK;
ALTER TABLE REF_ENSEMBLE drop constraint REF_ENSEMBLE_AGEN_ID_FK; 
ALTER TABLE REF_ENSEMBLE_KEYVAL drop constraint REF_ENSEMBLE_KEYVAL_PK;
ALTER TABLE REF_ENSEMBLE_KEYVAL drop constraint ENSEMBLE_KEY_ENSEMBLE_ID_FK;
ALTER TABLE REF_ENSEMBLE_TRACE  drop constraint REF_ENSEMBLE_TRACE_PK; 
ALTER TABLE REF_ENSEMBLE_TRACE drop constraint ensemble_tr_ensemble_id_fk; 
ALTER TABLE REF_ENSEMBLE_TRACE drop constraint ensemble_model_run_id_fk; 
ALTER TABLE ref_hm_filetype         
      DROP CONSTRAINT ref_hm_filetype_pk
;    
ALTER TABLE ref_hm_pcode           
      DROP CONSTRAINT ref_hm_pcode_pk
;
ALTER TABLE ref_hm_pcode_objecttype       
      DROP CONSTRAINT ref_hm_pcode_ob_pk
;
ALTER TABLE ref_hm_site
      DROP CONSTRAINT ref_hm_site_pk
;
ALTER TABLE ref_hm_site_datatype 
      DROP CONSTRAINT ref_hm_site_dat_pk
;  
ALTER TABLE ref_hm_site_hdbid          
      DROP CONSTRAINT ref_hm_site_hdb_pk
; 
ALTER TABLE ref_hm_site_pcode    
      DROP CONSTRAINT ref_hm_site_pcode_pk
;
ALTER TABLE ref_interval_redefinition
      DROP CONSTRAINT ref_interval_redefinition_pk
;
ALTER TABLE ref_model  
      DROP CONSTRAINT ref_model_pk
;
ALTER TABLE ref_model_run 
      DROP CONSTRAINT ref_model_run_pk
;
ALTER TABLE ref_model_user
      DROP CONSTRAINT ref_model_user_pk
; 
ALTER TABLE ref_res      
      DROP CONSTRAINT ref_res_pk  
;  
ALTER TABLE ref_res_flowlu            
      DROP CONSTRAINT ref_res_flowlu_pk   
; 
ALTER TABLE ref_res_wselu
      DROP CONSTRAINT ref_res_wselu_pk
;         
ALTER TABLE ref_site_coef
      DROP CONSTRAINT ref_site_coef_pk
;
ALTER TABLE ref_site_coeflu
      DROP CONSTRAINT ref_site_coeflu_pk
;    
ALTER TABLE ref_site_coef_day 
      DROP CONSTRAINT ref_site_coef_day_pk
;          
ALTER TABLE ref_site_coef_month 
      DROP CONSTRAINT ref_site_coef_month_pk
;          
ALTER TABLE ref_str
      DROP CONSTRAINT ref_str_pk
;    

ALTER TABLE hdb_agen 
      DROP CONSTRAINT hdb_agen_pk
;  
ALTER TABLE hdb_attr
   DROP CONSTRAINT hdb_attr_pk
; 
ALTER TABLE hdb_collection_system
      DROP CONSTRAINT hdb_collection_system_pk
;  
ALTER TABLE hdb_computed_datatype 
      DROP CONSTRAINT hdb_computed_datatype_pk
;  
ALTER TABLE hdb_damtype
      DROP CONSTRAINT hdb_damtype_pk
;
ALTER TABLE hdb_datatype 
      DROP CONSTRAINT hdb_datatype_pk
;  
ALTER TABLE hdb_datatype 
      DROP CONSTRAINT hdb_datatype_uk1
;  
ALTER TABLE hdb_datatype 
      DROP CONSTRAINT hdb_datatype_uk2
;  
ALTER TABLE hdb_data_source           
      DROP CONSTRAINT hdb_data_source_pk
;    
ALTER TABLE hdb_date_time_unit
      DROP CONSTRAINT hdb_date_time_unit_pk
;
ALTER TABLE hdb_derivation_flag
      DROP CONSTRAINT hdb_derivation_flag_pk
;   
ALTER TABLE hdb_dimension         
      DROP CONSTRAINT hdb_dimension_pk
;   
ALTER TABLE hdb_divtype
      DROP CONSTRAINT hdb_divtype_pk
;  
ALTER TABLE hdb_dmi_unit_map            
      DROP CONSTRAINT hdb_dmi_unit_map_pk
; 
ALTER TABLE hdb_gagetype                
      DROP CONSTRAINT hdb_gagetype_pk
; 
ALTER TABLE hdb_interval
      DROP CONSTRAINT hdb_interval_pk
;  
ALTER TABLE hdb_loading_application
      DROP CONSTRAINT hdb_loading_application_pk
;  
ALTER TABLE hdb_method
      DROP CONSTRAINT hdb_method_pk
;  
ALTER TABLE hdb_model 
      DROP CONSTRAINT hdb_model_pk
;
ALTER TABLE hdb_objecttype        
      DROP CONSTRAINT hdb_objecttype_pk
;

ALTER TABLE hdb_rating_algorithm        
      DROP CONSTRAINT hdb_rating_algoritm_pk;

ALTER TABLE hdb_rating_type       
      DROP CONSTRAINT hdb_rating_type_pk;

ALTER TABLE ref_rating        
      DROP CONSTRAINT ref_rating_pk;

ALTER TABLE ref_site_rating        
      DROP CONSTRAINT ref_site_rating_pk;

ALTER TABLE hdb_river 
      DROP CONSTRAINT hdb_river_pk
;
ALTER TABLE hdb_river_reach 
      DROP CONSTRAINT hdb_river_reach_pk
; 
ALTER TABLE hdb_site
      DROP CONSTRAINT hdb_site_pk
;
ALTER TABLE hdb_site_datatype 
      DROP CONSTRAINT hdb_site_datatype_pk
;   
ALTER TABLE hdb_site_datatype 
      DROP CONSTRAINT hdb_site_datatype_uk
;   
ALTER TABLE hdb_state
      DROP CONSTRAINT hdb_state_pk
;   
ALTER TABLE hdb_unit  
      DROP CONSTRAINT hdb_unit_pk
;
ALTER TABLE hdb_usbr_off
      DROP CONSTRAINT hdb_usbr_off_pk
;
ALTER TABLE hdb_validation            
      DROP CONSTRAINT hdb_validation_pk
;
