  CREATE OR REPLACE TRIGGER HDB_USBR_OFF_PK_TRIG
  BEFORE INSERT OR UPDATE ON HDB_USBR_OFF
  REFERENCING FOR EACH ROW
  BEGIN IF inserting THEN IF populate_pk.pkval_pre_populated = FALSE THEN :new.OFF_ID := populate_pk.get_pk_val( 'HDB_USBR_OFF', FALSE );  END IF; ELSIF updating THEN :new.OFF_ID := :old.OFF_ID; END IF; END;
/

show errors trigger HDB_USBR_OFF_PK_TRIG;