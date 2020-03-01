-- ========================================================================================
-- Name:  [adm].[uspReadWebDirectorybyRole]
-- Desc:  Despliega las vistas a las que esta autorizado o no a ver dependiendo del rol.
-- Auth:  Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date:  03/28/2019
------------------------------------------------
-- Change History
------------------------------------------------
-- CI	Date		Author		Descriptioe3n
-- --	----		------		----------------------------------------------
-- ========================================================================================
CREATE PROCEDURE [adm].[uspReadWebDirectorybyRole]
		@RoleID			INT
AS
BEGIN
	SET NOCOUNT ON
    BEGIN TRY
            DECLARE @lErrorMessage NVARCHAR(4000)
            DECLARE @lErrorSeverity INT
            DECLARE @lErrorState INT
			-- ========================================================================================
				SELECT	[ProfileID] = ISNULL(P.[ProfileID],0)
						,WD.[WebID]
						,WD.[MainClass]
						,WD.[WebName]
						,[ActiveFlag] = ISNULL(P.[ActiveFlag],0)
      
				FROM	[adm].[utbWebDirectory] WD
						INNER JOIN [adm].[utbRoles] R ON R.RoleID = @RoleID AND R.ApplicationID = WD.ApplicationID
						OUTER APPLY	(SELECT	WR.[ProfileID]
											,WR.[ActiveFlag]
									  FROM	[adm].[utbWebDirectorybyRole] WR
									  WHERE	WR.[RoleID] = @RoleID
											AND WR.[WebID] = WD.[WebID]) P
				WHERE	WD.[ActiveFlag] = 1
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
