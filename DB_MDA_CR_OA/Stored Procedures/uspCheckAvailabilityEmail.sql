-- ======================================================================
-- Name: [adm].[uspCheckAvailabilityUserName]
-- Desc: Es para validar si un nombre de usuario ya existe en la base de datos
-- Auth: Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date: 5/24/2019
-------------------------------------------------------------
-- Change History
-------------------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		-----------------------------
-- ======================================================================

CREATE PROCEDURE [adm].[uspCheckAvailabilityEmail]
	@Email VARCHAR(50)
AS 
    BEGIN
        SET NOCOUNT ON
        BEGIN TRY
            DECLARE @lErrorMessage NVARCHAR(4000)
            DECLARE @lErrorSeverity INT
            DECLARE @lErrorState INT

            -- =======================================================
				SELECT	 [UserID]
						,[FullName]
						,[UserName]
						,[Email]
				FROM	[adm].[utbUsers]
				WHERE	[Email] = @Email
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
