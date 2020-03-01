-- ======================================================================
-- Name: [adm].[uspUpdateRole]
-- Desc: Se utiliza para actualizar la información de un rol
-- Auth: Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date: 3/29/2019
-------------------------------------------------------------
-- Change History
-------------------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		-----------------------------
-- ======================================================================

CREATE PROCEDURE [adm].[uspUpdateRole]
	@ActionType		VARCHAR(6),
	@InsertUser		VARCHAR(50),
	@RoleID			INT,
	@RoleName		VARCHAR(50)		=	NULL,
	@Description	VARCHAR(MAX)	=	NULL,
	@ActiveFlag		BIT				=	NULL
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
				IF(@ActionType = 'MS') --- MS = Modify Status
					BEGIN
						UPDATE	[adm].[utbRoles] 
						SET		[ActiveFlag]		=	@ActiveFlag
								,[LastModifyDate]	=	GETDATE()
								,[LastModifyUser]	=	@InsertUser
						WHERE	[RoleID] = @RoleID
					END
				ELSE		 -- Modify entire information
					BEGIN
						UPDATE	[adm].[utbRoles] 
						SET		[RoleName]			=	@RoleName
								,[RoleDescription]	=	@Description
								,[ActiveFlag]		=	@ActiveFlag
								,[LastModifyDate]	=	GETDATE()
								,[LastModifyUser]	=	@InsertUser
						WHERE	[RoleID] = @RoleID
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
