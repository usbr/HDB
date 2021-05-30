set echo on
set feedback on
spool hdb_userprivs.out

grant select on DBA.cp_active_sdi_tsparm_view to public;
grant select on DBA.hdb_agen to public;
grant select on DBA.hdb_attr to public;
grant select on DBA.hdb_attr_feature to public;
grant select on DBA.hdb_collection_system to public;
/*grant select on DBA.hdb_computed_datatype to public;  */
/*grant select on DBA.hdb_computed_datatype_component to public;*/
grant select on DBA.hdb_damtype to public;
grant select on DBA.hdb_data_source to public;
grant select on DBA.hdb_datatype to public;
grant select on DBA.hdb_datatype_feature to public;
grant select on DBA.hdb_date_time_unit to public;
grant select on DBA.hdb_dimension to public;
/* grant select on DBA.hdb_derivation_flag to public; removed for CP Project */
grant select on DBA.REF_DB_GENERIC_LIST to public;
grant select on DBA.ref_div to public;
grant select on DBA.hdb_divtype to public;
grant select on DBA.hdb_dmi_unit_map to public;
grant select on DBA.hdb_ext_site_code_sys to public;
grant select on DBA.hdb_ext_site_code to public;
grant select on DBA.hdb_ext_site_code_archive to public;
grant select on DBA.hdb_ext_data_code_sys to public;
grant select on DBA.hdb_ext_data_code to public;
grant select on DBA.hdb_ext_data_code_archive to public;
grant select on DBA.hdb_ext_data_source to public;
grant select on DBA.hdb_ext_data_source_archive to public;
grant select on DBA.hdb_feature to public;
grant select on DBA.hdb_feature_class to public;
grant select on DBA.hdb_feature_property to public;
grant select on DBA.hdb_gagetype to public;
grant select on DBA.hdb_interval to public;
grant select on DBA.hdb_loading_application to public;
grant select on DBA.hdb_method to public;
grant select on DBA.hdb_method_class to public;
grant select on DBA.hdb_method_class_type to public;
grant select on DBA.hdb_model to public;
grant select on DBA.hdb_model_coord to public;
grant select on DBA.hdb_modeltype to public;
grant select on DBA.hdb_objecttype to public;
grant select on DBA.hdb_operator to public;
grant select on DBA.hdb_overwrite_flag to public;
grant select on DBA.hdb_physical_quantity to public;
grant select on DBA.hdb_property to public;
grant select on DBA.hdb_rating_algorithm to public;
grant select on DBA.hdb_rating_type to public;
grant select on DBA.hdb_river to public;
grant select on DBA.hdb_river_reach to public;
grant select on DBA.hdb_site to public;
grant select on DBA.hdb_site_datatype to public;
grant select on DBA.hdb_state to public;
grant select on DBA.hdb_unit to public;
grant select on DBA.hdb_usbr_off to public;
grant select on DBA.hdb_validation to public;
grant select on DBA.hm_temp_data to public;
grant select on DBA.m_day to public;
grant select on DBA.m_hour to public;
grant select on DBA.m_month to public;
grant select on DBA.m_monthrange to public;
grant select on DBA.m_monthstat to public;
grant select on DBA.m_wy to public;
grant select on DBA.m_year to public;
grant select on DBA.ref_agg_disagg to public;
grant select on DBA.ref_app_data_source to public;
grant select on DBA.ref_auth_site to public;
grant select on DBA.ref_auth_site_datatype to public;
grant select on DBA.ref_db_list to public;
/* grant select on DBA.ref_derivation_destination to public; removed for CP Project  */
/* grant select on DBA.ref_derivation_source to public; removed for CP Project  */
grant select on DBA.ref_dmi_data_map to public;
grant select on DBA.REF_ENSEMBLE to public;
grant select on DBA.REF_ENSEMBLE_KEYVAL to public;
grant select on DBA.REF_ENSEMBLE_TRACE to public;
grant select on DBA.REF_ENSEMBLE_ARCHIVE to public;
grant select on DBA.REF_ENSEMBLE_KEYVAL_ARCHIVE to public;
grant select on DBA.REF_ENSEMBLE_TRACE_ARCHIVE to public;
grant select on DBA.ref_ext_site_data_map to public;
grant select on DBA.ref_ext_site_data_map_archive to public;
grant select on DBA.ref_ext_site_data_map_keyval to public;
grant select on DBA.ref_ext_site_data_map_key_arch to public;
grant select on DBA.ref_hm_filetype to public;
grant select on DBA.ref_hm_pcode to public;
grant select on DBA.ref_hm_pcode_objecttype to public;
grant select on DBA.ref_hm_site to public;
grant select on DBA.ref_hm_site_datatype to public;
grant select on DBA.ref_hm_site_hdbid to public;
grant select on DBA.ref_hm_site_pcode to public;
grant select on DBA.ref_inter_copy_limits_archive to public;
grant select on DBA.ref_interval_copy_limits to public;
grant select on DBA.ref_inter_copy_limits_archive to public;
grant select on DBA.ref_interval_redefinition to public;
grant select on DBA.ref_interval_redef_archive to public;
grant select on DBA.ref_loading_application_prop to public;
grant select on DBA.ref_model_run to public;
grant select on DBA.ref_model_run_archive to public;
grant select on DBA.ref_model_run_keyval to public;
grant select on DBA.ref_model_run_keyval_archive to public;
grant select on DBA.ref_rating to public;
grant select on DBA.ref_rating_archive to public;
grant select on DBA.ref_res to public;
grant select on DBA.ref_res_flowlu to public;
grant select on DBA.ref_res_wselu to public;
grant select on DBA.ref_site_rating to public;
grant select on DBA.ref_site_rating_archive to public;
grant select on DBA.ref_site_attr to public;
grant select on DBA.ref_site_attr_archive to public;
grant select on DBA.ref_site_coef to public;
grant select on DBA.ref_site_coef_day to public;
grant select on DBA.ref_site_coef_month to public;
grant select on DBA.ref_site_coeflu to public;
grant select on DBA.ref_spatial_relation to public;
grant select on DBA.ref_source_priority to public;
grant select on DBA.ref_source_priority_archive to public;
grant select on DBA.ref_str to public;
grant select on DBA.ref_user_groups to public;
grant select on DBA.r_base to public;
grant select on DBA.r_base_archive to public;
/*  grant select on DBA.r_base_update to public;  removed for CP  */
grant select on DBA.r_day to public;
grant select on DBA.r_daystat to public;
grant select on DBA.r_hour to public;
grant select on DBA.r_hourstat to public;
grant select on DBA.r_instant to public;
grant select on DBA.r_month to public;
grant select on DBA.r_monthstat to public;
grant select on DBA.r_monthstatrange to public;
grant select on DBA.r_other to public;
grant select on DBA.r_wy to public;
grant select on DBA.r_wystat to public;
grant select on DBA.r_year to public;
grant select on DBA.r_yearstat to public;
/*   Missing grants added on 09/2015
grant select on DBA.V_HDB_SITE_DATATYPE_NAME to public;
grant select on DBA.HDB_DATATYPE_UNIT to public;
grant select on DBA.DAYS to public;
grant select on DBA.dba_roles to public;
GRANT SELECT ON DBA.HDB_SITE_ARCHIVE to PUBLIC;
GRANT SELECT ON DBA.HDB_DATATYPE_ARCHIVE to PUBLIC;
GRANT SELECT ON DBA.HDB_SITE_DATATYPE_ARCHIVE to PUBLIC;

 */
spool off
exit;

