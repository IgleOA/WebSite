-- ======================================================================
-- Name: [music].[uspReadAvailableCopyPrograms]
-- Desc: Muestra la informacion de todos programas disponibles para copiar
-- Auth: Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date: 6/03/2019
-------------------------------------------------------------
-- Change History
-------------------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		-----------------------------
-- ======================================================================

CREATE PROCEDURE [music].[uspReadAvailableCopyPrograms]
	@ProgramID	INT
AS 
    BEGIN
        SET NOCOUNT ON
        BEGIN TRY
            DECLARE @lErrorMessage NVARCHAR(4000)
            DECLARE @lErrorSeverity INT
            DECLARE @lErrorState INT

            -- =======================================================
				DECLARE @Datetime DATETIME

				SELECT	@Datetime = CONVERT(DATETIME,CONVERT(VARCHAR(10),[ProgramDate],111) +' '+ [ProgramSchedule])
				FROM	[music].[utbPrograms]
				WHERE	[ProgramID] = @ProgramID

				SELECT	TOP 10
						[ProgramID]
						,[ProgramDate]
						,[ProgramSchedule]
						,[CompleteFlag]
						,[ActiveFlag]
						,[Datetime] = CONVERT(DATETIME,CONVERT(VARCHAR(10),[ProgramDate],111) +' '+ [ProgramSchedule])
						,[NotificationDate]
				FROM	[music].[utbPrograms]
				WHERE	[ActiveFlag] = 1
						AND CONVERT(DATETIME,CONVERT(VARCHAR(10),[ProgramDate],111) +' '+ [ProgramSchedule]) <  @Datetime
				ORDER BY [Datetime]	DESC
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
