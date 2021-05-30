create or replace trigger check_attr_type_and_unit 
after insert or update
on hdb_attr
for each row
begin
     if (:new.attr_value_type <> 'number' and :new.unit_id is not null) then
	  raise_application_error(-20005,'Error: Unit_id appropriate only for attributes with type: number');
     end if;

end;
/
show errors trigger check_attr_type_and_unit;


