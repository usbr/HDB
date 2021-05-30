CREATE OR REPLACE PACKAGE DATATYPE_PKG as
   type      rowid_tab_type is table of rowid index by binary_integer;
   type      dt_id_tab_type is table of number(11) index by binary_integer;
   type      dt_type_tab_type is table of varchar2(32) index by binary_integer;

   rowid_tab    rowid_tab_type;
   dt_id_tab    dt_id_tab_type;
   dt_type_tab  dt_type_tab_type;
   datatype_index binary_integer;
end datatype_pkg;
/

create or replace public synonym DATATYPE_PKG for DATATYPE_PKG;
grant execute on DATATYPE_PKG to app_role;
grant execute on DATATYPE_PKG to savoir_faire;
