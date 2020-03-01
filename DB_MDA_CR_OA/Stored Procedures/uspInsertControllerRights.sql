-- ======================================================================
-- Name: [adm].[uspInsertControllerRights]
-- Desc: Se utiliza para agregar nuevos derechos a un rol en específico
-- Auth: Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date: 05/23/2019
-------------------------------------------------------------
-- Change History
-------------------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		-----------------------------
-- ======================================================================

CREATE PROCEDURE [adm].[uspInsertControllerRights]
		@InsertUser		VARCHAR(50),
		@RoleID			INT,
		@ControllerID	INT,
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
				IF (@Right = 'Read')
					BEGIN
						INSERT INTO [adm].[utbControllerRights] ([RoleID],[ControllerID],[InsertUser],[LastModifyUser])
						VALUES (@RoleID,@ControllerID,@InsertUser,@InsertUser)
					END
				ELSE
					BEGIN
						INSERT INTO [adm].[utbControllerRights] ([RoleID],[ControllerID],[WriteFlag],[InsertUser],[LastModifyUser])
						VALUES (@RoleID,@ControllerID,1,@InsertUser,@InsertUser)
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
