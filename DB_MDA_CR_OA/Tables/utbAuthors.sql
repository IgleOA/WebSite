CREATE TABLE [music].[utbAuthors]
(
	[AuthorID]		 INT           IDENTITY (1, 1) NOT NULL,
    [AuthorName]     VARCHAR (100) NOT NULL,
	[ProfileLink]	 VARCHAR (MAX) NULL,
    [ActiveFlag]     BIT           CONSTRAINT [utbAuthorsDefaultActiveFlagTrue] DEFAULT ((1)) NOT NULL,
    [InsertDate]     DATETIME      CONSTRAINT [utbAuthorsDefaultInsertDateSysDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [InsertUser]     VARCHAR (100) CONSTRAINT [utbAuthorsDefaultInsertUserSuser_Sname] DEFAULT (suser_sname()) NOT NULL,
    [LastModifyDate] DATETIME      CONSTRAINT [utbAuthorsDefaultLastModifyDateSysDateTime] DEFAULT (sysdatetime()) NOT NULL,
    [LastModifyUser] VARCHAR (100) CONSTRAINT [utbAuthorsDefaultLastModifyUserSuser_Sname] DEFAULT (suser_sname()) NOT NULL,
    CONSTRAINT [utbAuthorID] PRIMARY KEY CLUSTERED ([AuthorID] ASC)
);


GO
CREATE TRIGGER [music].[utrLogAuthors] ON [music].[utbAuthors]
FOR INSERT,UPDATE
AS
	BEGIN
		DECLARE @INSERTUPDATE VARCHAR(30)
		DECLARE @StartValues	XML = (SELECT * FROM Deleted [Values] for xml AUTO, ELEMENTS XSINIL)
		DECLARE @EndValues		XML = (SELECT * FROM Inserted [Values] for xml AUTO, ELEMENTS XSINIL)

		CREATE TABLE #DBCC (EventType varchar(50), Parameters varchar(50), EventInfo nvarchar(max))

		INSERT INTO #DBCC
		EXEC ('DBCC INPUTBUFFER(@@SPID)')

		--Assume it is an insert
		SET @INSERTUPDATE ='INSERT'
		--If there's data in deleted, it's an update
		IF EXISTS(SELECT * FROM Deleted)
		  SET @INSERTUPDATE='UPDATE'

		INSERT INTO [adm].[utbLogActivities] ([ActivityType],[TargetTable],[SQLStatement],[StartValues],[EndValues],[User],[LogActivityDate])
		SELECT	@INSERTUPDATE
				,'[music].[utbAuthors]'
				,(SELECT EventInfo FROM #DBCC)
				,@StartValues
				,@EndValues
				,[LastModifyUser]
				,GETDATE()
		FROM Inserted
	END;


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Esta tabla contiene la informacion de todos los autores de canciones.', 
@level0type = N'SCHEMA', @level0name = N'music', 
@level1type = N'TABLE', @level1name = N'utbAuthors';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'ID del Autor.', 
@level0type = N'SCHEMA', @level0name = N'music', 
@level1type = N'TABLE', @level1name = N'utbAuthors', 
@level2type = N'COLUMN', @level2name = N'AuthorID';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Nombre del autor.', 
@level0type = N'SCHEMA', @level0name = N'music', 
@level1type = N'TABLE', @level1name = N'utbAuthors', 
@level2type = N'COLUMN', @level2name = N'AuthorName';			 


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Link del perfil del autor.', 
@level0type = N'SCHEMA', @level0name = N'music', 
@level1type = N'TABLE', @level1name = N'utbAuthors', 
@level2type = N'COLUMN', @level2name = N'ProfileLink';	


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Este flag indica si el tipo de documento esta activo o no.', 
@level0type = N'SCHEMA', @level0name = N'music', 
@level1type = N'TABLE', @level1name = N'utbAuthors', 
@level2type = N'COLUMN', @level2name = N'ActiveFlag';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Fecha de inserción del autor.', 
@level0type = N'SCHEMA', @level0name = N'music',
@level1type = N'TABLE', @level1name = N'utbAuthors', 
@level2type = N'COLUMN', @level2name = N'InsertDate';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description',
@value = N'Usuario que inserto el autor.', 
@level0type = N'SCHEMA', @level0name = N'music', 
@level1type = N'TABLE', @level1name = N'utbAuthors', 
@level2type = N'COLUMN', @level2name = N'InsertUser';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Fecha de la ultima modificación realizada sobre el autor.', 
@level0type = N'SCHEMA', @level0name = N'music', 
@level1type = N'TABLE', @level1name = N'utbAuthors', 
@level2type = N'COLUMN', @level2name = N'LastModifyDate';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Nombre del usuario que realizo la ultima modificación sobre el autor.', 
@level0type = N'SCHEMA', @level0name = N'music', 
@level1type = N'TABLE', @level1name = N'utbAuthors', 
@level2type = N'COLUMN', @level2name = N'LastModifyUser';

