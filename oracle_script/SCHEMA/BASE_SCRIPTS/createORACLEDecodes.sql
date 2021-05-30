--
set echo on
spool decodes_schema.out

-----------------------------------------------------------------------
-- Single record DecodesDatabaseVersion table.
-- If this table doesn't exist, it means the database < 6.0
-- Some SQL code acts differently depending on the database version.
-----------------------------------------------------------------------
CREATE TABLE DECODESDatabaseVersion
(
	version INTEGER NOT NULL,
	options  VARCHAR(400)
) tablespace HDB_data;

-- commented out since the table load of standard data will handle this
--INSERT into DECODESDatabaseVersion VALUES(8, NULL) ;
--commit;

/*  remove from HDB creation due to existing hdb tables
-----------------------------------------------------------------------
-- Sites & Site Names
-----------------------------------------------------------------------

CREATE TABLE Site
(
	id INTEGER NOT NULL,
	latitude VARCHAR(24),
	longitude VARCHAR(24),
	nearestCity VARCHAR(64),
	state VARCHAR(24),
	region VARCHAR(64),
	timezone VARCHAR(64),
	country VARCHAR(64),
	elevation FLOAT,
	elevUnitAbbr VARCHAR(24),
	description VARCHAR(800)
) tablespace HDB_data;

-- Guarantees no two sites have the same ID:
CREATE UNIQUE INDEX Site_IdIdx on Site (id)  tablespace HDB_idx;

CREATE TABLE SiteName
(
	siteid INTEGER NOT NULL,
	nameType VARCHAR(24) NOT NULL,
	siteName VARCHAR(24) NOT NULL
) tablespace HDB_data;

-- Guarantees at most one site name of a given time per site.
CREATE UNIQUE INDEX SiteName_IdTypeIdx on SiteName (siteid, nameType)  tablespace HDB_idx;

end of removing comment  */

-----------------------------------------------------------------------
-- EquipmentModel & its properties.
-----------------------------------------------------------------------

-----------------------------------------------------------------------
-- Site Properties are new for DECODES DB Version 8
-----------------------------------------------------------------------
CREATE TABLE SITE_PROPERTY
(
    site_id INTEGER NOT NULL,
    prop_name VARCHAR2(24) NOT NULL,
    prop_value VARCHAR2(240) NOT NULL
) 
tablespace HDB_data;

-----------------------------------------------------------------------
-- Guarantees property names are unique within a Site
-----------------------------------------------------------------------
CREATE UNIQUE INDEX Site_Property_IdNameIdx
    on DECODES.SITE_PROPERTY (site_id, prop_name)  tablespace HDB_idx ; 
    
---------------------------------------------------------------------------
-- the privileges for table SITE_PROPERTY
-- everyone should be at least able to read it
---------------------------------------------------------------------------
create  or replace public synonym SITE_PROPERTY for DECODES.SITE_PROPERTY;
grant select on DECODES.SITE_PROPERTY to public;
grant select,insert,update,delete on DECODES.SITE_PROPERTY to calc_definition_role;
grant select,insert,update,delete on DECODES.SITE_PROPERTY to savoir_faire;


CREATE TABLE EquipmentModel
(
	id INTEGER NOT NULL,
	name VARCHAR(24) NOT NULL,
	company VARCHAR(64),
	model VARCHAR(64),
	description VARCHAR(400),
	equipmentType VARCHAR(24)
) tablespace HDB_data;

-- Guarantees no two EquipmentModels have the same ID:
CREATE UNIQUE INDEX EquipmentModel_IdIdx on EquipmentModel (id)  tablespace HDB_idx;

-- Guarantees no two EquipmentModels have the same name:
CREATE UNIQUE INDEX EquipmentModel_NmIdx on EquipmentModel (name)  tablespace HDB_idx;

CREATE TABLE EquipmentProperty
(
	equipmentId INTEGER NOT NULL,
	name VARCHAR(24) NOT NULL,
	value VARCHAR(240) NOT NULL
) tablespace HDB_data;

-- Guarantees property names are unique within an EquipmentModel:
CREATE UNIQUE INDEX EquipmentProperty_IdNameIdx 
	on EquipmentProperty (equipmentId, name)  tablespace HDB_idx;


-----------------------------------------------------------------------
-- Enumeration & its values
-----------------------------------------------------------------------

CREATE TABLE Enum
(
	id INTEGER NOT NULL,
	name VARCHAR(24) NOT NULL,
	defaultValue VARCHAR(24)
) tablespace HDB_data;

-- Guarantees no two Enums have the same ID:
CREATE UNIQUE INDEX EnumIdIdx on Enum(id)  tablespace HDB_idx;

CREATE TABLE EnumValue
(
	enumId INTEGER NOT NULL,
	enumValue VARCHAR(24) NOT NULL,
	description VARCHAR(400),
	execClass VARCHAR(160),
	editClass VARCHAR(160),
	sortNumber INTEGER
) tablespace HDB_data;

-- Guarantees each EnumValue is unique within an Enum.
CREATE UNIQUE INDEX EnumValueIdx on EnumValue(enumId, enumValue);

-----------------------------------------------------------------------
-- Data Types & Equivalences
-----------------------------------------------------------------------

CREATE TABLE DataType 
(
	id INTEGER NOT NULL,
	standard VARCHAR(24) NOT NULL,
	code VARCHAR(24) NOT NULL
) tablespace HDB_data;

-- Guarantees no two DataTypes have the same ID:
CREATE UNIQUE INDEX DataType_IdIdx on DataType (id)  tablespace HDB_idx;

-- Guarantees no two DataTypes have the same standard & code:
CREATE UNIQUE INDEX DataTypeCode_IdIdx on DataType (standard, code)  tablespace HDB_idx;


-- An entry in the DataTypeEquivalence table says that the two 
-- data types represent the same type of data, but in different standards.
-- For example EPA 00063 is equivalent to SHEF HG
CREATE TABLE DataTypeEquivalence
(
	id0 INTEGER NOT NULL,
	id1 INTEGER NOT NULL
) tablespace HDB_data;

-- Guarantees that each equivalence assertion is unique.
CREATE UNIQUE INDEX DataTypeEquivalence_Id1Idx 
	on DataTypeEquivalence (id0, id1)  tablespace HDB_idx;


-----------------------------------------------------------------------
-- Platforms & Platform Sensors
-----------------------------------------------------------------------

CREATE TABLE Platform
(
	id INTEGER NOT NULL,
	agency VARCHAR(64),
	isProduction VARCHAR(5) DEFAULT 'FALSE',
	siteId INTEGER,
	configId INTEGER,
	description VARCHAR(400),
	lastModifyTime TIMESTAMP WITH TIME ZONE,
	expiration TIMESTAMP WITH TIME ZONE,
        platformDesignator VARCHAR(24)
) tablespace HDB_data;

CREATE TABLE PlatformProperty
(
	platformId INTEGER NOT NULL,
	name VARCHAR(24) NOT NULL,
	value VARCHAR(240) NOT NULL
) tablespace HDB_data;

-- Guarantees no two Platforms have the same ID:
CREATE UNIQUE INDEX Platform_IdIdx on Platform (id)  tablespace HDB_idx;

CREATE TABLE PlatformSensor
(
	platformId INTEGER NOT NULL,
	sensorNumber INTEGER NOT NULL,
	siteId INTEGER,
        dd_nu INTEGER
) tablespace HDB_data;

CREATE TABLE PlatformSensorProperty
(
	platformId INTEGER NOT NULL,
	sensorNumber INTEGER NOT NULL,
	name VARCHAR(24) NOT NULL,
	value VARCHAR(240) NOT NULL
) tablespace HDB_data;

CREATE TABLE TransportMedium
(
	platformId INTEGER NOT NULL,
	mediumType VARCHAR(24) NOT NULL,
	mediumId VARCHAR(64),   -- Holds DCP address or other identifier
	scriptName VARCHAR(24), -- soft link to script in this platform's config.
	channelNum INTEGER,
	assignedTime INTEGER,
	transmitWindow INTEGER,
	transmitInterval INTEGER,
	equipmentId INTEGER,
	timeAdjustment INTEGER,
	preamble CHAR,
	timeZone VARCHAR(64)
) tablespace HDB_data;

-- Guarantees no two TransportMedia have same type and ID.
CREATE UNIQUE INDEX TransportMediumIdx on TransportMedium(mediumType,mediumId) tablespace HDB_idx;

-----------------------------------------------------------------------
-- Platform Configurations & Subordinate Entities
-----------------------------------------------------------------------

CREATE TABLE PlatformConfig
(
	id INTEGER NOT NULL,
	name VARCHAR(64) NOT NULL,
	description VARCHAR(400),
	equipmentId INTEGER
) tablespace HDB_data;

-- Guarantees no two PlatformConfigs have the same ID:
CREATE UNIQUE INDEX PlatformConfigIdIdx on PlatformConfig(id) tablespace HDB_idx;

-- Guarantees no two PlatformConfigs have the same name:
CREATE UNIQUE INDEX PlatformConfigNameIdx on PlatformConfig(name) tablespace HDB_idx;

CREATE TABLE ConfigSensor
(
	configId INTEGER NOT NULL,
	sensorNumber INTEGER NOT NULL,
	sensorName VARCHAR(64),
	recordingMode CHAR,
	recordingInterval INTEGER,     -- # seconds
	timeOfFirstSample INTEGER,     -- second of day
	equipmentId INTEGER,
	absoluteMin FLOAT,
	absoluteMax FLOAT,
        stat_cd VARCHAR(5)
) tablespace HDB_data;

-- This relation associates a data type with a sensor.
-- A sensor may have mulptiple data types, but only one for each standard.
CREATE TABLE ConfigSensorDataType
(
	configId INTEGER NOT NULL,
	sensorNumber INTEGER NOT NULL,
	dataTypeId INTEGER NOT NULL
) tablespace HDB_data;

CREATE TABLE ConfigSensorProperty
(
	configId INTEGER NOT NULL,
	sensorNumber INTEGER NOT NULL,
	name VARCHAR(24) NOT NULL,
	value VARCHAR(240) NOT NULL
) tablespace HDB_data;

-----------------------------------------------------------------------
-- Decoding Scripts & Subordinate Entities
-----------------------------------------------------------------------

CREATE TABLE DecodesScript
(
	id INTEGER NOT NULL,
	configId INTEGER NOT NULL,
	name VARCHAR(24) NOT NULL,
	type VARCHAR(24) NOT NULL,
	dataOrder CHAR         -- A=Ascending D=Descending
) tablespace HDB_data;

-- Guarantees no two DecodesScripts have the same ID:
CREATE UNIQUE INDEX DecodesScriptIdx on DecodesScript(id) tablespace HDB_idx;

-- Guarantees script names are unique within a PlatformConfig:
CREATE UNIQUE INDEX DecodesScriptNmIdx on DecodesScript(configId, name) tablespace HDB_idx;
 
CREATE TABLE FormatStatement
(
	decodesScriptId INTEGER NOT NULL,
	sequenceNum INTEGER NOT NULL,
	label VARCHAR(24) NOT NULL,
	format VARCHAR(400)
) tablespace HDB_data;

-- Guarantees each format statement has a unique sequence within a script:
CREATE UNIQUE INDEX FormatStatementIdx on 
	FormatStatement(decodesScriptId, sequenceNum) tablespace HDB_idx;

CREATE TABLE ScriptSensor
(
	decodesScriptId INTEGER NOT NULL,
	sensorNumber INTEGER NOT NULL,
	unitConverterId INTEGER
) tablespace HDB_data;

-- Guarantees each scriptsensor has unique number within a script:
CREATE UNIQUE INDEX ScriptSensorIdx on 
	ScriptSensor(decodesScriptId, sensorNumber);

-----------------------------------------------------------------------
-- Routing Specs 
-----------------------------------------------------------------------

CREATE TABLE RoutingSpec
(
	id INTEGER NOT NULL,
	name VARCHAR(64) NOT NULL,
	dataSourceId INTEGER,
	enableEquations VARCHAR(5) DEFAULT 'FALSE',
	usePerformanceMeasurements VARCHAR(5) DEFAULT 'FALSE',
	outputFormat VARCHAR(24),
	outputTimeZone VARCHAR(64),
	presentationGroupName VARCHAR(64),
	sinceTime VARCHAR(80),
	untilTime VARCHAR(80),
	consumerType VARCHAR(24),
	consumerArg VARCHAR(400),
	lastModifyTime TIMESTAMP WITH TIME ZONE,
	isProduction VARCHAR(5) DEFAULT 'FALSE'
) tablespace HDB_data;

-- Guarantees no two RoutingSpecs have the same ID:
CREATE UNIQUE INDEX RoutingSpecIdIdx on RoutingSpec(id) tablespace HDB_idx;

-- Guarantees no two RoutingSpecs have the same name:
CREATE UNIQUE INDEX RoutingSpecNmIdx on RoutingSpec(name) tablespace HDB_idx;

-- Associates a routing spec to a network list:
CREATE TABLE RoutingSpecNetworkList
(
	routingSpecId INTEGER NOT NULL,
	networkListName VARCHAR(64) NOT NULL
) tablespace HDB_data;

CREATE TABLE RoutingSpecProperty
(
	routingSpecId INTEGER NOT NULL,
	name VARCHAR(24) NOT NULL,
	value VARCHAR(240) NOT NULL
) tablespace HDB_data;


-----------------------------------------------------------------------
-- Data Sources
-----------------------------------------------------------------------

CREATE TABLE DataSource
(
	id INTEGER NOT NULL,
	name VARCHAR(64) NOT NULL,
	dataSourceType VARCHAR(24) NOT NULL,
	dataSourceArg VARCHAR(400)
) tablespace HDB_data;

-- Guarantees no two DataSources have the same ID:
CREATE UNIQUE INDEX DataSource_IdIdx on DataSource(id)  tablespace HDB_idx;

-- Guarantees no two DataSources have the same name:
CREATE UNIQUE INDEX DataSource_NmIdx on DataSource(name)  tablespace HDB_idx;

CREATE TABLE DataSourceGroupMember
(
	groupId INTEGER NOT NULL,
	sequenceNum INTEGER NOT NULL,
	memberId INTEGER NOT NULL
) tablespace HDB_data;

-----------------------------------------------------------------------
-- Network Lists
-----------------------------------------------------------------------

CREATE TABLE NetworkList
(
	id INTEGER NOT NULL,
	name VARCHAR(64) NOT NULL,
	transportMediumType VARCHAR(24),
	siteNameTypePreference VARCHAR(24),
	lastModifyTime TIMESTAMP WITH TIME ZONE NOT NULL
) tablespace HDB_data;

-- Guarantees no two NetworkLists have the same ID:
CREATE UNIQUE INDEX NetworkList_IdIdx on NetworkList(id)  tablespace HDB_idx;

-- Guarantees no two NetworkLists have the same name:
CREATE UNIQUE INDEX NetworkList_NmIdx on NetworkList(name)  tablespace HDB_idx;

CREATE TABLE NetworkListEntry
(
	networkListId INTEGER NOT NULL,
	transportId VARCHAR(64) NOT NULL
) tablespace HDB_data;


-----------------------------------------------------------------------
-- Presentation Groups
-----------------------------------------------------------------------

CREATE TABLE PresentationGroup
(
	id INTEGER NOT NULL,
	name VARCHAR(64) NOT NULL,
	inheritsFrom INTEGER,
	lastModifyTime TIMESTAMP WITH TIME ZONE,
	isProduction VARCHAR(5) DEFAULT 'false'
) tablespace HDB_data;

-- Guarantees no two PresentationGroups have the same ID:
CREATE UNIQUE INDEX PresGrp_IdIdx on PresentationGroup(id) tablespace HDB_idx;

-- Guarantees no two PresentationGroups have the same name:
CREATE UNIQUE INDEX PresGrp_NmIdx on PresentationGroup(name) tablespace HDB_idx;

CREATE TABLE DataPresentation
(
	id INTEGER NOT NULL,
	groupId INTEGER NOT NULL,
	dataTypeId INTEGER,
	unitAbbr VARCHAR(24),
	equipmentId INTEGER,
	maxDecimals INTEGER
) tablespace HDB_data;

CREATE TABLE RoundingRule
(
	dataPresentationId INTEGER NOT NULL,
	upperLimit FLOAT,
	sigDigits INTEGER NOT NULL
) tablespace HDB_data;

-----------------------------------------------------------------------
-- Engineering Units and Conversions
-----------------------------------------------------------------------
/*  remove due to HDB equivalency table

CREATE TABLE EngineeringUnit
(
	unitAbbr VARCHAR(24) NOT NULL,
	name VARCHAR(64) NOT NULL,
	family VARCHAR(24),
	measures VARCHAR(24)
) tablespace HDB_data;

-- Guarantees no two EngineeringUnits have the same abbreviation:
CREATE UNIQUE INDEX EUAbbrIdx on EngineeringUnit(unitAbbr) tablespace HDB_idx;

  end of remove comment   */


CREATE TABLE UnitConverter
(
	id INTEGER NOT NULL,
	fromUnitsAbbr VARCHAR(24),
	toUnitsAbbr VARCHAR(24),
	algorithm VARCHAR(24),
	-- Meaning of coeffients depends on the algorithm:
	a FLOAT,
	b FLOAT,
	c FLOAT,
	d FLOAT,
	e FLOAT,
	f FLOAT
) tablespace HDB_data;

-- Guarantees no two UnitConverters have the same ID:
CREATE UNIQUE INDEX UnitConverterIdIdx on UnitConverter(id) tablespace HDB_idx;

-- Note: We DON'T put a unique index on from/to abbreviations because
-- Raw converters all have "raw" as the from abbreviation. Many
-- different raw converters may have the same from/to values.




--------------------------------------------------------------------------
-- This script updates DECODES tables from an USBR HDB 5.2 CCP Schema to 
-- OpenDCS 6.2 Schema.
--
--------------------------------------------------------------------------

ALTER TABLE ENUM ADD DESCRIPTION VARCHAR2(400);

ALTER TABLE DATATYPE ADD DISPLAY_NAME VARCHAR2(64);

CREATE TABLE SCHEDULE_ENTRY
(
    SCHEDULE_ENTRY_ID NUMBER(*,0) NOT NULL,
    -- Unique name for this schedule entry.
    NAME VARCHAR2(64) NOT NULL,
    LOADING_APPLICATION_ID NUMBER(*,0),
    ROUTINGSPEC_ID INTEGER NOT NULL,
    -- date/time for first execution.
    -- Null means start immediately.
    START_TIME date,
    -- Used to interpret interval adding to start time.
    TIMEZONE VARCHAR2(32),
    -- Any valid interval in this database.
    -- Null means execute one time only.
    RUN_INTERVAL VARCHAR2(64),
    -- true or false
    ENABLED VARCHAR2(5) NOT NULL,
    LAST_MODIFIED date NOT NULL,
    PRIMARY KEY (SCHEDULE_ENTRY_ID),
    CONSTRAINT SENAME_UNIQUE UNIQUE(NAME)
) tablespace HDB_DATA;

-- Describes a schedule run.
CREATE TABLE SCHEDULE_ENTRY_STATUS
(
    SCHEDULE_ENTRY_STATUS_ID NUMBER(*,0) NOT NULL,
    SCHEDULE_ENTRY_ID NUMBER(*,0) NOT NULL,
    RUN_START_TIME date NOT NULL,
    -- Null means no messages yet received
    LAST_MESSAGE_TIME date,
    -- Null means still running.
    RUN_COMPLETE_TIME date,
    -- Hostname or IP Address of server where the routing spec was run.
    HOSTNAME VARCHAR2(64) NOT NULL,
    -- Brief string describing current status: "initializing", "running", "complete", "failed".
    RUN_STATUS VARCHAR2(24) NOT NULL,
    -- Number of messages successfully processed during the run.
    NUM_MESSAGES INT DEFAULT 0 NOT NULL,
    -- Number of decoding errors encountered.
    NUM_DECODE_ERRORS INT DEFAULT 0 NOT NULL,
    -- Number of distinct platforms seen
    NUM_PLATFORMS INT DEFAULT 0 NOT NULL,
    LAST_SOURCE VARCHAR2(32),
    LAST_CONSUMER VARCHAR2(32),
    -- Last time this entry was written to the database.
    LAST_MODIFIED date NOT NULL,
    PRIMARY KEY (SCHEDULE_ENTRY_STATUS_ID),
    CONSTRAINT sched_entry_start_unique UNIQUE (SCHEDULE_ENTRY_ID, RUN_START_TIME)
) tablespace HDB_DATA;


ALTER TABLE SCHEDULE_ENTRY
    ADD CONSTRAINT SCHEDULE_ENTRY_FKLA
    FOREIGN KEY (LOADING_APPLICATION_ID)
    REFERENCES HDB_LOADING_APPLICATION (LOADING_APPLICATION_ID)
;


ALTER TABLE ROUTINGSPEC ADD CONSTRAINT ROUTINGSPEC_PK PRIMARY KEY (ID);
ALTER TABLE SCHEDULE_ENTRY
    ADD CONSTRAINT SCHEDULE_ENTRY_FKRS
    FOREIGN KEY (ROUTINGSPEC_ID)
    REFERENCES ROUTINGSPEC (ID)
;

ALTER TABLE SCHEDULE_ENTRY_STATUS
    ADD CONSTRAINT SCHEDULE_ENTRY_STATUS_FKSE
    FOREIGN KEY (SCHEDULE_ENTRY_ID)
    REFERENCES SCHEDULE_ENTRY (SCHEDULE_ENTRY_ID)
;

CREATE TABLE DACQ_EVENT
(
    -- Surrogate Key. Events are numbered from 0...MAX
    DACQ_EVENT_ID NUMBER(*,0) NOT NULL,
    SCHEDULE_ENTRY_STATUS_ID NUMBER(*,0),
    PLATFORM_ID NUMBER(*,0),
    EVENT_TIME date NOT NULL,
    -- INFO = 3, WARNING = 4, FAILURE = 5, FATAL = 6
    --
    EVENT_PRIORITY INT NOT NULL,
    -- Software subsystem that generated this event
    SUBSYSTEM VARCHAR2(24),
    -- If this is related to a message, this holds the message's local_recv_time.
    MSG_RECV_TIME DATE,
    EVENT_TEXT VARCHAR2(256) NOT NULL,
    PRIMARY KEY (DACQ_EVENT_ID)
) tablespace HDB_DATA;

ALTER TABLE DACQ_EVENT
    ADD CONSTRAINT DACQ_EVENT_FKSE
    FOREIGN KEY (SCHEDULE_ENTRY_STATUS_ID)
    REFERENCES SCHEDULE_ENTRY_STATUS (SCHEDULE_ENTRY_STATUS_ID)
;
CREATE INDEX DQE_PLATFORM_ID_IDX ON DACQ_EVENT (PLATFORM_ID) tablespace HDB_IDX;

CREATE TABLE PLATFORM_STATUS
(
    PLATFORM_ID NUMBER(*,0) NOT NULL,
    -- Time of last station contact, whether or not a message was successfully received.
    LAST_CONTACT_TIME date,
    -- Time stamp of last message received. This is the message time stamp parsed from the header.
    -- Null means no message ever received.
    LAST_MESSAGE_TIME date,
    -- Up to 8 failure codes describing data acquisition and decoding.
    LAST_FAILURE_CODES VARCHAR2(8),
    -- Null means no errors encountered ever.
    LAST_ERROR_TIME date,
    -- Points to status of last routing spec / schedule entry run.
    -- Null means that the schedule entry is too old and has been purged.
    LAST_SCHEDULE_ENTRY_STATUS_ID NUMBER(*,0),
    ANNOTATION VARCHAR2(400),
    PRIMARY KEY (PLATFORM_ID)
) tablespace HDB_DATA;

ALTER TABLE PLATFORM_STATUS
    ADD CONSTRAINT PLATFORM_STATUS_FKSE
    FOREIGN KEY (LAST_SCHEDULE_ENTRY_STATUS_ID)
    REFERENCES SCHEDULE_ENTRY_STATUS (SCHEDULE_ENTRY_STATUS_ID)
;


ALTER TABLE NETWORKLISTENTRY ADD PLATFORM_NAME VARCHAR2(64);
ALTER TABLE NETWORKLISTENTRY ADD DESCRIPTION VARCHAR2(80);

ALTER TABLE TRANSPORTMEDIUM ADD LOGGERTYPE VARCHAR2(24);
ALTER TABLE TRANSPORTMEDIUM ADD BAUD INT;
ALTER TABLE TRANSPORTMEDIUM ADD STOPBITS INT;
ALTER TABLE TRANSPORTMEDIUM ADD PARITY VARCHAR2(1);
ALTER TABLE TRANSPORTMEDIUM ADD DATABITS INT;
ALTER TABLE TRANSPORTMEDIUM ADD DOLOGIN VARCHAR2(5);
ALTER TABLE TRANSPORTMEDIUM ADD USERNAME VARCHAR2(32);
ALTER TABLE TRANSPORTMEDIUM ADD PASSWORD VARCHAR2(32);


----------------------------------------------------------------

CREATE TABLE SERIAL_PORT_STATUS
(
    -- Combo of DigiHostName:PortNumber
    PORT_NAME VARCHAR2(48) NOT NULL,
    -- True when port is locked.
    IN_USE VARCHAR2(5) DEFAULT 'FALSE' NOT NULL,
    -- Name of routing spec (or other process) that last used (or is currently using) the port.
    -- Null means never been used.
    LAST_USED_BY_PROC VARCHAR2(64),
    -- Hostname or IP Address from which this port was last used (or is currently being used).
    -- Null means never been used.
    LAST_USED_BY_HOST VARCHAR2(64),
    -- Java msec Date/Time this port was last used.
    LAST_ACTIVITY_TIME DATE,
    -- Java msec Date/Time that a message was successfully received on this port.
    LAST_RECEIVE_TIME DATE,
    -- The Medium ID (e.g. logger name) from which a message was last received on this port.
    LAST_MEDIUM_ID VARCHAR2(64),
    -- Java msec Date/Time of the last time an error occurred on this port.
    LAST_ERROR_TIME DATE,
    -- Short string. Usually one of the following:
    -- idle, dialing, login, receiving, goodbye, error
    PORT_STATUS VARCHAR2(32),
    PRIMARY KEY (PORT_NAME)
) tablespace HDB_DATA;

ALTER TABLE DATATYPE MODIFY(CODE VARCHAR2(65 BYTE));

ALTER TABLE DECODESDATABASEVERSION RENAME COLUMN VERSION TO VERSION_NUM;
ALTER TABLE DECODESDATABASEVERSION RENAME COLUMN options TO DB_OPTIONS;
ALTER TABLE EQUIPMENTPROPERTY RENAME COLUMN VALUE TO PROP_VALUE;

UPDATE NETWORKLIST SET TRANSPORTMEDIUMTYPE = 'goes' WHERE TRANSPORTMEDIUMTYPE IS NULL;
ALTER TABLE NETWORKLIST MODIFY(TRANSPORTMEDIUMTYPE  NOT NULL);
UPDATE NETWORKLIST SET SITENAMETYPEPREFERENCE = 'hdb' WHERE SITENAMETYPEPREFERENCE IS NULL;
ALTER TABLE NETWORKLIST MODIFY(SITENAMETYPEPREFERENCE  NOT NULL);

ALTER TABLE PRESENTATIONGROUP MODIFY(LASTMODIFYTIME NOT NULL);
UPDATE PRESENTATIONGROUP SET ISPRODUCTION = 'FALSE' WHERE ISPRODUCTION IS NULL;
ALTER TABLE PRESENTATIONGROUP MODIFY(ISPRODUCTION  NOT NULL);
ALTER TABLE PRESENTATIONGROUP MODIFY(ISPRODUCTION  DEFAULT 'FALSE');

UPDATE ROUTINGSPEC SET ENABLEEQUATIONS = 'FALSE' WHERE ENABLEEQUATIONS IS NULL;
ALTER TABLE ROUTINGSPEC MODIFY(ENABLEEQUATIONS  NOT NULL);

UPDATE ROUTINGSPEC SET USEPERFORMANCEMEASUREMENTS = 'FALSE' 
  WHERE USEPERFORMANCEMEASUREMENTS IS NULL;
ALTER TABLE ROUTINGSPEC MODIFY(USEPERFORMANCEMEASUREMENTS  NOT NULL);
UPDATE ROUTINGSPEC SET ISPRODUCTION = 'FALSE' WHERE ISPRODUCTION IS NULL;
ALTER TABLE ROUTINGSPEC MODIFY(ISPRODUCTION NOT NULL);

ALTER TABLE ROUTINGSPECPROPERTY RENAME COLUMN NAME TO PROP_NAME;
ALTER TABLE ROUTINGSPECPROPERTY RENAME COLUMN VALUE TO PROP_VALUE;

CREATE UNIQUE INDEX DS_GROUP_SEQ_UNIQUE ON DATASOURCEGROUPMEMBER
(GROUPID, SEQUENCENUM) tablespace HDB_IDX;

CREATE UNIQUE INDEX NL_TRANSPORT_UNIQUE ON NETWORKLISTENTRY
(NETWORKLISTID, TRANSPORTID) tablespace HDB_IDX;

UPDATE CONFIGSENSOR SET SENSORNAME = 'X' WHERE SENSORNAME IS NULL;
ALTER TABLE CONFIGSENSOR MODIFY(SENSORNAME  NOT NULL);
UPDATE CONFIGSENSOR SET RECORDINGMODE = 'U' WHERE RECORDINGMODE IS NULL;
ALTER TABLE CONFIGSENSOR MODIFY(RECORDINGMODE  NOT NULL);

ALTER TABLE CONFIGSENSORPROPERTY RENAME COLUMN NAME TO PROP_NAME;
ALTER TABLE CONFIGSENSORPROPERTY RENAME COLUMN VALUE TO PROP_VALUE;

ALTER TABLE DATAPRESENTATION ADD (MAX_VALUE  FLOAT(126));
ALTER TABLE DATAPRESENTATION ADD (MIN_VALUE  FLOAT(126));
CREATE UNIQUE INDEX PRES_DT_UNIQUE ON DATAPRESENTATION (GROUPID, DATATYPEID) tablespace HDB_IDX;

ALTER TABLE DECODESSCRIPT RENAME COLUMN TYPE TO SCRIPT_TYPE;
UPDATE DECODESSCRIPT SET DATAORDER = 'A' WHERE DATAORDER IS NULL;
ALTER TABLE DECODESSCRIPT MODIFY(DATAORDER NOT NULL);
ALTER TABLE DECODESSCRIPT MODIFY(DATAORDER DEFAULT 'A');

UPDATE PLATFORM SET ISPRODUCTION = 'FALSE' WHERE ISPRODUCTION IS NULL;
ALTER TABLE PLATFORM MODIFY(ISPRODUCTION NOT NULL);

ALTER TABLE PLATFORMPROPERTY RENAME COLUMN NAME TO PROP_NAME;
ALTER TABLE PLATFORMPROPERTY RENAME COLUMN VALUE TO PROP_VALUE;

ALTER TABLE PLATFORMSENSORPROPERTY RENAME COLUMN NAME TO PROP_NAME;
ALTER TABLE PLATFORMSENSORPROPERTY RENAME COLUMN VALUE TO PROP_VALUE;

ALTER TABLE DATASOURCEGROUPMEMBER ADD PRIMARY KEY (GROUPID, MEMBERID);

ALTER TABLE DATASOURCEGROUPMEMBER ADD CONSTRAINT GROUP_SEQ_UNIQUE
  UNIQUE (GROUPID, SEQUENCENUM)
  USING INDEX tablespace HDB_IDX;
  
ALTER TABLE ENUM
 ADD CONSTRAINT ENNAME_UNIQUE
  UNIQUE (NAME)
  USING INDEX tablespace HDB_IDX;

ALTER TABLE ROUTINGSPECNETWORKLIST
 ADD PRIMARY KEY (ROUTINGSPECID, NETWORKLISTNAME);

ALTER TABLE ROUTINGSPECPROPERTY
 ADD PRIMARY KEY (ROUTINGSPECID, PROP_NAME);

ALTER TABLE CONFIGSENSOR
 ADD PRIMARY KEY (CONFIGID, SENSORNUMBER);

ALTER TABLE CONFIGSENSORPROPERTY
 ADD PRIMARY KEY (CONFIGID, SENSORNUMBER, PROP_NAME);

ALTER TABLE DATAPRESENTATION ADD CONSTRAINT PRES_DT_UNIQUE
  UNIQUE (GROUPID, DATATYPEID) USING INDEX tablespace HDB_IDX;

-- MJM the following doesn't work because there are platforms with same site/desig
-- but with different expiration. Furthermore, Oracle doesn't allow a timestamp with
-- timezone to be part of a unique key, so I can't simply add EXPIRATION to the
-- column list.
--ALTER TABLE PLATFORM
-- ADD CONSTRAINT SITE_DESIGNATOR_UNIQUE
--  UNIQUE (SITEID, PLATFORMDESIGNATOR)
--  USING INDEX tablespace HDB_IDX;
  
ALTER TABLE PLATFORMPROPERTY ADD PRIMARY KEY (PLATFORMID, PROP_NAME);
  
ALTER TABLE PLATFORMSENSOR ADD PRIMARY KEY (PLATFORMID, SENSORNUMBER);

ALTER TABLE PLATFORMSENSORPROPERTY ADD PRIMARY KEY (PLATFORMID, SENSORNUMBER, PROP_NAME);

ALTER TABLE TRANSPORTMEDIUM ADD PRIMARY KEY (PLATFORMID, MEDIUMTYPE);

ALTER TABLE PLATFORMSENSORPROPERTY
 ADD CONSTRAINT PLATFORMSENSORPROPERTY_FKPS
  FOREIGN KEY (PLATFORMID, SENSORNUMBER)
  REFERENCES PLATFORMSENSOR (PLATFORMID,SENSORNUMBER);
  
update unitconverter set A = 6894.74729 where lower(fromunitsabbr) = 'psi' and lower(tounitsabbr) = 'pa';

-----------------------------------------------------------------
-- two new sequences for the high volume ccp/decodes tables so they don't use CWMS_SEQ:
-----------------------------------------------------------------
CREATE SEQUENCE DACQ_EVENTIDSEQ MINVALUE 1 START WITH 1 MAXVALUE 2000000000 NOCACHE CYCLE;
CREATE SEQUENCE SCHEDULE_ENTRY_STATUSIDSEQ MINVALUE 1 START WITH 1 MAXVALUE 2000000000 NOCACHE CYCLE;
CREATE SEQUENCE SCHEDULE_ENTRYIDSEQ MINVALUE 1 START WITH 1 MAXVALUE 2000000000 NOCACHE CYCLE;

-----------------------------------------------------------------
-- permissions for the new stuff.
-----------------------------------------------------------------
GRANT SELECT,INSERT,UPDATE,DELETE ON SCHEDULE_ENTRY TO DECODES_ROLE, CALC_DEFINITION_ROLE;
GRANT SELECT,INSERT,UPDATE,DELETE ON SCHEDULE_ENTRY_STATUS TO DECODES_ROLE, CALC_DEFINITION_ROLE;
GRANT SELECT,INSERT,UPDATE,DELETE ON DACQ_EVENT TO DECODES_ROLE, CALC_DEFINITION_ROLE;
GRANT SELECT,INSERT,UPDATE,DELETE ON PLATFORM_STATUS TO DECODES_ROLE, CALC_DEFINITION_ROLE;

GRANT SELECT ON DACQ_EVENTIDSEQ TO DECODES_ROLE;
GRANT SELECT ON SCHEDULE_ENTRY_STATUSIDSEQ TO DECODES_ROLE;
GRANT SELECT ON SCHEDULE_ENTRYIDSEQ TO DECODES_ROLE;

-----------------------------------------------------------------
-- public synonyms for the new stuff
-----------------------------------------------------------------
CREATE PUBLIC SYNONYM DACQ_EVENT FOR  DACQ_EVENT;
CREATE PUBLIC SYNONYM SCHEDULE_ENTRY FOR  SCHEDULE_ENTRY;
CREATE PUBLIC SYNONYM SCHEDULE_ENTRY_STATUS FOR  SCHEDULE_ENTRY_STATUS;
CREATE PUBLIC SYNONYM PLATFORM_STATUS FOR  PLATFORM_STATUS;
CREATE PUBLIC SYNONYM SERIAL_PORT_STATUS FOR  SERIAL_PORT_STATUS;

CREATE PUBLIC SYNONYM DACQ_EVENTIDSEQ FOR  DACQ_EVENTIDSEQ;
CREATE PUBLIC SYNONYM SCHEDULE_ENTRY_STATUSIDSEQ FOR  SCHEDULE_ENTRY_STATUSIDSEQ;
CREATE PUBLIC SYNONYM SCHEDULE_ENTRYIDSEQ FOR  SCHEDULE_ENTRYIDSEQ;

-----------------------------------------------------------------
-- Finally, update the database version numbers in the database
-----------------------------------------------------------------
delete from DecodesDatabaseVersion;
insert into DecodesDatabaseVersion values(13, 'Updated to OpenDCS 6.2 RC06');
delete from tsdb_database_version;
insert into tsdb_database_version values(13, 'Updated to OpenDCS 6.2 RC06');

commit;


--------------------------------------------------------------------------
-- This script updates DECODES tables from an USBR HDB 6.3 CCP Schema to 
-- OpenDCS 6.4 Schema.
--------------------------------------------------------------------------

DELETE FROM DACQ_EVENT;

ALTER TABLE DACQ_EVENT ADD LOADING_APPLICATION_ID NUMBER(*,0);

ALTER TABLE DACQ_EVENT ADD CONSTRAINT DACQ_EVENT_FKLA
    FOREIGN KEY (LOADING_APPLICATION_ID) REFERENCES
    HDB_LOADING_APPLICATION(LOADING_APPLICATION_ID);

DROP SEQUENCE DACQ_EVENTIDSEQ;
CREATE SEQUENCE DACQ_EVENTIDSEQ MINVALUE 1 START WITH 1 NOCACHE;

-----------------------------------------------------------------
-- Finally, update the database version numbers in the database
-----------------------------------------------------------------
delete from DecodesDatabaseVersion;
insert into DecodesDatabaseVersion values(15, 'Updated to OpenDCS 6.4');
delete from tsdb_database_version;
insert into tsdb_database_version values(15, 'Updated to OpenDCS 6.4');

commit;


spool off

exit;
