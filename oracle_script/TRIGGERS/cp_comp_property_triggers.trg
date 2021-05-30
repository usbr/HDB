
create or replace trigger cp_comp_property_update                                                                    
after insert or update on cp_comp_property 
for each row 
DECLARE 
temp_computation_id cp_computation.computation_id%TYPE;

begin 
/*  This trigger created by M.  Bogner  04/05/2006
    This trigger archives any updates to the table
    cp_comp_property.
*/

temp_computation_id := :new.computation_id;

IF (UPDATING) THEN
 temp_computation_id := :old.computation_id;
 insert into cp_comp_property_archive (                     
   COMPUTATION_ID,
   PROP_NAME,
   PROP_VALUE,
   ARCHIVE_REASON,
   DATE_TIME_ARCHIVED,
   ARCHIVE_CMMNT
) 
values (                                           
   :old.COMPUTATION_ID,
   :old.PROP_NAME,
   :old.PROP_VALUE,
   'UPDATE', 
   sysdate, 
   NULL); 
END IF;

/* now update parent table's date_time_loaded for sql statements issued on this table */ 
hdb_utilities.touch_cp_computation(temp_computation_id);

end;                                                                    
/                                                                                                                       
show errors trigger cp_comp_property_update;                                                                         

                                                                                                                        
create or replace trigger cp_comp_property_delete                                                                    
after delete on cp_comp_property 
for each row 
begin 
/*  This trigger created by M.  Bogner  04/05/2006
    This trigger archives any deletes to the table
    cp_comp_property.
*/
insert into cp_comp_property_archive (                     
   COMPUTATION_ID,
   PROP_NAME,
   PROP_VALUE,
   ARCHIVE_REASON,
   DATE_TIME_ARCHIVED,
   ARCHIVE_CMMNT
) 
values (                                           
   :old.COMPUTATION_ID,
   :old.PROP_NAME,
   :old.PROP_VALUE,
   'DELETE', 
   sysdate, 
   NULL); 

/* now update parent table's date_time_loaded for sql statements issued on this table */ 
hdb_utilities.touch_cp_computation(:old.computation_id);

end;                                                                    
/                                                                                                                       
show errors trigger cp_comp_property_delete;                                                                         

