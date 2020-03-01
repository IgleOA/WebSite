-- ========================================================================================
-- Name:  [adm].[uspReadWebDirectorybyUser]
-- Desc:  Despliega el menu principal que va a tener el usuario
-- Auth:  Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date:  05/24/2019
------------------------------------------------
-- Change History
------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		----------------------------------------------
-- ========================================================================================
CREATE PROCEDURE [adm].[uspReadWebDirectorybyUser]
		@AppID		INT,
		@UserName	VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON
    BEGIN TRY
            DECLARE @lErrorMessage NVARCHAR(4000)
            DECLARE @lErrorSeverity INT
            DECLARE @lErrorState INT
			-- ========================================================================================
				SELECT	WDR.[ProfileID]
						,WD.[MainClass]
						,WD.[WebName]
						,WD.[Controller]
						,WD.[ViewPage]
						,WD.[Parameter]
      
				FROM	[adm].[utbWebDirectory] WD
						INNER JOIN [adm].[utbWebDirectorybyRole] WDR ON WDR.[WebID] = WD.[WebID] AND WDR.[ActiveFlag] = 1
						INNER JOIN [adm].[utbRoles] R ON R.[RoleID] = WDR.RoleID AND R.[ActiveFlag] = 1
						INNER JOIN [adm].[utbRolesbyUser] RU ON RU.[RoleID] = R.RoleID AND RU.[ActiveFlag] = 1
						INNER JOIN [adm].[utbUsers] U ON U.[UserID] = RU.[UserID] AND U.[ActiveFlag] = 1
				WHERE	WD.[ActiveFlag] = 1
						AND U.[UserName] = @UserName
						AND WD.[ApplicationID] = @AppID
				ORDER BY WD.[MainOrder], WD.[Order]
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
