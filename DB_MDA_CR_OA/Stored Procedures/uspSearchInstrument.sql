-- ======================================================================
-- Name: [music].[uspSearchInstrument]
-- Desc: Permite mostrar la informacion de un instrumento en especifico
-- Auth: Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date: 4/15/2019
-------------------------------------------------------------
-- Change History
-------------------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		-----------------------------
-- ======================================================================

CREATE PROCEDURE [music].[uspSearchInstrument]
		@InstrumentID INT
AS 
    BEGIN
        SET NOCOUNT ON
        BEGIN TRY
            DECLARE @lErrorMessage NVARCHAR(4000)
            DECLARE @lErrorSeverity INT
            DECLARE @lErrorState INT

            -- =======================================================
				SELECT	[InstrumentID]
						,[Instrument]
				FROM	[music].[utbInstruments]
				WHERE	[InstrumentID] = @InstrumentID
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
