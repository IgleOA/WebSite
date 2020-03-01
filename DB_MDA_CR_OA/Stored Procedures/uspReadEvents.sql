-- ======================================================================
-- Name: [adm].[uspReadEvents]
-- Desc: Muestra la informacion de todos los eventos disponibles
-- Auth: Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date: 06/11/2019
-------------------------------------------------------------
-- Change History
-------------------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		-----------------------------
-- ======================================================================

CREATE PROCEDURE [adm].[uspReadEvents]
	@Date	DATETIME
AS 
    BEGIN
        SET NOCOUNT ON
        BEGIN TRY
            DECLARE @lErrorMessage NVARCHAR(4000)
            DECLARE @lErrorSeverity INT
            DECLARE @lErrorState INT

            -- =======================================================
				DECLARE @StartDate	DATETIME	=	DATEADD(MONTH,DATEDIFF(MONTH,0,@Date),0)
				DECLARE @EndDate	DATETIME	=	EOMONTH(@StartDate)

				SELECT	[EventID]
						,[EventTypeID]
						,[Subject]
						,[Description]
						,[StartDate]
						,[EndDate]
						,[IsFullDay]
				FROM	[adm].[utbEvents]
				WHERE	[ActiveFlag] = 1
						AND (
								([StartDate] >= @StartDate AND [StartDate] <= @EndDate)
								OR
								([EndDate] >= @StartDate AND DATEADD(MONTH,DATEDIFF(MONTH,0,[StartDate]),0) <= @StartDate)
							)
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
