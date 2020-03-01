-- ======================================================================
-- Name:[music].[uspReadPrograms]
-- Desc: Muestra la informacion de todos programas existentes
-- Auth: Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date: 4/17/2019
-------------------------------------------------------------
-- Change History
-------------------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		-----------------------------
-- ======================================================================

CREATE PROCEDURE [music].[uspReadPrograms]
AS 
    BEGIN
        SET NOCOUNT ON
        BEGIN TRY
            DECLARE @lErrorMessage NVARCHAR(4000)
            DECLARE @lErrorSeverity INT
            DECLARE @lErrorState INT

            -- =======================================================
				SELECT	[ProgramID]
						,[ProgramDate]
						,[ProgramSchedule]
						,[CompleteFlag]
						,[ActiveFlag]
						,[NotificationDate] = CASE WHEN [NotificationDate] IS NOT NULL THEN CONVERT(DATETIME,CONVERT(VARCHAR(20),SWITCHOFFSET([NotificationDate],'-06:00'),120))
												   ELSE NULL END
				FROM	[music].[utbPrograms]
				WHERE	[ActiveFlag] = 1
				ORDER BY	[ProgramDate] DESC
							,[ProgramSchedule] DESC
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
