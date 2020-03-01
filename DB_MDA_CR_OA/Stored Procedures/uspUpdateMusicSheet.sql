-- ======================================================================
-- Name: [music].[uspUpdateMusicSheet]
-- Desc: Se utiliza para actualizar la información de una partitura
-- Auth: Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date: 4/16/2019
-------------------------------------------------------------
-- Change History
-------------------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		-----------------------------
-- ======================================================================

CREATE PROCEDURE [music].[uspUpdateMusicSheet]
	@InsertUser		VARCHAR(50),
	@MSID			INT,
	@MSTypeID		INT,
	@SongID			INT,
	@Version		VARCHAR(MAX),
	@InstrumentID	INT, 
	@Tonality		VARCHAR(10),
	@ActiveFlag		BIT
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
				UPDATE	[music].[utbMusicSheets]
				SET		[MSTypeID]	=	@MSTypeID,
						[SongID]	=	@SongID,
						[Version]	=	@Version,
						[InstrumentID]	=	@InstrumentID,
						[Tonality]		=	@Tonality,
						[ActiveFlag]	=	@ActiveFlag,
						[LastModifyUser]	=	@InsertUser,
						[LastModifyDate]	=	GETDATE()
				WHERE	[MSID]		=	@MSID

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
