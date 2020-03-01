
-- ======================================================================
-- Name: [music].[uspCopyProgram]
-- Desc: Se utiliza para copiar programas de otros existentes
-- Auth: Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date: 4/02/2019
-------------------------------------------------------------
-- Change History
-------------------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		-----------------------------
-- ======================================================================

CREATE PROCEDURE [music].[uspCopyProgram]
	@ProgramIDTarget	INT,
	@ProgramIDSource	INT,
	@InsertUser			VARCHAR(50)
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
				DELETE FROM [music].[utbSongsbyProgram]
				WHERE [ProgramID] = @ProgramIDTarget

				INSERT INTO [music].[utbSongsbyProgram] ([ProgramID],[SongID],[InsertUser],[LastModifyUser])
				SELECT	[ProgramID]			=	@ProgramIDTarget
						,[SongID]		
						,[InsertUser]		=	@InsertUser
						,[LastModifyUser]	=	@InsertUser
				FROM	[music].[utbSongsbyProgram]
				WHERE	[ProgramID]	= @ProgramIDSource
						AND [ActiveFlag] = 1
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
