CREATE OR REPLACE FUNCTION check_supersystem_connection (select_string IN VARCHAR2) RETURN INTEGER IS
   test_count INTEGER;
   BEGIN
    test_count := -1;
    execute immediate select_string into test_count;

    if (test_count >= 0) then
     return (0);
    end if;

   EXCEPTION
     WHEN OTHERS THEN
       return (-1);

   END check_supersystem_connection;
/

grant execute on check_supersystem_connection to public;
--drop public synonym check_supersystem_connection;
create public synonym check_supersystem_connection for check_supersystem_connection;
