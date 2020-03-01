-- ======================================================================
-- Name: [music].[uspAddMusicSheet]
-- Desc: Se utiliza para la agregar documentos
-- Auth: Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date: 3/29/2019
-------------------------------------------------------------
-- Change History
-------------------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		-----------------------------
-- ======================================================================

CREATE PROCEDURE [music].[uspAddMusicSheet]
	@InsertUser		VARCHAR(50),
	@MSTypeID		INT,
	@SongID			INT,
	@Version		VARCHAR(MAX),
	@InstrumentID	INT, 
	@Tonality		VARCHAR(10),
	@FileName		VARCHAR(100),
	@FileData		VARBINARY(MAX)
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
				INSERT INTO [music].[utbMusicSheets] ([MSTypeID],[SongID],[Version],[InstrumentID],[Tonality],[FileName],[FileData],[ActiveFlag],[InsertUser],[LastModifyUser])
				VALUES (@MSTypeID,@SongID,@Version,@InstrumentID,@Tonality,@FileName,@FileData,1,@InsertUser,@InsertUser)
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
