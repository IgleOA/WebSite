-- ======================================================================
-- Name: [music].[uspReadNextRehearsal]
-- Desc: Muestra la lista de canciones para el ensayo
-- Auth: Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date: 05/07/2019
-------------------------------------------------------------
-- Change History
-------------------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		-----------------------------
-- ======================================================================

CREATE PROCEDURE [music].[uspReadNextRehearsal]
AS 
    BEGIN
        SET NOCOUNT ON
        BEGIN TRY
            DECLARE @lErrorMessage NVARCHAR(4000)
            DECLARE @lErrorSeverity INT
            DECLARE @lErrorState INT

            -- =======================================================
				SELECT	DISTINCT
						S.[SongID]
						,S.[SongName]
						,S.[AuthorID]
				FROM	[music].[utbSongsbyProgram] SP
						LEFT JOIN [music].[utbSongs] S ON S.[SongID] = SP.[SongID]
						INNER JOIN [music].[utbPrograms] P ON P.[ProgramID] = SP.[ProgramID] AND P.[CompleteFlag] = 0
				WHERE	SP.[ActiveFlag] = 1
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
