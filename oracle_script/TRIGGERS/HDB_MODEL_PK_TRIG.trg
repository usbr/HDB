  CREATE OR REPLACE TRIGGER HDB_MODEL_PK_TRIG
  BEFORE INSERT OR UPDATE ON HDB_MODEL
  REFERENCING FOR EACH ROW
  BEGIN
IF inserting THEN
  IF populate_pk.pkval_pre_populated = FALSE THEN
    :new.MODEL_ID := populate_pk.get_pk_val( 'HDB_MODEL', FALSE );
  END IF;
ELSIF updating THEN
  :new.MODEL_ID := :old.MODEL_ID;
END IF;
END;
/

show errors trigger HDB_MODEL_PK_TRIG;