create or replace procedure check_valid_attr_value (cur_attr_id number, cur_value float, cur_string_value varchar2, cur_date_value date)
IS
    cur_attr_value_type varchar2(10);
BEGIN
    SELECT attr_value_type 
	INTO cur_attr_value_type
	FROM hdb_attr
	WHERE attr_id = cur_attr_id;

    if cur_attr_value_type = 'number' then
	if (cur_value is null OR cur_string_value is not null OR cur_date_value is not null) then
	   raise_application_error (-20001,'Attr_value_type is ' || cur_attr_value_type || '. Value must be NOT NULL; string_value and date_value must be NULL.');
        end if;
    elsif cur_attr_value_type = 'string' then
	if (cur_string_value is null OR cur_value is not null OR cur_date_value is not null) then
	   raise_application_error (-20002,'Attr_value_type is ' || cur_attr_value_type || '. String_value must be NOT NULL; value and date_value must be NULL.');
        end if;
    else
	if (cur_date_value is null OR cur_value is not null OR cur_string_value is not null) then
	   raise_application_error (-20003,'Attr_value_type is ' || cur_attr_value_type || '. Date_value must be NOT NULL; value and string_value must be NULL.');
        end if;
    end if;
END;
/
show errors;
grant execute on check_valid_attr_value to public;
create public synonym check_valid_attr_value for check_valid_attr_value;
