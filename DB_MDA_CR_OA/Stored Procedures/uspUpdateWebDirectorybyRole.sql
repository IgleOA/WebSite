-- ======================================================================
-- Name: [adm].[uspUpdateWebDirectorybyRole]
-- Desc: Se utiliza para actualizar los accessos de los diferentes roles
-- Auth: Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date: 5/24/2019
-------------------------------------------------------------
-- Change History
-------------------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		-----------------------------
-- ======================================================================

CREATE PROCEDURE [adm].[uspUpdateWebDirectorybyRole]
		@InsertUser	VARCHAR(50),
		@ProfileID	INT		
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
				DECLARE @Status BIT

				SELECT	@Status = [ActiveFlag]
				FROM	[adm].[utbWebDirectorybyRole]
				WHERE	[ProfileID] = @ProfileID

				IF(@Status = 1)
					BEGIN
						UPDATE	[adm].[utbWebDirectorybyRole]
						SET		[ActiveFlag]		=	0
								,[LastModifyDate]	=	GETDATE()
								,[LastModifyUser]	=	@InsertUser
						WHERE	[ProfileID]			=	@ProfileID
					END
				ELSE
					BEGIN
						UPDATE	[adm].[utbWebDirectorybyRole]
						SET		[ActiveFlag]		=	1
								,[LastModifyDate]	=	GETDATE()
								,[LastModifyUser]	=	@InsertUser
						WHERE	[ProfileID]			=	@ProfileID
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
