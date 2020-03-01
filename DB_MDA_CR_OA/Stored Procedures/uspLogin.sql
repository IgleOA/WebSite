-- ======================================================================
-- Name: [adm].[uspLogin]
-- Desc: Se utiliza para la validación de los usuarios al logearse en la applicación
-- Auth: Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date: 5/24/2019
-------------------------------------------------------------
-- Change History
-------------------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		-----------------------------
-- ======================================================================

CREATE PROCEDURE [adm].[uspLogin]
	@UserName	VARCHAR(50),
	@Password	VARCHAR(50)
AS 
    BEGIN
        SET NOCOUNT ON
        BEGIN TRY
            DECLARE @lErrorMessage NVARCHAR(4000)
            DECLARE @lErrorSeverity INT
            DECLARE @lErrorState INT

            -- =======================================================
				DECLARE @UserID		INT
				DECLARE @AuthFlag	BIT

				IF EXISTS (SELECT TOP 1 [UserID] FROM [adm].[utbUsers] WHERE [UserName] = @UserName)
					BEGIN
						SELECT	@UserID		=	[UserID],
								@AuthFlag	=	[AuthorizationFlag]
						FROM	[adm].[utbUsers] 
						WHERE	[UserName]	=	@UserName
								AND [PasswordHash] = HASHBYTES('SHA2_512',@Password)
								AND [ActiveFlag] = 1

						IF (@UserID IS NULL)
							BEGIN
								SET @UserID = -1  -- Password Incorrecto
							END
						ELSE
							BEGIN
								IF(@AuthFlag = 0)
									BEGIN
										SET	@UserID  = -2  -- Usuario no autorizado aún
									END
							END
						SELECT @UserID
					END
				ELSE 
					BEGIN
						SELECT (0)  -- Usuario no registrado
					END

			-- =======================================================

        END TRY
        BEGIN CATCH

            SELECT  @lErrorMessage = ERROR_MESSAGE() ,
                    @lErrorSeverity = ERROR_SEVERITY() ,
                    @lErrorState = ERROR_STATE()       

            RAISERROR (@lErrorMessage, @lErrorSeverity, @lErrorState);
        END CATCH
    END
    SET NOCOUNT OFF
GO
