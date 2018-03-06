
USE [FileListener]
GO

CREATE TABLE [dbo].[Action](
	[Id]            [tinyint] NULL,
	[Name]          [varchar](50) NULL
) ON [PRIMARY]
GO

INSERT [dbo].[Action] ([Id], [Name]) VALUES (0, N'None')
INSERT [dbo].[Action] ([Id], [Name]) VALUES (1, N'Copy')
INSERT [dbo].[Action] ([Id], [Name]) VALUES (2, N'Move')
INSERT [dbo].[Action] ([Id], [Name]) VALUES (3, N'Delete')
INSERT [dbo].[Action] ([Id], [Name]) VALUES (4, N'Zip')
INSERT [dbo].[Action] ([Id], [Name]) VALUES (5, N'UnZip')
INSERT [dbo].[Action] ([Id], [Name]) VALUES (6, N'Zip with Password')
INSERT [dbo].[Action] ([Id], [Name]) VALUES (7, N'UnZip with Password')
INSERT [dbo].[Action] ([Id], [Name]) VALUES (8, N'Encrypt with Password')
INSERT [dbo].[Action] ([Id], [Name]) VALUES (9, N'Decrypt with Password')

Id   Name
---- --------------------------------------------------
0    None
1    Copy
2    Move/Change
3    Delete
4    Zip
5    UnZip
6    Zip with Password
7    UnZip with Password
8    Encrypt with Password
9    Decrypt with Password


/****** Object:  Table [dbo].[WatchTask]    Script Date: 3/5/2018 7:35:43 PM ******/
CREATE TABLE [dbo].[WatchTask](
	[Id]                [int] NOT NULL,
	[Name]              [varchar](50) NULL,
	[Sequence]          [tinyint] NULL,
	[JobId]             [int] NULL,
	[WatchPattern]      [varchar](100) NULL,
	[ActionId]          [tinyint] NULL,
	[IsMultiple]        [bit] NULL,
	[TargetPath]        [varchar](100) NULL,
	[TargetFileName]    [varbinary](50) NULL,
	[TargetFileExtension] [varchar](50) NULL,
	[EMail]             [varchar](50) NULL,
	[EMailGroupId]      [smallint] NULL,
	[StatusNotify]      [bit] NULL,
	[ResultNotify]      [bit] NULL,
 CONSTRAINT [PK_WatchTask] PRIMARY KEY CLUSTERED 
(	[Id] ASC    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[WatchJob]    Script Date: 3/5/2018 7:35:43 PM ******/
CREATE TABLE [dbo].[WatchJob](
	[Id]                [int] IDENTITY(1,1) NOT NULL,
	[Name]              [varchar](50) NULL,
	[Sequence]          [tinyint] NULL,
	[ProcessId]         [int] NULL,
	[GroupName]         [varchar](50) NULL,
	[GroupCondition]    [bit] NOT NULL,
	[EMail]             [varchar](50) NULL,
	[EMailGroupId]      [smallint] NULL,
	[StatusNotify]      [bit] NULL,
	[ResultNotify]      [bit] NULL,
 CONSTRAINT [PK_WatchJob] PRIMARY KEY CLUSTERED 
(	[Id] ASC )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[WatchProcess]    Script Date: 3/5/2018 7:35:43 PM ******/
CREATE TABLE [dbo].[WatchProcess](
	[Id]                [int] IDENTITY(1,1) NOT NULL,
	[Name]              [varchar](50) NULL,
	[Priority]          [tinyint] NULL,         0:Top Priority
	[OwnerId]           [int] NULL,
	[FolderPath]        [varchar](100) NULL,
 CONSTRAINT [PK_WatchProcess] PRIMARY KEY CLUSTERED 
(	[Id] ASC )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


/****** Object:  Table [dbo].[WatchOwner]    Script Date: 3/5/2018 7:35:43 PM ******/
CREATE TABLE [dbo].[WatchOwner](
	[Id]                [int] NOT NULL,
	[Name]              [varchar](50) NULL,
	[Description]       [varchar](100) NULL,
	[Grade]             [tinyint] NULL,         0:Administrator, 1:SuperUser, 
	[Group]             [varchar](50) NULL,
 CONSTRAINT [PK_WatchOwner] PRIMARY KEY CLUSTERED 
(	[Id] ASC )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


ALTER TABLE [dbo].[WatchJob]  WITH CHECK 
    ADD  CONSTRAINT [FK_WatchJob_WatchProcess] FOREIGN KEY([ProcessId])     REFERENCES [dbo].[WatchProcess] ([Id])
GO

ALTER TABLE [dbo].[WatchJob] CHECK CONSTRAINT [FK_WatchJob_WatchProcess]
GO

ALTER TABLE [dbo].[WatchProcess]  WITH CHECK 
    ADD  CONSTRAINT [FK_WatchProcess_WatchOwner] FOREIGN KEY([OwnerId])     REFERENCES [dbo].[WatchOwner] ([Id])
GO

ALTER TABLE [dbo].[WatchProcess] CHECK CONSTRAINT [FK_WatchProcess_WatchOwner]
GO

ALTER TABLE [dbo].[WatchTask]  WITH CHECK 
    ADD  CONSTRAINT [FK_WatchTask_WatchJob] FOREIGN KEY([JobId])            REFERENCES [dbo].[WatchJob] ([Id])
GO

ALTER TABLE [dbo].[WatchTask] CHECK CONSTRAINT [FK_WatchTask_WatchJob]
GO
ALTER TABLE [dbo].[WatchTask]  WITH CHECK 
    ADD  CONSTRAINT [FK_WatchTask_WatchTask] FOREIGN KEY([Id])              REFERENCES [dbo].[WatchTask] ([Id])
GO

ALTER TABLE [dbo].[WatchTask] CHECK CONSTRAINT [FK_WatchTask_WatchTask]
GO


/****** Object:  Table [dbo].[EMailAddress]    Script Date: 3/5/2018 11:17:06 PM ******/
CREATE TABLE [dbo].[EMailAddress] (
	[Id]                [int] NOT NULL,
	[EMailAddress]      [varchar](50) NULL,
	[NickName]          [varchar](50) NULL,
	[PrintName]         [varchar](50) NULL,
	[FirstName]         [varchar](50) NULL,
	[MiddleName]        [varchar](50) NULL,
	[LastName]          [varchar](50) NULL,
 CONSTRAINT [PK_EMail] PRIMARY KEY CLUSTERED 
(	[Id] ASC ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[EMailGroup]    Script Date: 3/5/2018 11:17:06 PM ******/
CREATE TABLE [dbo].[EMailGroup](
	[Id]                [int] NULL,
	[Name]              [varchar](50) NULL,
	[Description]       [varchar](100) NULL
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[EMailGroupList]    Script Date: 3/5/2018 11:17:06 PM ******/
CREATE TABLE [dbo].[EMailGroupList](
	[Id]                [int] IDENTITY(1,1) NOT NULL,
	[EMailGroupId]      [int] NOT NULL,
	[EMailAddressId]    [int] NOT NULL,
 CONSTRAINT [PK_EMailGroupList] PRIMARY KEY CLUSTERED 
(	[EMailGroupId] ASC,
	[EMailAddressId] ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

