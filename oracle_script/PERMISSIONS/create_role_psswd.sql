set echo on
set feedback on
spool create_role_psswd.out

/* Run as psswd_user */
--drop table role_psswd;

create table role_psswd (
role varchar2 (30) NOT NULL,
psswd varchar2 (30) NOT NULL
)
pctfree 10
pctused 40
tablespace HDB_data
storage (initial 500k
         next     50k
         pctincrease 25);

alter table role_psswd add (constraint
    role_psswd_pk
    primary key (role)
using index storage(initial 70k next 70k pctincrease 0) tablespace HDB_idx);
	

/* Insert needed rows */
insert into role_psswd values ('app_role', 'hdb_app_');
insert into role_psswd values ('ref_meta_role', 'ref_meta_');
insert into role_psswd values ('hdb_meta_role', 'hdb_meta_');

/* supposidely removed by C.  Marra during Model Run Project
insert into role_psswd values ('model_role', 'hdb_model_');
*/
/*  insert into role_psswd values ('derivation_role', 'hdb_derivation_'); removed for cp project  */

spool off

exit;

