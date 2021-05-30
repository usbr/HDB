

create or replace trigger ref_ensemble_trace_upd
after update on REF_ENSEMBLE_TRACE for each row begin 
insert into REF_ENSEMBLE_TRACE_ARCHIVE (
ENSEMBLE_ID,
TRACE_ID,
TRACE_NUMERIC,
TRACE_NAME,
MODEL_RUN_ID,
ARCHIVE_REASON, DATE_TIME_ARCHIVED, ARCHIVE_CMMNT) values (
:old.ENSEMBLE_ID,
:old.TRACE_ID,
:old.TRACE_NUMERIC,
:old.TRACE_NAME,
:old.MODEL_RUN_ID,
'UPDATE', sysdate, NULL); end;
/
show errors trigger ref_ensemble_trace_upd;

create or replace trigger ref_ensemble_trace_del
after delete on REF_ENSEMBLE_TRACE for each row begin
insert into REF_ENSEMBLE_TRACE_ARCHIVE(
ENSEMBLE_ID,
TRACE_ID,
TRACE_NUMERIC,
TRACE_NAME,
MODEL_RUN_ID,
ARCHIVE_REASON, DATE_TIME_ARCHIVED, ARCHIVE_CMMNT) values (
:old.ENSEMBLE_ID,
:old.TRACE_ID,
:old.TRACE_NUMERIC,
:old.TRACE_NAME,
:old.MODEL_RUN_ID,
'DELETE', sysdate, NULL); end;
/
show errors trigger ref_ensemble_trace_del;