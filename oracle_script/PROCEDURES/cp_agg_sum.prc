create or replace PROCEDURE CP_AGG_SUM( P_IN_SDI NUMBER, P_DATE_TIME DATE,
     P_OUT_SDI NUMBER, P_MMDD VARCHAR2)
	IS

	PRAGMA AUTONOMOUS_TRANSACTION; -- Needed to be called from SQL, not necessary from a stored procedure

    /* This cursor uses the dates_between function to get enough dates around the requested dates  */
    CURSOR get_agg_sum (c_sdi NUMBER, c_sdt DATE, c_edt DATE) IS
	select DAYS2.DAYS,DAYS2.RSUM from
	 (select DAYS.days,
      sum(rd.value) Over (order by days.days) "RSUM"
	  from r_day rd,
      (select c_sdi "SDI", date_time "DAYS" from table(dates_between(c_sdt,c_edt+1,'day'))) DAYS
		where  DAYS.days = rd.start_date_time (+)
		and    DAYS.sdi = rd.site_datatype_id (+)
		and    DAYS.days <= sysdate ) DAYS2
	where
	       days2.days >= c_sdt
       and days2.days <= c_edt
       and days2.rsum is not null
	order by 1;

    /* now the local variables needed  */

    l_count NUMBER;
	l_agg_value FLOAT;
    l_SDT  date;
    l_EDT  date;
	l_year number;

	BEGIN
	/* this function calculates the rolling sum of daily values for a
	   user specified start date (P_MMDD) for the whole year period
	*/

	/*  this procedure written by M. Bogner for Eastern Colorado 12/18/2012  
        Validation in Write_to_hdb call changed by IsmailO 10/04/2018 from empty string('') to null due to its type CHAR . 
    */

    /* get the year of the triggering record's date */
    l_year := to_number(to_char(P_DATE_TIME,'yyyy'));

    /*  Compute the begin and end dates for the query based on the P_MMDD parameter  */
    IF to_number(to_char(P_DATE_TIME,'mmdd')) < to_number(P_MMDD) THEN
       /* the triggering value is before the cutoff date  */
       l_SDT := to_date (P_MMDD ||to_char(l_year -1),'mmddyyyy');
       l_EDT := to_date (P_MMDD ||to_char(l_year),'mmddyyyy') - 1;
    ELSE
       /* the triggering value is after the cutoff date  */
       l_SDT := to_date (P_MMDD ||to_char(l_year),'mmddyyyy');
       l_EDT := to_date (P_MMDD ||to_char(l_year +1),'mmddyyyy')- 1;
    END IF;

        /* Loop in cursor records for the interval and perform DML accordingly  */
		FOR p1 IN get_agg_sum(P_IN_SDI,l_SDT,l_EDT) LOOP

		    /* this summing computation works so write it to the DB  */
		    /* use the default value 45 to indicate the CP Process was responsible for this data  */
		    --deny_action (to_char(P_OUT_SDI)||p1.days||round(p1.rsum,5)||'day');

            WRITE_TO_HDB (P_OUT_SDI,p1.days,round(p1.rsum,5),'day',45,2,0,null,null);

		END LOOP;

	   /* now commit this stuff since it is an autonomous transaction  */
	   commit;


	END;
/


show errors;

create or replace public synonym CP_AGG_SUM for CP_AGG_SUM;
grant execute on CP_AGG_SUM to app_role;
grant execute on CP_AGG_SUM to savoir_faire;
