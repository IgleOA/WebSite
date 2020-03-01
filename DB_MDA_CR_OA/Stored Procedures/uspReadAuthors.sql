-- ======================================================================
-- Name: [music].[uspReadAuthors]
-- Desc: Muestra la informacion de todos autores existentes
-- Auth: Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date: 4/12/2019
-------------------------------------------------------------
-- Change History
-------------------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		-----------------------------
-- ======================================================================

CREATE PROCEDURE [music].[uspReadAuthors]
AS 
    BEGIN
        SET NOCOUNT ON
        BEGIN TRY
            DECLARE @lErrorMessage NVARCHAR(4000)
            DECLARE @lErrorSeverity INT
            DECLARE @lErrorState INT

            -- =======================================================
				SELECT	[AuthorID]
						,[AuthorName]
						,[ProfileLink]
						,[ActiveFlag]
				FROM	[music].[utbAuthors]
				ORDER BY [AuthorName]
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
