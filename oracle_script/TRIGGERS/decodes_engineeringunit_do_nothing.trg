/* this set of triggers is now obsolete due to the czar strategy employed for the datatypes rework  project  */
/* so this set of triggers which basically do nothing but allow code to do dml against the view              */
/* should be deployed as of 09/01/2006  */

create or replace trigger decodes_unit_delete
instead of delete on unit_to_decodes_unit_view 
for each row
declare
 TEMP_COUNT number;

begin


/* right now just delete if the abbreviation is there  */
/* actually don't do any deletes cause the use of rledit would destroy the database  */
/* so effectively shut off delete capabilities */
/*  delete from hdb_unit where unit_common_name = :old.unitabbr;   */
temp_count := 0;

END;
.
/

create or replace trigger decodes_unit_update
instead of update on unit_to_decodes_unit_view 
for each row
declare
 TEMP_DIM_ID number;
begin

/* effectively don't do anything so that everything works that tries to update the database via this view */
/* but in actuallity nothing will actually be done                                                         */
TEMP_DIM_ID := 0;

END;
.
/


create or replace trigger decodes_unit_insert
instead of insert on unit_to_decodes_unit_view 
declare
 TEMP_DIM_ID number;
 TEMP_UNIT_ID number;
begin

/* effectively don't do anything so that everything works that tries to update the database via this view */
/* but in actuallity nothing will actually be done                                                         */
TEMP_DIM_ID := 0;

END;
.
/
