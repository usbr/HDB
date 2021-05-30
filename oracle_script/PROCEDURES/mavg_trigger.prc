CREATE OR REPLACE PROCEDURE MAVG_TRIGGER ( P_IN_SDI NUMBER, P_DATE_TIME DATE, 
    P_INTERVAL_WINDOW NUMBER, P_MIN_VALUES_REQUIRED NUMBER, P_OUT_SDI NUMBER,
	P_COMPUTATION_ID NUMBER DEFAULT 2, P_LOADING_ID NUMBER DEFAULT 45) 
	IS
	
	PRAGMA AUTONOMOUS_TRANSACTION; -- Needed to be called from SQL, not necessary from a stored procedure

	return_value FLOAT;  /* keep in case we need to revert back to function  */

    /* special windowing query used for this procedure(function) that will do moving averages	                  */  
    /* This cursor uses the dates_between function to get enough dates around the requested interval  */
    CURSOR get_moving_avg (c_sdi NUMBER, c_intervals NUMBER , c_sdt DATE) IS  
	select HRS2.HOURS,HRS2.RECS,HRS2.MAVG from
	 (select hrs.hours, 
	  sum(decode(rh.site_datatype_id,NULL,0,1)) Over (order by hrs.hours rows between c_intervals-1 preceding and current row) "RECS",
      avg(rh.value) Over (order by hrs.hours rows between c_intervals-1 preceding and current row) "MAVG"
	  from r_hour rh, 
      (select c_sdi "SDI", date_time "HOURS" from table(dates_between(c_sdt-(c_intervals*2)/24,c_sdt+(c_intervals*2)/24,'hour'))) HRS
		where  HRS.hours = rh.start_date_time (+)
		and    HRS.sdi = rh.site_datatype_id (+)) HRS2
	where 
	       hrs2.hours >= c_sdt
       and hrs2.hours <  c_sdt + c_intervals/24  
	order by 1;  

    /* now the local variables needed  */

    l_count NUMBER;
	l_intervals NUMBER;
	l_mvavg_value FLOAT;	

	BEGIN 
	/* this function calculates the moving hourly average of values
	   the interval (number of hours is based on input parameter P_INTERVAL_WINDOW
	   The P_MIN_VALUES_REQUIRED determines if enough records exist to return
	   a value other than null
	*/

	/*  this procedure written by M. Bogner for Eastern Colorado 011/07/2011  
      Mod  by M Bogner 1/27/2015 to add loading_app and computation id as params, not as defaults 
      Validation in Write_to_hdb call changed by IsmailO 10/04/2018 from empty string('') to null due to its type CHAR . 
    */

		return_value := 0;

        /* Loop in cursor records for the interval and perform DML accordingly  */
		FOR p1 IN get_moving_avg(P_IN_SDI,P_INTERVAL_WINDOW,P_DATE_TIME) LOOP

		  /* see if there were enough values to produce the calculation.  If not, delete output */
		  IF p1.recs < P_MIN_VALUES_REQUIRED  THEN
		    DELETE_FROM_HDB (P_OUT_SDI,p1.hours,NULL,'hour',P_LOADING_ID,P_COMPUTATION_ID,0);
		  ELSE 
		    /* this was a good moving average computation so write it to the DB  */
		    /* use the default value 45 to indicate the CP Process was responsible for this data  */
		    return_value := return_value + 1;
		    WRITE_TO_HDB (P_OUT_SDI,p1.hours,round(p1.mavg,5),'hour',P_LOADING_ID,P_COMPUTATION_ID,0,null,null);
		  END IF;

		END LOOP;

	   /* now commit this stuff since it is an autonomous transaction  */
	   commit;

	   /* all processing is done so return the return value  */
       /* Not necessary if used as a procedure               */
--	   --return (return_value);
	END;
/


show errors;

create or replace public synonym MAVG_TRIGGER for MAVG_TRIGGER;
grant execute on MAVG_TRIGGER to app_role;
grant execute on MAVG_TRIGGER to savoir_faire;
