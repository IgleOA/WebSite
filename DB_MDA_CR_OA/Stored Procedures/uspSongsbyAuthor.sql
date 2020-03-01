-- ======================================================================
-- Name: [music].[uspSongsbyAuthor]
-- Desc: Muestra el repertorio de canciones por author
-- Auth: Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date: 4/14/2019
-------------------------------------------------------------
-- Change History
-------------------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		-----------------------------
-- ======================================================================

CREATE PROCEDURE [music].[uspSongsbyAuthor]
	@AuthorID	INT
AS 
    BEGIN
        SET NOCOUNT ON
        BEGIN TRY
            DECLARE @lErrorMessage NVARCHAR(4000)
            DECLARE @lErrorSeverity INT
            DECLARE @lErrorState INT

            -- =======================================================
				SELECT	[SongID]
						,[SongName]
						,[AuthorID]
				FROM	[music].[utbSongs]
				WHERE	[AuthorID] = @AuthorID
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
