-- ======================================================================
-- Name: [adm].[uspCreateRole]
-- Desc: Se utiliza para la creación de nuevos roles
-- Auth: Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date: 05/24/2019
-------------------------------------------------------------
-- Change History
-------------------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		-----------------------------
-- ======================================================================

CREATE PROCEDURE [adm].[uspCreateRole]
	@InsertUser		VARCHAR(50),
	@AppID			INT,
	@RoleName		VARCHAR(50),
	@Description	VARCHAR(MAX)
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
				INSERT INTO [adm].[utbRoles] ([ApplicationID],[RoleName],[RoleDescription],[ActiveFlag],[CreationUser],[LastModifyUser])
				VALUES (@AppID, @RoleName,@Description,1,@InsertUser,@InsertUser)
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
