CREATE OR REPLACE TRIGGER REF_SITE_RATING_PK_TRIG
before INSERT OR UPDATE
ON "REF_SITE_RATING"
FOR EACH ROW
BEGIN

  IF inserting THEN
    SELECT ref_site_rating_seq.nextval
    INTO :NEW.rating_id
    FROM dual;
  ELSIF updating THEN
      :NEW.rating_id := :OLD.rating_id;
  END IF;

  :NEW.date_time_loaded := sysdate;
END;

/
show errors trigger REF_SITE_RATING_PK_TRIG;


create or replace trigger ref_site_rating_arch_upd
after update on ref_site_rating for each row 
begin 
insert into ref_site_rating_archive (
RATING_ID,
INDEP_SITE_DATATYPE_ID,
RATING_TYPE_COMMON_NAME,
EFFECTIVE_START_DATE_TIME,
EFFECTIVE_END_DATE_TIME,
DATE_TIME_LOADED,
AGEN_ID,
DESCRIPTION,
ARCHIVE_REASON, DATE_TIME_ARCHIVED, ARCHIVE_CMMNT) values (
:old.RATING_ID,
:old.INDEP_SITE_DATATYPE_ID,
:old.RATING_TYPE_COMMON_NAME,
:old.EFFECTIVE_START_DATE_TIME,
:old.EFFECTIVE_END_DATE_TIME,
:old.DATE_TIME_LOADED,
:old.AGEN_ID,
:old.DESCRIPTION,
'UPDATE', sysdate, NULL);
 end;
/
show errors trigger ref_site_rating_arch_upd;



create or replace trigger ref_site_rating_arch_del
after delete on ref_site_rating for each row 
begin 
insert into ref_site_rating_archive (
RATING_ID,
INDEP_SITE_DATATYPE_ID,
RATING_TYPE_COMMON_NAME,
EFFECTIVE_START_DATE_TIME,
EFFECTIVE_END_DATE_TIME,
DATE_TIME_LOADED,
AGEN_ID,
DESCRIPTION,
ARCHIVE_REASON, DATE_TIME_ARCHIVED, ARCHIVE_CMMNT) values (
:old.RATING_ID,
:old.INDEP_SITE_DATATYPE_ID,
:old.RATING_TYPE_COMMON_NAME,
:old.EFFECTIVE_START_DATE_TIME,
:old.EFFECTIVE_END_DATE_TIME,
:old.DATE_TIME_LOADED,
:old.AGEN_ID,
:old.DESCRIPTION,
'DELETE', sysdate, NULL); 
end;
/
show errors trigger ref_site_rating_arch_del;


