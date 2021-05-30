create or replace trigger decodes_site_update
instead of update on site_to_decodes_site_view 
for each row
declare
 TEMP_SCS_ID number;
 TEMP_INT number;
 TEMP_INT1 number;
 TEMP_INT2 number;
 TEMP_SITE_NAME HDB_SITE.SITE_NAME%TYPE;
 TEMP_DESCRIPTION HDB_SITE.DESCRIPTION%TYPE;
begin

/*  this trigger is designed to update appropriate records in the site_to_decodes_site_view
    whenever an update to the view is detected
    written by M. Bogner  May 2005
    modified by M. Bogner May 2006 because of testing incompatibilities
    modified by M. Bogner April 2011 to make a merge statement on decodes extension table
    and new architectural decisions
*/


  temp_int := instr(:new.description,chr(10));
  temp_int1 := temp_int - 1;
  temp_int2 := temp_int + 1;

  /*  if there's no line feed then there is a data entry error or just the site name has been sent */
  if (temp_int = 0) then  
      temp_int1 := 240;
      temp_int2 := 241;
--    raise_application_error(-20000,'Description Must have a <RETURN> within it to determine system name!!!');
  end if;

  /*  if the carriage return is a  place beyond 240 then the site name is too long  */
  if (temp_int > 240) then  
      temp_int1 := 240;
      temp_int2 := 241;
--    raise_application_error(-20000,'The system name must not be longer than 240 characters!!!');
  end if;

  /*  now set the site_name and description  based on the location of the line feed  */
  /*  or the determination of the splitting location                                 */
  temp_site_name := substr(:new.description,1,temp_int1);
  temp_description:= substr(:new.description,temp_int2);

/*  update the hdb_site table for the appropriate columns in this view  */

update hdb_site set
site_name = temp_site_name,
description =  temp_description,
lat = :new.latitude,
longi = :new.longitude,
elevation = :new.elevation
where site_id = :new.id;

/*  update the decodes_site_ext table for the appropriate columns in this view  */
/*  commented out to be replaced with merge statement  */
/*
update decodes_site_ext set 
nearestcity = :new.nearestcity,
state = :new.state,
region = :new.region,
timezone = :new.timezone,
country = :new.country,
elevunitabbr = :new.elevunitabbr
where site_id = :new.id;
*/

/* now here is the new merge statement to replace the update of decodes_site_ext  */

merge into decodes_site_ext DSE
using (
  select :new.nearestcity "NEARESTCITY",:new.state "STATE",:new.region "REGION",
  :new.timezone "TIMEZONE",:new.country "COUNTRY",:new.elevunitabbr "ELEVUNITABBR",
  :new.id "SITE_ID" from dual 
  ) DV  
on (DSE.SITE_ID = DV.SITE_ID)
WHEN MATCHED THEN UPDATE SET 
  nearestcity = DV.NEARESTCITY, state = DV.STATE, region = DV.REGION,
  timezone = DV.TIMEZONE, country = DV.COUNTRY, elevunitabbr = DV.ELEVUNITABBR
  WHEN NOT MATCHED THEN INSERT (DSE.SITE_ID,DSE.NEARESTCITY,DSE.STATE,DSE.REGION,DSE.TIMEZONE,
  DSE.COUNTRY,DSE.ELEVUNITABBR)
     VALUES (DV.SITE_ID,DV.NEARESTCITY,DV.STATE,DV.REGION,DV.TIMEZONE,
             DV.COUNTRY,DV.ELEVUNITABBR);

END;
.
/


create or replace trigger decodes_site_delete
instead of delete on site_to_decodes_site_view 
for each row
declare
 TEMP_SCS_ID number;
 TEMP_INT number;
begin

/*  this trigger is designed to delete appropriate records in the site_to_decodes_site_view
    whenever an delete to the view is detected
    written by M. Bogner  May 2005
*/

--delete from hdb_ext_site_code where hdb_site_id = :old.id;
delete from hdb_site where site_id = :old.id;


END;
.
/

create or replace trigger decodes_site_insert
instead of insert on site_to_decodes_site_view 
for each row
declare
 TEMP_INT number;
 TEMP_INT1 number;
 TEMP_INT2 number;
 TEMP_DBS_CODE REF_DB_LIST.DB_SITE_CODE%TYPE;
 TEMP_SITE_NAME HDB_SITE.SITE_NAME%TYPE;
 TEMP_DESCRIPTION HDB_SITE.DESCRIPTION%TYPE;

begin

/*  this trigger is designed to insert appropriate records in the site_to_decodes_site_view
    whenever an insert to the site_to_decodes_site_view view is detected
    written by M. Bogner  May 2005
    modified by M. Bogner May 2006 because of testing incompatibilities
    modified by M. Bogner April 2011 to make a merge statement on decodes extension table
    and new architectural decisions
*/


  /*  for inserts into hdb_site go get the db_site code from the ref_db_list table */
  select db_site_code into temp_dbs_code from ref_db_list where session_no = 1;

  /* the description is suppose to be the system name along with the description */

  temp_int := instr(:new.description,chr(10));
  temp_int1 := temp_int - 1;
  temp_int2 := temp_int + 1;

  /*  if there's no line feed then there is a data entry error or just the site name has been sent */
  if (temp_int = 0) then  
      temp_int1 := 240;
      temp_int2 := 241;
--    raise_application_error(-20000,'Description Must have a <RETURN> within it to determine system name!!!');
  end if;

  /*  if the carriage return is a  place beyond 240 then the site name is too long  */
  if (temp_int > 240) then  
      temp_int1 := 240;
      temp_int2 := 241;
--    raise_application_error(-20000,'The system name must not be longer than 240 characters!!!');
  end if;

  /*  now set the site_name and description  based on the location of the line feed  */
  /*  or the determination of the splitting location                                 */
  temp_site_name := substr(:new.description,1,temp_int1);
  temp_description:= substr(:new.description,temp_int2);

  /*  insert the record into the hdb_site table  */
  populate_pk.SET_PRE_POPULATED (0);
  insert into hdb_site
  (SITE_ID,SITE_NAME,SITE_COMMON_NAME,OBJECTTYPE_ID,DB_SITE_CODE,DESCRIPTION,LAT,LONGI,ELEVATION)
  values (:new.id,temp_site_name,temp_site_name,9,temp_dbs_code,
      temp_description,:new.latitude,:new.longitude,:new.elevation);
  /* above modified 05.04.2006 by M Bogner to insert values that where missing from the insert statement  */
  /* above modified 05.15.2006 by M Bogner to insert values for a new procedure to determine site and description*/
  populate_pk.SET_PRE_POPULATED (1);

  /* now insert the other data into the site extension table  */
  /* the insert should have already been done so we are going to do an update instead but I will leave this code here 
     but commented out just in case we may need it later...
  insert into DECODES_SITE_EXT 
  (SITE_ID,NEARESTCITY,STATE,REGION,TIMEZONE,COUNTRY,ELEVUNITABBR)
  values (NEW.ID,:NEW.NEARESTCITY,:NEW.STATE,:NEW.REGION,:NEW.TIMEZONE,:NEW.COUNTRY,:NEW.ELEVUNITABBR);
  
  end of the commented out block  */


  /*  update the decodes_site_ext table for the appropriate columns in this view  */
  /*  commented out to be replaced with merge statement  */
/*
  update decodes_site_ext set 
  nearestcity = :new.nearestcity,
  state = :new.state,
  region = :new.region,
  timezone = :new.timezone,
  country = :new.country,
  elevunitabbr = :new.elevunitabbr
  where site_id = :new.id;
*/

/* now here is the new merge statement to replace the update of decodes_site_ext  */

merge into decodes_site_ext DSE
using (
  select :new.nearestcity "NEARESTCITY",:new.state "STATE",:new.region "REGION",
  :new.timezone "TIMEZONE",:new.country "COUNTRY",:new.elevunitabbr "ELEVUNITABBR",
  :new.id "SITE_ID" from dual 
  ) DV  
on (DSE.SITE_ID = DV.SITE_ID)
WHEN MATCHED THEN UPDATE SET 
  nearestcity = DV.NEARESTCITY, state = DV.STATE, region = DV.REGION,
  timezone = DV.TIMEZONE, country = DV.COUNTRY, elevunitabbr = DV.ELEVUNITABBR
  WHEN NOT MATCHED THEN INSERT (DSE.SITE_ID,DSE.NEARESTCITY,DSE.STATE,DSE.REGION,DSE.TIMEZONE,
  DSE.COUNTRY,DSE.ELEVUNITABBR)
     VALUES (DV.SITE_ID,DV.NEARESTCITY,DV.STATE,DV.REGION,DV.TIMEZONE,
             DV.COUNTRY,DV.ELEVUNITABBR);

END;
.
/
