﻿/*
Deployment script for DB_MDA_CR_OA

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "DB_MDA_CR_OA"
:setvar DefaultFilePrefix "DB_MDA_CR_OA"
:setvar DefaultDataPath ""
:setvar DefaultLogPath ""

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
PRINT N'Altering [adm].[uspReadUsers]...';


GO
-- ======================================================================
-- Name: [adm].[uspReadUsers]
-- Desc: Muestra la informacion de todos los usuarios existentes
-- Auth: Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date: 5/23/2019
-------------------------------------------------------------
-- Change History
-------------------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		-----------------------------
-- ======================================================================

ALTER PROCEDURE [adm].[uspReadUsers]
	@AppID INT = NULL
AS 
    BEGIN
        SET NOCOUNT ON
        BEGIN TRY
            DECLARE @lErrorMessage NVARCHAR(4000)
            DECLARE @lErrorSeverity INT
            DECLARE @lErrorState INT

            -- =======================================================
				IF(@AppID IS NULL)
					BEGIN
						SELECT	U.[UserID]
								,U.[FullName]
								,U.[UserName]
								,U.[Email]
								,U.[InternalUser]
								,U.[ActiveFlag]
								,U.[AuthorizationFlag]
								,[RoleID]		=	MR.[RoleID]
								,[MainAreaID]	=	MR.[ApplicationID]
								,[MainArea]		=	MR.[MainAppName]
						FROM	[adm].[utbUsers] U
								OUTER APPLY (SELECT TOP 1 RU.[RoleID], R.[RoleName], R.[ApplicationID], AD.[MainAppName]
											 FROM	[adm].[utbRolesbyUser] RU
													INNER JOIN [adm].[utbRoles] R ON R.[RoleID] = RU.[RoleID] AND R.[ActiveFlag] = 1							
													INNER JOIN [adm].[utbAppDirectory] AD ON AD.[ApplicationID] = R.[ApplicationID] AND AD.[ActiveFlag] = 1
											 WHERE	RU.[UserID] = U.[UserID]
													AND RU.[ActiveFlag] = 1
											 ORDER BY R.[ApplicationID],R.[RoleID]) MR
					END
				ELSE
					BEGIN
						IF(@AppID = 1) /*Ministry Area*/
							BEGIN
								DECLARE	@RoleID INT

								SELECT	@RoleID = [RoleID]
								FROM	[adm].[utbRoles]
								WHERE	[ApplicationID] = 1
										AND [RoleName] = 'Usuario'

								SELECT	U.[UserID]
										,U.[FullName]
										,U.[UserName]
										,U.[Email]
										,U.[InternalUser]
										,U.[ActiveFlag]
										,U.[AuthorizationFlag]
										,[RoleID]		=	ISNULL(MR.[RoleID],@RoleID)
										,[MainAreaID]	=	AD.[ApplicationID]
										,[MainArea]		=	AD.[MainAppName]
								FROM	[adm].[utbUsers] U
										OUTER APPLY (SELECT RU.[RoleID], R.[RoleName], R.[ApplicationID]
													 FROM	[adm].[utbRolesbyUser] RU
															INNER JOIN [adm].[utbRoles] R ON R.[RoleID] = RU.[RoleID] AND R.[ApplicationID] = @AppID
													 WHERE	RU.[UserID] = U.[UserID]) MR
										OUTER APPLY (SELECT TOP 1 RU.[RoleID], R.[RoleName], R.[ApplicationID]
													 FROM	[adm].[utbRolesbyUser] RU
															INNER JOIN [adm].[utbRoles] R ON R.[RoleID] = RU.[RoleID] AND R.[ApplicationID] != @AppID
													 WHERE	RU.[UserID] = U.[UserID]
													 ORDER BY RU.[CreationDate]) OTR
										LEFT JOIN [adm].[utbAppDirectory] AD ON AD.[ApplicationID] = ISNULL(OTR.[ApplicationID],@AppID)
							END
						ELSE
							BEGIN
								SELECT	U.[UserID]
										,U.[FullName]
										,U.[UserName]
										,U.[Email]
										,U.[InternalUser]
										,U.[ActiveFlag]
										,U.[AuthorizationFlag]
										,RU.RoleID
										,[MainAreaID]	=	AD.[ApplicationID]
										,[MainArea]		=	AD.[MainAppName]
								FROM	[adm].[utbUsers] U
										INNER JOIN [adm].[utbRolesbyUser] RU ON RU.[UserID] = U.[UserID]
										INNER JOIN [adm].[utbRoles] R ON R.[RoleID] = RU.[RoleID] AND R.[ApplicationID] = @AppID
										LEFT JOIN [adm].[utbAppDirectory] AD ON AD.[ApplicationID] = @AppID
							END
					END
			-- =======================================================

        END TRY
        BEGIN CATCH

            SELECT  @lErrorMessage = ERROR_MESSAGE() ,
                    @lErrorSeverity = ERROR_SEVERITY() ,
                    @lErrorState = ERROR_STATE()       

            RAISERROR (@lErrorMessage, @lErrorSeverity, @lErrorState);
        END CATCH
    END
    SET NOCOUNT OFF
GO
PRINT N'Update complete.';


GO