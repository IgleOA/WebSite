-- ======================================================================
-- Name: [music].[uspSearchProgram]
-- Desc: Muestra la informacion de un programa en especifico
-- Auth: Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date: 4/17/2019
-------------------------------------------------------------
-- Change History
-------------------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		-----------------------------
-- ======================================================================

CREATE PROCEDURE [music].[uspSearchProgramDetails]
	@ProgramID	INT
AS 
    BEGIN
        SET NOCOUNT ON
        BEGIN TRY
            DECLARE @lErrorMessage NVARCHAR(4000)
            DECLARE @lErrorSeverity INT
            DECLARE @lErrorState INT

            -- =======================================================
				SELECT	SP.[SPID]
						,SP.[ProgramID]
						,SP.[SongID]
						,S.[AuthorID]
						,SP.[ActiveFlag]
				FROM	[music].[utbSongsbyProgram] SP
						LEFT JOIN [music].[utbSongs] S ON S.[SongID] = SP.[SongID]
				WHERE	SP.[ProgramID] = @ProgramID
						AND SP.[ActiveFlag] = 1
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
