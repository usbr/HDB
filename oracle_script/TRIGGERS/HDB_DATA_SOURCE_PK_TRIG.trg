  CREATE OR REPLACE TRIGGER HDB_DATA_SOURCE_PK_TRIG
  BEFORE INSERT OR UPDATE ON HDB_DATA_SOURCE
  REFERENCING FOR EACH ROW
  BEGIN IF inserting THEN IF populate_pk.pkval_pre_populated = FALSE THEN :new.SOURCE_ID := populate_pk.get_pk_val( 'HDB_DATA_SOURCE', FALSE );  END IF; ELSIF updating THEN :new.SOURCE_ID := :old.SOURCE_ID; END IF; END;
/
show errors trigger HDB_DATA_SOURCE_PK_TRIG;