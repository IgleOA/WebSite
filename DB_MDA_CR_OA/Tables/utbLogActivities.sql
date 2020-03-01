CREATE TABLE [adm].[utbLogActivities] (
    [ActivityID]      INT           IDENTITY (1, 1) NOT NULL,
    [ActivityType]    VARCHAR (50)  NOT NULL,
    [TargetTable]     VARCHAR (100) NOT NULL,
    [SQLStatement]    VARCHAR (MAX) NOT NULL,
    [StartValues]     XML           NULL,
    [EndValues]       XML           NOT NULL,
    [User]            VARCHAR (100) CONSTRAINT [utbLogActivitiesDefaultUserSuser_Sname] DEFAULT (suser_sname()) NOT NULL,
    [LogActivityDate] DATETIME      CONSTRAINT [utbLogActivitiesDefaultLogActivityDateSysDateTime] DEFAULT (sysdatetime()) NOT NULL,
    CONSTRAINT [ubtActivityID] PRIMARY KEY CLUSTERED ([ActivityID] ASC)
);


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Esta tabla contiene toda la informacion sobre los cambios realizados en las diferentes tablas de la base de datos.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbLogActivities';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Numero de unico del cambio.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbLogActivities',
@level2type = N'COLUMN', @level2name = N'ActivityID';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Tipo de cambio realizado (INSERT, UPDATE, DELETE).', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbLogActivities', 
@level2type = N'COLUMN', @level2name = N'ActivityType';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Nombre de la tabla sobre la cual se realizo el cambio.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbLogActivities', 
@level2type = N'COLUMN', @level2name = N'TargetTable';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description',
@value = N'SQL Statement (Query o SP) que se utilizo para realizar el cambio.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbLogActivities', 
@level2type = N'COLUMN', @level2name = N'SQLStatement';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Datos iniciales antes del cambio, aplica solo para UPDATE o DELETE.',
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbLogActivities', 
@level2type = N'COLUMN', @level2name = N'StartValues';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Datos despues del cambio.',
@level0type = N'SCHEMA', @level0name = N'adm',
@level1type = N'TABLE', @level1name = N'utbLogActivities', 
@level2type = N'COLUMN', @level2name = N'EndValues';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Usuario que realizo la actividad.',
@level0type = N'SCHEMA', @level0name = N'adm',
@level1type = N'TABLE', @level1name = N'utbLogActivities', 
@level2type = N'COLUMN', @level2name = N'User';


GO
EXECUTE sp_addextendedproperty 
@name = N'MS_Description', 
@value = N'Fecha en que se realizo el cambio.', 
@level0type = N'SCHEMA', @level0name = N'adm', 
@level1type = N'TABLE', @level1name = N'utbLogActivities', 
@level2type = N'COLUMN', @level2name = N'LogActivityDate';

