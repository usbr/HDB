undefine tbl_owner
define tbl_owner = &1
set echo off
spool wa_constraints.out

PROMPT Creating Primary Key on 'REF_MODEL_SITE_CONFIG'
ALTER TABLE &&tbl_owner..REF_MODEL_SITE_CONFIG
 ADD CONSTRAINT REF_MODEL_SITE_CONFIG_PK PRIMARY KEY 
  (SITE_ID
  ,CONFIG_ID
  ,MODEL_ID
  ,EFFECTIVE_START_DATE_TIME)
using index tablespace hdb_index
/

PROMPT Creating Primary Key on 'REF_RELEASETYPE'
ALTER TABLE &&tbl_owner..REF_RELEASETYPE
 ADD CONSTRAINT REF_RELEASETYPE_PK PRIMARY KEY 
  (RELEASETYPE_ID)
using index tablespace hdb_index
/

PROMPT Creating Primary Key on 'REF_EXCHANGE_PAYBACK'
ALTER TABLE &&tbl_owner..REF_EXCHANGE_PAYBACK
 ADD CONSTRAINT REF_EXCHANGE_PAYBACK_PK PRIMARY KEY 
  (EXCHANGE_SITE_ID
  ,EXCHANGE_CONFIG_ID
  ,PAYBACK_SUPPLY_ID)
using index tablespace hdb_index
/

PROMPT Creating Primary Key on 'REF_SUPPLYTYPE'
ALTER TABLE &&tbl_owner..REF_SUPPLYTYPE
 ADD CONSTRAINT REF_SUPPLY_TYPE_PK PRIMARY KEY 
  (SUPPLYTYPE_ID)
using index tablespace hdb_index
/

PROMPT Creating Primary Key on 'REF_ANNOTATION'
ALTER TABLE &&tbl_owner..REF_ANNOTATION
 ADD CONSTRAINT REF_ANNOTATION_PK PRIMARY KEY 
  (ANNOTATION_ID)
using index tablespace hdb_index
/

PROMPT Creating Primary Key on 'REF_EXCHANGE'
ALTER TABLE &&tbl_owner..REF_EXCHANGE
 ADD CONSTRAINT REF_EXCHANGE_PK PRIMARY KEY 
  (SITE_ID
  ,CONFIG_ID)
using index tablespace hdb_index
/

PROMPT Creating Primary Key on 'REF_ANNOTATION_BORROW'
ALTER TABLE &&tbl_owner..REF_ANNOTATION_BORROW
 ADD CONSTRAINT REF_ANNOTATION_BORROW_PK PRIMARY KEY 
  (ANNOTATION_BORROW_ID)
using index tablespace hdb_index
/

PROMPT Creating Primary Key on 'REF_ANNOTATION_LETTER'
ALTER TABLE &&tbl_owner..REF_ANNOTATION_LETTER
 ADD CONSTRAINT REF_ANNOTATION_LETTER_PK PRIMARY KEY 
  (ANNOTATION_LETTER_ID)
using index tablespace hdb_index
/

PROMPT Creating Primary Key on 'REF_WATERTYPE'
ALTER TABLE &&tbl_owner..REF_WATERTYPE
 ADD CONSTRAINT REF_WATERTYPE_PK PRIMARY KEY 
  (WATERTYPE_ID)
using index tablespace hdb_index
/

PROMPT Creating Primary Key on 'REF_DESTINATION'
ALTER TABLE &&tbl_owner..REF_DESTINATION
 ADD CONSTRAINT REF_DESTINATION_PK PRIMARY KEY 
  (DESTINATION_ID)
using index tablespace hdb_index
/

PROMPT Creating Primary Key on 'REF_ACCTTYPE'
ALTER TABLE &&tbl_owner..REF_ACCTTYPE
 ADD CONSTRAINT REF_ACCTTYPE_PK PRIMARY KEY 
  (ACCTTYPE_ID)
using index tablespace hdb_index
/

PROMPT Creating Primary Key on 'REF_ANNOTATIONTYPE'
ALTER TABLE &&tbl_owner..REF_ANNOTATIONTYPE
 ADD CONSTRAINT REF_ANNOTATIONTYPE_PK PRIMARY KEY 
  (ANNOTATIONTYPE_ID)
/

PROMPT Creating Primary Key on 'REF_ACCT'
ALTER TABLE &&tbl_owner..REF_ACCT
 ADD CONSTRAINT REF_ACCT_PK PRIMARY KEY 
  (SITE_ID
  ,CONFIG_ID)
using index tablespace hdb_index
/

PROMPT Creating Primary Key on 'REF_SUBBASIN_MEMBERS'
ALTER TABLE &&tbl_owner..REF_SUBBASIN_MEMBERS
 ADD CONSTRAINT REF_SUBBASIN_MEMBERS_PK PRIMARY KEY 
  (SITE_ID
  ,CONFIG_ID
  ,MEMBER_SITE_ID)
using index tablespace hdb_index
/

PROMPT Creating Primary Key on 'REF_LEASETYPE'
ALTER TABLE &&tbl_owner..REF_LEASETYPE
 ADD CONSTRAINT REF_LEASETYPE_PK PRIMARY KEY 
  (LEASETYPE_ID)
using index tablespace hdb_index
/

PROMPT Creating Primary Key on 'REF_BORROWTYPE'
ALTER TABLE &&tbl_owner..REF_BORROWTYPE
 ADD CONSTRAINT REF_BORROWTYPE_PK PRIMARY KEY 
  (BORROWTYPE_ID)
using index tablespace hdb_index
/

PROMPT Creating Primary Key on 'REF_SUPPLY'
ALTER TABLE &&tbl_owner..REF_SUPPLY
 ADD CONSTRAINT REF_SUPPLY_PK PRIMARY KEY 
  (SITE_ID
  ,CONFIG_ID)
using index tablespace hdb_index
/

PROMPT Creating Primary Key on 'REF_WATER_OWNER'
ALTER TABLE &&tbl_owner..REF_WATER_OWNER
 ADD CONSTRAINT REF_WATER_OWNER_PK PRIMARY KEY 
  (WATER_OWNER_ID)
using index tablespace hdb_index
/

PROMPT Creating Primary Key on 'REF_ANNOTATION_LEASE'
ALTER TABLE &&tbl_owner..REF_ANNOTATION_LEASE
 ADD CONSTRAINT REF_ANNOTATION_LEASE_PK PRIMARY KEY 
  (ANNOTATION_LEASE_ID)
using index tablespace hdb_index
/

PROMPT Creating Primary Key on 'REF_DMI_SITE_MAP'
ALTER TABLE &&tbl_owner..REF_DMI_SITE_MAP
 ADD CONSTRAINT REF_DMI_SITE_MAP_PK PRIMARY KEY 
  (MODEL_ID
  ,OBJECT_NAME
  ,EFFECTIVE_START_DATE_TIME
  ,EFFECTIVE_END_DATE_TIME
  ,OBJECTTYPE_ID)
using index tablespace hdb_index
/

PROMPT Creating Primary Key on 'REF_SUPPLY_ROLE'
ALTER TABLE &&tbl_owner..REF_SUPPLY_ROLE
 ADD CONSTRAINT REF_SUPPLY_ROLE_PK PRIMARY KEY 
  (SUPPLY_ROLE_ID)
using index tablespace hdb_index
/

PROMPT Creating Unique Keys on 'REF_ANNOTATION'
ALTER TABLE &&tbl_owner..REF_ANNOTATION 
 ADD ( CONSTRAINT REF_ANNOTATION_UK UNIQUE 
  (SUPPLY_ID
  ,RELEASE_START_DATE))
using index tablespace hdb_index
/
                        
PROMPT Creating Foreign Keys on 'REF_MODEL_SITE_CONFIG'
ALTER TABLE &&tbl_owner..REF_MODEL_SITE_CONFIG ADD CONSTRAINT
 REF_MODEL_SITE_CONFIG_FK2 FOREIGN KEY 
  (MODEL_ID) REFERENCES HDB_MODEL
  (MODEL_ID)
/

PROMPT Creating Foreign Keys on 'REF_EXCHANGE_PAYBACK'
ALTER TABLE &&tbl_owner..REF_EXCHANGE_PAYBACK ADD CONSTRAINT
 REF_EXCHANGE_PAYBACK_FK1 FOREIGN KEY 
  (EXCHANGE_SITE_ID
  ,EXCHANGE_CONFIG_ID) REFERENCES REF_EXCHANGE
  (SITE_ID
  ,CONFIG_ID) ADD CONSTRAINT
 REF_EXCHANGE_PAYBACK_FK2 FOREIGN KEY 
  (PAYBACK_SUPPLY_ID) REFERENCES REF_SUPPLY
  (SITE_ID)
/

PROMPT Creating Foreign Keys on 'REF_ANNOTATION'
ALTER TABLE &&tbl_owner..REF_ANNOTATION ADD CONSTRAINT
 REF_ANNOTATION_FK1 FOREIGN KEY 
  (SUPPLY_ID) REFERENCES REF_SUPPLY
  (SITE_ID) ADD CONSTRAINT
 REF_ANNOTATION_FK3 FOREIGN KEY 
  (RELATED_ANNOTATION_ID) REFERENCES REF_ANNOTATION
  (ANNOTATION_ID)
/

PROMPT Creating Foreign Keys on 'REF_EXCHANGE'
ALTER TABLE &&tbl_owner..REF_EXCHANGE ADD CONSTRAINT
 REF_EXCHANGE_FK1 FOREIGN KEY 
  (SITE_ID) REFERENCES HDB_SITE
  (SITE_ID) ADD CONSTRAINT
 REF_EXCHANGE_FK2 FOREIGN KEY 
  (BORROW_SUPPLY_ID) REFERENCES REF_SUPPLY
  (SITE_ID) ADD CONSTRAINT
 REF_EXCHANGE_FK3 FOREIGN KEY 
  (PAYBACK_DESTINATION_SUPPLY_ID) REFERENCES REF_SUPPLY
  (SITE_ID)
/

PROMPT Creating Foreign Keys on 'REF_ANNOTATION_BORROW'
ALTER TABLE &&tbl_owner..REF_ANNOTATION_BORROW ADD CONSTRAINT
 REF_ANNOTATION_BORROW_FK2 FOREIGN KEY 
  (BORROWTYPE_ID) REFERENCES REF_BORROWTYPE
  (BORROWTYPE_ID) ADD CONSTRAINT
 REF_ANNOTATION_BORROW_FK1 FOREIGN KEY 
  (BORROWED_FROM_WATER_OWNER_ID) REFERENCES REF_WATER_OWNER
  (WATER_OWNER_ID)
/

PROMPT Creating Foreign Keys on 'REF_ANNOTATION_LETTER'
ALTER TABLE &&tbl_owner..REF_ANNOTATION_LETTER ADD CONSTRAINT
 REF_ANNOTATION_LETTER_FK2 FOREIGN KEY 
  (RELEASED_TO_SITE_ID) REFERENCES HDB_SITE
  (SITE_ID) ADD CONSTRAINT
 REF_ANNOTATION_LETTER_FK1 FOREIGN KEY 
  (GIVEN_TO_WATER_OWNER_ID) REFERENCES REF_WATER_OWNER
  (WATER_OWNER_ID)
/

PROMPT Creating Foreign Keys on 'REF_ACCT'
ALTER TABLE &&tbl_owner..REF_ACCT ADD CONSTRAINT
 REF_ACCT_FK4 FOREIGN KEY 
  (WATERTYPE_ID) REFERENCES REF_WATERTYPE
  (WATERTYPE_ID) ADD CONSTRAINT
 REF_ACCT_FK1 FOREIGN KEY 
  (SITE_ID) REFERENCES HDB_SITE
  (SITE_ID) ADD CONSTRAINT
 REF_ACCT_FK2 FOREIGN KEY 
  (ACCTTYPE_ID) REFERENCES REF_ACCTTYPE
  (ACCTTYPE_ID) ADD CONSTRAINT
 REF_ACCT_FK3 FOREIGN KEY 
  (WATER_OWNER_ID) REFERENCES REF_WATER_OWNER
  (WATER_OWNER_ID)
/

PROMPT Creating Foreign Keys on 'REF_SUBBASIN_MEMBERS'
ALTER TABLE &&tbl_owner..REF_SUBBASIN_MEMBERS ADD CONSTRAINT
 REF_SUBBASIN_MEMBERS_FK1 FOREIGN KEY 
  (SITE_ID) REFERENCES HDB_SITE
  (SITE_ID) ADD CONSTRAINT
 REF_SUBBASIN_MEMBERS_FK2 FOREIGN KEY 
  (MEMBER_SITE_ID) REFERENCES HDB_SITE
  (SITE_ID)
/

PROMPT Creating Foreign Keys on 'HDB_SITE'
ALTER TABLE &&tbl_owner..HDB_SITE ADD CONSTRAINT
 HDB_SITE_FK3 FOREIGN KEY 
  (PARENT_OBJECTTYPE_ID) REFERENCES HDB_OBJECTTYPE
  (OBJECTTYPE_ID) ADD CONSTRAINT
 HDB_SITE_FK1 FOREIGN KEY 
  (OBJECTTYPE_ID) REFERENCES HDB_OBJECTTYPE
  (OBJECTTYPE_ID) ADD CONSTRAINT
 HDB_SITE_FK6 FOREIGN KEY 
  (BASIN_ID) REFERENCES HDB_SITE
  (SITE_ID) ADD CONSTRAINT
 HDB_SITE_FK2 FOREIGN KEY 
  (PARENT_SITE_ID) REFERENCES HDB_SITE
  (SITE_ID)
/

PROMPT Creating Foreign Keys on 'REF_SUPPLY'
ALTER TABLE &&tbl_owner..REF_SUPPLY ADD CONSTRAINT
 REF_SUPPLY_FK1 FOREIGN KEY 
  (SITE_ID) REFERENCES HDB_SITE
  (SITE_ID) ADD CONSTRAINT
 REF_SUPPLY_FK7 FOREIGN KEY 
  (DESTINATION_ID) REFERENCES REF_DESTINATION
  (DESTINATION_ID) ADD CONSTRAINT
 REF_SUPPLY_FK3 FOREIGN KEY 
  (DOWNSTREAM_ACCT_ID) REFERENCES REF_ACCT
  (SITE_ID) ADD CONSTRAINT
 REF_SUPPLY_FK2 FOREIGN KEY 
  (SOURCE_ACCT_ID) REFERENCES REF_ACCT
  (SITE_ID) ADD CONSTRAINT
 REF_SUPPLY_FK4 FOREIGN KEY 
  (SUPPLY_ROLE_ID) REFERENCES REF_SUPPLY_ROLE
  (SUPPLY_ROLE_ID) ADD CONSTRAINT
 REF_SUPPLY_FK5 FOREIGN KEY 
  (SUPPLYTYPE_ID) REFERENCES REF_SUPPLYTYPE
  (SUPPLYTYPE_ID) ADD CONSTRAINT
 REF_SUPPLY_FK6 FOREIGN KEY 
  (RELEASETYPE_ID) REFERENCES REF_RELEASETYPE
  (RELEASETYPE_ID)
/

PROMPT Creating Foreign Keys on 'REF_ANNOTATION_LEASE'
ALTER TABLE &&tbl_owner..REF_ANNOTATION_LEASE ADD CONSTRAINT
 REF_ANNOTATION_LEASE_FK2 FOREIGN KEY 
  (LEASETYPE_ID) REFERENCES REF_LEASETYPE
  (LEASETYPE_ID) ADD CONSTRAINT
 REF_ANNOTATION_LEASE_FK1 FOREIGN KEY 
  (PURCHASED_FROM_WATER_OWNER_ID) REFERENCES REF_WATER_OWNER
  (WATER_OWNER_ID)
/

PROMPT Creating Foreign Keys on 'REF_DMI_SITE_MAP'
ALTER TABLE &&tbl_owner..REF_DMI_SITE_MAP ADD CONSTRAINT
 REF_DMI_SITE_MAP_FK1 FOREIGN KEY 
  (MODEL_ID) REFERENCES HDB_MODEL
  (MODEL_ID) ADD CONSTRAINT
 REF_DMI_SITE_MAP_FK2 FOREIGN KEY 
  (OBJECTTYPE_ID) REFERENCES HDB_OBJECTTYPE
  (OBJECTTYPE_ID) ADD CONSTRAINT
 REF_DMI_SITE_MAP_FK3 FOREIGN KEY 
  (SITE_ID) REFERENCES HDB_SITE
  (SITE_ID)
/



spool off
exit

