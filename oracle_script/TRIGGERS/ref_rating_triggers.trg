create or replace trigger ref_rating_insert_update
before insert or update on ref_rating
for each row
begin
:new.date_time_loaded := sysdate; 
end;

/
show errors trigger ref_rating_insert_update;


create or replace trigger ref_rating_arch_upd
after update on ref_rating for each row 
begin 
insert into ref_rating_archive (
RATING_ID,
INDEPENDENT_VALUE,
DEPENDENT_VALUE,
DATE_TIME_LOADED, ARCHIVE_REASON, DATE_TIME_ARCHIVED, ARCHIVE_CMMNT) values (
:old.RATING_ID,
:old.INDEPENDENT_VALUE,
:old.DEPENDENT_VALUE,
:old.date_time_loaded,'UPDATE', sysdate, NULL); 
end;
/

show errors trigger ref_rating_arch_upd;


create or replace trigger ref_rating_arch_del
after delete on ref_rating for each row 
begin 
insert into ref_rating_archive (
RATING_ID,
INDEPENDENT_VALUE,
DEPENDENT_VALUE,
DATE_TIME_LOADED, ARCHIVE_REASON, DATE_TIME_ARCHIVED, ARCHIVE_CMMNT) values (
:old.RATING_ID,
:old.INDEPENDENT_VALUE,
:old.DEPENDENT_VALUE,
:old.date_time_loaded,'DELETE', sysdate, NULL); 
end;
/
show errors trigger ref_rating_arch_del;

