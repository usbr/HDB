
create or replace trigger ref_interval_cp_lim_b4_ins_up
before             insert OR update 
on                ref_interval_copy_limits
for   each row
begin
    
    /* created by M.  Bogner 01/07/11  */
    /*
    the purpose of this trigger is to make sure the date_time_loaded is modified
    to sysdate
    */
    
      :new.date_time_loaded := sysdate;

end;
/

create or replace trigger ref_interval_cp_limits_update                                                                    
after update on  ref_interval_copy_limits 
for each row 
begin 
/*  This trigger created by M.  Bogner  11/19/2007
    This trigger archives any updates to the table
    ref_interval_copy_limits.
    
    modified by M. Bogner 27 Oct 2008 to account for
    new preprocessor columns
*/
insert into  ref_inter_copy_limits_archive (                     
SITE_DATATYPE_ID,
INTERVAL,
MIN_VALUE_EXPECTED,
MIN_VALUE_CUTOFF,
MAX_VALUE_EXPECTED,
MAX_VALUE_CUTOFF,
TIME_OFFSET_MINUTES,
DATE_TIME_LOADED,
ARCHIVE_REASON,
DATE_TIME_ARCHIVED,
ARCHIVE_CMMNT,
EFFECTIVE_START_DATE_TIME,
EFFECTIVE_END_DATE_TIME,
PREPROCESSOR_EQUATION
) 
VALUES (
:old.SITE_DATATYPE_ID,
:old.INTERVAL,
:old.MIN_VALUE_EXPECTED,
:old.MIN_VALUE_CUTOFF,
:old.MAX_VALUE_EXPECTED,
:old.MAX_VALUE_CUTOFF,
:old.TIME_OFFSET_MINUTES,
:old.DATE_TIME_LOADED,
'UPDATE',
sysdate,
NULL,
:old.EFFECTIVE_START_DATE_TIME,
:old.EFFECTIVE_END_DATE_TIME,
:old.PREPROCESSOR_EQUATION
);
end;                                                                    

/                                                                                                                       
show errors trigger ref_interval_cp_limits_update;                                                                         

                                                                                                                        
create or replace trigger ref_interval_cp_limits_delete                                                            
after delete on ref_interval_copy_limits 
for each row 
begin 
/*  This trigger created by M.  Bogner  11/19/2007
    This trigger archives any updates to the table
    ref_interval_copy_limits.
    
    modified by M. Bogner 27 Oct 2008 to account for
    new preprocessor columns
*/
insert into  ref_inter_copy_limits_archive (                     
SITE_DATATYPE_ID,
INTERVAL,
MIN_VALUE_EXPECTED,
MIN_VALUE_CUTOFF,
MAX_VALUE_EXPECTED,
MAX_VALUE_CUTOFF,
TIME_OFFSET_MINUTES,
DATE_TIME_LOADED,
ARCHIVE_REASON,
DATE_TIME_ARCHIVED,
ARCHIVE_CMMNT,
EFFECTIVE_START_DATE_TIME,
EFFECTIVE_END_DATE_TIME,
PREPROCESSOR_EQUATION
) 
VALUES (
:old.SITE_DATATYPE_ID,
:old.INTERVAL,
:old.MIN_VALUE_EXPECTED,
:old.MIN_VALUE_CUTOFF,
:old.MAX_VALUE_EXPECTED,
:old.MAX_VALUE_CUTOFF,
:old.TIME_OFFSET_MINUTES,
:old.DATE_TIME_LOADED,
'DELETE',
sysdate,
NULL,
:old.EFFECTIVE_START_DATE_TIME,
:old.EFFECTIVE_END_DATE_TIME,
:old.PREPROCESSOR_EQUATION
);
end;                                                                    
/                                                                                                                       
show errors trigger ref_interval_cp_limits_delete;                                                                         

