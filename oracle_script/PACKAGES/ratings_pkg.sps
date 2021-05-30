CREATE OR REPLACE PACKAGE ratings AS
  
/** 
 * Ratings package
 * connects to four tables: hdb_rating_algorithm, hdb_rating_type, 
 * ref_site_rating and ref_rating
 * Currently only supports 2-dimension x to y ratings
 * 3 dimension (x,y to z) ratings should
 * use two more tables, ref_site_3d_rating, and ref_3d_rating
 * also would require do_3d_rating, find_site_3d_rating, rating_3d_linear,
 * rating_3d_logarithmic algorithms and so forth.
*/


/** do_rating: actually does a rating. Must have previously looked up a rating_id
 * this procedure will use the rating algorithm defined in the hdb_rating_type
 * for the specified rating_id
 * Inputs:  rating_in - rating id from ref_site_rating
          indep_value - the independent value being rated
  Outputs: indep_base - the lower bound on indep_value found in the table
            dep_value - the y value resulting from the rating
          match_check - status of rating. Null, E for exact, A for extrapolation
          above maximum value, or B for extrapolation below min value.
*/
  
  PROCEDURE do_rating(rating_in in number,
  indep_value in number,
  indep_date in date,
  indep_base out number,
  dep_value out number,
  match_check out nocopy varchar2);

/* deletes all rows in ref_rating for a specific rating_id */

  procedure delete_rating_points(rating_in number);
  
/* creates a ref_site_rating entry */
  
  procedure create_site_rating(indep_site_datatype_id in number,
  rating_type_common_name in varchar2,
  effective_start_date_time in date,
  effective_end_date_time in date,
  agen_id in number,
  description in varchar2);
  
/* finds the minimum and maximum independent values for a specific rating_id */
  
  procedure find_rating_limits (rating_in in number,
  min_value out number,
  max_value out number);
  
/* finds the bounding independent and dependent values for a specified value and
  rating_id, as well as the same codes as do_rating for match_check */
  
  procedure find_rating_points (rating_in in number,
  indep_value in number,
  x1 out number,
  x2 out number,
  y1 out number,
  y2 out number,
  match_check out nocopy varchar2);

/*
Function to return a rating id if one exists that matches the input parameters
indep_sdi and rating_type are required
value_date_time is optional, and defaults to null
if it is null, ratings will only match if both start and end are null
if eff start or end are not null, they must be before or after value_date
respectively.
There is nothing in ref_site_rating prohibiting overlapping ratings.
Use of this function for time interpolated ratings is problematic because in that
case, we want two ratings, one from before, and one from after the date.

That case is currently left for applications to handle.
The most likely way to implement that is to put all ratings for time interpolation
in the database with  start and end effective dates as instants in time, then
query for the two ratings that span the value date of interest. Then do separate ratings
using those two rating ids, and then do time interpolation between them.
*/
 
  function find_site_rating( rating_type in varchar2,
  indep_sdi in number,
  value_date_time in date) 
  return ref_site_rating.rating_id%type;
  
/* alters a single row in ref_rating, good candiate for a merge statement, but
have not used that yet.*/

  procedure modify_rating_point (rating_in in number, 
  indep_value in number,
  dep_value in number);
  
/*
does a linear interpolation:
if an exact match is found, returns.
assumes the same equation for extrapolation as for interpolation
*/
  procedure rating_linear (rating_in in number,
      indep_value in number,
      indep_date in date,
      indep_base out number,
      dep_value out number,
      match_check out nocopy varchar2);

/*
LOG-LOG algorithm after Hydromet loglog and GSLOGLOG algorithms
Shift and offset are not applied here.
This function does no rounding on output, so it is likely to have many significant
figures (15+)

mathematic exceptions like log of a negative number cause exceptions just like other errors
*/
  procedure rating_logarithm (rating_in in number,
      indep_value in number,
      indep_date in date,
      indep_base out number,
      dep_value out number,
      match_check out nocopy varchar2);

/* want the row matching or immediately below the input
 * makes no sense to handle table bounds here,
 * so we just return B if the input x value is below the lowest number.
 * this should checked by the calling code
 */

  procedure rating_lookup (rating_in in number,
      indep_value in number,
      indep_date in date,
      indep_base out number,
      dep_value out number,
      match_check out nocopy varchar2);

/*
After Hydromet semilogx algorithm
Shift and offset are not applied here.
This function does no rounding on output, so it is likely to have many significant
figures (15+)
*/

  procedure rating_semilogx (rating_in in number,
      indep_value in number,
      indep_date in date,
      indep_base out number,
      dep_value out number,
      match_check out nocopy varchar2);

  PROCEDURE rating_time_interp_lookup(rating_in IN NUMBER,
      indep_value IN NUMBER,
      indep_date IN date,
      indep_base out number,
      dep_value OUT NUMBER,
      match_check OUT nocopy VARCHAR2);
      
   PROCEDURE rating_time_interp_linear(rating_in IN NUMBER,
      indep_value IN NUMBER,
      indep_date IN date,
      indep_base out number,
      dep_value OUT NUMBER,
      match_check OUT nocopy VARCHAR2);
 
/* alters the description field in ref_site_rating for a specified rating_id*/
  
  procedure update_rating_desc ( rating_in in number,
  description_in in varchar2);

END ratings;
.
/
