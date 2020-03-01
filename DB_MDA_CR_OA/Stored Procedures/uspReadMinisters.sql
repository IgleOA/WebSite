-- ======================================================================
-- Name: [ministry].[uspReadMinisters]
-- Desc: Muestra la informacion de todos ministros
-- Auth: Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date: 12/12/2019
-------------------------------------------------------------
-- Change History
-------------------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		-----------------------------
-- ======================================================================

CREATE PROCEDURE [ministry].[uspReadMinisters]
AS 
    BEGIN
        SET NOCOUNT ON
        BEGIN TRY
            DECLARE @lErrorMessage NVARCHAR(4000)
            DECLARE @lErrorSeverity INT
            DECLARE @lErrorState INT

            -- =======================================================
				SELECT	[MinisterID]
						,[MinisterName]
						,[ActiveFlag]
				FROM	[ministry].[utbMinisters]
				ORDER BY [MinisterName]
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
