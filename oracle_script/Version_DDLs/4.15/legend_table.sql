--------------------------------------------------------
-- This script creates a LEGEND table to be used by applications like HDB_POET.
-- IMPORTANT!!! This script should be executed as main schema user that owns the tables.
-- created on 05/10/2023 by IsmailO
--
--
-- #### hdb poet source code ####
--<add key="SourceLegend" value="
--  source data/not computed or manually edited/no overwrite flag set: PaleGreen,
--  source data/not computed or manually edited/overwrite flag set: DarkSeaGreen,
--  computed data from computation processor/not an aggregation from one interval to another: Yellow,
--  computed data from computation processor/is an aggregation from one interval to another: Gold,
--  computed data from computation processor/overwrite flag set: Goldenrod,
--  RiverWare computed data/no overwrite flag set: PaleGoldenrod,
--  RiverWare computed data/overwrite flag set: DarkKhaki,
--  manually edited data/no overwrite flag set: SkyBlue,
--  manually edited data/overwrite flag set: RoyalBlue,
--  RiverWare manually edited data/no overwrite flag set: Aquamarine,
--  RiverWare manually edited data/overwrite flag set: DarkTurquoise,
--  missing data/not yet inserted: LightGray,
--  Validation Failed!!! - Data outside of acceptable parameters: Red,
--  RBase data not available - computations and undo unavailable: DarkOrange
--"/>
--#### END of hdb poet source code ####
--------------------------------------------------------

CREATE TABLE REF_LEGEND (
  color VARCHAR2(20) NOT NULL,
  description VARCHAR2(200) NOT NULL,
  CONSTRAINT pk_legend PRIMARY KEY (color)
) tablespace HDB_DATA ;

comment on table REF_LEGEND is 'Stores the colors and descriptions of legends.';

  GRANT SELECT,INSERT,UPDATE,DELETE ON REF_LEGEND TO CALC_DEFINITION_ROLE;
  GRANT SELECT,INSERT,UPDATE,DELETE ON REF_LEGEND TO SAVOIR_FAIRE;
  GRANT SELECT,INSERT,UPDATE,DELETE ON REF_LEGEND TO REF_META_ROLE;
  GRANT REFERENCES ON REF_LEGEND TO DECODES;
  GRANT SELECT ON REF_LEGEND TO PUBLIC;
  create public synonym REF_LEGEND for REF_LEGEND;
  
  
--For UC only. Other databases will expect to fail.  
  GRANT SELECT ON REF_LEGEND TO HDB_READ_ROLE;
  GRANT SELECT,INSERT,UPDATE,DELETE ON REF_LEGEND TO HDB_WRITE_ROLE;

--populate colors and descriptions  
 INSERT INTO REF_LEGEND (color, description) VALUES ('PaleGreen', 'source data/not computed or manually edited/no overwrite flag set');
 INSERT INTO REF_LEGEND (color, description) VALUES ('DarkSeaGreen', 'source data/not computed or manually edited/overwrite flag set');
 INSERT INTO REF_LEGEND (color, description) VALUES ('Yellow', 'computed data from computation processor/not an aggregation from one interval to another');
 INSERT INTO REF_LEGEND (color, description) VALUES ('Gold', 'computed data from computation processor/is an aggregation from one interval to another');
 INSERT INTO REF_LEGEND (color, description) VALUES ('Goldenrod', 'computed data from computation processor/overwrite flag set');
 INSERT INTO REF_LEGEND (color, description) VALUES ('PaleGoldenrod', 'RiverWare computed data/no overwrite flag set');
 INSERT INTO REF_LEGEND (color, description) VALUES ('DarkKhaki', 'RiverWare computed data/overwrite flag set');
 INSERT INTO REF_LEGEND (color, description) VALUES ('SkyBlue', 'manually edited data/no overwrite flag set');
 INSERT INTO REF_LEGEND (color, description) VALUES ('RoyalBlue', 'manually edited data/overwrite flag set');
 INSERT INTO REF_LEGEND (color, description) VALUES ('Aquamarine', 'RiverWare manually edited data/no overwrite flag set');
 INSERT INTO REF_LEGEND (color, description) VALUES ('DarkTurquoise', 'RiverWare manually edited data/overwrite flag set');
 INSERT INTO REF_LEGEND (color, description) VALUES ('LightGray', 'missing data/not yet inserted');
 INSERT INTO REF_LEGEND (color, description) VALUES ('Red', 'Validation Failed!!! - Data outside of acceptable parameters');
 INSERT INTO REF_LEGEND (color, description) VALUES ('DarkOrange', 'RBase data not available - computations and undo unavailable');
commit;

--update version table
INSERT INTO TSDB_PROPERTY (PROP_NAME, PROP_VALUE) VALUES ('4.15.5', 'REF_LEGEND table have been created.');

--Commit
commit;