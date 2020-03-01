-- ======================================================================
-- Name: [adm].[uspUpdateControllerRights]
-- Desc: Se utiliza para actualizar los derechos de un rol en específico
-- Auth: Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date: 05/23/2019
-------------------------------------------------------------
-- Change History
-------------------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		-----------------------------
-- ======================================================================

CREATE PROCEDURE [adm].[uspUpdateControllerRights]
		@InsertUser		VARCHAR(50),
		@CTRRightID		INT,
		@Right			VARCHAR(20)
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
				DECLARE @pStatus BIT

				IF (@Right = 'Read')
					BEGIN
						SELECT	@pStatus = CASE WHEN [ReadFlag] = 1 THEN 0 ELSE 1 END
						FROM	[adm].[utbControllerRights]
						WHERE	[CTRRightID] = @CTRRightID

						UPDATE	[adm].[utbControllerRights]
						SET		[ReadFlag] = @pStatus
								,[LastModifyDate] = GETDATE()
								,[LastModifyUser] = @InsertUser
						WHERE	[CTRRightID] = @CTRRightID
					END
				ELSE
					BEGIN
						SELECT	@pStatus = CASE WHEN [WriteFlag] = 1 THEN 0 ELSE 1 END
						FROM	[adm].[utbControllerRights]
						WHERE	[CTRRightID] = @CTRRightID

						UPDATE	[adm].[utbControllerRights]
						SET		[WriteFlag] = @pStatus
								,[LastModifyDate] = GETDATE()
								,[LastModifyUser] = @InsertUser
						WHERE	[CTRRightID] = @CTRRightID
					END
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
