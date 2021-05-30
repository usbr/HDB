  CREATE OR REPLACE TRIGGER REF_DB_LIST_PK_TRIG
  BEFORE INSERT OR UPDATE ON REF_DB_LIST
  REFERENCING FOR EACH ROW
  BEGIN
IF inserting THEN
  IF populate_pk.pkval_pre_populated = FALSE THEN
    :new.SESSION_NO := populate_pk.get_pk_val( 'REF_DB_LIST', FALSE );
  END IF;
ELSIF updating THEN
  :new.SESSION_NO := :old.SESSION_NO;
END IF;
END;
/

show errors trigger REF_DB_LIST_PK_TRIG;
