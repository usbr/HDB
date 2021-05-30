set echo on
set feedback on
spool create_psswd_user.out

/* create tablespace PSSWD_user */
/* datafile '/oradb4/oradata/hdb/PSSWD_user.dbf' size 1M; */

-- drop user psswd_user cascade;

create user psswd_user identified by &1
default tablespace HDB_data quota 10M on HDB_data
temporary tablespace HDB_temp
QUOTA 10M on HDB_IDX;

grant connect to psswd_user;
grant create procedure to psswd_user;
grant create table to psswd_user;
grant create trigger to psswd_user;
grant select on dba_role_privs to psswd_user;
grant select on user$ to psswd_user;

spool off

exit;
