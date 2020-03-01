-- ======================================================================
-- Name: [ministry].[uspAddPreach]
-- Desc: Se utiliza para la agregar nuevas predicas
-- Auth: Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date: 12/13/2019
-------------------------------------------------------------
-- Change History
-------------------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		-----------------------------
-- ======================================================================

CREATE PROCEDURE [ministry].[uspAddPreach]
	@InsertUser		VARCHAR(50),
	@MinisterID		INT,
	@Title			VARCHAR(200),
	@Description	VARCHAR(MAX) = NULL,
	@Tags			VARCHAR(MAX) = NULL,
	@FileData		VARBINARY(MAX),
	@FileType		VARCHAR(10),
	@Date			DATE
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
				INSERT INTO [ministry].[utbPreaches] ([MinisterID],[Title],[Description],[Tags],[FileData],[FileType],[PreachingDate],[InsertUser],[LastModifyUser])
				VALUES (@MinisterID,@Title,@Description,@Tags,@FileData,@FileType,@Date,@InsertUser,@InsertUser)
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
