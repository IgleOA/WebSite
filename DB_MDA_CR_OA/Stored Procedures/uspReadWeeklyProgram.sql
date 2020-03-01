-- ======================================================================
-- Name: [music].[uspReadWeeklyProgram]
-- Desc: Muestra los programas de la semana
-- Auth: Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date: 5/17/2019
-------------------------------------------------------------
-- Change History
-------------------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		-----------------------------
-- ======================================================================

CREATE PROCEDURE [music].[uspReadWeeklyProgram]
AS 
    BEGIN
        SET NOCOUNT ON
        BEGIN TRY
            DECLARE @lErrorMessage NVARCHAR(4000)
            DECLARE @lErrorSeverity INT
            DECLARE @lErrorState INT

            -- =======================================================
				DECLARE @Date	DATETIME = CONVERT(DATETIME,CONVERT(VARCHAR(20),SWITCHOFFSET (GETDATE(),'-06:00'),120))
				SET DATEFIRST 1

				SELECT	[ProgramID]
						,[ProgramDate]
						,[ProgramSchedule]
						,[CompleteFlag]
						,[ActiveFlag]
						,[NotificationDate] = CASE WHEN [NotificationDate] IS NOT NULL THEN CONVERT(DATETIME,CONVERT(VARCHAR(20),SWITCHOFFSET([NotificationDate],'-06:00'),120))
												   ELSE NULL END
				FROM	[music].[utbPrograms]
				WHERE	[ActiveFlag] = 1
						AND DATEPART(WEEK,[ProgramDate]) = DATEPART(WEEK,@Date)
		 
				ORDER BY	[ProgramDate]
							,CONVERT(TIME,[ProgramSchedule])
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
