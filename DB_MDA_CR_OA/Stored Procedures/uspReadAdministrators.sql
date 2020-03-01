-- ========================================================================================
-- Name:  [adm].[uspReadAdministrators]
-- Desc:  Despliega la informacion de los administradores en funcion de la aplicación
-- Auth:  Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date:  05/24/2019
------------------------------------------------
-- Change History
------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		----------------------------------------------
-- ========================================================================================
CREATE PROCEDURE [adm].[uspReadAdministrators]
	@ApplicationID INT
AS
BEGIN
	SET NOCOUNT ON
    BEGIN TRY
            DECLARE @lErrorMessage NVARCHAR(4000)
            DECLARE @lErrorSeverity INT
            DECLARE @lErrorState INT
			-- ========================================================================================
				IF(@ApplicationID = 0)
					BEGIN
						SELECT	U.[UserID]
								,U.[FullName]
								,U.[UserName]
								,U.[Email]    
						FROM	[adm].[utbUsers] U
								INNER JOIN [adm].[utbRolesbyUser] RU ON RU.[UserID] = U.[UserID] AND RU.[ActiveFlag] = 1
								LEFT JOIN [adm].[utbRoles] R ON R.[RoleID] = RU.[RoleID]
						WHERE	R.[RoleName] IN ('Administrador de Plataforma','Administrador') 
					END
				ELSE
					BEGIN
						SELECT	U.[UserID]
								,U.[FullName]
								,U.[UserName]
								,U.[Email]    
						FROM	[adm].[utbUsers] U
								INNER JOIN [adm].[utbRolesbyUser] RU ON RU.[UserID] = U.[UserID] AND RU.[ActiveFlag] = 1
								LEFT JOIN [adm].[utbRoles] R ON R.[RoleID] = RU.[RoleID]
						WHERE	R.[RoleName] IN ('Administrador de Plataforma','Administrador') 
								AND R.[ApplicationID] = @ApplicationID
					END
			-- ========================================================================================
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
