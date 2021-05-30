
set echo on
set feedback on
spool hdb_roleprivs.out

/***********************************************************************/
/*  grant privileges to model_priv_role                              */
/***********************************************************************/
/* Messy, but can't grant model_role to role; otherwise, certain
   procedures which *must* fire for app_role will not fire, due to fact that
   model_role is also automatically enabled. So, grant all model privs to 
   model_priv_role, then grant this role to app_role and model_role. */
grant insert, update, delete on REF_ENSEMBLE to model_priv_role;
grant insert, update, delete on REF_ENSEMBLE_KEYVAL to model_priv_role;
grant insert, update, delete on REF_ENSEMBLE_TRACE to model_priv_role;
grant insert, update, delete on REF_ENSEMBLE_ARCHIVE to model_priv_role;
grant insert, update, delete on REF_ENSEMBLE_KEYVAL_ARCHIVE to model_priv_role;
grant insert, update, delete on REF_ENSEMBLE_TRACE_ARCHIVE to model_priv_role;
grant insert, update, delete on ref_model_run to model_priv_role;
grant insert, delete, update on ref_model_run_keyval to model_priv_role;
grant insert, delete, update on ref_model_run_archive to model_priv_role;
grant insert, delete, update on ref_model_run_keyval_archive to model_priv_role;
grant insert, update (value), delete on m_day to model_priv_role;
grant insert, update (value), delete on m_hour to model_priv_role;
grant insert, update (value), delete on m_month to model_priv_role;
grant insert, update (value), delete on m_monthstat to model_priv_role;
grant insert, update (value), delete on m_monthrange to model_priv_role;
grant insert, update (value), delete on m_year to model_priv_role;
grant insert, update (value), delete on m_wy to model_priv_role;

/***********************************************************************/
/*  grant privileges to app_role                                       */
/***********************************************************************/
grant model_priv_role to app_role; 
grant connect to app_role;
grant insert, update, delete on hm_temp_data to app_role;
grant update (max_hourly_date, max_daily_date) on ref_hm_site_datatype to app_role;
grant insert, update, delete on ref_interval_copy_limits to app_role;
grant insert,update,delete on REF_DB_GENERIC_LIST to app_role;
grant insert, update, delete on ref_loading_application_prop to app_role;
grant insert, update, delete on r_base to app_role;
grant insert, update (value, source_id), delete on r_daystat to app_role;
grant insert, update (value, source_id), delete on r_hourstat to app_role;
grant insert, update (value, source_id), delete on r_monthstat to app_role;
grant insert, update (value, source_id), delete on r_monthstatrange to app_role;
grant insert, update (value, source_id), delete on r_yearstat to app_role;
grant insert, update (value, source_id), delete on r_wystat to app_role;
grant  select, insert, delete, update on ref_user_groups  to  app_role;          
grant alter tablespace to app_role;
grant execute on ratings to app_role;
/***********************************************************************/
/*  grant privileges to derivation_role                                */
/* derivation_role removed for CP Project 2008                         */
/***********************************************************************/
-- grant connect to derivation_role;
-- grant create table to derivation_role;
-- grant insert, update, delete on r_instant to derivation_role;
-- grant insert, update, delete on r_other to derivation_role;
-- grant insert, update, delete on r_hour to derivation_role;
-- grant insert, update, delete on r_day to derivation_role;
-- grant insert, update, delete on r_month to derivation_role;
-- grant insert, update, delete on r_year to derivation_role;
-- grant insert, update, delete on r_wy to derivation_role;
-- grant insert, update, delete on r_base_update to derivation_role;

/***********************************************************************/
/*  grant privileges to ref_meta_role                                   */
/***********************************************************************/
grant  alter any table to ref_meta_role;
-- grant  insert, delete, update on ref_derivation_source to ref_meta_role;      
-- grant  insert, delete, update on ref_derivation_destination to ref_meta_role;
grant  insert, delete, update on ref_div  to  ref_meta_role;      
grant  insert, delete, update on ref_ext_site_data_map  to  ref_meta_role;      
grant  insert, delete, update on ref_ext_site_data_map_keyval  to  ref_meta_role;      
grant  insert, delete, update on ref_interval_copy_limits to ref_meta_role;
grant  insert, delete, update on ref_interval_redefinition to ref_meta_role;
grant  insert, delete, update on ref_res  to  ref_meta_role;       
grant  insert, delete, update on ref_str  to  ref_meta_role;          
grant  select, insert, delete, update on ref_user_groups  to  ref_meta_role;          
grant  insert, delete, update on ref_source_priority  to  ref_meta_role;          
grant  insert, delete, update on ref_res_flowlu  to  ref_meta_role;
grant  insert, delete, update on ref_res_wselu  to  ref_meta_role;     
grant  insert, delete, update on ref_site_attr  to  ref_meta_role; 
grant  insert, delete, update on ref_site_coef  to  ref_meta_role; 
grant  insert, delete, update on ref_site_coef_day  to  ref_meta_role; 
grant  insert, delete, update on ref_site_coef_month  to  ref_meta_role; 
grant  insert, delete, update on ref_site_coeflu  to  ref_meta_role;       
grant  insert, update, delete on ref_app_data_source to ref_meta_role;       
grant  insert, delete, update on ref_agg_disagg  to  ref_meta_role;
grant  insert, delete, update on ref_dmi_data_map  to  ref_meta_role;
grant  insert, update, delete on ref_auth_site  to  ref_meta_role;
grant  insert, update, delete on ref_auth_site_datatype  to  ref_meta_role;
grant  insert, delete, update on ref_hm_site_pcode to ref_meta_role;
grant  insert, delete, update on ref_hm_site_hdbid to ref_meta_role;
grant  insert, delete, update on ref_hm_site  to ref_meta_role;
grant  insert, delete, update on ref_hm_pcode_objecttype to ref_meta_role;
grant  insert, delete, update on ref_hm_pcode to ref_meta_role;   
grant  insert, delete, update on ref_hm_filetype to ref_meta_role; 
grant  insert, delete, update (session_no, db_site_db_name, db_site_code) 
   on ref_db_list  to  ref_meta_role;
grant  insert, delete, update (site_datatype_id, hourly, daily, weekly, crsp, 
   hourly_delete, cutoff_minute, hour_offset) on ref_hm_site_datatype to 
   ref_meta_role;
grant insert, delete, update on ref_spatial_relation to ref_meta_role;

/***********************************************************************/
/*  grant privileges to hdb_meta_role                                  */
/***********************************************************************/
grant  alter any table to hdb_meta_role;
grant ref_meta_role to hdb_meta_role;
grant  insert, delete, update on hdb_agen  to  hdb_meta_role;      
grant  insert, delete, update on hdb_attr  to  hdb_meta_role;     
grant  insert, delete, update on hdb_attr_feature  to  hdb_meta_role;     
grant  insert, delete, update on hdb_collection_system  to  hdb_meta_role;   
/*grant  insert, delete, update on hdb_computed_datatype  to  hdb_meta_role;  */ 
/*grant  insert, delete, update on hdb_computed_datatype_component  to  hdb_meta_role;   */
grant  insert, delete, update on hdb_damtype  to  hdb_meta_role; 
grant  insert, delete, update on hdb_data_source  to  hdb_meta_role; 
grant  insert, delete, update on hdb_datatype  to  hdb_meta_role;   

grant  insert, delete, update on hdb_datatype_feature  to  hdb_meta_role;   
grant  insert, delete, update on hdb_date_time_unit  to  hdb_meta_role;   
-- grant  insert, delete, update on hdb_derivation_flag  to  hdb_meta_role;   
grant  insert, delete, update on hdb_divtype  to  hdb_meta_role; 
grant  insert, delete, update on hdb_dmi_unit_map  to  hdb_meta_role;  
grant  insert, delete, update on hdb_ext_site_code_sys  to  hdb_meta_role;  
grant  insert, delete, update on hdb_ext_site_code to  hdb_meta_role;  
grant  insert, delete, update on hdb_ext_data_code_sys  to  hdb_meta_role; 
grant  insert, delete, update on hdb_ext_data_code  to  hdb_meta_role;  
grant  insert, delete, update on hdb_ext_data_source  to  hdb_meta_role;  

grant  insert, delete, update on hdb_feature  to  hdb_meta_role;   
grant  insert, delete, update on hdb_feature_class  to  hdb_meta_role;   
grant  insert, delete, update on hdb_feature_property  to  hdb_meta_role;   
grant  insert, delete, update on hdb_gagetype  to  hdb_meta_role;    
grant  insert, delete, update on hdb_interval  to  hdb_meta_role;    
grant  insert, delete, update on hdb_loading_application  to  hdb_meta_role;    
grant  insert, delete, update on hdb_method  to  hdb_meta_role;   
grant  insert, delete, update on hdb_method_class  to  hdb_meta_role;   
grant  insert, delete, update on hdb_method_class_type  to  hdb_meta_role;   
grant  insert, delete, update on hdb_model  to  hdb_meta_role;       
grant  insert, delete, update on hdb_model_coord  to  hdb_meta_role;       
grant  insert, update, delete on hdb_modeltype to hdb_meta_role;
grant  insert, delete, update on hdb_objecttype  to  hdb_meta_role; 
grant  insert, delete, update on hdb_operator  to  hdb_meta_role; 
grant  insert, delete, update on hdb_overwrite_flag  to  hdb_meta_role; 
grant  insert, delete, update on hdb_property  to  hdb_meta_role;        
grant  insert, delete, update on hdb_rating_algorithm  to  hdb_meta_role;        
grant  insert, delete, update on hdb_rating_type  to  hdb_meta_role;        
grant  insert, delete, update on hdb_river  to  hdb_meta_role;        
grant  insert, delete, update on hdb_river_reach  to  hdb_meta_role; 
grant  insert, delete, update on hdb_site  to  hdb_meta_role;       
grant  insert, delete, update on hdb_site_datatype  to  hdb_meta_role;  
grant  insert, delete, update on hdb_state  to  hdb_meta_role;         
grant  insert, delete, update on hdb_usbr_off  to  hdb_meta_role;   
grant  insert, delete, update on hdb_validation  to  hdb_meta_role;
grant execute on ratings to ref_meta_role;
/***********************************************************************/
/*  grant privileges to monthly                                        */
/***********************************************************************/
grant insert, update (value, source_id), delete on r_monthstat to monthly;
grant insert, update (value, source_id), delete on r_monthstatrange to monthly;
grant insert, update (value), delete on m_month to monthly;
grant insert, update (value), delete on m_monthrange to monthly;
grant insert, update (value), delete on m_monthstat to monthly;
/***********************************************************************/
/*  grant privileges to savoir_faire                                   */
/***********************************************************************/
grant  hdb_meta_role to savoir_faire;
grant insert,update,delete on ref_loading_application_prop to savoir_faire;
grant insert,update,delete on REF_DB_GENERIC_LIST to savoir_faire;
grant insert,update,delete on REF_ENSEMBLE to savoir_faire;
grant insert,update,delete on REF_ENSEMBLE_KEYVAL to savoir_faire;
grant insert,update,delete on REF_ENSEMBLE_TRACE to savoir_faire;
grant insert,update,delete on REF_ENSEMBLE_ARCHIVE to savoir_faire;
grant insert,update,delete on REF_ENSEMBLE_KEYVAL_ARCHIVE to savoir_faire;
grant insert,update,delete on REF_ENSEMBLE_TRACE_ARCHIVE to savoir_faire;
grant insert, update (value), delete on m_day  to  savoir_faire;
grant insert, update (value), delete on m_hour  to  savoir_faire;
grant insert, update (value), delete on m_month  to  savoir_faire;
grant insert, update (value), delete on m_wy  to  savoir_faire;
grant insert, update (value), delete on m_year  to  savoir_faire;
grant insert, delete, update (value) on m_monthstat to savoir_faire;
grant insert, delete, update (value) on m_monthrange to savoir_faire;
grant insert, delete, update on r_base to savoir_faire;
grant insert, delete, update on ref_interval_copy_limits to savoir_faire;
grant insert, delete, update on ref_inter_copy_limits_archive to savoir_faire;
grant insert, update (value, source_id), delete on r_daystat to savoir_faire;
grant insert, update (value, source_id), delete on r_hourstat to savoir_faire;
grant insert, update (value, source_id), delete on r_monthstat to savoir_faire;
grant insert, update (value, source_id), delete on r_monthstatrange to savoir_faire;
grant insert, update (value, source_id), delete on r_yearstat to savoir_faire;
grant insert, update (value, source_id), delete on r_wystat to savoir_faire;
/***********************************************************************/
/*  grant privileges to cp_process                                     */
/***********************************************************************/
/***********************************************************************/
/*  grant privileges to calc_definition_role                           */
/***********************************************************************/
grant execute on ratings to calc_definition_role;
grant insert, delete, update on ref_interval_copy_limits to calc_definition_role;
grant insert, update on hdb_loading_application to calc_definition_role;
grant insert, update on hdb_site_datatype to calc_definition_role;

/* Missing privileges added on 09/2015*/
grant select, insert, delete, update on ref_user_groups to savoir_faire;
grant execute on riverware_connection to model_priv_role;
grant delete on hdb_loading_application to calc_definition_role;
grant select,insert,update,delete on REF_RATING to app_role;
grant select,insert,update,delete on REF_SITE_RATING to app_role;
grant select,insert,update,delete on REF_RATING to ref_meta_role;
grant select,insert,update,delete on REF_SITE_RATING to ref_meta_role;
grant select,insert,update,delete on REF_SOURCE_PRIORITY_ARCHIVE to ref_meta_role;
grant select on hdb_site_sequence to app_role;
grant select on hdb_site_sequence to public;
grant select,insert,update,delete on ref_ext_site_data_map_archive to hdb_meta_role;
grant select,insert,update,delete on ref_ext_site_data_map_key_arch  to hdb_meta_role;

/* Missing privileges added for Alarm on 07/01/2020 */
GRANT INSERT,UPDATE,DELETE on HDB_LOADING_APPLICATION  to CALC_DEFINITION_ROLE;

spool off
exit;

