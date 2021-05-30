
CREATE OR REPLACE TRIGGER HDB_SITE_PK_TRIG 
BEFORE INSERT OR UPDATE ON HDB_SITE FOR EACH ROW 
/*  this trigger was created to replace the normally installed trigger that defines the site_id
    primary key via a call to the stored procedure.  This trigger was replaced with this code 
    because of the effort to integrate DECODES into the maintream HDB environment.  THere was little chance
    to get decodes to modify the primary key generator it used which was a sequence.  So to keep the sequence
    correct regardless of the method used to put data into hdb_site.  A sequence was necessary.

    this trigger written by M. Bogner  May 2005   */
BEGIN 
  /*  if the site_id is null comming in here then call the sequence to get the next available key
      otherwise the assume the key was generated outside via the sequence or an other method
      so leave it alone and continue processing  */
  IF inserting AND :new.SITE_ID is null THEN 
      select hdb_site_sequence.nextval into :new.SITE_ID from dual; 
  ELSIF updating THEN 
    /*  leave the site_id the same if updating  */
    :new.SITE_ID := :old.SITE_ID; 
  END IF; 
END;
.
/

CREATE OR REPLACE TRIGGER HDB_SITE_EXTENSION_TRIG 
AFTER INSERT ON HDB_SITE FOR EACH ROW 
/*  this trigger was created to insure that no matter how a record was placed into HDB that an 
    corresponding record in the decodes_site_ext table was also inserted.   This makes sure there 
    row consistency between these two tables.
    this trigger written by M. Bogner  May 2005   
    modified by M Bogner 7/31/08 to do a merge instead of an insert to fix a 
    bug created during a refresh on a slave database
    */
BEGIN 
/* nothing great we have to do here but to insert a record into the decodessite_ext  table  
   only if it doesn't already exist  */
   
    merge into decodes_site_ext dse using (select :new.site_id new_site_id from dual) dv
    on (dse.site_id = dv.new_site_id)
    when matched then update set region=dse.region
    when not matched then insert (site_id) values (dv.new_site_id);
    
    -- insert doesn't cut it on snapshot refreshes since the refresh triggers inserts for
    -- records already in the extension table
    -- insert into DECODES_Site_ext (site_id) values (:new.site_id);
END;
.
/
