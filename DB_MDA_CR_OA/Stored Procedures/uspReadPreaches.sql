-- ======================================================================
-- Name: [ministry].[uspReadPreaches]
-- Desc: Muestra la informacion de todas las predicas
-- Auth: Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date: 12/13/2019
-------------------------------------------------------------
-- Change History
-------------------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		-----------------------------
-- ======================================================================

CREATE PROCEDURE [ministry].[uspReadPreaches]
AS 
    BEGIN
        SET NOCOUNT ON
        BEGIN TRY
            DECLARE @lErrorMessage NVARCHAR(4000)
            DECLARE @lErrorSeverity INT
            DECLARE @lErrorState INT

            -- =======================================================
				SELECT	[PreachID]
						,P.[MinisterID]
						,M.[MinisterName]
						,[Title]
						,[Description]
						,[Tags]
						--,[FileData]
						,P.[ActiveFlag]
						,[PreachingDate]
				FROM	[ministry].[utbPreaches] P
						LEFT JOIN [ministry].[utbMinisters] M ON M.[MinisterID] = P.[MinisterID]
				ORDER BY [PreachingDate] DESC
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
