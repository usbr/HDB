  CREATE OR REPLACE TRIGGER HDB_FEATURE_PK_TRIG
  BEFORE INSERT OR UPDATE ON HDB_FEATURE
  REFERENCING FOR EACH ROW
  begin
IF inserting THEN
  IF populate_pk.pkval_pre_populated = FALSE THEN
     :new.FEATURE_ID := populate_pk.get_pk_val( 'HDB_FEATURE', FALSE );
  END IF;
ELSIF updating THEN
  :new.FEATURE_ID := :old.FEATURE_ID;
END IF;
end;
/

show errors trigger HDB_FEATURE_PK_TRIG;