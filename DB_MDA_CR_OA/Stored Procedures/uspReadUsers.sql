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

CREATE PROCEDURE [adm].[uspReadUsers]
	@AppID INT
AS 
    BEGIN
        SET NOCOUNT ON
        BEGIN TRY
            DECLARE @lErrorMessage NVARCHAR(4000)
            DECLARE @lErrorSeverity INT
            DECLARE @lErrorState INT

            -- =======================================================
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
