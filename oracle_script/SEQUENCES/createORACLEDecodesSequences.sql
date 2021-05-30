-- $Id: createORACLEDecodesSequences.sql,v 1.2 2006/05/23 18:04:32 hdba Exp $
--
-- $Log: createORACLEDecodesSequences.sql,v $
-- Revision 1.2  2006/05/23 18:04:32  hdba
-- mods for decodes phase 0 re-development effort
--
-- Revision 1.1  2006/01/04 16:58:18  hdba
-- new files and documentation to add phase 0 to cvs
--
-- Revision 1.1  2003/11/17 14:55:56  mjmaloney
-- These are the sequences used in Postgres for generating new surrogate keys.
--
--

--
-- This file contains definitions for the SEQUENCES used to generate
-- surrogate keys. Do not execute this file if your database uses
-- some other mechanism to generate surrogate keys.
--

-- Used to assign IDs for new sites:
-- remove the siteid sequence since we will be using HDB site ids
--CREATE SEQUENCE SiteIdSeq NOCACHE;

-- Used to assign IDs to new EquipmentModel records:
CREATE SEQUENCE EquipmentIdSeq NOCACHE;

-- Used to assign IDs to new Enum records:
CREATE SEQUENCE EnumIdSeq start with 17 NOCACHE;

-- Used to assign IDs to new DataType records:
CREATE SEQUENCE DataTypeIdSeq start with 10500 NOCACHE;

-- Used to assign IDs to new Platform records:
CREATE SEQUENCE PlatformIdSeq NOCACHE;

-- Used to assign IDs to new PlatformConfig records:
CREATE SEQUENCE PlatformConfigIdSeq NOCACHE;

-- Used to assign IDs to new DecodesScript records:
CREATE SEQUENCE DecodesScriptIdSeq NOCACHE;

-- Used to assign IDs to new RoutingSpec records:
CREATE SEQUENCE RoutingSpecIdSeq NOCACHE;

-- Used to assign IDs to new DataSource records:
CREATE SEQUENCE DataSourceIdSeq NOCACHE;

-- Used to assign IDs to new Network List records:
CREATE SEQUENCE NetworkListIdSeq NOCACHE;

-- Used to assign IDs to new PresentationGroup records:
CREATE SEQUENCE PresentationGroupIdSeq NOCACHE;

-- Used to assign IDs to new DataPresentation records:
CREATE SEQUENCE DataPresentationIdSeq NOCACHE;

-- Used to assign IDs to new UnitConverter records:
CREATE SEQUENCE UnitConverterIdSeq start with 100 NOCACHE;

exit;

