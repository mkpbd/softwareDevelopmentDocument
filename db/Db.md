
```sql
USE [HMS]
GO

/****** Object:  Table [Account].[AccountGroups]    Script Date: 09/27/25 11:07:51 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Account].[AccountGroups](
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_AccountGroups] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [Account].[AccountGroups] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO

ALTER TABLE [Account].[AccountGroups] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO



```


```sql
USE [HMS]
GO

/****** Object:  Table [Account].[AttachedFileWithVouchers]    Script Date: 09/27/25 11:09:11 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Account].[AttachedFileWithVouchers](
	[Id] [uniqueidentifier] NOT NULL,
	[VoucherMasterId] [uniqueidentifier] NOT NULL,
	[FileContent] [varbinary](max) NULL,
	[FileExtension] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_AttachedFileWithVouchers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [Account].[AttachedFileWithVouchers] ADD  DEFAULT ((1)) FOR [TenantId]
GO

ALTER TABLE [Account].[AttachedFileWithVouchers]  WITH CHECK ADD  CONSTRAINT [FK_AttachedFileWithVouchers_VoucherMasters_VoucherMasterId] FOREIGN KEY([VoucherMasterId])
REFERENCES [Account].[VoucherMasters] ([Id])
ON DELETE CASCADE
GO

ALTER TABLE [Account].[AttachedFileWithVouchers] CHECK CONSTRAINT [FK_AttachedFileWithVouchers_VoucherMasters_VoucherMasterId]
GO

```

```sql
USE [HMS]
GO

/****** Object:  Table [Account].[Banks]    Script Date: 09/27/25 11:09:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Account].[Banks](
	[Id] [uniqueidentifier] NOT NULL,
	[BankName] [nvarchar](100) NOT NULL,
	[BranchAddress] [nvarchar](100) NULL,
	[ContactNo] [nvarchar](50) NULL,
	[AccountNo] [nvarchar](50) NOT NULL,
	[Signatories] [nvarchar](100) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_Banks] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [Account].[Banks] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO

```

```sql
USE [HMS]
GO

/****** Object:  Table [Account].[Categories]    Script Date: 09/27/25 11:10:18 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Account].[Categories](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CodeNo] [nvarchar](max) NULL,
	[NatueOfAccountId] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [Account].[Categories] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO

```

```sql
USE [HMS]
GO

/****** Object:  Table [Account].[COADescription]    Script Date: 09/27/25 11:10:59 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Account].[COADescription](
	[Name] [nvarchar](100) NOT NULL,
	[CodeNo] [nvarchar](50) NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_COADescription] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [Account].[COADescription] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO

ALTER TABLE [Account].[COADescription] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO

```


```sql
USE [HMS]
GO

/****** Object:  Table [Account].[Configuration]    Script Date: 09/27/25 11:12:12 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Account].[Configuration](
	[AcountType] [nvarchar](max) NULL,
	[AcountId] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Configuration] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [Account].[Configuration] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO

ALTER TABLE [Account].[Configuration] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO

```

```sql
USE [HMS]
GO

/****** Object:  Table [Account].[ConsultantGlobalLedgers]    Script Date: 09/27/25 11:12:51 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Account].[ConsultantGlobalLedgers](
	[Id] [uniqueidentifier] NOT NULL,
	[ConsultantId] [uniqueidentifier] NOT NULL,
	[TranDate] [datetime2](7) NOT NULL,
	[PatientId] [uniqueidentifier] NOT NULL,
	[InvoiceNo] [bigint] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Debit] [float] NOT NULL,
	[Credit] [float] NOT NULL,
	[Balance] [float] NOT NULL,
	[TenantId] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[ServiceUnitId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_ConsultantGlobalLedgers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [Account].[ConsultantGlobalLedgers] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO

ALTER TABLE [Account].[ConsultantGlobalLedgers] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ServiceUnitId]
GO

```


```sql
USE [HMS]
GO

/****** Object:  Table [Account].[CostCenters]    Script Date: 09/27/25 11:13:22 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Account].[CostCenters](
	[Id] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Name] [nvarchar](max) NULL,
 CONSTRAINT [PK_CostCenters] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [Account].[CostCenters]  WITH CHECK ADD  CONSTRAINT [FK_CostCenters_Tenants_TenantId] FOREIGN KEY([TenantId])
REFERENCES [Admin].[Tenants] ([Id])
ON DELETE CASCADE
GO

ALTER TABLE [Account].[CostCenters] CHECK CONSTRAINT [FK_CostCenters_Tenants_TenantId]
GO

```


```sql
USE [HMS]
GO
/****** Object:  Table [Account].[DueCollection]    Script Date: 09/27/25 11:14:21 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Account].[DueCollection](
	[Id] [uniqueidentifier] NOT NULL,
	[LoyalMemberId] [uniqueidentifier] NOT NULL,
	[StaffRecordId] [uniqueidentifier] NOT NULL,
	[Duedate] [datetime2](7) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[ReceivedAmount] [real] NOT NULL,
	[DueAmount] [real] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[Discount] [real] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
	[UserId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DueCollection] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [Account].[DueCollection] ADD  DEFAULT ('0001-01-01T00:00:00.0000000') FOR [Duedate]
GO

ALTER TABLE [Account].[DueCollection] ADD  DEFAULT (CONVERT([real],(0))) FOR [Discount]
GO

ALTER TABLE [Account].[DueCollection] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO

ALTER TABLE [Account].[DueCollection] ADD  DEFAULT ((1)) FOR [TenantId]
GO

ALTER TABLE [Account].[DueCollection] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [UserId]
GO

```


```sql
USE [HMS]
GO


/****** Object:  Table [Account].[FiscalYears]    Script Date: 09/27/25 11:15:48 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Account].[FiscalYears](
	[FYear] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_FiscalYears] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [Account].[FiscalYears] ADD  CONSTRAINT [DF_FiscalYears_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO

ALTER TABLE [Account].[FiscalYears] ADD  CONSTRAINT [DF_FiscalYears_IsDeleted]  DEFAULT ('False') FOR [IsDeleted]
GO

ALTER TABLE [Account].[FiscalYears] ADD  CONSTRAINT [DF_FiscalYears_IsSynced]  DEFAULT ('False') FOR [IsSynced]
GO

ALTER TABLE [Account].[FiscalYears] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO

```