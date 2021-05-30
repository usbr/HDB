/* Czar_user */
create user czar_user identified by CZAR_PASSWD
default tablespace HDB_user quota unlimited on HDB_user
temporary tablespace HDB_temp;

grant create session to czar_user;
grant connect to czar_user;


/* Meta_data_user */
create user meta_data_user identified by MD_PASSWD
default tablespace HDB_user quota unlimited on HDB_user
temporary tablespace HDB_temp;

grant create session to meta_data_user;
grant connect to meta_data_user;

