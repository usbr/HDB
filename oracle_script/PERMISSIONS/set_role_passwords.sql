set echo on
set feedback on
spool set_role_passwords.out
-- THis script has been eliminated for the 11i install
-- script eliminated by M. Bogner , Sutron Corporation  03-June-2011

alter role app_role identified by hdb_app_;
alter role ref_meta_role identified by ref_meta_;
alter role hdb_meta_role identified by hdb_meta_;
/* alter role derivation_role identified by hdb_derivation_;  removed by  CP project   */

/* supposidely removed by C.  Marra during Model Run Project
alter role model_role identified by hdb_model_;
*/

spool off

exit;
