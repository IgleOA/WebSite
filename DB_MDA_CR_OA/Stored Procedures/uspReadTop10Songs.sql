-- ======================================================================
-- Name: [music].[uspReadTop10Songs]
-- Desc: Leer las 10 canciones mas utilizadas en los programas
-- Auth: Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date: 05/18/2019
-------------------------------------------------------------
-- Change History
-------------------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		-----------------------------
-- ======================================================================

CREATE PROCEDURE [music].[uspReadTop10Songs]
AS 
    BEGIN
        SET NOCOUNT ON
        BEGIN TRY
            DECLARE @lErrorMessage NVARCHAR(4000)
            DECLARE @lErrorSeverity INT
            DECLARE @lErrorState INT

            -- =======================================================
				SELECT	DISTINCT
						SP.SongID
						,P.ProgramDate
				INTO	#MainData
				FROM	[music].[utbSongsbyProgram] SP
						LEFT JOIN [music].[utbPrograms] P ON P.[ProgramID] = SP.[ProgramID]
				WHERE	SP.[ActiveFlag] = 1

				SELECT	TOP 10
						[RowNumber] = ROW_NUMBER() OVER(ORDER BY T.Times DESC)
						,S.[SongID]
						,S.[SongName]
						,S.[AuthorID]  
						,T.Times
				FROM	[music].[utbSongs] S
						OUTER APPLY (SELECT [Times] = COUNT(SP.SongID)
									 FROM	#MainData SP
									 WHERE	SP.[SongID] = S.SongID
											AND DATEDIFF(DAY,SP.[ProgramDate],GETDATE()) <= 90) T
				ORDER BY T.Times DESC

				DROP TABLE #MainData
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
