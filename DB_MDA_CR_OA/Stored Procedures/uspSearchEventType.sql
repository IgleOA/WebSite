-- ======================================================================
-- Name: [adm].[uspSearchEventType]
-- Desc: Muestra la informacion de un específico de tipos de eventos
-- Auth: Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date: 06/11/2019
-------------------------------------------------------------
-- Change History
-------------------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		-----------------------------
-- ======================================================================

CREATE PROCEDURE [adm].[uspSearchEventType]
	@TypeID INT
AS 
    BEGIN
        SET NOCOUNT ON
        BEGIN TRY
            DECLARE @lErrorMessage NVARCHAR(4000)
            DECLARE @lErrorSeverity INT
            DECLARE @lErrorState INT

            -- =======================================================
				SELECT	[EventTypeID]	
						,[EventTypeName]
						,[ThemeColor]
				FROM	[adm].[utbEventTypes]
				WHERE	[ActiveFlag] = 1
						AND [EventTypeID] = @TypeID
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
