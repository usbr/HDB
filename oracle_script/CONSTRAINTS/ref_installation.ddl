
alter table    ref_installation
add
   constraint  check_meta_data_install_type
   check       (meta_data_installation_type in ('master','snapshot','island'));


