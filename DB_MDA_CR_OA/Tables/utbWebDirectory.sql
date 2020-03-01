CREATE TABLE [adm].[utbWebDirectory]
(
	[WebID]				INT				IDENTITY (1, 1) NOT NULL,
	[ApplicationID]		INT				NOT NULL,
    [WebName]			VARCHAR (50)	NOT NULL,
    [MainClass]			VARCHAR (50)	NOT NULL,
	[MainOrder]			INT				NULL,
    [Controller]		VARCHAR (50)	NOT NULL,
    [ViewPage]			VARCHAR (50)	NOT NULL,
    [Parameter]			VARCHAR (50)	NULL,
	[Order]				INT				NOT NULL,
    [ActiveFlag]		BIT				CONSTRAINT [utbWebDirectoryDefaultActiveFlagIsTrue] DEFAULT ((1)) NOT NULL,
    [CreationDate]		DATETIME		CONSTRAINT [utbWebDirectoryDefaultCreationDateSysDatetime] DEFAULT (sysdatetime()) NOT NULL,
    [CreationUser]		VARCHAR (100)	CONSTRAINT [utbWebDirectoryDefaultCreationUserSuser_Sname] DEFAULT (suser_sname()) NOT NULL,
    [LastModifyDate]	DATETIME		CONSTRAINT [utbWebDirectoryDefaultLastModifyDatesysdatetime] DEFAULT (sysdatetime()) NOT NULL,
    [LastModifyUser]	VARCHAR (100)	CONSTRAINT [utbWebDirectoryDefaultLastModifyUsersuser_sname] DEFAULT (suser_sname()) NOT NULL,
    CONSTRAINT [utbWebID] PRIMARY KEY CLUSTERED ([WebID] ASC),
	CONSTRAINT [fk.adm.utbWebDirectory.adm.AppDirectory.ApplicationID] FOREIGN KEY ([ApplicationID]) REFERENCES [adm].[utbAppDirectory] ([ApplicationID])
);
GO

CREATE TRIGGER [adm].[utrLogWebDirectory] ON [adm].[utbWebDirectory]
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
				,'[adm].[utbWebDirectory]'
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
@value = N'Esta tabla contiene metadata de los diferente sites que hay dentro de una applicacion.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbWebDirectory';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'ID de identidad.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbWebDirectory', 
@level2type = N'COLUMN', @level2name = N'WebID';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'ID de identificació a la que pertenece la pagina.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbWebDirectory', 
@level2type = N'COLUMN', @level2name = N'ApplicationID';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Nombre que se desplegara la página.', 
@level0type = N'SCHEMA', 
@level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbWebDirectory', 
@level2type = N'COLUMN', @level2name = N'WebName';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Nombre de la clase principal a la que pertenece esta página.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbWebDirectory', 
@level2type = N'COLUMN', @level2name = N'MainClass';

GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Orden de la clase primaria.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbWebDirectory', 
@level2type = N'COLUMN', @level2name = N'MainOrder';

GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Nombre del controlador a la que pertenece.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbWebDirectory',
@level2type = N'COLUMN', @level2name = N'Controller';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Nombre de la vista a que pertenece.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbWebDirectory', 
@level2type = N'COLUMN', @level2name = N'ViewPage';



GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Valor del parametro en caso de que la pagina lo necesite.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbWebDirectory', 
@level2type = N'COLUMN', @level2name = N'Parameter';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Valor que determina el orden en que deben aparecer los links.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbWebDirectory', 
@level2type = N'COLUMN', @level2name = N'Order';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Este flag es usado para identificar si la pagina esta active o no.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbWebDirectory', 
@level2type = N'COLUMN', @level2name = N'ActiveFlag';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Fecha de creation del registro.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbWebDirectory', 
@level2type = N'COLUMN', @level2name = N'CreationDate';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Usuario que inserto el registro.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbWebDirectory', 
@level2type = N'COLUMN', @level2name = N'CreationUser';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Fecha de la última modificación sobre el registro.', 
@level0type = N'SCHEMA', @level0name = N'adm',
@level1type = N'TABLE', @level1name = N'utbWebDirectory', 
@level2type = N'COLUMN', @level2name = N'LastModifyDate';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Usuario que realizo la última modificación del registro.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbWebDirectory', 
@level2type = N'COLUMN', @level2name = N'LastModifyUser';


