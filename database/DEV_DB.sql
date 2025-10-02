USE [msdb]
GO
EXECUTE msdb.dbo.rds_drop_database N'DB_NAME'
GO
 
USE [master]
GO
 
CREATE DATABASE [DB_NAME]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'DB_NAME', FILENAME = N'D:\rdsdbdata\DATA\DB_NAME.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10%)
 LOG ON 
( NAME = N'DB_NAME_log', FILENAME = N'D:\rdsdbdata\DATA\DB_NAME_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DB_NAME].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

USE [DB_NAME]
GO

/* CREATE SCHEMA abx for Natural Framework and Natural Security Tables and Functions */
IF SCHEMA_ID(N'abx') IS NULL
  EXEC('CREATE SCHEMA [abx] AUTHORIZATION [dbo]')
GO

/* Security */
USE [DB_NAME]
GO

/* Users */

CREATE USER [NEWARK_HQ\devops_svc] FOR LOGIN [NEWARK_HQ\devops_svc] WITH DEFAULT_SCHEMA=[dbo]
GO

CREATE USER [NEWARK_HQ\mf_svc_dev] FOR LOGIN [NEWARK_HQ\mf_svc_dev] WITH DEFAULT_SCHEMA=[dbo]
GO

CREATE USER [NEWARK_HQ\DB_NAME_Developers] FOR LOGIN [NEWARK_HQ\DB_NAME_Developers]
GO

CREATE USER [NEWARK_HQ\MF-RDS-Developers] FOR LOGIN [NEWARK_HQ\MF-RDS-Developers]
GO

/* Roles */

CREATE ROLE [DB_NAMEAppRole]
GO

ALTER ROLE [db_owner] ADD MEMBER [NEWARK_HQ\DB_NAME_Developers]
GO

ALTER ROLE [db_owner] ADD MEMBER [NEWARK_HQ\devops_svc]
GO

ALTER ROLE [db_datawriter] ADD MEMBER [NEWARK_HQ\mf_svc_dev]
GO

ALTER ROLE [db_datawriter] ADD MEMBER [NEWARK_HQ\MF-RDS-Developers]
GO

ALTER ROLE [db_datareader] ADD MEMBER [NEWARK_HQ\mf_svc_dev]
GO

ALTER ROLE [db_datareader] ADD MEMBER [NEWARK_HQ\MF-RDS-Developers]
GO

ALTER ROLE [DB_NAMEAppRole] ADD MEMBER [NEWARK_HQ\mf_svc_dev]
GO