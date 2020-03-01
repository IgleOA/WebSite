-- ======================================================================
-- Name: [adm].[uspAutoCompletePrograms]
-- Desc: Este SP completa automaticamente los programas caducados
-- Auth: Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date: 5/04/2019
-------------------------------------------------------------
-- Change History
-------------------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		-----------------------------
-- ======================================================================

CREATE PROCEDURE [adm].[uspAutoCompletePrograms]

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
				SELECT	*
				INTO	#MainData
				FROM	[music].[utbPrograms] 
				WHERE	[ProgramDate] < CONVERT(DATETIME,CONVERT(VARCHAR(10),GETDATE(),111))
						AND [CompleteFlag] = 0

				UPDATE	[music].[utbPrograms]
				SET		[CompleteFlag]	=	1
						,[LastModifyUser]	=	SYSTEM_USER
						,[LastModifyDate]	=	GETDATE()
				WHERE	[ProgramID] IN (SELECT [ProgramID] FROM #MainData)

				SELECT	*
				FROM	 #MainData
				
				DROP TABLE #MainData
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
