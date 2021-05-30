  CREATE OR REPLACE TRIGGER HDB_AGEN_PK_TRIG
  BEFORE INSERT OR UPDATE ON HDB_AGEN
  REFERENCING FOR EACH ROW
  BEGIN IF inserting THEN IF populate_pk.pkval_pre_populated = FALSE THEN :new.AGEN_ID := populate_pk.get_pk_val( 'HDB_AGEN', FALSE );  END IF; ELSIF updating THEN :new.AGEN_ID := :old.AGEN_ID; END IF; END;
/
show errors trigger HDB_AGEN_PK_TRIG;