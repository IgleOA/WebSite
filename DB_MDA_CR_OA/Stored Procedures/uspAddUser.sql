-- ======================================================================
-- Name: [adm].[uspAddUser]
-- Desc: Se utiliza para la creación de nuevos usuarios
-- Auth: Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date: 5/24/2019
-------------------------------------------------------------
-- Change History
-------------------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		-----------------------------
-- ======================================================================

CREATE PROCEDURE [adm].[uspAddUser]
	@InsertUser		VARCHAR(50),
	@FullName		VARCHAR(50),
	@UserName		VARCHAR(50),
	@Email			VARCHAR(50),
	@Password		VARCHAR(50),
	@ApplicationID	INT,
	@RoleID			INT	= NULL
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
				DECLARE	@UserID INT

				IF(@RoleID IS NULL)
					BEGIN
						INSERT INTO [adm].[utbUsers] ([FullName],[UserName],[Email],[PasswordHash],[CreationUser],[LastModifyUser])
						VALUES (@FullName, @UserName,@Email,HASHBYTES('SHA2_512',@Password),@InsertUser,@InsertUser)
					END
				ELSE
					BEGIN
						INSERT INTO [adm].[utbUsers] ([FullName],[UserName],[Email],[PasswordHash],[AuthorizationFlag],[CreationUser],[LastModifyUser])
						VALUES (@FullName, @UserName,@Email,HASHBYTES('SHA2_512',@Password),1,@InsertUser,@InsertUser)
					END

				SELECT	@UserID = [UserID]
				FROM	[adm].[utbUsers]
				WHERE	[UserName] = @UserName
						AND [ActiveFlag] = 1

				IF(@RoleID IS NULL)
					BEGIN
						IF(@ApplicationID = 1)
							BEGIN
								SELECT	@RoleID = [RoleID]
								FROM	[adm].[utbRoles]
								WHERE	[ApplicationID] = @ApplicationID
										AND [RoleName] = 'Nuevo Usuario'
						
								INSERT INTO [adm].[utbRolesbyUser] ([UserID],[RoleID],[CreationUser],[LastModifyUser])
								VALUES (@UserID,@RoleID,@InsertUser,@InsertUser)
							END
						ELSE
							BEGIN
								INSERT INTO [adm].[utbRolesbyUser] ([UserID],[RoleID],[CreationUser],[LastModifyUser])
								SELECT	@UserID
										,[RoleID]
										,@InsertUser
										,@InsertUser
								FROM	[adm].[utbRoles]
								WHERE	[ApplicationID] IN (1,@ApplicationID)
										AND [RoleName] = 'Nuevo Usuario'
							END
					END
				ELSE
					BEGIN
						IF(@ApplicationID = 1)
							BEGIN
								INSERT INTO [adm].[utbRolesbyUser] ([UserID],[RoleID],[CreationUser],[LastModifyUser])
								VALUES (@UserID,@RoleID,@InsertUser,@InsertUser)
							END
						ELSE
							BEGIN
								INSERT INTO [adm].[utbRolesbyUser] ([UserID],[RoleID],[CreationUser],[LastModifyUser])
								SELECT	@UserID
										,[RoleID]
										,@InsertUser
										,@InsertUser
								FROM	[adm].[utbRoles]
								WHERE	([RoleID] = @RoleID)
										OR
										([RoleName] = 'Usuario' AND [ApplicationID] = 1)
							END
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
