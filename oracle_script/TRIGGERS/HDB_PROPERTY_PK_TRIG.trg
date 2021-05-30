  CREATE OR REPLACE TRIGGER HDB_PROPERTY_PK_TRIG
  BEFORE INSERT OR UPDATE ON HDB_PROPERTY
  REFERENCING FOR EACH ROW
  begin
IF inserting THEN
  IF populate_pk.pkval_pre_populated = FALSE THEN
     :new.PROPERTY_ID := populate_pk.get_pk_val( 'HDB_PROPERTY', FALSE );
  END IF;
ELSIF updating THEN
  :new.PROPERTY_ID := :old.PROPERTY_ID;
END IF;
end;
/

show errors trigger HDB_PROPERTY_PK_TRIG;