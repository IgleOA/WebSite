CREATE TABLE [music].[utbMSFavoritesbyUser]
(
	[MSFavoriteID]	 INT           IDENTITY (1, 1) NOT NULL,
	[MSID]			 INT		   NOT NULL,
	[UserID]		 INT		   NOT NULL,
    [ActiveFlag]     BIT           CONSTRAINT [utbMSFavoritesbyUserDefaultActiveFlagIsTrue] DEFAULT ((1)) NOT NULL,
    [CreationDate]   DATETIME      CONSTRAINT [utbMSFavoritesbyUserDefaultCreationDateSysDatetime] DEFAULT (sysdatetime()) NOT NULL,
    [CreationUser]   VARCHAR (100) CONSTRAINT [utbMSFavoritesbyUserDefaultCreationUserSuser_Sname] DEFAULT (suser_sname()) NOT NULL,
    [LastModifyDate] DATETIME      CONSTRAINT [utbMSFavoritesbyUserDefaultLastModifyDatesysdatetime] DEFAULT (sysdatetime()) NOT NULL,
    [LastModifyUser] VARCHAR (100) CONSTRAINT [utbMSFavoritesbyUserDefaultLastModifyUsersuser_sname] DEFAULT (suser_sname()) NOT NULL,
    CONSTRAINT [utbMSFavoriteID] PRIMARY KEY CLUSTERED ([MSFavoriteID] ASC),
	CONSTRAINT [fk.music.utbMSFavoritesbyUsers.music.utbMusicSheets.MSID] FOREIGN KEY ([MSID]) REFERENCES [music].[utbMusicSheets] ([MSID]),
	CONSTRAINT [fk.music.utbMSFavoritesbyUsers.adm.utbUsers.UserID] FOREIGN KEY ([UserID]) REFERENCES [adm].[utbUsers] ([UserID])
);
GO

CREATE TRIGGER [music].[utrLogMSFavoritesbyUsers] ON [music].[utbMSFavoritesbyUser]
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
				,'[music].[utbMSFavoritesbyUser]'
				,(SELECT EventInfo FROM #DBCC)
				,@StartValues
				,@EndValues
				,[LastModifyUser]
				,GETDATE()
		FROM Inserted
	END

GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Esta tabla contiene metadata de las partituras favoritas de cada usuarion.', 
@level0type = N'SCHEMA', @level0name = N'music', 
@level1type = N'TABLE', @level1name = N'utbMSFavoritesbyUser';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'ID de identidad.', 
@level0type = N'SCHEMA', @level0name = N'music', 
@level1type = N'TABLE', @level1name = N'utbMSFavoritesbyUser', 
@level2type = N'COLUMN', @level2name = N'MSFavoriteID';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'ID de identidad de la partitura.', 
@level0type = N'SCHEMA', @level0name = N'music', 
@level1type = N'TABLE', @level1name = N'utbMSFavoritesbyUser', 
@level2type = N'COLUMN', @level2name = N'MSID';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'ID de identidad del usuario.', 
@level0type = N'SCHEMA', 
@level0name = N'music', 
@level1type = N'TABLE', @level1name = N'utbMSFavoritesbyUser', 
@level2type = N'COLUMN', @level2name = N'UserID';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Este flag es usado para identificar si el favorito es activo o no.', 
@level0type = N'SCHEMA', @level0name = N'music', 
@level1type = N'TABLE', @level1name = N'utbMSFavoritesbyUser', 
@level2type = N'COLUMN', @level2name = N'ActiveFlag';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Fecha de creation del registro.', 
@level0type = N'SCHEMA', @level0name = N'music', 
@level1type = N'TABLE', @level1name = N'utbMSFavoritesbyUser', 
@level2type = N'COLUMN', @level2name = N'CreationDate';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Usuario que inserto el registro.', 
@level0type = N'SCHEMA', @level0name = N'music', 
@level1type = N'TABLE', @level1name = N'utbMSFavoritesbyUser', 
@level2type = N'COLUMN', @level2name = N'CreationUser';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Fecha de la última modificación sobre el registro.', 
@level0type = N'SCHEMA', @level0name = N'music',
@level1type = N'TABLE', @level1name = N'utbMSFavoritesbyUser', 
@level2type = N'COLUMN', @level2name = N'LastModifyDate';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Usuario que realizo la última modificación del registro.', 
@level0type = N'SCHEMA', @level0name = N'music', 
@level1type = N'TABLE', @level1name = N'utbMSFavoritesbyUser', 
@level2type = N'COLUMN', @level2name = N'LastModifyUser';

