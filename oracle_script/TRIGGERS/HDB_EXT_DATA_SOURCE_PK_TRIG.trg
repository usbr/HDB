  CREATE OR REPLACE TRIGGER HDB_EXT_DATA_SOURCE_PK_TRIG
  BEFORE INSERT OR UPDATE ON HDB_EXT_DATA_SOURCE
  REFERENCING FOR EACH ROW
  BEGIN IF inserting THEN IF populate_pk.pkval_pre_populated = FALSE THEN :new.EXT_DATA_SOURCE_ID := populate_pk.get_pk_val( 'HDB_EXT_DATA_SOURCE', FALSE );  END IF; ELSIF updating THEN :new.EXT_DATA_SOURCE_ID := :old.EXT_DATA_SOURCE_ID; END IF; END;
/
show errors trigger HDB_EXT_DATA_SOURCE_PK_TRIG;