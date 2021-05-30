CREATE OR REPLACE PROCEDURE refresh_phys_quan_snap_wrap (slave_db_site_code IN VARCHAR2) IS
   my_stmt VARCHAR2(1000);
   err_num NUMBER;
   BEGIN
     my_stmt := 'BEGIN run_refresh_phys_quan_snap_' || slave_db_site_code || '; END;';
     err_num := SQLCODE;

     execute immediate my_stmt;

     EXCEPTION
	  when others then
          err_num := SQLCODE;

          if err_num = -6550 then     
            RAISE_APPLICATION_ERROR (-20001, 'identifier not declared'); 
          else 
            RAISE_APPLICATION_ERROR (-20002, 'some other error');
          end if;

   END refresh_phys_quan_snap_wrap;
/
show errors
/

grant execute on refresh_phys_quan_snap_wrap to czar_role;
--drop public synonym refresh_phys_quan_snap_wrap;
create public synonym refresh_phys_quan_snap_wrap for refresh_phys_quan_snap_wrap;

