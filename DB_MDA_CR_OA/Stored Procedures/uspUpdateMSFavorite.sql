-- ======================================================================
-- Name: [music].[uspUpdateMSFavorite]
-- Desc: Se utiliza para cambiar si una cancion es favorita o no
-- Auth: Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date: 4/16/2019
-------------------------------------------------------------
-- Change History
-------------------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		-----------------------------
-- ======================================================================

CREATE PROCEDURE [music].[uspUpdateMSFavorite]
	@User	VARCHAR(50),
	@MSID	INT
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
				DECLARE @UserID	INT	=	(SELECT [UserID]
										 FROM	[adm].[utbUsers]
										 WHERE	[UserName] = @User)

				DECLARE @MSFavoriteID	INT 
				DECLARE @ActiveFlag		BIT

				SELECT	@MSFavoriteID	=	[MSFavoriteID]
						,@ActiveFlag	=	[ActiveFlag]
				FROM	[music].[utbMSFavoritesbyUser]
				WHERE	[UserID] = @UserID
						AND [MSID] = @MSID

				IF(@MSFavoriteID IS NULL)
					BEGIN
						INSERT INTO [music].[utbMSFavoritesbyUser] ([MSID],[UserID],[CreationUser],[LastModifyUser])
						VALUES (@MSID,@UserID,@User,@User)
					END
				ELSE
					BEGIN
						IF(@ActiveFlag = 1)
							BEGIN
								UPDATE	[music].[utbMSFavoritesbyUser]
								SET		[ActiveFlag]		=	0
										,[LastModifyDate]	=	GETDATE()
										,[LastModifyUser]	=	@User
								WHERE	[MSFavoriteID]		=	@MSFavoriteID
							END
						ELSE
							BEGIN
								UPDATE	[music].[utbMSFavoritesbyUser]
								SET		[ActiveFlag]		=	1
										,[LastModifyDate]	=	GETDATE()
										,[LastModifyUser]	=	@User
								WHERE	[MSFavoriteID]		=	@MSFavoriteID
							END
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
