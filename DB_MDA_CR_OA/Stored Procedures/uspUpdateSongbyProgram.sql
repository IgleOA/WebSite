-- ======================================================================
-- Name: [music].[uspUpdateSongbyProgram]
-- Desc: Se utiliza para desabilitar una canción de un programa 
-- Auth: Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date: 4/29/2019
-------------------------------------------------------------
-- Change History
-------------------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		-----------------------------
-- ======================================================================

CREATE PROCEDURE [music].[uspUpdateSongbyProgram]
	@InsertUser		VARCHAR(50),
	@SPID			INT
AS 
    BEGIN
        SET NOCOUNT ON
        SET XACT_ABORT ON
                           
        BEGIN TRY
            DECLARE @lErrorMessage NVARCHAR(4000)
            DECLARE @lErrorSeverity INT
            DECLARE @lErrorState INT
            DECLARE @lLocalTran BIT = 0
                               
            IF @@TRANCOUNT = 0 
                BEGIN
                    BEGIN TRANSACTION
                    SET @lLocalTran = 1
                END

            -- =======================================================
				UPDATE	[music].[utbSongsbyProgram]
				SET		[ActiveFlag] = 0
						,[LastModifyDate] = GETDATE()
						,[LastModifyUser] = @InsertUser
				WHERE	[SPID] = @SPID

				SELECT	[ProgramID]
				FROM	[music].[utbSongsbyProgram]
				WHERE	[SPID] = @SPID
			-- =======================================================

        IF ( @@trancount > 0
                 AND @lLocalTran = 1
               ) 
                BEGIN
                    COMMIT TRANSACTION
                END
        END TRY
        BEGIN CATCH
            IF ( @@trancount > 0
                 AND XACT_STATE() <> 0
               ) 
                BEGIN
                    ROLLBACK TRANSACTION
                END

            SELECT  @lErrorMessage = ERROR_MESSAGE() ,
                    @lErrorSeverity = ERROR_SEVERITY() ,
                    @lErrorState = ERROR_STATE()       

            RAISERROR (@lErrorMessage, @lErrorSeverity, @lErrorState);
        END CATCH
    END

    SET NOCOUNT OFF
    SET XACT_ABORT OFF
GO
