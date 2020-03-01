
-- ======================================================================
-- Name: [adm].[uspSearchUser]
-- Desc: Permite mostrar la informacion de un usuario en especifico
-- Auth: Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date: 05/24/2019
-------------------------------------------------------------
-- Change History
-------------------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		-----------------------------
-- ======================================================================

CREATE PROCEDURE [adm].[uspSearchUser]
		@UserID INT,
		@AppID	INT
AS 
    BEGIN
        SET NOCOUNT ON
        BEGIN TRY
            DECLARE @lErrorMessage NVARCHAR(4000)
            DECLARE @lErrorSeverity INT
            DECLARE @lErrorState INT

            -- =======================================================
				SELECT	U.[UserID]
						,U.[FullName]
						,U.[UserName]
						,U.[Email]
						,RU.[RoleID]
						,U.[ActiveFlag]
						,U.[AuthorizationFlag]  
				FROM	[adm].[utbUsers] U
						LEFT JOIN [adm].[utbRolesbyUser] RU ON RU.[UserID] = U.[UserID] AND RU.[ActiveFlag] = 1
						INNER JOIN [adm].[utbRoles] R ON RU.[RoleID] = RU.[RoleID] AND R.[ApplicationID] = @AppID 
				WHERE	U.[UserID] = @UserID
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