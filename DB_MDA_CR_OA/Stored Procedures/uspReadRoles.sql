-- ======================================================================
-- Name: [adm].[uspReadRoles]
-- Desc: Muestra la informacion de todos los roles existentes
-- Auth: Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date: 3/26/2019
-------------------------------------------------------------
-- Change History
-------------------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		-----------------------------
-- ======================================================================

CREATE PROCEDURE [adm].[uspReadRoles]
	@AppID INT
AS 
    BEGIN
        SET NOCOUNT ON
        BEGIN TRY
            DECLARE @lErrorMessage NVARCHAR(4000)
            DECLARE @lErrorSeverity INT
            DECLARE @lErrorState INT

            -- =======================================================
				SELECT	[RoleID]
						,[RoleName]
						,[RoleDescription]
						,[ActiveFlag]
				FROM	[adm].[utbRoles]
				WHERE	[ApplicationID] = @AppID
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
