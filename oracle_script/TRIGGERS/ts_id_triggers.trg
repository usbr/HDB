CREATE OR REPLACE TRIGGER CP_TS_ID_PK_TRIG 
BEFORE INSERT OR UPDATE 
ON CP_TS_ID 
FOR EACH ROW 
BEGIN 
	IF inserting THEN
	      SELECT CP_TS_ID_SEQUENCE.NEXTVAL INTO :NEW.TS_ID FROM DUAL;
    ELSIF updating THEN 
     /*  do nothing as of now  */
     null;
    END IF; 
END;         
                                                                                
.
/
