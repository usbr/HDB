  CREATE OR REPLACE TRIGGER HDB_RIVER_PK_TRIG
  BEFORE INSERT OR UPDATE ON HDB_RIVER
  REFERENCING FOR EACH ROW
  BEGIN IF inserting THEN IF populate_pk.pkval_pre_populated = FALSE THEN :new.RIVER_ID := populate_pk.get_pk_val( 'HDB_RIVER', FALSE );  END IF; ELSIF updating THEN :new.RIVER_ID := :old.RIVER_ID; END IF; END;
/

show errors trigger HDB_RIVER_PK_TRIG;