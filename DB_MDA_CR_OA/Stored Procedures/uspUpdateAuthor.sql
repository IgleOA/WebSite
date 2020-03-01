-- ======================================================================
-- Name: [music].[uspUpdateAuthor]
-- Desc: Se utiliza para editar la información de un autor
-- Auth: Jonathan Piedra jonitapc_quimind@hotmail.com
-- Date: 4/12/2019
-------------------------------------------------------------
-- Change History
-------------------------------------------------------------
-- CI	Date		Author		Description
-- --	----		------		-----------------------------
-- ======================================================================

CREATE PROCEDURE [music].[uspUpdateAuthor]
	@InsertUser		VARCHAR(50),
	@AuthorID		INT,
	@AuthorName		VARCHAR(50),
	@ProfileLink	VARCHAR(MAX)	=	NULL
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
				UPDATE	[music].[utbAuthors] 
				SET		[AuthorName]		=	@AuthorName
						,[ProfileLink]		=	@ProfileLink
						,[LastModifyUser]	=	@InsertUser
				WHERE	[AuthorID]			=	@AuthorID
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
