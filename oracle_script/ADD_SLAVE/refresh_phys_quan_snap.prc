create or replace PROCEDURE refresh_phys_quan_snap                                                
   IS                                                                           
      the_db_name    VARCHAR2(30) := NULL;                                      
      v_count        NUMBER;                                                    
      my_mes         VARCHAR2(2000);                                            
                                                                                
      PROCEDURE refresh_czar_table(the_table  IN   VARCHAR)                     
      IS                                                                        
         -- This will get the primary key against the                           
         -- snapshot being refreshed.                                           
         CURSOR the_table_constraints IS                                        
             SELECT constraint_name, constraint_type, owner                     
             FROM all_constraints                                               
             WHERE table_name = upper(the_table)                                
             AND constraint_type = 'P';                                         
                                                                                
         CURSOR fk_constraints ( pk_name VARCHAR) IS                            
             SELECT constraint_name, table_name, owner                          
             FROM all_constraints                                               
             WHERE r_constraint_name =  pk_name;                                
                                                                                
      alter_stmt      VARCHAR2(300) := NULL;                                    
      curs_handle     INTEGER := NULL;                                          
      curs_ret_val    INTEGER;                                                  
	  table_owner     VARCHAR2(100);                                               
                                                                                
      BEGIN                                                                     
         -- disable all constraints on "the_table"                              
                                                                                
         FOR a_constraint IN the_table_constraints LOOP                         
                                                                                
		 -- Set the constraint owner, assumed to be the table owner                   
		 -- Icky to do this once for every constraint, as it should                   
		 -- be the same owner for all constraints on the table... but                 
		 -- also probably more efficient than opening the cursor again                
		 table_owner := a_constraint.owner;                                           
                                                                                
               FOR single_fk IN fk_constraints(a_constraint.constraint_name) LOOP                                                                               
                                                                                
                  alter_stmt := 'ALTER TABLE '|| single_fk.owner || '.' ||      
				single_fk.table_name ||                                                     
                                ' DISABLE CONSTRAINT '||single_fk.constraint_name;                                                                              
                                                                                
                                                                                
                                                                                
                  curs_handle := DBMS_SQL.OPEN_CURSOR;                          
                                                                                
                                                                                
                  DBMS_SQL.PARSE( curs_handle, alter_stmt, DBMS_SQL.NATIVE );   
                                                                                
                                                                                
                  curs_ret_val := DBMS_SQL.EXECUTE( curs_handle );              
                                                                                
                                                                                
                  DBMS_SQL.CLOSE_CURSOR( curs_handle );                         
                                                                                
                                                                                
               END LOOP;                                                        
         END LOOP;                                                              
                                                                                
         DBMS_SNAPSHOT.REFRESH(table_owner||'.'||the_table, 'c');               
                                                                                
         -- re-enable all the constraints on "the_table"                        
         FOR a_constraint IN the_table_constraints LOOP                         
               FOR single_fk IN fk_constraints(a_constraint.constraint_name) LOOP                                                                               
                                                                                
                  alter_stmt := 'ALTER TABLE '|| single_fk.owner || '.' ||      
                                     single_fk.table_name ||                    
                                     ' ENABLE CONSTRAINT '||single_fk.constraint_name;                                                                          
                                                                                
                  curs_handle := DBMS_SQL.OPEN_CURSOR;                          
                  DBMS_SQL.PARSE( curs_handle, alter_stmt, DBMS_SQL.NATIVE );   
                  curs_ret_val := DBMS_SQL.EXECUTE( curs_handle );              
                  DBMS_SQL.CLOSE_CURSOR( curs_handle );                         
               END LOOP;                                                        
         END LOOP;                                                              
      END;                                                                      
                                                                                
   BEGIN                                                                        
      BEGIN                                                                     
                                                                                
         SELECT db_site_db_name                                                 
         INTO the_db_name                                                       
         FROM ref_db_list                                                       
         WHERE session_no = 1;                                                  
                                                                                
	 -- Delete last refresh_monitor record for this DB, if there is one.           
	 SELECT count(db_site_db_name)                                                 
         INTO v_count                                                           
         FROM ref_phys_quan_refresh_monitor                                     
         WHERE db_site_db_name = the_db_name;                                   
                                                                                
         if (v_count = 1) then                                                  
  	   DELETE FROM ref_phys_quan_refresh_monitor                                 
           WHERE db_site_db_name = the_db_name;                                 
         end if;                                                                
                                                                                
         -- NOTE that the order of these refreshes IS important.                
         -- There are foreign key dependencies that could fail if               
         -- order is wrong.                                                     
         refresh_czar_table('HDB_DIMENSION');                                   
         refresh_czar_table('HDB_UNIT');                                        
         refresh_czar_table('HDB_PHYSICAL_QUANTITY');                           
                                                                                
 	 -- Write message to table which is monitored in Meta Data App                
         my_mes := 'Refresh of czar-maintained snapshots completed successfully 
at ' || upper(the_db_name);                                                     
                                                                                
         INSERT INTO ref_phys_quan_refresh_monitor                              
         VALUES (the_db_name, my_mes, 0);                                       
                                                                                
      EXCEPTION                                                                 
         WHEN others THEN                                                       
            my_mes := sqlerrm;                                                  
            INSERT INTO ref_phys_quan_refresh_monitor                           
            VALUES (the_db_name, upper (the_db_name) || ': ' || my_mes, 1);     
      END;                                                                      
   END refresh_phys_quan_snap;                                                  

/
show errors
/
