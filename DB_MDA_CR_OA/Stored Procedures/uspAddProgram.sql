-- ======================================================================
-- Name: [music].[uspAddProgram]
-- Desc: Se utiliza para la agregar nuevos programas
-- Auth: Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date: 4/19/2019
-------------------------------------------------------------
-- Change History
-------------------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		-----------------------------
-- ======================================================================

CREATE PROCEDURE [music].[uspAddProgram]
	@InsertUser		VARCHAR(50),
	@PDate			DATETIME,
	@PSchedule		VARCHAR(20),
	@ProgramID		INT OUTPUT

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
				DECLARE @CompleteFlag BIT

				IF(@PDate>= CONVERT(VARCHAR(10),GETDATE(),111))
					BEGIN
						SET @CompleteFlag = 0
					END
				ELSE 
					BEGIN
						SET @CompleteFlag = 1
					END

				INSERT INTO [music].[utbPrograms] ([ProgramDate],[ProgramSchedule],[CompleteFlag],[CreationUser],[LastModifyUser])
				VALUES (@PDate,@PSchedule,@CompleteFlag,@InsertUser,@InsertUser)

				SET @ProgramID = SCOPE_IDENTITY()

				SELECT [ProgramID] = @ProgramID

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
