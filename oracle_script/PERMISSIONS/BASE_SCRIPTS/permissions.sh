#!/bin/bash 

# The following calls create the users, table, and triggers/procedures
# needed to implement new HDB permissions scheme.

sqlplus 'DBA/PASSWD as sysdba' @./PERMISSIONS/create_psswd_user.sql $HDB_LOCAL ;
# the role passwords were eliminated for 11i
# this was shutoff by M. Bogner, Sutron Corporation 03-June-2011
#sqlplus 'DBA/PASSWD as sysdba' @./PERMISSIONS/set_role_passwords.sql ;
sqlplus psswd_user/$HDB_LOCAL @./PERMISSIONS/create_role_psswd.sql ;
sqlplus psswd_user/$HDB_LOCAL @./PERMISSIONS/check_valid_role_name.prc ;
sqlplus psswd_user/$HDB_LOCAL @./PERMISSIONS/role_psswd_fk.trg ;
sqlplus 'DBA/PASSWD as sysdba' @./PERMISSIONS/create_app_user.sql $HDB_LOCAL ;
sqlplus 'DBA/PASSWD as sysdba' @./PERMISSIONS/local_user.sql ;
