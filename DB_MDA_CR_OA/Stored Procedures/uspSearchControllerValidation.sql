-- ======================================================================
-- Name: [adm].[uspSearchControllerValidation]
-- Desc: Valida los derechos de un usuarion dentro de un controlador en específico
-- Auth: Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date: 05/23/2019
-------------------------------------------------------------
-- Change History
-------------------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		-----------------------------
-- ======================================================================

CREATE PROCEDURE [adm].[uspSearchControllerValidation]
	@AppID			INT,
	@ControllerName	VARCHAR(50),
	@UserName		VARCHAR(50)
AS 
    BEGIN
        SET NOCOUNT ON
        BEGIN TRY
            DECLARE @lErrorMessage NVARCHAR(4000)
            DECLARE @lErrorSeverity INT
            DECLARE @lErrorState INT

            -- =======================================================
				SELECT	CR.[CTRRightID]
						,CR.[ControllerID]
						,CD.[ControllerName]
						,CR.[ReadFlag]
						,CR.[WriteFlag]
				FROM	[adm].[utbControllerRights] CR
						JOIN [adm].[utbControllerDirectory] CD ON CD.[ControllerID] = CR.[ControllerID] 
																  AND CD.ControllerName = @ControllerName 
																  AND CD.[ApplicationID] = @AppID
																  AND CD.[ActiveFlag] = 1
						JOIN [adm].[utbRolesbyUser] RU ON RU.[RoleID] = CR.[RoleID] AND RU.[ActiveFlag] = 1
						JOIN [adm].[utbUsers] U ON U.[UserID] = RU.[UserID] AND U.UserName = @UserName
				WHERE	CR.[ActiveFlag] = 1
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
