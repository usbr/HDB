
undefine tbl_owner
define tbl_owner = &1
set echo off
spool wa_tables.out

PROMPT Creating Table 'REF_WA_MODEL_SITE_CONFIG'
CREATE TABLE &&tbl_owner..REF_WA_MODEL_SITE_CONFIG
 (SITE_ID NUMBER(38) NOT NULL
 ,CONFIG_ID NUMBER(38) NOT NULL
 ,MODEL_ID NUMBER(38) NOT NULL
 ,EFFECTIVE_START_DATE_TIME DATE NOT NULL
 ,EFFECTIVE_END_DATE_TIME DATE
 )
tablespace HDB_data;

ALTER TABLE &&tbl_owner..REF_WA_MODEL_SITE_CONFIG
 ADD CONSTRAINT REF_WA_MODEL_SITE_CONFIG_PK PRIMARY KEY 
  (SITE_ID
  ,CONFIG_ID
  ,MODEL_ID
  ,EFFECTIVE_START_DATE_TIME)
using index tablespace hdb_idx;

ALTER TABLE &&tbl_owner..REF_WA_MODEL_SITE_CONFIG ADD CONSTRAINT
 REF_WA_MODEL_SITE_CONFIG_FK2 FOREIGN KEY 
  (MODEL_ID) REFERENCES HDB_MODEL
  (MODEL_ID);

CREATE PUBLIC SYNONYM REF_WA_MODEL_SITE_CONFIG for &&tbl_owner..REF_WA_MODEL_SITE_CONFIG;
GRANT SELECT on &&tbl_owner..REF_WA_MODEL_SITE_CONFIG to PUBLIC;
GRANT SELECT, INSERT, UPDATE, DELETE on &&tbl_owner..REF_WA_MODEL_SITE_CONFIG to WA_ROLE;

COMMENT ON TABLE REF_WA_MODEL_SITE_CONFIG IS 'For each model in HDB, indicates sites and site configurations which are valid at a point in time. Initially intended for use with logical (account, supply, exchange) sites and subbasins, not physical sites.'
/

COMMENT ON COLUMN REF_WA_MODEL_SITE_CONFIG.SITE_ID IS 'Site_id for this model configuration, from one of the base tables in REF_WA_Site_Config_View. FK (with config_id) to REF_WA_Site_Config_View.'
/

COMMENT ON COLUMN REF_WA_MODEL_SITE_CONFIG.CONFIG_ID IS 'Config_id for this site and model.  FK (with site_id) to REF_WA_Site_Config_View.'
/

COMMENT ON COLUMN REF_WA_MODEL_SITE_CONFIG.MODEL_ID IS 'Model_id for this site configuration. FK to HDB_Model.'
/

COMMENT ON COLUMN REF_WA_MODEL_SITE_CONFIG.EFFECTIVE_START_DATE_TIME IS 'Start date and time for which this model site configuration is valid.'
/

COMMENT ON COLUMN REF_WA_MODEL_SITE_CONFIG.EFFECTIVE_END_DATE_TIME IS 'End date and time for which this model site configuration is valid.'
/

PROMPT Creating Table 'REF_WA_RELEASETYPE'
CREATE TABLE &&tbl_owner..REF_WA_RELEASETYPE
 (RELEASETYPE_ID NUMBER(38) NOT NULL
 ,RELEASETYPE_NAME VARCHAR2(64) NOT NULL
 ,RELEASETYPE_COMMON_NAME VARCHAR2(64) NOT NULL
 ,RELEASETYPE_SHORT_NAME VARCHAR2(10) 
 ,EFFECTIVE_START_DATE date NOT NULL
 ,EFFECTIVE_END_DATE date 
 ,CMMNT VARCHAR2(1000)
 )
tablespace HDB_data;

ALTER TABLE &&tbl_owner..REF_WA_RELEASETYPE
 ADD CONSTRAINT REF_WA_RELEASETYPE_PK PRIMARY KEY 
  (RELEASETYPE_ID)
using index tablespace hdb_idx;

CREATE PUBLIC SYNONYM REF_WA_RELEASETYPE for &&tbl_owner..REF_WA_RELEASETYPE;
GRANT SELECT on &&tbl_owner..REF_WA_RELEASETYPE to PUBLIC;
GRANT SELECT, INSERT, UPDATE, DELETE on &&tbl_owner..REF_WA_RELEASETYPE to WA_ROLE;


COMMENT ON TABLE REF_WA_RELEASETYPE IS 'Lookup for all release types.'
/

COMMENT ON COLUMN REF_WA_RELEASETYPE.RELEASETYPE_ID IS 'Unique identifier. No implicit meaning.'
/

COMMENT ON COLUMN REF_WA_RELEASETYPE.RELEASETYPE_NAME IS 'Name of this releasetype.'
/

COMMENT ON COLUMN REF_WA_RELEASETYPE.CMMNT IS 'Comment.'
/

PROMPT Creating Table 'REF_WA_DESTINATION'
CREATE TABLE &&tbl_owner..REF_WA_DESTINATION
 (DESTINATION_ID NUMBER(38) NOT NULL
 ,DESTINATION_NAME VARCHAR2(64) NOT NULL
 ,DESTINATION_COMMON_NAME VARCHAR2(64) NOT NULL
 ,DESTINATION_SHORT_NAME VARCHAR2(10) 
 ,EFFECTIVE_START_DATE date NOT NULL
 ,EFFECTIVE_END_DATE date 
 ,CMMNT VARCHAR2(1000)
 )
tablespace HDB_data;

ALTER TABLE &&tbl_owner..REF_WA_DESTINATION
 ADD CONSTRAINT REF_WA_DESTINATION_PK PRIMARY KEY 
  (DESTINATION_ID)
using index tablespace hdb_idx;

CREATE PUBLIC SYNONYM REF_WA_DESTINATION for &&tbl_owner..REF_WA_DESTINATION;
GRANT SELECT on &&tbl_owner..REF_WA_DESTINATION to PUBLIC;
GRANT SELECT, INSERT, UPDATE, DELETE on &&tbl_owner..REF_WA_DESTINATION to WA_ROLE;

COMMENT ON TABLE REF_WA_DESTINATION IS 'Lookup for release destinations.'
/

COMMENT ON COLUMN REF_WA_DESTINATION.DESTINATION_ID IS 'Unique identifier. No implicit meaning.'
/

COMMENT ON COLUMN REF_WA_DESTINATION.DESTINATION_NAME IS 'Name of release destination.'
/

COMMENT ON COLUMN REF_WA_DESTINATION.CMMNT IS 'Comment.'
/
PROMPT Creating Table 'REF_WA_SUPPLYTYPE'
CREATE TABLE &&tbl_owner..REF_WA_SUPPLYTYPE
 (SUPPLYTYPE_ID NUMBER(38) NOT NULL
 ,SUPPLYTYPE_NAME VARCHAR2(64) NOT NULL
 ,SUPPLYTYPE_COMMON_NAME VARCHAR2(64) NOT NULL
 ,SUPPLYTYPE_SHORT_NAME VARCHAR2(10) 
 ,EFFECTIVE_START_DATE date NOT NULL
 ,EFFECTIVE_END_DATE date 
 ,CMMNT VARCHAR2(1000)
 )
tablespace HDB_data;

ALTER TABLE &&tbl_owner..REF_WA_SUPPLYTYPE
 ADD CONSTRAINT REF_WA_SUPPLY_TYPE_PK PRIMARY KEY 
  (SUPPLYTYPE_ID)
using index tablespace hdb_idx;

CREATE PUBLIC SYNONYM REF_WA_SUPPLYTYPE for &&tbl_owner..REF_WA_SUPPLYTYPE;
GRANT SELECT on &&tbl_owner..REF_WA_SUPPLYTYPE to PUBLIC;
GRANT SELECT, INSERT, UPDATE, DELETE on &&tbl_owner..REF_WA_SUPPLYTYPE to WA_ROLE;

COMMENT ON TABLE REF_WA_SUPPLYTYPE IS 'Lookup for all supply types.'
/

COMMENT ON COLUMN REF_WA_SUPPLYTYPE.SUPPLYTYPE_ID IS 'Unique identifier. No implicit meaning.'
/

COMMENT ON COLUMN REF_WA_SUPPLYTYPE.SUPPLYTYPE_NAME IS 'Name of this type of supply.'
/

COMMENT ON COLUMN REF_WA_SUPPLYTYPE.CMMNT IS 'Comment.'
/

PROMPT Creating Table 'REF_WA_BORROWTYPE'
CREATE TABLE &&tbl_owner..REF_WA_BORROWTYPE
 (BORROWTYPE_ID NUMBER(38) NOT NULL
 ,BORROWTYPE_NAME VARCHAR2(64) NOT NULL
 ,BORROWTYPE_COMMON_NAME VARCHAR2(64) NOT NULL
 ,BORROWTYPE_SHORT_NAME VARCHAR2(10) 
 ,EFFECTIVE_START_DATE date NOT NULL
 ,EFFECTIVE_END_DATE date 
 ,CMMNT VARCHAR2(1000)
 )
tablespace HDB_data;

ALTER TABLE &&tbl_owner..REF_WA_BORROWTYPE
 ADD CONSTRAINT REF_WA_BORROWTYPE_PK PRIMARY KEY 
  (BORROWTYPE_ID)
using index tablespace hdb_idx;

CREATE PUBLIC SYNONYM REF_WA_BORROWTYPE for &&tbl_owner..REF_WA_BORROWTYPE;
GRANT SELECT on &&tbl_owner..REF_WA_BORROWTYPE to PUBLIC;
GRANT SELECT, INSERT, UPDATE, DELETE on &&tbl_owner..REF_WA_BORROWTYPE to WA_ROLE;

COMMENT ON TABLE REF_WA_BORROWTYPE IS 'Lookup table for types of borrows.'
/

COMMENT ON COLUMN REF_WA_BORROWTYPE.BORROWTYPE_ID IS 'Unique identifier. No implicit meaning.'
/

COMMENT ON COLUMN REF_WA_BORROWTYPE.BORROWTYPE_NAME IS 'Name of type of borrow.'
/

COMMENT ON COLUMN REF_WA_BORROWTYPE.CMMNT IS 'Comment.'
/
PROMPT Creating Table 'REF_WA_WATER_OWNER'
CREATE TABLE &&tbl_owner..REF_WA_WATER_OWNER
 (WATER_OWNER_ID NUMBER(38) NOT NULL
 ,WATER_OWNER_NAME VARCHAR2(64) NOT NULL
 ,WATER_OWNER_COMMON_NAME VARCHAR2(64) NOT NULL
 ,WATER_OWNER_SHORT_NAME VARCHAR2(10)
 ,EFFECTIVE_START_DATE date NOT NULL
 ,EFFECTIVE_END_DATE date 
 ,CMMNT VARCHAR2(1000)
 )
tablespace HDB_data;

ALTER TABLE &&tbl_owner..REF_WA_WATER_OWNER
 ADD CONSTRAINT REF_WA_WATER_OWNER_PK PRIMARY KEY 
  (WATER_OWNER_ID)
using index tablespace hdb_idx;

CREATE PUBLIC SYNONYM REF_WA_WATER_OWNER for &&tbl_owner..REF_WA_WATER_OWNER;
GRANT SELECT on &&tbl_owner..REF_WA_WATER_OWNER to PUBLIC;
GRANT SELECT, INSERT, UPDATE, DELETE on &&tbl_owner..REF_WA_WATER_OWNER to WA_ROLE;

COMMENT ON TABLE REF_WA_WATER_OWNER IS 'Lookup for all water owners, or contractors.'
/

COMMENT ON COLUMN REF_WA_WATER_OWNER.WATER_OWNER_ID IS 'Unique identifier. No implicit meaning.'
/

COMMENT ON COLUMN REF_WA_WATER_OWNER.WATER_OWNER_NAME IS 'Name of the water owner.'
/

COMMENT ON COLUMN REF_WA_WATER_OWNER.CMMNT IS 'Comment.'
/

PROMPT Creating Table 'REF_WA_ANNOTATION_LETTER'
CREATE TABLE &&tbl_owner..REF_WA_ANNOTATION_LETTER
 (ANNOTATION_LETTER_ID NUMBER(38) NOT NULL
 ,LETTER_ISSUED_DATE DATE NOT NULL
 ,AMOUNT_REQUESTED_AF NUMBER NOT NULL
 ,VOLUME_ABOVE_OTOWI NUMBER NOT NULL
 ,VOLUME_BELOW_OTOWI NUMBER NOT NULL
 ,GIVEN_TO_WATER_OWNER_ID NUMBER NOT NULL
 ,DEPLETION_START_DATE DATE NOT NULL
 ,DEPLETION_END_DATE DATE NOT NULL
 ,RELEASED_TO_SITE_ID NUMBER NOT NULL
 ,RELEASE_REQUIRED_COMPLETE_DATE DATE NOT NULL
 ,RELEASE_COMPLETED_DATE DATE
 ,CONVEYANCE_LOSSES_AF NUMBER
 ,CONTROL_NUMBER VARCHAR2(15)
 )
tablespace HDB_data;

ALTER TABLE &&tbl_owner..REF_WA_ANNOTATION_LETTER
 ADD CONSTRAINT REF_WA_ANNOTATION_LETTER_PK PRIMARY KEY 
  (ANNOTATION_LETTER_ID)
using index tablespace hdb_idx;

ALTER TABLE &&tbl_owner..REF_WA_ANNOTATION_LETTER ADD CONSTRAINT
 REF_WA_ANNOTATION_LETTER_FK2 FOREIGN KEY 
  (RELEASED_TO_SITE_ID) REFERENCES HDB_SITE
  (SITE_ID) ADD CONSTRAINT
 REF_WA_ANNOTATION_LETTER_FK1 FOREIGN KEY 
  (GIVEN_TO_WATER_OWNER_ID) REFERENCES REF_WA_WATER_OWNER
  (WATER_OWNER_ID);

CREATE PUBLIC SYNONYM REF_WA_ANNOTATION_LETTER for &&tbl_owner..REF_WA_ANNOTATION_LETTER;
GRANT SELECT on &&tbl_owner..REF_WA_ANNOTATION_LETTER to PUBLIC;
GRANT SELECT, INSERT, UPDATE, DELETE on &&tbl_owner..REF_WA_ANNOTATION_LETTER to WA_ROLE;

COMMENT ON TABLE REF_WA_ANNOTATION_LETTER IS 'Lookup for all details on letter annotations.'
/

COMMENT ON COLUMN REF_WA_ANNOTATION_LETTER.ANNOTATION_LETTER_ID IS 'Unique identifier. No implicit meaning.'
/

COMMENT ON COLUMN REF_WA_ANNOTATION_LETTER.LETTER_ISSUED_DATE IS 'Date the letter was issued.'
/

COMMENT ON COLUMN REF_WA_ANNOTATION_LETTER.VOLUME_ABOVE_OTOWI IS 'Depletions above the Otowi Gage.'
/

COMMENT ON COLUMN REF_WA_ANNOTATION_LETTER.VOLUME_BELOW_OTOWI IS 'Depletions below the Otowi Gage.'
/

COMMENT ON COLUMN REF_WA_ANNOTATION_LETTER.GIVEN_TO_WATER_OWNER_ID IS 'ID of owner (contractor) receiving the water. FK to REF_WA_Water_Owner.'
/

COMMENT ON COLUMN REF_WA_ANNOTATION_LETTER.DEPLETION_START_DATE IS 'Start date for depletions being accounted for.'
/

COMMENT ON COLUMN REF_WA_ANNOTATION_LETTER.DEPLETION_END_DATE IS 'End date for depletions being accounted for.'
/

COMMENT ON COLUMN REF_WA_ANNOTATION_LETTER.RELEASED_TO_SITE_ID IS 'Site to which water was released. FK to HDB_Site.'
/

COMMENT ON COLUMN REF_WA_ANNOTATION_LETTER.RELEASE_REQUIRED_COMPLETE_DATE IS 'Date by which the release must be completed.'
/

COMMENT ON COLUMN REF_WA_ANNOTATION_LETTER.RELEASE_COMPLETED_DATE IS 'Date on which the release was actually completed.'
/

COMMENT ON COLUMN REF_WA_ANNOTATION_LETTER.CONVEYANCE_LOSSES_AF IS 'Losses incurred during the release.'
/

COMMENT ON COLUMN REF_WA_ANNOTATION_LETTER.CONTROL_NUMBER IS 'Control Number for the letter.'
/


CREATE TABLE &&tbl_owner..REF_WA_WATERTYPE
 (WATERTYPE_ID NUMBER(38) NOT NULL
 ,WATERTYPE_NAME VARCHAR2(64) NOT NULL
 ,WATERTYPE_COMMON_NAME VARCHAR2(64) NOT NULL
 ,WATERTYPE_SHORT_NAME VARCHAR2(10) 
 ,EFFECTIVE_START_DATE date NOT NULL
 ,EFFECTIVE_END_DATE date 
 ,CMMNT VARCHAR2(1000)
 )
tablespace HDB_data;

ALTER TABLE &&tbl_owner..REF_WA_WATERTYPE
 ADD CONSTRAINT REF_WA_WATERTYPE_PK PRIMARY KEY 
  (WATERTYPE_ID)
using index tablespace hdb_idx;

CREATE PUBLIC SYNONYM REF_WA_WATERTYPE for &&tbl_owner..REF_WA_WATERTYPE;
GRANT SELECT on &&tbl_owner..REF_WA_WATERTYPE to PUBLIC;
GRANT SELECT, INSERT, UPDATE, DELETE on &&tbl_owner..REF_WA_WATERTYPE to WA_ROLE;

COMMENT ON TABLE REF_WA_WATERTYPE IS 'Lookup for water types.'
/

COMMENT ON COLUMN REF_WA_WATERTYPE.WATERTYPE_ID IS 'Unique identifier. No implicit meaning.'
/

COMMENT ON COLUMN REF_WA_WATERTYPE.WATERTYPE_NAME IS 'Name of the watertype.'
/

COMMENT ON COLUMN REF_WA_WATERTYPE.CMMNT IS 'Comment.'
/

PROMPT Creating Table 'REF_WA_ACCTTYPE'
CREATE TABLE &&tbl_owner..REF_WA_ACCTTYPE
 (ACCTTYPE_ID NUMBER(38) NOT NULL
 ,ACCTTYPE_NAME VARCHAR2(64) NOT NULL
 ,IS_LEGAL_ENTITY VARCHAR2(1) NOT NULL
 ,ACCTTYPE_COMMON_NAME VARCHAR2(64) NOT NULL
 ,ACCTTYPE_SHORT_NAME VARCHAR2(10) 
 ,EFFECTIVE_START_DATE date NOT NULL
 ,EFFECTIVE_END_DATE date 
 ,CMMNT VARCHAR2(1000)
 )
tablespace HDB_data;

ALTER TABLE &&tbl_owner..REF_WA_ACCTTYPE
 ADD CONSTRAINT REF_WA_ACCTTYPE_PK PRIMARY KEY 
  (ACCTTYPE_ID)
using index tablespace hdb_idx;


CREATE PUBLIC SYNONYM REF_WA_ACCTTYPE for &&tbl_owner..REF_WA_ACCTTYPE;
GRANT SELECT on &&tbl_owner..REF_WA_ACCTTYPE to PUBLIC;
GRANT SELECT, INSERT, UPDATE, DELETE on &&tbl_owner..REF_WA_ACCTTYPE to WA_ROLE;

COMMENT ON TABLE REF_WA_ACCTTYPE IS 'Lookup for water account types (e.g., storage, diversion, passthrough) and their attributes.'
/

COMMENT ON COLUMN REF_WA_ACCTTYPE.ACCTTYPE_ID IS 'Unique identifier. No Implicit meaning.'
/

COMMENT ON COLUMN REF_WA_ACCTTYPE.ACCTTYPE_NAME IS 'Name of this account type.'
/

COMMENT ON COLUMN REF_WA_ACCTTYPE.IS_LEGAL_ENTITY IS 'Indicates if this account is a legal entity, or not (e.g., just a modeling entity). Y or N.'
/

COMMENT ON COLUMN REF_WA_ACCTTYPE.CMMNT IS 'Comment.'
/


PROMPT Creating Table 'REF_WA_ANNOTATIONTYPE'
CREATE TABLE &&tbl_owner..REF_WA_ANNOTATIONTYPE
 (ANNOTATIONTYPE_ID NUMBER(38) NOT NULL
 ,ANNOTATIONTYPE_NAME VARCHAR2(64) NOT NULL
 ,ANNOTATIONTYPE_COMMON_NAME VARCHAR2(64) NOT NULL
 ,ANNOTATIONTYPE_SHORT_NAME VARCHAR2(10)
 ,EFFECTIVE_START_DATE date NOT NULL
 ,EFFECTIVE_END_DATE date 
 ,CMMNT VARCHAR2(1000)
 )
tablespace HDB_data;

ALTER TABLE &&tbl_owner..REF_WA_ANNOTATIONTYPE
 ADD CONSTRAINT REF_WA_ANNOTATIONTYPE_PK PRIMARY KEY 
  (ANNOTATIONTYPE_ID)
using index tablespace hdb_idx;

CREATE PUBLIC SYNONYM REF_WA_ANNOTATIONTYPE for &&tbl_owner..REF_WA_ANNOTATIONTYPE;
GRANT SELECT on &&tbl_owner..REF_WA_ANNOTATIONTYPE to PUBLIC;
GRANT SELECT, INSERT, UPDATE, DELETE on &&tbl_owner..REF_WA_ANNOTATIONTYPE to WA_ROLE;

COMMENT ON TABLE REF_WA_ANNOTATIONTYPE IS 'Lookup table for annotation types, such as letter, borrow, etc.'
/

COMMENT ON COLUMN REF_WA_ANNOTATIONTYPE.ANNOTATIONTYPE_ID IS 'Unique identifier. No implicit meaning.'
/

COMMENT ON COLUMN REF_WA_ANNOTATIONTYPE.ANNOTATIONTYPE_NAME IS 'Name of this annotation type.'
/

COMMENT ON COLUMN REF_WA_ANNOTATIONTYPE.CMMNT IS 'Comment.'
/

PROMPT Creating Table 'REF_WA_ACCT'
CREATE TABLE &&tbl_owner..REF_WA_ACCT
 (SITE_ID NUMBER(38) NOT NULL
 ,CONFIG_ID NUMBER(38) NOT NULL
 ,ACCTTYPE_ID NUMBER(38) NOT NULL
 ,WATERTYPE_ID NUMBER(38) NOT NULL
 ,WATER_OWNER_ID NUMBER(38) NOT NULL
 ,ALLOW_STORAGE VARCHAR2(1)
 )
tablespace HDB_data;

ALTER TABLE &&tbl_owner..REF_WA_ACCT
 ADD CONSTRAINT REF_WA_ACCT_PK PRIMARY KEY 
  (SITE_ID
  ,CONFIG_ID)
using index tablespace hdb_idx;

ALTER TABLE &&tbl_owner..REF_WA_ACCT ADD CONSTRAINT
 REF_WA_ACCT_FK4 FOREIGN KEY 
  (WATERTYPE_ID) REFERENCES REF_WA_WATERTYPE
  (WATERTYPE_ID) ADD CONSTRAINT
 REF_WA_ACCT_FK1 FOREIGN KEY 
  (SITE_ID) REFERENCES HDB_SITE
  (SITE_ID) ADD CONSTRAINT
 REF_WA_ACCT_FK2 FOREIGN KEY 
  (ACCTTYPE_ID) REFERENCES REF_WA_ACCTTYPE
  (ACCTTYPE_ID) ADD CONSTRAINT
 REF_WA_ACCT_FK3 FOREIGN KEY 
  (WATER_OWNER_ID) REFERENCES REF_WA_WATER_OWNER
  (WATER_OWNER_ID);

CREATE PUBLIC SYNONYM REF_WA_ACCT for &&tbl_owner..REF_WA_ACCT;
GRANT SELECT on &&tbl_owner..REF_WA_ACCT to PUBLIC;
GRANT SELECT, INSERT, UPDATE, DELETE on &&tbl_owner..REF_WA_ACCT to WA_ROLE;

COMMENT ON TABLE REF_WA_ACCT IS 'Lookup table for all accounts and account-specific information.'
/

COMMENT ON COLUMN REF_WA_ACCT.SITE_ID IS 'Site_id for this account. FK to HDB_Site.'
/

COMMENT ON COLUMN REF_WA_ACCT.CONFIG_ID IS 'Configuration identifier for this account. There are as many config_ids for an account as there are different set of attribute values for the account. Config_id is unique within an account, but not across accounts.'
/

COMMENT ON COLUMN REF_WA_ACCT.ACCTTYPE_ID IS 'Type of this account (e.g., storage, diversion, etc.) FK to REF_WA_Accttype.'
/

COMMENT ON COLUMN REF_WA_ACCT.WATERTYPE_ID IS 'Type (color) of water for this account. FK to REF_WA_Watertype'
/

COMMENT ON COLUMN REF_WA_ACCT.WATER_OWNER_ID IS 'Water owner (contractor) for this account. FK to REF_WA_Water_Owner.'
/

COMMENT ON COLUMN REF_WA_ACCT.ALLOW_STORAGE IS 'Indicates if this account can have storage on it. Appropriate namely for passthrough accounts. Y or N.'
/

PROMPT Creating Table 'REF_WA_SUBBASIN_MEMBERS'
CREATE TABLE &&tbl_owner..REF_WA_SUBBASIN_MEMBERS
 (SITE_ID NUMBER(38) NOT NULL
 ,CONFIG_ID NUMBER(38) NOT NULL
 ,MEMBER_SITE_ID NUMBER(38) NOT NULL
 )
tablespace HDB_data;

ALTER TABLE &&tbl_owner..REF_WA_SUBBASIN_MEMBERS
 ADD CONSTRAINT REF_WA_SUBBASIN_MEMBERS_PK PRIMARY KEY 
  (SITE_ID
  ,CONFIG_ID
  ,MEMBER_SITE_ID)
using index tablespace hdb_idx;

ALTER TABLE &&tbl_owner..REF_WA_SUBBASIN_MEMBERS ADD CONSTRAINT
 REF_WA_SUBBASIN_MEMBERS_FK1 FOREIGN KEY 
  (SITE_ID) REFERENCES HDB_SITE
  (SITE_ID) ADD CONSTRAINT
 REF_WA_SUBBASIN_MEMBERS_FK2 FOREIGN KEY 
  (MEMBER_SITE_ID) REFERENCES HDB_SITE
  (SITE_ID);

CREATE PUBLIC SYNONYM REF_WA_SUBBASIN_MEMBERS for &&tbl_owner..REF_WA_SUBBASIN_MEMBERS;
GRANT SELECT on &&tbl_owner..REF_WA_SUBBASIN_MEMBERS to PUBLIC;
GRANT SELECT, INSERT, UPDATE, DELETE on &&tbl_owner..REF_WA_SUBBASIN_MEMBERS to WA_ROLE;

COMMENT ON TABLE REF_WA_SUBBASIN_MEMBERS IS 'Lookup for all subbasin member relations; can vary by model and date. Note that FK should be defined to ref_subbasin (when it exists), not hdb_site.'
/

COMMENT ON COLUMN REF_WA_SUBBASIN_MEMBERS.SITE_ID IS 'Site_id for this subbasin. FK to HDB_Site. When REF_WA_Subbasin is implemented, needs to be a FK (with config_id) to REF_WA_Subbasin.'
/

COMMENT ON COLUMN REF_WA_SUBBASIN_MEMBERS.CONFIG_ID IS 'Configuration identifier for this set of subbasin members and the parent subbasin. There are as many config_ids for a subbasin as there are different sets of attribute values or members for the subbasin Config_id is unique within a subbasin.'
/

COMMENT ON COLUMN REF_WA_SUBBASIN_MEMBERS.MEMBER_SITE_ID IS 'Site_id of subbasin member. FK to HDB_Site.'
/


PROMPT Creating Table 'REF_WA_LEASETYPE'
CREATE TABLE &&tbl_owner..REF_WA_LEASETYPE
 (LEASETYPE_ID NUMBER(38) NOT NULL
 ,LEASETYPE_NAME VARCHAR2(64) NOT NULL
 ,LEASETYPE_COMMON_NAME VARCHAR2(64) NOT NULL
 ,LEASETYPE_SHORT_NAME VARCHAR2(10) 
 ,EFFECTIVE_START_DATE date NOT NULL
 ,EFFECTIVE_END_DATE date 
 ,CMMNT VARCHAR2(1000)
 )
tablespace HDB_data;

ALTER TABLE &&tbl_owner..REF_WA_LEASETYPE
 ADD CONSTRAINT REF_WA_LEASETYPE_PK PRIMARY KEY 
  (LEASETYPE_ID)
using index tablespace hdb_idx;

CREATE PUBLIC SYNONYM REF_WA_LEASETYPE for &&tbl_owner..REF_WA_LEASETYPE;
GRANT SELECT on &&tbl_owner..REF_WA_LEASETYPE to PUBLIC;
GRANT SELECT, INSERT, UPDATE, DELETE on &&tbl_owner..REF_WA_LEASETYPE to WA_ROLE;

COMMENT ON TABLE REF_WA_LEASETYPE IS 'Lookup table for lease types.'
/

COMMENT ON COLUMN REF_WA_LEASETYPE.LEASETYPE_ID IS 'Unique identifier. No implicit meaning.'
/

COMMENT ON COLUMN REF_WA_LEASETYPE.LEASETYPE_NAME IS 'Name of this type of lease.'
/

COMMENT ON COLUMN REF_WA_LEASETYPE.CMMNT IS 'Comment.'
/

PROMPT Creating Table 'REF_WA_ANNOTATION_LEASE'
CREATE TABLE &&tbl_owner..REF_WA_ANNOTATION_LEASE
 (ANNOTATION_LEASE_ID NUMBER(38) NOT NULL
 ,PURCHASED_FROM_WATER_OWNER_ID NUMBER(38) NOT NULL
 ,CONTRACT_NUMBER VARCHAR2(32) NOT NULL
 ,LEASE_AMOUNT_AF NUMBER NOT NULL
 ,LEASETYPE_ID NUMBER(38) NOT NULL
 )
tablespace HDB_data;

ALTER TABLE &&tbl_owner..REF_WA_ANNOTATION_LEASE
 ADD CONSTRAINT REF_WA_ANNOTATION_LEASE_PK PRIMARY KEY 
  (ANNOTATION_LEASE_ID)
using index tablespace hdb_idx;

ALTER TABLE &&tbl_owner..REF_WA_ANNOTATION_LEASE ADD CONSTRAINT
 REF_WA_ANNOTATION_LEASE_FK2 FOREIGN KEY 
  (LEASETYPE_ID) REFERENCES REF_WA_LEASETYPE
  (LEASETYPE_ID) ADD CONSTRAINT
 REF_WA_ANNOTATION_LEASE_FK1 FOREIGN KEY 
  (PURCHASED_FROM_WATER_OWNER_ID) REFERENCES REF_WA_WATER_OWNER
  (WATER_OWNER_ID);

CREATE PUBLIC SYNONYM REF_WA_ANNOTATION_LEASE for &&tbl_owner..REF_WA_ANNOTATION_LEASE;
GRANT SELECT on &&tbl_owner..REF_WA_ANNOTATION_LEASE to PUBLIC;
GRANT SELECT, INSERT, UPDATE, DELETE on &&tbl_owner..REF_WA_ANNOTATION_LEASE to WA_ROLE;

COMMENT ON TABLE REF_WA_ANNOTATION_LEASE IS 'Lookup table for lease annotation details.'
/

COMMENT ON COLUMN REF_WA_ANNOTATION_LEASE.ANNOTATION_LEASE_ID IS 'Unique identifier. No implicit meaning.'
/

COMMENT ON COLUMN REF_WA_ANNOTATION_LEASE.PURCHASED_FROM_WATER_OWNER_ID IS 'ID of contractor from which water was purchased. FK to REF_WA_Water_Owner.'
/

COMMENT ON COLUMN REF_WA_ANNOTATION_LEASE.CONTRACT_NUMBER IS 'Contract number.'
/

COMMENT ON COLUMN REF_WA_ANNOTATION_LEASE.LEASE_AMOUNT_AF IS 'Amount of water leased.'
/

COMMENT ON COLUMN REF_WA_ANNOTATION_LEASE.LEASETYPE_ID IS 'Type of lease (e.g. irrigation, minnow)'
/


PROMPT Creating Table 'REF_WA_DMI_SITE_MAP'
CREATE TABLE &&tbl_owner..REF_WA_DMI_SITE_MAP
 (MODEL_ID NUMBER(38) NOT NULL
 ,OBJECT_NAME VARCHAR2(240) NOT NULL
 ,OBJECTTYPE_ID NUMBER(38) NOT NULL
 ,SITE_ID NUMBER(38) NOT NULL
 ,EFFECTIVE_START_DATE_TIME DATE NOT NULL
 ,EFFECTIVE_END_DATE_TIME DATE 
 )
tablespace HDB_data;

ALTER TABLE &&tbl_owner..REF_WA_DMI_SITE_MAP
 ADD CONSTRAINT REF_WA_DMI_SITE_MAP_PK PRIMARY KEY 
  (MODEL_ID
  ,OBJECT_NAME
  ,OBJECTTYPE_ID
  ,SITE_ID
  ,EFFECTIVE_START_DATE_TIME)
using index tablespace hdb_idx;

ALTER TABLE &&tbl_owner..REF_WA_DMI_SITE_MAP ADD CONSTRAINT
 REF_WA_DMI_SITE_MAP_FK1 FOREIGN KEY 
  (MODEL_ID) REFERENCES HDB_MODEL
  (MODEL_ID) ADD CONSTRAINT
 REF_WA_DMI_SITE_MAP_FK2 FOREIGN KEY 
  (OBJECTTYPE_ID) REFERENCES HDB_OBJECTTYPE
  (OBJECTTYPE_ID) ADD CONSTRAINT
 REF_WA_DMI_SITE_MAP_FK3 FOREIGN KEY 
  (SITE_ID) REFERENCES HDB_SITE
  (SITE_ID);

CREATE PUBLIC SYNONYM REF_WA_DMI_SITE_MAP for &&tbl_owner..REF_WA_DMI_SITE_MAP;
GRANT SELECT on &&tbl_owner..REF_WA_DMI_SITE_MAP to PUBLIC;
GRANT SELECT, INSERT, UPDATE, DELETE on &&tbl_owner..REF_WA_DMI_SITE_MAP to WA_ROLE;

COMMENT ON TABLE REF_WA_DMI_SITE_MAP IS 'Mapping of modeling objects onto HDB site IDs. Mapping can vary by model, object type, and date.'
/

COMMENT ON COLUMN REF_WA_DMI_SITE_MAP.MODEL_ID IS 'ID of model for which this site mapping is valid. FK to HDB_Model.'
/

COMMENT ON COLUMN REF_WA_DMI_SITE_MAP.OBJECT_NAME IS 'Name of object in modeling system, such as Riverware. 240 characters to accomodate very long object names in Riverware.'
/

COMMENT ON COLUMN REF_WA_DMI_SITE_MAP.EFFECTIVE_START_DATE_TIME IS 'Date and time at which this mapping became valid.'
/

COMMENT ON COLUMN REF_WA_DMI_SITE_MAP.EFFECTIVE_END_DATE_TIME IS 'Date and time at which this mapping became invalid.'
/

COMMENT ON COLUMN REF_WA_DMI_SITE_MAP.OBJECTTYPE_ID IS 'Type of HDB object for which this mapping applies. (That is, a given modeling object might map to different HDB sites depending on whether climate, reservoir, etc. data is of interest). FK to HDB_Objecttype.'
/

COMMENT ON COLUMN REF_WA_DMI_SITE_MAP.SITE_ID IS 'ID of HDB site to which this modeling object maps, given the objecttype_id. FK to HDB_Site.'
/


PROMPT Creating Table 'REF_WA_SUPPLY_ROLE'
CREATE TABLE &&tbl_owner..REF_WA_SUPPLY_ROLE
 (SUPPLY_ROLE_ID NUMBER(38) NOT NULL
 ,SUPPLY_ROLE_NAME VARCHAR2(64) NOT NULL
 ,SUPPLY_ROLE_COMMON_NAME VARCHAR2(64) NOT NULL
 ,SUPPLY_ROLE_SHORT_NAME VARCHAR2(10) 
 ,EFFECTIVE_START_DATE date NOT NULL
 ,EFFECTIVE_END_DATE date 
 ,CMMNT VARCHAR2(1000)
 )
tablespace HDB_data;

ALTER TABLE &&tbl_owner..REF_WA_SUPPLY_ROLE
 ADD CONSTRAINT REF_WA_SUPPLY_ROLE_PK PRIMARY KEY 
  (SUPPLY_ROLE_ID)
using index tablespace hdb_idx;

CREATE PUBLIC SYNONYM REF_WA_SUPPLY_ROLE for &&tbl_owner..REF_WA_SUPPLY_ROLE;
GRANT SELECT on &&tbl_owner..REF_WA_SUPPLY_ROLE to PUBLIC;
GRANT SELECT, INSERT, UPDATE, DELETE on &&tbl_owner..REF_WA_SUPPLY_ROLE to WA_ROLE;

COMMENT ON TABLE REF_WA_SUPPLY_ROLE IS 'Lookup for all supply roles as defined in Riverware (e.g., borrow, input borrow, standalone).'
/

COMMENT ON COLUMN REF_WA_SUPPLY_ROLE.SUPPLY_ROLE_ID IS 'Unique identifier. No implicit meaning.'
/

COMMENT ON COLUMN REF_WA_SUPPLY_ROLE.SUPPLY_ROLE_NAME IS 'Name of the supply role.'
/

COMMENT ON COLUMN REF_WA_SUPPLY_ROLE.CMMNT IS 'Comment.'
/

PROMPT Creating Table 'REF_WA_SUPPLY'
CREATE TABLE &&tbl_owner..REF_WA_SUPPLY
 (SITE_ID NUMBER(38) NOT NULL
 ,CONFIG_ID NUMBER(38) NOT NULL
 ,SUPPLYTYPE_ID NUMBER(38) NOT NULL
 ,SUPPLY_ROLE_ID NUMBER(38) NOT NULL
 ,SOURCE_ACCT_NAME VARCHAR2(240)
 ,SOURCE_ACCT_ID NUMBER(38)
 ,DOWNSTREAM_ACCT_NAME VARCHAR2(240)
 ,DOWNSTREAM_ACCT_ID NUMBER(38)
 ,RELEASETYPE_ID NUMBER(38)
 ,DESTINATION_ID NUMBER(38)
 )
tablespace HDB_data;

ALTER TABLE &&tbl_owner..REF_WA_SUPPLY
 ADD CONSTRAINT REF_WA_SUPPLY_PK PRIMARY KEY 
  (SITE_ID
  ,CONFIG_ID)
using index tablespace hdb_idx;

ALTER TABLE &&tbl_owner..REF_WA_SUPPLY ADD CONSTRAINT
 REF_WA_SUPPLY_FK1 FOREIGN KEY 
  (SITE_ID) REFERENCES HDB_SITE
  (SITE_ID) ADD CONSTRAINT
 REF_WA_SUPPLY_FK7 FOREIGN KEY 
  (DESTINATION_ID) REFERENCES REF_WA_DESTINATION
  (DESTINATION_ID) ADD CONSTRAINT
 REF_WA_SUPPLY_FK3 FOREIGN KEY 
  (DOWNSTREAM_ACCT_ID) REFERENCES HDB_SITE
  (SITE_ID) ADD CONSTRAINT
 REF_WA_SUPPLY_FK2 FOREIGN KEY 
  (SOURCE_ACCT_ID) REFERENCES HDB_SITE
  (SITE_ID) ADD CONSTRAINT
 REF_WA_SUPPLY_FK4 FOREIGN KEY 
  (SUPPLY_ROLE_ID) REFERENCES REF_WA_SUPPLY_ROLE
  (SUPPLY_ROLE_ID) ADD CONSTRAINT
 REF_WA_SUPPLY_FK5 FOREIGN KEY 
  (SUPPLYTYPE_ID) REFERENCES REF_WA_SUPPLYTYPE
  (SUPPLYTYPE_ID) ADD CONSTRAINT
 REF_WA_SUPPLY_FK6 FOREIGN KEY 
  (RELEASETYPE_ID) REFERENCES REF_WA_RELEASETYPE
  (RELEASETYPE_ID);


CREATE PUBLIC SYNONYM REF_WA_SUPPLY for &&tbl_owner..REF_WA_SUPPLY;
GRANT SELECT on &&tbl_owner..REF_WA_SUPPLY to PUBLIC;
GRANT SELECT, INSERT, UPDATE, DELETE on &&tbl_owner..REF_WA_SUPPLY to WA_ROLE;

COMMENT ON TABLE REF_WA_SUPPLY IS 'Lookup table for all supplies and supply-specific information.'
/

COMMENT ON COLUMN REF_WA_SUPPLY.SITE_ID IS 'Site_id of supply. FK to HDB_Site.'
/

COMMENT ON COLUMN REF_WA_SUPPLY.CONFIG_ID IS 'Configuration identifier for this supply. There are as many config_ids for a supply as there are different set of attribute values for the supply. Config_id is unique within a supply, but not across supplies.'
/

COMMENT ON COLUMN REF_WA_SUPPLY.SUPPLYTYPE_ID IS 'ID for this supply type (e.g., inflow/outflow, diversion/return flow). FK to REF_WA_Supplytype.'
/

COMMENT ON COLUMN REF_WA_SUPPLY.SUPPLY_ROLE_ID IS 'ID to indicate role that this supply has in Riverware (e.g., standalone, borrow, input borrow, etc). FK to REF_WA_Supply_Role.'
/

COMMENT ON COLUMN REF_WA_SUPPLY.SOURCE_ACCT_NAME IS 'Name of account on upstream end of supply. Use without source_acct_id when have a supply whose upstream account is not stored in HDB. This allows supply to be fully described without requiring storage of numerous unneeded passthrough accounts.'
/

COMMENT ON COLUMN REF_WA_SUPPLY.SOURCE_ACCT_ID IS 'ID of account on upstream end of supply. Do not use unless upstream account is stored in HDB. FK to REF_WA_Acct.'
/

COMMENT ON COLUMN REF_WA_SUPPLY.DOWNSTREAM_ACCT_NAME IS 'Name of account on downstream end of supply. Use without source_acct_id when have a supply whose downstream account is not stored in HDB. This allows supply to be fully described without requiring storage of numerous unneeded passthrough accounts.'
/

COMMENT ON COLUMN REF_WA_SUPPLY.DOWNSTREAM_ACCT_ID IS 'ID of account on downstream end of supply. Do not use unless downstream account is stored in HDB. FK to REF_WA_Acct.'
/

COMMENT ON COLUMN REF_WA_SUPPLY.RELEASETYPE_ID IS 'ID for this type of release, as the releasetype is indicated on the supply in Riverware. FK to REF_WA_Releasetype.'
/

COMMENT ON COLUMN REF_WA_SUPPLY.DESTINATION_ID IS 'ID for this destination, as the destination is indicated on the supply in Riverware. FK to REF_WA_Destination.'
/

PROMPT Creating Table 'REF_WA_ANNOTATION'
CREATE TABLE &&tbl_owner..REF_WA_ANNOTATION
 (ANNOTATION_ID NUMBER(38) NOT NULL
 ,SUPPLY_ID NUMBER(38) NOT NULL
 ,RELEASE_START_DATE DATE NOT NULL
 ,ANNOTATIONTYPE_ID NUMBER(38) NOT NULL
 ,RELATED_ANNOTATION_ID NUMBER(38) 
 ,AUXILIARY_ANNOTATION_ID NUMBER(38) 
 ,ANNOTATION_CMMNT VARCHAR2(2000)
 ,ANNOTATION_DESCR VARCHAR2(30)
 )
tablespace HDB_data;

ALTER TABLE &&tbl_owner..REF_WA_ANNOTATION
 ADD CONSTRAINT REF_WA_ANNOTATION_PK PRIMARY KEY 
  (ANNOTATION_ID)
using index tablespace hdb_idx;

ALTER TABLE &&tbl_owner..REF_WA_ANNOTATION 
 ADD CONSTRAINT REF_WA_ANNOTATION_UK UNIQUE 
  (SUPPLY_ID
  ,RELEASE_START_DATE)
using index tablespace hdb_idx;

ALTER TABLE &&tbl_owner..REF_WA_ANNOTATION ADD CONSTRAINT
 REF_WA_ANNOTATION_FK1 FOREIGN KEY 
  (SUPPLY_ID) REFERENCES HDB_SITE
  (SITE_ID) ADD CONSTRAINT
 REF_WA_ANNOTATION_FK3 FOREIGN KEY 
  (RELATED_ANNOTATION_ID) REFERENCES REF_WA_ANNOTATION
  (ANNOTATION_ID) ADD CONSTRAINT
 REF_WA_ANNOTATION_FK4 FOREIGN KEY 
  (AUXILIARY_ANNOTATION_ID) REFERENCES REF_WA_ANNOTATION
  (ANNOTATION_ID);

CREATE PUBLIC SYNONYM REF_WA_ANNOTATION for &&tbl_owner..REF_WA_ANNOTATION;
GRANT SELECT on &&tbl_owner..REF_WA_ANNOTATION to PUBLIC;
GRANT SELECT, INSERT, UPDATE, DELETE on &&tbl_owner..REF_WA_ANNOTATION to WA_ROLE;


COMMENT ON TABLE REF_WA_ANNOTATION IS 'Lookup table for all annotations on releases.'
/

COMMENT ON COLUMN REF_WA_ANNOTATION.ANNOTATION_ID IS 'Unique identifier. No implicit meaning.'
/

COMMENT ON COLUMN REF_WA_ANNOTATION.SUPPLY_ID IS 'Supply to which this annotation applies. FK to REF_WA_Supply.'
/

COMMENT ON COLUMN REF_WA_ANNOTATION.RELEASE_START_DATE IS 'Date the release of water for this reason was started.'
/

COMMENT ON COLUMN REF_WA_ANNOTATION.RELATED_ANNOTATION_ID IS 'Previously-defined annotation to which this one is related (e.g., a pointer to a Borrow annotation related to the current Payback). FK to REF_WA_Annotation.'
/

COMMENT ON COLUMN REF_WA_ANNOTATION.ANNOTATIONTYPE_ID IS 'Type of the annotation (for instance letter, borrow, lease, irrigation, etc). FK to REF_WA_Annotationtype'
/

COMMENT ON COLUMN REF_WA_ANNOTATION.AUXILIARY_ANNOTATION_ID IS 'ID of type-specific annotation for this event. That is, pointer to information specific to this letter, borrow, or lease. FK to REF_WA_Auxiliary_Annotation_View.'
/

COMMENT ON COLUMN REF_WA_ANNOTATION.ANNOTATION_CMMNT IS 'Comment to further describe the release event.'
/

COMMENT ON COLUMN REF_WA_ANNOTATION.ANNOTATION_DESCR IS 'Descriptor intended to identify the annotation.'
/

PROMPT Creating Table 'REF_WA_EXCHANGE'
CREATE TABLE REF_WA_EXCHANGE
 (SITE_ID NUMBER(38) NOT NULL
 ,CONFIG_ID NUMBER(38) NOT NULL
 ,BORROW_SUPPLY_ID NUMBER(38) 
 ,PAYBACK_DESTINATION_SUPPLY_ID NUMBER(38)
 )
tablespace HDB_data;

ALTER TABLE &&tbl_owner..REF_WA_EXCHANGE
 ADD CONSTRAINT REF_WA_EXCHANGE_PK PRIMARY KEY 
  (SITE_ID
  ,CONFIG_ID)
using index tablespace hdb_idx;

ALTER TABLE &&tbl_owner..REF_WA_EXCHANGE ADD CONSTRAINT
 REF_WA_EXCHANGE_FK1 FOREIGN KEY 
  (SITE_ID) REFERENCES HDB_SITE
  (SITE_ID) ADD CONSTRAINT
 REF_WA_EXCHANGE_FK2 FOREIGN KEY 
  (BORROW_SUPPLY_ID) REFERENCES HDB_SITE
  (SITE_ID) ADD CONSTRAINT
 REF_WA_EXCHANGE_FK3 FOREIGN KEY 
  (PAYBACK_DESTINATION_SUPPLY_ID) REFERENCES HDB_SITE
  (SITE_ID);

CREATE PUBLIC SYNONYM REF_WA_EXCHANGE for &&tbl_owner..REF_WA_EXCHANGE;
GRANT SELECT on &&tbl_owner..REF_WA_EXCHANGE to PUBLIC;
GRANT SELECT, INSERT, UPDATE, DELETE on &&tbl_owner..REF_WA_EXCHANGE to WA_ROLE;

COMMENT ON TABLE REF_WA_EXCHANGE IS 'Lookup table for all exchange-specific information.'
/

COMMENT ON COLUMN REF_WA_EXCHANGE.SITE_ID IS 'Site_id of this exchange. FK to HDB_Site.'
/

COMMENT ON COLUMN REF_WA_EXCHANGE.CONFIG_ID IS 'Configuration identifier for this exhange and its paybacks. There are as many config_ids for an exchange as there are different sets of attribute values or payback supplies for the exchange. Config_id is unique within an exchange.'
/

COMMENT ON COLUMN REF_WA_EXCHANGE.BORROW_SUPPLY_ID IS 'ID of supply from which the water is borrowed. FK to HDB_Supply.'
/

COMMENT ON COLUMN REF_WA_EXCHANGE.PAYBACK_DESTINATION_SUPPLY_ID IS 'ID of supply which the water must reach before being counted as "payed back." Optional. FK to REF_WA_Supply.'
/

PROMPT Creating Table 'REF_WA_EXCHANGE_PAYBACK'
CREATE TABLE &&tbl_owner..REF_WA_EXCHANGE_PAYBACK
 (SITE_ID NUMBER(38) NOT NULL
 ,CONFIG_ID NUMBER(38) NOT NULL
 ,EXCHANGE_SITE_ID NUMBER(38) NOT NULL
 ,PAYBACK_SUPPLY_ID NUMBER(38) NOT NULL
 ,PAYBACK_LEGAL_LOSS_AF NUMBER NOT NULL
 )
tablespace HDB_data;

ALTER TABLE &&tbl_owner..REF_WA_EXCHANGE_PAYBACK
 ADD CONSTRAINT REF_WA_EXCHANGE_PAYBACK_PK PRIMARY KEY 
 (SITE_ID 
 ,CONFIG_ID)
using index tablespace hdb_idx;

ALTER TABLE &&tbl_owner..REF_WA_EXCHANGE_PAYBACK ADD CONSTRAINT
 REF_WA_EXCHANGE_PAYBACK_FK1 FOREIGN KEY 
  (SITE_ID) REFERENCES HDB_SITE
  (SITE_ID) ADD CONSTRAINT
 REF_WA_EXCHANGE_PAYBACK_FK2 FOREIGN KEY 
  (EXCHANGE_SITE_ID) REFERENCES HDB_SITE
  (SITE_ID ) ADD CONSTRAINT
 REF_WA_EXCHANGE_PAYBACK_FK3 FOREIGN KEY 
  (PAYBACK_SUPPLY_ID) REFERENCES HDB_SITE
  (SITE_ID);


CREATE PUBLIC SYNONYM REF_WA_EXCHANGE_PAYBACK for &&tbl_owner..REF_WA_EXCHANGE_PAYBACK;
GRANT SELECT on &&tbl_owner..REF_WA_EXCHANGE_PAYBACK to PUBLIC;
GRANT SELECT, INSERT, UPDATE, DELETE on &&tbl_owner..REF_WA_EXCHANGE_PAYBACK to WA_ROLE;


COMMENT ON COLUMN REF_WA_EXCHANGE_PAYBACK.SITE_ID IS 'Site_id of this exchange payback. FK to HDB_Site.'
/

COMMENT ON COLUMN REF_WA_EXCHANGE_PAYBACK.CONFIG_ID IS 'Configuration identifier for this exhange payback. There are as many config_ids for an exchange payback as there are different sets of attribute values or payback supplies for the exchange. Config_id is unique within an exchange payback.'
/
COMMENT ON TABLE REF_WA_EXCHANGE_PAYBACK IS 'Lookup for exchange payback definitions.'
/

COMMENT ON COLUMN REF_WA_EXCHANGE_PAYBACK.EXCHANGE_SITE_ID IS 'ID of the exchange that this payback applies to. FK to REF_WA_Exchange.'
/

COMMENT ON COLUMN REF_WA_EXCHANGE_PAYBACK.PAYBACK_SUPPLY_ID IS 'ID of supply paying back this exchange. FK to REF_WA_Supply.'
/

COMMENT ON COLUMN REF_WA_EXCHANGE_PAYBACK.PAYBACK_LEGAL_LOSS_AF IS 'Legal loss for this payback supply.'
/


PROMPT Creating Table 'REF_WA_ANNOTATION_BORROW'
CREATE TABLE &&tbl_owner..REF_WA_ANNOTATION_BORROW
 (ANNOTATION_BORROW_ID NUMBER(38) NOT NULL
 ,BORROWED_FROM_WATER_OWNER_ID NUMBER(38) NOT NULL
 ,BORROW_DATE DATE NOT NULL
 ,BORROW_AMOUNT_AF NUMBER NOT NULL
 ,BORROWTYPE_ID NUMBER NOT NULL
 )
tablespace HDB_data;

ALTER TABLE &&tbl_owner..REF_WA_ANNOTATION_BORROW
 ADD CONSTRAINT REF_WA_ANNOTATION_BORROW_PK PRIMARY KEY 
  (ANNOTATION_BORROW_ID)
using index tablespace hdb_idx;

ALTER TABLE &&tbl_owner..REF_WA_ANNOTATION_BORROW ADD CONSTRAINT
 REF_WA_ANNOTATION_BORROW_FK2 FOREIGN KEY 
  (BORROWTYPE_ID) REFERENCES REF_WA_BORROWTYPE
  (BORROWTYPE_ID) ADD CONSTRAINT
 REF_WA_ANNOTATION_BORROW_FK1 FOREIGN KEY 
  (BORROWED_FROM_WATER_OWNER_ID) REFERENCES REF_WA_WATER_OWNER
  (WATER_OWNER_ID);

CREATE PUBLIC SYNONYM REF_WA_ANNOTATION_BORROW for &&tbl_owner..REF_WA_ANNOTATION_BORROW;
GRANT SELECT on &&tbl_owner..REF_WA_ANNOTATION_BORROW to PUBLIC;
GRANT SELECT, INSERT, UPDATE, DELETE on &&tbl_owner..REF_WA_ANNOTATION_BORROW to WA_ROLE;

COMMENT ON TABLE REF_WA_ANNOTATION_BORROW IS 'Lookup for all details on borrow annotations.'
/

COMMENT ON COLUMN REF_WA_ANNOTATION_BORROW.ANNOTATION_BORROW_ID IS 'Unique identifier. No implicit meaning.'
/

COMMENT ON COLUMN REF_WA_ANNOTATION_BORROW.BORROWED_FROM_WATER_OWNER_ID IS 'ID of owner from which the water was borrowed. FK to REF_WA_Water_Owner.'
/

COMMENT ON COLUMN REF_WA_ANNOTATION_BORROW.BORROW_AMOUNT_AF IS 'Amount borrowed.'
/

COMMENT ON COLUMN REF_WA_ANNOTATION_BORROW.BORROWTYPE_ID IS 'ID indicating the type of this borrow (e.g., minnow, irrigation, letter). FK to REF_WA_Borrowtype'
/


PROMPT Creating Table 'REF_WA_SLOT_DATA'
CREATE TABLE &&tbl_owner..REF_WA_SLOT_DATA
 (MODEL_ID     NUMBER(38)    NOT NULL
 ,LNNO         varchar2(20) 
 ,SECTION      VARCHAR2(20)
 ,OBJECT       VARCHAR2(240)
 ,OBJECT_TYPE  VARCHAR2(20)
 ,SLOT         VARCHAR2(50)
 ,SLOT_TYPE    VARCHAR2(20)
 ,UNIT_TYPE    VARCHAR2(20)
 ,UNIT_SCALE   VARCHAR2(20)
 ,UNITS        VARCHAR2(20)
 ,UNIT_FMT     VARCHAR2(20)
 ,UNIT_SPEC    VARCHAR2(20)
 ,DATA_TYPE    VARCHAR2(20)
 )
tablespace HDB_data;

CREATE PUBLIC SYNONYM REF_WA_SLOT_DATA for &&tbl_owner..REF_WA_SLOT_DATA;
GRANT SELECT on &&tbl_owner..REF_WA_SLOT_DATA to PUBLIC;
GRANT SELECT, INSERT, UPDATE, DELETE on &&tbl_owner..REF_WA_SLOT_DATA to WA_ROLE;


PROMPT Modifying Table 'HDB_SITE'
alter table &&tbl_owner..hdb_site modify (site_name varchar2(240),site_common_name varchar2(240));

PROMPT Modifying Table 'REF_DMI_DATA_MAP'
alter table &&tbl_owner..REF_DMI_DATA_MAP modify (object_name varchar2(240));

spool off

