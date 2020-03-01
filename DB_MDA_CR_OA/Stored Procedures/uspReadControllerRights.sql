-- ========================================================================================
-- Name:  [adm].[uspReadControllerRights]
-- Desc:  Despliega las derechos asociados a un rol específico.
-- Auth:  Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date:  05/19/2019
------------------------------------------------
-- Change History
------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		----------------------------------------------
-- ========================================================================================
CREATE PROCEDURE [adm].[uspReadControllerRights]
		@RoleID	INT
AS
BEGIN
	SET NOCOUNT ON
    BEGIN TRY
            DECLARE @lErrorMessage NVARCHAR(4000)
            DECLARE @lErrorSeverity INT
            DECLARE @lErrorState INT
			-- ========================================================================================
				SELECT	CD.[ControllerID]
						,CD.[ControllerName]
						,[CTRRightID]	=	ISNULL(CR.[CTRRightID],0)
						,[ReadFlag]		=	ISNULL(CR.[ReadFlag],0)
						,[WriteFlag]	=	ISNULL(CR.[WriteFlag],0)
				FROM	[adm].[utbControllerDirectory] CD
						INNER JOIN [adm].[utbRoles] R ON R.[ApplicationID] = CD.[ApplicationID]
						LEFT JOIN [adm].[utbControllerRights] CR ON CR.[ControllerID] = CD.ControllerID 
																	AND CR.[ActiveFlag] = 1
																	AND CR.[RoleID] = @RoleID

				WHERE	CD.[ActiveFlag] = 1
						AND R.[RoleID] = @RoleID
				ORDER BY CD.[ControllerName]
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
