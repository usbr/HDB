  CREATE OR REPLACE TRIGGER HDB_STATE_PK_TRIG
  BEFORE INSERT OR UPDATE ON HDB_STATE
  REFERENCING FOR EACH ROW
  BEGIN IF inserting THEN IF populate_pk.pkval_pre_populated = FALSE THEN :new.STATE_ID := populate_pk.get_pk_val( 'HDB_STATE', FALSE );  END IF; ELSIF updating THEN :new.STATE_ID := :old.STATE_ID; END IF; END;
/

show errors trigger HDB_STATE_PK_TRIG;