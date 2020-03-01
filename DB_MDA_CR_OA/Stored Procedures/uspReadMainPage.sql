-- ========================================================================================
-- Name:  [adm].[uspReadMainPage]
-- Desc:  Despliega los titulos y categorias de la Pagina Principal
-- Auth:  Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date:  05/24/2019
------------------------------------------------
-- Change History
------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		----------------------------------------------
-- ========================================================================================
CREATE PROCEDURE [adm].[uspReadMainPage]
AS
BEGIN
	SET NOCOUNT ON
    BEGIN TRY
            DECLARE @lErrorMessage NVARCHAR(4000)
            DECLARE @lErrorSeverity INT
            DECLARE @lErrorState INT
			-- ========================================================================================
				SELECT	[ApplicationID]
						,[MainAppName]
						,[Controller]
						,[ViewPage]
						,[Slide]		=	CASE WHEN ROW_NUMBER() OVER(ORDER BY [MainAppName]) < 10 THEN 'Slide0'+CONVERT(VARCHAR(1),ROW_NUMBER() OVER(ORDER BY [MainAppName]))
												 ELSE 'Slide' + CONVERT(VARCHAR(10),ROW_NUMBER() OVER(ORDER BY [MainAppName])) END
						,[PageIndex]	=	ROW_NUMBER() OVER(ORDER BY [MainAppName])-1
						,[Description]
				FROM	[adm].[utbAppDirectory]
				WHERE	[ActiveFlag] = 1
				ORDER BY [Order]
						
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
