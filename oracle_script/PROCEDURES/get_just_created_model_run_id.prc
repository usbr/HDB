/* Determine new model_run_id by selecting largest MRI
   with most recent date_time_loaded where parameters are 
   equal to those passed in. Intended to be called
   only from create_model_run_id procedure, and the Meta Data
   application. */

create or replace PROCEDURE get_just_created_model_run_id ( 
   model_run_id_out             OUT number,
   model_run_name_in            IN varchar2,
   model_id_in                  IN number,
   run_date_in                  IN date,
   num_extra_keys               IN number,
   start_date_in                IN date,
   end_date_in                  IN date,
   hydrologic_indicator_in      IN varchar2,
   modeltype_in                 IN varchar2,
   time_step_descriptor_in      IN varchar2,
   cmmnt_in                     IN varchar2)
IS
  num_ext  varchar2(100);
  st_dt    varchar2(100);
  end_dt   varchar2(100);
  hyd_ind  varchar2(100);
  modtype  varchar2(100);
  tmstp    varchar2(200);
  cmt      varchar2(2000);
  prim_sel_stmt varchar2(1000);
  sec_sel_stmt  varchar2(1000);
  ter_sel_stmt  varchar2(1000);
  where_stmt    varchar2(2000);
  sel_stmt varchar2(2000);
  text varchar2(1000);
BEGIN
  /* Determine new model_run_id by selecting largest MRI
     with most recent date_time_loaded 
     where parameters are equal to those passed in. */
  if (num_extra_keys = 0) then 
    num_ext := 'extra_keys_y_n = ''N''';
  else
    num_ext := 'extra_keys_y_n = ''Y''';
  end if;

  if (start_date_in is null) then 
    st_dt := 'start_date IS NULL';
  else
    st_dt := 'to_date(start_date,''dd-mon-yyyy hh24:mi:ss'') = to_date('''||start_date_in||''',''dd-mon-yyyy hh24:mi:ss'')';
  end if;

  if (end_date_in is null) then 
    end_dt := ' and end_date IS NULL';
  else
    end_dt := ' and to_date(end_date,''dd-mon-yyyy hh24:mi:ss'') = to_date('''||end_date_in||''',''dd-mon-yyyy hh24:mi:ss'')';
  end if;

  if (hydrologic_indicator_in is null) then 
    hyd_ind := ' and hydrologic_indicator IS NULL';
  else
    hyd_ind := ' and hydrologic_indicator = '''||hydrologic_indicator_in||''' ';
  end if;

  if (modeltype_in is null) then 
    modtype := ' and modeltype IS NULL';
  else
    modtype := ' and modeltype = '''||modeltype_in||''' ';
  end if;

  if (time_step_descriptor_in is null) then 
    tmstp := ' and time_step_descriptor IS NULL';
  else
    tmstp := ' and time_step_descriptor = '''||time_step_descriptor_in||''' ';
  end if;

  if (cmmnt_in is null) then 
    cmt := ' and cmmnt IS NULL';
  else
    cmt := ' and cmmnt = '''||cmmnt_in||''' ';
  end if;

  prim_sel_stmt := 'SELECT model_run_id FROM ref_model_run ';
  where_stmt := 'WHERE model_run_name=:1 and model_id=:2 and '||num_ext||' and run_date=:3 and '||st_dt||end_dt||hyd_ind||modtype||tmstp||cmt;
  sec_sel_stmt := ' and date_time_loaded = (select max(date_time_loaded) from ref_model_run ' || where_stmt ||')';
  ter_sel_stmt := ' and model_run_id = (select max(model_run_id) from ref_model_run ' || where_stmt ||')';
  sel_stmt := prim_sel_stmt || where_stmt || sec_sel_stmt || ter_sel_stmt;

  EXECUTE IMMEDIATE sel_stmt INTO model_run_id_out USING model_run_name_in,model_id_in,run_date_in,model_run_name_in,model_id_in,run_date_in,model_run_name_in,model_id_in,run_date_in;

  EXCEPTION
   WHEN OTHERS THEN 
     rollback;
     text := sqlerrm||' when trying to get just created model_run_id';
     deny_action (text);

end;
/

show errors;
/
create public synonym get_just_created_model_run_id 
  for get_just_created_model_run_id;

grant execute on get_just_created_model_run_id to model_priv_role;


