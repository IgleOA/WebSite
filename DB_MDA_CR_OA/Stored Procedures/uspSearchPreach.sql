-- ======================================================================
-- Name: [ministry].[uspSearchPreach]
-- Desc: Muestra la informacion de todas las predicas
-- Auth: Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date: 12/13/2019
-------------------------------------------------------------
-- Change History
-------------------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		-----------------------------
-- ======================================================================

CREATE PROCEDURE [ministry].[uspSearchPreach]
	@PreachID	INT
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
						,[FileData]
						,[FileType]
						,P.[ActiveFlag]
						,[PreachingDate]
						,[InsertDate] = CONVERT(datetime, SWITCHOFFSET(P.[InsertDate], DATEPART(TZOFFSET,P.[InsertDate] AT TIME ZONE 'Central America Standard Time')))
				FROM	[ministry].[utbPreaches] P
						LEFT JOIN [ministry].[utbMinisters] M ON M.[MinisterID] = P.[MinisterID]
				WHERE	[PreachID] = @PreachID
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
