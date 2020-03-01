-- ======================================================================
-- Name: [music].[uspReadMusicSheetsbySong]
-- Desc: Muestra las partituras de una cancion en especifico
-- Auth: Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date: 4/14/2019
-------------------------------------------------------------
-- Change History
-------------------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		-----------------------------
-- ======================================================================

CREATE PROCEDURE [music].[uspReadMusicSheetsbySong]
	@SongID	INT,
	@User	VARCHAR(50)
AS 
    BEGIN
        SET NOCOUNT ON
        BEGIN TRY
            DECLARE @lErrorMessage NVARCHAR(4000)
            DECLARE @lErrorSeverity INT
            DECLARE @lErrorState INT

            -- =======================================================
				DECLARE	@UserID	INT	=	(SELECT [UserID]
										 FROM	[adm].[utbUsers]
										 WHERE	[UserName] = @User)

				SELECT	MS.[MSID]
						,MS.[MSTypeID]
						,MS.[SongID]
						,[Version]			=	CASE WHEN MS.[Version] IS NULL THEN 'NV' ELSE '"' + MS.[Version] + '"' END
						,MS.[InstrumentID]
						,MS.[Tonality]
						,MS.[FileName]
						,MS.[FileData]
						,MS.[ActiveFlag]
						,[Favorite]			=	CASE WHEN F.[MSFavoriteID] IS NOT NULL THEN 1 ELSE 0 END
				FROM	[music].[utbMusicSheets] MS
						LEFT JOIN [music].[utbMSFavoritesbyUser] F ON F.[MSID] = MS.[MSID] 
																	AND F.[UserID] = @UserID 
																	AND F.[ActiveFlag] = 1
				WHERE	MS.[SongID] = @SongID
						AND MS.[ActiveFlag] = 1
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
