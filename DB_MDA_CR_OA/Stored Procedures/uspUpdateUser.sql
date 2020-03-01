-- ======================================================================
-- Name: [adm].[uspUpdateUser]
-- Desc: Se utiliza para actualizar la información de un usuario
-- Auth: Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date: 5/25/2019
-------------------------------------------------------------
-- Change History
-------------------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		-----------------------------
-- ======================================================================

CREATE PROCEDURE [adm].[uspUpdateUser]
	@ActionType		VARCHAR(6),
	@InsertUser		VARCHAR(50),
	@UserID			INT,
	@AppID			INT			=	NULL,
	@FullName		VARCHAR(50)	=	NULL,
	@RoleID			INT			=	NULL,
	@ActiveFlag		BIT			=	NULL
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
				DECLARE @RoleUserID INT

				IF(@ActionType = 'GUDP')		-- GUDP = General Update
					BEGIN
						UPDATE	[adm].[utbUsers]
						SET		[FullName]		=	@FullName,
								[ActiveFlag]	=	@ActiveFlag,
								[LastModifyUser]=	@InsertUser,
								[LastModifyDate]=	GETDATE()
						WHERE	[UserID]	=	@UserID

						SELECT	@RoleUserID = RU.[RoleUserID]
						FROM	[adm].[utbRolesbyUser] RU
								LEFT JOIN [adm].[utbRoles] R ON R.[RoleID] = RU.[RoleID]
						WHERE	R.[ApplicationID] = @AppID
								AND RU.[UserID] = @UserID

						UPDATE	[adm].[utbRolesbyUser]
						SET		[RoleID] = @RoleID,
								[LastModifyDate] = GETDATE(),
								[LastModifyUser] = @InsertUser
						WHERE	[RoleUserID] = @RoleUserID
					END
				ELSE
					BEGIN
						IF(@ActionType = 'MS')	-- MS = Modify Status - ActiveFlag
							BEGIN
								UPDATE	[adm].[utbUsers]
								SET		[ActiveFlag]	=	@ActiveFlag,
										[LastModifyUser]=	@InsertUser,
										[LastModifyDate]=	GETDATE()
								WHERE	[UserID]	=	@UserID
							END
						ELSE					-- Authorizations
							BEGIN
								UPDATE	[adm].[utbUsers]
								SET		[AuthorizationFlag]	=	1,
										[LastModifyUser]	=	@InsertUser,
										[LastModifyDate]	=	GETDATE()
								WHERE	[UserID]	=	@UserID

								SELECT	@RoleUserID = RU.[RoleUserID]
								FROM	[adm].[utbRolesbyUser] RU
										LEFT JOIN [adm].[utbRoles] R ON R.[RoleID] = RU.[RoleID]
								WHERE	R.[ApplicationID] = @AppID
										AND RU.[UserID] = @UserID

								UPDATE	[adm].[utbRolesbyUser]
								SET		[RoleID] = @RoleID,
										[LastModifyDate] = GETDATE(),
										[LastModifyUser] = @InsertUser
								WHERE	[RoleUserID] = @RoleUserID
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
