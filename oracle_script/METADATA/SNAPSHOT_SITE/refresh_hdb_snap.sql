create or replace PROCEDURE refresh_HDB_snap  (which_table IN varchar2)
   IS
      the_db_name    VARCHAR2(30) := NULL;
      my_mes         VARCHAR2(2000);
      abbrev_table   VARCHAR2(2000) := 'ALL';
      standardized_table   VARCHAR2(2000) := 'ALL';
      test NUMBER;
      active_table   VARCHAR2(30);
	refresh_start_date VARCHAR2(30);
	refresh_end_date VARCHAR2(30);

      PROCEDURE refresh_snapshot_table(the_table  IN   VARCHAR)
      IS
         -- Oracle Consulting:  Gary Coy, 7-JAN-1999
         -- This will get the primary key against the
         -- snapshot being refreshed.
         CURSOR the_table_constraints IS
             SELECT constraint_name, constraint_type, owner
             FROM all_constraints
             WHERE table_name = upper(the_table)
             AND constraint_type in ('P','U');

         CURSOR fk_constraints ( pk_name VARCHAR) IS
             SELECT constraint_name, table_name, owner
             FROM all_constraints
             WHERE r_constraint_name =  pk_name;

      alter_stmt      VARCHAR2(300) := NULL;
      curs_handle     INTEGER := NULL;
      curs_ret_val    INTEGER;
      table_owner     VARCHAR2(100);
      is_archive      INTEGER;

      BEGIN
         active_table := the_table;

         -- disable all constraints on "the_table" except archive tables

         SELECT instr(lower(the_table),'archive')
         INTO is_archive
         FROM dual;

         IF (is_archive = 0 and upper(the_table) not in ('HDB_SITE_DATATYPE','HDB_INTERVAL','HDB_AGEN',
             'HDB_METHOD','HDB_COLLECTION_SYSTEM','HDB_LOADING_APPLICATION','HDB_OVERWRITE_FLAG','HDB_VALIDATION')) THEN
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
         ELSE  /* get owner of archive table and fast refresh tables */
           SELECT owner
           INTO table_owner
           FROM all_tables
           WHERE table_name = upper(the_table);
         END IF; /* is archive table or fast refresh table */

         if (upper(the_table)  not in ('HDB_SITE_DATATYPE','HDB_INTERVAL','HDB_AGEN',
             'HDB_METHOD','HDB_COLLECTION_SYSTEM','HDB_LOADING_APPLICATION','HDB_OVERWRITE_FLAG','HDB_VALIDATION')) THEN
           DBMS_SNAPSHOT.REFRESH(table_owner||'.'||the_table, 'c');
           commit;
         else
           DBMS_SNAPSHOT.REFRESH(table_owner||'.'||the_table, 'f');
           commit;
         end if;


         -- re-enable all the constraints on "the_table"
      if (upper(the_table)  not in ('HDB_SITE_DATATYPE','HDB_INTERVAL','HDB_AGEN',
             'HDB_METHOD','HDB_COLLECTION_SYSTEM','HDB_LOADING_APPLICATION','HDB_OVERWRITE_FLAG','HDB_VALIDATION')) THEN
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
      end if; -- fast refresh table



      END;
   BEGIN

      refresh_start_date := to_char (sysdate, 'DD-MON-YYYY HH24:MI:SS');

      BEGIN

	   DELETE FROM ref_refresh_monitor;
           COMMIT;

         SELECT db_site_db_name
         INTO the_db_name
         FROM ref_db_list
         WHERE session_no = 1;


         -- Oracle Consulting:  Gary Coy 29-OCT-1998
         -- This effectively 'hardcodes' the master HDB site
         -- to be Upper Colorado HDB in Salt Lake City
         -- This could be handled better, but for now, I think
         -- the odds of the master site moving are pretty slim.
         -- NOTE that the order of these refreshes IS important.
         -- There are foreign key dependencies that could fail if
         -- order is wrong.


	 -- Check to see if a subset of tables is to be refreshed, or ALL
	 if (which_table = 'ALL') THEN
               refresh_snapshot_table('HDB_FEATURE_CLASS');                     
               refresh_snapshot_table('HDB_FEATURE');                           
               refresh_snapshot_table('HDB_PROPERTY');                          
               refresh_snapshot_table('HDB_FEATURE_PROPERTY');                  
               refresh_snapshot_table('HDB_AGEN');                              
               refresh_snapshot_table('HDB_METHOD_CLASS_TYPE');                 
               refresh_snapshot_table('HDB_METHOD_CLASS');                      
               refresh_snapshot_table('HDB_OPERATOR');                          
               refresh_snapshot_table('HDB_METHOD');                            
               refresh_snapshot_table('HDB_DATE_TIME_UNIT');                    
               refresh_snapshot_table('HDB_INTERVAL');                          
     	       refresh_snapshot_table('HDB_OBJECTTYPE');                          
               refresh_snapshot_table('HDB_ATTR');                              
               refresh_snapshot_table('HDB_ATTR_FEATURE');                      
               refresh_snapshot_table('HDB_SITE');                              
               refresh_snapshot_table('HDB_DATATYPE');                          
               refresh_snapshot_table('HDB_DATATYPE_FEATURE');                  
               refresh_snapshot_table('HDB_DATA_SOURCE');                       
               refresh_snapshot_table('HDB_DIVTYPE');                           
               refresh_snapshot_table('HDB_GAGETYPE');                          
               refresh_snapshot_table('HDB_MODELTYPE');                         
               refresh_snapshot_table('HDB_RIVER');                             
               refresh_snapshot_table('HDB_STATE');                             
               refresh_snapshot_table('HDB_SITE_DATATYPE');                     
               refresh_snapshot_table('HDB_VALIDATION');                        
               refresh_snapshot_table('HDB_USBR_OFF');                          
               refresh_snapshot_table('HDB_RIVER_REACH');                       
               refresh_snapshot_table('HDB_MODEL');                             
               refresh_snapshot_table('HDB_MODEL_COORD');                       
               refresh_snapshot_table('HDB_DMI_UNIT_MAP');                      
               refresh_snapshot_table('HDB_DAMTYPE');                           
               refresh_snapshot_table('HDB_DERIVATION_FLAG');                   
               refresh_snapshot_table('HDB_OVERWRITE_FLAG');                    
               refresh_snapshot_table('HDB_COLLECTION_SYSTEM');                 
               refresh_snapshot_table('HDB_LOADING_APPLICATION');               
               refresh_snapshot_table('HDB_EXT_SITE_CODE_SYS');                 
               refresh_snapshot_table('HDB_EXT_DATA_CODE_SYS');                 
               refresh_snapshot_table('HDB_EXT_SITE_CODE');                     
               refresh_snapshot_table('HDB_EXT_SITE_CODE_ARCHIVE');             
               refresh_snapshot_table('HDB_EXT_DATA_CODE');                     
               refresh_snapshot_table('HDB_EXT_DATA_CODE_ARCHIVE');             
               refresh_snapshot_table('HDB_EXT_DATA_SOURCE');                   
               refresh_snapshot_table('HDB_EXT_DATA_SOURCE_ARCHIVE');           
               refresh_snapshot_table('HDB_RATING_TYPE');           
               refresh_snapshot_table('HDB_RATING_ALGORITHM');
               refresh_snapshot_table('HDB_SITE_ARCHIVE');
	       refresh_snapshot_table('HDB_SITE_DATATYPE_ARCHIVE');
               refresh_snapshot_table('HDB_DATATYPE_ARCHIVE');

	else
             /* Remove any spaces so the instr tests will be exact tests, e.g., not refreshing
                HDB_FEATURE when only HDB_FEATURE_PROPERTY is in the list of tables. Add a
                comma at the end so the last table in the list will be detected. */
 		 standardized_table := replace (upper(which_table),' ','');
	       abbrev_table := standardized_table ; -- This will be used in the status message
		 standardized_table := standardized_table ||',';

               if (instr(standardized_table,'HDB_FEATURE_CLASS,') > 0) then
		 refresh_snapshot_table('HDB_FEATURE_CLASS');
	       end if;
               if (instr(standardized_table,'HDB_FEATURE,') > 0) then
		 refresh_snapshot_table('HDB_FEATURE');
	       end if;
               if (instr(standardized_table,'HDB_PROPERTY,') > 0) then
		 refresh_snapshot_table('HDB_PROPERTY');
	       end if;
               if (instr(standardized_table,'HDB_FEATURE_PROPERTY,') > 0) then
		 refresh_snapshot_table('HDB_FEATURE_PROPERTY');
	       end if;
               if (instr(standardized_table,'HDB_AGEN,') > 0) then
		 refresh_snapshot_table('HDB_AGEN');
	       end if;
               if (instr(standardized_table,'HDB_METHOD_CLASS_TYPE,') > 0) then
		 refresh_snapshot_table('HDB_METHOD_CLASS_TYPE');
	       end if;
               if (instr(standardized_table,'HDB_METHOD_CLASS,') > 0) then
		 refresh_snapshot_table('HDB_METHOD_CLASS');
	       end if;
               if (instr(standardized_table,'HDB_OPERATOR,') > 0) then
		 refresh_snapshot_table('HDB_OPERATOR');
	       end if;
               if (instr(standardized_table,'HDB_METHOD,') > 0) then
		 refresh_snapshot_table('HDB_METHOD');
	       end if;
               if (instr(standardized_table,'HDB_DATE_TIME_UNIT,') > 0) then
		 refresh_snapshot_table('HDB_DATE_TIME_UNIT');
	       end if;
               if (instr(standardized_table,'HDB_INTERVAL,') > 0) then
		 refresh_snapshot_table('HDB_INTERVAL');
	       end if;
     	       if (instr(standardized_table,'HDB_OBJECTTYPE,') > 0) then
		 refresh_snapshot_table('HDB_OBJECTTYPE');
	       end if;
               if (instr(standardized_table,'HDB_ATTR,') > 0) then
		 refresh_snapshot_table('HDB_ATTR');
	       end if;
               if (instr(standardized_table,'HDB_ATTR_FEATURE,') > 0) then
		 refresh_snapshot_table('HDB_ATTR_FEATURE');
	       end if;
               if (instr(standardized_table,'HDB_SITE,') > 0) then
             refresh_snapshot_table('HDB_SITE');
	       end if;
                if (instr(standardized_table,'HDB_DATATYPE,') > 0) then
		 refresh_snapshot_table('HDB_DATATYPE');
	       end if;
               if (instr(standardized_table,'HDB_DATATYPE_FEATURE,') > 0) then
		 refresh_snapshot_table('HDB_DATATYPE_FEATURE');
	       end if;
               if (instr(standardized_table,'HDB_DATA_SOURCE,') > 0) then
		 refresh_snapshot_table('HDB_DATA_SOURCE');
	       end if;
               if (instr(standardized_table,'HDB_DIVTYPE,') > 0) then
		 refresh_snapshot_table('HDB_DIVTYPE');
	       end if;
               if (instr(standardized_table,'HDB_GAGETYPE,') > 0) then
		 refresh_snapshot_table('HDB_GAGETYPE');
	       end if;
               if (instr(standardized_table,'HDB_MODELTYPE,') > 0) then
		 refresh_snapshot_table('HDB_MODELTYPE');
	       end if;
               if (instr(standardized_table,'HDB_RIVER,') > 0) then
		 refresh_snapshot_table('HDB_RIVER');
	       end if;
               if (instr(standardized_table,'HDB_STATE,') > 0) then
		 refresh_snapshot_table('HDB_STATE');
	       end if;
               if (instr(standardized_table,'HDB_SITE_DATATYPE,') > 0) then
		 refresh_snapshot_table('HDB_SITE_DATATYPE');
	       end if;
               if (instr(standardized_table,'HDB_VALIDATION,') > 0) then
		 refresh_snapshot_table('HDB_VALIDATION');
	       end if;
               if (instr(standardized_table,'HDB_USBR_OFF,') > 0) then
		 refresh_snapshot_table('HDB_USBR_OFF');
	       end if;
               if (instr(standardized_table,'HDB_RIVER_REACH,') > 0) then
		 refresh_snapshot_table('HDB_RIVER_REACH');
	       end if;
               if (instr(standardized_table,'HDB_MODEL,') > 0) then
		 refresh_snapshot_table('HDB_MODEL');
	       end if;
               if (instr(standardized_table,'HDB_MODEL_COORD,') > 0) then
		 refresh_snapshot_table('HDB_MODEL_COORD');
	       end if;
               if (instr(standardized_table,'HDB_DMI_UNIT_MAP,') > 0) then
		 refresh_snapshot_table('HDB_DMI_UNIT_MAP');
	       end if;
               if (instr(standardized_table,'HDB_DAMTYPE,') > 0) then
		 refresh_snapshot_table('HDB_DAMTYPE');
	       end if;
               if (instr(standardized_table,'HDB_DERIVATION_FLAG,') > 0) then
		 refresh_snapshot_table('HDB_DERIVATION_FLAG');
	       end if;
               if (instr(standardized_table,'HDB_OVERWRITE_FLAG,') > 0) then
		 refresh_snapshot_table('HDB_OVERWRITE_FLAG');
	       end if;
               if (instr(standardized_table,'HDB_COLLECTION_SYSTEM,') > 0) then
		 refresh_snapshot_table('HDB_COLLECTION_SYSTEM');
	       end if;
               if (instr(standardized_table,'HDB_LOADING_APPLICATION,') > 0) then
		 refresh_snapshot_table('HDB_LOADING_APPLICATION');
	       end if;
               if (instr(standardized_table,'HDB_EXT_SITE_CODE_SYS,') > 0) then
		 refresh_snapshot_table('HDB_EXT_SITE_CODE_SYS');
	       end if;
               if (instr(standardized_table,'HDB_EXT_DATA_CODE_SYS,') > 0) then
		 refresh_snapshot_table('HDB_EXT_DATA_CODE_SYS');
	       end if;
               if (instr(standardized_table,'HDB_EXT_SITE_CODE,') > 0) then
		 refresh_snapshot_table('HDB_EXT_SITE_CODE');
	       end if;
               if (instr(standardized_table,'HDB_EXT_SITE_CODE_ARCHIVE,') > 0) then
		 refresh_snapshot_table('HDB_EXT_SITE_CODE_ARCHIVE');
	       end if;
               if (instr(standardized_table,'HDB_EXT_DATA_CODE,') > 0) then
		 refresh_snapshot_table('HDB_EXT_DATA_CODE');
	       end if;
               if (instr(standardized_table,'HDB_EXT_DATA_CODE_ARCHIVE,') > 0) then
		 refresh_snapshot_table('HDB_EXT_DATA_CODE_ARCHIVE');
	       end if;           
               if (instr(standardized_table,'HDB_RATING_TYPE,') > 0) then
		 refresh_snapshot_table('HDB_RATING_TYPE');
	       end if;
               if (instr(standardized_table,'HDB_RATING_ALGORITHM,') > 0) then
		 refresh_snapshot_table('HDB_RATING_ALGORITHM');
	       end if;
               if (instr(standardized_table,'HDB_SITE_ARCHIVE,') > 0) then
		 refresh_snapshot_table('HDB_SITE_ARCHIVE');
	       end if;
               if (instr(standardized_table,'HDB_SITE_DATATYPE_ARCHIVE,') > 0) then
		 refresh_snapshot_table('HDB_SITE_DATATYPE_ARCHIVE');
	       end if;
               if (instr(standardized_table,'HDB_DATATYPE_ARCHIVE,') > 0) then
		 refresh_snapshot_table('HDB_DATATYPE_ARCHIVE');
	       end if;           
               if (instr(standardized_table,'HDB_EXT_DATA_SOURCE,') > 0) then
		 refresh_snapshot_table('HDB_EXT_DATA_SOURCE');
	       end if;
               /* Have to check for just 'ARC', not the full archive table name,
                  because in APEX procedure set_refresh_tables, the archive table
                  name is created by removing the '_SYN' from the application item
                  ARCHIVE_TABLE_NAME. This table is the one HDB_ table where the
                  archive table's synonym is not simply the table name + '_SYN', so
                  this is handled as a special case. No other tables will match this
                  instr, so refreshing the table twice is not a concern */
               if (instr(standardized_table,'HDB_EXT_DATA_SOURCE_ARC') > 0) then
		 refresh_snapshot_table('HDB_EXT_DATA_SOURCE_ARCHIVE');
	       end if;
            end if;

   	    -- Write message to table which is monitored by refresh
            -- trigger in forms app
          refresh_end_date := to_char (sysdate, 'DD-MON-YYYY HH24:MI:SS');


            INSERT INTO ref_refresh_monitor values (substr(upper (the_db_name)||': STARTED: '||refresh_start_date||' COMPLETED: '||refresh_end_date||' : SUCCESS -- Refresh of '||abbrev_table || ' snapshot(s) completed.',1,2000),0);
            -- for debugging:
            -- dbms_output.put_line(upper (the_db_name)||': STARTED: '||refresh_start_date||' COMPLETED: '||refresh_end_date||' : SUCCESS -- Refresh of '||abbrev_table || ' snapshot(s) completed.');
            COMMIT;

      EXCEPTION
         WHEN others THEN
            my_mes := sqlerrm;
            refresh_end_date := to_char (sysdate, 'DD-MON-YYYY HH24:MI:SS');
	          INSERT INTO ref_refresh_monitor values (substr(upper (the_db_name)||': STARTED: '||refresh_start_date||' COMPLETED: '||refresh_end_date||' : ERROR: '||active_table||' -- '|| my_mes,1,2000), 1);
            -- for debugging:
            -- dbms_output.put_line(upper (the_db_name)||': STARTED: '||refresh_start_date||' COMPLETED: '||refresh_end_date||' : ERROR -- '|| my_mes);
            COMMIT;
      END;
   END refresh_HDB_snap;
   /
   show errors 
/