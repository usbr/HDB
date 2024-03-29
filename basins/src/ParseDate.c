/*****************************************************************************
* DESCRIPTION
* This function takes the date string produced by SNOTEL log files, parses it,
* and sets the string passed in to a valid Oracle date.
*
* ASSUMPTIONS 
*
* INPUT
* char *      - date string
* char *      - ingres date
*
* OUTPUT
* warnings and error messages
*
* RETURN
* OK
*
*
* COMMENTS
*
* AUTHOR - EDITORS  
* Carol Marra
*****************************************************************************/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "basins.h"

#define FUNC_NAME "parseDate"
#define NUM_COLUMNS 2

int parseDate (char *dateString, char *oracleDate)

{
  char *tempDate,
       tempDate1[20],
       tempDate2[20],
       day[11],
       month[25],
       year[8];
  short i;


  /* Get the month */
  tempDate = strstr(dateString, ":");
  strcpy (tempDate2, &(tempDate[2]));
  strcpy (month, tempDate2);

  i = 0;
  while (month[i] != ' ')
    i++;
  month[i] = '\0';
  strcpy (tempDate1, &(tempDate2[i + 1])); 


  /* Get the day */
  strcpy (day, tempDate1);

  i = 0;
  while (day[i] != ' ')
    i++;
  day[i] = '\0';
  strcpy (tempDate2, &(tempDate1[i + 3])); 


  /* Get the year */
  strcpy (year, tempDate2);

  i = 0;
  while (year[i] != '\n' && year[i] != ' ')
    i++;
  year[i] = '\0';

  /* construct the Oracle date */
  sprintf (oracleDate, "%s-%s-%s", day, month, year);

  return (OK);
}



