CREATE OR REPLACE TRIGGER HDB_ATTR_PK_TRIG
  BEFORE INSERT OR UPDATE ON HDB_ATTR
  REFERENCING FOR EACH ROW
  BEGIN IF inserting THEN IF populate_pk.pkval_pre_populated = FALSE THEN :new.ATTR_ID := populate_pk.get_pk_val( 'HDB_ATTR', FALSE );  END IF; ELSIF updating THEN :new.ATTR_ID := :old.ATTR_ID; END IF; END;
/
show errors trigger HDB_ATTR_PK_TRIG;