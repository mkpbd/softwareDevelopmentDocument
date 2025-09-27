
```sql
USE [HMS]
GO
/****** Object:  Table [Account].[AccountGroups]    Script Date: 09/27/25 11:19:26 AM ******/
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
/****** Object:  Table [Account].[AttachedFileWithVouchers]    Script Date: 09/27/25 11:19:26 AM ******/
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
/****** Object:  Table [Account].[Banks]    Script Date: 09/27/25 11:19:26 AM ******/
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
/****** Object:  Table [Account].[Categories]    Script Date: 09/27/25 11:19:26 AM ******/
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
/****** Object:  Table [Account].[COADescription]    Script Date: 09/27/25 11:19:26 AM ******/
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
/****** Object:  Table [Account].[Configuration]    Script Date: 09/27/25 11:19:26 AM ******/
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
/****** Object:  Table [Account].[ConsultantGlobalLedgers]    Script Date: 09/27/25 11:19:26 AM ******/
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
/****** Object:  Table [Account].[CostCenters]    Script Date: 09/27/25 11:19:26 AM ******/
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
/****** Object:  Table [Account].[DueCollection]    Script Date: 09/27/25 11:19:26 AM ******/
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
/****** Object:  Table [Account].[FiscalYears]    Script Date: 09/27/25 11:19:26 AM ******/
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
/****** Object:  Table [Account].[FSLI]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Account].[FSLI](
	[Name] [nvarchar](100) NOT NULL,
	[CodeNo] [nvarchar](50) NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_FSLI] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Account].[GeneralLedgers]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Account].[GeneralLedgers](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Level5HeadId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[BankCashOth] [nvarchar](max) NULL,
	[GLCodeNo] [nvarchar](max) NULL,
	[IsActive] [bit] NOT NULL,
	[IsControlAccount] [bit] NOT NULL,
	[IsCostCenter] [bit] NOT NULL,
	[IsRecurringCost] [bit] NOT NULL,
	[IsBillingContainDetails] [bit] NOT NULL,
	[ReportAndSpId] [uniqueidentifier] NOT NULL,
	[COADescriptionId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_GeneralLedgers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Account].[GLItemDescription]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Account].[GLItemDescription](
	[Name] [nvarchar](250) NOT NULL,
	[CodeNo] [nvarchar](50) NOT NULL,
	[SubCategoryId] [uniqueidentifier] NOT NULL,
	[COADescriptionId] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[FSLIId] [uniqueidentifier] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_GLItemDescription] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Account].[GLMappingWithStatements]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Account].[GLMappingWithStatements](
	[Id] [uniqueidentifier] NOT NULL,
	[GeneralLedgerId] [uniqueidentifier] NOT NULL,
	[StatementSubHeadId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_GLMappingWithStatements] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Account].[HISandDiagMediaPaymentRecordDetails]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Account].[HISandDiagMediaPaymentRecordDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[HISandDiagMediaPaymentRecordId] [uniqueidentifier] NOT NULL,
	[PatientId] [uniqueidentifier] NOT NULL,
	[PaidAmount] [float] NOT NULL,
	[PatientGroup] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Commission] [float] NOT NULL,
	[PatientName] [nvarchar](max) NULL,
	[TestOrServiceName] [nvarchar](max) NULL,
	[TotalCost] [float] NOT NULL,
	[BillNo] [bigint] NOT NULL,
 CONSTRAINT [PK_HISandDiagMediaPaymentRecordDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Account].[HISandDiagMediaPaymentRecords]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Account].[HISandDiagMediaPaymentRecords](
	[Id] [uniqueidentifier] NOT NULL,
	[MarketingJOfficerOrMediaId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[InvoiceNo] [bigint] NOT NULL,
	[PaymentDate] [datetime2](7) NOT NULL,
	[Addition] [float] NOT NULL,
	[Deduction] [float] NOT NULL,
	[Remarks] [nvarchar](max) NULL,
	[Discount] [float] NOT NULL,
 CONSTRAINT [PK_HISandDiagMediaPaymentRecords] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Account].[IPDPatientGlobalLedgers]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Account].[IPDPatientGlobalLedgers](
	[Id] [uniqueidentifier] NOT NULL,
	[TranDate] [datetime2](7) NOT NULL,
	[IPDPatientId] [uniqueidentifier] NOT NULL,
	[DoctorId] [uniqueidentifier] NOT NULL,
	[ServiceId] [int] NOT NULL,
	[Particulars] [nvarchar](max) NULL,
	[Debit] [float] NOT NULL,
	[Credit] [float] NOT NULL,
	[Balance] [float] NOT NULL,
	[TransactionType] [nvarchar](max) NULL,
	[TenantId] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[ServiceUnitId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_IPDPatientGlobalLedgers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Account].[JournalTypes]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Account].[JournalTypes](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[ShortName] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_JournalTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Account].[Level4Heads]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Account].[Level4Heads](
	[Id] [uniqueidentifier] NOT NULL,
	[SubCategoryId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_Level4Heads] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Account].[Level5Heads]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Account].[Level5Heads](
	[Id] [uniqueidentifier] NOT NULL,
	[Level4HeadId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_Level5Heads] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Account].[LoyalMemberLedgers]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Account].[LoyalMemberLedgers](
	[Id] [uniqueidentifier] NOT NULL,
	[Particulars] [nvarchar](max) NULL,
	[Debit] [real] NOT NULL,
	[Credit] [real] NOT NULL,
	[Balance] [real] NOT NULL,
	[TransactionType] [nvarchar](max) NULL,
	[LoyalMemberId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[InvoiceNo] [bigint] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Invdate] [datetime2](7) NULL,
 CONSTRAINT [PK_LoyalMemberLedgers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Account].[LoyalMembers]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Account].[LoyalMembers](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[MobileNo] [nvarchar](max) NULL,
	[Address] [nvarchar](max) NULL,
	[ReferranceName] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_LoyalMembers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Account].[MainSubAccountsRelations]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Account].[MainSubAccountsRelations](
	[Glid] [uniqueidentifier] NOT NULL,
	[GroupId] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_MainSubAccountsRelations] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Account].[MasterStatements]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Account].[MasterStatements](
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_MasterStatements] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Account].[NatureOfAccounts]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Account].[NatureOfAccounts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CodeNo] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[MasterStatementId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_NatureOfAccounts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Account].[POSTerminals]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Account].[POSTerminals](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](100) NULL,
	[BankAccountId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_POSTerminals] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Account].[RadiologicalReportingFeePaymentRecordDetails]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Account].[RadiologicalReportingFeePaymentRecordDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[RadiologicalReportingFeePaymentRecordId] [uniqueidentifier] NOT NULL,
	[PatientId] [uniqueidentifier] NOT NULL,
	[TestItemId] [uniqueidentifier] NOT NULL,
	[PaidAmount] [float] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[ReportingFee] [float] NOT NULL,
	[TestName] [nvarchar](max) NULL,
	[BillNo] [bigint] NOT NULL,
	[PatientName] [nvarchar](max) NULL,
 CONSTRAINT [PK_RadiologicalReportingFeePaymentRecordDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Account].[RadiologicalReportingFeePaymentRecords]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Account].[RadiologicalReportingFeePaymentRecords](
	[Id] [uniqueidentifier] NOT NULL,
	[DoctorId] [uniqueidentifier] NOT NULL,
	[InvoiceNo] [bigint] NOT NULL,
	[PaymentDate] [datetime2](7) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Addition] [float] NOT NULL,
	[Deduction] [float] NOT NULL,
	[Remarks] [nvarchar](max) NULL,
 CONSTRAINT [PK_RadiologicalReportingFeePaymentRecords] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Account].[StatementBroadHeads]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Account].[StatementBroadHeads](
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_StatementBroadHeads] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Account].[StatementSubHeads]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Account].[StatementSubHeads](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[StatementBroadHeadId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_StatementSubHeads] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Account].[SubCategories]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Account].[SubCategories](
	[Id] [uniqueidentifier] NOT NULL,
	[CategoryId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_SubCategories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Account].[SubLedgers]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Account].[SubLedgers](
	[Id] [uniqueidentifier] NOT NULL,
	[SubLedgerTypeId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Address] [nvarchar](max) NULL,
	[MobileNo] [nvarchar](max) NULL,
	[EmailAddress] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[InvoiceId] [uniqueidentifier] NOT NULL,
	[InvoiceNo] [bigint] NOT NULL,
	[SupplierId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_SubLedgers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Account].[SubLedgerTypes]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Account].[SubLedgerTypes](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_SubLedgerTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Account].[SupplierGlobalLedgers]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Account].[SupplierGlobalLedgers](
	[Id] [uniqueidentifier] NOT NULL,
	[SupplierId] [uniqueidentifier] NOT NULL,
	[Particulars] [nvarchar](max) NULL,
	[Debit] [real] NOT NULL,
	[Credit] [real] NOT NULL,
	[Balance] [real] NOT NULL,
	[TransactionType] [nvarchar](max) NULL,
	[ServiceId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[ServiceUnitId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_SupplierGlobalLedgers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Account].[VoucherMasterDetails]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Account].[VoucherMasterDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[VoucherMasterId] [uniqueidentifier] NOT NULL,
	[GeneralLedgerId] [uniqueidentifier] NOT NULL,
	[CostCenterId] [uniqueidentifier] NOT NULL,
	[SubLedgerTypeId] [uniqueidentifier] NOT NULL,
	[SubLedgerId] [uniqueidentifier] NOT NULL,
	[Debit] [float] NOT NULL,
	[Credit] [float] NOT NULL,
	[Narration] [nvarchar](max) NULL,
	[SeriveId] [uniqueidentifier] NOT NULL,
	[CheqDate] [datetime2](7) NULL,
	[CheqNo] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[ServiceUnitId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_VoucherMasterDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Account].[VoucherMasters]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Account].[VoucherMasters](
	[Id] [uniqueidentifier] NOT NULL,
	[VoucherNo] [nvarchar](max) NULL,
	[PostingDate] [datetime2](7) NOT NULL,
	[JournalTypeId] [uniqueidentifier] NOT NULL,
	[Note] [nvarchar](max) NULL,
	[PaidTo] [int] NOT NULL,
	[TenantId] [int] NOT NULL,
	[VoucherMode] [nvarchar](max) NULL,
	[ReferenceId] [uniqueidentifier] NOT NULL,
	[IsReversal] [bit] NOT NULL,
	[DocumentDate] [datetime2](7) NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[VoucherDate] [datetime2](7) NOT NULL,
	[ReferenceTypeId] [int] NOT NULL,
	[ServiceUnitId] [uniqueidentifier] NOT NULL,
	[FYearId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_VoucherMasters] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Account].[VoucherTypes]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Account].[VoucherTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TypeCode] [nvarchar](max) NULL,
	[TypeTitle] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_VoucherTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Admin].[Countries]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admin].[Countries](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nationality] [nvarchar](max) NULL,
	[ShortCode] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[CountryName] [nvarchar](max) NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_Countries] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Admin].[Departments]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admin].[Departments](
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Departments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Admin].[DiscountCategories]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admin].[DiscountCategories](
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[DepartmentId] [uniqueidentifier] NOT NULL,
	[DiscountInParcent] [float] NOT NULL,
 CONSTRAINT [PK_DiscountCategories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Admin].[DiscountRestrictions]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admin].[DiscountRestrictions](
	[Id] [uniqueidentifier] NOT NULL,
	[RoleId] [uniqueidentifier] NOT NULL,
	[DepartmentId] [uniqueidentifier] NOT NULL,
	[DiscountPercent] [float] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[LastModifiedOn] [datetime2](7) NULL,
 CONSTRAINT [PK_Admin.DiscountRestrictions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Admin].[EditorMargins]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admin].[EditorMargins](
	[MLeft] [nvarchar](max) NULL,
	[MRight] [nvarchar](max) NULL,
	[MTop] [nvarchar](max) NULL,
	[MBottom] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_EditorMargins] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Admin].[EditorShorkeys]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admin].[EditorShorkeys](
	[Code] [nvarchar](max) NULL,
	[Value] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_EditorShorkeys] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Admin].[IndentStores]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admin].[IndentStores](
	[Id] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NOT NULL,
	[IndentNo] [bigint] NOT NULL,
	[ServiceUnitId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedDate] [datetime] NULL,
	[CreatedBy] [uniqueidentifier] NULL,
	[LastModifiedBy] [uniqueidentifier] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[IndentNo] ASC,
	[ServiceUnitId] ASC,
	[TenantId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[IndentNo] ASC,
	[ServiceUnitId] ASC,
	[TenantId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[IndentNo] ASC,
	[ServiceUnitId] ASC,
	[TenantId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admin].[InvestigationEntryPageControls]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admin].[InvestigationEntryPageControls](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ControlId] [nvarchar](max) NULL,
	[IsGridOrListView] [bit] NOT NULL,
	[IsVisible] [bit] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_InvestigationEntryPageControls] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Admin].[InvoiceStores]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admin].[InvoiceStores](
	[Id] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NOT NULL,
	[InvoiceNo] [bigint] NOT NULL,
	[ServiceUnitId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedDate] [datetime] NULL,
	[CreatedBy] [uniqueidentifier] NULL,
	[LastModifiedBy] [uniqueidentifier] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[InvoiceNo] ASC,
	[ServiceUnitId] ASC,
	[TenantId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[InvoiceNo] ASC,
	[ServiceUnitId] ASC,
	[TenantId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[InvoiceNo] ASC,
	[ServiceUnitId] ASC,
	[TenantId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Admin].[IPDAdmissionpageControls]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admin].[IPDAdmissionpageControls](
	[ControlId] [nvarchar](max) NULL,
	[IsVisible] [bit] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_IPDAdmissionpageControls] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Admin].[LabNoStores]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admin].[LabNoStores](
	[Id] [uniqueidentifier] NULL,
	[InvoiceId] [uniqueidentifier] NULL,
	[TestItemId] [uniqueidentifier] NULL,
	[TestSampleId] [uniqueidentifier] NULL,
	[LabNo] [int] NULL,
	[TenantId] [int] NULL,
	[PathologicalMachineGroupId] [uniqueidentifier] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Admin].[PaymentChannels]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admin].[PaymentChannels](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[PaymentModeId] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_PaymentChannels] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Admin].[PaymentModes]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admin].[PaymentModes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_PaymentModes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Admin].[Printers]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admin].[Printers](
	[Id] [uniqueidentifier] NOT NULL,
	[PrinterName] [nvarchar](max) NULL,
	[UseArea] [nvarchar](max) NULL,
	[PageSize] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_Printers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Admin].[ProjectMenus]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admin].[ProjectMenus](
	[Name] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[NavigationPage] [nvarchar](max) NULL,
	[DisplayOrder] [int] NOT NULL,
	[IsActive] [int] NOT NULL,
	[MenuIcon] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[LandingPageIconUrl] [nvarchar](max) NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[ParentId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_ProjectMenus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Admin].[ServeTypes]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admin].[ServeTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_ServeTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Admin].[ServiceUnits]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admin].[ServiceUnits](
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
	[DepartmentId] [uniqueidentifier] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_ServiceUnits] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Admin].[Tenants]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admin].[Tenants](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Address] [nvarchar](max) NULL,
	[HotLine] [nvarchar](max) NULL,
	[Logo] [varbinary](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[BranchId] [int] NOT NULL,
	[Logo2] [varbinary](max) NULL,
	[Name2] [nvarchar](max) NULL,
	[ShortName] [nvarchar](max) NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_Tenants] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Admin].[UHIDUsesRecords]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Admin].[UHIDUsesRecords](
	[Id] [uniqueidentifier] NOT NULL,
	[UHID] [bigint] NOT NULL,
	[UsesDate] [datetime2](7) NULL,
	[InvoiceNo] [bigint] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
	[ServiceUnitId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_UHIDUsesRecords] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Anonymous].[AnonymousUsers]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Anonymous].[AnonymousUsers](
	[Id] [uniqueidentifier] NOT NULL,
	[MobileNo] [nvarchar](max) NULL,
	[EMailId] [nvarchar](max) NULL,
	[UHID] [bigint] NULL,
	[IsMobileRequest] [bit] NOT NULL,
	[IsEmailRequest] [bit] NOT NULL,
	[PasswordHash] [nvarchar](200) NULL,
	[SaltHash] [nvarchar](200) NULL,
	[IsPasswordSet] [bit] NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[ShouldResetPassword] [bit] NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_AnonymousUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Anonymous].[AnonymousUserVerifications]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Anonymous].[AnonymousUserVerifications](
	[Id] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[PatientId] [uniqueidentifier] NULL,
	[OTPCode] [nvarchar](max) NULL,
	[OTPExpireTime] [datetime2](7) NOT NULL,
	[IsOTPMacthed] [bit] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_AnonymousUserVerifications] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Canteen].[CanteenOutlets]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Canteen].[CanteenOutlets](
	[Name] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_CanteenOutlets] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Canteen].[CanteenStockInfoesDateWiseHistories]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Canteen].[CanteenStockInfoesDateWiseHistories](
	[AutoId] [int] IDENTITY(1,1) NOT NULL,
	[FilterDate] [date] NULL,
	[ProductStock] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Canteen].[CanteenStockInfoesDateWiseHistories_BK]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Canteen].[CanteenStockInfoesDateWiseHistories_BK](
	[AutoId] [int] NOT NULL,
	[FilterDate] [date] NULL,
	[ProductStock] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Canteen].[CanteenStockTransferDetails]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Canteen].[CanteenStockTransferDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[CanteenStockTransferId] [uniqueidentifier] NOT NULL,
	[Qty] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TransferQty] [int] NOT NULL,
	[ItemId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_CanteenStockTransferDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Canteen].[CanteenStockTransfers]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Canteen].[CanteenStockTransfers](
	[Id] [uniqueidentifier] NOT NULL,
	[TransferDate] [datetime2](7) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Status] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
	[ToOutletId] [uniqueidentifier] NOT NULL,
	[FromOutletId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_CanteenStockTransfers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Canteen].[Groups]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Canteen].[Groups](
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_Groups] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Canteen].[IPDFoodIndents]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Canteen].[IPDFoodIndents](
	[Id] [uniqueidentifier] NOT NULL,
	[IndentNo] [bigint] NOT NULL,
	[IPDPatientId] [uniqueidentifier] NOT NULL,
	[CabinNo] [nvarchar](max) NULL,
	[CabinType] [nvarchar](max) NULL,
	[IndentDateTime] [datetime2](7) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Priority] [int] NOT NULL,
	[Status] [int] NOT NULL,
	[IsContinue] [bit] NOT NULL,
	[FoodPatternGroupId] [uniqueidentifier] NOT NULL,
	[Qty] [int] NOT NULL,
	[Remarks] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[IsRead] [bit] NOT NULL,
	[StoppedDate] [datetime2](7) NOT NULL,
	[LastViewDate] [datetime2](7) NOT NULL,
	[LastViewedMealOrder] [int] NOT NULL,
	[LastChangedDate] [datetime2](7) NOT NULL,
	[IsDietChanged] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
	[CanteenOutLetId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_IPDFoodIndents] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Canteen].[Items]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Canteen].[Items](
	[PurchaseRate] [real] NOT NULL,
	[StaffSaleRate] [real] NOT NULL,
	[GenaralSaleRate] [real] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Unit] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[VatInPercent] [decimal](5, 2) NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[ItemCode] [nvarchar](max) NULL,
	[ProductionRate] [real] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[GroupId] [uniqueidentifier] NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_Items] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Canteen].[MemberDueCollectionInvoices]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Canteen].[MemberDueCollectionInvoices](
	[Id] [uniqueidentifier] NOT NULL,
	[InvoiceNo] [bigint] NOT NULL,
	[MemberId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[ReceivedAmount] [float] NOT NULL,
	[Discount] [float] NOT NULL,
	[Remarks] [nvarchar](max) NULL,
	[Due] [float] NOT NULL,
	[ReceiveDate] [datetime2](7) NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Canteen].[RawItemIssueDetails]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Canteen].[RawItemIssueDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[RawItemIssueId] [uniqueidentifier] NOT NULL,
	[RawItemId] [uniqueidentifier] NOT NULL,
	[Qty] [real] NOT NULL,
	[Unit] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_RawItemIssueDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Canteen].[RawItemIssues]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Canteen].[RawItemIssues](
	[Id] [uniqueidentifier] NOT NULL,
	[IssueNo] [bigint] NOT NULL,
	[IssueDate] [datetime2](7) NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_RawItemIssues] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Canteen].[RawItems]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Canteen].[RawItems](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Unit] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[PRate] [real] NOT NULL,
	[SRate] [real] NOT NULL,
	[GroupId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_RawItems] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Canteen].[RawItemStockReceiveDetails]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Canteen].[RawItemStockReceiveDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[RawItemStockReceiveId] [uniqueidentifier] NOT NULL,
	[RawItemId] [uniqueidentifier] NOT NULL,
	[Qty] [real] NOT NULL,
	[Unit] [nvarchar](max) NULL,
	[PRate] [real] NOT NULL,
	[Total] [real] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_RawItemStockReceiveDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Canteen].[RawItemStockReceives]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Canteen].[RawItemStockReceives](
	[Id] [uniqueidentifier] NOT NULL,
	[SupplierId] [uniqueidentifier] NOT NULL,
	[ReceiveNo] [bigint] NOT NULL,
	[RDate] [datetime2](7) NULL,
	[TotalAmount] [real] NOT NULL,
	[Discount] [real] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_RawItemStockReceives] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Canteen].[SaleInvoiceDetails]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Canteen].[SaleInvoiceDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[InvoiceId] [uniqueidentifier] NOT NULL,
	[Qty] [real] NOT NULL,
	[PurchaseRate] [real] NOT NULL,
	[SaleRate] [real] NOT NULL,
	[TotalPrice] [real] NOT NULL,
	[Discount] [real] NOT NULL,
	[VatInTk] [float] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
	[ProductId ] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_SaleInvoiceDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Canteen].[SaleInvoices]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Canteen].[SaleInvoices](
	[Id] [uniqueidentifier] NOT NULL,
	[Invdate] [datetime2](7) NULL,
	[InvoiceNo] [bigint] NOT NULL,
	[TotalTK] [real] NOT NULL,
	[DiscountTK] [real] NOT NULL,
	[GrandTK] [real] NOT NULL,
	[ReceivedTK] [real] NOT NULL,
	[ChangeTK] [real] NOT NULL,
	[DueTK] [real] NOT NULL,
	[Remarks] [nvarchar](max) NULL,
	[UHID] [nvarchar](max) NULL,
	[LoyalMemberId] [uniqueidentifier] NOT NULL,
	[StaffRecordId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[InvoicePrefix] [nvarchar](max) NULL,
	[VatInTk] [float] NOT NULL,
	[IPDPatientRecordId] [uniqueidentifier] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[ServType] [nvarchar](max) NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[SaleCancelReason] [nvarchar](max) NULL,
	[MealType] [nvarchar](max) NULL,
	[CustomerType] [nvarchar](max) NULL,
	[FoodPatternName] [nvarchar](max) NULL,
	[IndentNo] [bigint] NOT NULL,
	[DailySerial] [int] NOT NULL,
	[CanteenOutLetId] [uniqueidentifier] NOT NULL,
	[IsDietChanged] [bit] NOT NULL,
	[CabinId] [uniqueidentifier] NOT NULL,
	[AfterDischargeCleared] [bit] NOT NULL,
	[PriorityTxt] [nvarchar](100) NOT NULL,
	[FoodDeliverableId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_SaleInvoices] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Canteen].[SaleInvoices_DailySerial]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Canteen].[SaleInvoices_DailySerial](
	[CreatedOn] [date] NULL,
	[DailySerial] [int] NULL,
	[ID] [uniqueidentifier] NULL,
 CONSTRAINT [U_canteen_SaleInvoices_DailySerial] UNIQUE NONCLUSTERED 
(
	[CreatedOn] ASC,
	[DailySerial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Canteen].[SaleLedgers]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Canteen].[SaleLedgers](
	[Id] [uniqueidentifier] NOT NULL,
	[InvoiceId] [uniqueidentifier] NOT NULL,
	[TranDate] [datetime2](7) NULL,
	[Description] [nvarchar](max) NULL,
	[Debit] [float] NOT NULL,
	[Credit] [float] NOT NULL,
	[Balance] [float] NOT NULL,
	[TransactionType] [int] NOT NULL,
	[PaymentChannelId] [int] NOT NULL,
	[PosTerminalId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_SaleLedgers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Canteen].[SalesmanDutyOutlets]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Canteen].[SalesmanDutyOutlets](
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[CanteenOutLetId] [uniqueidentifier] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_SalesmanDutyOutlets] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Canteen].[StockReceiveRecordDetails]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Canteen].[StockReceiveRecordDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[Qty] [int] NOT NULL,
	[PurchaseRate] [real] NOT NULL,
	[SaleRate] [real] NOT NULL,
	[StaffSaleRate] [real] NOT NULL,
	[Total] [real] NOT NULL,
	[StockReceiveId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
	[ItemId ] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_StockReceiveRecordDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Canteen].[StockReceiveRecords]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Canteen].[StockReceiveRecords](
	[Id] [uniqueidentifier] NOT NULL,
	[SupplierId] [uniqueidentifier] NOT NULL,
	[InvoiceNo] [bigint] NOT NULL,
	[RDate] [datetime2](7) NULL,
	[Particulars] [nvarchar](max) NULL,
	[TotalAmount] [real] NOT NULL,
	[Discount] [real] NOT NULL,
	[SupplierInvoiceDate] [datetime2](7) NULL,
	[SupplierInvoiceNo] [nvarchar](max) NULL,
	[TenantId] [int] NOT NULL,
	[ReceiveTypeId] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[CanteenOutLetId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_StockReceiveRecords] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[__EFMigrationsHistory]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__EFMigrationsHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AuditTrails]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuditTrails](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](max) NULL,
	[Type] [nvarchar](max) NULL,
	[TableName] [nvarchar](max) NULL,
	[DateTime] [datetime2](7) NOT NULL,
	[OldValues] [nvarchar](max) NULL,
	[NewValues] [nvarchar](max) NULL,
	[AffectedColumns] [nvarchar](max) NULL,
	[PrimaryKey] [nvarchar](max) NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_AuditTrails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Clients]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Clients](
	[ConnectionString] [varchar](200) NULL,
	[ClientName] [varchar](100) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_Clients] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Customers]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customers](
	[Id] [uniqueidentifier] NOT NULL,
	[CName] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DataProtectionKeys]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DataProtectionKeys](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FriendlyName] [nvarchar](450) NULL,
	[Xml] [nvarchar](4000) NULL,
 CONSTRAINT [PK_DataProtectionKeys] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OpenIddictApplications]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OpenIddictApplications](
	[Id] [nvarchar](450) NOT NULL,
	[ClientId] [nvarchar](100) NULL,
	[ClientSecret] [nvarchar](max) NULL,
	[ConcurrencyToken] [nvarchar](50) NULL,
	[ConsentType] [nvarchar](50) NULL,
	[DisplayName] [nvarchar](max) NULL,
	[DisplayNames] [nvarchar](max) NULL,
	[Permissions] [nvarchar](max) NULL,
	[PostLogoutRedirectUris] [nvarchar](max) NULL,
	[Properties] [nvarchar](max) NULL,
	[RedirectUris] [nvarchar](max) NULL,
	[Requirements] [nvarchar](max) NULL,
	[Type] [nvarchar](50) NULL,
 CONSTRAINT [PK_OpenIddictApplications] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OpenIddictAuthorizations]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OpenIddictAuthorizations](
	[Id] [nvarchar](450) NOT NULL,
	[ApplicationId] [nvarchar](450) NULL,
	[ConcurrencyToken] [nvarchar](50) NULL,
	[CreationDate] [datetime2](7) NULL,
	[Properties] [nvarchar](max) NULL,
	[Scopes] [nvarchar](max) NULL,
	[Status] [nvarchar](50) NULL,
	[Subject] [nvarchar](400) NULL,
	[Type] [nvarchar](50) NULL,
 CONSTRAINT [PK_OpenIddictAuthorizations] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OpenIddictScopes]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OpenIddictScopes](
	[Id] [nvarchar](450) NOT NULL,
	[ConcurrencyToken] [nvarchar](50) NULL,
	[Description] [nvarchar](max) NULL,
	[Descriptions] [nvarchar](max) NULL,
	[DisplayName] [nvarchar](max) NULL,
	[DisplayNames] [nvarchar](max) NULL,
	[Name] [nvarchar](200) NULL,
	[Properties] [nvarchar](max) NULL,
	[Resources] [nvarchar](max) NULL,
 CONSTRAINT [PK_OpenIddictScopes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OpenIddictTokens]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OpenIddictTokens](
	[Id] [nvarchar](450) NOT NULL,
	[ApplicationId] [nvarchar](450) NULL,
	[AuthorizationId] [nvarchar](450) NULL,
	[ConcurrencyToken] [nvarchar](50) NULL,
	[CreationDate] [datetime2](7) NULL,
	[ExpirationDate] [datetime2](7) NULL,
	[Payload] [nvarchar](max) NULL,
	[Properties] [nvarchar](max) NULL,
	[RedemptionDate] [datetime2](7) NULL,
	[ReferenceId] [nvarchar](100) NULL,
	[Status] [nvarchar](50) NULL,
	[Subject] [nvarchar](400) NULL,
	[Type] [nvarchar](50) NULL,
 CONSTRAINT [PK_OpenIddictTokens] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Payroll.TaxAdjustmentListOfMay]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Payroll.TaxAdjustmentListOfMay](
	[SL] [int] NULL,
	[EMPNO] [nvarchar](max) NULL,
	[EmpName] [nvarchar](max) NULL,
	[April] [float] NULL,
	[Minimun] [float] NULL,
	[Balance] [float] NULL,
	[Payable] [float] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SyncRecords]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SyncRecords](
	[Id] [uniqueidentifier] NOT NULL,
	[TableName] [nvarchar](100) NOT NULL,
	[TenantId] [int] NULL,
	[IsDeleted] [bit] NOT NULL,
	[Version] [bigint] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TblVoucherType]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TblVoucherType](
	[VTYPEID] [int] NOT NULL,
	[TypeCode] [varchar](20) NULL,
	[TypeTitle] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[temp_2023_04_18]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[temp_2023_04_18](
	[Value1] [nvarchar](max) NULL,
	[Value2] [nvarchar](max) NULL,
	[Value3] [nvarchar](max) NULL,
	[Value4] [nvarchar](max) NULL,
	[Value5] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[temp_2024_11_1]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[temp_2024_11_1](
	[autoid] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](max) NULL,
	[mlID] [uniqueidentifier] NULL,
	[mrid] [int] NULL,
	[status] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[temp_2024_11_2]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[temp_2024_11_2](
	[Column1] [nvarchar](max) NULL,
	[Column2] [nvarchar](max) NULL,
	[Column3] [nvarchar](max) NULL,
	[Column4] [nvarchar](max) NULL,
	[Column5] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TempSPGetReferralCommissionStatement]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TempSPGetReferralCommissionStatement](
	[ReportType] [nvarchar](max) NULL,
	[ConsultantID] [uniqueidentifier] NULL,
	[invoiceNumber] [bigint] NULL,
	[PatientID] [uniqueidentifier] NULL,
	[EDate] [date] NULL,
	[FullName] [nvarchar](100) NULL,
	[TotalSales] [float] NULL,
	[AUDIOMETRY] [float] NULL,
	[BMD] [float] NULL,
	[CBCT] [float] NULL,
	[COLONOSCOPY] [float] NULL,
	[CT SCAN] [float] NULL,
	[ECG] [float] NULL,
	[ECHO] [float] NULL,
	[ECHO COLOR DOPPLER] [float] NULL,
	[EEG] [float] NULL,
	[EMG] [float] NULL,
	[ENDOSCOPY] [float] NULL,
	[ENT] [float] NULL,
	[ETT] [float] NULL,
	[FIBROSCAN] [float] NULL,
	[HISTOPATHOLOGY] [float] NULL,
	[HOLTER ECG] [float] NULL,
	[IMMUNOHISTOCHEMISTRY] [float] NULL,
	[IMMUNOLOGY] [float] NULL,
	[MAMOGRAPHY] [float] NULL,
	[MICROBIOLOGY] [float] NULL,
	[MOLECULAR DIAGNOSTIC] [float] NULL,
	[MRI] [float] NULL,
	[NCV] [float] NULL,
	[NEUROLOGY] [float] NULL,
	[OPG] [float] NULL,
	[Pathology] [float] NULL,
	[SEROLOGY] [float] NULL,
	[ULTRASOUND] [float] NULL,
	[UROFLOMETRY] [float] NULL,
	[VASCULAR IMAGING] [float] NULL,
	[X-RAY] [float] NULL,
	[Discount] [float] NULL,
	[Due] [float] NULL,
	[Refund] [float] NULL,
	[Paid] [float] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ViewIndividualSalaries]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ViewIndividualSalaries](
	[Id] [uniqueidentifier] NOT NULL,
	[HouseRentInPercentOfBasic] [float] NOT NULL,
	[MedicalAllownceInPercentOfBasic] [float] NOT NULL,
	[Conveyance] [float] NOT NULL,
	[StaffInform] [nvarchar](max) NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[EmployeeNo] [nvarchar](max) NULL,
	[EmployeeName] [nvarchar](max) NULL,
	[BasicAmount] [float] NOT NULL,
	[Others] [float] NULL,
	[SpecialAllowance] [float] NULL,
	[Pf] [float] NULL,
	[Cpf] [float] NULL,
	[TotalSalary] [float] NULL,
	[OvertimePerHour] [float] NULL,
	[IsPFDeductionOn] [bit] NOT NULL,
	[GeneralSalaryPolicyId] [int] NOT NULL,
	[IncermentTypeId] [int] NOT NULL,
	[IncrementType] [nvarchar](max) NULL,
	[GeneralSalaryPolicyGroup] [nvarchar](max) NULL,
 CONSTRAINT [PK_ViewIndividualSalaries] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[AgeVariantNormalValues]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[AgeVariantNormalValues](
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[NormalValue] [nvarchar](max) NULL,
	[IsSynced] [bit] NULL,
	[Max] [float] NOT NULL,
	[Min] [float] NOT NULL,
	[TenantId] [int] NOT NULL,
	[ReportParameterId] [uniqueidentifier] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[ReportingAgeGroupId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_AgeVariantNormalValues] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[ConsultantPaymentRecords]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[ConsultantPaymentRecords](
	[Id] [uniqueidentifier] NOT NULL,
	[InvoiceNo] [bigint] NOT NULL,
	[ConsultantId] [uniqueidentifier] NOT NULL,
	[InvoiceIds] [nvarchar](max) NULL,
	[PayDate] [datetime2](7) NULL,
	[PayTime] [nvarchar](max) NULL,
	[Amount] [float] NOT NULL,
	[DateFrom] [datetime2](7) NULL,
	[DateTo] [datetime2](7) NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Remarks] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_ConsultantPaymentRecords] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[CreditCards]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[CreditCards](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProviderName] [nvarchar](max) NULL,
	[Address] [nvarchar](max) NULL,
	[ContactNo] [nvarchar](max) NULL,
	[DiscountGroupdId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_CreditCards] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[CSAntibiotics]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[CSAntibiotics](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_CSAntibiotics] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[CSGrowths]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[CSGrowths](
	[Id] [uniqueidentifier] NOT NULL,
	[PathologyReportId] [uniqueidentifier] NOT NULL,
	[TestItemId] [uniqueidentifier] NOT NULL,
	[CSAntibioticId] [uniqueidentifier] NOT NULL,
	[Diameter] [nvarchar](max) NULL,
	[ValueA] [nvarchar](max) NULL,
	[ValueB] [nvarchar](max) NULL,
	[ValueC] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_CSGrowths] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[CSGrowthTypes]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[CSGrowthTypes](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_CSGrowthTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[CSMessases]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[CSMessases](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_CSMessases] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[CSNoGrowthResults]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[CSNoGrowthResults](
	[Id] [uniqueidentifier] NOT NULL,
	[PathologyReportId] [uniqueidentifier] NOT NULL,
	[TestItemId] [uniqueidentifier] NOT NULL,
	[MicroBioBacteriaAId] [uniqueidentifier] NOT NULL,
	[MicroBioBacteriaBId] [uniqueidentifier] NOT NULL,
	[MicroBioBacteriaCId] [uniqueidentifier] NOT NULL,
	[GrowthTypeId] [uniqueidentifier] NOT NULL,
	[CSMessageId] [uniqueidentifier] NOT NULL,
	[ColonyCount] [nvarchar](max) NULL,
	[Incubation] [nvarchar](max) NULL,
	[CultureMediaUsed] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_CSNoGrowthResults] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[CSOthersValues]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[CSOthersValues](
	[Id] [uniqueidentifier] NOT NULL,
	[PathologyReportId] [uniqueidentifier] NOT NULL,
	[TestItemId] [uniqueidentifier] NOT NULL,
	[Analyzer] [nvarchar](max) NULL,
	[PusCellValue] [nvarchar](max) NULL,
	[EpithelialCellValue] [nvarchar](max) NULL,
	[RBCValue] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Note] [nvarchar](max) NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_CSOthersValues] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[DiscountGroupDetails]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[DiscountGroupDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[DiscountGroupId] [uniqueidentifier] NOT NULL,
	[TestItemId] [uniqueidentifier] NOT NULL,
	[DiscountInPercent] [real] NOT NULL,
	[DiscountInGross] [real] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_DiscountGroupDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[DiscountGroups]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[DiscountGroups](
	[Id] [uniqueidentifier] NOT NULL,
	[PackageName] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_DiscountGroups] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[InvestigationInvoiceDetails]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[InvestigationInvoiceDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[InvestigationInvoiceId] [uniqueidentifier] NOT NULL,
	[TestItemId] [uniqueidentifier] NOT NULL,
	[LabNoPrefix] [nvarchar](max) NULL,
	[AccessionNumber] [bigint] NOT NULL,
	[SOPInstanceUID] [nvarchar](max) NULL,
	[Rate] [float] NOT NULL,
	[Qty] [int] NOT NULL,
	[Total] [float] NOT NULL,
	[DiscountInPercent] [float] NOT NULL,
	[Discount] [float] NOT NULL,
	[ProbableReportDeliveryDateTime] [datetime2](7) NOT NULL,
	[ReportDeliveryBy] [uniqueidentifier] NOT NULL,
	[ProcedureStep] [int] NOT NULL,
	[LisReportStatus] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsCancelApproved] [bit] NOT NULL,
	[IsAllSampleCarried] [bit] NOT NULL,
	[IsAllSampleCollected] [bit] NOT NULL,
	[IsAllSampleReceived] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[IsUrgent] [bit] NOT NULL,
	[ImagingReportStatus] [int] NOT NULL,
	[TenantId] [int] NOT NULL,
	[IsReportingFeePaid] [bit] NOT NULL,
 CONSTRAINT [PK_InvestigationInvoiceDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[InvestigationInvoiceLedgers]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[InvestigationInvoiceLedgers](
	[Id] [uniqueidentifier] NOT NULL,
	[InvestigationInvoiceId] [uniqueidentifier] NOT NULL,
	[TranDate] [datetime2](7) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Debit] [real] NOT NULL,
	[Credit] [real] NOT NULL,
	[Balance] [real] NOT NULL,
	[TransactionType] [int] NOT NULL,
	[PaymentChannelId] [int] NOT NULL,
	[PosTerminalId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Remarks] [nvarchar](max) NULL,
	[TenantId] [int] NOT NULL,
	[DiscountCategoryId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_InvestigationInvoiceLedgers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[InvestigationInvoices]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[InvestigationInvoices](
	[Id] [uniqueidentifier] NOT NULL,
	[InvoicePrefix] [nvarchar](50) NULL,
	[InvoiceNo] [bigint] NOT NULL,
	[UHID] [bigint] NOT NULL,
	[EntryDate] [datetime2](7) NOT NULL,
	[EntryTime] [nvarchar](50) NULL,
	[FullName] [nvarchar](max) NULL,
	[AgeYear] [nvarchar](50) NULL,
	[AgeMonth] [nvarchar](50) NULL,
	[AgeDay] [nvarchar](50) NULL,
	[Gender] [nvarchar](max) NULL,
	[MobileNo] [nvarchar](max) NULL,
	[RefdDoctorId] [uniqueidentifier] NOT NULL,
	[StaffRecordId] [uniqueidentifier] NOT NULL,
	[IPDPatientRecordId] [uniqueidentifier] NOT NULL,
	[OPDEmergencyPatientId] [uniqueidentifier] NOT NULL,
	[IsCancelApproved] [bit] NOT NULL,
	[CancelApprovedBy] [uniqueidentifier] NOT NULL,
	[MarketingJOfficerOrMediaId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[CabinNo] [nvarchar](max) NULL,
	[ServiceBenificiery] [nvarchar](max) NULL,
	[RxId] [bigint] NOT NULL,
	[Remarks] [nvarchar](max) NULL,
	[IsSynced] [bit] NOT NULL,
	[MediaId] [uniqueidentifier] NOT NULL,
	[IsConsultantPaid] [bit] NOT NULL,
	[IsMediaPaid] [bit] NOT NULL,
	[IsIPDPaid] [bit] NOT NULL,
	[InvestigationIndentId] [uniqueidentifier] NOT NULL,
	[EntryBy] [nvarchar](max) NULL,
	[CorporateClientId] [uniqueidentifier] NOT NULL,
	[IsMediaCommissionPaid] [bit] NOT NULL,
	[PackageId] [uniqueidentifier] NOT NULL,
	[Address] [nvarchar](200) NULL,
	[SampleColectionAt] [nvarchar](50) NULL,
 CONSTRAINT [PK_InvestigationInvoices] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[IPDDiagnosis]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[IPDDiagnosis](
	[Id] [uniqueidentifier] NOT NULL,
	[RecordDate] [datetime2](7) NULL,
	[IPDPatientRecordId] [uniqueidentifier] NOT NULL,
	[Diagnosis] [nvarchar](max) NULL,
	[Remarks] [nvarchar](max) NULL,
	[DoctorId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_IPDDiagnosis] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[IPDDueCollections]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[IPDDueCollections](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientId] [uniqueidentifier] NOT NULL,
	[PayDate] [datetime2](7) NOT NULL,
	[Amount] [real] NOT NULL,
	[PaymentChannelId] [int] NOT NULL,
	[PosTerminalId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TransactionType] [int] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_IPDDueCollections] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[IPDInvestigationIndentDetails]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[IPDInvestigationIndentDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDInvestigationIndentId] [uniqueidentifier] NOT NULL,
	[TestItemId] [uniqueidentifier] NOT NULL,
	[Qty] [int] NOT NULL,
	[Status] [int] NOT NULL,
	[Remarks] [nvarchar](max) NULL,
	[SpecialInstruction] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[IsPerformed] [bit] NOT NULL,
	[TestDate] [datetime2](7) NULL,
	[TestTime] [datetime2](7) NULL,
	[PackageRate] [real] NOT NULL,
	[Rate] [real] NOT NULL,
	[TenantId] [int] NOT NULL,
	[ManualTestName] [nvarchar](100) NULL,
 CONSTRAINT [PK_IPDInvestigationIndentDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[IPDInvestigationIndents]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[IPDInvestigationIndents](
	[Id] [uniqueidentifier] NOT NULL,
	[IndentNo] [bigint] NOT NULL,
	[IPDPatientId] [uniqueidentifier] NOT NULL,
	[CabinNo] [nvarchar](max) NULL,
	[CabinType] [nvarchar](max) NULL,
	[IndentDateTime] [datetime2](7) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Priority] [int] NOT NULL,
	[SpecialInstruction] [nvarchar](max) NULL,
	[AttentionOf] [nvarchar](max) NULL,
	[Status] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[DoctorId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_IPDInvestigationIndents] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[LISPatientRecord]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[LISPatientRecord](
	[PatientId] [uniqueidentifier] NOT NULL,
	[LabNo] [int] NULL,
	[SequenceId] [int] NULL,
	[InstrumentName] [nvarchar](max) NULL,
	[PathologicalMachineId] [uniqueidentifier] NOT NULL,
	[ReportDate] [datetime2](7) NULL,
	[InsertDate] [datetime2](7) NULL,
	[ORG_CODE] [int] NULL,
	[PatientIdExt] [nvarchar](max) NULL,
	[FileName] [nvarchar](max) NULL,
	[ReportTypeId] [int] NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NULL,
	[IsSynced] [bit] NULL,
	[TenantId] [int] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_LISPatientRecord] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[LISResultRecord]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[LISResultRecord](
	[Category] [nvarchar](max) NULL,
	[Code] [nvarchar](max) NULL,
	[Name] [nvarchar](max) NULL,
	[LongName] [nvarchar](max) NULL,
	[Value] [nvarchar](max) NULL,
	[Unit] [nvarchar](max) NULL,
	[Range] [nvarchar](max) NULL,
	[ReportDate] [datetime2](7) NULL,
	[ReportDefId] [int] NULL,
	[PrintOrder] [int] NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NULL,
	[IsSynced] [bit] NULL,
	[ParameterId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NOT NULL,
	[PatientRecordId] [uniqueidentifier] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_LISResultRecord] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[MachineGroupAndTestMapping]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[MachineGroupAndTestMapping](
	[TenantId] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TestSampleId] [uniqueidentifier] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[PathologicalMachineGroupId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_MachineGroupAndTestMapping] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[MediaPaymentRecords]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[MediaPaymentRecords](
	[Id] [uniqueidentifier] NOT NULL,
	[InvoiceNo] [bigint] NOT NULL,
	[MediaId] [uniqueidentifier] NOT NULL,
	[InvoiceIds] [nvarchar](max) NULL,
	[PayDate] [datetime2](7) NULL,
	[PayTime] [nvarchar](max) NULL,
	[Amount] [float] NOT NULL,
	[DateFrom] [datetime2](7) NULL,
	[DateTo] [datetime2](7) NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Remarks] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_MediaPaymentRecords] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[MicroBioBacterias]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[MicroBioBacterias](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_MicroBioBacterias] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[Modalities]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[Modalities](
	[Name] [nvarchar](max) NULL,
	[AETitle] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[TestGroupId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Modalities] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[OPDPackages]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[OPDPackages](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[OPDPackageTestItems]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[OPDPackageTestItems](
	[Id] [uniqueidentifier] NOT NULL,
	[OPDPackageId] [uniqueidentifier] NOT NULL,
	[TestItemId] [uniqueidentifier] NOT NULL,
	[Rate] [real] NOT NULL,
	[PackageRage] [real] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[ParentGroup]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[ParentGroup](
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_ParentGroup] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[PathMachineOutputParameter]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[PathMachineOutputParameter](
	[OldId] [int] IDENTITY(1,1) NOT NULL,
	[PathologicalMachineId] [uniqueidentifier] NOT NULL,
	[OutputParam] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[HostCode] [nvarchar](50) NULL,
	[TestItemId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[TestSampleId] [uniqueidentifier] NOT NULL,
	[ReportParameterId] [uniqueidentifier] NOT NULL,
	[SampleType] [nvarchar](50) NULL,
 CONSTRAINT [PK_PathMachineOutputParameter] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[PathologicalMachineGroups]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[PathologicalMachineGroups](
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_PathologicalMachineGroups] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[PathologicalMachines]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[PathologicalMachines](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[MachineCode] [nvarchar](max) NULL,
	[ReportTitle] [nvarchar](max) NULL,
	[TenantId] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[PathologicalMachineGroupId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_PathologicalMachines] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[PathologyDescriptiveReports]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[PathologyDescriptiveReports](
	[Id] [uniqueidentifier] NOT NULL,
	[ReportDateTime] [datetime2](7) NULL,
	[InvoiceNo] [bigint] NOT NULL,
	[TestItemId] [uniqueidentifier] NOT NULL,
	[ReportContent] [ntext] NULL,
	[FinalizedByDoctorId] [uniqueidentifier] NOT NULL,
	[SampleStatus] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_PathologyDescriptiveReports] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[PathologyReportConfigs]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[PathologyReportConfigs](
	[Id] [uniqueidentifier] NOT NULL,
	[TestItemId] [uniqueidentifier] NOT NULL,
	[TitleVisible] [bit] NOT NULL,
	[ResultVisible] [bit] NOT NULL,
	[UnitVisible] [bit] NOT NULL,
	[ReferenceValueVisible] [bit] NOT NULL,
	[MethodVisible] [bit] NOT NULL,
	[ColumnWidths] [nvarchar](100) NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK__Patholog__3214EC0711EBAFB2] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[PathologyReportDetails]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[PathologyReportDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[PathologyReportId] [uniqueidentifier] NOT NULL,
	[TestItemId] [uniqueidentifier] NOT NULL,
	[TestTitle] [nvarchar](max) NULL,
	[TestResult] [nvarchar](max) NULL,
	[ResultUnit] [nvarchar](max) NULL,
	[NormalResult] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[IsThisOnePrinted] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
	[ReportParameterId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_PathologyReportDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[PathologyReportPermissions]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[PathologyReportPermissions](
	[Id] [uniqueidentifier] NOT NULL,
	[DoctorId] [uniqueidentifier] NOT NULL,
	[TestGroupIds] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_PathologyReportPermissions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[PathologyReports]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[PathologyReports](
	[Id] [uniqueidentifier] NOT NULL,
	[PatientId] [uniqueidentifier] NOT NULL,
	[ReportDate] [datetime2](7) NULL,
	[ReportDoctorId] [uniqueidentifier] NOT NULL,
	[ReportType] [int] NOT NULL,
	[AnyComments] [nvarchar](max) NULL,
	[PreparedDate] [datetime2](7) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[LabNo] [int] NOT NULL,
	[SampleStatus] [int] NOT NULL,
	[IsCSGrowth] [bit] NOT NULL,
	[IsCSReport] [bit] NOT NULL,
	[AnalyzerName] [nvarchar](max) NULL,
	[IsReversedForResultReview] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
	[ReportTechnologistId] [uniqueidentifier] NOT NULL,
	[ReportVerifierId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_PathologyReports] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[PathologyTemplates]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[PathologyTemplates](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[TemplateContent] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_PathologyTemplates] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[PDFConfigurations]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[PDFConfigurations](
	[Id] [uniqueidentifier] NOT NULL,
	[ReportTitle] [nvarchar](max) NULL,
	[Configuration] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[RadiologyReports]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[RadiologyReports](
	[Id] [uniqueidentifier] NOT NULL,
	[ReportDateTime] [datetime2](7) NULL,
	[InvoiceNo] [bigint] NOT NULL,
	[TestItemId] [uniqueidentifier] NOT NULL,
	[ReportContent] [ntext] NULL,
	[FinalizedByDoctorId] [uniqueidentifier] NOT NULL,
	[SampleStatus] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_RadiologyReports] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[RadiologyTemplates]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[RadiologyTemplates](
	[Id] [uniqueidentifier] NOT NULL,
	[DoctorId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[TemplateContent] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_RadiologyTemplates] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[ReportDeliveryTimingDetails]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[ReportDeliveryTimingDetails](
	[EntryTime] [nvarchar](max) NULL,
	[DeliveryTime] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[RDTMId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_ReportDeliveryTimingDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[ReportDeliveryTimingMasters]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[ReportDeliveryTimingMasters](
	[TotalDeliverySlot] [int] NOT NULL,
	[OrgCode] [int] NOT NULL,
	[IsActiveNow] [bit] NOT NULL,
	[IsWeekendDeliverySchedule] [bit] NOT NULL,
	[WeekEndStartTime] [nvarchar](max) NULL,
	[IsWeekEndStartTimeOnPrevDay] [bit] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_ReportDeliveryTimingMasters] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[reportFormates]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[reportFormates](
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_ReportFormates] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[ReportingAgeGroups]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[ReportingAgeGroups](
	[Name] [nvarchar](max) NULL,
	[AgeLowLimitInMonths] [float] NOT NULL,
	[AgeHigherLimitLessThanEqualTo] [float] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[AgeHigherLimitLessThan] [float] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_ReportingAgeGroups] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[ReportParameters]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[ReportParameters](
	[TestItemId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Normavalue] [nvarchar](max) NULL,
	[HasAgeVariant] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[isGroupTitle] [bit] NOT NULL,
	[IsBold] [bit] NOT NULL,
	[IsItalic] [bit] NOT NULL,
	[Remarks] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[Unit] [nvarchar](max) NULL,
	[IsSynced] [bit] NOT NULL,
	[Max] [float] NOT NULL,
	[Min] [float] NOT NULL,
	[ShortName] [nvarchar](max) NULL,
	[ComparativeResultDisplayHeader] [nvarchar](max) NULL,
	[DischargeCertificateDisplayHeader] [nvarchar](max) NULL,
	[IsShowOnComparativeResult] [bit] NOT NULL,
	[IsShowOnDischargeCertificate] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[TestMethodId] [uniqueidentifier] NOT NULL,
	[InputType] [nvarchar](100) NOT NULL,
	[ValueOptions] [nvarchar](500) NOT NULL,
	[DefaultValue] [nvarchar](200) NOT NULL,
	[TestSampleId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_ReportParameters] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[ReportParameterValues]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[ReportParameterValues](
	[Id] [uniqueidentifier] NOT NULL,
	[Value] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[ReportParameterId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NOT NULL,
	[IsDefault] [bit] NOT NULL,
 CONSTRAINT [PK_ReportParameterValues] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[ReportTitles]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[ReportTitles](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_ReportTitles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[ReportTitleSettings]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[ReportTitleSettings](
	[Id] [uniqueidentifier] NOT NULL,
	[ReportTitleId] [uniqueidentifier] NOT NULL,
	[TestItemId] [uniqueidentifier] NOT NULL,
	[TestOrder] [float] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_ReportTitleSettings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[ReportVerifiers]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[ReportVerifiers](
	[Name] [nvarchar](max) NULL,
	[Identity1] [nvarchar](max) NULL,
	[Identity2] [nvarchar](max) NULL,
	[Identity3] [nvarchar](max) NULL,
	[Identity4] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_ReportVerifiers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[SampleCarriers]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[SampleCarriers](
	[StaffRecordId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_SampleCarriers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[SampleCollectionAndReceiptionPrinters]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[SampleCollectionAndReceiptionPrinters](
	[OldId] [int] IDENTITY(1,1) NOT NULL,
	[PrinterName] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_SampleCollectionAndReceiptionPrinters] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[SampleCollectionRecords]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[SampleCollectionRecords](
	[Id] [uniqueidentifier] NOT NULL,
	[LabNo] [int] NOT NULL,
	[InvoiceId] [uniqueidentifier] NOT NULL,
	[InvestigationInvoiceDetailId] [uniqueidentifier] NOT NULL,
	[SampleCollectionBy] [uniqueidentifier] NOT NULL,
	[SampleCollectionDateTime] [datetime2](7) NULL,
	[SampleCarriedBy] [uniqueidentifier] NOT NULL,
	[SampleCarriedDateTime] [datetime2](7) NULL,
	[SampleReceiveByAtLab] [uniqueidentifier] NOT NULL,
	[SampleReceiveDateTime] [datetime2](7) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[SampleStatus] [int] NOT NULL,
	[RejectRemarks] [nvarchar](max) NULL,
	[TenantId] [int] NOT NULL,
	[TestSampleId] [uniqueidentifier] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[SampleStatuses]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[SampleStatuses](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_SampleStatuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[Technologists]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[Technologists](
	[Name] [nvarchar](max) NULL,
	[Identity1] [nvarchar](max) NULL,
	[Identity2] [nvarchar](max) NULL,
	[Identity3] [nvarchar](max) NULL,
	[Identity4] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[ProfileImage] [varbinary](max) NULL,
	[TenantId] [int] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Technologists] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[TestGroups]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[TestGroups](
	[Name] [nvarchar](max) NULL,
	[TokenOrder] [int] NULL,
	[MovementOrder] [int] NOT NULL,
	[MovementRoomNo] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[ParentGroupId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_TestGroups] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[TestGroupWiseReportingFees]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[TestGroupWiseReportingFees](
	[Id] [uniqueidentifier] NOT NULL,
	[DoctorId] [uniqueidentifier] NOT NULL,
	[FeeInPercent] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TestGroupId] [uniqueidentifier] NOT NULL,
	[FeeInTk] [float] NULL,
 CONSTRAINT [PK_TestGroupWiseReportingFees] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[TestItems]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[TestItems](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Rate] [float] NOT NULL,
	[Specimen] [nvarchar](max) NULL,
	[SampleExtractionType] [nvarchar](max) NULL,
	[NumberOfSample] [int] NULL,
	[TestCode] [nvarchar](max) NULL,
	[ShortName] [nvarchar](max) NULL,
	[DayNeededForReportDelivery] [int] NOT NULL,
	[EscapeDayNeededForReportDeliveryDayCount] [int] NOT NULL,
	[DeliveryTimeOnReportDay] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TestMethodId] [uniqueidentifier] NOT NULL,
	[IsReportInTableFormat] [bit] NOT NULL,
	[NoOfColumn] [int] NOT NULL,
	[TestGroupId] [uniqueidentifier] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[DefaultVacutainerId] [uniqueidentifier] NOT NULL,
	[IsDiscountAllow] [bit] NOT NULL,
 CONSTRAINT [PK_TestItems] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[TestMethods]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[TestMethods](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_TestMethods] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[TestSamples]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[TestSamples](
	[TestItemId] [uniqueidentifier] NOT NULL,
	[LabelText] [nvarchar](max) NULL,
	[Specimen] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_TestSamples] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[TestWiseReportingFees]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[TestWiseReportingFees](
	[Id] [uniqueidentifier] NOT NULL,
	[DoctorId] [uniqueidentifier] NOT NULL,
	[TestItemId] [uniqueidentifier] NOT NULL,
	[FeeInPercent] [int] NOT NULL,
	[FeeInAmount] [float] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_TestWiseReportingFees] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Diag].[UserPrintReports]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[UserPrintReports](
	[Id] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[ReportName] [nvarchar](50) NOT NULL,
	[CreatedBy] [nvarchar](50) NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](50) NULL,
	[LastModifiedOn] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
	[PatientId] [uniqueidentifier] NOT NULL,
	[TestId] [uniqueidentifier] NOT NULL,
	[LabNo] [int] NOT NULL,
 CONSTRAINT [PK_UserPrintReports_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Diag].[VacutainerAndMachineGroupMappings]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Diag].[VacutainerAndMachineGroupMappings](
	[TenantId] [int] NOT NULL,
	[TestItemId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[PathologicalMachineGroupId] [uniqueidentifier] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_VacutainerAndMachineGroupMappings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [EMR].[AdvicesOnTreatments]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EMR].[AdvicesOnTreatments](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientId] [uniqueidentifier] NOT NULL,
	[EMRAdviceId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
	[ManualAdivce] [nvarchar](200) NOT NULL,
 CONSTRAINT [PK_AdvicesOnTreatments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [EMR].[AdviceTemplateDetails]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EMR].[AdviceTemplateDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[AdviceTemplateId] [uniqueidentifier] NOT NULL,
	[AdviceEn] [nvarchar](max) NULL,
	[AdviceBn] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_AdviceTemplateDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [EMR].[AdviceTemplates]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EMR].[AdviceTemplates](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[DeptId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_AdviceTemplates] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [EMR].[AppliedMedicationDoses]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EMR].[AppliedMedicationDoses](
	[Id] [uniqueidentifier] NOT NULL,
	[RxIpdTreatmentId] [uniqueidentifier] NOT NULL,
	[ApplyDate] [datetime2](7) NOT NULL,
	[ApplyTime] [datetime2](7) NOT NULL,
	[TreatmentDoseTimingDetailId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_AppliedMedicationDoses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [EMR].[BirthCertificates]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EMR].[BirthCertificates](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientId] [uniqueidentifier] NOT NULL,
	[NameOfChild] [nvarchar](max) NULL,
	[GenderOfChild] [nvarchar](max) NULL,
	[PlaceOfBirth] [nvarchar](max) NULL,
	[FatherName] [nvarchar](max) NULL,
	[Religion] [nvarchar](max) NULL,
	[GrandFatherName] [nvarchar](max) NULL,
	[DateAndTimeOfBirth] [datetime2](7) NOT NULL,
	[ModeOfDelivery] [nvarchar](max) NULL,
	[BirthWeight] [float] NOT NULL,
	[Comments] [nvarchar](max) NULL,
	[FatherPresentAddress] [nvarchar](max) NULL,
	[FatherPermanentAddress] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_BirthCertificates] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [EMR].[BloodRequisitions]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EMR].[BloodRequisitions](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientRecordId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[PrimaryDiagnosis] [nvarchar](max) NULL,
	[CSBP] [nvarchar](max) NULL,
	[CSPulse] [nvarchar](max) NULL,
	[LatestCBCReport] [nvarchar](max) NULL,
	[DemandedBlood] [nvarchar](max) NULL,
	[BloodUnit] [nvarchar](max) NULL,
	[TestRequired] [nvarchar](max) NULL,
	[PreviousTransfusionHistory] [nvarchar](max) NULL,
	[NoOfTransFusion] [nvarchar](max) NULL,
	[LastTransfuionDate] [datetime2](7) NOT NULL,
	[AnyReactionOccured] [nvarchar](max) NULL,
	[DoctorName] [nvarchar](max) NULL,
	[BMDCNo] [nvarchar](max) NULL,
	[ReqDate] [datetime2](7) NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[BloodGroup] [nvarchar](20) NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_BloodRequisitions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [EMR].[BloodTransfusionOrders]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EMR].[BloodTransfusionOrders](
	[Id] [uniqueidentifier] NOT NULL,
	[PatientId] [uniqueidentifier] NOT NULL,
	[CabinNo] [nvarchar](50) NULL,
	[BagNo] [nvarchar](50) NULL,
	[BloodGroup] [nvarchar](10) NULL,
	[CompatibleWithTheBloodOf] [nvarchar](50) NULL,
	[BloodTransfusionOrderDetails] [nvarchar](max) NULL,
	[ActionsAfterReaction] [nvarchar](max) NULL,
	[DateTime] [datetime] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [EMR].[ColonscopyEMROrders]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EMR].[ColonscopyEMROrders](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientRecordId] [uniqueidentifier] NOT NULL,
	[Note] [ntext] NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[DepartmentName] [nvarchar](max) NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_ColonscopyEMROrders] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [EMR].[ConsultancyVisitNotes]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EMR].[ConsultancyVisitNotes](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientId] [uniqueidentifier] NOT NULL,
	[Note] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_ConsultancyVisitNotes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [EMR].[DeathRecordCommonDataGroupItems]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EMR].[DeathRecordCommonDataGroupItems](
	[Id] [uniqueidentifier] NOT NULL,
	[DeathRecordCommonDataId] [uniqueidentifier] NOT NULL,
	[LabelName] [nvarchar](max) NULL,
	[InputDisplayType] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_DeathRecordCommonDataGroupItems] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [EMR].[DeathRecordCommonDatas]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EMR].[DeathRecordCommonDatas](
	[Id] [uniqueidentifier] NOT NULL,
	[GroupName] [nvarchar](max) NULL,
	[Title] [nvarchar](max) NULL,
	[DisplayOrder] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_DeathRecordCommonDatas] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [EMR].[DeathRecordDetails]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EMR].[DeathRecordDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[DeathRecordId] [uniqueidentifier] NOT NULL,
	[DeathRecordCommonDataId] [uniqueidentifier] NOT NULL,
	[DeathRecordCommonDataGroupItemsId] [uniqueidentifier] NOT NULL,
	[Comments] [nvarchar](max) NULL,
	[Others] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_DeathRecordDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [EMR].[DeathRecords]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EMR].[DeathRecords](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientRecordId] [uniqueidentifier] NOT NULL,
	[DateOfDeath] [datetime2](7) NOT NULL,
	[TimeOfDeath] [datetime2](7) NOT NULL,
	[DeceasedNID] [nvarchar](max) NULL,
	[DeceasedGurdianNID] [nvarchar](max) NULL,
	[RelationWithGurdian] [nvarchar](max) NULL,
	[FamilyContactNo] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_DeathRecords] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [EMR].[DietOnDischarges]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EMR].[DietOnDischarges](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientId] [uniqueidentifier] NOT NULL,
	[FoodPatternGroupId] [uniqueidentifier] NOT NULL,
	[SuggestDate] [datetime2](7) NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[FluidRestriction] [nvarchar](max) NULL,
	[ServerQty] [int] NOT NULL,
	[DurationTime] [nvarchar](max) NULL,
	[ServedCalories] [nvarchar](max) NULL,
	[ProteinRestrictions] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Remarks] [nvarchar](max) NULL,
	[ManualPatternName] [nvarchar](200) NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_DietOnDischarges] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [EMR].[DietSuggests]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EMR].[DietSuggests](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientId] [uniqueidentifier] NOT NULL,
	[FoodPatternGroupId] [uniqueidentifier] NOT NULL,
	[SuggestDate] [datetime2](7) NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[FluidRestriction] [nvarchar](max) NULL,
	[ServerQty] [int] NOT NULL,
	[DurationTime] [nvarchar](max) NULL,
	[ServedCalories] [nvarchar](max) NULL,
	[ProteinRestrictions] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Remarks] [nvarchar](max) NULL,
	[ManualPatternName] [nvarchar](200) NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_DietSuggests] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [EMR].[DoctorVisitPlans]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EMR].[DoctorVisitPlans](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientRecordId] [uniqueidentifier] NOT NULL,
	[DoctorId] [uniqueidentifier] NOT NULL,
	[AssistantDoctorId] [uniqueidentifier] NOT NULL,
	[VisitDateTime] [datetime2](7) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_DoctorVisitPlans] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [EMR].[EMRAdvices]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EMR].[EMRAdvices](
	[Id] [uniqueidentifier] NOT NULL,
	[Advice] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[DeptId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_EMRAdvices] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [EMR].[EMRDiagnosises]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EMR].[EMRDiagnosises](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientId] [uniqueidentifier] NOT NULL,
	[Diagnosis] [nvarchar](max) NULL,
	[DDate] [datetime2](7) NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_EMRDiagnosises] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [EMR].[EndoscopyEMROrders]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EMR].[EndoscopyEMROrders](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientRecordId] [uniqueidentifier] NOT NULL,
	[Note] [ntext] NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[DepartmentName] [nvarchar](max) NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_EndoscopyEMROrders] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [EMR].[ERCPEMROrders]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EMR].[ERCPEMROrders](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientRecordId] [uniqueidentifier] NOT NULL,
	[Note] [ntext] NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[DepartmentName] [nvarchar](max) NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_ERCPEMROrders] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [EMR].[HandOverSheetForms]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EMR].[HandOverSheetForms](
	[Id] [uniqueidentifier] NOT NULL,
	[DepartmentId] [uniqueidentifier] NOT NULL,
	[FormTitle] [nvarchar](max) NOT NULL,
	[Fields] [nvarchar](max) NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [EMR].[HandOverSheets]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EMR].[HandOverSheets](
	[Id] [uniqueidentifier] NOT NULL,
	[PatientId] [uniqueidentifier] NOT NULL,
	[DepartmentId] [uniqueidentifier] NOT NULL,
	[Data] [nvarchar](max) NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [EMR].[Holidays]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EMR].[Holidays](
	[Id] [uniqueidentifier] NOT NULL,
	[StaffRecordId] [uniqueidentifier] NOT NULL,
	[HoliDate] [datetime2](7) NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_Holidays] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [EMR].[ICUCourses]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EMR].[ICUCourses](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientId] [uniqueidentifier] NOT NULL,
	[Course] [ntext] NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[EntryDate] [datetime2](7) NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_ICUCourses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [EMR].[NurseToNursePatientHandOverRecords]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EMR].[NurseToNursePatientHandOverRecords](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientRecordId] [uniqueidentifier] NOT NULL,
	[HODate] [datetime2](7) NOT NULL,
	[HOTime] [datetime2](7) NOT NULL,
	[HanOverBy] [uniqueidentifier] NOT NULL,
	[HandOverTo] [uniqueidentifier] NOT NULL,
	[IsReceipantAcknowledged] [bit] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_NurseToNursePatientHandOverRecords] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [EMR].[OTTemplateGroups]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EMR].[OTTemplateGroups](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_OTTemplateGroups] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [EMR].[OTTemplates]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EMR].[OTTemplates](
	[Id] [uniqueidentifier] NOT NULL,
	[OTTemplateGroupId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[TemplateContent] [ntext] NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[DepartmentId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_OTTemplates] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [EMR].[ProcedureNotes]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EMR].[ProcedureNotes](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientId] [uniqueidentifier] NOT NULL,
	[EntryDate] [datetime2](7) NOT NULL,
	[Note] [ntext] NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_ProcedureNotes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [EMR].[SuggestedInvestigations]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EMR].[SuggestedInvestigations](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientId] [uniqueidentifier] NOT NULL,
	[TestItemId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Remarks] [nvarchar](max) NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_SuggestedInvestigations] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [EMR].[TransferNotesEMR]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EMR].[TransferNotesEMR](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientRecordId] [uniqueidentifier] NOT NULL,
	[Note] [ntext] NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[DepartmentName] [nvarchar](max) NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_TransferNotesEMR] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [EMR].[TreatmentDoseTimingDetails]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EMR].[TreatmentDoseTimingDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[TreatmentDoseTimingId] [uniqueidentifier] NOT NULL,
	[Time] [datetime2](7) NOT NULL,
	[IntervalInMinute] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_TreatmentDoseTimingDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [EMR].[TreatmentDoseTimings]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EMR].[TreatmentDoseTimings](
	[Id] [uniqueidentifier] NOT NULL,
	[RxIpdTreatmentId] [uniqueidentifier] NOT NULL,
	[TimingType] [int] NOT NULL,
	[StartDate] [datetime2](7) NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_TreatmentDoseTimings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [EMR].[TreatmentOnDischarges]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EMR].[TreatmentOnDischarges](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientRecordId] [uniqueidentifier] NOT NULL,
	[BrandExtentionId] [uniqueidentifier] NOT NULL,
	[Dosage] [nvarchar](max) NULL,
	[Duration] [nvarchar](max) NULL,
	[Note] [nvarchar](max) NULL,
	[Status] [nvarchar](max) NULL,
	[StartDate] [datetime2](7) NULL,
	[StartTime] [nvarchar](max) NULL,
	[StopDate] [datetime2](7) NULL,
	[StopTime] [nvarchar](max) NULL,
	[StoppingNote] [nvarchar](max) NULL,
	[HoldDate] [datetime2](7) NULL,
	[HoldingTime] [nvarchar](max) NULL,
	[HoldingNote] [nvarchar](max) NULL,
	[DoseId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[DoseStatus] [nvarchar](max) NULL,
	[DoctorId] [uniqueidentifier] NOT NULL,
	[ConsultantId] [uniqueidentifier] NOT NULL,
	[IsDischargeCertificate] [bit] NOT NULL,
	[ManualBrand] [nvarchar](max) NULL,
	[IsManualBrand] [bit] NOT NULL,
	[RouteOfAdministration] [nvarchar](max) NULL,
	[DisplayOrder] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[UpToDate] [date] NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_TreatmentOnDischarges] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [EMR].[TreatmentOrderArchiveDetails]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EMR].[TreatmentOrderArchiveDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[OrderArchiveId] [uniqueidentifier] NOT NULL,
	[BrandExtentionId] [uniqueidentifier] NOT NULL,
	[Dosage] [nvarchar](max) NULL,
	[Duration] [nvarchar](max) NULL,
	[Note] [nvarchar](max) NULL,
	[Status] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[IsManualBrand] [bit] NOT NULL,
	[ManualBrand] [nvarchar](max) NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_TreatmentOrderArchiveDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [EMR].[TreatmentOrderArchives]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EMR].[TreatmentOrderArchives](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientId] [uniqueidentifier] NOT NULL,
	[DoctorId] [uniqueidentifier] NOT NULL,
	[OrderDateTime] [datetime2](7) NULL,
	[OrderType] [nvarchar](max) NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_TreatmentOrderArchives] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [EMR].[ZolendronicEMROrders]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [EMR].[ZolendronicEMROrders](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientRecordId] [uniqueidentifier] NOT NULL,
	[Note] [ntext] NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[DepartmentName] [nvarchar](max) NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_ZolendronicEMROrders] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[AggregatedCounter]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[AggregatedCounter](
	[Key] [nvarchar](100) NOT NULL,
	[Value] [bigint] NOT NULL,
	[ExpireAt] [datetime] NULL,
 CONSTRAINT [PK_HangFire_CounterAggregated] PRIMARY KEY CLUSTERED 
(
	[Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[Counter]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[Counter](
	[Key] [nvarchar](100) NOT NULL,
	[Value] [int] NOT NULL,
	[ExpireAt] [datetime] NULL,
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_HangFire_Counter] PRIMARY KEY CLUSTERED 
(
	[Key] ASC,
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[Hash]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[Hash](
	[Key] [nvarchar](100) NOT NULL,
	[Field] [nvarchar](100) NOT NULL,
	[Value] [nvarchar](max) NULL,
	[ExpireAt] [datetime2](7) NULL,
 CONSTRAINT [PK_HangFire_Hash] PRIMARY KEY CLUSTERED 
(
	[Key] ASC,
	[Field] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[Job]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[Job](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[StateId] [bigint] NULL,
	[StateName] [nvarchar](20) NULL,
	[InvocationData] [nvarchar](max) NOT NULL,
	[Arguments] [nvarchar](max) NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[ExpireAt] [datetime] NULL,
 CONSTRAINT [PK_HangFire_Job] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[JobParameter]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[JobParameter](
	[JobId] [bigint] NOT NULL,
	[Name] [nvarchar](40) NOT NULL,
	[Value] [nvarchar](max) NULL,
 CONSTRAINT [PK_HangFire_JobParameter] PRIMARY KEY CLUSTERED 
(
	[JobId] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[JobQueue]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[JobQueue](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[JobId] [bigint] NOT NULL,
	[Queue] [nvarchar](50) NOT NULL,
	[FetchedAt] [datetime] NULL,
 CONSTRAINT [PK_HangFire_JobQueue] PRIMARY KEY CLUSTERED 
(
	[Queue] ASC,
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[List]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[List](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Key] [nvarchar](100) NOT NULL,
	[Value] [nvarchar](max) NULL,
	[ExpireAt] [datetime] NULL,
 CONSTRAINT [PK_HangFire_List] PRIMARY KEY CLUSTERED 
(
	[Key] ASC,
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[Schema]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[Schema](
	[Version] [int] NOT NULL,
 CONSTRAINT [PK_HangFire_Schema] PRIMARY KEY CLUSTERED 
(
	[Version] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[Server]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[Server](
	[Id] [nvarchar](200) NOT NULL,
	[Data] [nvarchar](max) NULL,
	[LastHeartbeat] [datetime] NOT NULL,
 CONSTRAINT [PK_HangFire_Server] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[Set]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[Set](
	[Key] [nvarchar](100) NOT NULL,
	[Score] [float] NOT NULL,
	[Value] [nvarchar](256) NOT NULL,
	[ExpireAt] [datetime] NULL,
 CONSTRAINT [PK_HangFire_Set] PRIMARY KEY CLUSTERED 
(
	[Key] ASC,
	[Value] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = ON, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [HangFire].[State]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HangFire].[State](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[JobId] [bigint] NOT NULL,
	[Name] [nvarchar](20) NOT NULL,
	[Reason] [nvarchar](100) NULL,
	[CreatedAt] [datetime] NOT NULL,
	[Data] [nvarchar](max) NULL,
 CONSTRAINT [PK_HangFire_State] PRIMARY KEY CLUSTERED 
(
	[JobId] ASC,
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[AdmittedPackages]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[AdmittedPackages](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientRecordId] [uniqueidentifier] NOT NULL,
	[PackageId] [uniqueidentifier] NOT NULL,
	[AdmissionDate] [datetime2](7) NULL,
	[ReleaseDate] [datetime2](7) NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[IsOccupiedByPatient] [bit] NOT NULL,
 CONSTRAINT [PK_AdmittedPackages] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[AdvancePaymentDetails]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[AdvancePaymentDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[AdvancePaymentId] [uniqueidentifier] NOT NULL,
	[PaymentChannelId] [int] NOT NULL,
	[Amount] [float] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Remarks] [nvarchar](max) NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_AdvancePaymentDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[AdvancePayments]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[AdvancePayments](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientId] [uniqueidentifier] NOT NULL,
	[PayDate] [datetime2](7) NULL,
	[PayTime] [nvarchar](max) NULL,
	[Amount] [float] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Remarks] [nvarchar](max) NULL,
	[PaymentChannelId] [int] NOT NULL,
	[PosTerminalId] [uniqueidentifier] NOT NULL,
	[TransactionType] [int] NOT NULL,
	[AdvanceReturnAmount] [float] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_AdvancePayments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[AdvicesByDepts]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[AdvicesByDepts](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientRecordId] [uniqueidentifier] NOT NULL,
	[Advice] [nvarchar](max) NULL,
	[AdviceByDoctorId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[ConsultantsReport] [nvarchar](max) NULL,
	[DeptId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_AdvicesByDepts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[AnaesthesiaTypes]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[AnaesthesiaTypes](
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_AnaesthesiaTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[AssignedDoctorRecords]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[AssignedDoctorRecords](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientRecordId] [uniqueidentifier] NOT NULL,
	[AssignedDoctorId] [uniqueidentifier] NOT NULL,
	[AssignedDate] [datetime2](7) NULL,
	[TrasferDate] [datetime2](7) NULL,
	[IsUnderHim] [bit] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_AssignedDoctorRecords] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[BabyNotes]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[BabyNotes](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientRecordId] [uniqueidentifier] NOT NULL,
	[OTScheduleId] [uniqueidentifier] NOT NULL,
	[NoteDateTime] [datetime2](7) NULL,
	[Note] [nvarchar](max) NULL,
	[DateOfBirth] [datetime2](7) NULL,
	[Sex] [nvarchar](max) NULL,
	[Weight] [nvarchar](max) NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Remarks] [nvarchar](max) NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_BabyNotes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[BedRentPackages]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[BedRentPackages](
	[Id] [uniqueidentifier] NOT NULL,
	[ServicePackageId] [uniqueidentifier] NOT NULL,
	[CabinId] [uniqueidentifier] NOT NULL,
	[Rent] [real] NOT NULL,
	[Duration] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_BedRentPackages] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[CabinChargeRules]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[CabinChargeRules](
	[CalenderChangeTime] [nvarchar](max) NULL,
	[AdmissionDayGracePeriodInhours] [int] NOT NULL,
	[ReleaseDayGracePeriodInhours] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[OverlappedPickupMax] [bit] NOT NULL,
	[AdmissionDayGracePeriodInminutes] [int] NOT NULL,
	[ReleaseDayGracePeriodInminutes] [int] NOT NULL,
	[IsAdmissonDayPreCalendarTimeBillWillbeHourly] [bit] NOT NULL,
	[IsReleaseDayPostCalendarTimeBillWillbeHourly] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[AdmissionDayMaxPreCalendarHour] [int] NOT NULL,
	[ReleaseDayMaxPostCalendarHour] [int] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_CabinChargeRules] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[CabinDiscounts]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[CabinDiscounts](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientRecordId] [uniqueidentifier] NOT NULL,
	[CabinId] [uniqueidentifier] NOT NULL,
	[StayingDate] [datetime2](7) NULL,
	[Description] [nvarchar](max) NULL,
	[NoOfDay] [int] NOT NULL,
	[Rate] [decimal](18, 2) NOT NULL,
	[TotalAmount] [decimal](18, 2) NOT NULL,
	[Discount] [float] NOT NULL,
	[IsExtra] [bit] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_CabinDiscounts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[Cabins]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[Cabins](
	[Id] [uniqueidentifier] NOT NULL,
	[CabinNo] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[Rent] [decimal](18, 2) NOT NULL,
	[FloorId] [uniqueidentifier] NOT NULL,
	[HourlyRent] [decimal](18, 2) NOT NULL,
	[Status] [int] NOT NULL,
	[TenantId] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[CabinTypeId] [uniqueidentifier] NOT NULL,
	[HDepartmentId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Cabins] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[CabinTypes]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[CabinTypes](
	[CabinType] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IPDServicesBillingHeadName] [nvarchar](max) NULL,
	[IsSynced] [bit] NOT NULL,
	[AdmissionFee] [int] NOT NULL,
	[ServiceHeadId] [uniqueidentifier] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_CabinTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[ConfinementNotes]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[ConfinementNotes](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientRecordId] [uniqueidentifier] NOT NULL,
	[OTScheduleId] [uniqueidentifier] NOT NULL,
	[NoteDateTime] [datetime2](7) NULL,
	[Note] [ntext] NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[AnaesthesiastId] [uniqueidentifier] NOT NULL,
	[Indication] [nvarchar](max) NULL,
	[ProcedureName] [nvarchar](max) NULL,
	[SurgeonId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_ConfinementNotes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[ConservativeTreatments]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[ConservativeTreatments](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientRecordId] [uniqueidentifier] NOT NULL,
	[BrandExtentionId] [uniqueidentifier] NOT NULL,
	[Dosage] [nvarchar](max) NULL,
	[Duration] [nvarchar](max) NULL,
	[Note] [nvarchar](max) NULL,
	[Status] [nvarchar](max) NULL,
	[StartDate] [datetime2](7) NULL,
	[StartTime] [nvarchar](max) NULL,
	[StopDate] [datetime2](7) NULL,
	[StopTime] [nvarchar](max) NULL,
	[StoppingNote] [nvarchar](max) NULL,
	[HoldDate] [datetime2](7) NULL,
	[HoldingTime] [nvarchar](max) NULL,
	[HoldingNote] [nvarchar](max) NULL,
	[DoseId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[DoctorId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_ConservativeTreatments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[ConsultancyPackages]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[ConsultancyPackages](
	[Id] [uniqueidentifier] NOT NULL,
	[ServicePackageId] [uniqueidentifier] NOT NULL,
	[ServiceExecutingHeadId] [uniqueidentifier] NOT NULL,
	[ConsultantId] [uniqueidentifier] NOT NULL,
	[PackageAmount] [real] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_ConsultancyPackages] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[DaywiseFoodBillCharges]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[DaywiseFoodBillCharges](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientRecordId] [uniqueidentifier] NOT NULL,
	[CabinId] [uniqueidentifier] NOT NULL,
	[BillDate] [datetime2](7) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Rate] [real] NOT NULL,
	[TotalAmount] [real] NOT NULL,
	[Discount] [real] NOT NULL,
	[ServType] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_DaywiseFoodBillCharges] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[DiscargeAdvices]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[DiscargeAdvices](
	[Id] [uniqueidentifier] NOT NULL,
	[Advice] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[AdviceBn] [nvarchar](max) NULL,
	[DeptId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_DiscargeAdvices] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[DischargeCertificate]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[DischargeCertificate](
	[EditorText] [nvarchar](max) NULL,
	[IPDPatientId] [uniqueidentifier] NOT NULL,
	[DischargeCertificateDate] [datetime2](7) NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
	[PreparedBy] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DischargeCertificate] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[DischargeTemplates]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[DischargeTemplates](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[ClassName] [nvarchar](max) NULL,
	[TenantId] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_DischargeTemplates] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[DoDPatientAccesses]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[DoDPatientAccesses](
	[UserId] [uniqueidentifier] NOT NULL,
	[FloorId] [uniqueidentifier] NOT NULL,
	[DeptIds] [nvarchar](max) NULL,
	[IsPatientVisibleByFloor] [bit] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_DoDPatientAccesses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[DynamicFormCategories]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[DynamicFormCategories](
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_TestSamples] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[DynamicInputControls]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[DynamicInputControls](
	[CType] [nvarchar](max) NULL,
	[CTypeId] [int] NOT NULL,
	[LabelText] [nvarchar](max) NULL,
	[IsDropDown] [bit] NOT NULL,
	[IsEnable] [bit] NOT NULL,
	[HasValidation] [bit] NOT NULL,
	[MinRange] [int] NOT NULL,
	[MaxRange] [int] NOT NULL,
	[WillDisplayOnDischargeCertificate] [bit] NOT NULL,
	[ColSpan] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_DynamicInputControls] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[DynamicInputControlValues]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[DynamicInputControlValues](
	[CTypeValue] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[ControltypeId] [uniqueidentifier] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DynamicInputControlValues] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[DynamicTemplateDetails]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[DynamicTemplateDetails](
	[SortOrder] [int] NOT NULL,
	[BindValue] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
	[ControlFormID] [uniqueidentifier] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[BindDropDownValue] [uniqueidentifier] NOT NULL,
	[ControltypeId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_DynamicTemplateDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[DynamicTemplates]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[DynamicTemplates](
	[FormTitle] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[DynamicFormCategoryId] [uniqueidentifier] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[DepartmentId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_DynamicTemplates] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[FinalBillLedgers]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[FinalBillLedgers](
	[Id] [uniqueidentifier] NOT NULL,
	[FinalBillId] [uniqueidentifier] NOT NULL,
	[TranDateTime] [datetime2](7) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Debit] [float] NOT NULL,
	[Credit] [float] NOT NULL,
	[Balance] [float] NOT NULL,
	[TransactionType] [int] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[PaymentChannelId] [int] NOT NULL,
	[PosTerminalId] [uniqueidentifier] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
	[DiscountCategoryId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_FinalBillLedgers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[FinalBills]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[FinalBills](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientRecordId] [uniqueidentifier] NOT NULL,
	[BillDate] [datetime2](7) NOT NULL,
	[Billtime] [nvarchar](max) NULL,
	[BillPreparedby] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Remarks] [nvarchar](max) NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_FinalBills] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[FinalBillSummarys]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[FinalBillSummarys](
	[Id] [uniqueidentifier] NOT NULL,
	[FinalBillId] [uniqueidentifier] NOT NULL,
	[SummaryHeadName] [nvarchar](max) NULL,
	[Amount] [float] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[Discount] [float] NOT NULL,
	[GrandTotal] [float] NOT NULL,
	[ServiceCharge] [float] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[SummaryHeadId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_FinalBillSummarys] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[Floors]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[Floors](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[TenantId] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_Floors] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[FollowUpDataDetails]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[FollowUpDataDetails](
	[BindValue] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[DynamicFormDId] [uniqueidentifier] NOT NULL,
	[MasterId] [uniqueidentifier] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[ControltypeId] [uniqueidentifier] NOT NULL,
	[BindDropDownValue] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_FollowUpDataDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[FollowUpDatas]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[FollowUpDatas](
	[PatientId] [uniqueidentifier] NOT NULL,
	[CheckUpDate] [datetime2](7) NOT NULL,
	[TemplateType] [nvarchar](max) NULL,
	[FollowUpSheetScheduleId] [uniqueidentifier] NOT NULL,
	[FollowUpByUserId] [uniqueidentifier] NOT NULL,
	[FollowUpSheetScheduleName] [nvarchar](max) NULL,
	[FollowupType] [nvarchar](max) NULL,
	[DoctorId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[DynamicFormId] [uniqueidentifier] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_FollowUpDatas] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[FollowUpSheetSchedules]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[FollowUpSheetSchedules](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[StartTime] [datetime2](7) NOT NULL,
	[EndTime] [datetime2](7) NOT NULL,
	[TenantId] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_FollowUpSheetSchedules] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[HDepartments]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[HDepartments](
	[Name] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[AdmissionFee] [decimal](18, 2) NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[DischargeTemplateId] [uniqueidentifier] NOT NULL,
	[backupId] [int] NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_HDepartments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[HospitalDepartmentWiseRevenue]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[HospitalDepartmentWiseRevenue](
	[id] [uniqueidentifier] NULL,
	[InvoiceNo] [nvarchar](max) NULL,
	[FullName] [nvarchar](max) NULL,
	[AdmissionDateTime] [datetime] NULL,
	[DischargedDateTime] [datetime] NULL,
	[Admissionfee] [float] NULL,
	[CabinWardBill] [float] NULL,
	[ICUBill] [float] NULL,
	[HDUBill] [float] NULL,
	[CCUBill] [float] NULL,
	[NICUBill] [float] NULL,
	[BedSideService] [float] NULL,
	[Consultation] [float] NULL,
	[PAC] [float] NULL,
	[OTMedicine] [float] NULL,
	[OTCharge] [float] NULL,
	[SurgeonFee] [float] NULL,
	[Anaesthesia] [float] NULL,
	[Assistant] [float] NULL,
	[POW] [float] NULL,
	[Investigation] [float] NULL,
	[DayCareService] [float] NULL,
	[Medicine] [float] NULL,
	[Food] [float] NULL,
	[ServiceCharge] [float] NULL,
	[TotalBill] [float] NULL,
	[Discount] [float] NULL,
	[Received] [float] NULL,
	[Due] [float] NULL,
	[DischargeBy] [nvarchar](max) NULL,
	[TenantId] [int] NULL,
	[IsSynced] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[IPDCabinAllocationRecords]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[IPDCabinAllocationRecords](
	[Id] [uniqueidentifier] NOT NULL,
	[PatientId] [uniqueidentifier] NOT NULL,
	[CabinId] [uniqueidentifier] NOT NULL,
	[AllocationDateTime] [datetime2](7) NOT NULL,
	[AllotType] [nvarchar](max) NULL,
	[Status] [nvarchar](max) NULL,
	[IsOccupiedByPatient] [bit] NOT NULL,
	[SoftwareGeneratedRemaks] [nvarchar](max) NULL,
	[UserRemaks] [nvarchar](max) NULL,
	[ReleaseDateTime] [datetime2](7) NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[AllocationOrder] [int] NOT NULL,
	[DeptId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
	[SitRent] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_IPDCabinAllocationRecords] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[IPDConsultantServices]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[IPDConsultantServices](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientId] [uniqueidentifier] NOT NULL,
	[ServiceId] [uniqueidentifier] NOT NULL,
	[ConsultantId] [uniqueidentifier] NOT NULL,
	[ServiceDate] [datetime2](7) NOT NULL,
	[Rate] [real] NOT NULL,
	[Qty] [int] NOT NULL,
	[Discount] [float] NOT NULL,
	[ServiceCharge] [int] NOT NULL,
	[ScheduleType] [nvarchar](max) NULL,
	[CabinNo] [nvarchar](max) NULL,
	[CabinType] [nvarchar](max) NULL,
	[EntryDate] [datetime2](7) NOT NULL,
	[IsExtraService] [bit] NOT NULL,
	[IsConsultancyPaId] [bit] NOT NULL,
	[Remarks] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[IsPostedToAccount] [bit] NOT NULL,
	[DeliverySectionId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_IPDConsultantServices] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[IPDIndentForwardAndPatientAccesses]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[IPDIndentForwardAndPatientAccesses](
	[Id] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[FloorId] [uniqueidentifier] NOT NULL,
	[DeptIds] [nvarchar](max) NULL,
	[IsPatientVisibleByFloor] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[IndentForwardToOutlet] [uniqueidentifier] NOT NULL,
	[CanteenOutLetId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_IPDIndentForwardAndPatientAccesses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[IPDNonMedicationOrders]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[IPDNonMedicationOrders](
	[IPDPatientRecordId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[Dose] [nvarchar](max) NULL,
	[IsSynced] [bit] NOT NULL,
	[Instruction] [nvarchar](max) NULL,
	[DoctorId] [uniqueidentifier] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[NonMedicationOrderId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_IPDNonMedicationOrders] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[IPDPatientDeptHistories]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[IPDPatientDeptHistories](
	[Id] [uniqueidentifier] NOT NULL,
	[PatientId] [uniqueidentifier] NOT NULL,
	[DepartmentId] [uniqueidentifier] NOT NULL,
	[CabinId] [uniqueidentifier] NOT NULL,
	[AdmissionDate] [date] NOT NULL,
	[ReleaseDate] [date] NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[IPDPatientEvents]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[IPDPatientEvents](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientRecordId] [uniqueidentifier] NOT NULL,
	[Events] [nvarchar](max) NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[DoctorId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_IPDPatientEvents] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[IPDPatientRecords]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[IPDPatientRecords](
	[Id] [uniqueidentifier] NOT NULL,
	[UHID] [bigint] NOT NULL,
	[InvoicePrefix] [nvarchar](max) NULL,
	[InvoiceNo] [bigint] NOT NULL,
	[FullName] [nvarchar](max) NULL,
	[AgeYear] [nvarchar](max) NULL,
	[AgeMonth] [nvarchar](max) NULL,
	[AgeDay] [nvarchar](max) NULL,
	[AdmissionDateTime] [datetime2](7) NOT NULL,
	[RefdDoctorId] [uniqueidentifier] NOT NULL,
	[AssignedDoctorId] [uniqueidentifier] NOT NULL,
	[AdmittedCabinId] [uniqueidentifier] NOT NULL,
	[Status] [nvarchar](max) NULL,
	[MarketingJOfficerOrMediaId] [uniqueidentifier] NOT NULL,
	[ProbableDischargeDateTime] [datetime2](7) NULL,
	[DischargedDateTime] [datetime2](7) NULL,
	[IsCCCHold] [bit] NOT NULL,
	[IsPharmacyClaimCleared] [bit] NOT NULL,
	[StaffRecordId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NOT NULL,
	[AdmissionByUserId] [uniqueidentifier] NOT NULL,
	[DischargeByUserId] [uniqueidentifier] NOT NULL,
	[IsClearedForDischarge] [bit] NOT NULL,
	[IsClearedFromPharmacy] [bit] NOT NULL,
	[IsClearedFromNurseStation] [bit] NOT NULL,
	[IsClearedFromDoD] [bit] NOT NULL,
	[IsCCHold] [bit] NOT NULL,
	[IsNotified] [bit] NOT NULL,
	[Remarks] [nvarchar](max) NULL,
	[MediaId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[IsManualCabinDayCount] [bit] NOT NULL,
	[CabinChargeCalculationGracePeriodType] [int] NOT NULL,
	[AdditionalDoctorIds] [nvarchar](max) NULL,
	[AdmissionFee] [int] NOT NULL,
	[ChiefConsultantId] [uniqueidentifier] NOT NULL,
	[DeptId] [uniqueidentifier] NOT NULL,
	[CorporateClientId] [uniqueidentifier] NOT NULL,
	[IsEMRLoaded] [bit] NOT NULL,
	[IsTransferredFromOrigin] [bit] NOT NULL,
	[IsMediaCommissionPaid] [bit] NOT NULL,
	[MediaHonorarium] [nvarchar](max) NULL,
	[BillingMode] [nvarchar](max) NULL,
 CONSTRAINT [PK_IPDPatientRecords] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[IPDServiceRecords]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[IPDServiceRecords](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientId] [uniqueidentifier] NOT NULL,
	[ServiceId] [uniqueidentifier] NOT NULL,
	[ServiceDatetime] [datetime2](7) NOT NULL,
	[Rate] [float] NOT NULL,
	[Discount] [float] NOT NULL,
	[Qty] [float] NOT NULL,
	[ServiceCharge] [float] NOT NULL,
	[Amount] [float] NOT NULL,
	[IsExtraService] [bit] NOT NULL,
	[EntryDateTime] [datetime2](7) NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[EndDateTime] [datetime2](7) NULL,
	[IsPostedToAccount] [bit] NOT NULL,
	[StartDateTime] [datetime2](7) NULL,
	[DeliverySectionId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_IPDServiceRecords] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[ManualCabinDays]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[ManualCabinDays](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientId] [uniqueidentifier] NOT NULL,
	[CabinId] [uniqueidentifier] NOT NULL,
	[NoOfDays] [int] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[EntryDate] [datetime2](7) NOT NULL,
	[PackageRate] [real] NOT NULL,
	[Rate] [real] NOT NULL,
	[CabinTypeId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_ManualCabinDays] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[MedicineReturnIndentDetails]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[MedicineReturnIndentDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[MedicineRetirnIndentId] [uniqueidentifier] NOT NULL,
	[BrandExtensionId] [uniqueidentifier] NOT NULL,
	[LotRecordId] [uniqueidentifier] NOT NULL,
	[Qty] [int] NOT NULL,
	[Status] [int] NOT NULL,
	[Remarks] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_MedicineReturnIndentDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[MedicineReturnIndents]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[MedicineReturnIndents](
	[Id] [uniqueidentifier] NOT NULL,
	[IndentNo] [bigint] NOT NULL,
	[IPDPatientId] [uniqueidentifier] NOT NULL,
	[CabinNo] [nvarchar](max) NULL,
	[CabinType] [nvarchar](max) NULL,
	[IndentDateTime] [datetime2](7) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Status] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[IndentToOutletId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_MedicineReturnIndents] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[MemberPictures]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[MemberPictures](
	[UHID] [bigint] NOT NULL,
	[ProfileImage] [varbinary](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[DoctorId] [uniqueidentifier] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_MemberPictures] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[MemberShipTypes]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[MemberShipTypes](
	[Type] [nvarchar](max) NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_MemberShipTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[NonMedicationOrders]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[NonMedicationOrders](
	[Order] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_NonMedicationOrders] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[OTInfoNurseStationDetails]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[OTInfoNurseStationDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[OTInfoNurseStationId] [uniqueidentifier] NOT NULL,
	[ServiceHeadId] [uniqueidentifier] NOT NULL,
	[DoctorId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_OTInfoNurseStationDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[OTInfoNurseStations]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[OTInfoNurseStations](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientId] [uniqueidentifier] NOT NULL,
	[EntryDate] [datetime2](7) NULL,
	[ChiefSurgeonId] [uniqueidentifier] NOT NULL,
	[IndicationOfSurgery] [nvarchar](max) NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[AnaesthesiaTypeId] [uniqueidentifier] NOT NULL,
	[OTNameId ] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_OTInfoNurseStations] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[OTNames]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[OTNames](
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_OTNames] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[OTNotes]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[OTNotes](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientRecordId] [uniqueidentifier] NOT NULL,
	[OTScheduleId] [uniqueidentifier] NOT NULL,
	[NoteDateTime] [datetime2](7) NULL,
	[Indication] [nvarchar](max) NULL,
	[Incision] [nvarchar](max) NULL,
	[Findings] [ntext] NULL,
	[HPR] [ntext] NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[AnesthetistId] [uniqueidentifier] NOT NULL,
	[Procedure] [ntext] NULL,
	[SurgeonId] [uniqueidentifier] NOT NULL,
	[AnesthesiaName] [nvarchar](max) NULL,
	[OTNameId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
	[DoctorAssistantName] [nvarchar](max) NULL,
 CONSTRAINT [PK_OTNotes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[OTRoom]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[OTRoom](
	[Name] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_OTRoom] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[OTRoomBookingRequests]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[OTRoomBookingRequests](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientRecordId] [uniqueidentifier] NOT NULL,
	[RequestDate] [datetime2](7) NULL,
	[RequestTime] [nvarchar](max) NULL,
	[RequestBy] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[OTScheduleId] [uniqueidentifier] NOT NULL,
	[RequestForOTRoomId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_OTRoomBookingRequests] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[OTRoomBooks]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[OTRoomBooks](
	[Id] [uniqueidentifier] NOT NULL,
	[BookingRequestId] [uniqueidentifier] NOT NULL,
	[IPDPatientRecordId] [uniqueidentifier] NOT NULL,
	[OTDate] [datetime2](7) NULL,
	[OTStartTime] [datetime2](7) NULL,
	[OTEndTime] [datetime2](7) NULL,
	[Status] [nvarchar](max) NULL,
	[OTRoomBookedBy] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[OTRoomId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_OTRoomBooks] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[OTSchedules]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[OTSchedules](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientRecordId] [uniqueidentifier] NOT NULL,
	[SurgeonId] [uniqueidentifier] NOT NULL,
	[AnaesthesiologistId] [uniqueidentifier] NOT NULL,
	[OTDateTime] [datetime2](7) NULL,
	[Status] [nvarchar](max) NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsCompleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[AnesthesiaType] [nvarchar](max) NULL,
	[Floor] [nvarchar](max) NULL,
	[OTRoom] [nvarchar](max) NULL,
	[IndicationOfSurgery] [nvarchar](max) NULL,
	[Others] [nvarchar](max) NULL,
	[OTNameId] [uniqueidentifier] NOT NULL,
	[OTTypeId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_OTSchedules] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[OTServiceDetails]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[OTServiceDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[OTServiceId] [uniqueidentifier] NOT NULL,
	[ServiceHeadId] [uniqueidentifier] NOT NULL,
	[DoctorId] [uniqueidentifier] NOT NULL,
	[Rate] [real] NOT NULL,
	[Qty] [int] NOT NULL,
	[ServiceCharge] [int] NOT NULL,
	[Amount] [real] NOT NULL,
	[Discount] [real] NOT NULL,
	[IsExtraService] [bit] NOT NULL,
	[IsConsultancyPaId] [bit] NOT NULL,
	[Remarks] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[IsPostedToAccount] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_OTServiceDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[OTServices]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[OTServices](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientId] [uniqueidentifier] NOT NULL,
	[ChiefSurgeonId] [uniqueidentifier] NOT NULL,
	[IncisionType] [nvarchar](max) NULL,
	[StartDateTime] [datetime2](7) NULL,
	[EndDateTime] [datetime2](7) NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[IndicationOfSurgery] [nvarchar](max) NULL,
	[ServiceEntryDate] [datetime2](7) NULL,
	[ServiceEntryTime] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[AnaesthesiaTypeId] [uniqueidentifier] NOT NULL,
	[OTNameId] [uniqueidentifier] NOT NULL,
	[OTTypeId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_OTServices] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[OTTypes]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[OTTypes](
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_OTTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[PackageInvestigations]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[PackageInvestigations](
	[Id] [uniqueidentifier] NOT NULL,
	[ServicePackageId] [uniqueidentifier] NOT NULL,
	[TestItemId] [uniqueidentifier] NOT NULL,
	[Rate] [real] NOT NULL,
	[PackageRate] [real] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_PackageInvestigations] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[PackageIPDServices]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[PackageIPDServices](
	[Id] [uniqueidentifier] NOT NULL,
	[ServicePackageId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Amount] [real] NOT NULL,
	[ServiceId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_PackageIPDServices] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[PackageMedicines]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[PackageMedicines](
	[Id] [uniqueidentifier] NOT NULL,
	[ServicePackageId] [uniqueidentifier] NOT NULL,
	[BrandExtensionId] [uniqueidentifier] NOT NULL,
	[Qty] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_PackageMedicines] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[PatientConditionDuringDischarges]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[PatientConditionDuringDischarges](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientRecordId] [uniqueidentifier] NOT NULL,
	[EntryDate] [datetime2](7) NULL,
	[EntryTime] [nvarchar](max) NULL,
	[Pulse] [nvarchar](max) NULL,
	[Pressure] [nvarchar](max) NULL,
	[Temperature] [nvarchar](max) NULL,
	[Abdomen] [nvarchar](max) NULL,
	[Dressing] [nvarchar](max) NULL,
	[DrainTube] [nvarchar](max) NULL,
	[Catheter] [nvarchar](max) NULL,
	[Bladder] [nvarchar](max) NULL,
	[Bowel] [nvarchar](max) NULL,
	[DoctorName] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[FHR] [nvarchar](max) NULL,
	[FM] [nvarchar](max) NULL,
	[PVB] [nvarchar](max) NULL,
	[Uterus] [nvarchar](max) NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_PatientConditionDuringDischarges] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[PatientDynamicFormDataDetails]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[PatientDynamicFormDataDetails](
	[BindValue] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[MasterId] [uniqueidentifier] NOT NULL,
	[DynamicFormDId] [uniqueidentifier] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[BindDropDownValue] [uniqueidentifier] NOT NULL,
	[ControltypeId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_PatientDynamicFormDataDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[PatientDynamicFormDatas]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[PatientDynamicFormDatas](
	[PatientId] [uniqueidentifier] NOT NULL,
	[CheckUpDate] [datetime2](7) NOT NULL,
	[TemplateType] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[DoctorId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[DynamicFormId] [uniqueidentifier] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_PatientDynamicFormDatas] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[PostDischargeAdvices]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[PostDischargeAdvices](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[IsBaby] [bit] NOT NULL,
	[AdviceName] [nvarchar](max) NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_PostDischargeAdvices] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[PostDischargeFollowups]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[PostDischargeFollowups](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientId] [uniqueidentifier] NOT NULL,
	[ConsultantId] [uniqueidentifier] NOT NULL,
	[FollowupDateTime] [datetime2](7) NULL,
	[FollowupAfter] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Remarks] [nvarchar](200) NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_PostDischargeFollowups] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[PostOperativeNotes]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[PostOperativeNotes](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientRecordId] [uniqueidentifier] NOT NULL,
	[OTScheduleId] [uniqueidentifier] NOT NULL,
	[Note] [ntext] NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_PostOperativeNotes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[PreoperativeNotes]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[PreoperativeNotes](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientRecordId] [uniqueidentifier] NOT NULL,
	[OTScheduleId] [uniqueidentifier] NOT NULL,
	[Note] [ntext] NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[DepartmentName] [nvarchar](max) NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_PreoperativeNotes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[ProcedureWeights]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[ProcedureWeights](
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_ProcedureWeights] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[RegRecords]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[RegRecords](
	[Id] [uniqueidentifier] NOT NULL,
	[UHIDPrefix] [nvarchar](max) NULL,
	[UHID] [bigint] NOT NULL,
	[Title] [nvarchar](max) NULL,
	[IDNo] [nvarchar](max) NULL,
	[Surname] [nvarchar](max) NULL,
	[IDType] [nvarchar](max) NULL,
	[FullName] [nvarchar](max) NOT NULL,
	[AgeYear] [nvarchar](max) NULL,
	[AgeMonth] [nvarchar](max) NULL,
	[AgeDay] [nvarchar](max) NULL,
	[Dob] [datetime2](7) NULL,
	[Sex] [nvarchar](max) NULL,
	[FatherName] [nvarchar](max) NULL,
	[MotherName] [nvarchar](max) NULL,
	[MaritalStatus] [nvarchar](max) NULL,
	[Profession] [nvarchar](max) NULL,
	[MobileNo] [nvarchar](max) NULL,
	[Email] [nvarchar](max) NULL,
	[CareOf] [nvarchar](max) NULL,
	[HouseNo] [nvarchar](max) NULL,
	[RoadNo] [nvarchar](max) NULL,
	[Po] [nvarchar](max) NULL,
	[ArearOrThana] [nvarchar](max) NULL,
	[District] [nvarchar](max) NULL,
	[PatientAddress] [nvarchar](max) NULL,
	[MembershipType] [nvarchar](max) NULL,
	[UnionId] [int] NOT NULL,
	[Cpname] [nvarchar](max) NULL,
	[CphouseNo] [nvarchar](max) NULL,
	[CproadNo] [nvarchar](max) NULL,
	[Cpvillage] [nvarchar](max) NULL,
	[Cppo] [nvarchar](max) NULL,
	[CparearOrThana] [nvarchar](max) NULL,
	[Cpdistrict] [nvarchar](max) NULL,
	[Cpaddress] [nvarchar](max) NULL,
	[Cpmobile] [nvarchar](max) NULL,
	[CpnationalId] [nvarchar](max) NULL,
	[RelationWithPatient] [nvarchar](max) NULL,
	[BloodGroup] [nvarchar](max) NULL,
	[SpouseName] [nvarchar](max) NULL,
	[Status] [nvarchar](max) NULL,
	[Others] [nvarchar](max) NULL,
	[NationalId] [nvarchar](max) NULL,
	[DesignationId] [int] NOT NULL,
	[NoOfSons] [nvarchar](max) NULL,
	[NoOfDaughters] [nvarchar](max) NULL,
	[Village] [nvarchar](max) NULL,
	[UpazilaOrAreaId] [int] NOT NULL,
	[LocalGurdianUpazilaOrAreaId] [int] NOT NULL,
	[RegDate] [datetime2](7) NOT NULL,
	[IsRegisterd] [bit] NOT NULL,
	[RefdId] [uniqueidentifier] NOT NULL,
	[EmployeeId] [nvarchar](max) NULL,
	[TenantId] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[Religion] [nvarchar](max) NULL,
	[IsSynced] [bit] NOT NULL,
	[IsOTPVerified] [bit] NOT NULL,
	[OTPCode] [nvarchar](max) NULL,
	[Password] [nvarchar](max) NULL,
	[OPDCodeExpireTime] [datetime2](7) NULL,
	[GivenName] [nvarchar](max) NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[Confidential] [nvarchar](200) NULL,
	[SpacialAlert] [nvarchar](200) NULL,
 CONSTRAINT [PK_RegRecords] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[RxIpdTreatmentLogs]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[RxIpdTreatmentLogs](
	[TreatmentId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[EventName] [nvarchar](20) NOT NULL,
	[Note] [nvarchar](20) NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[TenantId] [int] NULL,
	[IsSynced] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[RxIpdTreatments]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[RxIpdTreatments](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientRecordId] [uniqueidentifier] NOT NULL,
	[BrandExtentionId] [uniqueidentifier] NOT NULL,
	[Dosage] [nvarchar](max) NULL,
	[Duration] [nvarchar](max) NULL,
	[Note] [nvarchar](max) NULL,
	[Status] [nvarchar](max) NULL,
	[StartDate] [datetime2](7) NULL,
	[StartTime] [nvarchar](max) NULL,
	[StopDate] [datetime2](7) NULL,
	[StopTime] [nvarchar](max) NULL,
	[StoppingNote] [nvarchar](max) NULL,
	[HoldDate] [datetime2](7) NULL,
	[HoldingTime] [nvarchar](max) NULL,
	[HoldingNote] [nvarchar](max) NULL,
	[DoseId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[DoseStatus] [nvarchar](max) NULL,
	[DoctorId] [uniqueidentifier] NOT NULL,
	[ConsultantId] [uniqueidentifier] NOT NULL,
	[IsDischargeCertificate] [bit] NOT NULL,
	[IsManualBrand] [bit] NOT NULL,
	[ManualBrand] [nvarchar](max) NULL,
	[RouteOfAdministration] [nvarchar](max) NULL,
	[DisplayOrder] [int] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_RxIpdTreatments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[SaveConsultancyPaymentRecordDetails]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[SaveConsultancyPaymentRecordDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[RecordId] [uniqueidentifier] NOT NULL,
	[ServiceRecordId] [uniqueidentifier] NOT NULL,
	[ServicePayableAmount] [float] NOT NULL,
	[ServiceType] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_SaveConsultancyPaymentRecordDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[SaveConsultancyPaymentRecords]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[SaveConsultancyPaymentRecords](
	[Id] [uniqueidentifier] NOT NULL,
	[InvoiceNo] [bigint] NOT NULL,
	[ConsultantId] [uniqueidentifier] NOT NULL,
	[PayDate] [datetime2](7) NULL,
	[Amount] [float] NOT NULL,
	[DateFrom] [datetime2](7) NULL,
	[DateTo] [datetime2](7) NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_SaveConsultancyPaymentRecords] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[ServiceExecutingHeadRates]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[ServiceExecutingHeadRates](
	[Id] [uniqueidentifier] NOT NULL,
	[ServiceExecutingHeadId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
	[Rate] [real] NOT NULL,
	[ConsultantCommInPercent] [int] NOT NULL,
	[DocVisit] [bit] NOT NULL,
	[HospitalCommInPercent] [int] NOT NULL,
	[IsServiceChargeApplicable] [bit] NOT NULL,
	[OpdShow] [bit] NOT NULL,
	[PoorFund] [real] NOT NULL,
	[ProcedureWeight] [nvarchar](max) NULL,
	[ServiceChargeInPercent] [int] NOT NULL,
	[VAT] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_ServiceExecutingHeadRates] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[ServiceExecutingHeads]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[ServiceExecutingHeads](
	[Id] [uniqueidentifier] NOT NULL,
	[HeadName] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[ServiceCode] [nvarchar](max) NULL,
	[ServiceType] [nvarchar](max) NULL,
	[ServiceSubSubGroupId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_ServiceExecutingHeads] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[ServiceGroups]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[ServiceGroups](
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_ServiceGroups] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[ServiceIncomeShares]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[ServiceIncomeShares](
	[Id] [uniqueidentifier] NOT NULL,
	[ExecutingServiceHeadId] [uniqueidentifier] NOT NULL,
	[HospitalShareInPercent] [float] NOT NULL,
	[HospitalShareInTk] [float] NOT NULL,
	[DoctorShareInPercent] [float] NOT NULL,
	[DoctorShareInTk] [float] NOT NULL,
	[DoctorDutyType] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
	[DoctorId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_ServiceIncomeShares] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[ServicePackages]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[ServicePackages](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[TotalAmount] [real] NOT NULL,
	[TenantId] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[PackageDuration] [int] NOT NULL,
 CONSTRAINT [PK_ServicePackages] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[ServiceSubGroups]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[ServiceSubGroups](
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[ServiceGroupId] [uniqueidentifier] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_ServiceSubGroups] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[ServiceSubSubGroups]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[ServiceSubSubGroups](
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[ServiceSubGroupId] [uniqueidentifier] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_ServiceSubSubGroups] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[SMSNotifications]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[SMSNotifications](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientRecordId] [uniqueidentifier] NOT NULL,
	[SMSText] [nvarchar](max) NULL,
	[SMSTo] [nvarchar](max) NULL,
	[Status] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[ServiceUnitId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_SMSNotifications] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[SurgeryProcedures]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[SurgeryProcedures](
	[Id] [uniqueidentifier] NOT NULL,
	[Title] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[AreaOfOT] [nvarchar](max) NULL,
	[TenantId] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_SurgeryProcedures] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[TransferNotes]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[TransferNotes](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientRecordId] [uniqueidentifier] NOT NULL,
	[OTScheduleId] [uniqueidentifier] NOT NULL,
	[NoteDateTime] [datetime2](7) NULL,
	[Note] [ntext] NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_TransferNotes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[VitalSignRecordDetails]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[VitalSignRecordDetails](
	[BindValue] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[DynamicFormDId] [uniqueidentifier] NOT NULL,
	[MasterId] [uniqueidentifier] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[BindDropDownValue] [uniqueidentifier] NOT NULL,
	[ControltypeId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_VitalSignRecordDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Hospital].[VitalSignRecords]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Hospital].[VitalSignRecords](
	[PatientId] [uniqueidentifier] NOT NULL,
	[CheckUpDate] [datetime2](7) NOT NULL,
	[TemplateType] [nvarchar](max) NULL,
	[UseUHIDRecordId] [uniqueidentifier] NOT NULL,
	[UHID] [bigint] NOT NULL,
	[InvoiceNo] [bigint] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[DynamicFormId] [uniqueidentifier] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
	[IndentStatus] [nvarchar](50) NULL,
	[HasValue] [bit] NOT NULL,
	[VitalNo] [bigint] NOT NULL,
 CONSTRAINT [PK_VitalSignRecords] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HR].[ApplicationPermissions]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[ApplicationPermissions](
	[Id] [uniqueidentifier] NOT NULL,
	[StaffRecordId] [uniqueidentifier] NOT NULL,
	[DeptId] [int] NOT NULL,
	[ApplicationForStaffRecordId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_ApplicationPermissions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HR].[AttachedDocs]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[AttachedDocs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[FileName] [nvarchar](max) NULL,
	[FileExtention] [nvarchar](max) NULL,
	[FileContent] [varbinary](max) NULL,
	[StaffRecordId] [uniqueidentifier] NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_AttachedDocs] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HR].[AttendanceRecords]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[AttendanceRecords](
	[Id] [uniqueidentifier] NOT NULL,
	[EntryTime] [datetime2](7) NULL,
	[EmployeeCode] [nvarchar](max) NULL,
	[MachineSerialNo] [nvarchar](max) NULL,
	[InTimeNormal] [datetime2](7) NULL,
	[OutTimeNormal] [datetime2](7) NULL,
	[InTimeOverTime] [datetime2](7) NULL,
	[OutTimeOverTime] [datetime2](7) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_AttendanceRecords] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HR].[Departments]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[Departments](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[DivId] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_Departments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HR].[DeptInchargeDocs]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[DeptInchargeDocs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StaffRecordId] [uniqueidentifier] NULL,
	[Doc] [varbinary](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_DeptInchargeDocs] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HR].[DeptIncharges]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[DeptIncharges](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DeptId] [int] NULL,
	[StaffRecordId] [uniqueidentifier] NULL,
	[AppointmentDate] [datetime2](7) NULL,
	[AppointRemarks] [nvarchar](max) NULL,
	[ReleaseDate] [datetime2](7) NULL,
	[ReleaseRemarks] [nvarchar](max) NULL,
	[IsActive] [bit] NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_DeptIncharges] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HR].[Designations]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[Designations](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[JoiningSalaray] [float] NOT NULL,
	[IncrementAfterConfirmation] [float] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_Designations] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HR].[Divisions]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[Divisions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_Divisions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HR].[DutyExchangeRecords]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[DutyExchangeRecords](
	[Id] [uniqueidentifier] NOT NULL,
	[StaffId] [uniqueidentifier] NOT NULL,
	[Year] [int] NOT NULL,
	[Datefrom] [datetime2](7) NOT NULL,
	[DateTo] [datetime2](7) NOT NULL,
	[TotalDays] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[ExchangeWithStaffId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DutyExchangeRecords] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HR].[DutyRoasterCalender]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[DutyRoasterCalender](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DepartmentId] [int] NULL,
	[SubDepartmentId] [int] NULL,
	[Week] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[RoasterDuration] [nvarchar](max) NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_DutyRoasterCalender] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HR].[DutyRoasterCalenderDetail]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[DutyRoasterCalenderDetail](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ShiftName] [nvarchar](max) NULL,
	[StartTime] [datetime2](7) NULL,
	[EndTime] [datetime2](7) NULL,
	[DutyRoasterCalenderId] [int] NULL,
	[EmployeeIds] [nvarchar](max) NULL,
	[ShifTypeid] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_DutyRoasterCalenderDetail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HR].[DutyRoasterSettings]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[DutyRoasterSettings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StaffRecordId] [uniqueidentifier] NULL,
	[DeptId] [int] NULL,
	[DesignationId] [int] NULL,
	[InTime] [nvarchar](50) NULL,
	[OutTime] [nvarchar](50) NULL,
	[RoasterDate] [date] NULL,
	[LateMinuteApproved] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_DutyRoasterSettings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HR].[EducationalQualifications]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[EducationalQualifications](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[NameOfExam] [nvarchar](max) NULL,
	[Passingyear] [int] NULL,
	[Department] [nvarchar](max) NULL,
	[Cgpa] [nvarchar](max) NULL,
	[Board] [nvarchar](max) NULL,
	[StaffRecordId] [uniqueidentifier] NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_EducationalQualifications] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HR].[EmergencyContacts]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[EmergencyContacts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[EmgName] [nvarchar](max) NULL,
	[EmgContact] [nvarchar](max) NULL,
	[EmgRelation] [nvarchar](max) NULL,
	[StaffRecordId] [uniqueidentifier] NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_EmergencyContacts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HR].[Festivals]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[Festivals](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FestivalName] [nvarchar](250) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_Festivals] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HR].[IndividualEmployeeLeaveEligibles]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[IndividualEmployeeLeaveEligibles](
	[Id] [uniqueidentifier] NOT NULL,
	[IndividualEmployeeLeavePolicyId] [uniqueidentifier] NOT NULL,
	[LeaveTypeId] [int] NOT NULL,
	[LeaveDay] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_IndividualEmployeeLeaveEligibles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HR].[IndividualEmployeeLeavePolices]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[IndividualEmployeeLeavePolices](
	[Id] [uniqueidentifier] NOT NULL,
	[StaffRecordId] [uniqueidentifier] NOT NULL,
	[OneDaySalaryDeductionOnTotalLateCount] [int] NOT NULL,
	[AbsentDeduction] [bit] NOT NULL,
	[TotalYearlyLeave] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[LateConsiderAfterInMins] [int] NOT NULL,
 CONSTRAINT [PK_IndividualEmployeeLeavePolices] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HR].[JobCirculations]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[JobCirculations](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CirculationNo] [nvarchar](max) NULL,
	[CirculationTitle] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_JobCirculations] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HR].[JobCvs]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[JobCvs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Jcid] [int] NOT NULL,
	[Applyfor] [nvarchar](max) NULL,
	[ApplicatName] [nvarchar](max) NULL,
	[ApplicatMobileNo] [nvarchar](max) NULL,
	[FileName] [nvarchar](max) NULL,
	[CvinPdf] [varbinary](max) NULL,
	[CvinWord] [varbinary](max) NULL,
	[Status] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_JobCvs] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HR].[LeaveApplications]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[LeaveApplications](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StaffRecordId] [uniqueidentifier] NOT NULL,
	[StartDate] [datetime2](7) NOT NULL,
	[AppSubject] [nvarchar](max) NULL,
	[LeaveApprovalStatus] [nvarchar](max) NULL,
	[ApplicationInPdf] [varbinary](max) NULL,
	[ApplicationInWord] [varbinary](max) NULL,
	[SentTo] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[EndDate] [datetime2](7) NOT NULL,
	[ApplicationDate] [datetime2](7) NOT NULL,
	[ExtraEndDate] [datetime2](7) NOT NULL,
	[ExtraStartDate] [datetime2](7) NOT NULL,
	[SubstituteStaffId] [uniqueidentifier] NOT NULL,
	[TotalLeaveQTY] [int] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[LeaveTypeNames] [nvarchar](max) NULL,
 CONSTRAINT [PK_LeaveApplications] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HR].[LeaveApprovalSettings]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[LeaveApprovalSettings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ApprovLevel] [nvarchar](max) NULL,
	[DeptId] [int] NULL,
	[LevelApprovebyLoginUserId] [uniqueidentifier] NULL,
	[LevelApprovebyStaffRecordId] [uniqueidentifier] NOT NULL,
	[LevelTagKey] [nvarchar](max) NULL,
	[LevelOrder] [int] NOT NULL,
	[IsThisTheHighestLevelApproval] [bit] NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_LeaveApprovalSettings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HR].[LeaveApproveOnDifferentLevels]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[LeaveApproveOnDifferentLevels](
	[Id] [uniqueidentifier] NOT NULL,
	[LeaveApplicationsId] [int] NOT NULL,
	[LevelTagKey] [nvarchar](max) NULL,
	[ApprovedStartDate] [datetime2](7) NOT NULL,
	[ApprovedEndDate] [datetime2](7) NOT NULL,
	[DayCount] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_LeaveApproveOnDifferentLevels] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HR].[LeavePolicies]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[LeavePolicies](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Year] [int] NOT NULL,
	[Cl] [int] NOT NULL,
	[Ml] [int] NOT NULL,
	[MedicalLeave] [int] NOT NULL,
	[AbsentDeduction] [bit] NOT NULL,
	[LateConsiderAfterMins] [int] NOT NULL,
	[OnedaySalaryDeductionForLateInDays] [int] NOT NULL,
	[AnnualLeave] [int] NOT NULL,
	[FestivalLeave] [int] NOT NULL,
	[GovtLeave] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[TotalYearlyLeave] [int] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_LeavePolicies] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HR].[LeaveRecords]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[LeaveRecords](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StaffId] [uniqueidentifier] NOT NULL,
	[Year] [int] NOT NULL,
	[Datefrom] [datetime2](7) NOT NULL,
	[DateTo] [datetime2](7) NOT NULL,
	[TotalDays] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[LeavePurpose] [nvarchar](max) NULL,
 CONSTRAINT [PK_LeaveRecords] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HR].[LeaveTypes]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[LeaveTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_LeaveTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HR].[ManualAttendances]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[ManualAttendances](
	[Id] [uniqueidentifier] NOT NULL,
	[StaffRecordId] [uniqueidentifier] NOT NULL,
	[BDateTime] [datetime2](7) NOT NULL,
	[InTime] [nvarchar](max) NULL,
	[OutTime] [nvarchar](max) NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_ManualAttendances] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HR].[MaternityLeaveRecords]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[MaternityLeaveRecords](
	[Id] [uniqueidentifier] NOT NULL,
	[StaffId] [uniqueidentifier] NOT NULL,
	[Year] [int] NOT NULL,
	[Datefrom] [datetime2](7) NOT NULL,
	[DateTo] [datetime2](7) NOT NULL,
	[TotalDays] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_MaternityLeaveRecords] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HR].[OverManageDutyRecords]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[OverManageDutyRecords](
	[Id] [uniqueidentifier] NOT NULL,
	[StaffId] [uniqueidentifier] NOT NULL,
	[Year] [int] NOT NULL,
	[DutyDatefrom] [datetime2](7) NOT NULL,
	[DutyDateTo] [datetime2](7) NOT NULL,
	[LeaveDatefrom] [datetime2](7) NOT NULL,
	[LeaveDateTo] [datetime2](7) NOT NULL,
	[TotalDays] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_OverManageDutyRecords] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HR].[PFSettlements]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[PFSettlements](
	[Id] [uniqueidentifier] NOT NULL,
	[StaffRecordId] [uniqueidentifier] NOT NULL,
	[ApprovedBy] [uniqueidentifier] NOT NULL,
	[Reference] [nvarchar](100) NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HR].[RoasterType]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[RoasterType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NULL,
	[StartTime] [nvarchar](max) NULL,
	[EndTime] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[DepartmentId] [int] NOT NULL,
	[ShortDescription] [nvarchar](50) NULL,
 CONSTRAINT [PK_RoasterType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HR].[StaffFestivalMappings]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[StaffFestivalMappings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StaffRecordId] [uniqueidentifier] NOT NULL,
	[Festivald] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_StaffFestivalMappings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HR].[StaffRecords]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[StaffRecords](
	[Id] [uniqueidentifier] NOT NULL,
	[SubDeptId] [int] NULL,
	[DeptId] [int] NOT NULL,
	[DesignationId] [int] NOT NULL,
	[EmployeeName] [nvarchar](350) NULL,
	[JoiningDate] [datetime2](7) NOT NULL,
	[EmployeeNo] [nvarchar](50) NULL,
	[FirstName] [nvarchar](250) NULL,
	[MiddleName] [nvarchar](max) NULL,
	[LastName] [nvarchar](max) NULL,
	[FatherName] [nvarchar](max) NULL,
	[MotherName] [nvarchar](max) NULL,
	[PermanentAddress] [nvarchar](max) NULL,
	[PresentAddress] [nvarchar](max) NULL,
	[MobileNo] [nvarchar](max) NULL,
	[EmailId] [nvarchar](max) NULL,
	[BloodGroup] [nvarchar](max) NULL,
	[Religion] [nvarchar](max) NULL,
	[DateofBirth] [datetime2](7) NULL,
	[Sex] [nvarchar](max) NULL,
	[MaritalStatus] [nvarchar](max) NULL,
	[Nationality] [int] NOT NULL,
	[NationIdorPpno] [nvarchar](max) NULL,
	[DivisionId] [int] NULL,
	[Confirmationdate] [datetime2](7) NULL,
	[EmployeeCategory] [int] NOT NULL,
	[EmployeeJobLocation] [nvarchar](max) NULL,
	[Jcid] [int] NOT NULL,
	[Jcvid] [int] NOT NULL,
	[BiometricEnrollmentNo] [int] NOT NULL,
	[IsHoD] [bit] NOT NULL,
	[ProvableConfirmationdate] [datetime2](7) NULL,
	[OfficialMobileNo] [nvarchar](max) NULL,
	[Remarks] [nvarchar](max) NULL,
	[WorkingTime] [nvarchar](max) NULL,
	[TimeofInterval] [nvarchar](max) NULL,
	[WeeklyHoliday] [nvarchar](max) NULL,
	[ShiftAndRelay] [nvarchar](max) NULL,
	[DescriptionOfChangeGroup] [nvarchar](max) NULL,
	[ProficePicture] [varbinary](max) NULL,
	[ServiceNature] [nvarchar](50) NOT NULL,
	[SalaryStatus] [nvarchar](50) NOT NULL,
	[PaymentMode] [nvarchar](50) NULL,
	[BankAccountNo] [nvarchar](50) NULL,
	[IsSeparated] [bit] NOT NULL,
	[IsInActive] [bit] NOT NULL,
	[InActiveReasons] [nvarchar](500) NULL,
	[ResignationDate] [datetime2](7) NULL,
	[TenantId] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TINNo] [nvarchar](max) NULL,
	[IsPFSettled] [bit] NOT NULL,
 CONSTRAINT [PK_StaffRecords] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [HR].[SubDepartments]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [HR].[SubDepartments](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DeptId] [int] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_SubDepartments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Identity].[RoleClaims]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Identity].[RoleClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Group] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[RoleId] [nvarchar](450) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_RoleClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Identity].[Roles]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Identity].[Roles](
	[Id] [nvarchar](450) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[Name] [nvarchar](256) NULL,
	[NormalizedName] [nvarchar](256) NULL,
	[ConcurrencyStamp] [nvarchar](max) NULL,
	[IsSynced] [bit] NOT NULL,
	[ParentId] [nvarchar](50) NULL,
 CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Identity].[UserClaims]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Identity].[UserClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](450) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_UserClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Identity].[UserLogins]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Identity].[UserLogins](
	[LoginProvider] [nvarchar](450) NOT NULL,
	[ProviderKey] [nvarchar](450) NOT NULL,
	[ProviderDisplayName] [nvarchar](max) NULL,
	[UserId] [nvarchar](450) NOT NULL,
 CONSTRAINT [PK_UserLogins] PRIMARY KEY CLUSTERED 
(
	[LoginProvider] ASC,
	[ProviderKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Identity].[UserRoles]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Identity].[UserRoles](
	[UserId] [nvarchar](450) NOT NULL,
	[RoleId] [nvarchar](450) NOT NULL,
	[IsSynced] [bit] NULL,
 CONSTRAINT [PK_UserRoles] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Identity].[Users]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Identity].[Users](
	[Id] [nvarchar](450) NOT NULL,
	[FirstName] [nvarchar](max) NULL,
	[LastName] [nvarchar](max) NULL,
	[FullName] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[DeletedOn] [datetime2](7) NULL,
	[IsActive] [bit] NOT NULL,
	[StaffRecordId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NOT NULL,
	[UserName] [nvarchar](256) NULL,
	[NormalizedUserName] [nvarchar](256) NULL,
	[Email] [nvarchar](256) NULL,
	[NormalizedEmail] [nvarchar](256) NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[SecurityStamp] [nvarchar](max) NULL,
	[ConcurrencyStamp] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[PhoneNumberConfirmed] [bit] NOT NULL,
	[TwoFactorEnabled] [bit] NOT NULL,
	[LockoutEnd] [datetimeoffset](7) NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[AccessFailedCount] [int] NOT NULL,
	[DoctorId] [uniqueidentifier] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[ProfilePictureDataUrl] [nvarchar](250) NULL,
	[RefreshToken] [nvarchar](max) NOT NULL,
	[RefreshTokenExpiryTime] [datetime] NOT NULL,
	[ApiKey] [nvarchar](250) NULL,
	[Salt] [nvarchar](250) NULL,
	[BaseModule] [nvarchar](250) NULL,
	[ExpireDate] [nvarchar](250) NULL,
	[TechnologistId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Identity].[UserTokens]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Identity].[UserTokens](
	[UserId] [nvarchar](450) NOT NULL,
	[LoginProvider] [nvarchar](450) NOT NULL,
	[Name] [nvarchar](450) NOT NULL,
	[Value] [nvarchar](max) NULL,
 CONSTRAINT [PK_UserTokens] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[LoginProvider] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [ITAXTDS].[IncomeTaxActAndTDSRules]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ITAXTDS].[IncomeTaxActAndTDSRules](
	[Id] [uniqueidentifier] NOT NULL,
	[RuleDescription] [nvarchar](max) NULL,
	[Remarks] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_IncomeTaxActAndTDSRules] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [ITAXTDS].[IncomeTaxAndTDS]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ITAXTDS].[IncomeTaxAndTDS](
	[Id] [uniqueidentifier] NOT NULL,
	[IncomeTaxActAndTDSRuleId] [uniqueidentifier] NOT NULL,
	[CategoryName] [nvarchar](max) NULL,
	[TDSInPercent] [real] NOT NULL,
	[Remarks] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_IncomeTaxAndTDS] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Location].[Districts]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Location].[Districts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DivisionId] [int] NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[BnName] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_Districts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Location].[Divisions]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Location].[Divisions](
	[Id] [int] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_Divisions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Log].[UserActivityLog]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Log].[UserActivityLog](
	[Id] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[ActivityType] [int] NOT NULL,
	[ActivityDetails] [nvarchar](max) NULL,
	[Timestamp] [datetime2](7) NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[ModuleType] [int] NOT NULL,
	[TableName] [nvarchar](max) NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_UserActivityLog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Marketing].[CommissionGroups]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Marketing].[CommissionGroups](
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_CommissionGroups] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Marketing].[CommissionSetups]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Marketing].[CommissionSetups](
	[Id] [uniqueidentifier] NOT NULL,
	[TestItemId] [uniqueidentifier] NOT NULL,
	[CommissionInPercent] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[CommissionGroupId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_CommissionSetups] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Marketing].[CorporateClients]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Marketing].[CorporateClients](
	[Name] [nvarchar](max) NOT NULL,
	[Address] [nvarchar](max) NULL,
	[ContactPerson] [nvarchar](max) NOT NULL,
	[ContactNumber] [nvarchar](max) NOT NULL,
	[Maid] [int] NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[DiscountGroupId] [uniqueidentifier] NOT NULL,
	[IsCash] [bit] NOT NULL,
	[IsCredit] [bit] NOT NULL,
	[InGross] [bit] NOT NULL,
	[InPercent] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_CorporateClients] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Marketing].[DoctorCommissions]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Marketing].[DoctorCommissions](
	[Id] [uniqueidentifier] NOT NULL,
	[Commission] [real] NULL,
	[DoctorId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[ServiceExecutingHeadId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DoctorCommissions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Marketing].[DoctorFieldOfSpecialities]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Marketing].[DoctorFieldOfSpecialities](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_DoctorFieldOfSpecialities] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Marketing].[Doctors]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Marketing].[Doctors](
	[Id] [uniqueidentifier] NOT NULL,
	[DoctorFieldOfSpecialityId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[DoctorCodeNo] [nvarchar](max) NULL,
	[PhoneFax] [nvarchar](max) NULL,
	[ProfessionalIdentity1] [nvarchar](max) NULL,
	[ProfessionalIdentity2] [nvarchar](max) NULL,
	[ProfessionalIdentity3] [nvarchar](max) NULL,
	[ProfessionalIdentity4] [nvarchar](max) NULL,
	[ProfessionalIdentity5] [nvarchar](max) NULL,
	[ProfessionalIdentity6] [nvarchar](max) NULL,
	[CurrentWorkPlace] [nvarchar](max) NULL,
	[PastWorkplace] [nvarchar](max) NULL,
	[OPDChamberVisitFeeMaiden] [float] NOT NULL,
	[OPDChamberVisitFeeNew] [float] NOT NULL,
	[OPDChamberVisitFeeOld] [float] NOT NULL,
	[OPDChamberReportConsultancyFee] [float] NOT NULL,
	[SelfChamberVisitFeeMaiden] [float] NOT NULL,
	[SelfChamberVisitFeeNew] [float] NOT NULL,
	[SelfChamberVisitFeeOld] [float] NOT NULL,
	[SelfChamberReportConsultancyFee] [float] NOT NULL,
	[IPDWordVisitFee] [float] NOT NULL,
	[MarketingJOfficerOrMediaId] [uniqueidentifier] NOT NULL,
	[ExtraAmount] [float] NOT NULL,
	[IsPathologyReporter] [bit] NOT NULL,
	[IsImagingReporter] [bit] NOT NULL,
	[IsChamberPractitioner] [bit] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Type] [nvarchar](max) NULL,
	[IsActive] [bit] NOT NULL,
	[RxDepartmentId] [int] NOT NULL,
 CONSTRAINT [PK_Doctors] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Marketing].[DoctorServiceTypes]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Marketing].[DoctorServiceTypes](
	[Id] [uniqueidentifier] NOT NULL,
	[TypeName] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_DoctorServiceTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Marketing].[FeederTenants]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Marketing].[FeederTenants](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Address] [nvarchar](max) NULL,
	[Hotline] [nvarchar](max) NULL,
	[Division] [nvarchar](max) NULL,
	[District] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_FeederTenants] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Marketing].[GrossSalesTargets]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Marketing].[GrossSalesTargets](
	[Id] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NOT NULL,
	[Month] [int] NOT NULL,
	[Year] [int] NOT NULL,
	[TargetAmount] [float] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_GrossSalesTargets] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Marketing].[HoDs]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Marketing].[HoDs](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[PhoneNumber] [nvarchar](max) NULL,
 CONSTRAINT [PK_HoDs] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Marketing].[MarketingJOfficerOrMedias]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Marketing].[MarketingJOfficerOrMedias](
	[Id] [uniqueidentifier] NOT NULL,
	[MarketingOfficerId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[RoleType] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[Code] [nvarchar](max) NULL,
	[CommissionGroupId] [uniqueidentifier] NOT NULL,
	[Address] [nvarchar](max) NULL,
 CONSTRAINT [PK_MarketingJOfficerOrMedias] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Marketing].[MarketingManagers]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Marketing].[MarketingManagers](
	[Id] [uniqueidentifier] NOT NULL,
	[HoDId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[PhoneNumber] [nvarchar](max) NULL,
 CONSTRAINT [PK_MarketingManagers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Marketing].[MarketingOfficers]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Marketing].[MarketingOfficers](
	[Id] [uniqueidentifier] NOT NULL,
	[MarketingManagerId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[PhoneNumber] [nvarchar](max) NULL,
 CONSTRAINT [PK_MarketingOfficers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Marketing].[MarketingZoneMappings]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Marketing].[MarketingZoneMappings](
	[Id] [uniqueidentifier] NOT NULL,
	[MarketingJOfficerOrMediaId] [uniqueidentifier] NOT NULL,
	[MarketingZoneId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_MarketingZoneMappings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Marketing].[MarketingZones]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Marketing].[MarketingZones](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_MarketingZones] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Marketing].[Medias]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Marketing].[Medias](
	[Id] [uniqueidentifier] NOT NULL,
	[MarketingJOfficerOrMediaId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CodeNo] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_Medias] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Marketing].[MPOSalesTargets]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Marketing].[MPOSalesTargets](
	[Id] [uniqueidentifier] NOT NULL,
	[MarketingJOfficerOrMediaId] [uniqueidentifier] NOT NULL,
	[Month] [int] NOT NULL,
	[Year] [int] NOT NULL,
	[TargetAmount] [float] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_MPOSalesTargets] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Menu].[MenuPermissions]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Menu].[MenuPermissions](
	[RoleId] [nvarchar](max) NULL,
	[IsPermissionGranted] [bit] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[MenuId] [uniqueidentifier] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_MenuPermissions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Nutrition].[CabinTypeAndMealMappings]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Nutrition].[CabinTypeAndMealMappings](
	[Id] [uniqueidentifier] NOT NULL,
	[MealTypeId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[CabinTypeId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_CabinTypeAndMealMappings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Nutrition].[FoodDeliverableDetails]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Nutrition].[FoodDeliverableDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[FoodDeliverableId] [uniqueidentifier] NOT NULL,
	[Qty] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[ItemId ] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_FoodDeliverableDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Nutrition].[FoodDeliverables]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Nutrition].[FoodDeliverables](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDFoodIndentId] [uniqueidentifier] NOT NULL,
	[Status] [nvarchar](max) NULL,
	[MealTypeId] [uniqueidentifier] NOT NULL,
	[FoodPatternGroupId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Remarks] [nvarchar](max) NULL,
	[ReviewedByUserId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
	[IsChanged] [bit] NOT NULL,
	[ReviewedAt] [datetime] NULL,
	[ServedAt] [datetime] NULL,
 CONSTRAINT [PK_FoodDeliverables] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Nutrition].[FoodPatternDetail]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Nutrition].[FoodPatternDetail](
	[Id] [uniqueidentifier] NOT NULL,
	[FoodPatternId] [uniqueidentifier] NOT NULL,
	[Qty] [int] NOT NULL,
	[Status] [nvarchar](max) NULL,
	[Remarks] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[ItemId ] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_FoodPatternDetail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Nutrition].[FoodPatternGroups]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Nutrition].[FoodPatternGroups](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_FoodPatternGroups] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Nutrition].[FoodPatterns]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Nutrition].[FoodPatterns](
	[Id] [uniqueidentifier] NOT NULL,
	[FoodPatternGroupId] [uniqueidentifier] NOT NULL,
	[MealTypeId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_FoodPatterns] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Nutrition].[MealTypes]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Nutrition].[MealTypes](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[OrderValue] [int] NOT NULL,
 CONSTRAINT [PK_MealTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [OPD].[ChamberPractionerRoutines]    Script Date: 09/27/25 11:19:26 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [OPD].[ChamberPractionerRoutines](
	[Id] [uniqueidentifier] NOT NULL,
	[DoctorId] [uniqueidentifier] NOT NULL,
	[BusinessDate] [datetime2](7) NULL,
	[IsChamberOpen] [bit] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_ChamberPractionerRoutines] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [OPD].[ChamberPractionerSettings]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [OPD].[ChamberPractionerSettings](
	[Id] [uniqueidentifier] NOT NULL,
	[DoctorId] [uniqueidentifier] NOT NULL,
	[ChamberStartTime] [datetime2](7) NULL,
	[TimeInterval] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[PatientCount] [int] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_ChamberPractionerSettings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [OPD].[ConsultancyDetails]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [OPD].[ConsultancyDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[PatientId] [uniqueidentifier] NOT NULL,
	[Qty] [int] NOT NULL,
	[Rate] [real] NOT NULL,
	[TotalAmount] [real] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[ServiceId] [uniqueidentifier] NOT NULL,
	[IsCancelApproved] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_ConsultancyDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [OPD].[CPFeeCollectionRecords]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [OPD].[CPFeeCollectionRecords](
	[Id] [uniqueidentifier] NOT NULL,
	[CPPatientRecordId] [uniqueidentifier] NOT NULL,
	[CPId] [uniqueidentifier] NOT NULL,
	[VisitTypeId] [uniqueidentifier] NOT NULL,
	[VisitDate] [datetime2](7) NULL,
	[VisitFee] [float] NOT NULL,
	[Status] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_CPFeeCollectionRecords] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [OPD].[CPLedgers]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [OPD].[CPLedgers](
	[Id] [uniqueidentifier] NOT NULL,
	[TranDate] [datetime2](7) NOT NULL,
	[PatientId] [uniqueidentifier] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Debit] [real] NOT NULL,
	[Credit] [real] NOT NULL,
	[Balance] [real] NOT NULL,
	[TransactionType] [int] NOT NULL,
	[PaymentChannelId] [int] NOT NULL,
	[PosTerminalId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_CPLedgers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [OPD].[CPPatientRecords]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [OPD].[CPPatientRecords](
	[Id] [uniqueidentifier] NOT NULL,
	[InvoiceNo] [bigint] NOT NULL,
	[DoctorAppointmentId] [uniqueidentifier] NOT NULL,
	[UHID] [bigint] NOT NULL,
	[FullName] [nvarchar](max) NULL,
	[MobileNo] [nvarchar](max) NULL,
	[AgeYear] [nvarchar](max) NULL,
	[AgeMonth] [nvarchar](max) NULL,
	[AgeDay] [nvarchar](max) NULL,
	[Gender] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_CPPatientRecords] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [OPD].[DoctorAppointments]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [OPD].[DoctorAppointments](
	[Id] [uniqueidentifier] NOT NULL,
	[UHID] [bigint] NOT NULL,
	[DoctorId] [uniqueidentifier] NOT NULL,
	[VisitTypeId] [uniqueidentifier] NOT NULL,
	[AppointmentDate] [datetime2](7) NOT NULL,
	[AppointmentTime] [nvarchar](max) NULL,
	[Fee] [float] NOT NULL,
	[Status] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Remarks] [nvarchar](max) NULL,
	[SerialNo] [int] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
	[FullName] [nvarchar](max) NULL,
	[AgeYear] [nvarchar](max) NULL,
	[AgeMonth] [nvarchar](max) NULL,
	[AgeDay] [nvarchar](max) NULL,
	[Sex] [nvarchar](max) NULL,
	[MobileNo] [nvarchar](max) NULL,
	[Dob] [datetime2](7) NULL,
	[RxInitDDate] [date] NULL,
	[RefdDoctorId] [uniqueidentifier] NOT NULL,
	[ReleventHistory] [nvarchar](max) NOT NULL,
	[ClinicalFindings] [nvarchar](max) NOT NULL,
	[ClinicalImpression] [nvarchar](max) NOT NULL,
	[MedicineServeStatus] [nvarchar](max) NOT NULL,
	[RxDepartmentId] [int] NOT NULL,
 CONSTRAINT [PK_DoctorAppointments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [OPD].[OPDConsultancyLedger]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [OPD].[OPDConsultancyLedger](
	[Id] [uniqueidentifier] NOT NULL,
	[TranDate] [datetime2](7) NOT NULL,
	[PatientId] [uniqueidentifier] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Debit] [real] NOT NULL,
	[Credit] [real] NOT NULL,
	[Balance] [real] NOT NULL,
	[TransactionType] [int] NOT NULL,
	[PaymentChannelId] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[PosTerminalId] [uniqueidentifier] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Remarks] [nvarchar](max) NULL,
	[TenantId] [int] NULL,
	[DiscountCategoryId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_OPDConsultancyLedger] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [OPD].[OPDIncomeSharings]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [OPD].[OPDIncomeSharings](
	[HospitalShareInPercent] [int] NOT NULL,
	[DepartmnetShareInPercent] [int] NOT NULL,
	[DoctorShareFromDepartmentInPercent] [int] NOT NULL,
	[NurseShareFromDepartmentInPercent] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_OPDIncomeSharings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [OPD].[OPDPatientHistories]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [OPD].[OPDPatientHistories](
	[PatientId] [uniqueidentifier] NOT NULL,
	[CheckUpDate] [datetime2](7) NOT NULL,
	[TemplateType] [nvarchar](max) NULL,
	[EntryDate] [datetime2](7) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[DynamicFormId] [uniqueidentifier] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_OPDPatientHistories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [OPD].[OPDPatientHistoryDetails]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [OPD].[OPDPatientHistoryDetails](
	[ControltypeId] [int] NOT NULL,
	[BindValue] [nvarchar](max) NULL,
	[BindDropDownValue] [int] NOT NULL,
	[DynamicFormDId] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[MasterId] [uniqueidentifier] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_OPDPatientHistoryDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [OPD].[OPDPrescriptions]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [OPD].[OPDPrescriptions](
	[Id] [uniqueidentifier] NOT NULL,
	[AppointmentId] [uniqueidentifier] NOT NULL,
	[VisitId] [uniqueidentifier] NOT NULL,
	[VisitDate] [datetime2](7) NOT NULL,
	[AdmissionUnderDoctorId] [uniqueidentifier] NOT NULL,
	[AdmissionUnderDepartmentId] [uniqueidentifier] NOT NULL,
	[PrescriptionType] [nvarchar](max) NULL,
	[IsInformed] [bit] NOT NULL,
	[TreatmentGivenInEmergency] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[OPDRxNo] [bigint] NOT NULL,
	[VitalId] [uniqueidentifier] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [OPD].[OPDServiceLedger]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [OPD].[OPDServiceLedger](
	[Id] [uniqueidentifier] NOT NULL,
	[TranDate] [datetime2](7) NOT NULL,
	[PatientId] [uniqueidentifier] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Debit] [real] NOT NULL,
	[Credit] [real] NOT NULL,
	[Balance] [real] NOT NULL,
	[TransactionType] [int] NOT NULL,
	[PaymentChannelId] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[PosTerminalId] [uniqueidentifier] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Remarks] [nvarchar](max) NULL,
	[TenantId] [int] NULL,
	[DiscountCategoryId] [uniqueidentifier] NULL,
 CONSTRAINT [PK_OPDServiceLedger] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [OPD].[OTAssistantPaymentDetails]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [OPD].[OTAssistantPaymentDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[RecordId] [uniqueidentifier] NOT NULL,
	[DoctorId] [uniqueidentifier] NOT NULL,
	[Amount] [float] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_OTAssistantPaymentDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [OPD].[OTAssistantPayments]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [OPD].[OTAssistantPayments](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientId] [uniqueidentifier] NOT NULL,
	[EntryDate] [datetime2](7) NULL,
	[OTName] [nvarchar](max) NULL,
	[OTDate] [datetime2](7) NULL,
	[SurgeonFee] [float] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[IPDPatientInvoiceNo] [bigint] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_OTAssistantPayments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [OPD].[PatientRecordConsultancyFees]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [OPD].[PatientRecordConsultancyFees](
	[Id] [uniqueidentifier] NOT NULL,
	[InvoicePrefix] [nvarchar](50) NULL,
	[InvoiceNo] [bigint] NOT NULL,
	[UHID] [bigint] NOT NULL,
	[EntryDate] [datetime2](7) NOT NULL,
	[EntryTime] [nvarchar](50) NULL,
	[AgeYear] [nvarchar](50) NULL,
	[AgeMonth] [nvarchar](50) NULL,
	[AgeDay] [nvarchar](50) NULL,
	[RefdDoctorId] [uniqueidentifier] NOT NULL,
	[VisitTypeId] [uniqueidentifier] NOT NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[IsCancelApproved] [bit] NOT NULL,
	[CancelApprovedBy] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[Gender] [nvarchar](max) NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[FullName] [nvarchar](max) NULL,
	[MobileNo] [nvarchar](max) NULL,
	[TenantId] [int] NOT NULL,
	[MarketingJOfficerOrMediaId] [uniqueidentifier] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Remarks] [nvarchar](max) NULL,
	[ServiceSubSubGroupId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_PatientRecordConsultancyFees] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [OPD].[PatientRecordOPDServices]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [OPD].[PatientRecordOPDServices](
	[Id] [uniqueidentifier] NOT NULL,
	[InvoicePrefix] [nvarchar](50) NULL,
	[InvoiceNo] [bigint] NOT NULL,
	[UHID] [bigint] NOT NULL,
	[EntryDate] [datetime2](7) NOT NULL,
	[EntryTime] [nvarchar](50) NULL,
	[AgeYear] [nvarchar](50) NULL,
	[AgeMonth] [nvarchar](50) NULL,
	[AgeDay] [nvarchar](50) NULL,
	[RefdDoctorId] [uniqueidentifier] NOT NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[IsCancelApproved] [bit] NOT NULL,
	[CancelApprovedBy] [uniqueidentifier] NOT NULL,
	[Gender] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[FullName] [nvarchar](max) NULL,
	[MobileNo] [nvarchar](max) NULL,
	[TenantId] [int] NOT NULL,
	[MarketingJOfficerOrMediaId] [uniqueidentifier] NOT NULL,
	[ServiceByDoctorId] [uniqueidentifier] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Remarks] [nvarchar](max) NULL,
	[ServiceSubSubGroupId] [uniqueidentifier] NOT NULL,
	[SerialNo] [nvarchar](max) NULL,
	[IndentNo] [bigint] NOT NULL,
 CONSTRAINT [PK_PatientRecordOPDServices] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [OPD].[PatientVisitTypes]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [OPD].[PatientVisitTypes](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](100) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_PatientVisitTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [OPD].[Schedules]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [OPD].[Schedules](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](100) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_Schedules] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [OPD].[ServiceDetails]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [OPD].[ServiceDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[PatientId] [uniqueidentifier] NOT NULL,
	[OldId] [int] NULL,
	[ServiceId] [uniqueidentifier] NOT NULL,
	[ServiceByDoctorId] [uniqueidentifier] NOT NULL,
	[Qty] [int] NOT NULL,
	[Rate] [real] NOT NULL,
	[TotalAmount] [real] NOT NULL,
	[IsCancelApproved] [bit] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_ServiceDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Others].[Messages]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Others].[Messages](
	[Id] [uniqueidentifier] NOT NULL,
	[MessageTxt] [nvarchar](max) NULL,
	[MessageDate] [datetime2](7) NULL,
	[IsRead] [bit] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_Messages] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Others].[Notifications]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Others].[Notifications](
	[Id] [uniqueidentifier] NOT NULL,
	[NotificationTxt] [nvarchar](max) NULL,
	[NotifyDate] [datetime2](7) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_Notifications] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Others].[NotificationSentTos]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Others].[NotificationSentTos](
	[Id] [uniqueidentifier] NOT NULL,
	[NotificationId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[IsRead] [bit] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_NotificationSentTos] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Payroll].[AllowancePayments]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Payroll].[AllowancePayments](
	[Id] [uniqueidentifier] NOT NULL,
	[StaffRecordId] [uniqueidentifier] NOT NULL,
	[OtherAllowance] [real] NOT NULL,
	[SpecialAllowance] [real] NOT NULL,
	[PayMonth] [int] NOT NULL,
	[PayYear] [int] NOT NULL,
	[PayDate] [datetime2](7) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_AllowancePayments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Payroll].[ApprovedSalarySheets]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Payroll].[ApprovedSalarySheets](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StaffRecordId] [uniqueidentifier] NOT NULL,
	[SalaryMonth] [int] NOT NULL,
	[SalaryYear] [int] NOT NULL,
	[ApprovalDate] [datetime2](7) NULL,
	[Basic] [float] NOT NULL,
	[HouseRent] [float] NOT NULL,
	[MedAllowance] [float] NOT NULL,
	[Conveyence] [float] NOT NULL,
	[Overtime] [float] NOT NULL,
	[Allowance] [float] NOT NULL,
	[SpecialAllowance] [float] NOT NULL,
	[FestivalBonus] [float] NOT NULL,
	[GTotal] [float] NOT NULL,
	[PF] [float] NOT NULL,
	[OthersDeduction] [float] NOT NULL,
	[LWP] [float] NOT NULL,
	[Punishment] [float] NOT NULL,
	[Advance] [float] NOT NULL,
	[NetPayable] [float] NOT NULL,
	[Approvedby] [nvarchar](max) NULL,
	[PaymentMode] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IncomeTax] [float] NOT NULL,
	[Arrear] [float] NOT NULL,
	[IsCommit] [bit] NOT NULL,
	[OtherAllowance] [float] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_ApprovedSalarySheets] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Payroll].[AprovedFestivalBonuses]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Payroll].[AprovedFestivalBonuses](
	[Id] [uniqueidentifier] NOT NULL,
	[StaffRecordId] [uniqueidentifier] NOT NULL,
	[FestvalId] [int] NOT NULL,
	[BonusYear] [int] NOT NULL,
	[BonusMonth] [int] NOT NULL,
	[TotalSalary] [float] NOT NULL,
	[BasicAmount] [float] NOT NULL,
	[BonusAmount] [float] NOT NULL,
	[IsCommit] [bit] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_AprovedFestivalBonuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Payroll].[ArrearRecords]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Payroll].[ArrearRecords](
	[Id] [uniqueidentifier] NOT NULL,
	[StaffRecordId] [uniqueidentifier] NOT NULL,
	[EntryDate] [datetime2](7) NOT NULL,
	[PayableMonth] [int] NOT NULL,
	[PayableYear] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[Amount] [float] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_ArrearRecords] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Payroll].[FestivalBonuses]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Payroll].[FestivalBonuses](
	[Id] [uniqueidentifier] NOT NULL,
	[FestivalId] [int] NOT NULL,
	[Month] [int] NOT NULL,
	[Year] [int] NOT NULL,
	[DateFrom] [datetime2](7) NULL,
	[DateTo] [datetime2](7) NULL,
	[BonusPercentOfBasic] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_FestivalBonuses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Payroll].[GeneralSalaryPolicies]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Payroll].[GeneralSalaryPolicies](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[BasicInPercentOfTotalAmount] [float] NULL,
	[HouseRentInPercentOfBasic] [float] NULL,
	[MedicalInPercentOfBasic] [float] NULL,
	[PfinPercentOfBasic] [float] NULL,
	[CpfinPercentOfBasic] [float] NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[PolicyName] [nvarchar](max) NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_GeneralSalaryPolicies] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Payroll].[incometaxcertificate]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Payroll].[incometaxcertificate](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[GroupName] [nvarchar](50) NULL,
	[Particulars] [nvarchar](50) NULL,
	[Amount] [float] NULL,
	[Column4] [nvarchar](50) NULL,
	[Column5] [nvarchar](50) NULL,
	[IsSynced] [bit] NULL,
 CONSTRAINT [PK_payroll.incometaxcertificate] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Payroll].[IncrementRecords]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Payroll].[IncrementRecords](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StaffRecordId] [uniqueidentifier] NOT NULL,
	[Incrementdate] [datetime2](7) NOT NULL,
	[Month] [int] NOT NULL,
	[Year] [int] NOT NULL,
	[Increment] [float] NULL,
	[TotalInrementedAmount] [float] NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[Arrear] [float] NULL,
	[IsCommit] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_IncrementRecords] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Payroll].[IncrementTypes]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Payroll].[IncrementTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_IncrementTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Payroll].[IndividualSalaries]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Payroll].[IndividualSalaries](
	[Id] [uniqueidentifier] NOT NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[HouseRentInPercentOfBasic] [float] NOT NULL,
	[MedicalAllownceInPercentOfBasic] [float] NOT NULL,
	[Conveyance] [float] NOT NULL,
	[BasicAmount] [float] NOT NULL,
	[Others] [float] NULL,
	[SpecialAllowance] [float] NULL,
	[Pf] [float] NULL,
	[Cpf] [float] NULL,
	[TotalSalary] [float] NULL,
	[OvertimePerHour] [float] NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsPFDeductionOn] [bit] NOT NULL,
	[GeneralSalaryPolicyId] [int] NOT NULL,
	[IncermentTypeId] [int] NOT NULL,
	[FixedAmount] [float] NULL,
	[SalaryEvaluationDurationId] [int] NOT NULL,
	[TaxableAmount] [float] NOT NULL,
	[OtherAllowance] [float] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_IndividualSalaries] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Payroll].[IndividualSalariesIncomeTax]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Payroll].[IndividualSalariesIncomeTax](
	[EmployeeId] [uniqueidentifier] NULL,
	[TaxYear] [int] NULL,
	[NetTaxPayablePerYear] [decimal](18, 2) NULL,
	[NetTaxPayablePerMonth] [decimal](18, 2) NULL,
	[LastModification] [datetime] NULL,
	[TaxMonth] [int] NULL,
	[IsSynced] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [Payroll].[LeaveEncashments]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Payroll].[LeaveEncashments](
	[Id] [uniqueidentifier] NOT NULL,
	[StaffRecordId] [uniqueidentifier] NOT NULL,
	[EncashmentYear] [int] NOT NULL,
	[EncashmentMonth] [int] NOT NULL,
	[Amount] [float] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_LeaveEncashments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Payroll].[MonthlyHrSalarySheet]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Payroll].[MonthlyHrSalarySheet](
	[Autoid] [bigint] IDENTITY(1,1) NOT NULL,
	[EmployeeId] [uniqueidentifier] NULL,
	[EmployeeNo] [nvarchar](50) NULL,
	[EmployeeName] [nvarchar](max) NULL,
	[DeptName] [nvarchar](max) NULL,
	[Designation] [nvarchar](max) NULL,
	[DateOfJoining] [date] NULL,
	[EmployeeNature] [nvarchar](50) NULL,
	[PaymentMode] [nvarchar](50) NULL,
	[Basic] [decimal](12, 2) NULL,
	[HouseRent] [decimal](12, 2) NULL,
	[MedicalAllownceInPercentOfBasic] [decimal](12, 2) NULL,
	[Conveyance] [decimal](12, 2) NULL,
	[OthersAllowance] [decimal](12, 2) NULL,
	[SpecialAllowance] [decimal](12, 2) NULL,
	[TotalSalary] [decimal](12, 2) NULL,
	[overtime] [decimal](12, 2) NULL,
	[FestivalBonus] [decimal](12, 2) NULL,
	[IncomeTax] [decimal](12, 2) NULL,
	[GrossTotal] [decimal](12, 2) NULL,
	[PF] [decimal](12, 2) NULL,
	[TotalDeductCount] [decimal](12, 2) NULL,
	[TotalMonthlyHour] [decimal](12, 2) NULL,
	[Lwp] [decimal](12, 2) NULL,
	[OthersTotalDeduc] [decimal](12, 2) NULL,
	[TotalLWPAmount] [decimal](12, 2) NULL,
	[PunishmentAmount] [decimal](12, 2) NULL,
	[AdvancePaid] [decimal](12, 2) NULL,
	[ArrearSalary] [decimal](12, 2) NULL,
	[TotalPayableSalary] [decimal](12, 2) NULL,
	[TotalDeduction] [decimal](12, 2) NULL,
	[NetPayble] [decimal](12, 2) NULL,
	[PaidAmount] [decimal](12, 2) NULL,
	[Displaystatus] [int] NULL,
	[ProcessDate] [datetime] NULL,
	[SalaryYear] [int] NULL,
	[SalaryMonth] [int] NULL,
	[OtherAllowance] [decimal](12, 2) NULL,
	[IsSynced] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Payroll].[MonthlyHrSalarySheetHistory]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Payroll].[MonthlyHrSalarySheetHistory](
	[Autoid] [bigint] NULL,
	[EmployeeId] [uniqueidentifier] NULL,
	[EmployeeNo] [nvarchar](50) NULL,
	[EmployeeName] [nvarchar](max) NULL,
	[DeptName] [nvarchar](max) NULL,
	[Designation] [nvarchar](max) NULL,
	[DateOfJoining] [date] NULL,
	[EmployeeNature] [nvarchar](50) NULL,
	[PaymentMode] [nvarchar](50) NULL,
	[Basic] [decimal](12, 2) NULL,
	[HouseRent] [decimal](12, 2) NULL,
	[MedicalAllownceInPercentOfBasic] [decimal](12, 2) NULL,
	[Conveyance] [decimal](12, 2) NULL,
	[OthersAllowance] [decimal](12, 2) NULL,
	[SpecialAllowance] [decimal](12, 2) NULL,
	[TotalSalary] [decimal](12, 2) NULL,
	[overtime] [decimal](12, 2) NULL,
	[FestivalBonus] [decimal](12, 2) NULL,
	[IncomeTax] [decimal](12, 2) NULL,
	[GrossTotal] [decimal](12, 2) NULL,
	[PF] [decimal](12, 2) NULL,
	[TotalDeductCount] [decimal](12, 2) NULL,
	[TotalMonthlyHour] [decimal](12, 2) NULL,
	[Lwp] [decimal](12, 2) NULL,
	[OthersTotalDeduc] [decimal](12, 2) NULL,
	[TotalLWPAmount] [decimal](12, 2) NULL,
	[PunishmentAmount] [decimal](12, 2) NULL,
	[AdvancePaid] [decimal](12, 2) NULL,
	[ArrearSalary] [decimal](12, 2) NULL,
	[TotalPayableSalary] [decimal](12, 2) NULL,
	[TotalDeduction] [decimal](12, 2) NULL,
	[NetPayble] [decimal](12, 2) NULL,
	[PaidAmount] [decimal](12, 2) NULL,
	[Displaystatus] [int] NULL,
	[ProcessDate] [datetime] NULL,
	[SalaryYear] [int] NULL,
	[SalaryMonth] [int] NULL,
	[OtherAllowance] [decimal](12, 2) NULL,
	[IsSynced] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Payroll].[PFLedgers]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Payroll].[PFLedgers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StaffRecordId] [uniqueidentifier] NOT NULL,
	[TranDate] [datetime2](7) NOT NULL,
	[Remarks] [nvarchar](max) NULL,
	[Debit] [real] NOT NULL,
	[Credit] [real] NOT NULL,
	[Balance] [real] NOT NULL,
	[TransactionType] [nvarchar](max) NULL,
	[SalaryMonth] [int] NOT NULL,
	[SalaryYear] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_PFLedgers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Payroll].[SalaryCertificateTaxCalculationSlab]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Payroll].[SalaryCertificateTaxCalculationSlab](
	[AutoID] [bigint] NOT NULL,
	[TaxYear] [int] NULL,
	[SlabDisplay] [nvarchar](max) NULL,
	[SlabAmount] [decimal](18, 2) NULL,
	[SlabRateDisplay] [nvarchar](max) NULL,
	[SlabTax] [decimal](18, 2) NULL,
	[SlabRangeMin] [decimal](18, 2) NULL,
	[SlabRangeMax] [decimal](18, 2) NULL,
	[SlabRate] [decimal](18, 2) NULL,
	[SlabStartDate] [date] NULL,
	[SlabEndDate] [date] NULL,
	[AllowableRebatePrecentage] [int] NULL,
	[MaximumLimit] [float] NULL,
	[YearWiseSlabTaxableIncome] [int] NULL,
	[ExemptionHouseRent] [decimal](18, 2) NULL,
	[ExemptionMedicalAllow] [decimal](18, 2) NULL,
	[ExemptionConvAllow] [decimal](18, 2) NULL,
	[IsFirstSlabthisYear] [int] NULL,
 CONSTRAINT [PK_Payroll.SalaryCertificateTaxCalculationSlab] PRIMARY KEY CLUSTERED 
(
	[AutoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Payroll].[SalaryEvaluationDurations]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Payroll].[SalaryEvaluationDurations](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_SalaryEvaluationDurations] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Payroll].[SalaryPunishments]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Payroll].[SalaryPunishments](
	[Id] [uniqueidentifier] NOT NULL,
	[StaffRecordId] [uniqueidentifier] NOT NULL,
	[PunishmentAmount] [float] NULL,
	[SalaryYear] [int] NULL,
	[SalaryMonth] [int] NULL,
	[Description] [nvarchar](max) NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_SalaryPunishments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Payroll].[SalaryStartStopRecords]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Payroll].[SalaryStartStopRecords](
	[Id] [uniqueidentifier] NOT NULL,
	[StaffRecordId] [uniqueidentifier] NOT NULL,
	[StopMonth] [int] NOT NULL,
	[StopYear] [int] NOT NULL,
	[StoppedAmount] [float] NOT NULL,
	[StartMonth] [int] NOT NULL,
	[StartYear] [int] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_SalaryStartStopRecords] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Payroll].[StaffGlobalLedgers]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Payroll].[StaffGlobalLedgers](
	[Id] [uniqueidentifier] NOT NULL,
	[StaffRecordId] [uniqueidentifier] NOT NULL,
	[Particulars] [nvarchar](max) NULL,
	[Debit] [real] NOT NULL,
	[Credit] [real] NOT NULL,
	[Balance] [real] NOT NULL,
	[TransactionType] [nvarchar](max) NULL,
	[ServiceId] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[ReferranceId] [uniqueidentifier] NOT NULL,
	[ServiceUnitId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_StaffGlobalLedgers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Payroll].[StaffMonthlySalaryRecords]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Payroll].[StaffMonthlySalaryRecords](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StaffRecordId] [uniqueidentifier] NOT NULL,
	[PaybleDate] [date] NULL,
	[Month] [int] NOT NULL,
	[Year] [int] NOT NULL,
	[AdvancePaid] [float] NOT NULL,
	[SalaryPaid] [float] NOT NULL,
	[PaymentMode] [nvarchar](50) NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_StaffMonthlySalaryRecords] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Payroll].[StaffOvertimes]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Payroll].[StaffOvertimes](
	[Id] [uniqueidentifier] NOT NULL,
	[StaffRecordId] [uniqueidentifier] NOT NULL,
	[EntryDate] [date] NOT NULL,
	[Days] [int] NOT NULL,
	[PayMonth] [int] NOT NULL,
	[PayYear] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[Hours] [int] NOT NULL,
	[OverTimeMonth] [int] NOT NULL,
	[OverTimeYear] [int] NOT NULL,
	[TotalAmount] [float] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_StaffOvertimes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Payroll].[StaffSalaryDeductions]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Payroll].[StaffSalaryDeductions](
	[Id] [uniqueidentifier] NOT NULL,
	[StaffRecordId] [uniqueidentifier] NULL,
	[Lwp] [float] NULL,
	[AIT] [float] NULL,
	[SM] [float] NULL,
	[MobileBill] [float] NULL,
	[Others] [float] NULL,
	[FoodBill] [float] NULL,
	[month] [int] NULL,
	[year] [int] NULL,
	[AdvanceSalary] [float] NULL,
	[OvertimeDayAmount] [float] NULL,
	[OvertimeHourAmount] [float] NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[OthersDeducation] [float] NULL,
	[IsSynced] [bit] NOT NULL,
	[DeductionCause] [nvarchar](max) NULL,
 CONSTRAINT [PK_StaffSalaryDeductions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Payroll].[TaxSlabs]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Payroll].[TaxSlabs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Amount] [int] NOT NULL,
	[Gender] [nvarchar](max) NULL,
	[TaxInPercent] [int] NOT NULL,
	[FixedExapmtedIncome] [int] NOT NULL,
	[TaxRebateOnTaxableIncome] [int] NOT NULL,
	[TaxRebateOnInvestment] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[SlabStartEndDate] [nvarchar](max) NULL,
 CONSTRAINT [PK_TaxSlabs] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Payroll].[TimedAttendanceLogPullHistories]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Payroll].[TimedAttendanceLogPullHistories](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PullFromDate] [datetime] NOT NULL,
	[PullFromTime] [nvarchar](max) NULL,
	[PullToDate] [datetime] NOT NULL,
	[PullToTime] [nvarchar](max) NULL,
	[PullFromSortableDateTime] [nvarchar](max) NULL,
	[PullToSortableDateTime] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_TimedAttendanceLogPullHistories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Payroll].[TimedAttendanceLogs]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Payroll].[TimedAttendanceLogs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PullId] [int] NOT NULL,
	[MachineNumber] [int] NOT NULL,
	[IndRegID] [int] NOT NULL,
	[StaffRecordId] [uniqueidentifier] NOT NULL,
	[BDate] [datetime] NOT NULL,
	[InTime] [nvarchar](max) NULL,
	[OutTime] [nvarchar](max) NULL,
	[Remarks] [nvarchar](max) NULL,
	[InSortableDateTime] [datetime] NOT NULL,
	[OutSortableDateTime] [datetime] NOT NULL,
	[IndRegID_BDate] [nvarchar](25) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_TimedAttendanceLogs] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Personal].[BloodGroups]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Personal].[BloodGroups](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_BloodGroups] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Personal].[Genders]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Personal].[Genders](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_Genders] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Personal].[MaritalStatus]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Personal].[MaritalStatus](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Status] [nvarchar](max) NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_MaritalStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Personal].[Occupations]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Personal].[Occupations](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_Occupations] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Personal].[Relations]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Personal].[Relations](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_Relations] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Personal].[Religions]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Personal].[Religions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_Religions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Personal].[TitleOrNamePrefixes]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Personal].[TitleOrNamePrefixes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](max) NOT NULL,
	[Gender] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_TitleOrNamePrefixes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Personal].[UpazilaOrAreas]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Personal].[UpazilaOrAreas](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DistrictId] [int] NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[BnName] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_UpazilaOrAreas] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [PFBook].[PFDeposits]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PFBook].[PFDeposits](
	[Id] [uniqueidentifier] NOT NULL,
	[DepositDate] [datetime2](7) NULL,
	[DepositYear] [int] NOT NULL,
	[Month] [nvarchar](max) NULL,
	[ChequeNo] [nvarchar](max) NULL,
	[ChequeDate] [datetime2](7) NULL,
	[Amount] [real] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_PFDeposits] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [PFBook].[PfGeneralLedgers]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PFBook].[PfGeneralLedgers](
	[Id] [uniqueidentifier] NOT NULL,
	[PFLevel4HeadId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[StaffRecordId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_PfGeneralLedgers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [PFBook].[PFLevel4Heads]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PFBook].[PFLevel4Heads](
	[Id] [uniqueidentifier] NOT NULL,
	[PfSubCategoryId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_PFLevel4Heads] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [PFBook].[PfNoAcategories]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PFBook].[PfNoAcategories](
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
 CONSTRAINT [PK_PfNoAcategories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [PFBook].[PFNoAs]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PFBook].[PFNoAs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_PFNoAs] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [PFBook].[PFSubCategories]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PFBook].[PFSubCategories](
	[Id] [uniqueidentifier] NOT NULL,
	[PfNoACategoryId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_PFSubCategories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [PFBook].[PFVoucherMasterDetails]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PFBook].[PFVoucherMasterDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[VDID] [uniqueidentifier] NOT NULL,
	[DTLID] [uniqueidentifier] NOT NULL,
	[SUBDTLID] [int] NOT NULL,
	[Debit] [real] NOT NULL,
	[Credit] [real] NOT NULL,
	[DESCRIPTION] [nvarchar](max) NULL,
	[SeriveId] [uniqueidentifier] NOT NULL,
	[VMID] [uniqueidentifier] NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[ServiceUnitId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_PFVoucherMasterDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [PFBook].[PFVoucherMasters]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PFBook].[PFVoucherMasters](
	[Id] [uniqueidentifier] NOT NULL,
	[VMID] [uniqueidentifier] NOT NULL,
	[VoucherNo] [nvarchar](max) NULL,
	[VoucherDate] [datetime2](7) NOT NULL,
	[VTYPEID] [int] NOT NULL,
	[REMARKS] [nvarchar](max) NULL,
	[PaidTo] [int] NOT NULL,
	[TenantId] [int] NOT NULL,
	[VoucherMode] [nvarchar](max) NULL,
	[RefrenceID] [uniqueidentifier] NOT NULL,
	[IsReversal] [bit] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[ChecqueNo] [nvarchar](max) NULL,
	[NameOfBank] [nvarchar](max) NULL,
	[SrlNo] [nvarchar](max) NULL,
	[IsPFSettledVoucher] [bit] NOT NULL,
	[ChequeDate] [datetime2](7) NOT NULL,
	[ChequeDepositDate] [datetime2](7) NOT NULL,
	[ChequeMonth] [nvarchar](max) NULL,
	[ChequeYear] [int] NOT NULL,
	[FDRNo] [nvarchar](max) NULL,
	[MatureDate] [datetime2](7) NOT NULL,
	[Particulars] [nvarchar](max) NULL,
	[FDRWithdrawDate] [datetime2](7) NOT NULL,
	[ServiceUnitId] [uniqueidentifier] NOT NULL,
	[FYearId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_PFVoucherMasters] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Pharmacy].[AuditedStocks]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Pharmacy].[AuditedStocks](
	[Id] [uniqueidentifier] NOT NULL,
	[StockAuditId] [uniqueidentifier] NOT NULL,
	[BrandExtentionId] [uniqueidentifier] NOT NULL,
	[SoftwareStock] [int] NOT NULL,
	[PhysicalStock] [int] NOT NULL,
	[LotId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[ExpireStock] [int] NOT NULL,
	[IsCountComplete] [bit] NOT NULL,
	[ShortDateStock] [int] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_AuditedStocks] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Pharmacy].[BrandExtensions]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Pharmacy].[BrandExtensions](
	[Id] [uniqueidentifier] NOT NULL,
	[BarCode] [nvarchar](max) NULL,
	[BrandId] [uniqueidentifier] NOT NULL,
	[Unit] [nvarchar](max) NULL,
	[PurchasePrice] [real] NOT NULL,
	[SalePrice] [real] NOT NULL,
	[PkgUnit] [nvarchar](max) NULL,
	[QtyPerBox] [int] NOT NULL,
	[TurnOver] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[FormationId] [uniqueidentifier] NOT NULL,
	[GenericId] [uniqueidentifier] NOT NULL,
	[StrengthId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_BrandExtensions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Pharmacy].[BrandNames]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Pharmacy].[BrandNames](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[SubCategoryId] [uniqueidentifier] NOT NULL,
	[ManufacturerId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_BrandNames] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Pharmacy].[Formations]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Pharmacy].[Formations](
	[Name] [nvarchar](max) NOT NULL,
	[ShortFormation] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_Formations] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Pharmacy].[Generics]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Pharmacy].[Generics](
	[Name] [nvarchar](max) NOT NULL,
	[Info] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[GroupId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Generics] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Pharmacy].[Groups]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Pharmacy].[Groups](
	[Name] [nvarchar](max) NOT NULL,
	[Info] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Groups] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Pharmacy].[InvoiceDetails]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Pharmacy].[InvoiceDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[InvoiceId] [uniqueidentifier] NOT NULL,
	[BrandExtensionId] [uniqueidentifier] NOT NULL,
	[Qty] [int] NOT NULL,
	[SaleRate] [float] NOT NULL,
	[PurchaseRate] [float] NOT NULL,
	[TotalAmount] [float] NOT NULL,
	[LotRecordId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_InvoiceDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Pharmacy].[InvoiceLedgers]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Pharmacy].[InvoiceLedgers](
	[Id] [uniqueidentifier] NOT NULL,
	[InvoiceId] [uniqueidentifier] NOT NULL,
	[TranDate] [datetime2](7) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Debit] [real] NOT NULL,
	[Credit] [real] NOT NULL,
	[Balance] [real] NOT NULL,
	[TransactionType] [int] NOT NULL,
	[PaymentChannelId] [int] NOT NULL,
	[PosTerminalId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
	[DiscountCategoryId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_InvoiceLedgers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Pharmacy].[Invoices]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Pharmacy].[Invoices](
	[Id] [uniqueidentifier] NOT NULL,
	[InvoicePrefix] [nvarchar](max) NULL,
	[InvoiceNo] [bigint] NOT NULL,
	[Invdate] [datetime2](7) NOT NULL,
	[TotalAmount] [float] NOT NULL,
	[Discount] [float] NOT NULL,
	[GrandTotal] [float] NOT NULL,
	[ReceiveAmount] [float] NOT NULL,
	[ChangeAmount] [float] NOT NULL,
	[DueAmount] [float] NOT NULL,
	[ReturnFromInvoiceId] [uniqueidentifier] NOT NULL,
	[StaffRecordId] [uniqueidentifier] NOT NULL,
	[IPDPatientRecordId] [uniqueidentifier] NOT NULL,
	[OPDEmergencyPatientId] [uniqueidentifier] NOT NULL,
	[IPDIndentId] [uniqueidentifier] NOT NULL,
	[OutletIndentId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[ServeTypeId] [int] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Remarks] [nvarchar](max) NULL,
	[IsIPDBillPaid] [bit] NOT NULL,
	[CustomerName] [nvarchar](max) NULL,
	[MobileNo] [nvarchar](max) NULL,
	[MedicineReturnIndentId] [uniqueidentifier] NOT NULL,
	[IsPostedToAccount] [bit] NOT NULL,
	[MedicineOutletId] [uniqueidentifier] NOT NULL,
	[RxId] [bigint] NOT NULL,
 CONSTRAINT [PK_Invoices] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Pharmacy].[InvoiceTypes]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Pharmacy].[InvoiceTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_InvoiceTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Pharmacy].[IPDMedicineIndentDetails]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Pharmacy].[IPDMedicineIndentDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDMedicineIndentId] [uniqueidentifier] NOT NULL,
	[BrandExtensionId] [uniqueidentifier] NOT NULL,
	[Qty] [int] NOT NULL,
	[ServeTypeId] [int] NOT NULL,
	[Remarks] [nvarchar](max) NULL,
	[ServedQty] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_IPDMedicineIndentDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Pharmacy].[IPDMedicineIndents]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Pharmacy].[IPDMedicineIndents](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientId] [uniqueidentifier] NOT NULL,
	[IndentNo] [bigint] NOT NULL,
	[CabinNo] [nvarchar](max) NULL,
	[CabinType] [nvarchar](max) NULL,
	[IndentDateTime] [datetime2](7) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Priority] [int] NOT NULL,
	[ServeTypeId] [int] NOT NULL,
	[OTRoomName] [nvarchar](max) NULL,
	[ServedDateTime] [datetime2](7) NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
	[IndentToOutletId] [uniqueidentifier] NOT NULL,
	[CabinId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_IPDMedicineIndents] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Pharmacy].[LotRecords]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Pharmacy].[LotRecords](
	[Id] [uniqueidentifier] NOT NULL,
	[BatchNo] [nvarchar](max) NULL,
	[ExpireDate] [nvarchar](max) NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_LotRecords] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Pharmacy].[Manufacturers]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Pharmacy].[Manufacturers](
	[Name] [nvarchar](max) NOT NULL,
	[ManufacturerAccId] [int] NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Manufacturers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Pharmacy].[MedicineOutlets]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Pharmacy].[MedicineOutlets](
	[Name] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[CodeNo] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_MedicineOutlets] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Pharmacy].[OutletIndentDetails]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Pharmacy].[OutletIndentDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[OutletIndentId] [uniqueidentifier] NOT NULL,
	[BrandExtensionId] [uniqueidentifier] NOT NULL,
	[Qty] [int] NOT NULL,
	[Status] [int] NOT NULL,
	[Remarks] [nvarchar](max) NULL,
	[ServedQty] [int] NOT NULL,
	[LotId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_OutletIndentDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Pharmacy].[OutletIndents]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Pharmacy].[OutletIndents](
	[Id] [uniqueidentifier] NOT NULL,
	[IndentNo] [bigint] NOT NULL,
	[IndentDateTime] [datetime2](7) NOT NULL,
	[Priority] [int] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Status] [int] NOT NULL,
	[TenantId] [int] NOT NULL,
	[ToOutletId] [uniqueidentifier] NOT NULL,
	[FromOutletId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_OutletIndents] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Pharmacy].[PackaingUnits]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Pharmacy].[PackaingUnits](
	[Name] [nvarchar](max) NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_PackaingUnits] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Pharmacy].[PharmacistDutyOutlets]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Pharmacy].[PharmacistDutyOutlets](
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
	[OutletId] [uniqueidentifier] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_PharmacistDutyOutlets] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Pharmacy].[PharmacyStockInfoesDateWiseHistories]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Pharmacy].[PharmacyStockInfoesDateWiseHistories](
	[FilterDate] [date] NULL,
	[ProductStock] [nvarchar](max) NULL,
	[TenantId] [int] NOT NULL,
	[OutletId] [uniqueidentifier] NOT NULL,
	[AutoId] [uniqueidentifier] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Pharmacy].[PharmacyStockInfoesDateWiseHistories_BK]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Pharmacy].[PharmacyStockInfoesDateWiseHistories_BK](
	[FilterDate] [date] NULL,
	[ProductStock] [nvarchar](max) NULL,
	[TenantId] [int] NOT NULL,
	[OutletId] [uniqueidentifier] NOT NULL,
	[AutoId] [uniqueidentifier] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Pharmacy].[PharmacyStockInfoesDateWiseHistories2025]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Pharmacy].[PharmacyStockInfoesDateWiseHistories2025](
	[FilterDate] [date] NULL,
	[ProductStock] [nvarchar](max) NULL,
	[TenantId] [int] NOT NULL,
	[OutletId] [uniqueidentifier] NOT NULL,
	[AutoId] [uniqueidentifier] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Pharmacy].[PIPDDueCollections]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Pharmacy].[PIPDDueCollections](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientId] [uniqueidentifier] NOT NULL,
	[PayDate] [datetime2](7) NOT NULL,
	[Amount] [real] NOT NULL,
	[PaymentChannelId] [int] NOT NULL,
	[PosTerminalId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TransactionType] [int] NOT NULL,
 CONSTRAINT [PK_PIPDDueCollections] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Pharmacy].[PLoyalMemberLedgers]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Pharmacy].[PLoyalMemberLedgers](
	[Id] [uniqueidentifier] NOT NULL,
	[PLoyalMemberId] [uniqueidentifier] NOT NULL,
	[InvoiceId] [uniqueidentifier] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Debit] [real] NOT NULL,
	[Credit] [real] NOT NULL,
	[Balance] [real] NOT NULL,
	[EntryDate] [datetime2](7) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[PaymentChannelId] [int] NOT NULL,
	[PosTerminalId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NOT NULL,
	[TransactionType] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_PLoyalMemberLedgers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Pharmacy].[PLoyalMembers]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Pharmacy].[PLoyalMembers](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[ContactNo] [nvarchar](max) NULL,
	[ReferranceName] [nvarchar](max) NULL,
	[Remarks] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_PLoyalMembers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Pharmacy].[PurchaseOrderDetails]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Pharmacy].[PurchaseOrderDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[OrderId] [uniqueidentifier] NOT NULL,
	[BrandExtensionId] [uniqueidentifier] NOT NULL,
	[Qty] [int] NOT NULL,
	[Status] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_PurchaseOrderDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Pharmacy].[PurchaseOrders]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Pharmacy].[PurchaseOrders](
	[Id] [uniqueidentifier] NOT NULL,
	[OrderNo] [nvarchar](max) NULL,
	[OrderToSupplierId] [uniqueidentifier] NOT NULL,
	[PurchaseDateTime] [datetime2](7) NOT NULL,
	[EntryDate] [datetime2](7) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Status] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_PurchaseOrders] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Pharmacy].[RceivePurchOrders]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Pharmacy].[RceivePurchOrders](
	[Id] [uniqueidentifier] NOT NULL,
	[StockReceiveId] [uniqueidentifier] NOT NULL,
	[PONo] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_RceivePurchOrders] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Pharmacy].[ROLRecords]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Pharmacy].[ROLRecords](
	[Id] [uniqueidentifier] NOT NULL,
	[BrandExtensionId] [uniqueidentifier] NOT NULL,
	[ROL] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
	[OutletId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_ROLRecords] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Pharmacy].[StockAuditDetails]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Pharmacy].[StockAuditDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[AuditId] [uniqueidentifier] NOT NULL,
	[ProductId] [uniqueidentifier] NOT NULL,
	[PhysicalStock] [int] NOT NULL,
	[Status] [nvarchar](20) NOT NULL,
	[ExpireDate] [date] NOT NULL,
	[CreatedBy] [nvarchar](max) NOT NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
	[SoftwareStock] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Pharmacy].[StockAudits]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Pharmacy].[StockAudits](
	[Id] [uniqueidentifier] NOT NULL,
	[AuditYear] [nvarchar](max) NULL,
	[AuditMonth] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
	[MedicineOutletId] [uniqueidentifier] NOT NULL,
	[Status] [nvarchar](10) NOT NULL,
 CONSTRAINT [PK_StockAudits] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Pharmacy].[StockReceiveDetails]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Pharmacy].[StockReceiveDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[StockReceiveId] [uniqueidentifier] NOT NULL,
	[BrandExtensionId] [uniqueidentifier] NOT NULL,
	[Qty] [int] NOT NULL,
	[PurchaseRate] [float] NOT NULL,
	[SaleRate] [float] NOT NULL,
	[TotalAmount] [float] NOT NULL,
	[DisCountInpercent] [float] NOT NULL,
	[GrossDiscount] [float] NOT NULL,
	[VatInpercent] [float] NOT NULL,
	[VatInGrossAmount] [float] NOT NULL,
	[LotRecordId] [uniqueidentifier] NOT NULL,
	[RceivePurchOrderId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_StockReceiveDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Pharmacy].[StockReceives]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Pharmacy].[StockReceives](
	[Id] [uniqueidentifier] NOT NULL,
	[SupplierId] [uniqueidentifier] NOT NULL,
	[InvoiceNo] [bigint] NOT NULL,
	[OrderId] [uniqueidentifier] NOT NULL,
	[EntryDate] [datetime2](7) NOT NULL,
	[Remarks] [nvarchar](max) NULL,
	[TotalAmount] [float] NOT NULL,
	[Discount] [float] NOT NULL,
	[VatAmount] [float] NOT NULL,
	[GrandTotal] [float] NOT NULL,
	[SupplierInvoiceDate] [datetime2](7) NOT NULL,
	[SupplierInvoiceNo] [nvarchar](max) NULL,
	[SupplierChallanNo] [nvarchar](max) NULL,
	[IPDReturnBillId] [uniqueidentifier] NOT NULL,
	[OPDReturnBillId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NOT NULL,
	[SupplierReturnIndentNo] [bigint] NOT NULL,
	[ReceiveTypeId] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[OutletId] [uniqueidentifier] NOT NULL,
	[OutletIndentId] [uniqueidentifier] NULL,
 CONSTRAINT [PK_StockReceives] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Pharmacy].[StockTransfer]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Pharmacy].[StockTransfer](
	[Id] [uniqueidentifier] NOT NULL,
	[TransferDate] [datetime2](7) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
	[FromOutletId] [uniqueidentifier] NOT NULL,
	[ToOutletId] [uniqueidentifier] NOT NULL,
	[OutletIndentId] [uniqueidentifier] NULL,
 CONSTRAINT [PK_StockTransfer] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Pharmacy].[StockTransferDetails]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Pharmacy].[StockTransferDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[TransferId] [uniqueidentifier] NOT NULL,
	[BrandExtensionId] [uniqueidentifier] NOT NULL,
	[Qty] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_StockTransferDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Pharmacy].[Strengths]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Pharmacy].[Strengths](
	[Value] [nvarchar](max) NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Strengths] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Pharmacy].[SupplierLedgers]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Pharmacy].[SupplierLedgers](
	[Id] [uniqueidentifier] NOT NULL,
	[SupplierId] [uniqueidentifier] NOT NULL,
	[StockReceiveId] [uniqueidentifier] NOT NULL,
	[TransactionDate] [datetime2](7) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Debit] [float] NOT NULL,
	[Credit] [float] NOT NULL,
	[Balance] [float] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_SupplierLedgers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Pharmacy].[SupplierReturnIndentDetails]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Pharmacy].[SupplierReturnIndentDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[SupplierReturnIndentId] [uniqueidentifier] NOT NULL,
	[BrandExtensionId] [uniqueidentifier] NOT NULL,
	[Qty] [int] NOT NULL,
	[LotRecordId] [uniqueidentifier] NOT NULL,
	[Status] [int] NOT NULL,
	[ReturnBrandExtentionId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_SupplierReturnIndentDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Pharmacy].[SupplierReturnIndents]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Pharmacy].[SupplierReturnIndents](
	[Id] [uniqueidentifier] NOT NULL,
	[SupplierId] [uniqueidentifier] NOT NULL,
	[RetDate] [datetime2](7) NULL,
	[RetStatus] [int] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[IndentNo] [bigint] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
	[FromOutletId] [uniqueidentifier] NOT NULL,
	[ReceiveId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_SupplierReturnIndents] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Pharmacy].[Units]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Pharmacy].[Units](
	[Name] [nvarchar](10) NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Units] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Pharmacy].[ViewCurrentStockLog]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Pharmacy].[ViewCurrentStockLog](
	[AutoID] [bigint] IDENTITY(1,1) NOT NULL,
	[BrandExtensionID] [uniqueidentifier] NULL,
	[OutletID] [int] NULL,
	[LotRecerdID] [uniqueidentifier] NULL,
	[CurrentStock] [float] NULL,
	[LogDate] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [ReAgentManagement].[ReAgentManualUses]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ReAgentManagement].[ReAgentManualUses](
	[Id] [uniqueidentifier] NOT NULL,
	[BrandExtensionId] [uniqueidentifier] NOT NULL,
	[TestItemId] [uniqueidentifier] NOT NULL,
	[QC] [int] NOT NULL,
	[Damage] [int] NOT NULL,
	[Recheck] [int] NOT NULL,
	[QCRemarks] [nvarchar](max) NULL,
	[DamageRemarks] [nvarchar](max) NULL,
	[RecheckRemarks] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_ReAgentManualUses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [ReAgentManagement].[TestAndRegAgentMappings]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ReAgentManagement].[TestAndRegAgentMappings](
	[Id] [uniqueidentifier] NOT NULL,
	[BrandExtensionId] [uniqueidentifier] NOT NULL,
	[TestItemId] [uniqueidentifier] NOT NULL,
	[PackSize] [int] NOT NULL,
	[NumberOfTest] [int] NOT NULL,
	[PerTestQty] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_TestAndRegAgentMappings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Rx].[Advices]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Rx].[Advices](
	[CPId] [uniqueidentifier] NOT NULL,
	[AdviceEn] [nvarchar](max) NULL,
	[AdviceBn] [nvarchar](max) NULL,
	[ShortKey] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_Advices] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Rx].[AdviceToPatients]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Rx].[AdviceToPatients](
	[Id] [uniqueidentifier] NOT NULL,
	[RxVisitId] [uniqueidentifier] NOT NULL,
	[Advice] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_AdviceToPatients] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Rx].[ChiefComplains]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Rx].[ChiefComplains](
	[CPId] [uniqueidentifier] NOT NULL,
	[CCEn] [nvarchar](max) NULL,
	[CCBn] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_ChiefComplains] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Rx].[Clinicalimpressions]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Rx].[Clinicalimpressions](
	[Id] [uniqueidentifier] NOT NULL,
	[CPId] [uniqueidentifier] NOT NULL,
	[ImpressionTitle] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_Clinicalimpressions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Rx].[Drugs]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Rx].[Drugs](
	[Id] [uniqueidentifier] NOT NULL,
	[RxVisitId] [uniqueidentifier] NOT NULL,
	[BrandExtensionId] [uniqueidentifier] NOT NULL,
	[Dosage] [nvarchar](max) NULL,
	[Duration] [nvarchar](max) NULL,
	[Qty] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TreatmentType] [nvarchar](max) NULL,
	[ProductName] [nvarchar](max) NULL,
	[TenantId] [int] NULL,
	[DoseId] [uniqueidentifier] NOT NULL,
	[IsDoseBangla] [bit] NOT NULL,
	[ManualDrugName] [nvarchar](100) NOT NULL,
	[PrescriptionId] [uniqueidentifier] NOT NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK_Drugs] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Rx].[Durations]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Rx].[Durations](
	[Unit] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Durations] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Rx].[InitialDatas]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Rx].[InitialDatas](
	[Id] [uniqueidentifier] NOT NULL,
	[RxVisitId] [uniqueidentifier] NOT NULL,
	[RxInitDDate] [datetime2](7) NULL,
	[CC] [nvarchar](max) NULL,
	[CCDuration] [nvarchar](max) NULL,
	[CCDurationUnit] [nvarchar](max) NULL,
	[PresentHistory] [nvarchar](max) NULL,
	[PastHistory] [nvarchar](max) NULL,
	[TreatmentPaln] [nvarchar](max) NULL,
	[WeightInKg] [nvarchar](max) NULL,
	[Height] [nvarchar](max) NULL,
	[HeightUnit] [nvarchar](max) NULL,
	[BMI] [nvarchar](max) NULL,
	[BpErrectTop] [nvarchar](max) NULL,
	[BpErrectBottom] [nvarchar](max) NULL,
	[BpSupineTop] [nvarchar](max) NULL,
	[BpSupineBottom] [nvarchar](max) NULL,
	[Pulse] [nvarchar](max) NULL,
	[PulseBehaviour1] [nvarchar](max) NULL,
	[PulseBehaviour2] [nvarchar](max) NULL,
	[OtherFindings] [nvarchar](max) NULL,
	[DrugHistory] [nvarchar](max) NULL,
	[Diagnosis] [nvarchar](max) NULL,
	[FollowUpOn] [datetime2](7) NULL,
	[FollowUpAfter] [nvarchar](max) NULL,
	[CommentsOrReferral] [nvarchar](max) NULL,
	[Notes] [nvarchar](max) NULL,
	[Dx] [nvarchar](max) NULL,
	[IsThereAnySketch] [bit] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[AssignedDoctorId] [uniqueidentifier] NOT NULL,
	[Comments] [nvarchar](max) NULL,
	[SPO2] [nvarchar](max) NULL,
	[Temperature] [nvarchar](max) NULL,
	[TenantId] [int] NULL,
	[Confidential] [nvarchar](200) NULL,
	[SpacialAlert] [nvarchar](200) NULL,
	[SpecialAlert] [nvarchar](max) NOT NULL,
	[AppointmentId] [uniqueidentifier] NOT NULL,
	[BP] [nvarchar](max) NOT NULL,
	[CoMorbidDeases] [nvarchar](max) NOT NULL,
	[VitalNo] [bigint] NOT NULL,
	[Procedure] [nvarchar](200) NOT NULL,
	[PrescriptionId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_InitialDatas] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Rx].[Investigations]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Rx].[Investigations](
	[Id] [uniqueidentifier] NOT NULL,
	[RxVisitId] [uniqueidentifier] NOT NULL,
	[TestItemId] [uniqueidentifier] NOT NULL,
	[DiscountInPercent] [int] NOT NULL,
	[DiscountGross] [float] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
	[PrescriptionId] [uniqueidentifier] NOT NULL,
	[Remarks] [nvarchar](200) NOT NULL,
 CONSTRAINT [PK_Investigations] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Rx].[OPDProdureSuggessions]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Rx].[OPDProdureSuggessions](
	[Id] [uniqueidentifier] NOT NULL,
	[RxVisitId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[ProcedureId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
	[Qty] [int] NOT NULL,
	[Rate] [float] NOT NULL,
	[ServiceBy] [uniqueidentifier] NULL,
	[IndentStatus] [nvarchar](50) NULL,
	[IndentBy] [nvarchar](50) NULL,
	[IndentNo] [bigint] NOT NULL,
	[Remarks] [nvarchar](200) NOT NULL,
	[PrescriptionId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_OPDProdureSuggessions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Rx].[OtherFindings]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Rx].[OtherFindings](
	[CPId] [uniqueidentifier] NOT NULL,
	[OtherFindingEn] [nvarchar](max) NULL,
	[OtherFindingBn] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_OtherFindings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Rx].[PastHistories]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Rx].[PastHistories](
	[CPId] [uniqueidentifier] NOT NULL,
	[HistoryEn] [nvarchar](max) NULL,
	[HistoryBn] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_PastHistories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Rx].[PatientChiefComplains]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Rx].[PatientChiefComplains](
	[Id] [uniqueidentifier] NOT NULL,
	[RxVisitId] [uniqueidentifier] NOT NULL,
	[Complain] [nvarchar](max) NULL,
	[Duration] [nvarchar](max) NULL,
	[Frequency] [nvarchar](max) NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
	[AppointmentId] [uniqueidentifier] NOT NULL,
	[ComplainManual] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_PatientChiefComplains] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Rx].[PatientClinicalimpressions]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Rx].[PatientClinicalimpressions](
	[Id] [uniqueidentifier] NOT NULL,
	[RxVisitId] [uniqueidentifier] NOT NULL,
	[ImpressionTitle] [nvarchar](max) NULL,
	[Remarks] [nvarchar](max) NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
	[ManualTitle] [nvarchar](max) NULL,
 CONSTRAINT [PK_PatientClinicalimpressions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Rx].[PatientMasterDatas]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Rx].[PatientMasterDatas](
	[Id] [uniqueidentifier] NOT NULL,
	[UHID] [bigint] NOT NULL,
	[EntryDate] [datetime2](7) NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_PatientMasterDatas] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Rx].[PatientRelevantHistoryPart1s]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Rx].[PatientRelevantHistoryPart1s](
	[Id] [uniqueidentifier] NOT NULL,
	[RxVisitId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[WrittenDate] [datetime2](7) NOT NULL,
	[CM_Allergy] [nvarchar](max) NULL,
	[CM_Bronchial_Asthma] [nvarchar](max) NULL,
	[CM_DiabetisMellitus] [nvarchar](max) NULL,
	[CM_Hypertension] [nvarchar](max) NULL,
	[CM_IsChemic_Heart_Disease] [nvarchar](max) NULL,
	[CM_Cronic_Kidney_Disease] [nvarchar](max) NULL,
	[CM_Others] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_PatientRelevantHistoryPart1s] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Rx].[PatientRelevantHistoryPart2s]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Rx].[PatientRelevantHistoryPart2s](
	[Id] [uniqueidentifier] NOT NULL,
	[RxVisitId] [uniqueidentifier] NOT NULL,
	[RelevantHistoryId] [uniqueidentifier] NOT NULL,
	[RelevantHistoryTxt] [nvarchar](max) NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[WrittenDate] [datetime2](7) NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_PatientRelevantHistoryPart2s] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Rx].[PresentHistories]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Rx].[PresentHistories](
	[CPId] [uniqueidentifier] NOT NULL,
	[HistoryEn] [nvarchar](max) NULL,
	[HistoryBn] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_PresentHistories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Rx].[RelevantHistories]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Rx].[RelevantHistories](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_RelevantHistories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Rx].[RxCPDosages]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Rx].[RxCPDosages](
	[Id] [uniqueidentifier] NOT NULL,
	[CPId] [uniqueidentifier] NOT NULL,
	[DoseEnLong] [nvarchar](max) NULL,
	[DoseBnLong] [nvarchar](max) NULL,
	[DoseEnShort] [nvarchar](max) NULL,
	[DoseBnShort] [nvarchar](max) NULL,
	[ShortKey] [nvarchar](max) NULL,
	[EMRInterPretId] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[GenericId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_RxCPDosages] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Rx].[RxDepartments]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Rx].[RxDepartments](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](250) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[FeatureKey] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Rx].[RxDeptWiseFeature]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Rx].[RxDeptWiseFeature](
	[Id] [uniqueidentifier] NOT NULL,
	[VisitId] [uniqueidentifier] NOT NULL,
	[DeptName] [nvarchar](255) NOT NULL,
	[Data] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Rx].[RxDeptWiseFeatures]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Rx].[RxDeptWiseFeatures](
	[Id] [uniqueidentifier] NOT NULL,
	[VisitId] [uniqueidentifier] NOT NULL,
	[Department] [nvarchar](255) NOT NULL,
	[Data] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Rx].[RxGenericDosages]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Rx].[RxGenericDosages](
	[Id] [uniqueidentifier] NOT NULL,
	[DoseEnLong] [nvarchar](max) NULL,
	[DoseBnLong] [nvarchar](max) NULL,
	[DoseEnShort] [nvarchar](max) NULL,
	[DoseBnShort] [nvarchar](max) NULL,
	[ShortKey] [nvarchar](max) NULL,
	[EMRInterPretId] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[GenericId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_RxGenericDosages] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Rx].[RxOpthelmologyInstructions]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Rx].[RxOpthelmologyInstructions](
	[Id] [uniqueidentifier] NOT NULL,
	[DoctorId] [uniqueidentifier] NOT NULL,
	[Instruction] [nvarchar](max) NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Rx].[RxSonologists]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Rx].[RxSonologists](
	[Id] [uniqueidentifier] NOT NULL,
	[VisitId] [uniqueidentifier] NOT NULL,
	[DoctorId] [uniqueidentifier] NOT NULL,
	[Sonologist] [nvarchar](max) NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Rx].[VisitHistories]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Rx].[VisitHistories](
	[Id] [uniqueidentifier] NOT NULL,
	[PatientMasterDataId] [uniqueidentifier] NOT NULL,
	[DoctorId] [uniqueidentifier] NOT NULL,
	[VisitNo] [int] NOT NULL,
	[VisitDate] [datetime2](7) NOT NULL,
	[VisitTime] [nvarchar](max) NULL,
	[AgeYear] [nvarchar](max) NULL,
	[AgeMonth] [nvarchar](max) NULL,
	[AgeDay] [nvarchar](max) NULL,
	[IsServiceCompleted] [bit] NOT NULL,
	[SrlNo] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[RxType] [int] NOT NULL,
	[IPDInvoiceNo] [bigint] NOT NULL,
	[OPDInvoiceNo] [bigint] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
	[AppointmentId] [uniqueidentifier] NOT NULL,
	[Notes] [nvarchar](max) NOT NULL,
	[ReferPlan] [nvarchar](max) NOT NULL,
	[ReleventHistory] [nvarchar](max) NOT NULL,
	[FollowUpDate] [date] NULL,
	[Discount] [float] NOT NULL,
	[SonologistId] [uniqueidentifier] NOT NULL,
	[RxNo] [bigint] NOT NULL,
	[VitalSignRecordId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_VisitHistories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SuperAdmin].[AccountConfigurations]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SuperAdmin].[AccountConfigurations](
	[SectionName] [nvarchar](max) NULL,
	[IsPostingOnSale] [bit] NOT NULL,
	[IsPostingAtEndOfDay] [bit] NOT NULL,
	[IsPostingWeeklyBasis] [bit] NOT NULL,
	[IsPostingMonthlyBasis] [bit] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_AccountConfigurations] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SuperAdmin].[AppSettings]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SuperAdmin].[AppSettings](
	[JSPrintManagerURL] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[DailyFoodBillInOthers] [int] NOT NULL,
	[DailyFoodBillInWard] [int] NOT NULL,
	[VisitingCardRate] [real] NOT NULL,
	[VATRegNo] [nvarchar](max) NULL,
	[IPDServiceCharge] [real] NOT NULL,
	[IsAutoInvestigationInvoiceAfterIndent] [bit] NOT NULL,
	[IsTubeAndNeedleWillbeAutoAdded] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[MenuBackGroudColor] [nvarchar](max) NULL,
	[SampleDispatchDelayInMinute] [int] NOT NULL,
	[IsAppointSerialAuto] [bit] NOT NULL,
	[WillTecnlogistSignatureAddOnReport] [bit] NOT NULL,
	[IsIntegratedAccountsEnabled] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_AppSettings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SuperAdmin].[GLAndHospitalServiceSubGroupMappings]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SuperAdmin].[GLAndHospitalServiceSubGroupMappings](
	[Id] [uniqueidentifier] NOT NULL,
	[GeneralLedgerId] [uniqueidentifier] NOT NULL,
	[SereviceSection] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[ServiceSubGroupId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_GLAndHospitalServiceSubGroupMappings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SuperAdmin].[GLAndPharmacyServiceMappings]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SuperAdmin].[GLAndPharmacyServiceMappings](
	[Id] [uniqueidentifier] NOT NULL,
	[GeneralLedgerId] [uniqueidentifier] NOT NULL,
	[ServiceName] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_GLAndPharmacyServiceMappings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SuperAdmin].[ParameterDashboard]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SuperAdmin].[ParameterDashboard](
	[AutoID] [bigint] NOT NULL,
	[DashboardType] [nvarchar](max) NULL,
	[GroupName] [nvarchar](max) NULL,
	[TitleName] [nvarchar](max) NULL,
	[Amount] [float] NULL,
	[ActiveStatus] [int] NULL,
	[Query] [nvarchar](max) NULL,
	[TenantId] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SuperAdmin].[ReportAndSps]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SuperAdmin].[ReportAndSps](
	[Id] [uniqueidentifier] NOT NULL,
	[ReportName] [nvarchar](max) NULL,
	[SpName] [nvarchar](max) NULL,
	[GroupName] [nvarchar](max) NULL,
	[DeptId] [int] NULL,
	[SubDeptId] [int] NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[DownloadPrefix] [nvarchar](max) NULL,
	[ReportClass] [nvarchar](max) NULL,
	[ResponseClass] [nvarchar](max) NULL,
	[RdlcReportName] [nvarchar](max) NULL,
	[ReportTitle] [nvarchar](max) NULL,
	[IsSynced] [bit] NOT NULL,
	[ReportType] [int] NOT NULL,
	[FolderName] [nvarchar](max) NULL,
	[IsFinancialStatement] [bit] NOT NULL,
 CONSTRAINT [PK_ReportAndSps] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SuperAdmin].[ReportPermissions]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SuperAdmin].[ReportPermissions](
	[ReportAndSpId] [uniqueidentifier] NOT NULL,
	[RoleId] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_ReportPermissions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[BrandExtensions]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[BrandExtensions](
	[Id] [uniqueidentifier] NOT NULL,
	[BrandId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[PurchasePrice] [real] NOT NULL,
	[SalePrice] [real] NOT NULL,
	[ROL] [int] NOT NULL,
	[AlternateName] [nvarchar](max) NULL,
	[AttachedImage] [varbinary](max) NULL,
	[CodeOrPartNo] [nvarchar](max) NULL,
	[IsExpireDateRequired] [bit] NOT NULL,
	[OpeningDate] [datetime2](7) NULL,
	[OpeningQty] [int] NOT NULL,
	[SpecSizeOrColor] [nvarchar](max) NULL,
 CONSTRAINT [PK_BrandExtensions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[BrandNames]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[BrandNames](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Unit] [nvarchar](max) NULL,
	[SubCategoryId] [uniqueidentifier] NOT NULL,
	[SubGroupId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_BrandNames] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[ComparativeStudies]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[ComparativeStudies](
	[Id] [uniqueidentifier] NOT NULL,
	[CSNo] [nvarchar](max) NULL,
	[CSDate] [datetime2](7) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Status] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_ComparativeStudies] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[ComparativeStudyDetails]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[ComparativeStudyDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[ComparativeStudyId] [uniqueidentifier] NOT NULL,
	[SupplierId] [uniqueidentifier] NOT NULL,
	[BrandExtensionId] [uniqueidentifier] NOT NULL,
	[UnitPrice] [float] NOT NULL,
	[Qty] [int] NOT NULL,
	[VatInPercent] [float] NOT NULL,
	[VatInTk] [float] NOT NULL,
	[AITInPercent] [float] NOT NULL,
	[AITInTk] [float] NOT NULL,
	[TotalPrice] [float] NOT NULL,
	[Status] [nvarchar](max) NULL,
	[ManualBrandName] [nvarchar](max) NULL,
	[IsManualBrand] [bit] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_ComparativeStudyDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[CSApprovalSettings]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[CSApprovalSettings](
	[Id] [uniqueidentifier] NOT NULL,
	[ApprovLevel] [nvarchar](max) NULL,
	[DeptId] [int] NOT NULL,
	[LevelApprovebyLoginUserId] [uniqueidentifier] NOT NULL,
	[LevelApprovebyStaffRecordId] [uniqueidentifier] NOT NULL,
	[LevelTagKey] [nvarchar](max) NULL,
	[LevelOrder] [int] NOT NULL,
	[IsThisTheHighestLevelApproval] [bit] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_CSApprovalSettings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[DeptStoreAcesses]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[DeptStoreAcesses](
	[Id] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[DeptId] [uniqueidentifier] NOT NULL,
	[StoreId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DeptStoreAcesses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[GRNFaultDescriptions]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[GRNFaultDescriptions](
	[Id] [uniqueidentifier] NOT NULL,
	[GRNId] [uniqueidentifier] NOT NULL,
	[BrandExtensionId] [uniqueidentifier] NOT NULL,
	[Qty] [int] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_GRNFaultDescriptions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[GRNs]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[GRNs](
	[Id] [uniqueidentifier] NOT NULL,
	[PO] [nvarchar](max) NULL,
	[GRNDate] [datetime2](7) NULL,
	[Note] [nvarchar](max) NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_GRNs] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[Groups]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[Groups](
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Groups] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[IndentApprovals]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[IndentApprovals](
	[Id] [uniqueidentifier] NOT NULL,
	[IndentId] [uniqueidentifier] NOT NULL,
	[ApprovalLevelId] [uniqueidentifier] NOT NULL,
	[ApprovalDate] [datetime2](7) NULL,
	[ApprovalTime] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[NextApprovalLevelId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_IndentApprovals] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[IssueDetails]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[IssueDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[IssueId] [uniqueidentifier] NOT NULL,
	[BrandExtensionId] [uniqueidentifier] NOT NULL,
	[Qty] [int] NOT NULL,
	[LotRecordId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_IssueDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[Issues]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[Issues](
	[Id] [uniqueidentifier] NOT NULL,
	[IssueNo] [bigint] NOT NULL,
	[IssueDate] [datetime2](7) NULL,
	[IndentId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[ServeTypeId] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[StoreId] [uniqueidentifier] NOT NULL,
	[DepartmentId] [uniqueidentifier] NOT NULL,
	[ReceivedBy] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Issues] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[IssueStoreAcesses]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[IssueStoreAcesses](
	[Id] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[StoreId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_IssueStoreAcesses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[LotRecords]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[LotRecords](
	[Id] [uniqueidentifier] NOT NULL,
	[ExpireDate] [nvarchar](max) NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_LotRecords] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[MainStores]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[MainStores](
	[Name] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_MainStores] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[ParentCategories]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[ParentCategories](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_ParentCategories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[PRIndentDetails]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[PRIndentDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[PRIndentId] [uniqueidentifier] NOT NULL,
	[StoreIndentId] [uniqueidentifier] NOT NULL,
	[BrandExtensionId] [uniqueidentifier] NOT NULL,
	[Qty] [int] NOT NULL,
	[ServedQty] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[ApprovedQty] [int] NOT NULL,
 CONSTRAINT [PK_PRIndentDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[PRIndents]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[PRIndents](
	[Id] [uniqueidentifier] NOT NULL,
	[IndentNo] [bigint] NOT NULL,
	[IndentDate] [datetime2](7) NULL,
	[IndentBy] [uniqueidentifier] NOT NULL,
	[ServeTypeId] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[StoreId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_PRIndents] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[PRSubmittedDetails]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[PRSubmittedDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[PRSubmittedId] [uniqueidentifier] NOT NULL,
	[PRIndentNo] [bigint] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_PRSubmittedDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[PRSubmitteds]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[PRSubmitteds](
	[Id] [uniqueidentifier] NOT NULL,
	[SubmittedDate] [datetime2](7) NULL,
	[SubmittedBy] [uniqueidentifier] NOT NULL,
	[ServeTypeId] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[MainStoreId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_PRSubmitteds] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[PurchaseOrderDetails]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[PurchaseOrderDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[OrderId] [uniqueidentifier] NOT NULL,
	[BrandExtensionId] [uniqueidentifier] NOT NULL,
	[Qty] [int] NOT NULL,
	[Status] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_PurchaseOrderDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[PurchaseOrders]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[PurchaseOrders](
	[Id] [uniqueidentifier] NOT NULL,
	[OrderNo] [nvarchar](max) NULL,
	[OrderToSupplierId] [uniqueidentifier] NOT NULL,
	[PurchaseDateTime] [datetime2](7) NULL,
	[EntryDate] [datetime2](7) NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Status] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[PRSubmittedId] [uniqueidentifier] NOT NULL,
	[RequisitionId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_PurchaseOrders] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[PurchaseRequisiontionDetails]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[PurchaseRequisiontionDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[PurchaseRequisiontionId] [uniqueidentifier] NOT NULL,
	[BrandExtensionId] [uniqueidentifier] NOT NULL,
	[RequisitionQty] [int] NOT NULL,
	[ApprovedQty] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_PurchaseRequisiontionDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[PurchaseRequisiontions]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[PurchaseRequisiontions](
	[Id] [uniqueidentifier] NOT NULL,
	[RequisitionNo] [bigint] NOT NULL,
	[RequisitionDate] [datetime2](7) NULL,
	[RequisitionTime] [nvarchar](max) NULL,
	[Note] [nvarchar](max) NULL,
	[TermsOfCondition] [nvarchar](max) NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[SupplierId] [uniqueidentifier] NOT NULL,
	[IsCashPurchase] [bit] NOT NULL,
	[IsCreditPurchase] [bit] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[StoreDeptId] [uniqueidentifier] NOT NULL,
	[StoreId] [uniqueidentifier] NOT NULL,
	[MainStoreId] [uniqueidentifier] NOT NULL,
	[PRSubmittedId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_PurchaseRequisiontions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[ReAgentTestMappings]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[ReAgentTestMappings](
	[Id] [uniqueidentifier] NOT NULL,
	[BrandExtensionId] [uniqueidentifier] NOT NULL,
	[TestItemId] [uniqueidentifier] NOT NULL,
	[PackSize] [float] NOT NULL,
	[Unit] [nvarchar](max) NULL,
	[NumberOfTest] [int] NOT NULL,
	[UseQtyPerTest] [float] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_ReAgentTestMappings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[RequisitionApprovals]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[RequisitionApprovals](
	[Id] [uniqueidentifier] NOT NULL,
	[RequisitionId] [uniqueidentifier] NOT NULL,
	[ApprovalLevelId] [uniqueidentifier] NOT NULL,
	[ApprovalDate] [datetime2](7) NULL,
	[ApprovalTime] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[NextApprovalLevelId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_RequisitionApprovals] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[SCMPurchaseApprovalSettings]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[SCMPurchaseApprovalSettings](
	[Id] [uniqueidentifier] NOT NULL,
	[RoleId] [nvarchar](max) NULL,
	[ApprovalLevel] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[StoreId] [uniqueidentifier] NOT NULL,
	[MainStoreId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_SCMPurchaseApprovalSettings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[SStockTransfer]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[SStockTransfer](
	[Id] [uniqueidentifier] NOT NULL,
	[TransferDate] [datetime2](7) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
	[MainStoreId] [uniqueidentifier] NOT NULL,
	[SubStoreId] [uniqueidentifier] NOT NULL,
	[IndentId] [uniqueidentifier] NULL,
	[ServeTypeId] [int] NOT NULL,
 CONSTRAINT [PK_SStockTransfer] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[SStockTransferDetails]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[SStockTransferDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[TransferId] [uniqueidentifier] NOT NULL,
	[BrandExtensionId] [uniqueidentifier] NOT NULL,
	[Qty] [int] NOT NULL,
	[LotRecordId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[TenantId] [int] NOT NULL,
 CONSTRAINT [PK_SStockTransferDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[StockReceiveDetails]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[StockReceiveDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[StockReceiveId] [uniqueidentifier] NOT NULL,
	[BrandExtensionId] [uniqueidentifier] NOT NULL,
	[Qty] [int] NOT NULL,
	[PurchaseRate] [float] NOT NULL,
	[SaleRate] [float] NOT NULL,
	[TotalAmount] [float] NOT NULL,
	[DisCountInpercent] [float] NOT NULL,
	[GrossDiscount] [float] NOT NULL,
	[VatInpercent] [float] NOT NULL,
	[VatInGrossAmount] [float] NOT NULL,
	[LotRecordId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_StockReceiveDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[StockReceives]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[StockReceives](
	[Id] [uniqueidentifier] NOT NULL,
	[SupplierId] [uniqueidentifier] NOT NULL,
	[InvoiceNo] [bigint] NOT NULL,
	[EntryDate] [datetime2](7) NOT NULL,
	[Remarks] [nvarchar](max) NULL,
	[TotalAmount] [float] NOT NULL,
	[Discount] [float] NOT NULL,
	[VatAmount] [float] NOT NULL,
	[GrandTotal] [float] NOT NULL,
	[SupplierInvoiceDate] [datetime2](7) NOT NULL,
	[SupplierInvoiceNo] [nvarchar](max) NULL,
	[SupplierChallanNo] [nvarchar](max) NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[TenantId] [int] NOT NULL,
	[ReceiveTypeId] [int] NOT NULL,
	[PONo] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[StoreId] [uniqueidentifier] NOT NULL,
	[MainStoreId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_StockReceives] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[StoreDepts]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[StoreDepts](
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[backupId] [int] NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_StoreDepts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[StoreDeptUserAccesses]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[StoreDeptUserAccesses](
	[Id] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[StoreDeptIds] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_StoreDeptUserAccesses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[StoreIndentApprovalSettings]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[StoreIndentApprovalSettings](
	[Id] [uniqueidentifier] NOT NULL,
	[RoleId] [nvarchar](max) NULL,
	[ApprovalLevel] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[StoreId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_StoreIndentApprovalSettings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[StoreIndentDetails]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[StoreIndentDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[StoreIndentId] [uniqueidentifier] NOT NULL,
	[BrandExtensionId] [uniqueidentifier] NOT NULL,
	[Qty] [int] NOT NULL,
	[ServedQty] [int] NOT NULL,
	[ServeTypeId] [int] NOT NULL,
	[Remarks] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[ApprovedQty] [int] NOT NULL,
 CONSTRAINT [PK_StoreIndentDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[StoreIndents]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[StoreIndents](
	[Id] [uniqueidentifier] NOT NULL,
	[IndentNo] [bigint] NOT NULL,
	[Priority] [int] NOT NULL,
	[IndentDate] [datetime2](7) NULL,
	[IndentBy] [uniqueidentifier] NOT NULL,
	[ServeTypeId] [int] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[StoreId] [uniqueidentifier] NOT NULL,
	[IndentStatus] [nvarchar](50) NULL,
 CONSTRAINT [PK_StoreIndents] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[Stores]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[Stores](
	[Name] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[MainStoreId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Stores] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[SubCategories]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[SubCategories](
	[Id] [uniqueidentifier] NOT NULL,
	[ParentCategoryId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_SubCategories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[SubGroups]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[SubGroups](
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[GroupId] [uniqueidentifier] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_SubGroups] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[Suppliers]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[Suppliers](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Address] [nvarchar](max) NULL,
	[ContactNo] [nvarchar](max) NULL,
	[IsManufacturer] [bit] NOT NULL,
	[GLId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[EnlistmentDate] [datetime2](7) NOT NULL,
	[ExpireDate] [datetime2](7) NOT NULL,
	[IsEnlisted] [bit] NOT NULL,
	[VatInPercent] [real] NOT NULL,
	[ManufacturerId] [uniqueidentifier] NOT NULL,
	[TypeId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Suppliers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[SupplierTypes]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[SupplierTypes](
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_SupplierTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SupplyChain ].[XrayFilmTestMappings]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SupplyChain ].[XrayFilmTestMappings](
	[Id] [uniqueidentifier] NOT NULL,
	[BrandExtensionId] [uniqueidentifier] NOT NULL,
	[TestItemId] [uniqueidentifier] NOT NULL,
	[Unit] [nvarchar](max) NULL,
	[UseQtyPerTest] [float] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_XrayFilmTestMappings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [TransfusionMedicine].[BCParameters]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [TransfusionMedicine].[BCParameters](
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Values] [nvarchar](max) NULL,
	[Id] [uniqueidentifier] NOT NULL,
	[BloodComponentId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_BCParameters] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [TransfusionMedicine].[BloodComponents]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [TransfusionMedicine].[BloodComponents](
	[Name] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Rate] [int] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_BloodComponents] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [TransfusionMedicine].[BloodDonors]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [TransfusionMedicine].[BloodDonors](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientRecordId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[FatherName] [nvarchar](max) NULL,
	[Age] [nvarchar](max) NULL,
	[Sex] [nvarchar](max) NULL,
	[MarriedStatus] [bit] NOT NULL,
	[Occupation] [nvarchar](max) NULL,
	[Email] [nvarchar](max) NULL,
	[PresentAddress] [nvarchar](max) NULL,
	[BeforeBloodDonets] [bit] NOT NULL,
	[DonorIDNo] [nvarchar](max) NULL,
	[CabinNo] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_BloodDonors] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [TransfusionMedicine].[CrossMatchingRecords]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [TransfusionMedicine].[CrossMatchingRecords](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientRecordId] [uniqueidentifier] NOT NULL,
	[CMDateTime] [datetime2](7) NULL,
	[BloodGroup] [nvarchar](max) NULL,
	[Rhfactor] [nvarchar](max) NULL,
	[Speciman] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[DoctorId] [uniqueidentifier] NOT NULL,
	[TechnologistId] [uniqueidentifier] NOT NULL,
	[BloodComponentId] [uniqueidentifier] NOT NULL,
	[CrossMatchingResultId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_CrossMatchingRecords] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [TransfusionMedicine].[CrossMatchingResults]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [TransfusionMedicine].[CrossMatchingResults](
	[Result] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[Id] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_CrossMatchingResults] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [TransfusionMedicine].[CrossMatchingValues]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [TransfusionMedicine].[CrossMatchingValues](
	[Id] [uniqueidentifier] NOT NULL,
	[CrossMatchingRecordId] [uniqueidentifier] NOT NULL,
	[Result] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[BCParameterId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_CrossMatchingValues] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [TransfusionMedicine].[DonorContributionRecords]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [TransfusionMedicine].[DonorContributionRecords](
	[Id] [uniqueidentifier] NOT NULL,
	[CrossMatchingRecordId] [uniqueidentifier] NOT NULL,
	[BloodGroup] [nvarchar](max) NULL,
	[Rhfactor] [nvarchar](max) NULL,
	[BagId] [nvarchar](max) NULL,
	[ExpireDate] [datetime2](7) NULL,
	[BloodDonorId] [uniqueidentifier] NOT NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
 CONSTRAINT [PK_DonorContributionRecords] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [TransfusionMedicine].[SerologyRecords]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [TransfusionMedicine].[SerologyRecords](
	[Id] [uniqueidentifier] NOT NULL,
	[IPDPatientRecordId] [uniqueidentifier] NOT NULL,
	[SDate] [datetime2](7) NULL,
	[Speciman] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[BloodComponentId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_SerologyRecords] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [TransfusionMedicine].[SerologyResults]    Script Date: 09/27/25 11:19:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [TransfusionMedicine].[SerologyResults](
	[Id] [uniqueidentifier] NOT NULL,
	[SerologyRecordId] [uniqueidentifier] NOT NULL,
	[Result] [nvarchar](max) NULL,
	[CreatedBy] [nvarchar](max) NULL,
	[CreatedOn] [datetime2](7) NOT NULL,
	[LastModifiedBy] [nvarchar](max) NULL,
	[LastModifiedOn] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsSynced] [bit] NOT NULL,
	[BCParameterId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_SerologyResults] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Account].[AccountGroups] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Account].[AccountGroups] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Account].[AttachedFileWithVouchers] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Account].[Banks] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Account].[Categories] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Account].[COADescription] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Account].[COADescription] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Account].[Configuration] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Account].[Configuration] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Account].[ConsultantGlobalLedgers] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Account].[ConsultantGlobalLedgers] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ServiceUnitId]
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
ALTER TABLE [Account].[FiscalYears] ADD  CONSTRAINT [DF_FiscalYears_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [Account].[FiscalYears] ADD  CONSTRAINT [DF_FiscalYears_IsDeleted]  DEFAULT ('False') FOR [IsDeleted]
GO
ALTER TABLE [Account].[FiscalYears] ADD  CONSTRAINT [DF_FiscalYears_IsSynced]  DEFAULT ('False') FOR [IsSynced]
GO
ALTER TABLE [Account].[FiscalYears] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Account].[FSLI] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Account].[FSLI] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Account].[GeneralLedgers] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsActive]
GO
ALTER TABLE [Account].[GeneralLedgers] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsControlAccount]
GO
ALTER TABLE [Account].[GeneralLedgers] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsCostCenter]
GO
ALTER TABLE [Account].[GeneralLedgers] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsRecurringCost]
GO
ALTER TABLE [Account].[GeneralLedgers] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsBillingContainDetails]
GO
ALTER TABLE [Account].[GeneralLedgers] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ReportAndSpId]
GO
ALTER TABLE [Account].[GeneralLedgers] ADD  CONSTRAINT [DF_GeneralLedgers_COADescriptionId]  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [COADescriptionId]
GO
ALTER TABLE [Account].[GLItemDescription] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Account].[GLItemDescription] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [FSLIId]
GO
ALTER TABLE [Account].[GLItemDescription] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Account].[HISandDiagMediaPaymentRecordDetails] ADD  DEFAULT ((0.0000000000000000e+000)) FOR [Commission]
GO
ALTER TABLE [Account].[HISandDiagMediaPaymentRecordDetails] ADD  DEFAULT ((0.0000000000000000e+000)) FOR [TotalCost]
GO
ALTER TABLE [Account].[HISandDiagMediaPaymentRecordDetails] ADD  DEFAULT (CONVERT([bigint],(0))) FOR [BillNo]
GO
ALTER TABLE [Account].[HISandDiagMediaPaymentRecords] ADD  DEFAULT (CONVERT([bigint],(0))) FOR [InvoiceNo]
GO
ALTER TABLE [Account].[HISandDiagMediaPaymentRecords] ADD  DEFAULT ('0001-01-01T00:00:00.0000000') FOR [PaymentDate]
GO
ALTER TABLE [Account].[HISandDiagMediaPaymentRecords] ADD  DEFAULT ((0.0000000000000000e+000)) FOR [Addition]
GO
ALTER TABLE [Account].[HISandDiagMediaPaymentRecords] ADD  DEFAULT ((0.0000000000000000e+000)) FOR [Deduction]
GO
ALTER TABLE [Account].[HISandDiagMediaPaymentRecords] ADD  DEFAULT ((0.0000000000000000e+000)) FOR [Discount]
GO
ALTER TABLE [Account].[IPDPatientGlobalLedgers] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ServiceUnitId]
GO
ALTER TABLE [Account].[LoyalMemberLedgers] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Account].[LoyalMemberLedgers] ADD  DEFAULT (CONVERT([bigint],(0))) FOR [InvoiceNo]
GO
ALTER TABLE [Account].[LoyalMemberLedgers] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [UserId]
GO
ALTER TABLE [Account].[LoyalMembers] ADD  CONSTRAINT [DF_LoyalMembers_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [Account].[LoyalMembers] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Account].[LoyalMembers] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Account].[MainSubAccountsRelations] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Account].[MainSubAccountsRelations] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Account].[MasterStatements] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Account].[MasterStatements] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Account].[NatureOfAccounts] ADD  CONSTRAINT [DF__NatureOfA__IsSyn__6EC13C93]  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Account].[NatureOfAccounts] ADD  CONSTRAINT [DF_NatureOfAccounts_MasterStatementId]  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [MasterStatementId]
GO
ALTER TABLE [Account].[POSTerminals] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Account].[RadiologicalReportingFeePaymentRecordDetails] ADD  DEFAULT ((0.0000000000000000e+000)) FOR [ReportingFee]
GO
ALTER TABLE [Account].[RadiologicalReportingFeePaymentRecordDetails] ADD  DEFAULT (CONVERT([bigint],(0))) FOR [BillNo]
GO
ALTER TABLE [Account].[RadiologicalReportingFeePaymentRecords] ADD  DEFAULT ((0.0000000000000000e+000)) FOR [Addition]
GO
ALTER TABLE [Account].[RadiologicalReportingFeePaymentRecords] ADD  DEFAULT ((0.0000000000000000e+000)) FOR [Deduction]
GO
ALTER TABLE [Account].[StatementBroadHeads] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Account].[StatementSubHeads] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [StatementBroadHeadId]
GO
ALTER TABLE [Account].[SubCategories] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Account].[SubLedgers] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [InvoiceId]
GO
ALTER TABLE [Account].[SubLedgers] ADD  DEFAULT (CONVERT([bigint],(0))) FOR [InvoiceNo]
GO
ALTER TABLE [Account].[SubLedgers] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [SupplierId]
GO
ALTER TABLE [Account].[SubLedgers] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Account].[SupplierGlobalLedgers] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ServiceUnitId]
GO
ALTER TABLE [Account].[VoucherMasterDetails] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ServiceUnitId]
GO
ALTER TABLE [Account].[VoucherMasterDetails] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Account].[VoucherMasters] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [UserId]
GO
ALTER TABLE [Account].[VoucherMasters] ADD  DEFAULT ('0001-01-01T00:00:00.0000000') FOR [VoucherDate]
GO
ALTER TABLE [Account].[VoucherMasters] ADD  DEFAULT ((0)) FOR [ReferenceTypeId]
GO
ALTER TABLE [Account].[VoucherMasters] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ServiceUnitId]
GO
ALTER TABLE [Account].[VoucherMasters] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [FYearId]
GO
ALTER TABLE [Admin].[Countries] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Admin].[Departments] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Admin].[Departments] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Admin].[DiscountCategories] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Admin].[DiscountCategories] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Admin].[DiscountCategories] ADD  DEFAULT ('a5e03945-cbd3-4337-84f5-dae62e6e305c') FOR [DepartmentId]
GO
ALTER TABLE [Admin].[DiscountCategories] ADD  DEFAULT ((0)) FOR [DiscountInParcent]
GO
ALTER TABLE [Admin].[EditorMargins] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Admin].[EditorShorkeys] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Admin].[IndentStores] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [Admin].[InvoiceStores] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [Admin].[IPDAdmissionpageControls] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Admin].[PaymentChannels] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Admin].[PaymentModes] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Admin].[ProjectMenus] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Admin].[ProjectMenus] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Admin].[ProjectMenus] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ParentId]
GO
ALTER TABLE [Admin].[ServiceUnits] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Admin].[ServiceUnits] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Admin].[ServiceUnits] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [DepartmentId]
GO
ALTER TABLE [Admin].[ServiceUnits] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Admin].[Tenants] ADD  DEFAULT ((0)) FOR [BranchId]
GO
ALTER TABLE [Admin].[Tenants] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Admin].[UHIDUsesRecords] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Admin].[UHIDUsesRecords] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Admin].[UHIDUsesRecords] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ServiceUnitId]
GO
ALTER TABLE [Anonymous].[AnonymousUsers] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Anonymous].[AnonymousUserVerifications] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Canteen].[CanteenOutlets] ADD  CONSTRAINT [DF_CanteenOutlets_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [Canteen].[CanteenOutlets] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Canteen].[CanteenOutlets] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Canteen].[CanteenOutlets] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Canteen].[CanteenStockTransferDetails] ADD  CONSTRAINT [DF_CanteenStockTransferDetails_CanteenStockTransferId]  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [CanteenStockTransferId]
GO
ALTER TABLE [Canteen].[CanteenStockTransferDetails] ADD  CONSTRAINT [DF_CanteenStockTransferDetails_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [Canteen].[CanteenStockTransferDetails] ADD  CONSTRAINT [DF_CanteenStockTransferDetails_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [Canteen].[CanteenStockTransferDetails] ADD  CONSTRAINT [DF_CanteenStockTransferDetails_IsSynced]  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Canteen].[CanteenStockTransferDetails] ADD  DEFAULT ((0)) FOR [TransferQty]
GO
ALTER TABLE [Canteen].[CanteenStockTransferDetails] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ItemId]
GO
ALTER TABLE [Canteen].[CanteenStockTransferDetails] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Canteen].[CanteenStockTransfers] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Canteen].[CanteenStockTransfers] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ToOutletId]
GO
ALTER TABLE [Canteen].[CanteenStockTransfers] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [FromOutletId]
GO
ALTER TABLE [Canteen].[Groups] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Canteen].[Groups] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Canteen].[Groups] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [Canteen].[IPDFoodIndents] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsRead]
GO
ALTER TABLE [Canteen].[IPDFoodIndents] ADD  DEFAULT ('0001-01-01T00:00:00.0000000') FOR [StoppedDate]
GO
ALTER TABLE [Canteen].[IPDFoodIndents] ADD  DEFAULT ('0001-01-01T00:00:00.0000000') FOR [LastViewDate]
GO
ALTER TABLE [Canteen].[IPDFoodIndents] ADD  DEFAULT ((0)) FOR [LastViewedMealOrder]
GO
ALTER TABLE [Canteen].[IPDFoodIndents] ADD  DEFAULT ('0001-01-01T00:00:00.0000000') FOR [LastChangedDate]
GO
ALTER TABLE [Canteen].[IPDFoodIndents] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsDietChanged]
GO
ALTER TABLE [Canteen].[IPDFoodIndents] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Canteen].[IPDFoodIndents] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [CanteenOutLetId]
GO
ALTER TABLE [Canteen].[Items] ADD  CONSTRAINT [DF_Items_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [Canteen].[Items] ADD  DEFAULT ((0.0)) FOR [VatInPercent]
GO
ALTER TABLE [Canteen].[Items] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Canteen].[Items] ADD  DEFAULT (CONVERT([real],(0))) FOR [ProductionRate]
GO
ALTER TABLE [Canteen].[Items] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Canteen].[Items] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [GroupId]
GO
ALTER TABLE [Canteen].[Items] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [Canteen].[RawItemIssueDetails] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Canteen].[RawItemIssues] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Canteen].[RawItems] ADD  DEFAULT (CONVERT([real],(0))) FOR [PRate]
GO
ALTER TABLE [Canteen].[RawItems] ADD  DEFAULT (CONVERT([real],(0))) FOR [SRate]
GO
ALTER TABLE [Canteen].[RawItems] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [GroupId]
GO
ALTER TABLE [Canteen].[RawItemStockReceiveDetails] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Canteen].[RawItemStockReceives] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Canteen].[SaleInvoiceDetails] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Canteen].[SaleInvoiceDetails] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ProductId ]
GO
ALTER TABLE [Canteen].[SaleInvoices] ADD  DEFAULT ((0.0000000000000000e+000)) FOR [VatInTk]
GO
ALTER TABLE [Canteen].[SaleInvoices] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [IPDPatientRecordId]
GO
ALTER TABLE [Canteen].[SaleInvoices] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Canteen].[SaleInvoices] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [UserId]
GO
ALTER TABLE [Canteen].[SaleInvoices] ADD  DEFAULT (CONVERT([bigint],(0))) FOR [IndentNo]
GO
ALTER TABLE [Canteen].[SaleInvoices] ADD  DEFAULT ((0)) FOR [DailySerial]
GO
ALTER TABLE [Canteen].[SaleInvoices] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [CanteenOutLetId]
GO
ALTER TABLE [Canteen].[SaleInvoices] ADD  CONSTRAINT [DF_SaleInvoices_IsDietChanged]  DEFAULT ((0)) FOR [IsDietChanged]
GO
ALTER TABLE [Canteen].[SaleInvoices] ADD  CONSTRAINT [DF_SaleInvoices_CabinId]  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [CabinId]
GO
ALTER TABLE [Canteen].[SaleInvoices] ADD  DEFAULT ((0)) FOR [AfterDischargeCleared]
GO
ALTER TABLE [Canteen].[SaleInvoices] ADD  DEFAULT ('') FOR [PriorityTxt]
GO
ALTER TABLE [Canteen].[SaleInvoices] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [FoodDeliverableId]
GO
ALTER TABLE [Canteen].[SaleLedgers] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Canteen].[SaleLedgers] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Canteen].[SalesmanDutyOutlets] ADD  CONSTRAINT [DF_SalesmanDutyOutlets_UserId]  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [UserId]
GO
ALTER TABLE [Canteen].[SalesmanDutyOutlets] ADD  CONSTRAINT [DF_SalesmanDutyOutlets_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [Canteen].[SalesmanDutyOutlets] ADD  CONSTRAINT [DF_SalesmanDutyOutlets_IsSynced]  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Canteen].[SalesmanDutyOutlets] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [CanteenOutLetId]
GO
ALTER TABLE [Canteen].[SalesmanDutyOutlets] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Canteen].[SalesmanDutyOutlets] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Canteen].[StockReceiveRecordDetails] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Canteen].[StockReceiveRecordDetails] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ItemId ]
GO
ALTER TABLE [Canteen].[StockReceiveRecords] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [CanteenOutLetId]
GO
ALTER TABLE [Canteen].[StockReceiveRecords] ADD  CONSTRAINT [DF_StockReceiveRecords_NUserId]  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [UserId]
GO
ALTER TABLE [dbo].[AuditTrails] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [dbo].[Clients] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [dbo].[Clients] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [dbo].[SyncRecords] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[SyncRecords] ADD  DEFAULT ((0)) FOR [Version]
GO
ALTER TABLE [dbo].[TempSPGetReferralCommissionStatement] ADD  DEFAULT ((0)) FOR [AUDIOMETRY]
GO
ALTER TABLE [dbo].[TempSPGetReferralCommissionStatement] ADD  DEFAULT ((0)) FOR [BMD]
GO
ALTER TABLE [dbo].[TempSPGetReferralCommissionStatement] ADD  DEFAULT ((0)) FOR [CBCT]
GO
ALTER TABLE [dbo].[TempSPGetReferralCommissionStatement] ADD  DEFAULT ((0)) FOR [COLONOSCOPY]
GO
ALTER TABLE [dbo].[TempSPGetReferralCommissionStatement] ADD  DEFAULT ((0)) FOR [CT SCAN]
GO
ALTER TABLE [dbo].[TempSPGetReferralCommissionStatement] ADD  DEFAULT ((0)) FOR [ECG]
GO
ALTER TABLE [dbo].[TempSPGetReferralCommissionStatement] ADD  DEFAULT ((0)) FOR [ECHO]
GO
ALTER TABLE [dbo].[TempSPGetReferralCommissionStatement] ADD  DEFAULT ((0)) FOR [ECHO COLOR DOPPLER]
GO
ALTER TABLE [dbo].[TempSPGetReferralCommissionStatement] ADD  DEFAULT ((0)) FOR [EEG]
GO
ALTER TABLE [dbo].[TempSPGetReferralCommissionStatement] ADD  DEFAULT ((0)) FOR [EMG]
GO
ALTER TABLE [dbo].[TempSPGetReferralCommissionStatement] ADD  DEFAULT ((0)) FOR [ENDOSCOPY]
GO
ALTER TABLE [dbo].[TempSPGetReferralCommissionStatement] ADD  DEFAULT ((0)) FOR [ENT]
GO
ALTER TABLE [dbo].[TempSPGetReferralCommissionStatement] ADD  DEFAULT ((0)) FOR [ETT]
GO
ALTER TABLE [dbo].[TempSPGetReferralCommissionStatement] ADD  DEFAULT ((0)) FOR [FIBROSCAN]
GO
ALTER TABLE [dbo].[TempSPGetReferralCommissionStatement] ADD  DEFAULT ((0)) FOR [HISTOPATHOLOGY]
GO
ALTER TABLE [dbo].[TempSPGetReferralCommissionStatement] ADD  DEFAULT ((0)) FOR [HOLTER ECG]
GO
ALTER TABLE [dbo].[TempSPGetReferralCommissionStatement] ADD  DEFAULT ((0)) FOR [IMMUNOHISTOCHEMISTRY]
GO
ALTER TABLE [dbo].[TempSPGetReferralCommissionStatement] ADD  DEFAULT ((0)) FOR [IMMUNOLOGY]
GO
ALTER TABLE [dbo].[TempSPGetReferralCommissionStatement] ADD  DEFAULT ((0)) FOR [MAMOGRAPHY]
GO
ALTER TABLE [dbo].[TempSPGetReferralCommissionStatement] ADD  DEFAULT ((0)) FOR [MICROBIOLOGY]
GO
ALTER TABLE [dbo].[TempSPGetReferralCommissionStatement] ADD  DEFAULT ((0)) FOR [MOLECULAR DIAGNOSTIC]
GO
ALTER TABLE [dbo].[TempSPGetReferralCommissionStatement] ADD  DEFAULT ((0)) FOR [MRI]
GO
ALTER TABLE [dbo].[TempSPGetReferralCommissionStatement] ADD  DEFAULT ((0)) FOR [NCV]
GO
ALTER TABLE [dbo].[TempSPGetReferralCommissionStatement] ADD  DEFAULT ((0)) FOR [NEUROLOGY]
GO
ALTER TABLE [dbo].[TempSPGetReferralCommissionStatement] ADD  DEFAULT ((0)) FOR [OPG]
GO
ALTER TABLE [dbo].[TempSPGetReferralCommissionStatement] ADD  DEFAULT ((0)) FOR [Pathology]
GO
ALTER TABLE [dbo].[TempSPGetReferralCommissionStatement] ADD  DEFAULT ((0)) FOR [SEROLOGY]
GO
ALTER TABLE [dbo].[TempSPGetReferralCommissionStatement] ADD  DEFAULT ((0)) FOR [ULTRASOUND]
GO
ALTER TABLE [dbo].[TempSPGetReferralCommissionStatement] ADD  DEFAULT ((0)) FOR [UROFLOMETRY]
GO
ALTER TABLE [dbo].[TempSPGetReferralCommissionStatement] ADD  DEFAULT ((0)) FOR [VASCULAR IMAGING]
GO
ALTER TABLE [dbo].[TempSPGetReferralCommissionStatement] ADD  DEFAULT ((0)) FOR [X-RAY]
GO
ALTER TABLE [Diag].[AgeVariantNormalValues] ADD  DEFAULT ((0.0000000000000000e+000)) FOR [Max]
GO
ALTER TABLE [Diag].[AgeVariantNormalValues] ADD  DEFAULT ((0.0000000000000000e+000)) FOR [Min]
GO
ALTER TABLE [Diag].[AgeVariantNormalValues] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Diag].[AgeVariantNormalValues] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ReportParameterId]
GO
ALTER TABLE [Diag].[AgeVariantNormalValues] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Diag].[AgeVariantNormalValues] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ReportingAgeGroupId]
GO
ALTER TABLE [Diag].[ConsultantPaymentRecords] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Diag].[CSGrowths] ADD  DEFAULT ((2)) FOR [TenantId]
GO
ALTER TABLE [Diag].[CSNoGrowthResults] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Diag].[CSOthersValues] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Diag].[InvestigationInvoiceDetails] ADD  CONSTRAINT [DF_InvestigationInvoiceDetails_AccessionNumber]  DEFAULT ((0)) FOR [AccessionNumber]
GO
ALTER TABLE [Diag].[InvestigationInvoiceDetails] ADD  CONSTRAINT [DF_InvestigationInvoiceDetails_ProbableReportDeliveryDateTime]  DEFAULT (getdate()) FOR [ProbableReportDeliveryDateTime]
GO
ALTER TABLE [Diag].[InvestigationInvoiceDetails] ADD  CONSTRAINT [DF_InvestigationInvoiceDetails_ReportDeliveryBy]  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ReportDeliveryBy]
GO
ALTER TABLE [Diag].[InvestigationInvoiceDetails] ADD  CONSTRAINT [DF_InvestigationInvoiceDetails_ProcedureStep]  DEFAULT ((1)) FOR [ProcedureStep]
GO
ALTER TABLE [Diag].[InvestigationInvoiceDetails] ADD  CONSTRAINT [DF_InvestigationInvoiceDetails_IsDeleted]  DEFAULT ('False') FOR [IsDeleted]
GO
ALTER TABLE [Diag].[InvestigationInvoiceDetails] ADD  CONSTRAINT [DF__Investiga__IsCan__3434A84B]  DEFAULT (CONVERT([bit],(0))) FOR [IsCancelApproved]
GO
ALTER TABLE [Diag].[InvestigationInvoiceDetails] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsAllSampleCarried]
GO
ALTER TABLE [Diag].[InvestigationInvoiceDetails] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsAllSampleCollected]
GO
ALTER TABLE [Diag].[InvestigationInvoiceDetails] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsAllSampleReceived]
GO
ALTER TABLE [Diag].[InvestigationInvoiceDetails] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Diag].[InvestigationInvoiceDetails] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsUrgent]
GO
ALTER TABLE [Diag].[InvestigationInvoiceDetails] ADD  DEFAULT ((1)) FOR [ImagingReportStatus]
GO
ALTER TABLE [Diag].[InvestigationInvoiceDetails] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Diag].[InvestigationInvoiceDetails] ADD  CONSTRAINT [DF_InvestigationInvoiceDetails_IsReportingFeePaid]  DEFAULT (CONVERT([bit],(0))) FOR [IsReportingFeePaid]
GO
ALTER TABLE [Diag].[InvestigationInvoiceLedgers] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Diag].[InvestigationInvoiceLedgers] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Diag].[InvestigationInvoiceLedgers] ADD  CONSTRAINT [DF_InvestigationInvoiceLedgers_DiscountCategoryId]  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [DiscountCategoryId]
GO
ALTER TABLE [Diag].[InvestigationInvoices] ADD  DEFAULT (CONVERT([bigint],(0))) FOR [UHID]
GO
ALTER TABLE [Diag].[InvestigationInvoices] ADD  CONSTRAINT [DF_InvestigationInvoices_RefdDoctorId]  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [RefdDoctorId]
GO
ALTER TABLE [Diag].[InvestigationInvoices] ADD  CONSTRAINT [DF_InvestigationInvoices_StaffRecordId]  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [StaffRecordId]
GO
ALTER TABLE [Diag].[InvestigationInvoices] ADD  CONSTRAINT [DF_InvestigationInvoices_IPDPatientRecordId]  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [IPDPatientRecordId]
GO
ALTER TABLE [Diag].[InvestigationInvoices] ADD  CONSTRAINT [DF_InvestigationInvoices_OPDEmergencyPatientId]  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [OPDEmergencyPatientId]
GO
ALTER TABLE [Diag].[InvestigationInvoices] ADD  CONSTRAINT [DF_InvestigationInvoices_IsCancelApproved]  DEFAULT ('False') FOR [IsCancelApproved]
GO
ALTER TABLE [Diag].[InvestigationInvoices] ADD  CONSTRAINT [DF_InvestigationInvoices_CancelApprovedBy]  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [CancelApprovedBy]
GO
ALTER TABLE [Diag].[InvestigationInvoices] ADD  CONSTRAINT [DF_InvestigationInvoices_MarketingAgentId]  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [MarketingJOfficerOrMediaId]
GO
ALTER TABLE [Diag].[InvestigationInvoices] ADD  CONSTRAINT [DF_InvestigationInvoices_UserId]  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [UserId]
GO
ALTER TABLE [Diag].[InvestigationInvoices] ADD  CONSTRAINT [DF_InvestigationInvoices_TenantId]  DEFAULT ((0)) FOR [TenantId]
GO
ALTER TABLE [Diag].[InvestigationInvoices] ADD  CONSTRAINT [DF_InvestigationInvoices_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [Diag].[InvestigationInvoices] ADD  CONSTRAINT [DF_InvestigationInvoices_IsDeleted]  DEFAULT ('False') FOR [IsDeleted]
GO
ALTER TABLE [Diag].[InvestigationInvoices] ADD  CONSTRAINT [DF_InvestigationInvoices_RxId]  DEFAULT ((0)) FOR [RxId]
GO
ALTER TABLE [Diag].[InvestigationInvoices] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Diag].[InvestigationInvoices] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [MediaId]
GO
ALTER TABLE [Diag].[InvestigationInvoices] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsConsultantPaid]
GO
ALTER TABLE [Diag].[InvestigationInvoices] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsMediaPaid]
GO
ALTER TABLE [Diag].[InvestigationInvoices] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsIPDPaid]
GO
ALTER TABLE [Diag].[InvestigationInvoices] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [InvestigationIndentId]
GO
ALTER TABLE [Diag].[InvestigationInvoices] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [CorporateClientId]
GO
ALTER TABLE [Diag].[InvestigationInvoices] ADD  CONSTRAINT [DF_InvestigationInvoices_IsMediaCommissionPaid]  DEFAULT (CONVERT([bit],(0))) FOR [IsMediaCommissionPaid]
GO
ALTER TABLE [Diag].[InvestigationInvoices] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [PackageId]
GO
ALTER TABLE [Diag].[IPDDiagnosis] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Diag].[IPDDueCollections] ADD  DEFAULT ((0)) FOR [TransactionType]
GO
ALTER TABLE [Diag].[IPDDueCollections] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Diag].[IPDInvestigationIndentDetails] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsPerformed]
GO
ALTER TABLE [Diag].[IPDInvestigationIndentDetails] ADD  DEFAULT (CONVERT([real],(0))) FOR [PackageRate]
GO
ALTER TABLE [Diag].[IPDInvestigationIndentDetails] ADD  DEFAULT (CONVERT([real],(0))) FOR [Rate]
GO
ALTER TABLE [Diag].[IPDInvestigationIndentDetails] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Diag].[IPDInvestigationIndentDetails] ADD  DEFAULT ('') FOR [ManualTestName]
GO
ALTER TABLE [Diag].[IPDInvestigationIndents] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [DoctorId]
GO
ALTER TABLE [Diag].[IPDInvestigationIndents] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Diag].[LISPatientRecord] ADD  CONSTRAINT [DF__LISPatien__Patie__17AE438D]  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [PatientId]
GO
ALTER TABLE [Diag].[LISPatientRecord] ADD  CONSTRAINT [DF__LISPatien__LabNo__5CC287E9]  DEFAULT ((0)) FOR [LabNo]
GO
ALTER TABLE [Diag].[LISPatientRecord] ADD  CONSTRAINT [DF__LISPatien__Patho__18A267C6]  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [PathologicalMachineId]
GO
ALTER TABLE [Diag].[LISPatientRecord] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Diag].[LISPatientRecord] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Diag].[LISResultRecord] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ParameterId]
GO
ALTER TABLE [Diag].[LISResultRecord] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Diag].[LISResultRecord] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [PatientRecordId]
GO
ALTER TABLE [Diag].[LISResultRecord] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Diag].[MachineGroupAndTestMapping] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Diag].[MachineGroupAndTestMapping] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [TestSampleId]
GO
ALTER TABLE [Diag].[MachineGroupAndTestMapping] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Diag].[MachineGroupAndTestMapping] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [PathologicalMachineGroupId]
GO
ALTER TABLE [Diag].[MediaPaymentRecords] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Diag].[Modalities] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Diag].[Modalities] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Diag].[Modalities] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [TestGroupId]
GO
ALTER TABLE [Diag].[ParentGroup] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Diag].[ParentGroup] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Diag].[PathMachineOutputParameter] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Diag].[PathMachineOutputParameter] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [TestItemId]
GO
ALTER TABLE [Diag].[PathMachineOutputParameter] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Diag].[PathMachineOutputParameter] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Diag].[PathMachineOutputParameter] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [TestSampleId]
GO
ALTER TABLE [Diag].[PathMachineOutputParameter] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ReportParameterId]
GO
ALTER TABLE [Diag].[PathologicalMachineGroups] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Diag].[PathologicalMachineGroups] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Diag].[PathologicalMachines] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Diag].[PathologicalMachines] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [PathologicalMachineGroupId]
GO
ALTER TABLE [Diag].[PathologyDescriptiveReports] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Diag].[PathologyReportConfigs] ADD  CONSTRAINT [DF__Pathology__Title__2A4DAD63]  DEFAULT ((1)) FOR [TitleVisible]
GO
ALTER TABLE [Diag].[PathologyReportConfigs] ADD  CONSTRAINT [DF__Pathology__Resul__2B41D19C]  DEFAULT ((1)) FOR [ResultVisible]
GO
ALTER TABLE [Diag].[PathologyReportConfigs] ADD  CONSTRAINT [DF__Pathology__UnitV__2C35F5D5]  DEFAULT ((1)) FOR [UnitVisible]
GO
ALTER TABLE [Diag].[PathologyReportConfigs] ADD  CONSTRAINT [DF__Pathology__Refer__2D2A1A0E]  DEFAULT ((1)) FOR [ReferenceValueVisible]
GO
ALTER TABLE [Diag].[PathologyReportConfigs] ADD  CONSTRAINT [DF__Pathology__Metho__2E1E3E47]  DEFAULT ((1)) FOR [MethodVisible]
GO
ALTER TABLE [Diag].[PathologyReportConfigs] ADD  CONSTRAINT [DF__Pathology__Colum__2F126280]  DEFAULT ('30, 20, 10, 20, 20') FOR [ColumnWidths]
GO
ALTER TABLE [Diag].[PathologyReportConfigs] ADD  CONSTRAINT [DF_PathologyReportConfigs_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [Diag].[PathologyReportDetails] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Diag].[PathologyReportDetails] ADD  DEFAULT ((0)) FOR [DisplayOrder]
GO
ALTER TABLE [Diag].[PathologyReportDetails] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsThisOnePrinted]
GO
ALTER TABLE [Diag].[PathologyReportDetails] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Diag].[PathologyReportDetails] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ReportParameterId]
GO
ALTER TABLE [Diag].[PathologyReportPermissions] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Diag].[PathologyReports] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Diag].[PathologyReports] ADD  DEFAULT ((0)) FOR [LabNo]
GO
ALTER TABLE [Diag].[PathologyReports] ADD  DEFAULT ((0)) FOR [SampleStatus]
GO
ALTER TABLE [Diag].[PathologyReports] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsCSGrowth]
GO
ALTER TABLE [Diag].[PathologyReports] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsCSReport]
GO
ALTER TABLE [Diag].[PathologyReports] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsReversedForResultReview]
GO
ALTER TABLE [Diag].[PathologyReports] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Diag].[PathologyReports] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ReportTechnologistId]
GO
ALTER TABLE [Diag].[PathologyReports] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ReportVerifierId]
GO
ALTER TABLE [Diag].[PathologyTemplates] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Diag].[RadiologyReports] ADD  DEFAULT ((0)) FOR [TenantId]
GO
ALTER TABLE [Diag].[RadiologyTemplates] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Diag].[ReportDeliveryTimingDetails] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Diag].[ReportDeliveryTimingDetails] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Diag].[ReportDeliveryTimingDetails] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Diag].[ReportDeliveryTimingDetails] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [RDTMId]
GO
ALTER TABLE [Diag].[ReportDeliveryTimingMasters] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Diag].[ReportDeliveryTimingMasters] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Diag].[ReportDeliveryTimingMasters] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Diag].[reportFormates] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Diag].[reportFormates] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Diag].[ReportingAgeGroups] ADD  DEFAULT ((0.0000000000000000e+000)) FOR [AgeHigherLimitLessThan]
GO
ALTER TABLE [Diag].[ReportingAgeGroups] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Diag].[ReportingAgeGroups] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Diag].[ReportParameters] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Diag].[ReportParameters] ADD  DEFAULT ((0.0000000000000000e+000)) FOR [Max]
GO
ALTER TABLE [Diag].[ReportParameters] ADD  DEFAULT ((0.0000000000000000e+000)) FOR [Min]
GO
ALTER TABLE [Diag].[ReportParameters] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsShowOnComparativeResult]
GO
ALTER TABLE [Diag].[ReportParameters] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsShowOnDischargeCertificate]
GO
ALTER TABLE [Diag].[ReportParameters] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Diag].[ReportParameters] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [TestMethodId]
GO
ALTER TABLE [Diag].[ReportParameters] ADD  DEFAULT ('text') FOR [InputType]
GO
ALTER TABLE [Diag].[ReportParameters] ADD  DEFAULT ('') FOR [ValueOptions]
GO
ALTER TABLE [Diag].[ReportParameters] ADD  DEFAULT ('') FOR [DefaultValue]
GO
ALTER TABLE [Diag].[ReportParameters] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [TestSampleId]
GO
ALTER TABLE [Diag].[ReportParameterValues] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ReportParameterId]
GO
ALTER TABLE [Diag].[ReportParameterValues] ADD  DEFAULT ((2)) FOR [TenantId]
GO
ALTER TABLE [Diag].[ReportParameterValues] ADD  DEFAULT ((0)) FOR [IsDefault]
GO
ALTER TABLE [Diag].[ReportVerifiers] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Diag].[ReportVerifiers] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Diag].[ReportVerifiers] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Diag].[SampleCarriers] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Diag].[SampleCarriers] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Diag].[SampleCollectionAndReceiptionPrinters] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Diag].[SampleCollectionAndReceiptionPrinters] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Diag].[SampleCollectionRecords] ADD  CONSTRAINT [DF__SampleCol__LabNo__03DC550A]  DEFAULT ((0)) FOR [LabNo]
GO
ALTER TABLE [Diag].[SampleCollectionRecords] ADD  CONSTRAINT [DF_SampleCollectionRecords_SampleCollectionBy]  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [SampleCollectionBy]
GO
ALTER TABLE [Diag].[SampleCollectionRecords] ADD  CONSTRAINT [DF_SampleCollectionRecords_SampleCarriedBy]  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [SampleCarriedBy]
GO
ALTER TABLE [Diag].[SampleCollectionRecords] ADD  CONSTRAINT [DF_SampleCollectionRecords_SampleReceiveByAtLab]  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [SampleReceiveByAtLab]
GO
ALTER TABLE [Diag].[SampleCollectionRecords] ADD  CONSTRAINT [DF_SampleCollectionRecords_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [Diag].[SampleCollectionRecords] ADD  CONSTRAINT [DF_SampleCollectionRecords_IsDeleted]  DEFAULT ('False') FOR [IsDeleted]
GO
ALTER TABLE [Diag].[SampleCollectionRecords] ADD  CONSTRAINT [DF__SampleCol__IsSyn__30C40A1A]  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Diag].[SampleCollectionRecords] ADD  DEFAULT ((0)) FOR [SampleStatus]
GO
ALTER TABLE [Diag].[SampleCollectionRecords] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Diag].[SampleCollectionRecords] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [TestSampleId]
GO
ALTER TABLE [Diag].[Technologists] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Diag].[Technologists] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Diag].[Technologists] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Diag].[TestGroups] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Diag].[TestGroups] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Diag].[TestGroups] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ParentGroupId]
GO
ALTER TABLE [Diag].[TestGroupWiseReportingFees] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [TestGroupId]
GO
ALTER TABLE [Diag].[TestItems] ADD  DEFAULT ((0)) FOR [DisplayOrder]
GO
ALTER TABLE [Diag].[TestItems] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Diag].[TestItems] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [TestMethodId]
GO
ALTER TABLE [Diag].[TestItems] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsReportInTableFormat]
GO
ALTER TABLE [Diag].[TestItems] ADD  DEFAULT ((0)) FOR [NoOfColumn]
GO
ALTER TABLE [Diag].[TestItems] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [TestGroupId]
GO
ALTER TABLE [Diag].[TestItems] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [Diag].[TestItems] ADD  CONSTRAINT [DF_TestItems_DefaultVacutainerId]  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [DefaultVacutainerId]
GO
ALTER TABLE [Diag].[TestItems] ADD  DEFAULT ((1)) FOR [IsDiscountAllow]
GO
ALTER TABLE [Diag].[TestSamples] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Diag].[VacutainerAndMachineGroupMappings] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Diag].[VacutainerAndMachineGroupMappings] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [PathologicalMachineGroupId]
GO
ALTER TABLE [Diag].[VacutainerAndMachineGroupMappings] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [EMR].[AdvicesOnTreatments] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [EMR].[AdvicesOnTreatments] ADD  DEFAULT ('') FOR [ManualAdivce]
GO
ALTER TABLE [EMR].[AdviceTemplates] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [DeptId]
GO
ALTER TABLE [EMR].[AppliedMedicationDoses] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [EMR].[BirthCertificates] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [EMR].[BloodRequisitions] ADD  DEFAULT ('') FOR [BloodGroup]
GO
ALTER TABLE [EMR].[BloodRequisitions] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [EMR].[BloodTransfusionOrders] ADD  DEFAULT (getdate()) FOR [DateTime]
GO
ALTER TABLE [EMR].[ColonscopyEMROrders] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [EMR].[ConsultancyVisitNotes] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [EMR].[DeathRecordCommonDataGroupItems] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [EMR].[DeathRecordCommonDatas] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [EMR].[DeathRecordDetails] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [EMR].[DeathRecords] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [EMR].[DietOnDischarges] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [EMR].[DietSuggests] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [EMR].[DoctorVisitPlans] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [EMR].[EMRAdvices] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [DeptId]
GO
ALTER TABLE [EMR].[EMRDiagnosises] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [EMR].[EndoscopyEMROrders] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [EMR].[ERCPEMROrders] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [EMR].[Holidays] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [EMR].[ICUCourses] ADD  DEFAULT ('0001-01-01T00:00:00.0000000') FOR [EntryDate]
GO
ALTER TABLE [EMR].[ICUCourses] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [EMR].[NurseToNursePatientHandOverRecords] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [EMR].[OTTemplates] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [DepartmentId]
GO
ALTER TABLE [EMR].[OTTemplates] ADD  CONSTRAINT [DF_OTTemplates_TenantId]  DEFAULT ((0)) FOR [TenantId]
GO
ALTER TABLE [EMR].[ProcedureNotes] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [EMR].[SuggestedInvestigations] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [EMR].[TransferNotesEMR] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [EMR].[TreatmentDoseTimingDetails] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [EMR].[TreatmentDoseTimings] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [EMR].[TreatmentOnDischarges] ADD  CONSTRAINT [DF__Treatment__Tenan__52469024]  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [EMR].[TreatmentOrderArchiveDetails] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsManualBrand]
GO
ALTER TABLE [EMR].[TreatmentOrderArchiveDetails] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [EMR].[TreatmentOrderArchives] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [EMR].[ZolendronicEMROrders] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[AdmittedPackages] ADD  CONSTRAINT [DF_AdmittedPackages_IsOccupiedByPatient]  DEFAULT (CONVERT([bit],(0))) FOR [IsOccupiedByPatient]
GO
ALTER TABLE [Hospital].[AdvancePaymentDetails] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[AdvancePayments] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[AdvicesByDepts] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [DeptId]
GO
ALTER TABLE [Hospital].[AdvicesByDepts] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Hospital].[AnaesthesiaTypes] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Hospital].[AnaesthesiaTypes] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Hospital].[AssignedDoctorRecords] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[BabyNotes] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[BedRentPackages] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[CabinChargeRules] ADD  DEFAULT (CONVERT([bit],(0))) FOR [OverlappedPickupMax]
GO
ALTER TABLE [Hospital].[CabinChargeRules] ADD  DEFAULT ((0)) FOR [AdmissionDayGracePeriodInminutes]
GO
ALTER TABLE [Hospital].[CabinChargeRules] ADD  DEFAULT ((0)) FOR [ReleaseDayGracePeriodInminutes]
GO
ALTER TABLE [Hospital].[CabinChargeRules] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsAdmissonDayPreCalendarTimeBillWillbeHourly]
GO
ALTER TABLE [Hospital].[CabinChargeRules] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsReleaseDayPostCalendarTimeBillWillbeHourly]
GO
ALTER TABLE [Hospital].[CabinChargeRules] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Hospital].[CabinChargeRules] ADD  DEFAULT ((0)) FOR [AdmissionDayMaxPreCalendarHour]
GO
ALTER TABLE [Hospital].[CabinChargeRules] ADD  DEFAULT ((0)) FOR [ReleaseDayMaxPostCalendarHour]
GO
ALTER TABLE [Hospital].[CabinChargeRules] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Hospital].[CabinChargeRules] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Hospital].[CabinDiscounts] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[Cabins] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsActive]
GO
ALTER TABLE [Hospital].[Cabins] ADD  DEFAULT ((0)) FOR [DisplayOrder]
GO
ALTER TABLE [Hospital].[Cabins] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [CabinTypeId]
GO
ALTER TABLE [Hospital].[Cabins] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [HDepartmentId]
GO
ALTER TABLE [Hospital].[CabinTypes] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Hospital].[CabinTypes] ADD  DEFAULT ((0)) FOR [AdmissionFee]
GO
ALTER TABLE [Hospital].[CabinTypes] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ServiceHeadId]
GO
ALTER TABLE [Hospital].[CabinTypes] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Hospital].[ConfinementNotes] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [AnaesthesiastId]
GO
ALTER TABLE [Hospital].[ConfinementNotes] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [SurgeonId]
GO
ALTER TABLE [Hospital].[ConfinementNotes] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[ConservativeTreatments] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [DoctorId]
GO
ALTER TABLE [Hospital].[ConservativeTreatments] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[ConsultancyPackages] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[DaywiseFoodBillCharges] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[DiscargeAdvices] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [DeptId]
GO
ALTER TABLE [Hospital].[DiscargeAdvices] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[DischargeCertificate] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Hospital].[DischargeCertificate] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[DischargeCertificate] ADD  DEFAULT ('00000000-0000-0000-0000-0000') FOR [PreparedBy]
GO
ALTER TABLE [Hospital].[DoDPatientAccesses] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Hospital].[DoDPatientAccesses] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Hospital].[DynamicFormCategories] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Hospital].[DynamicInputControls] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Hospital].[DynamicInputControls] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Hospital].[DynamicInputControlValues] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ControltypeId]
GO
ALTER TABLE [Hospital].[DynamicInputControlValues] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Hospital].[DynamicTemplateDetails] ADD  DEFAULT ((0)) FOR [DisplayOrder]
GO
ALTER TABLE [Hospital].[DynamicTemplateDetails] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ControlFormID]
GO
ALTER TABLE [Hospital].[DynamicTemplateDetails] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Hospital].[DynamicTemplateDetails] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [BindDropDownValue]
GO
ALTER TABLE [Hospital].[DynamicTemplateDetails] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ControltypeId]
GO
ALTER TABLE [Hospital].[DynamicTemplateDetails] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Hospital].[DynamicTemplates] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [DynamicFormCategoryId]
GO
ALTER TABLE [Hospital].[DynamicTemplates] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Hospital].[DynamicTemplates] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [DepartmentId]
GO
ALTER TABLE [Hospital].[DynamicTemplates] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Hospital].[FinalBillLedgers] ADD  DEFAULT ((0)) FOR [PaymentChannelId]
GO
ALTER TABLE [Hospital].[FinalBillLedgers] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [PosTerminalId]
GO
ALTER TABLE [Hospital].[FinalBillLedgers] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Hospital].[FinalBillLedgers] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[FinalBillLedgers] ADD  CONSTRAINT [DF_FinalBillLedgers_DiscountCategoryId]  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [DiscountCategoryId]
GO
ALTER TABLE [Hospital].[FinalBills] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Hospital].[FinalBills] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[FinalBillSummarys] ADD  DEFAULT ((0.0000000000000000e+000)) FOR [Discount]
GO
ALTER TABLE [Hospital].[FinalBillSummarys] ADD  DEFAULT ((0.0000000000000000e+000)) FOR [GrandTotal]
GO
ALTER TABLE [Hospital].[FinalBillSummarys] ADD  DEFAULT ((0.0000000000000000e+000)) FOR [ServiceCharge]
GO
ALTER TABLE [Hospital].[FinalBillSummarys] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Hospital].[FinalBillSummarys] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [SummaryHeadId]
GO
ALTER TABLE [Hospital].[FinalBillSummarys] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[FollowUpDataDetails] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [DynamicFormDId]
GO
ALTER TABLE [Hospital].[FollowUpDataDetails] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [MasterId]
GO
ALTER TABLE [Hospital].[FollowUpDataDetails] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Hospital].[FollowUpDataDetails] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ControltypeId]
GO
ALTER TABLE [Hospital].[FollowUpDataDetails] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [BindDropDownValue]
GO
ALTER TABLE [Hospital].[FollowUpDataDetails] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[FollowUpDatas] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [UserId]
GO
ALTER TABLE [Hospital].[FollowUpDatas] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [DynamicFormId]
GO
ALTER TABLE [Hospital].[FollowUpDatas] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Hospital].[FollowUpDatas] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[HDepartments] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Hospital].[HDepartments] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [DischargeTemplateId]
GO
ALTER TABLE [Hospital].[HDepartments] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Hospital].[HospitalDepartmentWiseRevenue] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[HospitalDepartmentWiseRevenue] ADD  DEFAULT ((1)) FOR [IsSynced]
GO
ALTER TABLE [Hospital].[IPDCabinAllocationRecords] ADD  CONSTRAINT [DF__IPDCabinA__Tenan__57FF697A]  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[IPDCabinAllocationRecords] ADD  CONSTRAINT [DF__IPDCabinA__SitRe__57CA5F50]  DEFAULT ((0)) FOR [SitRent]
GO
ALTER TABLE [Hospital].[IPDConsultantServices] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [UserId]
GO
ALTER TABLE [Hospital].[IPDConsultantServices] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsPostedToAccount]
GO
ALTER TABLE [Hospital].[IPDConsultantServices] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [DeliverySectionId]
GO
ALTER TABLE [Hospital].[IPDConsultantServices] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[IPDIndentForwardAndPatientAccesses] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [IndentForwardToOutlet]
GO
ALTER TABLE [Hospital].[IPDIndentForwardAndPatientAccesses] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [CanteenOutLetId]
GO
ALTER TABLE [Hospital].[IPDNonMedicationOrders] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Hospital].[IPDNonMedicationOrders] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [DoctorId]
GO
ALTER TABLE [Hospital].[IPDNonMedicationOrders] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Hospital].[IPDNonMedicationOrders] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [NonMedicationOrderId]
GO
ALTER TABLE [Hospital].[IPDNonMedicationOrders] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[IPDPatientEvents] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Hospital].[IPDPatientEvents] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [DoctorId]
GO
ALTER TABLE [Hospital].[IPDPatientEvents] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[IPDPatientRecords] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsManualCabinDayCount]
GO
ALTER TABLE [Hospital].[IPDPatientRecords] ADD  DEFAULT ((0)) FOR [CabinChargeCalculationGracePeriodType]
GO
ALTER TABLE [Hospital].[IPDPatientRecords] ADD  DEFAULT ((0)) FOR [AdmissionFee]
GO
ALTER TABLE [Hospital].[IPDPatientRecords] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ChiefConsultantId]
GO
ALTER TABLE [Hospital].[IPDPatientRecords] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [DeptId]
GO
ALTER TABLE [Hospital].[IPDPatientRecords] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [CorporateClientId]
GO
ALTER TABLE [Hospital].[IPDPatientRecords] ADD  DEFAULT ((0)) FOR [IsEMRLoaded]
GO
ALTER TABLE [Hospital].[IPDPatientRecords] ADD  DEFAULT ((0)) FOR [IsTransferredFromOrigin]
GO
ALTER TABLE [Hospital].[IPDPatientRecords] ADD  CONSTRAINT [DF_IPDPatientRecords_IsMediaCommissionPaid]  DEFAULT (CONVERT([bit],(0))) FOR [IsMediaCommissionPaid]
GO
ALTER TABLE [Hospital].[IPDPatientRecords] ADD  CONSTRAINT [DF_IPDPatientRecords_BillingMode]  DEFAULT ('General') FOR [BillingMode]
GO
ALTER TABLE [Hospital].[IPDServiceRecords] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [UserId]
GO
ALTER TABLE [Hospital].[IPDServiceRecords] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsPostedToAccount]
GO
ALTER TABLE [Hospital].[IPDServiceRecords] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [DeliverySectionId]
GO
ALTER TABLE [Hospital].[IPDServiceRecords] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[ManualCabinDays] ADD  DEFAULT ('0001-01-01T00:00:00.0000000') FOR [EntryDate]
GO
ALTER TABLE [Hospital].[ManualCabinDays] ADD  DEFAULT (CONVERT([real],(0))) FOR [PackageRate]
GO
ALTER TABLE [Hospital].[ManualCabinDays] ADD  DEFAULT (CONVERT([real],(0))) FOR [Rate]
GO
ALTER TABLE [Hospital].[ManualCabinDays] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [CabinTypeId]
GO
ALTER TABLE [Hospital].[ManualCabinDays] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[MedicineReturnIndentDetails] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[MedicineReturnIndents] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [IndentToOutletId]
GO
ALTER TABLE [Hospital].[MedicineReturnIndents] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[MemberPictures] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Hospital].[MemberPictures] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [DoctorId]
GO
ALTER TABLE [Hospital].[MemberPictures] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Hospital].[MemberPictures] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Hospital].[MemberShipTypes] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Hospital].[MemberShipTypes] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Hospital].[NonMedicationOrders] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Hospital].[NonMedicationOrders] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Hospital].[OTInfoNurseStationDetails] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[OTInfoNurseStations] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [AnaesthesiaTypeId]
GO
ALTER TABLE [Hospital].[OTInfoNurseStations] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [OTNameId ]
GO
ALTER TABLE [Hospital].[OTInfoNurseStations] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[OTNames] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Hospital].[OTNames] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Hospital].[OTNames] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[OTNotes] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [AnesthetistId]
GO
ALTER TABLE [Hospital].[OTNotes] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [SurgeonId]
GO
ALTER TABLE [Hospital].[OTNotes] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [OTNameId]
GO
ALTER TABLE [Hospital].[OTNotes] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[OTRoom] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Hospital].[OTRoom] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[OTRoomBookingRequests] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [OTScheduleId]
GO
ALTER TABLE [Hospital].[OTRoomBookingRequests] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [RequestForOTRoomId]
GO
ALTER TABLE [Hospital].[OTRoomBookingRequests] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[OTRoomBooks] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [OTRoomId]
GO
ALTER TABLE [Hospital].[OTRoomBooks] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[OTSchedules] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsCompleted]
GO
ALTER TABLE [Hospital].[OTSchedules] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Hospital].[OTSchedules] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [OTNameId]
GO
ALTER TABLE [Hospital].[OTSchedules] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [OTTypeId]
GO
ALTER TABLE [Hospital].[OTSchedules] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[OTServiceDetails] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsPostedToAccount]
GO
ALTER TABLE [Hospital].[OTServiceDetails] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[OTServices] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [AnaesthesiaTypeId]
GO
ALTER TABLE [Hospital].[OTServices] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [OTNameId]
GO
ALTER TABLE [Hospital].[OTServices] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [OTTypeId]
GO
ALTER TABLE [Hospital].[OTServices] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[OTTypes] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Hospital].[OTTypes] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Hospital].[PackageInvestigations] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Hospital].[PackageIPDServices] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[PackageMedicines] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[PatientConditionDuringDischarges] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Hospital].[PatientDynamicFormDataDetails] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [MasterId]
GO
ALTER TABLE [Hospital].[PatientDynamicFormDataDetails] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [DynamicFormDId]
GO
ALTER TABLE [Hospital].[PatientDynamicFormDataDetails] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Hospital].[PatientDynamicFormDataDetails] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [BindDropDownValue]
GO
ALTER TABLE [Hospital].[PatientDynamicFormDataDetails] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ControltypeId]
GO
ALTER TABLE [Hospital].[PatientDynamicFormDataDetails] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[PatientDynamicFormDatas] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [DoctorId]
GO
ALTER TABLE [Hospital].[PatientDynamicFormDatas] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [UserId]
GO
ALTER TABLE [Hospital].[PatientDynamicFormDatas] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [DynamicFormId]
GO
ALTER TABLE [Hospital].[PatientDynamicFormDatas] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Hospital].[PatientDynamicFormDatas] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[PostDischargeAdvices] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsBaby]
GO
ALTER TABLE [Hospital].[PostDischargeAdvices] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[PostDischargeFollowups] ADD  CONSTRAINT [DF__PostDisch__Remar__004264FE]  DEFAULT ('') FOR [Remarks]
GO
ALTER TABLE [Hospital].[PostDischargeFollowups] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[PostOperativeNotes] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[PreoperativeNotes] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[ProcedureWeights] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Hospital].[ProcedureWeights] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Hospital].[RegRecords] ADD  CONSTRAINT [DF_RegRecords_UnionId]  DEFAULT ((0)) FOR [UnionId]
GO
ALTER TABLE [Hospital].[RegRecords] ADD  CONSTRAINT [DF_RegRecords_DesignationId]  DEFAULT ((0)) FOR [DesignationId]
GO
ALTER TABLE [Hospital].[RegRecords] ADD  CONSTRAINT [DF_RegRecords_UpazilaOrAreaId]  DEFAULT ((0)) FOR [UpazilaOrAreaId]
GO
ALTER TABLE [Hospital].[RegRecords] ADD  CONSTRAINT [DF_RegRecords_LocalGurdianUpazilaOrAreaId]  DEFAULT ((0)) FOR [LocalGurdianUpazilaOrAreaId]
GO
ALTER TABLE [Hospital].[RegRecords] ADD  CONSTRAINT [DF_RegRecords_RegDate]  DEFAULT (getdate()) FOR [RegDate]
GO
ALTER TABLE [Hospital].[RegRecords] ADD  CONSTRAINT [DF_RegRecords_IsRegisterd]  DEFAULT ('False') FOR [IsRegisterd]
GO
ALTER TABLE [Hospital].[RegRecords] ADD  CONSTRAINT [DF_RegRecords_RefdId]  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [RefdId]
GO
ALTER TABLE [Hospital].[RegRecords] ADD  CONSTRAINT [DF_RegRecords_TenantId]  DEFAULT ((0)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[RegRecords] ADD  CONSTRAINT [DF_RegRecords_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [Hospital].[RegRecords] ADD  CONSTRAINT [DF_RegRecords_IsDeleted]  DEFAULT ('False') FOR [IsDeleted]
GO
ALTER TABLE [Hospital].[RegRecords] ADD  CONSTRAINT [DF__RegRecord__IsSyn__489B93AB]  DEFAULT ('False') FOR [IsSynced]
GO
ALTER TABLE [Hospital].[RegRecords] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsOTPVerified]
GO
ALTER TABLE [Hospital].[RegRecords] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [CompanyId]
GO
ALTER TABLE [Hospital].[RxIpdTreatmentLogs] ADD  DEFAULT ('started') FOR [EventName]
GO
ALTER TABLE [Hospital].[RxIpdTreatmentLogs] ADD  DEFAULT ('') FOR [Note]
GO
ALTER TABLE [Hospital].[RxIpdTreatmentLogs] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[RxIpdTreatmentLogs] ADD  DEFAULT ((1)) FOR [IsSynced]
GO
ALTER TABLE [Hospital].[RxIpdTreatments] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [DoctorId]
GO
ALTER TABLE [Hospital].[RxIpdTreatments] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ConsultantId]
GO
ALTER TABLE [Hospital].[RxIpdTreatments] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsDischargeCertificate]
GO
ALTER TABLE [Hospital].[RxIpdTreatments] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsManualBrand]
GO
ALTER TABLE [Hospital].[RxIpdTreatments] ADD  DEFAULT ((0)) FOR [DisplayOrder]
GO
ALTER TABLE [Hospital].[RxIpdTreatments] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[SaveConsultancyPaymentRecordDetails] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[SaveConsultancyPaymentRecords] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[ServiceExecutingHeadRates] ADD  DEFAULT ((0)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[ServiceExecutingHeadRates] ADD  DEFAULT (CONVERT([real],(0))) FOR [Rate]
GO
ALTER TABLE [Hospital].[ServiceExecutingHeadRates] ADD  DEFAULT ((0)) FOR [ConsultantCommInPercent]
GO
ALTER TABLE [Hospital].[ServiceExecutingHeadRates] ADD  DEFAULT (CONVERT([bit],(0))) FOR [DocVisit]
GO
ALTER TABLE [Hospital].[ServiceExecutingHeadRates] ADD  DEFAULT ((0)) FOR [HospitalCommInPercent]
GO
ALTER TABLE [Hospital].[ServiceExecutingHeadRates] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsServiceChargeApplicable]
GO
ALTER TABLE [Hospital].[ServiceExecutingHeadRates] ADD  DEFAULT (CONVERT([bit],(0))) FOR [OpdShow]
GO
ALTER TABLE [Hospital].[ServiceExecutingHeadRates] ADD  DEFAULT (CONVERT([real],(0))) FOR [PoorFund]
GO
ALTER TABLE [Hospital].[ServiceExecutingHeadRates] ADD  DEFAULT ((0)) FOR [ServiceChargeInPercent]
GO
ALTER TABLE [Hospital].[ServiceExecutingHeadRates] ADD  DEFAULT (CONVERT([bit],(0))) FOR [VAT]
GO
ALTER TABLE [Hospital].[ServiceExecutingHeadRates] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsActive]
GO
ALTER TABLE [Hospital].[ServiceExecutingHeads] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ServiceSubSubGroupId]
GO
ALTER TABLE [Hospital].[ServiceExecutingHeads] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[ServiceGroups] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Hospital].[ServiceGroups] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Hospital].[ServiceIncomeShares] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Hospital].[ServiceIncomeShares] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[ServiceIncomeShares] ADD  CONSTRAINT [DF_ServiceIncomeShares_DoctorId]  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [DoctorId]
GO
ALTER TABLE [Hospital].[ServicePackages] ADD  CONSTRAINT [DF_ServicePackages_PackageDuration]  DEFAULT ((0)) FOR [PackageDuration]
GO
ALTER TABLE [Hospital].[ServiceSubGroups] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Hospital].[ServiceSubGroups] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ServiceGroupId]
GO
ALTER TABLE [Hospital].[ServiceSubGroups] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Hospital].[ServiceSubSubGroups] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Hospital].[ServiceSubSubGroups] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ServiceSubGroupId]
GO
ALTER TABLE [Hospital].[ServiceSubSubGroups] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Hospital].[SMSNotifications] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ServiceUnitId]
GO
ALTER TABLE [Hospital].[SMSNotifications] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[TransferNotes] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[VitalSignRecordDetails] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [DynamicFormDId]
GO
ALTER TABLE [Hospital].[VitalSignRecordDetails] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [MasterId]
GO
ALTER TABLE [Hospital].[VitalSignRecordDetails] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Hospital].[VitalSignRecordDetails] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [BindDropDownValue]
GO
ALTER TABLE [Hospital].[VitalSignRecordDetails] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ControltypeId]
GO
ALTER TABLE [Hospital].[VitalSignRecordDetails] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[VitalSignRecords] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [DynamicFormId]
GO
ALTER TABLE [Hospital].[VitalSignRecords] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Hospital].[VitalSignRecords] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Hospital].[VitalSignRecords] ADD  DEFAULT ((0)) FOR [HasValue]
GO
ALTER TABLE [Hospital].[VitalSignRecords] ADD  DEFAULT ((0)) FOR [VitalNo]
GO
ALTER TABLE [HR].[AttachedDocs] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [HR].[AttendanceRecords] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [HR].[Departments] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [HR].[DeptInchargeDocs] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [HR].[DeptIncharges] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [HR].[Designations] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [HR].[Divisions] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [HR].[DutyExchangeRecords] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ExchangeWithStaffId]
GO
ALTER TABLE [HR].[DutyRoasterCalender] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [HR].[DutyRoasterCalenderDetail] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [HR].[DutyRoasterSettings] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [HR].[EducationalQualifications] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [HR].[EmergencyContacts] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [HR].[Festivals] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [HR].[IndividualEmployeeLeavePolices] ADD  DEFAULT ((0)) FOR [LateConsiderAfterInMins]
GO
ALTER TABLE [HR].[JobCirculations] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [HR].[JobCvs] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [HR].[LeaveApplications] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [HR].[LeaveApplications] ADD  DEFAULT ('0001-01-01T00:00:00.0000000') FOR [EndDate]
GO
ALTER TABLE [HR].[LeaveApplications] ADD  DEFAULT ('0001-01-01T00:00:00.0000000') FOR [ApplicationDate]
GO
ALTER TABLE [HR].[LeaveApplications] ADD  DEFAULT ('0001-01-01T00:00:00.0000000') FOR [ExtraEndDate]
GO
ALTER TABLE [HR].[LeaveApplications] ADD  DEFAULT ('0001-01-01T00:00:00.0000000') FOR [ExtraStartDate]
GO
ALTER TABLE [HR].[LeaveApplications] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [SubstituteStaffId]
GO
ALTER TABLE [HR].[LeaveApplications] ADD  DEFAULT ((0)) FOR [TotalLeaveQTY]
GO
ALTER TABLE [HR].[LeaveApplications] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [UserId]
GO
ALTER TABLE [HR].[LeaveApprovalSettings] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [HR].[LeavePolicies] ADD  DEFAULT ((0)) FOR [TotalYearlyLeave]
GO
ALTER TABLE [HR].[LeavePolicies] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [HR].[LeaveRecords] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [HR].[LeaveTypes] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [HR].[ManualAttendances] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [HR].[PFSettlements] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [StaffRecordId]
GO
ALTER TABLE [HR].[PFSettlements] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ApprovedBy]
GO
ALTER TABLE [HR].[PFSettlements] ADD  DEFAULT ('') FOR [Reference]
GO
ALTER TABLE [HR].[RoasterType] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [HR].[RoasterType] ADD  CONSTRAINT [DF_RoasterType_DepartmentId]  DEFAULT ((0)) FOR [DepartmentId]
GO
ALTER TABLE [HR].[StaffFestivalMappings] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [HR].[StaffRecords] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [HR].[StaffRecords] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsPFSettled]
GO
ALTER TABLE [HR].[SubDepartments] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Identity].[RoleClaims] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Identity].[Roles] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Identity].[UserRoles] ADD  DEFAULT ((1)) FOR [IsSynced]
GO
ALTER TABLE [Identity].[Users] ADD  CONSTRAINT [DF__Users__DoctorId__20ECC9AD]  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [DoctorId]
GO
ALTER TABLE [Identity].[Users] ADD  CONSTRAINT [DF__Users__IsSynced__02091B31]  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Identity].[Users] ADD  CONSTRAINT [DF_Users_RefreshToken]  DEFAULT ('Test') FOR [RefreshToken]
GO
ALTER TABLE [Identity].[Users] ADD  CONSTRAINT [DF_Users_RefreshTokenExpiryTime]  DEFAULT (getdate()) FOR [RefreshTokenExpiryTime]
GO
ALTER TABLE [Identity].[Users] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [TechnologistId]
GO
ALTER TABLE [Location].[Districts] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Location].[Divisions] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Log].[UserActivityLog] ADD  DEFAULT ((0)) FOR [ModuleType]
GO
ALTER TABLE [Log].[UserActivityLog] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Marketing].[CommissionGroups] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Marketing].[CommissionSetups] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [CommissionGroupId]
GO
ALTER TABLE [Marketing].[CorporateClients] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Marketing].[CorporateClients] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [DiscountGroupId]
GO
ALTER TABLE [Marketing].[CorporateClients] ADD  DEFAULT (CONVERT([bit],(1))) FOR [IsCash]
GO
ALTER TABLE [Marketing].[CorporateClients] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsCredit]
GO
ALTER TABLE [Marketing].[CorporateClients] ADD  DEFAULT (CONVERT([bit],(0))) FOR [InGross]
GO
ALTER TABLE [Marketing].[CorporateClients] ADD  DEFAULT (CONVERT([bit],(1))) FOR [InPercent]
GO
ALTER TABLE [Marketing].[CorporateClients] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Marketing].[DoctorCommissions] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Marketing].[DoctorCommissions] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ServiceExecutingHeadId]
GO
ALTER TABLE [Marketing].[DoctorFieldOfSpecialities] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Marketing].[Doctors] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsActive]
GO
ALTER TABLE [Marketing].[Doctors] ADD  DEFAULT ((0)) FOR [RxDepartmentId]
GO
ALTER TABLE [Marketing].[FeederTenants] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Marketing].[HoDs] ADD  CONSTRAINT [DF_HoDs_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [Marketing].[MarketingJOfficerOrMedias] ADD  CONSTRAINT [DF_MarketingJOfficerOrMedias_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [Marketing].[MarketingJOfficerOrMedias] ADD  CONSTRAINT [DF_MarketingJOfficerOrMedias_CommissionGroupId]  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [CommissionGroupId]
GO
ALTER TABLE [Marketing].[MarketingManagers] ADD  CONSTRAINT [DF_MarketingManagers_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [Marketing].[MarketingOfficers] ADD  CONSTRAINT [DF_MarketingOfficers_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [Menu].[MenuPermissions] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Menu].[MenuPermissions] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [MenuId]
GO
ALTER TABLE [Menu].[MenuPermissions] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Menu].[MenuPermissions] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Nutrition].[CabinTypeAndMealMappings] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [CabinTypeId]
GO
ALTER TABLE [Nutrition].[CabinTypeAndMealMappings] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Nutrition].[FoodDeliverableDetails] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ItemId ]
GO
ALTER TABLE [Nutrition].[FoodDeliverableDetails] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Nutrition].[FoodDeliverables] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ReviewedByUserId]
GO
ALTER TABLE [Nutrition].[FoodDeliverables] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Nutrition].[FoodDeliverables] ADD  DEFAULT ((0)) FOR [IsChanged]
GO
ALTER TABLE [Nutrition].[FoodPatternDetail] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ItemId ]
GO
ALTER TABLE [Nutrition].[FoodPatternDetail] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Nutrition].[MealTypes] ADD  DEFAULT ((0)) FOR [OrderValue]
GO
ALTER TABLE [OPD].[ChamberPractionerRoutines] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [OPD].[ChamberPractionerSettings] ADD  DEFAULT ((0)) FOR [PatientCount]
GO
ALTER TABLE [OPD].[ChamberPractionerSettings] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [OPD].[ConsultancyDetails] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ServiceId]
GO
ALTER TABLE [OPD].[ConsultancyDetails] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsCancelApproved]
GO
ALTER TABLE [OPD].[ConsultancyDetails] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [OPD].[ConsultancyDetails] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [OPD].[CPFeeCollectionRecords] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [OPD].[CPLedgers] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [OPD].[CPPatientRecords] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [OPD].[DoctorAppointments] ADD  DEFAULT ((0)) FOR [SerialNo]
GO
ALTER TABLE [OPD].[DoctorAppointments] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [UserId]
GO
ALTER TABLE [OPD].[DoctorAppointments] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [OPD].[DoctorAppointments] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [RefdDoctorId]
GO
ALTER TABLE [OPD].[DoctorAppointments] ADD  DEFAULT ('') FOR [ReleventHistory]
GO
ALTER TABLE [OPD].[DoctorAppointments] ADD  DEFAULT ('') FOR [ClinicalFindings]
GO
ALTER TABLE [OPD].[DoctorAppointments] ADD  DEFAULT ('') FOR [ClinicalImpression]
GO
ALTER TABLE [OPD].[DoctorAppointments] ADD  DEFAULT ('Pending') FOR [MedicineServeStatus]
GO
ALTER TABLE [OPD].[DoctorAppointments] ADD  DEFAULT ((0)) FOR [RxDepartmentId]
GO
ALTER TABLE [OPD].[OPDConsultancyLedger] ADD  DEFAULT ((0)) FOR [TransactionType]
GO
ALTER TABLE [OPD].[OPDConsultancyLedger] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [UserId]
GO
ALTER TABLE [OPD].[OPDConsultancyLedger] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [PosTerminalId]
GO
ALTER TABLE [OPD].[OPDConsultancyLedger] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [OPD].[OPDConsultancyLedger] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [OPD].[OPDConsultancyLedger] ADD  CONSTRAINT [DF_OPDConsultancyLedger_DiscountCategoryId]  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [DiscountCategoryId]
GO
ALTER TABLE [OPD].[OPDIncomeSharings] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [OPD].[OPDIncomeSharings] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [OPD].[OPDIncomeSharings] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [OPD].[OPDPatientHistories] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [DynamicFormId]
GO
ALTER TABLE [OPD].[OPDPatientHistories] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [OPD].[OPDPatientHistories] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [OPD].[OPDPatientHistoryDetails] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [MasterId]
GO
ALTER TABLE [OPD].[OPDPatientHistoryDetails] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [OPD].[OPDPatientHistoryDetails] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [OPD].[OPDPrescriptions] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [AppointmentId]
GO
ALTER TABLE [OPD].[OPDPrescriptions] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [VisitId]
GO
ALTER TABLE [OPD].[OPDPrescriptions] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [AdmissionUnderDoctorId]
GO
ALTER TABLE [OPD].[OPDPrescriptions] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [AdmissionUnderDepartmentId]
GO
ALTER TABLE [OPD].[OPDPrescriptions] ADD  DEFAULT ((0)) FOR [IsInformed]
GO
ALTER TABLE [OPD].[OPDPrescriptions] ADD  DEFAULT ((0)) FOR [OPDRxNo]
GO
ALTER TABLE [OPD].[OPDPrescriptions] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [VitalId]
GO
ALTER TABLE [OPD].[OPDServiceLedger] ADD  DEFAULT ((0)) FOR [TransactionType]
GO
ALTER TABLE [OPD].[OPDServiceLedger] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [UserId]
GO
ALTER TABLE [OPD].[OPDServiceLedger] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [PosTerminalId]
GO
ALTER TABLE [OPD].[OPDServiceLedger] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [OPD].[OPDServiceLedger] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [OPD].[OPDServiceLedger] ADD  CONSTRAINT [DF_OPDServiceLedger_DiscountCategoryId]  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [DiscountCategoryId]
GO
ALTER TABLE [OPD].[OTAssistantPaymentDetails] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [OPD].[OTAssistantPayments] ADD  DEFAULT (CONVERT([bigint],(0))) FOR [IPDPatientInvoiceNo]
GO
ALTER TABLE [OPD].[OTAssistantPayments] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [OPD].[PatientRecordConsultancyFees] ADD  DEFAULT (CONVERT([bigint],(0))) FOR [UHID]
GO
ALTER TABLE [OPD].[PatientRecordConsultancyFees] ADD  CONSTRAINT [DF__PatientRe__UserI__7FD5EEA5]  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [UserId]
GO
ALTER TABLE [OPD].[PatientRecordConsultancyFees] ADD  DEFAULT ((0)) FOR [TenantId]
GO
ALTER TABLE [OPD].[PatientRecordConsultancyFees] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [MarketingJOfficerOrMediaId]
GO
ALTER TABLE [OPD].[PatientRecordConsultancyFees] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [OPD].[PatientRecordConsultancyFees] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ServiceSubSubGroupId]
GO
ALTER TABLE [OPD].[PatientRecordOPDServices] ADD  DEFAULT (CONVERT([bigint],(0))) FOR [UHID]
GO
ALTER TABLE [OPD].[PatientRecordOPDServices] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [UserId]
GO
ALTER TABLE [OPD].[PatientRecordOPDServices] ADD  DEFAULT ((0)) FOR [TenantId]
GO
ALTER TABLE [OPD].[PatientRecordOPDServices] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [MarketingJOfficerOrMediaId]
GO
ALTER TABLE [OPD].[PatientRecordOPDServices] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ServiceByDoctorId]
GO
ALTER TABLE [OPD].[PatientRecordOPDServices] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [OPD].[PatientRecordOPDServices] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ServiceSubSubGroupId]
GO
ALTER TABLE [OPD].[PatientRecordOPDServices] ADD  CONSTRAINT [DF_PatientRecordOPDServices_SerialNo]  DEFAULT ('') FOR [SerialNo]
GO
ALTER TABLE [OPD].[PatientRecordOPDServices] ADD  DEFAULT ((0)) FOR [IndentNo]
GO
ALTER TABLE [OPD].[PatientVisitTypes] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [OPD].[Schedules] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [OPD].[ServiceDetails] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Others].[Messages] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [UserId]
GO
ALTER TABLE [Others].[Messages] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Others].[Notifications] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Others].[NotificationSentTos] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Payroll].[AllowancePayments] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Payroll].[ApprovedSalarySheets] ADD  DEFAULT ((0.0000000000000000e+000)) FOR [IncomeTax]
GO
ALTER TABLE [Payroll].[ApprovedSalarySheets] ADD  DEFAULT ((0.0000000000000000e+000)) FOR [Arrear]
GO
ALTER TABLE [Payroll].[ApprovedSalarySheets] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsCommit]
GO
ALTER TABLE [Payroll].[ApprovedSalarySheets] ADD  DEFAULT ((0.0000000000000000e+000)) FOR [OtherAllowance]
GO
ALTER TABLE [Payroll].[ApprovedSalarySheets] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Payroll].[ArrearRecords] ADD  DEFAULT ((0.0000000000000000e+000)) FOR [Amount]
GO
ALTER TABLE [Payroll].[ArrearRecords] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Payroll].[FestivalBonuses] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Payroll].[GeneralSalaryPolicies] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Payroll].[IncrementRecords] ADD  CONSTRAINT [DF_IncrementRecords_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [Payroll].[IncrementRecords] ADD  CONSTRAINT [DF_IncrementRecords_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [Payroll].[IncrementRecords] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsCommit]
GO
ALTER TABLE [Payroll].[IncrementRecords] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Payroll].[IncrementTypes] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Payroll].[IndividualSalaries] ADD  CONSTRAINT [DF__Individua__IsPFD__24B26D99]  DEFAULT (CONVERT([bit],(0))) FOR [IsPFDeductionOn]
GO
ALTER TABLE [Payroll].[IndividualSalaries] ADD  CONSTRAINT [DF__Individua__Gener__695C9DA1]  DEFAULT ((0)) FOR [GeneralSalaryPolicyId]
GO
ALTER TABLE [Payroll].[IndividualSalaries] ADD  CONSTRAINT [DF__Individua__Incer__6A50C1DA]  DEFAULT ((0)) FOR [IncermentTypeId]
GO
ALTER TABLE [Payroll].[IndividualSalaries] ADD  DEFAULT ((0)) FOR [SalaryEvaluationDurationId]
GO
ALTER TABLE [Payroll].[IndividualSalaries] ADD  DEFAULT ((0.0000000000000000e+000)) FOR [TaxableAmount]
GO
ALTER TABLE [Payroll].[IndividualSalaries] ADD  DEFAULT ((0.0000000000000000e+000)) FOR [OtherAllowance]
GO
ALTER TABLE [Payroll].[IndividualSalaries] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Payroll].[PFLedgers] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Payroll].[SalaryEvaluationDurations] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Payroll].[SalaryPunishments] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Payroll].[SalaryStartStopRecords] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Payroll].[StaffGlobalLedgers] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Payroll].[StaffGlobalLedgers] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ReferranceId]
GO
ALTER TABLE [Payroll].[StaffGlobalLedgers] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ServiceUnitId]
GO
ALTER TABLE [Payroll].[StaffMonthlySalaryRecords] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Payroll].[StaffOvertimes] ADD  DEFAULT ((0)) FOR [Hours]
GO
ALTER TABLE [Payroll].[StaffOvertimes] ADD  DEFAULT ((0)) FOR [OverTimeMonth]
GO
ALTER TABLE [Payroll].[StaffOvertimes] ADD  DEFAULT ((0)) FOR [OverTimeYear]
GO
ALTER TABLE [Payroll].[StaffOvertimes] ADD  DEFAULT ((0.0000000000000000e+000)) FOR [TotalAmount]
GO
ALTER TABLE [Payroll].[StaffOvertimes] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Payroll].[StaffSalaryDeductions] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Payroll].[TimedAttendanceLogPullHistories] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Payroll].[TimedAttendanceLogs] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Personal].[BloodGroups] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Personal].[Genders] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Personal].[MaritalStatus] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Personal].[Occupations] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Personal].[Relations] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Personal].[Religions] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Personal].[TitleOrNamePrefixes] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Personal].[UpazilaOrAreas] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [PFBook].[PfGeneralLedgers] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [StaffRecordId]
GO
ALTER TABLE [PFBook].[PFVoucherMasterDetails] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ServiceUnitId]
GO
ALTER TABLE [PFBook].[PFVoucherMasters] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsPFSettledVoucher]
GO
ALTER TABLE [PFBook].[PFVoucherMasters] ADD  DEFAULT ('0001-01-01T00:00:00.0000000') FOR [ChequeDate]
GO
ALTER TABLE [PFBook].[PFVoucherMasters] ADD  DEFAULT ('0001-01-01T00:00:00.0000000') FOR [ChequeDepositDate]
GO
ALTER TABLE [PFBook].[PFVoucherMasters] ADD  DEFAULT ((0)) FOR [ChequeYear]
GO
ALTER TABLE [PFBook].[PFVoucherMasters] ADD  DEFAULT ('0001-01-01T00:00:00.0000000') FOR [MatureDate]
GO
ALTER TABLE [PFBook].[PFVoucherMasters] ADD  DEFAULT ('0001-01-01T00:00:00.0000000') FOR [FDRWithdrawDate]
GO
ALTER TABLE [PFBook].[PFVoucherMasters] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ServiceUnitId]
GO
ALTER TABLE [PFBook].[PFVoucherMasters] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [FYearId]
GO
ALTER TABLE [Pharmacy].[AuditedStocks] ADD  DEFAULT ((0)) FOR [ExpireStock]
GO
ALTER TABLE [Pharmacy].[AuditedStocks] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsCountComplete]
GO
ALTER TABLE [Pharmacy].[AuditedStocks] ADD  DEFAULT ((0)) FOR [ShortDateStock]
GO
ALTER TABLE [Pharmacy].[AuditedStocks] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Pharmacy].[BrandExtensions] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsActive]
GO
ALTER TABLE [Pharmacy].[BrandExtensions] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [FormationId]
GO
ALTER TABLE [Pharmacy].[BrandExtensions] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [GenericId]
GO
ALTER TABLE [Pharmacy].[BrandExtensions] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [StrengthId]
GO
ALTER TABLE [Pharmacy].[BrandNames] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [SubCategoryId]
GO
ALTER TABLE [Pharmacy].[BrandNames] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ManufacturerId]
GO
ALTER TABLE [Pharmacy].[Formations] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Pharmacy].[Formations] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Pharmacy].[Formations] ADD  DEFAULT ((2)) FOR [TenantId]
GO
ALTER TABLE [Pharmacy].[Generics] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Pharmacy].[Generics] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Pharmacy].[Generics] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [GroupId]
GO
ALTER TABLE [Pharmacy].[Groups] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Pharmacy].[Groups] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Pharmacy].[InvoiceDetails] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Pharmacy].[InvoiceLedgers] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Pharmacy].[InvoiceLedgers] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Pharmacy].[InvoiceLedgers] ADD  CONSTRAINT [DF_InvoiceLedgers_DiscountCategoryId]  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [DiscountCategoryId]
GO
ALTER TABLE [Pharmacy].[Invoices] ADD  DEFAULT ((0)) FOR [ServeTypeId]
GO
ALTER TABLE [Pharmacy].[Invoices] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Pharmacy].[Invoices] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsIPDBillPaid]
GO
ALTER TABLE [Pharmacy].[Invoices] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [MedicineReturnIndentId]
GO
ALTER TABLE [Pharmacy].[Invoices] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsPostedToAccount]
GO
ALTER TABLE [Pharmacy].[Invoices] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [MedicineOutletId]
GO
ALTER TABLE [Pharmacy].[InvoiceTypes] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Pharmacy].[IPDMedicineIndentDetails] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Pharmacy].[IPDMedicineIndents] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Pharmacy].[IPDMedicineIndents] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [IndentToOutletId]
GO
ALTER TABLE [Pharmacy].[IPDMedicineIndents] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [CabinId]
GO
ALTER TABLE [Pharmacy].[LotRecords] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Pharmacy].[LotRecords] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Pharmacy].[Manufacturers] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Pharmacy].[Manufacturers] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Pharmacy].[MedicineOutlets] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Pharmacy].[MedicineOutlets] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Pharmacy].[MedicineOutlets] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Pharmacy].[OutletIndentDetails] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Pharmacy].[OutletIndents] ADD  CONSTRAINT [DF__OutletInd__IsSyn__625B65AE]  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Pharmacy].[OutletIndents] ADD  CONSTRAINT [DF__OutletInd__Statu__2157A958]  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [Pharmacy].[OutletIndents] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Pharmacy].[OutletIndents] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ToOutletId]
GO
ALTER TABLE [Pharmacy].[OutletIndents] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [FromOutletId]
GO
ALTER TABLE [Pharmacy].[PackaingUnits] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Pharmacy].[PackaingUnits] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Pharmacy].[PharmacistDutyOutlets] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Pharmacy].[PharmacistDutyOutlets] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Pharmacy].[PharmacistDutyOutlets] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [OutletId]
GO
ALTER TABLE [Pharmacy].[PharmacistDutyOutlets] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Pharmacy].[PharmacyStockInfoesDateWiseHistories] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Pharmacy].[PharmacyStockInfoesDateWiseHistories] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [OutletId]
GO
ALTER TABLE [Pharmacy].[PharmacyStockInfoesDateWiseHistories] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [AutoId]
GO
ALTER TABLE [Pharmacy].[PIPDDueCollections] ADD  DEFAULT ((0)) FOR [TransactionType]
GO
ALTER TABLE [Pharmacy].[PLoyalMemberLedgers] ADD  DEFAULT ((0)) FOR [PaymentChannelId]
GO
ALTER TABLE [Pharmacy].[PLoyalMemberLedgers] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [PosTerminalId]
GO
ALTER TABLE [Pharmacy].[PLoyalMemberLedgers] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Pharmacy].[PLoyalMemberLedgers] ADD  DEFAULT ('') FOR [TransactionType]
GO
ALTER TABLE [Pharmacy].[PLoyalMembers] ADD  CONSTRAINT [DF_PLoyalMembers_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [Pharmacy].[PLoyalMembers] ADD  CONSTRAINT [DF_PLoyalMembers_IsSynced]  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Pharmacy].[PLoyalMembers] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Pharmacy].[PurchaseOrderDetails] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Pharmacy].[PurchaseOrders] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Pharmacy].[RceivePurchOrders] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Pharmacy].[ROLRecords] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Pharmacy].[ROLRecords] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [OutletId]
GO
ALTER TABLE [Pharmacy].[StockAuditDetails] ADD  DEFAULT ((0)) FOR [PhysicalStock]
GO
ALTER TABLE [Pharmacy].[StockAuditDetails] ADD  DEFAULT ('Pending') FOR [Status]
GO
ALTER TABLE [Pharmacy].[StockAuditDetails] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Pharmacy].[StockAuditDetails] ADD  DEFAULT ((0)) FOR [SoftwareStock]
GO
ALTER TABLE [Pharmacy].[StockAudits] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Pharmacy].[StockAudits] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [MedicineOutletId]
GO
ALTER TABLE [Pharmacy].[StockAudits] ADD  DEFAULT ('') FOR [Status]
GO
ALTER TABLE [Pharmacy].[StockReceiveDetails] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Pharmacy].[StockReceives] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [OutletId]
GO
ALTER TABLE [Pharmacy].[StockReceives] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [OutletIndentId]
GO
ALTER TABLE [Pharmacy].[StockTransfer] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Pharmacy].[StockTransfer] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Pharmacy].[StockTransfer] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [FromOutletId]
GO
ALTER TABLE [Pharmacy].[StockTransfer] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ToOutletId]
GO
ALTER TABLE [Pharmacy].[StockTransfer] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [OutletIndentId]
GO
ALTER TABLE [Pharmacy].[StockTransferDetails] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Pharmacy].[Strengths] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Pharmacy].[Strengths] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Pharmacy].[SupplierLedgers] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Pharmacy].[SupplierReturnIndentDetails] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Pharmacy].[SupplierReturnIndents] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [Pharmacy].[SupplierReturnIndents] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [FromOutletId]
GO
ALTER TABLE [Pharmacy].[SupplierReturnIndents] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ReceiveId]
GO
ALTER TABLE [Pharmacy].[Units] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Pharmacy].[Units] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Rx].[Advices] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Rx].[Advices] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Rx].[Advices] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Rx].[AdviceToPatients] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Rx].[ChiefComplains] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Rx].[ChiefComplains] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Rx].[ChiefComplains] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Rx].[Clinicalimpressions] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Rx].[Drugs] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Rx].[Drugs] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [DoseId]
GO
ALTER TABLE [Rx].[Drugs] ADD  DEFAULT ((0)) FOR [IsDoseBangla]
GO
ALTER TABLE [Rx].[Drugs] ADD  DEFAULT ('') FOR [ManualDrugName]
GO
ALTER TABLE [Rx].[Drugs] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [PrescriptionId]
GO
ALTER TABLE [Rx].[Drugs] ADD  DEFAULT ((0)) FOR [DisplayOrder]
GO
ALTER TABLE [Rx].[Durations] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Rx].[Durations] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Rx].[InitialDatas] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Rx].[InitialDatas] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [AssignedDoctorId]
GO
ALTER TABLE [Rx].[InitialDatas] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Rx].[InitialDatas] ADD  DEFAULT ('') FOR [SpecialAlert]
GO
ALTER TABLE [Rx].[InitialDatas] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [AppointmentId]
GO
ALTER TABLE [Rx].[InitialDatas] ADD  DEFAULT ('') FOR [BP]
GO
ALTER TABLE [Rx].[InitialDatas] ADD  DEFAULT ('') FOR [CoMorbidDeases]
GO
ALTER TABLE [Rx].[InitialDatas] ADD  DEFAULT ((0)) FOR [VitalNo]
GO
ALTER TABLE [Rx].[InitialDatas] ADD  DEFAULT ('') FOR [Procedure]
GO
ALTER TABLE [Rx].[InitialDatas] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [PrescriptionId]
GO
ALTER TABLE [Rx].[Investigations] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Rx].[Investigations] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Rx].[Investigations] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [PrescriptionId]
GO
ALTER TABLE [Rx].[Investigations] ADD  DEFAULT ('') FOR [Remarks]
GO
ALTER TABLE [Rx].[OPDProdureSuggessions] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ProcedureId]
GO
ALTER TABLE [Rx].[OPDProdureSuggessions] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Rx].[OPDProdureSuggessions] ADD  DEFAULT ((0)) FOR [Qty]
GO
ALTER TABLE [Rx].[OPDProdureSuggessions] ADD  DEFAULT ((0)) FOR [Rate]
GO
ALTER TABLE [Rx].[OPDProdureSuggessions] ADD  DEFAULT ('') FOR [Remarks]
GO
ALTER TABLE [Rx].[OPDProdureSuggessions] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [PrescriptionId]
GO
ALTER TABLE [Rx].[OtherFindings] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Rx].[OtherFindings] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Rx].[OtherFindings] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Rx].[PastHistories] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Rx].[PastHistories] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Rx].[PastHistories] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Rx].[PatientChiefComplains] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Rx].[PatientChiefComplains] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [AppointmentId]
GO
ALTER TABLE [Rx].[PatientChiefComplains] ADD  DEFAULT ('') FOR [ComplainManual]
GO
ALTER TABLE [Rx].[PatientClinicalimpressions] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Rx].[PatientMasterDatas] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Rx].[PatientMasterDatas] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Rx].[PatientRelevantHistoryPart1s] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Rx].[PatientRelevantHistoryPart2s] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Rx].[PresentHistories] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Rx].[PresentHistories] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [Rx].[PresentHistories] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Rx].[RelevantHistories] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Rx].[RxCPDosages] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Rx].[RxCPDosages] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [GenericId]
GO
ALTER TABLE [Rx].[RxCPDosages] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Rx].[RxGenericDosages] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Rx].[RxGenericDosages] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [GenericId]
GO
ALTER TABLE [Rx].[VisitHistories] ADD  DEFAULT ((0)) FOR [RxType]
GO
ALTER TABLE [Rx].[VisitHistories] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [Rx].[VisitHistories] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [Rx].[VisitHistories] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [AppointmentId]
GO
ALTER TABLE [Rx].[VisitHistories] ADD  DEFAULT ('') FOR [Notes]
GO
ALTER TABLE [Rx].[VisitHistories] ADD  DEFAULT ('') FOR [ReferPlan]
GO
ALTER TABLE [Rx].[VisitHistories] ADD  DEFAULT ('') FOR [ReleventHistory]
GO
ALTER TABLE [Rx].[VisitHistories] ADD  DEFAULT ((0)) FOR [Discount]
GO
ALTER TABLE [Rx].[VisitHistories] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [SonologistId]
GO
ALTER TABLE [SuperAdmin].[AccountConfigurations] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [SuperAdmin].[AccountConfigurations] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [SuperAdmin].[AppSettings] ADD  DEFAULT ((0)) FOR [DailyFoodBillInOthers]
GO
ALTER TABLE [SuperAdmin].[AppSettings] ADD  DEFAULT ((0)) FOR [DailyFoodBillInWard]
GO
ALTER TABLE [SuperAdmin].[AppSettings] ADD  DEFAULT (CONVERT([real],(0))) FOR [VisitingCardRate]
GO
ALTER TABLE [SuperAdmin].[AppSettings] ADD  DEFAULT (CONVERT([real],(0))) FOR [IPDServiceCharge]
GO
ALTER TABLE [SuperAdmin].[AppSettings] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsAutoInvestigationInvoiceAfterIndent]
GO
ALTER TABLE [SuperAdmin].[AppSettings] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsTubeAndNeedleWillbeAutoAdded]
GO
ALTER TABLE [SuperAdmin].[AppSettings] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [SuperAdmin].[AppSettings] ADD  DEFAULT ((0)) FOR [SampleDispatchDelayInMinute]
GO
ALTER TABLE [SuperAdmin].[AppSettings] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsAppointSerialAuto]
GO
ALTER TABLE [SuperAdmin].[AppSettings] ADD  DEFAULT (CONVERT([bit],(0))) FOR [WillTecnlogistSignatureAddOnReport]
GO
ALTER TABLE [SuperAdmin].[AppSettings] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsIntegratedAccountsEnabled]
GO
ALTER TABLE [SuperAdmin].[AppSettings] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [SuperAdmin].[AppSettings] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [SuperAdmin].[GLAndHospitalServiceSubGroupMappings] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ServiceSubGroupId]
GO
ALTER TABLE [SuperAdmin].[GLAndHospitalServiceSubGroupMappings] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [SuperAdmin].[GLAndPharmacyServiceMappings] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [SuperAdmin].[ParameterDashboard] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [SuperAdmin].[ReportAndSps] ADD  CONSTRAINT [DF_ReportAndSps_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [SuperAdmin].[ReportAndSps] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [SuperAdmin].[ReportAndSps] ADD  DEFAULT ((0)) FOR [ReportType]
GO
ALTER TABLE [SuperAdmin].[ReportAndSps] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsFinancialStatement]
GO
ALTER TABLE [SuperAdmin].[ReportPermissions] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [SuperAdmin].[ReportPermissions] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [SuperAdmin].[ReportPermissions] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [SupplyChain ].[BrandExtensions] ADD  DEFAULT (CONVERT([real],(0))) FOR [PurchasePrice]
GO
ALTER TABLE [SupplyChain ].[BrandExtensions] ADD  DEFAULT (CONVERT([real],(0))) FOR [SalePrice]
GO
ALTER TABLE [SupplyChain ].[BrandExtensions] ADD  DEFAULT ((0)) FOR [ROL]
GO
ALTER TABLE [SupplyChain ].[BrandExtensions] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsExpireDateRequired]
GO
ALTER TABLE [SupplyChain ].[BrandExtensions] ADD  DEFAULT ((0)) FOR [OpeningQty]
GO
ALTER TABLE [SupplyChain ].[BrandNames] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [SubCategoryId]
GO
ALTER TABLE [SupplyChain ].[BrandNames] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [SubGroupId]
GO
ALTER TABLE [SupplyChain ].[DeptStoreAcesses] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [DeptId]
GO
ALTER TABLE [SupplyChain ].[DeptStoreAcesses] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [StoreId]
GO
ALTER TABLE [SupplyChain ].[Groups] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [SupplyChain ].[IndentApprovals] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [NextApprovalLevelId]
GO
ALTER TABLE [SupplyChain ].[Issues] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [StoreId]
GO
ALTER TABLE [SupplyChain ].[Issues] ADD  CONSTRAINT [DF_Issues_DepartmentId]  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [DepartmentId]
GO
ALTER TABLE [SupplyChain ].[Issues] ADD  CONSTRAINT [DF_Issues_ReceivedBy]  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ReceivedBy]
GO
ALTER TABLE [SupplyChain ].[IssueStoreAcesses] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [StoreId]
GO
ALTER TABLE [SupplyChain ].[MainStores] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [SupplyChain ].[PRIndentDetails] ADD  DEFAULT ((0)) FOR [ApprovedQty]
GO
ALTER TABLE [SupplyChain ].[PRIndents] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [StoreId]
GO
ALTER TABLE [SupplyChain ].[PRSubmittedDetails] ADD  DEFAULT ((0)) FOR [PRIndentNo]
GO
ALTER TABLE [SupplyChain ].[PRSubmitteds] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [MainStoreId]
GO
ALTER TABLE [SupplyChain ].[PurchaseOrders] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [PRSubmittedId]
GO
ALTER TABLE [SupplyChain ].[PurchaseOrders] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [RequisitionId]
GO
ALTER TABLE [SupplyChain ].[PurchaseRequisiontions] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [StoreDeptId]
GO
ALTER TABLE [SupplyChain ].[PurchaseRequisiontions] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [StoreId]
GO
ALTER TABLE [SupplyChain ].[PurchaseRequisiontions] ADD  DEFAULT ('B9F427DC-7DB2-4FD3-200D-08DD9AA9C352') FOR [MainStoreId]
GO
ALTER TABLE [SupplyChain ].[PurchaseRequisiontions] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [PRSubmittedId]
GO
ALTER TABLE [SupplyChain ].[RequisitionApprovals] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [NextApprovalLevelId]
GO
ALTER TABLE [SupplyChain ].[SCMPurchaseApprovalSettings] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [StoreId]
GO
ALTER TABLE [SupplyChain ].[SCMPurchaseApprovalSettings] ADD  DEFAULT ('B9F427DC-7DB2-4FD3-200D-08DD9AA9C352') FOR [MainStoreId]
GO
ALTER TABLE [SupplyChain ].[SStockTransfer] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [SupplyChain ].[SStockTransfer] ADD  DEFAULT ((1)) FOR [TenantId]
GO
ALTER TABLE [SupplyChain ].[SStockTransfer] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [MainStoreId]
GO
ALTER TABLE [SupplyChain ].[SStockTransfer] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [SubStoreId]
GO
ALTER TABLE [SupplyChain ].[SStockTransfer] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [IndentId]
GO
ALTER TABLE [SupplyChain ].[SStockTransfer] ADD  DEFAULT ((1)) FOR [ServeTypeId]
GO
ALTER TABLE [SupplyChain ].[SStockTransferDetails] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [LotRecordId]
GO
ALTER TABLE [SupplyChain ].[SStockTransferDetails] ADD  DEFAULT ('1') FOR [TenantId]
GO
ALTER TABLE [SupplyChain ].[StockReceives] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [StoreId]
GO
ALTER TABLE [SupplyChain ].[StockReceives] ADD  DEFAULT ('B9F427DC-7DB2-4FD3-200D-08DD9AA9C352') FOR [MainStoreId]
GO
ALTER TABLE [SupplyChain ].[StoreDepts] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [SupplyChain ].[StoreIndentApprovalSettings] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [StoreId]
GO
ALTER TABLE [SupplyChain ].[StoreIndentDetails] ADD  DEFAULT ((0)) FOR [ApprovedQty]
GO
ALTER TABLE [SupplyChain ].[StoreIndents] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [StoreId]
GO
ALTER TABLE [SupplyChain ].[StoreIndents] ADD  DEFAULT ('Pending') FOR [IndentStatus]
GO
ALTER TABLE [SupplyChain ].[Stores] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [SupplyChain ].[Stores] ADD  DEFAULT (newid()) FOR [MainStoreId]
GO
ALTER TABLE [SupplyChain ].[SubGroups] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [GroupId]
GO
ALTER TABLE [SupplyChain ].[SubGroups] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [SupplyChain ].[Suppliers] ADD  CONSTRAINT [DF__Suppliers__Enlis__07047126]  DEFAULT ('0001-01-01T00:00:00.0000000') FOR [EnlistmentDate]
GO
ALTER TABLE [SupplyChain ].[Suppliers] ADD  CONSTRAINT [DF__Suppliers__Expir__07F8955F]  DEFAULT ('0001-01-01T00:00:00.0000000') FOR [ExpireDate]
GO
ALTER TABLE [SupplyChain ].[Suppliers] ADD  CONSTRAINT [DF__Suppliers__IsEnl__08ECB998]  DEFAULT (CONVERT([bit],(0))) FOR [IsEnlisted]
GO
ALTER TABLE [SupplyChain ].[Suppliers] ADD  CONSTRAINT [DF__Suppliers__VatIn__09E0DDD1]  DEFAULT (CONVERT([real],(0))) FOR [VatInPercent]
GO
ALTER TABLE [SupplyChain ].[Suppliers] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [ManufacturerId]
GO
ALTER TABLE [SupplyChain ].[Suppliers] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [TypeId]
GO
ALTER TABLE [SupplyChain ].[SupplierTypes] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsSynced]
GO
ALTER TABLE [SupplyChain ].[SupplierTypes] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [SupplyChain ].[XrayFilmTestMappings] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [BrandExtensionId]
GO
ALTER TABLE [SupplyChain ].[XrayFilmTestMappings] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [TestItemId]
GO
ALTER TABLE [TransfusionMedicine].[BCParameters] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [TransfusionMedicine].[BCParameters] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [BloodComponentId]
GO
ALTER TABLE [TransfusionMedicine].[BloodComponents] ADD  DEFAULT ((0)) FOR [Rate]
GO
ALTER TABLE [TransfusionMedicine].[BloodComponents] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [TransfusionMedicine].[CrossMatchingRecords] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [DoctorId]
GO
ALTER TABLE [TransfusionMedicine].[CrossMatchingRecords] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [TechnologistId]
GO
ALTER TABLE [TransfusionMedicine].[CrossMatchingRecords] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [BloodComponentId]
GO
ALTER TABLE [TransfusionMedicine].[CrossMatchingRecords] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [CrossMatchingResultId]
GO
ALTER TABLE [TransfusionMedicine].[CrossMatchingResults] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [Id]
GO
ALTER TABLE [TransfusionMedicine].[CrossMatchingValues] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [BCParameterId]
GO
ALTER TABLE [TransfusionMedicine].[SerologyRecords] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [BloodComponentId]
GO
ALTER TABLE [TransfusionMedicine].[SerologyResults] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [BCParameterId]
GO
ALTER TABLE [Account].[AttachedFileWithVouchers]  WITH CHECK ADD  CONSTRAINT [FK_AttachedFileWithVouchers_VoucherMasters_VoucherMasterId] FOREIGN KEY([VoucherMasterId])
REFERENCES [Account].[VoucherMasters] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Account].[AttachedFileWithVouchers] CHECK CONSTRAINT [FK_AttachedFileWithVouchers_VoucherMasters_VoucherMasterId]
GO
ALTER TABLE [Account].[CostCenters]  WITH CHECK ADD  CONSTRAINT [FK_CostCenters_Tenants_TenantId] FOREIGN KEY([TenantId])
REFERENCES [Admin].[Tenants] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Account].[CostCenters] CHECK CONSTRAINT [FK_CostCenters_Tenants_TenantId]
GO
ALTER TABLE [Account].[GeneralLedgers]  WITH CHECK ADD  CONSTRAINT [FK_GeneralLedgers_Level5Heads_Level5HeadId] FOREIGN KEY([Level5HeadId])
REFERENCES [Account].[Level5Heads] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Account].[GeneralLedgers] CHECK CONSTRAINT [FK_GeneralLedgers_Level5Heads_Level5HeadId]
GO
ALTER TABLE [Account].[GLMappingWithStatements]  WITH CHECK ADD  CONSTRAINT [FK_GLMappingWithStatements_GeneralLedgers_GeneralLedgerId] FOREIGN KEY([GeneralLedgerId])
REFERENCES [Account].[GeneralLedgers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Account].[GLMappingWithStatements] CHECK CONSTRAINT [FK_GLMappingWithStatements_GeneralLedgers_GeneralLedgerId]
GO
ALTER TABLE [Account].[HISandDiagMediaPaymentRecordDetails]  WITH CHECK ADD  CONSTRAINT [FK_HISandDiagMediaPaymentRecordDetails_HISandDiagMediaPaymentRecords_HISandDiagMediaPaymentRecordId] FOREIGN KEY([HISandDiagMediaPaymentRecordId])
REFERENCES [Account].[HISandDiagMediaPaymentRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Account].[HISandDiagMediaPaymentRecordDetails] CHECK CONSTRAINT [FK_HISandDiagMediaPaymentRecordDetails_HISandDiagMediaPaymentRecords_HISandDiagMediaPaymentRecordId]
GO
ALTER TABLE [Account].[IPDPatientGlobalLedgers]  WITH CHECK ADD  CONSTRAINT [FK_IPDPatientGlobalLedgers_IPDPatientRecords_IPDPatientId] FOREIGN KEY([IPDPatientId])
REFERENCES [Hospital].[IPDPatientRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Account].[IPDPatientGlobalLedgers] CHECK CONSTRAINT [FK_IPDPatientGlobalLedgers_IPDPatientRecords_IPDPatientId]
GO
ALTER TABLE [Account].[Level4Heads]  WITH CHECK ADD  CONSTRAINT [FK_Level4Heads_SubCategories_SubCategoryId] FOREIGN KEY([SubCategoryId])
REFERENCES [Account].[SubCategories] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Account].[Level4Heads] CHECK CONSTRAINT [FK_Level4Heads_SubCategories_SubCategoryId]
GO
ALTER TABLE [Account].[Level5Heads]  WITH CHECK ADD  CONSTRAINT [FK_Level5Heads_Level4Heads_Level4HeadId] FOREIGN KEY([Level4HeadId])
REFERENCES [Account].[Level4Heads] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Account].[Level5Heads] CHECK CONSTRAINT [FK_Level5Heads_Level4Heads_Level4HeadId]
GO
ALTER TABLE [Account].[LoyalMemberLedgers]  WITH CHECK ADD  CONSTRAINT [FK_LoyalMemberLedgers_LoyalMembers_LoyalMemberId] FOREIGN KEY([LoyalMemberId])
REFERENCES [Account].[LoyalMembers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Account].[LoyalMemberLedgers] CHECK CONSTRAINT [FK_LoyalMemberLedgers_LoyalMembers_LoyalMemberId]
GO
ALTER TABLE [Account].[POSTerminals]  WITH CHECK ADD  CONSTRAINT [FK_POSTerminals_Banks_BankAccountId] FOREIGN KEY([BankAccountId])
REFERENCES [Account].[Banks] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Account].[POSTerminals] CHECK CONSTRAINT [FK_POSTerminals_Banks_BankAccountId]
GO
ALTER TABLE [Account].[RadiologicalReportingFeePaymentRecordDetails]  WITH CHECK ADD  CONSTRAINT [FK_RadiologicalReportingFeePaymentRecordDetails_RadiologicalReportingFeePaymentRecords_RadiologicalReportingFeePaymentRecordId] FOREIGN KEY([RadiologicalReportingFeePaymentRecordId])
REFERENCES [Account].[RadiologicalReportingFeePaymentRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Account].[RadiologicalReportingFeePaymentRecordDetails] CHECK CONSTRAINT [FK_RadiologicalReportingFeePaymentRecordDetails_RadiologicalReportingFeePaymentRecords_RadiologicalReportingFeePaymentRecordId]
GO
ALTER TABLE [Account].[SubLedgers]  WITH CHECK ADD  CONSTRAINT [FK_SubLedgers_SubLedgerTypes_SubLedgerTypeId] FOREIGN KEY([SubLedgerTypeId])
REFERENCES [Account].[SubLedgerTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Account].[SubLedgers] CHECK CONSTRAINT [FK_SubLedgers_SubLedgerTypes_SubLedgerTypeId]
GO
ALTER TABLE [Account].[SupplierGlobalLedgers]  WITH CHECK ADD  CONSTRAINT [FK_SupplierGlobalLedgers_Suppliers_SupplierId] FOREIGN KEY([SupplierId])
REFERENCES [SupplyChain ].[Suppliers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Account].[SupplierGlobalLedgers] CHECK CONSTRAINT [FK_SupplierGlobalLedgers_Suppliers_SupplierId]
GO
ALTER TABLE [Account].[VoucherMasterDetails]  WITH CHECK ADD  CONSTRAINT [FK_VoucherMasterDetails_VoucherMasters_VoucherMasterId] FOREIGN KEY([VoucherMasterId])
REFERENCES [Account].[VoucherMasters] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Account].[VoucherMasterDetails] CHECK CONSTRAINT [FK_VoucherMasterDetails_VoucherMasters_VoucherMasterId]
GO
ALTER TABLE [Account].[VoucherMasters]  WITH CHECK ADD  CONSTRAINT [FK_VoucherMasters_FiscalYears_FYearId] FOREIGN KEY([FYearId])
REFERENCES [Account].[FiscalYears] ([Id])
GO
ALTER TABLE [Account].[VoucherMasters] CHECK CONSTRAINT [FK_VoucherMasters_FiscalYears_FYearId]
GO
ALTER TABLE [Account].[VoucherMasters]  WITH CHECK ADD  CONSTRAINT [FK_VoucherMasters_JournalTypes_JournalTypeId] FOREIGN KEY([JournalTypeId])
REFERENCES [Account].[JournalTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Account].[VoucherMasters] CHECK CONSTRAINT [FK_VoucherMasters_JournalTypes_JournalTypeId]
GO
ALTER TABLE [Admin].[DiscountCategories]  WITH CHECK ADD  CONSTRAINT [FK_DiscountCategories_Departments_DepartmentId] FOREIGN KEY([DepartmentId])
REFERENCES [Admin].[Departments] ([Id])
GO
ALTER TABLE [Admin].[DiscountCategories] CHECK CONSTRAINT [FK_DiscountCategories_Departments_DepartmentId]
GO
ALTER TABLE [Admin].[PaymentChannels]  WITH CHECK ADD  CONSTRAINT [FK_PaymentChannels_PaymentModes_PaymentModeId] FOREIGN KEY([PaymentModeId])
REFERENCES [Admin].[PaymentModes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Admin].[PaymentChannels] CHECK CONSTRAINT [FK_PaymentChannels_PaymentModes_PaymentModeId]
GO
ALTER TABLE [Admin].[ServiceUnits]  WITH CHECK ADD  CONSTRAINT [FK_ServiceUnits_Departments_DepartmentId] FOREIGN KEY([DepartmentId])
REFERENCES [Admin].[Departments] ([Id])
GO
ALTER TABLE [Admin].[ServiceUnits] CHECK CONSTRAINT [FK_ServiceUnits_Departments_DepartmentId]
GO
ALTER TABLE [Admin].[Tenants]  WITH CHECK ADD  CONSTRAINT [FK_Tenants_Districts_BranchId] FOREIGN KEY([BranchId])
REFERENCES [Location].[Districts] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Admin].[Tenants] CHECK CONSTRAINT [FK_Tenants_Districts_BranchId]
GO
ALTER TABLE [Admin].[UHIDUsesRecords]  WITH CHECK ADD  CONSTRAINT [FK_UHIDUsesRecords_ServiceUnits_ServiceUnitId] FOREIGN KEY([ServiceUnitId])
REFERENCES [Admin].[ServiceUnits] ([Id])
GO
ALTER TABLE [Admin].[UHIDUsesRecords] CHECK CONSTRAINT [FK_UHIDUsesRecords_ServiceUnits_ServiceUnitId]
GO
ALTER TABLE [Anonymous].[AnonymousUserVerifications]  WITH CHECK ADD  CONSTRAINT [FK_AnonymousUserVerifications_AnonymousUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [Anonymous].[AnonymousUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Anonymous].[AnonymousUserVerifications] CHECK CONSTRAINT [FK_AnonymousUserVerifications_AnonymousUsers_UserId]
GO
ALTER TABLE [Anonymous].[AnonymousUserVerifications]  WITH CHECK ADD  CONSTRAINT [FK_AnonymousUserVerifications_InvestigationInvoices_PatientId] FOREIGN KEY([PatientId])
REFERENCES [Diag].[InvestigationInvoices] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Anonymous].[AnonymousUserVerifications] CHECK CONSTRAINT [FK_AnonymousUserVerifications_InvestigationInvoices_PatientId]
GO
ALTER TABLE [Canteen].[CanteenStockTransferDetails]  WITH CHECK ADD  CONSTRAINT [FK_CanteenStockTransferDetails_CanteenStockTransfers_CanteenStockTransferId] FOREIGN KEY([CanteenStockTransferId])
REFERENCES [Canteen].[CanteenStockTransfers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Canteen].[CanteenStockTransferDetails] CHECK CONSTRAINT [FK_CanteenStockTransferDetails_CanteenStockTransfers_CanteenStockTransferId]
GO
ALTER TABLE [Canteen].[IPDFoodIndents]  WITH CHECK ADD  CONSTRAINT [FK_IPDFoodIndents_CanteenOutlets_CanteenOutLetId] FOREIGN KEY([CanteenOutLetId])
REFERENCES [Canteen].[CanteenOutlets] ([Id])
GO
ALTER TABLE [Canteen].[IPDFoodIndents] CHECK CONSTRAINT [FK_IPDFoodIndents_CanteenOutlets_CanteenOutLetId]
GO
ALTER TABLE [Canteen].[IPDFoodIndents]  WITH CHECK ADD  CONSTRAINT [FK_IPDFoodIndents_IPDPatientRecords_IPDPatientId] FOREIGN KEY([IPDPatientId])
REFERENCES [Hospital].[IPDPatientRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Canteen].[IPDFoodIndents] CHECK CONSTRAINT [FK_IPDFoodIndents_IPDPatientRecords_IPDPatientId]
GO
ALTER TABLE [Canteen].[Items]  WITH CHECK ADD  CONSTRAINT [FK_Items_Groups_GroupId] FOREIGN KEY([GroupId])
REFERENCES [Canteen].[Groups] ([Id])
GO
ALTER TABLE [Canteen].[Items] CHECK CONSTRAINT [FK_Items_Groups_GroupId]
GO
ALTER TABLE [Canteen].[RawItemIssueDetails]  WITH CHECK ADD  CONSTRAINT [FK_RawItemIssueDetails_RawItemIssues_RawItemIssueId] FOREIGN KEY([RawItemIssueId])
REFERENCES [Canteen].[RawItemIssues] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Canteen].[RawItemIssueDetails] CHECK CONSTRAINT [FK_RawItemIssueDetails_RawItemIssues_RawItemIssueId]
GO
ALTER TABLE [Canteen].[RawItemIssueDetails]  WITH CHECK ADD  CONSTRAINT [FK_RawItemIssueDetails_RawItems_RawItemId] FOREIGN KEY([RawItemId])
REFERENCES [Canteen].[RawItems] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Canteen].[RawItemIssueDetails] CHECK CONSTRAINT [FK_RawItemIssueDetails_RawItems_RawItemId]
GO
ALTER TABLE [Canteen].[RawItems]  WITH CHECK ADD  CONSTRAINT [FK_RawItems_Groups_GroupId] FOREIGN KEY([GroupId])
REFERENCES [Canteen].[Groups] ([Id])
GO
ALTER TABLE [Canteen].[RawItems] CHECK CONSTRAINT [FK_RawItems_Groups_GroupId]
GO
ALTER TABLE [Canteen].[RawItemStockReceiveDetails]  WITH CHECK ADD  CONSTRAINT [FK_RawItemStockReceiveDetails_RawItems_RawItemId] FOREIGN KEY([RawItemId])
REFERENCES [Canteen].[RawItems] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Canteen].[RawItemStockReceiveDetails] CHECK CONSTRAINT [FK_RawItemStockReceiveDetails_RawItems_RawItemId]
GO
ALTER TABLE [Canteen].[RawItemStockReceiveDetails]  WITH CHECK ADD  CONSTRAINT [FK_RawItemStockReceiveDetails_RawItemStockReceives_RawItemStockReceiveId] FOREIGN KEY([RawItemStockReceiveId])
REFERENCES [Canteen].[RawItemStockReceives] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Canteen].[RawItemStockReceiveDetails] CHECK CONSTRAINT [FK_RawItemStockReceiveDetails_RawItemStockReceives_RawItemStockReceiveId]
GO
ALTER TABLE [Canteen].[RawItemStockReceives]  WITH CHECK ADD  CONSTRAINT [FK_RawItemStockReceives_Suppliers_SupplierId] FOREIGN KEY([SupplierId])
REFERENCES [SupplyChain ].[Suppliers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Canteen].[RawItemStockReceives] CHECK CONSTRAINT [FK_RawItemStockReceives_Suppliers_SupplierId]
GO
ALTER TABLE [Canteen].[SaleInvoiceDetails]  WITH CHECK ADD  CONSTRAINT [FK_SaleInvoiceDetails_SaleInvoices_InvoiceId] FOREIGN KEY([InvoiceId])
REFERENCES [Canteen].[SaleInvoices] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Canteen].[SaleInvoiceDetails] CHECK CONSTRAINT [FK_SaleInvoiceDetails_SaleInvoices_InvoiceId]
GO
ALTER TABLE [Canteen].[SaleInvoices]  WITH CHECK ADD  CONSTRAINT [FK_SaleInvoices_CanteenOutlets_CanteenOutletId] FOREIGN KEY([CanteenOutLetId])
REFERENCES [Canteen].[CanteenOutlets] ([Id])
GO
ALTER TABLE [Canteen].[SaleInvoices] CHECK CONSTRAINT [FK_SaleInvoices_CanteenOutlets_CanteenOutletId]
GO
ALTER TABLE [Canteen].[SaleLedgers]  WITH CHECK ADD  CONSTRAINT [FK_SaleLedgers_SaleInvoices_InvoiceId] FOREIGN KEY([InvoiceId])
REFERENCES [Canteen].[SaleInvoices] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Canteen].[SaleLedgers] CHECK CONSTRAINT [FK_SaleLedgers_SaleInvoices_InvoiceId]
GO
ALTER TABLE [Canteen].[SalesmanDutyOutlets]  WITH CHECK ADD  CONSTRAINT [FK_SalesmanDutyOutlets_CanteenOutlets_CanteenOutletId] FOREIGN KEY([CanteenOutLetId])
REFERENCES [Canteen].[CanteenOutlets] ([Id])
GO
ALTER TABLE [Canteen].[SalesmanDutyOutlets] CHECK CONSTRAINT [FK_SalesmanDutyOutlets_CanteenOutlets_CanteenOutletId]
GO
ALTER TABLE [Canteen].[StockReceiveRecordDetails]  WITH CHECK ADD  CONSTRAINT [FK_StockReceiveRecordDetails_StockReceiveRecords_StockReceiveId] FOREIGN KEY([StockReceiveId])
REFERENCES [Canteen].[StockReceiveRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Canteen].[StockReceiveRecordDetails] CHECK CONSTRAINT [FK_StockReceiveRecordDetails_StockReceiveRecords_StockReceiveId]
GO
ALTER TABLE [Canteen].[StockReceiveRecords]  WITH CHECK ADD  CONSTRAINT [FK_StockReceiveRecords_CanteenOutlets_CanteenOutletId] FOREIGN KEY([CanteenOutLetId])
REFERENCES [Canteen].[CanteenOutlets] ([Id])
GO
ALTER TABLE [Canteen].[StockReceiveRecords] CHECK CONSTRAINT [FK_StockReceiveRecords_CanteenOutlets_CanteenOutletId]
GO
ALTER TABLE [Canteen].[StockReceiveRecords]  WITH CHECK ADD  CONSTRAINT [FK_StockReceiveRecords_Suppliers_SupplierId] FOREIGN KEY([SupplierId])
REFERENCES [SupplyChain ].[Suppliers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Canteen].[StockReceiveRecords] CHECK CONSTRAINT [FK_StockReceiveRecords_Suppliers_SupplierId]
GO
ALTER TABLE [dbo].[OpenIddictAuthorizations]  WITH CHECK ADD  CONSTRAINT [FK_OpenIddictAuthorizations_OpenIddictApplications_ApplicationId] FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[OpenIddictApplications] ([Id])
GO
ALTER TABLE [dbo].[OpenIddictAuthorizations] CHECK CONSTRAINT [FK_OpenIddictAuthorizations_OpenIddictApplications_ApplicationId]
GO
ALTER TABLE [dbo].[OpenIddictTokens]  WITH CHECK ADD  CONSTRAINT [FK_OpenIddictTokens_OpenIddictApplications_ApplicationId] FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[OpenIddictApplications] ([Id])
GO
ALTER TABLE [dbo].[OpenIddictTokens] CHECK CONSTRAINT [FK_OpenIddictTokens_OpenIddictApplications_ApplicationId]
GO
ALTER TABLE [dbo].[OpenIddictTokens]  WITH CHECK ADD  CONSTRAINT [FK_OpenIddictTokens_OpenIddictAuthorizations_AuthorizationId] FOREIGN KEY([AuthorizationId])
REFERENCES [dbo].[OpenIddictAuthorizations] ([Id])
GO
ALTER TABLE [dbo].[OpenIddictTokens] CHECK CONSTRAINT [FK_OpenIddictTokens_OpenIddictAuthorizations_AuthorizationId]
GO
ALTER TABLE [Diag].[AgeVariantNormalValues]  WITH CHECK ADD  CONSTRAINT [FK_AgeVariantNormalValues_ReportingAgeGroups_ReportingAgeGroupId] FOREIGN KEY([ReportingAgeGroupId])
REFERENCES [Diag].[ReportingAgeGroups] ([Id])
GO
ALTER TABLE [Diag].[AgeVariantNormalValues] CHECK CONSTRAINT [FK_AgeVariantNormalValues_ReportingAgeGroups_ReportingAgeGroupId]
GO
ALTER TABLE [Diag].[AgeVariantNormalValues]  WITH CHECK ADD  CONSTRAINT [FK_AgeVariantNormalValues_ReportParameters_ReportParameterId] FOREIGN KEY([ReportParameterId])
REFERENCES [Diag].[ReportParameters] ([Id])
GO
ALTER TABLE [Diag].[AgeVariantNormalValues] CHECK CONSTRAINT [FK_AgeVariantNormalValues_ReportParameters_ReportParameterId]
GO
ALTER TABLE [Diag].[ConsultantPaymentRecords]  WITH CHECK ADD  CONSTRAINT [FK_ConsultantPaymentRecords_Doctors_ConsultantId] FOREIGN KEY([ConsultantId])
REFERENCES [Marketing].[Doctors] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Diag].[ConsultantPaymentRecords] CHECK CONSTRAINT [FK_ConsultantPaymentRecords_Doctors_ConsultantId]
GO
ALTER TABLE [Diag].[DiscountGroupDetails]  WITH NOCHECK ADD  CONSTRAINT [FK_DiscountGroupDetails_DiscountGroups_DiscountGroupId] FOREIGN KEY([DiscountGroupId])
REFERENCES [Diag].[DiscountGroups] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Diag].[DiscountGroupDetails] CHECK CONSTRAINT [FK_DiscountGroupDetails_DiscountGroups_DiscountGroupId]
GO
ALTER TABLE [Diag].[DiscountGroupDetails]  WITH NOCHECK ADD  CONSTRAINT [FK_DiscountGroupDetails_TestItems_TestItemId] FOREIGN KEY([TestItemId])
REFERENCES [Diag].[TestItems] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Diag].[DiscountGroupDetails] CHECK CONSTRAINT [FK_DiscountGroupDetails_TestItems_TestItemId]
GO
ALTER TABLE [Diag].[InvestigationInvoiceDetails]  WITH NOCHECK ADD  CONSTRAINT [FK_InvestigationInvoiceDetails_InvestigationInvoices_InvestigationInvoiceId] FOREIGN KEY([InvestigationInvoiceId])
REFERENCES [Diag].[InvestigationInvoices] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Diag].[InvestigationInvoiceDetails] CHECK CONSTRAINT [FK_InvestigationInvoiceDetails_InvestigationInvoices_InvestigationInvoiceId]
GO
ALTER TABLE [Diag].[InvestigationInvoiceDetails]  WITH NOCHECK ADD  CONSTRAINT [FK_InvestigationInvoiceDetails_TestItems_TestItemId] FOREIGN KEY([TestItemId])
REFERENCES [Diag].[TestItems] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Diag].[InvestigationInvoiceDetails] CHECK CONSTRAINT [FK_InvestigationInvoiceDetails_TestItems_TestItemId]
GO
ALTER TABLE [Diag].[InvestigationInvoiceLedgers]  WITH NOCHECK ADD  CONSTRAINT [FK_InvestigationInvoiceLedgers_InvestigationInvoices_InvestigationInvoiceId] FOREIGN KEY([InvestigationInvoiceId])
REFERENCES [Diag].[InvestigationInvoices] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Diag].[InvestigationInvoiceLedgers] CHECK CONSTRAINT [FK_InvestigationInvoiceLedgers_InvestigationInvoices_InvestigationInvoiceId]
GO
ALTER TABLE [Diag].[InvestigationInvoices]  WITH NOCHECK ADD  CONSTRAINT [FK_InvestigationInvoices_Tenants_TenantId] FOREIGN KEY([TenantId])
REFERENCES [Admin].[Tenants] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Diag].[InvestigationInvoices] CHECK CONSTRAINT [FK_InvestigationInvoices_Tenants_TenantId]
GO
ALTER TABLE [Diag].[IPDDiagnosis]  WITH CHECK ADD  CONSTRAINT [FK_IPDDiagnosis_IPDPatientRecords_IPDPatientRecordId] FOREIGN KEY([IPDPatientRecordId])
REFERENCES [Hospital].[IPDPatientRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Diag].[IPDDiagnosis] CHECK CONSTRAINT [FK_IPDDiagnosis_IPDPatientRecords_IPDPatientRecordId]
GO
ALTER TABLE [Diag].[IPDDueCollections]  WITH CHECK ADD  CONSTRAINT [FK_IPDDueCollections_IPDPatientRecords_IPDPatientId] FOREIGN KEY([IPDPatientId])
REFERENCES [Hospital].[IPDPatientRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Diag].[IPDDueCollections] CHECK CONSTRAINT [FK_IPDDueCollections_IPDPatientRecords_IPDPatientId]
GO
ALTER TABLE [Diag].[IPDInvestigationIndentDetails]  WITH CHECK ADD  CONSTRAINT [FK_IPDInvestigationIndentDetails_IPDInvestigationIndents_IPDInvestigationIndentId] FOREIGN KEY([IPDInvestigationIndentId])
REFERENCES [Diag].[IPDInvestigationIndents] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Diag].[IPDInvestigationIndentDetails] CHECK CONSTRAINT [FK_IPDInvestigationIndentDetails_IPDInvestigationIndents_IPDInvestigationIndentId]
GO
ALTER TABLE [Diag].[IPDInvestigationIndents]  WITH CHECK ADD  CONSTRAINT [FK_IPDInvestigationIndents_IPDPatientRecords_IPDPatientId] FOREIGN KEY([IPDPatientId])
REFERENCES [Hospital].[IPDPatientRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Diag].[IPDInvestigationIndents] CHECK CONSTRAINT [FK_IPDInvestigationIndents_IPDPatientRecords_IPDPatientId]
GO
ALTER TABLE [Diag].[MediaPaymentRecords]  WITH CHECK ADD  CONSTRAINT [FK_MediaPaymentRecords_Medias_MediaId] FOREIGN KEY([MediaId])
REFERENCES [Marketing].[Medias] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Diag].[MediaPaymentRecords] CHECK CONSTRAINT [FK_MediaPaymentRecords_Medias_MediaId]
GO
ALTER TABLE [Diag].[Modalities]  WITH CHECK ADD  CONSTRAINT [FK_Modalities_TestGroups_TestGroupId] FOREIGN KEY([TestGroupId])
REFERENCES [Diag].[TestGroups] ([Id])
GO
ALTER TABLE [Diag].[Modalities] CHECK CONSTRAINT [FK_Modalities_TestGroups_TestGroupId]
GO
ALTER TABLE [Diag].[PathMachineOutputParameter]  WITH NOCHECK ADD  CONSTRAINT [FK_PathMachineOutputParameter_PathologicalMachines_PathologicalMachineId] FOREIGN KEY([PathologicalMachineId])
REFERENCES [Diag].[PathologicalMachines] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Diag].[PathMachineOutputParameter] CHECK CONSTRAINT [FK_PathMachineOutputParameter_PathologicalMachines_PathologicalMachineId]
GO
ALTER TABLE [Diag].[PathMachineOutputParameter]  WITH CHECK ADD  CONSTRAINT [FK_PathMachineOutputParameter_ReportParameters_ReportParameterId] FOREIGN KEY([ReportParameterId])
REFERENCES [Diag].[ReportParameters] ([Id])
GO
ALTER TABLE [Diag].[PathMachineOutputParameter] CHECK CONSTRAINT [FK_PathMachineOutputParameter_ReportParameters_ReportParameterId]
GO
ALTER TABLE [Diag].[PathologyReportDetails]  WITH NOCHECK ADD  CONSTRAINT [FK_PathologyReportDetails_PathologyReports_PathologyReportId] FOREIGN KEY([PathologyReportId])
REFERENCES [Diag].[PathologyReports] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Diag].[PathologyReportDetails] CHECK CONSTRAINT [FK_PathologyReportDetails_PathologyReports_PathologyReportId]
GO
ALTER TABLE [Diag].[PathologyReportPermissions]  WITH CHECK ADD  CONSTRAINT [FK_PathologyReportPermissions_Doctors_DoctorId] FOREIGN KEY([DoctorId])
REFERENCES [Marketing].[Doctors] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Diag].[PathologyReportPermissions] CHECK CONSTRAINT [FK_PathologyReportPermissions_Doctors_DoctorId]
GO
ALTER TABLE [Diag].[RadiologyTemplates]  WITH NOCHECK ADD  CONSTRAINT [FK_RadiologyTemplates_Doctors_DoctorId] FOREIGN KEY([DoctorId])
REFERENCES [Marketing].[Doctors] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Diag].[RadiologyTemplates] CHECK CONSTRAINT [FK_RadiologyTemplates_Doctors_DoctorId]
GO
ALTER TABLE [Diag].[ReportDeliveryTimingDetails]  WITH CHECK ADD  CONSTRAINT [FK_ReportDeliveryTimingDetails_ReportDeliveryTimingMasters_RDTMId] FOREIGN KEY([RDTMId])
REFERENCES [Diag].[ReportDeliveryTimingMasters] ([Id])
GO
ALTER TABLE [Diag].[ReportDeliveryTimingDetails] CHECK CONSTRAINT [FK_ReportDeliveryTimingDetails_ReportDeliveryTimingMasters_RDTMId]
GO
ALTER TABLE [Diag].[ReportParameters]  WITH NOCHECK ADD  CONSTRAINT [FK_ReportParameters_TestItems_TestItemId] FOREIGN KEY([TestItemId])
REFERENCES [Diag].[TestItems] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Diag].[ReportParameters] CHECK CONSTRAINT [FK_ReportParameters_TestItems_TestItemId]
GO
ALTER TABLE [Diag].[ReportParameterValues]  WITH CHECK ADD  CONSTRAINT [FK_ReportParameterValues_ReportParameters_ReportParameterId] FOREIGN KEY([ReportParameterId])
REFERENCES [Diag].[ReportParameters] ([Id])
GO
ALTER TABLE [Diag].[ReportParameterValues] CHECK CONSTRAINT [FK_ReportParameterValues_ReportParameters_ReportParameterId]
GO
ALTER TABLE [Diag].[SampleCarriers]  WITH NOCHECK ADD  CONSTRAINT [FK_SampleCarriers_StaffRecords_StaffRecordId] FOREIGN KEY([StaffRecordId])
REFERENCES [HR].[StaffRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Diag].[SampleCarriers] CHECK CONSTRAINT [FK_SampleCarriers_StaffRecords_StaffRecordId]
GO
ALTER TABLE [Diag].[SampleCollectionRecords]  WITH CHECK ADD  CONSTRAINT [FK_SampleCollectionRecords_TestSamples_TestSampleId] FOREIGN KEY([TestSampleId])
REFERENCES [Diag].[TestSamples] ([Id])
GO
ALTER TABLE [Diag].[SampleCollectionRecords] CHECK CONSTRAINT [FK_SampleCollectionRecords_TestSamples_TestSampleId]
GO
ALTER TABLE [Diag].[TestGroups]  WITH CHECK ADD  CONSTRAINT [FK_TestGroups_ParentGroup_ParentGroupId] FOREIGN KEY([ParentGroupId])
REFERENCES [Diag].[ParentGroup] ([Id])
GO
ALTER TABLE [Diag].[TestGroups] CHECK CONSTRAINT [FK_TestGroups_ParentGroup_ParentGroupId]
GO
ALTER TABLE [Diag].[TestGroupWiseReportingFees]  WITH CHECK ADD  CONSTRAINT [FK_TestGroupWiseReportingFees_Doctors_DoctorId] FOREIGN KEY([DoctorId])
REFERENCES [Marketing].[Doctors] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Diag].[TestGroupWiseReportingFees] CHECK CONSTRAINT [FK_TestGroupWiseReportingFees_Doctors_DoctorId]
GO
ALTER TABLE [Diag].[TestGroupWiseReportingFees]  WITH CHECK ADD  CONSTRAINT [FK_TestGroupWiseReportingFees_TestGroups_TestGroupId] FOREIGN KEY([TestGroupId])
REFERENCES [Diag].[TestGroups] ([Id])
GO
ALTER TABLE [Diag].[TestGroupWiseReportingFees] CHECK CONSTRAINT [FK_TestGroupWiseReportingFees_TestGroups_TestGroupId]
GO
ALTER TABLE [Diag].[TestItems]  WITH CHECK ADD  CONSTRAINT [FK_TestItems_TestGroups_TestGroupId] FOREIGN KEY([TestGroupId])
REFERENCES [Diag].[TestGroups] ([Id])
GO
ALTER TABLE [Diag].[TestItems] CHECK CONSTRAINT [FK_TestItems_TestGroups_TestGroupId]
GO
ALTER TABLE [Diag].[TestSamples]  WITH NOCHECK ADD  CONSTRAINT [FK_TestSamples_TestItems_TestItemId] FOREIGN KEY([TestItemId])
REFERENCES [Diag].[TestItems] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Diag].[TestSamples] CHECK CONSTRAINT [FK_TestSamples_TestItems_TestItemId]
GO
ALTER TABLE [Diag].[TestWiseReportingFees]  WITH CHECK ADD  CONSTRAINT [FK_TestWiseReportingFees_Doctors_DoctorId] FOREIGN KEY([DoctorId])
REFERENCES [Marketing].[Doctors] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Diag].[TestWiseReportingFees] CHECK CONSTRAINT [FK_TestWiseReportingFees_Doctors_DoctorId]
GO
ALTER TABLE [Diag].[TestWiseReportingFees]  WITH CHECK ADD  CONSTRAINT [FK_TestWiseReportingFees_TestItems_TestItemId] FOREIGN KEY([TestItemId])
REFERENCES [Diag].[TestItems] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Diag].[TestWiseReportingFees] CHECK CONSTRAINT [FK_TestWiseReportingFees_TestItems_TestItemId]
GO
ALTER TABLE [EMR].[AdviceTemplateDetails]  WITH CHECK ADD  CONSTRAINT [FK_AdviceTemplateDetails_AdviceTemplates_AdviceTemplateId] FOREIGN KEY([AdviceTemplateId])
REFERENCES [EMR].[AdviceTemplates] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [EMR].[AdviceTemplateDetails] CHECK CONSTRAINT [FK_AdviceTemplateDetails_AdviceTemplates_AdviceTemplateId]
GO
ALTER TABLE [EMR].[AdviceTemplates]  WITH CHECK ADD  CONSTRAINT [FK_AdviceTemplates_HDepartments_DeptId] FOREIGN KEY([DeptId])
REFERENCES [Hospital].[HDepartments] ([Id])
GO
ALTER TABLE [EMR].[AdviceTemplates] CHECK CONSTRAINT [FK_AdviceTemplates_HDepartments_DeptId]
GO
ALTER TABLE [EMR].[AppliedMedicationDoses]  WITH CHECK ADD  CONSTRAINT [FK_AppliedMedicationDoses_RxIpdTreatments_RxIpdTreatmentId] FOREIGN KEY([RxIpdTreatmentId])
REFERENCES [Hospital].[RxIpdTreatments] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [EMR].[AppliedMedicationDoses] CHECK CONSTRAINT [FK_AppliedMedicationDoses_RxIpdTreatments_RxIpdTreatmentId]
GO
ALTER TABLE [EMR].[BirthCertificates]  WITH CHECK ADD  CONSTRAINT [FK_BirthCertificates_IPDPatientRecords_IPDPatientId] FOREIGN KEY([IPDPatientId])
REFERENCES [Hospital].[IPDPatientRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [EMR].[BirthCertificates] CHECK CONSTRAINT [FK_BirthCertificates_IPDPatientRecords_IPDPatientId]
GO
ALTER TABLE [EMR].[BloodRequisitions]  WITH CHECK ADD  CONSTRAINT [FK_BloodRequisitions_IPDPatientRecords_IPDPatientRecordId] FOREIGN KEY([IPDPatientRecordId])
REFERENCES [Hospital].[IPDPatientRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [EMR].[BloodRequisitions] CHECK CONSTRAINT [FK_BloodRequisitions_IPDPatientRecords_IPDPatientRecordId]
GO
ALTER TABLE [EMR].[ConsultancyVisitNotes]  WITH CHECK ADD  CONSTRAINT [FK_ConsultancyVisitNotes_IPDPatientRecords_IPDPatientId] FOREIGN KEY([IPDPatientId])
REFERENCES [Hospital].[IPDPatientRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [EMR].[ConsultancyVisitNotes] CHECK CONSTRAINT [FK_ConsultancyVisitNotes_IPDPatientRecords_IPDPatientId]
GO
ALTER TABLE [EMR].[DeathRecordCommonDataGroupItems]  WITH CHECK ADD  CONSTRAINT [FK_DeathRecordCommonDataGroupItems_DeathRecordCommonDatas_DeathRecordCommonDataId] FOREIGN KEY([DeathRecordCommonDataId])
REFERENCES [EMR].[DeathRecordCommonDatas] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [EMR].[DeathRecordCommonDataGroupItems] CHECK CONSTRAINT [FK_DeathRecordCommonDataGroupItems_DeathRecordCommonDatas_DeathRecordCommonDataId]
GO
ALTER TABLE [EMR].[DeathRecordDetails]  WITH CHECK ADD  CONSTRAINT [FK_DeathRecordDetails_DeathRecords_DeathRecordId] FOREIGN KEY([DeathRecordId])
REFERENCES [EMR].[DeathRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [EMR].[DeathRecordDetails] CHECK CONSTRAINT [FK_DeathRecordDetails_DeathRecords_DeathRecordId]
GO
ALTER TABLE [EMR].[EMRAdvices]  WITH CHECK ADD  CONSTRAINT [FK_EMRAdvices_HDepartments_DeptId] FOREIGN KEY([DeptId])
REFERENCES [Hospital].[HDepartments] ([Id])
GO
ALTER TABLE [EMR].[EMRAdvices] CHECK CONSTRAINT [FK_EMRAdvices_HDepartments_DeptId]
GO
ALTER TABLE [EMR].[Holidays]  WITH CHECK ADD  CONSTRAINT [FK_Holidays_StaffRecords_StaffRecordId] FOREIGN KEY([StaffRecordId])
REFERENCES [HR].[StaffRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [EMR].[Holidays] CHECK CONSTRAINT [FK_Holidays_StaffRecords_StaffRecordId]
GO
ALTER TABLE [EMR].[ICUCourses]  WITH CHECK ADD  CONSTRAINT [FK_ICUCourses_IPDPatientRecords_IPDPatientId] FOREIGN KEY([IPDPatientId])
REFERENCES [Hospital].[IPDPatientRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [EMR].[ICUCourses] CHECK CONSTRAINT [FK_ICUCourses_IPDPatientRecords_IPDPatientId]
GO
ALTER TABLE [EMR].[OTTemplates]  WITH CHECK ADD  CONSTRAINT [FK_OTTemplates_HDepartments_DepartmentId] FOREIGN KEY([DepartmentId])
REFERENCES [Hospital].[HDepartments] ([Id])
GO
ALTER TABLE [EMR].[OTTemplates] CHECK CONSTRAINT [FK_OTTemplates_HDepartments_DepartmentId]
GO
ALTER TABLE [EMR].[OTTemplates]  WITH CHECK ADD  CONSTRAINT [FK_OTTemplates_OTTemplateGroups_OTTemplateGroupId] FOREIGN KEY([OTTemplateGroupId])
REFERENCES [EMR].[OTTemplateGroups] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [EMR].[OTTemplates] CHECK CONSTRAINT [FK_OTTemplates_OTTemplateGroups_OTTemplateGroupId]
GO
ALTER TABLE [EMR].[ProcedureNotes]  WITH CHECK ADD  CONSTRAINT [FK_ProcedureNotes_IPDPatientRecords_IPDPatientId] FOREIGN KEY([IPDPatientId])
REFERENCES [Hospital].[IPDPatientRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [EMR].[ProcedureNotes] CHECK CONSTRAINT [FK_ProcedureNotes_IPDPatientRecords_IPDPatientId]
GO
ALTER TABLE [EMR].[SuggestedInvestigations]  WITH CHECK ADD  CONSTRAINT [FK_SuggestedInvestigations_TestItems_TestItemId] FOREIGN KEY([TestItemId])
REFERENCES [Diag].[TestItems] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [EMR].[SuggestedInvestigations] CHECK CONSTRAINT [FK_SuggestedInvestigations_TestItems_TestItemId]
GO
ALTER TABLE [EMR].[TreatmentDoseTimingDetails]  WITH CHECK ADD  CONSTRAINT [FK_TreatmentDoseTimingDetails_TreatmentDoseTimings_TreatmentDoseTimingId] FOREIGN KEY([TreatmentDoseTimingId])
REFERENCES [EMR].[TreatmentDoseTimings] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [EMR].[TreatmentDoseTimingDetails] CHECK CONSTRAINT [FK_TreatmentDoseTimingDetails_TreatmentDoseTimings_TreatmentDoseTimingId]
GO
ALTER TABLE [EMR].[TreatmentDoseTimings]  WITH CHECK ADD  CONSTRAINT [FK_TreatmentDoseTimings_RxIpdTreatments_RxIpdTreatmentId] FOREIGN KEY([RxIpdTreatmentId])
REFERENCES [Hospital].[RxIpdTreatments] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [EMR].[TreatmentDoseTimings] CHECK CONSTRAINT [FK_TreatmentDoseTimings_RxIpdTreatments_RxIpdTreatmentId]
GO
ALTER TABLE [EMR].[TreatmentOrderArchiveDetails]  WITH CHECK ADD  CONSTRAINT [FK_TreatmentOrderArchiveDetails_TreatmentOrderArchives_OrderArchiveId] FOREIGN KEY([OrderArchiveId])
REFERENCES [EMR].[TreatmentOrderArchives] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [EMR].[TreatmentOrderArchiveDetails] CHECK CONSTRAINT [FK_TreatmentOrderArchiveDetails_TreatmentOrderArchives_OrderArchiveId]
GO
ALTER TABLE [EMR].[TreatmentOrderArchives]  WITH CHECK ADD  CONSTRAINT [FK_TreatmentOrderArchives_IPDPatientRecords_IPDPatientId] FOREIGN KEY([IPDPatientId])
REFERENCES [Hospital].[IPDPatientRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [EMR].[TreatmentOrderArchives] CHECK CONSTRAINT [FK_TreatmentOrderArchives_IPDPatientRecords_IPDPatientId]
GO
ALTER TABLE [HangFire].[JobParameter]  WITH CHECK ADD  CONSTRAINT [FK_HangFire_JobParameter_Job] FOREIGN KEY([JobId])
REFERENCES [HangFire].[Job] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [HangFire].[JobParameter] CHECK CONSTRAINT [FK_HangFire_JobParameter_Job]
GO
ALTER TABLE [HangFire].[State]  WITH CHECK ADD  CONSTRAINT [FK_HangFire_State_Job] FOREIGN KEY([JobId])
REFERENCES [HangFire].[Job] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [HangFire].[State] CHECK CONSTRAINT [FK_HangFire_State_Job]
GO
ALTER TABLE [Hospital].[AdvancePaymentDetails]  WITH CHECK ADD  CONSTRAINT [FK_AdvancePaymentDetails_AdvancePayments_AdvancePaymentId] FOREIGN KEY([AdvancePaymentId])
REFERENCES [Hospital].[AdvancePayments] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[AdvancePaymentDetails] CHECK CONSTRAINT [FK_AdvancePaymentDetails_AdvancePayments_AdvancePaymentId]
GO
ALTER TABLE [Hospital].[AdvancePayments]  WITH CHECK ADD  CONSTRAINT [FK_AdvancePayments_IPDPatientRecords_IPDPatientId] FOREIGN KEY([IPDPatientId])
REFERENCES [Hospital].[IPDPatientRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[AdvancePayments] CHECK CONSTRAINT [FK_AdvancePayments_IPDPatientRecords_IPDPatientId]
GO
ALTER TABLE [Hospital].[AdvicesByDepts]  WITH CHECK ADD  CONSTRAINT [FK_AdvicesByDepts_Doctors_AdviceByDoctorId] FOREIGN KEY([AdviceByDoctorId])
REFERENCES [Marketing].[Doctors] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[AdvicesByDepts] CHECK CONSTRAINT [FK_AdvicesByDepts_Doctors_AdviceByDoctorId]
GO
ALTER TABLE [Hospital].[AssignedDoctorRecords]  WITH CHECK ADD  CONSTRAINT [FK_AssignedDoctorRecords_IPDPatientRecords_IPDPatientRecordId] FOREIGN KEY([IPDPatientRecordId])
REFERENCES [Hospital].[IPDPatientRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[AssignedDoctorRecords] CHECK CONSTRAINT [FK_AssignedDoctorRecords_IPDPatientRecords_IPDPatientRecordId]
GO
ALTER TABLE [Hospital].[BabyNotes]  WITH CHECK ADD  CONSTRAINT [FK_BabyNotes_IPDPatientRecords_IPDPatientRecordId] FOREIGN KEY([IPDPatientRecordId])
REFERENCES [Hospital].[IPDPatientRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[BabyNotes] CHECK CONSTRAINT [FK_BabyNotes_IPDPatientRecords_IPDPatientRecordId]
GO
ALTER TABLE [Hospital].[BedRentPackages]  WITH CHECK ADD  CONSTRAINT [FK_BedRentPackages_ServicePackages_ServicePackageId] FOREIGN KEY([ServicePackageId])
REFERENCES [Hospital].[ServicePackages] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[BedRentPackages] CHECK CONSTRAINT [FK_BedRentPackages_ServicePackages_ServicePackageId]
GO
ALTER TABLE [Hospital].[CabinDiscounts]  WITH CHECK ADD  CONSTRAINT [FK_CabinDiscounts_Cabins_CabinId] FOREIGN KEY([CabinId])
REFERENCES [Hospital].[Cabins] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[CabinDiscounts] CHECK CONSTRAINT [FK_CabinDiscounts_Cabins_CabinId]
GO
ALTER TABLE [Hospital].[Cabins]  WITH CHECK ADD  CONSTRAINT [FK_Cabins_CabinTypes_CabinTypeId] FOREIGN KEY([CabinTypeId])
REFERENCES [Hospital].[CabinTypes] ([Id])
GO
ALTER TABLE [Hospital].[Cabins] CHECK CONSTRAINT [FK_Cabins_CabinTypes_CabinTypeId]
GO
ALTER TABLE [Hospital].[Cabins]  WITH CHECK ADD  CONSTRAINT [FK_Cabins_Floors_FloorId] FOREIGN KEY([FloorId])
REFERENCES [Hospital].[Floors] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[Cabins] CHECK CONSTRAINT [FK_Cabins_Floors_FloorId]
GO
ALTER TABLE [Hospital].[Cabins]  WITH CHECK ADD  CONSTRAINT [FK_Cabins_HDepartments_HDepartmentId] FOREIGN KEY([HDepartmentId])
REFERENCES [Hospital].[HDepartments] ([Id])
GO
ALTER TABLE [Hospital].[Cabins] CHECK CONSTRAINT [FK_Cabins_HDepartments_HDepartmentId]
GO
ALTER TABLE [Hospital].[ConfinementNotes]  WITH CHECK ADD  CONSTRAINT [FK_ConfinementNotes_IPDPatientRecords_IPDPatientRecordId] FOREIGN KEY([IPDPatientRecordId])
REFERENCES [Hospital].[IPDPatientRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[ConfinementNotes] CHECK CONSTRAINT [FK_ConfinementNotes_IPDPatientRecords_IPDPatientRecordId]
GO
ALTER TABLE [Hospital].[ConsultancyPackages]  WITH CHECK ADD  CONSTRAINT [FK_ConsultancyPackages_ServicePackages_ServicePackageId] FOREIGN KEY([ServicePackageId])
REFERENCES [Hospital].[ServicePackages] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[ConsultancyPackages] CHECK CONSTRAINT [FK_ConsultancyPackages_ServicePackages_ServicePackageId]
GO
ALTER TABLE [Hospital].[DaywiseFoodBillCharges]  WITH CHECK ADD  CONSTRAINT [FK_DaywiseFoodBillCharges_Cabins_CabinId] FOREIGN KEY([CabinId])
REFERENCES [Hospital].[Cabins] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[DaywiseFoodBillCharges] CHECK CONSTRAINT [FK_DaywiseFoodBillCharges_Cabins_CabinId]
GO
ALTER TABLE [Hospital].[DiscargeAdvices]  WITH CHECK ADD  CONSTRAINT [FK_DiscargeAdvices_HDepartments_DeptId] FOREIGN KEY([DeptId])
REFERENCES [Hospital].[HDepartments] ([Id])
GO
ALTER TABLE [Hospital].[DiscargeAdvices] CHECK CONSTRAINT [FK_DiscargeAdvices_HDepartments_DeptId]
GO
ALTER TABLE [Hospital].[DischargeCertificate]  WITH CHECK ADD  CONSTRAINT [FK_DischargeCertificate_IPDPatientRecords_IPDPatientId] FOREIGN KEY([IPDPatientId])
REFERENCES [Hospital].[IPDPatientRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[DischargeCertificate] CHECK CONSTRAINT [FK_DischargeCertificate_IPDPatientRecords_IPDPatientId]
GO
ALTER TABLE [Hospital].[DischargeTemplates]  WITH CHECK ADD  CONSTRAINT [FK_DischargeTemplates_Tenants_TenantId] FOREIGN KEY([TenantId])
REFERENCES [Admin].[Tenants] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[DischargeTemplates] CHECK CONSTRAINT [FK_DischargeTemplates_Tenants_TenantId]
GO
ALTER TABLE [Hospital].[DynamicInputControlValues]  WITH CHECK ADD  CONSTRAINT [FK_DynamicInputControlValues_DynamicInputControls_ControlTypeID] FOREIGN KEY([ControltypeId])
REFERENCES [Hospital].[DynamicInputControls] ([Id])
GO
ALTER TABLE [Hospital].[DynamicInputControlValues] CHECK CONSTRAINT [FK_DynamicInputControlValues_DynamicInputControls_ControlTypeID]
GO
ALTER TABLE [Hospital].[DynamicTemplateDetails]  WITH CHECK ADD  CONSTRAINT [FK_DynamicTemplateDetails_DynamicInputControls_ControltypeId] FOREIGN KEY([ControltypeId])
REFERENCES [Hospital].[DynamicInputControls] ([Id])
GO
ALTER TABLE [Hospital].[DynamicTemplateDetails] CHECK CONSTRAINT [FK_DynamicTemplateDetails_DynamicInputControls_ControltypeId]
GO
ALTER TABLE [Hospital].[DynamicTemplateDetails]  WITH CHECK ADD  CONSTRAINT [FK_DynamicTemplateDetails_DynamicTemplates_ControlFormID] FOREIGN KEY([ControlFormID])
REFERENCES [Hospital].[DynamicTemplates] ([Id])
GO
ALTER TABLE [Hospital].[DynamicTemplateDetails] CHECK CONSTRAINT [FK_DynamicTemplateDetails_DynamicTemplates_ControlFormID]
GO
ALTER TABLE [Hospital].[DynamicTemplates]  WITH CHECK ADD  CONSTRAINT [FK_DynamicTemplates_DynamicFormCategories_DynamicFormCategoryId] FOREIGN KEY([DynamicFormCategoryId])
REFERENCES [Hospital].[DynamicFormCategories] ([Id])
GO
ALTER TABLE [Hospital].[DynamicTemplates] CHECK CONSTRAINT [FK_DynamicTemplates_DynamicFormCategories_DynamicFormCategoryId]
GO
ALTER TABLE [Hospital].[DynamicTemplates]  WITH CHECK ADD  CONSTRAINT [FK_DynamicTemplates_HDepartments_DepartmentId] FOREIGN KEY([DepartmentId])
REFERENCES [Hospital].[HDepartments] ([Id])
GO
ALTER TABLE [Hospital].[DynamicTemplates] CHECK CONSTRAINT [FK_DynamicTemplates_HDepartments_DepartmentId]
GO
ALTER TABLE [Hospital].[FinalBillLedgers]  WITH CHECK ADD  CONSTRAINT [FK_FinalBillLedgers_FinalBills_FinalBillId] FOREIGN KEY([FinalBillId])
REFERENCES [Hospital].[FinalBills] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[FinalBillLedgers] CHECK CONSTRAINT [FK_FinalBillLedgers_FinalBills_FinalBillId]
GO
ALTER TABLE [Hospital].[FinalBillSummarys]  WITH CHECK ADD  CONSTRAINT [FK_FinalBillSummarys_FinalBills_FinalBillId] FOREIGN KEY([FinalBillId])
REFERENCES [Hospital].[FinalBills] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[FinalBillSummarys] CHECK CONSTRAINT [FK_FinalBillSummarys_FinalBills_FinalBillId]
GO
ALTER TABLE [Hospital].[Floors]  WITH CHECK ADD  CONSTRAINT [FK_Floors_Tenants_TenantId] FOREIGN KEY([TenantId])
REFERENCES [Admin].[Tenants] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[Floors] CHECK CONSTRAINT [FK_Floors_Tenants_TenantId]
GO
ALTER TABLE [Hospital].[FollowUpDataDetails]  WITH CHECK ADD  CONSTRAINT [FK_FollowUpDataDetails_FollowUpDatas_MasterId] FOREIGN KEY([MasterId])
REFERENCES [Hospital].[FollowUpDatas] ([Id])
GO
ALTER TABLE [Hospital].[FollowUpDataDetails] CHECK CONSTRAINT [FK_FollowUpDataDetails_FollowUpDatas_MasterId]
GO
ALTER TABLE [Hospital].[FollowUpDatas]  WITH CHECK ADD  CONSTRAINT [FK_FollowUpDatas_DynamicTemplates_DynamicFormId] FOREIGN KEY([DynamicFormId])
REFERENCES [Hospital].[DynamicTemplates] ([Id])
GO
ALTER TABLE [Hospital].[FollowUpDatas] CHECK CONSTRAINT [FK_FollowUpDatas_DynamicTemplates_DynamicFormId]
GO
ALTER TABLE [Hospital].[FollowUpSheetSchedules]  WITH CHECK ADD  CONSTRAINT [FK_FollowUpSheetSchedules_Tenants_TenantId] FOREIGN KEY([TenantId])
REFERENCES [Admin].[Tenants] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[FollowUpSheetSchedules] CHECK CONSTRAINT [FK_FollowUpSheetSchedules_Tenants_TenantId]
GO
ALTER TABLE [Hospital].[IPDCabinAllocationRecords]  WITH CHECK ADD  CONSTRAINT [FK_IPDCabinAllocationRecords_Cabins_CabinId] FOREIGN KEY([CabinId])
REFERENCES [Hospital].[Cabins] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[IPDCabinAllocationRecords] CHECK CONSTRAINT [FK_IPDCabinAllocationRecords_Cabins_CabinId]
GO
ALTER TABLE [Hospital].[IPDConsultantServices]  WITH CHECK ADD  CONSTRAINT [FK_IPDConsultantServices_Doctors_ConsultantId] FOREIGN KEY([ConsultantId])
REFERENCES [Marketing].[Doctors] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[IPDConsultantServices] CHECK CONSTRAINT [FK_IPDConsultantServices_Doctors_ConsultantId]
GO
ALTER TABLE [Hospital].[IPDConsultantServices]  WITH CHECK ADD  CONSTRAINT [FK_IPDConsultantServices_ServiceExecutingHeads_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [Hospital].[ServiceExecutingHeads] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[IPDConsultantServices] CHECK CONSTRAINT [FK_IPDConsultantServices_ServiceExecutingHeads_ServiceId]
GO
ALTER TABLE [Hospital].[IPDIndentForwardAndPatientAccesses]  WITH CHECK ADD  CONSTRAINT [FK_IPDIndentForwardAndPatientAccesses_MedicineOutlets_IndentForwardToOutlet] FOREIGN KEY([IndentForwardToOutlet])
REFERENCES [Pharmacy].[MedicineOutlets] ([Id])
GO
ALTER TABLE [Hospital].[IPDIndentForwardAndPatientAccesses] CHECK CONSTRAINT [FK_IPDIndentForwardAndPatientAccesses_MedicineOutlets_IndentForwardToOutlet]
GO
ALTER TABLE [Hospital].[IPDIndentForwardAndPatientAccesses]  WITH CHECK ADD  CONSTRAINT [FK_IPDIndentForwardAndPatientAccesses_Tenants_TenantId] FOREIGN KEY([TenantId])
REFERENCES [Admin].[Tenants] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[IPDIndentForwardAndPatientAccesses] CHECK CONSTRAINT [FK_IPDIndentForwardAndPatientAccesses_Tenants_TenantId]
GO
ALTER TABLE [Hospital].[IPDNonMedicationOrders]  WITH CHECK ADD  CONSTRAINT [FK_IPDNonMedicationOrders_NonMedicationOrders_NonMedicationOrderId] FOREIGN KEY([NonMedicationOrderId])
REFERENCES [Hospital].[NonMedicationOrders] ([Id])
GO
ALTER TABLE [Hospital].[IPDNonMedicationOrders] CHECK CONSTRAINT [FK_IPDNonMedicationOrders_NonMedicationOrders_NonMedicationOrderId]
GO
ALTER TABLE [Hospital].[IPDPatientRecords]  WITH CHECK ADD  CONSTRAINT [FK_IPDPatientRecords_Doctors_AssignedDoctorId] FOREIGN KEY([AssignedDoctorId])
REFERENCES [Marketing].[Doctors] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[IPDPatientRecords] CHECK CONSTRAINT [FK_IPDPatientRecords_Doctors_AssignedDoctorId]
GO
ALTER TABLE [Hospital].[IPDPatientRecords]  WITH CHECK ADD  CONSTRAINT [FK_IPDPatientRecords_HDepartments_DeptId] FOREIGN KEY([DeptId])
REFERENCES [Hospital].[HDepartments] ([Id])
GO
ALTER TABLE [Hospital].[IPDPatientRecords] CHECK CONSTRAINT [FK_IPDPatientRecords_HDepartments_DeptId]
GO
ALTER TABLE [Hospital].[IPDPatientRecords]  WITH CHECK ADD  CONSTRAINT [FK_IPDPatientRecords_Tenants_TenantId] FOREIGN KEY([TenantId])
REFERENCES [Admin].[Tenants] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[IPDPatientRecords] CHECK CONSTRAINT [FK_IPDPatientRecords_Tenants_TenantId]
GO
ALTER TABLE [Hospital].[IPDServiceRecords]  WITH CHECK ADD  CONSTRAINT [FK_IPDServiceRecords_IPDPatientRecords_IPDPatientId] FOREIGN KEY([IPDPatientId])
REFERENCES [Hospital].[IPDPatientRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[IPDServiceRecords] CHECK CONSTRAINT [FK_IPDServiceRecords_IPDPatientRecords_IPDPatientId]
GO
ALTER TABLE [Hospital].[IPDServiceRecords]  WITH CHECK ADD  CONSTRAINT [FK_IPDServiceRecords_ServiceExecutingHeads_ServiceId] FOREIGN KEY([ServiceId])
REFERENCES [Hospital].[ServiceExecutingHeads] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[IPDServiceRecords] CHECK CONSTRAINT [FK_IPDServiceRecords_ServiceExecutingHeads_ServiceId]
GO
ALTER TABLE [Hospital].[ManualCabinDays]  WITH CHECK ADD  CONSTRAINT [FK_ManualCabinDays_Cabins_CabinId] FOREIGN KEY([CabinId])
REFERENCES [Hospital].[Cabins] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[ManualCabinDays] CHECK CONSTRAINT [FK_ManualCabinDays_Cabins_CabinId]
GO
ALTER TABLE [Hospital].[MedicineReturnIndentDetails]  WITH CHECK ADD  CONSTRAINT [FK_MedicineReturnIndentDetails_BrandExtensions_BrandExtensionId] FOREIGN KEY([BrandExtensionId])
REFERENCES [Pharmacy].[BrandExtensions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[MedicineReturnIndentDetails] CHECK CONSTRAINT [FK_MedicineReturnIndentDetails_BrandExtensions_BrandExtensionId]
GO
ALTER TABLE [Hospital].[MedicineReturnIndentDetails]  WITH CHECK ADD  CONSTRAINT [FK_MedicineReturnIndentDetails_LotRecords_LotRecordId] FOREIGN KEY([LotRecordId])
REFERENCES [Pharmacy].[LotRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[MedicineReturnIndentDetails] CHECK CONSTRAINT [FK_MedicineReturnIndentDetails_LotRecords_LotRecordId]
GO
ALTER TABLE [Hospital].[MedicineReturnIndentDetails]  WITH CHECK ADD  CONSTRAINT [FK_MedicineReturnIndentDetails_MedicineReturnIndents_MedicineRetirnIndentId] FOREIGN KEY([MedicineRetirnIndentId])
REFERENCES [Hospital].[MedicineReturnIndents] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[MedicineReturnIndentDetails] CHECK CONSTRAINT [FK_MedicineReturnIndentDetails_MedicineReturnIndents_MedicineRetirnIndentId]
GO
ALTER TABLE [Hospital].[MedicineReturnIndents]  WITH CHECK ADD  CONSTRAINT [FK_MedicineReturnIndents_IPDPatientRecords_IPDPatientId] FOREIGN KEY([IPDPatientId])
REFERENCES [Hospital].[IPDPatientRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[MedicineReturnIndents] CHECK CONSTRAINT [FK_MedicineReturnIndents_IPDPatientRecords_IPDPatientId]
GO
ALTER TABLE [Hospital].[MedicineReturnIndents]  WITH CHECK ADD  CONSTRAINT [FK_MedicineReturnIndents_MedicineOutlets_IndentToOutletId] FOREIGN KEY([IndentToOutletId])
REFERENCES [Pharmacy].[MedicineOutlets] ([Id])
GO
ALTER TABLE [Hospital].[MedicineReturnIndents] CHECK CONSTRAINT [FK_MedicineReturnIndents_MedicineOutlets_IndentToOutletId]
GO
ALTER TABLE [Hospital].[OTInfoNurseStationDetails]  WITH CHECK ADD  CONSTRAINT [FK_OTInfoNurseStationDetails_OTInfoNurseStations_OTInfoNurseStationId] FOREIGN KEY([OTInfoNurseStationId])
REFERENCES [Hospital].[OTInfoNurseStations] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[OTInfoNurseStationDetails] CHECK CONSTRAINT [FK_OTInfoNurseStationDetails_OTInfoNurseStations_OTInfoNurseStationId]
GO
ALTER TABLE [Hospital].[OTInfoNurseStationDetails]  WITH CHECK ADD  CONSTRAINT [FK_OTInfoNurseStationDetails_ServiceExecutingHeads_ServiceHeadId] FOREIGN KEY([ServiceHeadId])
REFERENCES [Hospital].[ServiceExecutingHeads] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[OTInfoNurseStationDetails] CHECK CONSTRAINT [FK_OTInfoNurseStationDetails_ServiceExecutingHeads_ServiceHeadId]
GO
ALTER TABLE [Hospital].[OTInfoNurseStations]  WITH CHECK ADD  CONSTRAINT [FK_OTInfoNurseStations_AnaesthesiaTypes_AnaesthesiaTypeId] FOREIGN KEY([AnaesthesiaTypeId])
REFERENCES [Hospital].[AnaesthesiaTypes] ([Id])
GO
ALTER TABLE [Hospital].[OTInfoNurseStations] CHECK CONSTRAINT [FK_OTInfoNurseStations_AnaesthesiaTypes_AnaesthesiaTypeId]
GO
ALTER TABLE [Hospital].[OTInfoNurseStations]  WITH CHECK ADD  CONSTRAINT [FK_OTInfoNurseStations_Doctors_ChiefSurgeonId] FOREIGN KEY([ChiefSurgeonId])
REFERENCES [Marketing].[Doctors] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[OTInfoNurseStations] CHECK CONSTRAINT [FK_OTInfoNurseStations_Doctors_ChiefSurgeonId]
GO
ALTER TABLE [Hospital].[OTInfoNurseStations]  WITH CHECK ADD  CONSTRAINT [FK_OTInfoNurseStations_OTNames_OTNameId] FOREIGN KEY([OTNameId ])
REFERENCES [Hospital].[OTNames] ([Id])
GO
ALTER TABLE [Hospital].[OTInfoNurseStations] CHECK CONSTRAINT [FK_OTInfoNurseStations_OTNames_OTNameId]
GO
ALTER TABLE [Hospital].[OTNotes]  WITH CHECK ADD  CONSTRAINT [FK_OTNotes_IPDPatientRecords_IPDPatientRecordId] FOREIGN KEY([IPDPatientRecordId])
REFERENCES [Hospital].[IPDPatientRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[OTNotes] CHECK CONSTRAINT [FK_OTNotes_IPDPatientRecords_IPDPatientRecordId]
GO
ALTER TABLE [Hospital].[OTRoomBookingRequests]  WITH CHECK ADD  CONSTRAINT [FK_OTRoomBookingRequests_OTRoom_RequestForOTRoomId] FOREIGN KEY([RequestForOTRoomId])
REFERENCES [Hospital].[OTRoom] ([Id])
GO
ALTER TABLE [Hospital].[OTRoomBookingRequests] CHECK CONSTRAINT [FK_OTRoomBookingRequests_OTRoom_RequestForOTRoomId]
GO
ALTER TABLE [Hospital].[OTRoomBooks]  WITH CHECK ADD  CONSTRAINT [FK_OTRoomBooks_OTRoomBookingRequests_BookingRequestId] FOREIGN KEY([BookingRequestId])
REFERENCES [Hospital].[OTRoomBookingRequests] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[OTRoomBooks] CHECK CONSTRAINT [FK_OTRoomBooks_OTRoomBookingRequests_BookingRequestId]
GO
ALTER TABLE [Hospital].[OTServiceDetails]  WITH CHECK ADD  CONSTRAINT [FK_OTServiceDetails_OTServices_OTServiceId] FOREIGN KEY([OTServiceId])
REFERENCES [Hospital].[OTServices] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[OTServiceDetails] CHECK CONSTRAINT [FK_OTServiceDetails_OTServices_OTServiceId]
GO
ALTER TABLE [Hospital].[OTServiceDetails]  WITH CHECK ADD  CONSTRAINT [FK_OTServiceDetails_ServiceExecutingHeads_ServiceHeadId] FOREIGN KEY([ServiceHeadId])
REFERENCES [Hospital].[ServiceExecutingHeads] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[OTServiceDetails] CHECK CONSTRAINT [FK_OTServiceDetails_ServiceExecutingHeads_ServiceHeadId]
GO
ALTER TABLE [Hospital].[PackageInvestigations]  WITH CHECK ADD  CONSTRAINT [FK_PackageInvestigations_ServicePackages_ServicePackageId] FOREIGN KEY([ServicePackageId])
REFERENCES [Hospital].[ServicePackages] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[PackageInvestigations] CHECK CONSTRAINT [FK_PackageInvestigations_ServicePackages_ServicePackageId]
GO
ALTER TABLE [Hospital].[PackageIPDServices]  WITH CHECK ADD  CONSTRAINT [FK_PackageIPDServices_ServicePackages_ServicePackageId] FOREIGN KEY([ServicePackageId])
REFERENCES [Hospital].[ServicePackages] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[PackageIPDServices] CHECK CONSTRAINT [FK_PackageIPDServices_ServicePackages_ServicePackageId]
GO
ALTER TABLE [Hospital].[PackageMedicines]  WITH CHECK ADD  CONSTRAINT [FK_PackageMedicines_ServicePackages_ServicePackageId] FOREIGN KEY([ServicePackageId])
REFERENCES [Hospital].[ServicePackages] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[PackageMedicines] CHECK CONSTRAINT [FK_PackageMedicines_ServicePackages_ServicePackageId]
GO
ALTER TABLE [Hospital].[PatientDynamicFormDataDetails]  WITH CHECK ADD  CONSTRAINT [FK_PatientDynamicFormDataDetails_PatientDynamicFormDatas_MasterId] FOREIGN KEY([MasterId])
REFERENCES [Hospital].[PatientDynamicFormDatas] ([Id])
GO
ALTER TABLE [Hospital].[PatientDynamicFormDataDetails] CHECK CONSTRAINT [FK_PatientDynamicFormDataDetails_PatientDynamicFormDatas_MasterId]
GO
ALTER TABLE [Hospital].[PostDischargeFollowups]  WITH CHECK ADD  CONSTRAINT [FK_PostDischargeFollowups_Doctors_ConsultantId] FOREIGN KEY([ConsultantId])
REFERENCES [Marketing].[Doctors] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[PostDischargeFollowups] CHECK CONSTRAINT [FK_PostDischargeFollowups_Doctors_ConsultantId]
GO
ALTER TABLE [Hospital].[PostOperativeNotes]  WITH CHECK ADD  CONSTRAINT [FK_PostOperativeNotes_IPDPatientRecords_IPDPatientRecordId] FOREIGN KEY([IPDPatientRecordId])
REFERENCES [Hospital].[IPDPatientRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[PostOperativeNotes] CHECK CONSTRAINT [FK_PostOperativeNotes_IPDPatientRecords_IPDPatientRecordId]
GO
ALTER TABLE [Hospital].[PreoperativeNotes]  WITH CHECK ADD  CONSTRAINT [FK_PreoperativeNotes_IPDPatientRecords_IPDPatientRecordId] FOREIGN KEY([IPDPatientRecordId])
REFERENCES [Hospital].[IPDPatientRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[PreoperativeNotes] CHECK CONSTRAINT [FK_PreoperativeNotes_IPDPatientRecords_IPDPatientRecordId]
GO
ALTER TABLE [Hospital].[SaveConsultancyPaymentRecordDetails]  WITH CHECK ADD  CONSTRAINT [FK_SaveConsultancyPaymentRecordDetails_SaveConsultancyPaymentRecords_RecordId] FOREIGN KEY([RecordId])
REFERENCES [Hospital].[SaveConsultancyPaymentRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[SaveConsultancyPaymentRecordDetails] CHECK CONSTRAINT [FK_SaveConsultancyPaymentRecordDetails_SaveConsultancyPaymentRecords_RecordId]
GO
ALTER TABLE [Hospital].[ServiceExecutingHeadRates]  WITH CHECK ADD  CONSTRAINT [FK_ServiceExecutingHeadRates_ServiceExecutingHeads_ServiceExecutingHeadId] FOREIGN KEY([ServiceExecutingHeadId])
REFERENCES [Hospital].[ServiceExecutingHeads] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[ServiceExecutingHeadRates] CHECK CONSTRAINT [FK_ServiceExecutingHeadRates_ServiceExecutingHeads_ServiceExecutingHeadId]
GO
ALTER TABLE [Hospital].[ServiceExecutingHeadRates]  WITH CHECK ADD  CONSTRAINT [FK_ServiceExecutingHeadRates_Tenants_TenantId] FOREIGN KEY([TenantId])
REFERENCES [Admin].[Tenants] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[ServiceExecutingHeadRates] CHECK CONSTRAINT [FK_ServiceExecutingHeadRates_Tenants_TenantId]
GO
ALTER TABLE [Hospital].[ServiceExecutingHeads]  WITH CHECK ADD  CONSTRAINT [FK_ServiceExecutingHeads_ServiceSubSubGroups_ServiceSubSubGroupId] FOREIGN KEY([ServiceSubSubGroupId])
REFERENCES [Hospital].[ServiceSubSubGroups] ([Id])
GO
ALTER TABLE [Hospital].[ServiceExecutingHeads] CHECK CONSTRAINT [FK_ServiceExecutingHeads_ServiceSubSubGroups_ServiceSubSubGroupId]
GO
ALTER TABLE [Hospital].[ServicePackages]  WITH CHECK ADD  CONSTRAINT [FK_ServicePackages_Tenants_TenantId] FOREIGN KEY([TenantId])
REFERENCES [Admin].[Tenants] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[ServicePackages] CHECK CONSTRAINT [FK_ServicePackages_Tenants_TenantId]
GO
ALTER TABLE [Hospital].[ServiceSubGroups]  WITH CHECK ADD  CONSTRAINT [FK_ServiceSubGroups_ServiceGroups_ServiceGroupId] FOREIGN KEY([ServiceGroupId])
REFERENCES [Hospital].[ServiceGroups] ([Id])
GO
ALTER TABLE [Hospital].[ServiceSubGroups] CHECK CONSTRAINT [FK_ServiceSubGroups_ServiceGroups_ServiceGroupId]
GO
ALTER TABLE [Hospital].[ServiceSubSubGroups]  WITH CHECK ADD  CONSTRAINT [FK_ServiceSubSubGroups_ServiceSubGroups_ServiceSubGroupId] FOREIGN KEY([ServiceSubGroupId])
REFERENCES [Hospital].[ServiceSubGroups] ([Id])
GO
ALTER TABLE [Hospital].[ServiceSubSubGroups] CHECK CONSTRAINT [FK_ServiceSubSubGroups_ServiceSubGroups_ServiceSubGroupId]
GO
ALTER TABLE [Hospital].[SurgeryProcedures]  WITH CHECK ADD  CONSTRAINT [FK_SurgeryProcedures_Tenants_TenantId] FOREIGN KEY([TenantId])
REFERENCES [Admin].[Tenants] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[SurgeryProcedures] CHECK CONSTRAINT [FK_SurgeryProcedures_Tenants_TenantId]
GO
ALTER TABLE [Hospital].[TransferNotes]  WITH CHECK ADD  CONSTRAINT [FK_TransferNotes_IPDPatientRecords_IPDPatientRecordId] FOREIGN KEY([IPDPatientRecordId])
REFERENCES [Hospital].[IPDPatientRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Hospital].[TransferNotes] CHECK CONSTRAINT [FK_TransferNotes_IPDPatientRecords_IPDPatientRecordId]
GO
ALTER TABLE [Hospital].[VitalSignRecordDetails]  WITH CHECK ADD  CONSTRAINT [FK_VitalSignRecordDetails_VitalSignRecords_MasterId] FOREIGN KEY([MasterId])
REFERENCES [Hospital].[VitalSignRecords] ([Id])
GO
ALTER TABLE [Hospital].[VitalSignRecordDetails] CHECK CONSTRAINT [FK_VitalSignRecordDetails_VitalSignRecords_MasterId]
GO
ALTER TABLE [Hospital].[VitalSignRecords]  WITH CHECK ADD  CONSTRAINT [FK_VitalSignRecords_DynamicTemplates_DynamicFormId] FOREIGN KEY([DynamicFormId])
REFERENCES [Hospital].[DynamicTemplates] ([Id])
GO
ALTER TABLE [Hospital].[VitalSignRecords] CHECK CONSTRAINT [FK_VitalSignRecords_DynamicTemplates_DynamicFormId]
GO
ALTER TABLE [HR].[ApplicationPermissions]  WITH CHECK ADD  CONSTRAINT [FK_ApplicationPermissions_StaffRecords_StaffRecordId] FOREIGN KEY([StaffRecordId])
REFERENCES [HR].[StaffRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [HR].[ApplicationPermissions] CHECK CONSTRAINT [FK_ApplicationPermissions_StaffRecords_StaffRecordId]
GO
ALTER TABLE [HR].[AttachedDocs]  WITH CHECK ADD  CONSTRAINT [FK_AttachedDocs_StaffRecords_StaffRecordId] FOREIGN KEY([StaffRecordId])
REFERENCES [HR].[StaffRecords] ([Id])
GO
ALTER TABLE [HR].[AttachedDocs] CHECK CONSTRAINT [FK_AttachedDocs_StaffRecords_StaffRecordId]
GO
ALTER TABLE [HR].[Departments]  WITH CHECK ADD  CONSTRAINT [FK_Departments_Divisions_DivId] FOREIGN KEY([DivId])
REFERENCES [HR].[Divisions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [HR].[Departments] CHECK CONSTRAINT [FK_Departments_Divisions_DivId]
GO
ALTER TABLE [HR].[DeptIncharges]  WITH CHECK ADD  CONSTRAINT [FK_DeptIncharges_Departments_DeptId] FOREIGN KEY([DeptId])
REFERENCES [HR].[Departments] ([Id])
GO
ALTER TABLE [HR].[DeptIncharges] CHECK CONSTRAINT [FK_DeptIncharges_Departments_DeptId]
GO
ALTER TABLE [HR].[DutyExchangeRecords]  WITH CHECK ADD  CONSTRAINT [FK_DutyExchangeRecords_StaffRecords_StaffId] FOREIGN KEY([StaffId])
REFERENCES [HR].[StaffRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [HR].[DutyExchangeRecords] CHECK CONSTRAINT [FK_DutyExchangeRecords_StaffRecords_StaffId]
GO
ALTER TABLE [HR].[DutyRoasterCalender]  WITH CHECK ADD  CONSTRAINT [FK_DutyRoasterCalender_Departments_DepartmentId] FOREIGN KEY([DepartmentId])
REFERENCES [HR].[Departments] ([Id])
GO
ALTER TABLE [HR].[DutyRoasterCalender] CHECK CONSTRAINT [FK_DutyRoasterCalender_Departments_DepartmentId]
GO
ALTER TABLE [HR].[DutyRoasterCalenderDetail]  WITH CHECK ADD  CONSTRAINT [FK_DutyRoasterCalenderDetail_DutyRoasterCalender_DutyRoasterCalenderId] FOREIGN KEY([DutyRoasterCalenderId])
REFERENCES [HR].[DutyRoasterCalender] ([Id])
GO
ALTER TABLE [HR].[DutyRoasterCalenderDetail] CHECK CONSTRAINT [FK_DutyRoasterCalenderDetail_DutyRoasterCalender_DutyRoasterCalenderId]
GO
ALTER TABLE [HR].[DutyRoasterCalenderDetail]  WITH CHECK ADD  CONSTRAINT [FK_DutyRoasterCalenderDetail_RoasterType_ShifTypeid] FOREIGN KEY([ShifTypeid])
REFERENCES [HR].[RoasterType] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [HR].[DutyRoasterCalenderDetail] CHECK CONSTRAINT [FK_DutyRoasterCalenderDetail_RoasterType_ShifTypeid]
GO
ALTER TABLE [HR].[DutyRoasterSettings]  WITH CHECK ADD  CONSTRAINT [FK_DutyRoasterSettings_Departments_DeptId] FOREIGN KEY([DeptId])
REFERENCES [HR].[Departments] ([Id])
GO
ALTER TABLE [HR].[DutyRoasterSettings] CHECK CONSTRAINT [FK_DutyRoasterSettings_Departments_DeptId]
GO
ALTER TABLE [HR].[DutyRoasterSettings]  WITH CHECK ADD  CONSTRAINT [FK_DutyRoasterSettings_Designations_DesignationId] FOREIGN KEY([DesignationId])
REFERENCES [HR].[Designations] ([Id])
GO
ALTER TABLE [HR].[DutyRoasterSettings] CHECK CONSTRAINT [FK_DutyRoasterSettings_Designations_DesignationId]
GO
ALTER TABLE [HR].[EducationalQualifications]  WITH CHECK ADD  CONSTRAINT [FK_EducationalQualifications_StaffRecords_StaffRecordId] FOREIGN KEY([StaffRecordId])
REFERENCES [HR].[StaffRecords] ([Id])
GO
ALTER TABLE [HR].[EducationalQualifications] CHECK CONSTRAINT [FK_EducationalQualifications_StaffRecords_StaffRecordId]
GO
ALTER TABLE [HR].[EmergencyContacts]  WITH CHECK ADD  CONSTRAINT [FK_EmergencyContacts_StaffRecords_StaffRecordId] FOREIGN KEY([StaffRecordId])
REFERENCES [HR].[StaffRecords] ([Id])
GO
ALTER TABLE [HR].[EmergencyContacts] CHECK CONSTRAINT [FK_EmergencyContacts_StaffRecords_StaffRecordId]
GO
ALTER TABLE [HR].[IndividualEmployeeLeaveEligibles]  WITH CHECK ADD  CONSTRAINT [FK_IndividualEmployeeLeaveEligibles_IndividualEmployeeLeavePolices_IndividualEmployeeLeavePolicyId] FOREIGN KEY([IndividualEmployeeLeavePolicyId])
REFERENCES [HR].[IndividualEmployeeLeavePolices] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [HR].[IndividualEmployeeLeaveEligibles] CHECK CONSTRAINT [FK_IndividualEmployeeLeaveEligibles_IndividualEmployeeLeavePolices_IndividualEmployeeLeavePolicyId]
GO
ALTER TABLE [HR].[IndividualEmployeeLeavePolices]  WITH CHECK ADD  CONSTRAINT [FK_IndividualEmployeeLeavePolices_StaffRecords_StaffRecordId] FOREIGN KEY([StaffRecordId])
REFERENCES [HR].[StaffRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [HR].[IndividualEmployeeLeavePolices] CHECK CONSTRAINT [FK_IndividualEmployeeLeavePolices_StaffRecords_StaffRecordId]
GO
ALTER TABLE [HR].[JobCvs]  WITH CHECK ADD  CONSTRAINT [FK_JobCvs_JobCirculations_Jcid] FOREIGN KEY([Jcid])
REFERENCES [HR].[JobCirculations] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [HR].[JobCvs] CHECK CONSTRAINT [FK_JobCvs_JobCirculations_Jcid]
GO
ALTER TABLE [HR].[LeaveApprovalSettings]  WITH CHECK ADD  CONSTRAINT [FK_LeaveApprovalSettings_Departments_DeptId] FOREIGN KEY([DeptId])
REFERENCES [HR].[Departments] ([Id])
GO
ALTER TABLE [HR].[LeaveApprovalSettings] CHECK CONSTRAINT [FK_LeaveApprovalSettings_Departments_DeptId]
GO
ALTER TABLE [HR].[LeaveApproveOnDifferentLevels]  WITH CHECK ADD  CONSTRAINT [FK_LeaveApproveOnDifferentLevels_LeaveApplications_LeaveApplicationsId] FOREIGN KEY([LeaveApplicationsId])
REFERENCES [HR].[LeaveApplications] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [HR].[LeaveApproveOnDifferentLevels] CHECK CONSTRAINT [FK_LeaveApproveOnDifferentLevels_LeaveApplications_LeaveApplicationsId]
GO
ALTER TABLE [HR].[MaternityLeaveRecords]  WITH CHECK ADD  CONSTRAINT [FK_MaternityLeaveRecords_StaffRecords_StaffId] FOREIGN KEY([StaffId])
REFERENCES [HR].[StaffRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [HR].[MaternityLeaveRecords] CHECK CONSTRAINT [FK_MaternityLeaveRecords_StaffRecords_StaffId]
GO
ALTER TABLE [HR].[OverManageDutyRecords]  WITH CHECK ADD  CONSTRAINT [FK_OverManageDutyRecords_StaffRecords_StaffId] FOREIGN KEY([StaffId])
REFERENCES [HR].[StaffRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [HR].[OverManageDutyRecords] CHECK CONSTRAINT [FK_OverManageDutyRecords_StaffRecords_StaffId]
GO
ALTER TABLE [HR].[StaffFestivalMappings]  WITH CHECK ADD  CONSTRAINT [FK_StaffFestivalMappings_Festivals_Festivald] FOREIGN KEY([Festivald])
REFERENCES [HR].[Festivals] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [HR].[StaffFestivalMappings] CHECK CONSTRAINT [FK_StaffFestivalMappings_Festivals_Festivald]
GO
ALTER TABLE [HR].[StaffRecords]  WITH CHECK ADD  CONSTRAINT [FK_StaffRecords_Departments_DeptId] FOREIGN KEY([DeptId])
REFERENCES [HR].[Departments] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [HR].[StaffRecords] CHECK CONSTRAINT [FK_StaffRecords_Departments_DeptId]
GO
ALTER TABLE [HR].[StaffRecords]  WITH CHECK ADD  CONSTRAINT [FK_StaffRecords_Designations_DesignationId] FOREIGN KEY([DesignationId])
REFERENCES [HR].[Designations] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [HR].[StaffRecords] CHECK CONSTRAINT [FK_StaffRecords_Designations_DesignationId]
GO
ALTER TABLE [HR].[StaffRecords]  WITH CHECK ADD  CONSTRAINT [FK_StaffRecords_Divisions_DivisionId] FOREIGN KEY([DivisionId])
REFERENCES [HR].[Divisions] ([Id])
GO
ALTER TABLE [HR].[StaffRecords] CHECK CONSTRAINT [FK_StaffRecords_Divisions_DivisionId]
GO
ALTER TABLE [HR].[StaffRecords]  WITH CHECK ADD  CONSTRAINT [FK_StaffRecords_SubDepartments_SubDeptId] FOREIGN KEY([SubDeptId])
REFERENCES [HR].[SubDepartments] ([Id])
GO
ALTER TABLE [HR].[StaffRecords] CHECK CONSTRAINT [FK_StaffRecords_SubDepartments_SubDeptId]
GO
ALTER TABLE [HR].[SubDepartments]  WITH CHECK ADD  CONSTRAINT [FK_SubDepartments_Departments_DeptId] FOREIGN KEY([DeptId])
REFERENCES [HR].[Departments] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [HR].[SubDepartments] CHECK CONSTRAINT [FK_SubDepartments_Departments_DeptId]
GO
ALTER TABLE [Identity].[RoleClaims]  WITH CHECK ADD  CONSTRAINT [FK_RoleClaims_Roles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [Identity].[Roles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Identity].[RoleClaims] CHECK CONSTRAINT [FK_RoleClaims_Roles_RoleId]
GO
ALTER TABLE [Identity].[UserClaims]  WITH CHECK ADD  CONSTRAINT [FK_UserClaims_Users_UserId] FOREIGN KEY([UserId])
REFERENCES [Identity].[Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Identity].[UserClaims] CHECK CONSTRAINT [FK_UserClaims_Users_UserId]
GO
ALTER TABLE [Identity].[UserLogins]  WITH CHECK ADD  CONSTRAINT [FK_UserLogins_Users_UserId] FOREIGN KEY([UserId])
REFERENCES [Identity].[Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Identity].[UserLogins] CHECK CONSTRAINT [FK_UserLogins_Users_UserId]
GO
ALTER TABLE [Identity].[UserRoles]  WITH CHECK ADD  CONSTRAINT [FK_UserRoles_Roles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [Identity].[Roles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Identity].[UserRoles] CHECK CONSTRAINT [FK_UserRoles_Roles_RoleId]
GO
ALTER TABLE [Identity].[UserRoles]  WITH CHECK ADD  CONSTRAINT [FK_UserRoles_Users_UserId] FOREIGN KEY([UserId])
REFERENCES [Identity].[Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Identity].[UserRoles] CHECK CONSTRAINT [FK_UserRoles_Users_UserId]
GO
ALTER TABLE [Identity].[UserTokens]  WITH CHECK ADD  CONSTRAINT [FK_UserTokens_Users_UserId] FOREIGN KEY([UserId])
REFERENCES [Identity].[Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Identity].[UserTokens] CHECK CONSTRAINT [FK_UserTokens_Users_UserId]
GO
ALTER TABLE [ITAXTDS].[IncomeTaxAndTDS]  WITH CHECK ADD  CONSTRAINT [FK_IncomeTaxAndTDS_IncomeTaxActAndTDSRules_IncomeTaxActAndTDSRuleId] FOREIGN KEY([IncomeTaxActAndTDSRuleId])
REFERENCES [ITAXTDS].[IncomeTaxActAndTDSRules] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [ITAXTDS].[IncomeTaxAndTDS] CHECK CONSTRAINT [FK_IncomeTaxAndTDS_IncomeTaxActAndTDSRules_IncomeTaxActAndTDSRuleId]
GO
ALTER TABLE [Marketing].[CommissionSetups]  WITH CHECK ADD  CONSTRAINT [FK_CommissionSetups_CommissionGroups_CommissionGroupId] FOREIGN KEY([CommissionGroupId])
REFERENCES [Marketing].[CommissionGroups] ([Id])
GO
ALTER TABLE [Marketing].[CommissionSetups] CHECK CONSTRAINT [FK_CommissionSetups_CommissionGroups_CommissionGroupId]
GO
ALTER TABLE [Marketing].[CommissionSetups]  WITH CHECK ADD  CONSTRAINT [FK_CommissionSetups_TestItems_TestItemId] FOREIGN KEY([TestItemId])
REFERENCES [Diag].[TestItems] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Marketing].[CommissionSetups] CHECK CONSTRAINT [FK_CommissionSetups_TestItems_TestItemId]
GO
ALTER TABLE [Marketing].[Doctors]  WITH CHECK ADD  CONSTRAINT [FK_Doctors_MarketingJOfficerOrMedias_MarketingJOfficerOrMediaId] FOREIGN KEY([MarketingJOfficerOrMediaId])
REFERENCES [Marketing].[MarketingJOfficerOrMedias] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Marketing].[Doctors] CHECK CONSTRAINT [FK_Doctors_MarketingJOfficerOrMedias_MarketingJOfficerOrMediaId]
GO
ALTER TABLE [Marketing].[GrossSalesTargets]  WITH CHECK ADD  CONSTRAINT [FK_GrossSalesTargets_Tenants_TenantId] FOREIGN KEY([TenantId])
REFERENCES [Admin].[Tenants] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Marketing].[GrossSalesTargets] CHECK CONSTRAINT [FK_GrossSalesTargets_Tenants_TenantId]
GO
ALTER TABLE [Marketing].[MarketingJOfficerOrMedias]  WITH CHECK ADD  CONSTRAINT [FK_MarketingJOfficerOrMedias_MarketingOfficers_MarketingOfficerId] FOREIGN KEY([MarketingOfficerId])
REFERENCES [Marketing].[MarketingOfficers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Marketing].[MarketingJOfficerOrMedias] CHECK CONSTRAINT [FK_MarketingJOfficerOrMedias_MarketingOfficers_MarketingOfficerId]
GO
ALTER TABLE [Marketing].[MarketingManagers]  WITH CHECK ADD  CONSTRAINT [FK_MarketingManagers_HoDs_HoDId] FOREIGN KEY([HoDId])
REFERENCES [Marketing].[HoDs] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Marketing].[MarketingManagers] CHECK CONSTRAINT [FK_MarketingManagers_HoDs_HoDId]
GO
ALTER TABLE [Marketing].[MarketingOfficers]  WITH CHECK ADD  CONSTRAINT [FK_MarketingOfficers_MarketingManagers_MarketingManagerId] FOREIGN KEY([MarketingManagerId])
REFERENCES [Marketing].[MarketingManagers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Marketing].[MarketingOfficers] CHECK CONSTRAINT [FK_MarketingOfficers_MarketingManagers_MarketingManagerId]
GO
ALTER TABLE [Marketing].[MarketingZoneMappings]  WITH CHECK ADD  CONSTRAINT [FK_MarketingZoneMappings_MarketingJOfficerOrMedias_MarketingJOfficerOrMediaId] FOREIGN KEY([MarketingJOfficerOrMediaId])
REFERENCES [Marketing].[MarketingJOfficerOrMedias] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Marketing].[MarketingZoneMappings] CHECK CONSTRAINT [FK_MarketingZoneMappings_MarketingJOfficerOrMedias_MarketingJOfficerOrMediaId]
GO
ALTER TABLE [Marketing].[MarketingZoneMappings]  WITH CHECK ADD  CONSTRAINT [FK_MarketingZoneMappings_MarketingZones_MarketingZoneId] FOREIGN KEY([MarketingZoneId])
REFERENCES [Marketing].[MarketingZones] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Marketing].[MarketingZoneMappings] CHECK CONSTRAINT [FK_MarketingZoneMappings_MarketingZones_MarketingZoneId]
GO
ALTER TABLE [Marketing].[Medias]  WITH CHECK ADD  CONSTRAINT [FK_Medias_MarketingJOfficerOrMedias_MarketingJOfficerOrMediaId] FOREIGN KEY([MarketingJOfficerOrMediaId])
REFERENCES [Marketing].[MarketingJOfficerOrMedias] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Marketing].[Medias] CHECK CONSTRAINT [FK_Medias_MarketingJOfficerOrMedias_MarketingJOfficerOrMediaId]
GO
ALTER TABLE [Marketing].[MPOSalesTargets]  WITH CHECK ADD  CONSTRAINT [FK_MPOSalesTargets_MarketingJOfficerOrMedias_MarketingJOfficerOrMediaId] FOREIGN KEY([MarketingJOfficerOrMediaId])
REFERENCES [Marketing].[MarketingJOfficerOrMedias] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Marketing].[MPOSalesTargets] CHECK CONSTRAINT [FK_MPOSalesTargets_MarketingJOfficerOrMedias_MarketingJOfficerOrMediaId]
GO
ALTER TABLE [Menu].[MenuPermissions]  WITH CHECK ADD  CONSTRAINT [FK_MenuPermissions_ProjectMenus_MenuId] FOREIGN KEY([MenuId])
REFERENCES [Admin].[ProjectMenus] ([Id])
GO
ALTER TABLE [Menu].[MenuPermissions] CHECK CONSTRAINT [FK_MenuPermissions_ProjectMenus_MenuId]
GO
ALTER TABLE [Nutrition].[CabinTypeAndMealMappings]  WITH CHECK ADD  CONSTRAINT [FK_CabinTypeAndMealMappings_CabinTypes_CabinTypeId] FOREIGN KEY([CabinTypeId])
REFERENCES [Hospital].[CabinTypes] ([Id])
GO
ALTER TABLE [Nutrition].[CabinTypeAndMealMappings] CHECK CONSTRAINT [FK_CabinTypeAndMealMappings_CabinTypes_CabinTypeId]
GO
ALTER TABLE [Nutrition].[FoodDeliverableDetails]  WITH CHECK ADD  CONSTRAINT [FK_FoodDeliverableDetails_FoodDeliverables_FoodDeliverableId] FOREIGN KEY([FoodDeliverableId])
REFERENCES [Nutrition].[FoodDeliverables] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Nutrition].[FoodDeliverableDetails] CHECK CONSTRAINT [FK_FoodDeliverableDetails_FoodDeliverables_FoodDeliverableId]
GO
ALTER TABLE [Nutrition].[FoodDeliverableDetails]  WITH CHECK ADD  CONSTRAINT [FK_FoodDeliverableDetails_Items_ItemId] FOREIGN KEY([ItemId ])
REFERENCES [Canteen].[Items] ([Id])
GO
ALTER TABLE [Nutrition].[FoodDeliverableDetails] CHECK CONSTRAINT [FK_FoodDeliverableDetails_Items_ItemId]
GO
ALTER TABLE [Nutrition].[FoodDeliverables]  WITH CHECK ADD  CONSTRAINT [FK_FoodDeliverables_IPDFoodIndents_IPDFoodIndentId] FOREIGN KEY([IPDFoodIndentId])
REFERENCES [Canteen].[IPDFoodIndents] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Nutrition].[FoodDeliverables] CHECK CONSTRAINT [FK_FoodDeliverables_IPDFoodIndents_IPDFoodIndentId]
GO
ALTER TABLE [Nutrition].[FoodPatternDetail]  WITH CHECK ADD  CONSTRAINT [FK_FoodPatternDetail_FoodPatterns_FoodPatternId] FOREIGN KEY([FoodPatternId])
REFERENCES [Nutrition].[FoodPatterns] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Nutrition].[FoodPatternDetail] CHECK CONSTRAINT [FK_FoodPatternDetail_FoodPatterns_FoodPatternId]
GO
ALTER TABLE [Nutrition].[FoodPatternDetail]  WITH CHECK ADD  CONSTRAINT [FK_FoodPatternDetail_Items_ItemId] FOREIGN KEY([ItemId ])
REFERENCES [Canteen].[Items] ([Id])
GO
ALTER TABLE [Nutrition].[FoodPatternDetail] CHECK CONSTRAINT [FK_FoodPatternDetail_Items_ItemId]
GO
ALTER TABLE [Nutrition].[FoodPatterns]  WITH CHECK ADD  CONSTRAINT [FK_FoodPatterns_FoodPatternGroups_FoodPatternGroupId] FOREIGN KEY([FoodPatternGroupId])
REFERENCES [Nutrition].[FoodPatternGroups] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Nutrition].[FoodPatterns] CHECK CONSTRAINT [FK_FoodPatterns_FoodPatternGroups_FoodPatternGroupId]
GO
ALTER TABLE [OPD].[ChamberPractionerRoutines]  WITH CHECK ADD  CONSTRAINT [FK_ChamberPractionerRoutines_Doctors_DoctorId] FOREIGN KEY([DoctorId])
REFERENCES [Marketing].[Doctors] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [OPD].[ChamberPractionerRoutines] CHECK CONSTRAINT [FK_ChamberPractionerRoutines_Doctors_DoctorId]
GO
ALTER TABLE [OPD].[ChamberPractionerSettings]  WITH CHECK ADD  CONSTRAINT [FK_ChamberPractionerSettings_Doctors_DoctorId] FOREIGN KEY([DoctorId])
REFERENCES [Marketing].[Doctors] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [OPD].[ChamberPractionerSettings] CHECK CONSTRAINT [FK_ChamberPractionerSettings_Doctors_DoctorId]
GO
ALTER TABLE [OPD].[ConsultancyDetails]  WITH CHECK ADD  CONSTRAINT [FK_ConsultancyDetails_PatientRecordConsultancyFees_PatientId] FOREIGN KEY([PatientId])
REFERENCES [OPD].[PatientRecordConsultancyFees] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [OPD].[ConsultancyDetails] CHECK CONSTRAINT [FK_ConsultancyDetails_PatientRecordConsultancyFees_PatientId]
GO
ALTER TABLE [OPD].[CPFeeCollectionRecords]  WITH CHECK ADD  CONSTRAINT [FK_CPFeeCollectionRecords_CPPatientRecords_CPPatientRecordId] FOREIGN KEY([CPPatientRecordId])
REFERENCES [OPD].[CPPatientRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [OPD].[CPFeeCollectionRecords] CHECK CONSTRAINT [FK_CPFeeCollectionRecords_CPPatientRecords_CPPatientRecordId]
GO
ALTER TABLE [OPD].[CPLedgers]  WITH CHECK ADD  CONSTRAINT [FK_CPLedgers_CPPatientRecords_PatientId] FOREIGN KEY([PatientId])
REFERENCES [OPD].[CPPatientRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [OPD].[CPLedgers] CHECK CONSTRAINT [FK_CPLedgers_CPPatientRecords_PatientId]
GO
ALTER TABLE [OPD].[OPDConsultancyLedger]  WITH CHECK ADD  CONSTRAINT [FK_OPDConsultancyLedger_PatientRecordConsultancyFees_PatientId] FOREIGN KEY([PatientId])
REFERENCES [OPD].[PatientRecordConsultancyFees] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [OPD].[OPDConsultancyLedger] CHECK CONSTRAINT [FK_OPDConsultancyLedger_PatientRecordConsultancyFees_PatientId]
GO
ALTER TABLE [OPD].[OPDPatientHistories]  WITH CHECK ADD  CONSTRAINT [FK_OPDPatientHistories_DynamicTemplates_DynamicFormId] FOREIGN KEY([DynamicFormId])
REFERENCES [Hospital].[DynamicTemplates] ([Id])
GO
ALTER TABLE [OPD].[OPDPatientHistories] CHECK CONSTRAINT [FK_OPDPatientHistories_DynamicTemplates_DynamicFormId]
GO
ALTER TABLE [OPD].[OPDPatientHistoryDetails]  WITH CHECK ADD  CONSTRAINT [FK_OPDPatientHistoryDetails_OPDPatientHistories_MasterId] FOREIGN KEY([MasterId])
REFERENCES [OPD].[OPDPatientHistories] ([Id])
GO
ALTER TABLE [OPD].[OPDPatientHistoryDetails] CHECK CONSTRAINT [FK_OPDPatientHistoryDetails_OPDPatientHistories_MasterId]
GO
ALTER TABLE [OPD].[OPDServiceLedger]  WITH CHECK ADD  CONSTRAINT [FK_OPDServiceLedger_PatientRecordOPDServices_PatientId] FOREIGN KEY([PatientId])
REFERENCES [OPD].[PatientRecordOPDServices] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [OPD].[OPDServiceLedger] CHECK CONSTRAINT [FK_OPDServiceLedger_PatientRecordOPDServices_PatientId]
GO
ALTER TABLE [OPD].[OTAssistantPaymentDetails]  WITH CHECK ADD  CONSTRAINT [FK_OTAssistantPaymentDetails_OTAssistantPayments_RecordId] FOREIGN KEY([RecordId])
REFERENCES [OPD].[OTAssistantPayments] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [OPD].[OTAssistantPaymentDetails] CHECK CONSTRAINT [FK_OTAssistantPaymentDetails_OTAssistantPayments_RecordId]
GO
ALTER TABLE [OPD].[ServiceDetails]  WITH CHECK ADD  CONSTRAINT [FK_ServiceDetails_PatientRecordOPDServices_PatientId] FOREIGN KEY([PatientId])
REFERENCES [OPD].[PatientRecordOPDServices] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [OPD].[ServiceDetails] CHECK CONSTRAINT [FK_ServiceDetails_PatientRecordOPDServices_PatientId]
GO
ALTER TABLE [Others].[NotificationSentTos]  WITH CHECK ADD  CONSTRAINT [FK_NotificationSentTos_Notifications_NotificationId] FOREIGN KEY([NotificationId])
REFERENCES [Others].[Notifications] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Others].[NotificationSentTos] CHECK CONSTRAINT [FK_NotificationSentTos_Notifications_NotificationId]
GO
ALTER TABLE [Payroll].[AllowancePayments]  WITH CHECK ADD  CONSTRAINT [FK_AllowancePayments_StaffRecords_StaffRecordId] FOREIGN KEY([StaffRecordId])
REFERENCES [HR].[StaffRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Payroll].[AllowancePayments] CHECK CONSTRAINT [FK_AllowancePayments_StaffRecords_StaffRecordId]
GO
ALTER TABLE [Payroll].[ArrearRecords]  WITH CHECK ADD  CONSTRAINT [FK_ArrearRecords_StaffRecords_StaffRecordId] FOREIGN KEY([StaffRecordId])
REFERENCES [HR].[StaffRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Payroll].[ArrearRecords] CHECK CONSTRAINT [FK_ArrearRecords_StaffRecords_StaffRecordId]
GO
ALTER TABLE [Payroll].[FestivalBonuses]  WITH CHECK ADD  CONSTRAINT [FK_FestivalBonuses_Festivals_FestivalId] FOREIGN KEY([FestivalId])
REFERENCES [HR].[Festivals] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Payroll].[FestivalBonuses] CHECK CONSTRAINT [FK_FestivalBonuses_Festivals_FestivalId]
GO
ALTER TABLE [Payroll].[IncrementRecords]  WITH CHECK ADD  CONSTRAINT [FK_IncrementRecords_StaffRecords_StaffRecordId] FOREIGN KEY([StaffRecordId])
REFERENCES [HR].[StaffRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Payroll].[IncrementRecords] CHECK CONSTRAINT [FK_IncrementRecords_StaffRecords_StaffRecordId]
GO
ALTER TABLE [Payroll].[IndividualSalaries]  WITH CHECK ADD  CONSTRAINT [FK_IndividualSalaries_StaffRecords_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [HR].[StaffRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Payroll].[IndividualSalaries] CHECK CONSTRAINT [FK_IndividualSalaries_StaffRecords_EmployeeId]
GO
ALTER TABLE [Payroll].[SalaryPunishments]  WITH CHECK ADD  CONSTRAINT [FK_SalaryPunishments_StaffRecords_StaffRecordId] FOREIGN KEY([StaffRecordId])
REFERENCES [HR].[StaffRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Payroll].[SalaryPunishments] CHECK CONSTRAINT [FK_SalaryPunishments_StaffRecords_StaffRecordId]
GO
ALTER TABLE [Payroll].[StaffGlobalLedgers]  WITH CHECK ADD  CONSTRAINT [FK_StaffGlobalLedgers_StaffRecords_StaffRecordId] FOREIGN KEY([StaffRecordId])
REFERENCES [HR].[StaffRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Payroll].[StaffGlobalLedgers] CHECK CONSTRAINT [FK_StaffGlobalLedgers_StaffRecords_StaffRecordId]
GO
ALTER TABLE [Payroll].[StaffOvertimes]  WITH CHECK ADD  CONSTRAINT [FK_StaffOvertimes_StaffRecords_StaffRecordId] FOREIGN KEY([StaffRecordId])
REFERENCES [HR].[StaffRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Payroll].[StaffOvertimes] CHECK CONSTRAINT [FK_StaffOvertimes_StaffRecords_StaffRecordId]
GO
ALTER TABLE [Payroll].[StaffSalaryDeductions]  WITH CHECK ADD  CONSTRAINT [FK_StaffSalaryDeductions_StaffRecords_StaffRecordId] FOREIGN KEY([StaffRecordId])
REFERENCES [HR].[StaffRecords] ([Id])
GO
ALTER TABLE [Payroll].[StaffSalaryDeductions] CHECK CONSTRAINT [FK_StaffSalaryDeductions_StaffRecords_StaffRecordId]
GO
ALTER TABLE [Payroll].[TimedAttendanceLogs]  WITH CHECK ADD  CONSTRAINT [FK_TimedAttendanceLogs_TimedAttendanceLogPullHistories_PullId] FOREIGN KEY([PullId])
REFERENCES [Payroll].[TimedAttendanceLogPullHistories] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Payroll].[TimedAttendanceLogs] CHECK CONSTRAINT [FK_TimedAttendanceLogs_TimedAttendanceLogPullHistories_PullId]
GO
ALTER TABLE [Personal].[UpazilaOrAreas]  WITH CHECK ADD  CONSTRAINT [FK_UpazilaOrAreas_Districts_DistrictId] FOREIGN KEY([DistrictId])
REFERENCES [Location].[Districts] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Personal].[UpazilaOrAreas] CHECK CONSTRAINT [FK_UpazilaOrAreas_Districts_DistrictId]
GO
ALTER TABLE [PFBook].[PFLevel4Heads]  WITH CHECK ADD  CONSTRAINT [FK_PFLevel4Heads_PFSubCategories_PfSubCategoryId] FOREIGN KEY([PfSubCategoryId])
REFERENCES [PFBook].[PFSubCategories] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [PFBook].[PFLevel4Heads] CHECK CONSTRAINT [FK_PFLevel4Heads_PFSubCategories_PfSubCategoryId]
GO
ALTER TABLE [PFBook].[PfNoAcategories]  WITH CHECK ADD  CONSTRAINT [FK_PfNoAcategories_PFNoAs_NatueOfAccountId] FOREIGN KEY([NatueOfAccountId])
REFERENCES [PFBook].[PFNoAs] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [PFBook].[PfNoAcategories] CHECK CONSTRAINT [FK_PfNoAcategories_PFNoAs_NatueOfAccountId]
GO
ALTER TABLE [PFBook].[PFSubCategories]  WITH CHECK ADD  CONSTRAINT [FK_PFSubCategories_PfNoAcategories_PfNoACategoryId] FOREIGN KEY([PfNoACategoryId])
REFERENCES [PFBook].[PfNoAcategories] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [PFBook].[PFSubCategories] CHECK CONSTRAINT [FK_PFSubCategories_PfNoAcategories_PfNoACategoryId]
GO
ALTER TABLE [PFBook].[PFVoucherMasterDetails]  WITH CHECK ADD  CONSTRAINT [FK_PFVoucherMasterDetails_PFVoucherMasters_VMID] FOREIGN KEY([VMID])
REFERENCES [PFBook].[PFVoucherMasters] ([Id])
GO
ALTER TABLE [PFBook].[PFVoucherMasterDetails] CHECK CONSTRAINT [FK_PFVoucherMasterDetails_PFVoucherMasters_VMID]
GO
ALTER TABLE [Pharmacy].[AuditedStocks]  WITH CHECK ADD  CONSTRAINT [FK_AuditedStocks_StockAudits_StockAuditId] FOREIGN KEY([StockAuditId])
REFERENCES [Pharmacy].[StockAudits] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Pharmacy].[AuditedStocks] CHECK CONSTRAINT [FK_AuditedStocks_StockAudits_StockAuditId]
GO
ALTER TABLE [Pharmacy].[BrandExtensions]  WITH CHECK ADD  CONSTRAINT [FK_BrandExtensions_BrandNames_BrandId] FOREIGN KEY([BrandId])
REFERENCES [Pharmacy].[BrandNames] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Pharmacy].[BrandExtensions] CHECK CONSTRAINT [FK_BrandExtensions_BrandNames_BrandId]
GO
ALTER TABLE [Pharmacy].[BrandExtensions]  WITH CHECK ADD  CONSTRAINT [FK_BrandExtensions_Formations_FormationId] FOREIGN KEY([FormationId])
REFERENCES [Pharmacy].[Formations] ([Id])
GO
ALTER TABLE [Pharmacy].[BrandExtensions] CHECK CONSTRAINT [FK_BrandExtensions_Formations_FormationId]
GO
ALTER TABLE [Pharmacy].[BrandExtensions]  WITH CHECK ADD  CONSTRAINT [FK_BrandExtensions_Generics_GenericId] FOREIGN KEY([GenericId])
REFERENCES [Pharmacy].[Generics] ([Id])
GO
ALTER TABLE [Pharmacy].[BrandExtensions] CHECK CONSTRAINT [FK_BrandExtensions_Generics_GenericId]
GO
ALTER TABLE [Pharmacy].[BrandNames]  WITH CHECK ADD  CONSTRAINT [FK_BrandNames_Manufacturers_ManufacturerId] FOREIGN KEY([ManufacturerId])
REFERENCES [Pharmacy].[Manufacturers] ([Id])
GO
ALTER TABLE [Pharmacy].[BrandNames] CHECK CONSTRAINT [FK_BrandNames_Manufacturers_ManufacturerId]
GO
ALTER TABLE [Pharmacy].[Generics]  WITH CHECK ADD  CONSTRAINT [FK_Generics_Groups_GroupId] FOREIGN KEY([GroupId])
REFERENCES [Pharmacy].[Groups] ([Id])
GO
ALTER TABLE [Pharmacy].[Generics] CHECK CONSTRAINT [FK_Generics_Groups_GroupId]
GO
ALTER TABLE [Pharmacy].[InvoiceDetails]  WITH CHECK ADD  CONSTRAINT [FK_InvoiceDetails_BrandExtensions_BrandExtensionId] FOREIGN KEY([BrandExtensionId])
REFERENCES [Pharmacy].[BrandExtensions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Pharmacy].[InvoiceDetails] CHECK CONSTRAINT [FK_InvoiceDetails_BrandExtensions_BrandExtensionId]
GO
ALTER TABLE [Pharmacy].[InvoiceDetails]  WITH CHECK ADD  CONSTRAINT [FK_InvoiceDetails_Invoices_InvoiceId] FOREIGN KEY([InvoiceId])
REFERENCES [Pharmacy].[Invoices] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Pharmacy].[InvoiceDetails] CHECK CONSTRAINT [FK_InvoiceDetails_Invoices_InvoiceId]
GO
ALTER TABLE [Pharmacy].[InvoiceDetails]  WITH CHECK ADD  CONSTRAINT [FK_InvoiceDetails_LotRecords_LotRecordId] FOREIGN KEY([LotRecordId])
REFERENCES [Pharmacy].[LotRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Pharmacy].[InvoiceDetails] CHECK CONSTRAINT [FK_InvoiceDetails_LotRecords_LotRecordId]
GO
ALTER TABLE [Pharmacy].[InvoiceLedgers]  WITH CHECK ADD  CONSTRAINT [FK_InvoiceLedgers_Invoices_InvoiceId] FOREIGN KEY([InvoiceId])
REFERENCES [Pharmacy].[Invoices] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Pharmacy].[InvoiceLedgers] CHECK CONSTRAINT [FK_InvoiceLedgers_Invoices_InvoiceId]
GO
ALTER TABLE [Pharmacy].[Invoices]  WITH CHECK ADD  CONSTRAINT [FK_Invoices_MedicineOutlets_MedicineOutLetId] FOREIGN KEY([MedicineOutletId])
REFERENCES [Pharmacy].[MedicineOutlets] ([Id])
GO
ALTER TABLE [Pharmacy].[Invoices] CHECK CONSTRAINT [FK_Invoices_MedicineOutlets_MedicineOutLetId]
GO
ALTER TABLE [Pharmacy].[Invoices]  WITH CHECK ADD  CONSTRAINT [FK_Invoices_ServeTypes_ServeTypeId] FOREIGN KEY([ServeTypeId])
REFERENCES [Admin].[ServeTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Pharmacy].[Invoices] CHECK CONSTRAINT [FK_Invoices_ServeTypes_ServeTypeId]
GO
ALTER TABLE [Pharmacy].[Invoices]  WITH CHECK ADD  CONSTRAINT [FK_Invoices_Tenants_TenantId] FOREIGN KEY([TenantId])
REFERENCES [Admin].[Tenants] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Pharmacy].[Invoices] CHECK CONSTRAINT [FK_Invoices_Tenants_TenantId]
GO
ALTER TABLE [Pharmacy].[IPDMedicineIndentDetails]  WITH CHECK ADD  CONSTRAINT [FK_IPDMedicineIndentDetails_BrandExtensions_BrandExtensionId] FOREIGN KEY([BrandExtensionId])
REFERENCES [Pharmacy].[BrandExtensions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Pharmacy].[IPDMedicineIndentDetails] CHECK CONSTRAINT [FK_IPDMedicineIndentDetails_BrandExtensions_BrandExtensionId]
GO
ALTER TABLE [Pharmacy].[IPDMedicineIndentDetails]  WITH CHECK ADD  CONSTRAINT [FK_IPDMedicineIndentDetails_IPDMedicineIndents_IPDMedicineIndentId] FOREIGN KEY([IPDMedicineIndentId])
REFERENCES [Pharmacy].[IPDMedicineIndents] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Pharmacy].[IPDMedicineIndentDetails] CHECK CONSTRAINT [FK_IPDMedicineIndentDetails_IPDMedicineIndents_IPDMedicineIndentId]
GO
ALTER TABLE [Pharmacy].[IPDMedicineIndents]  WITH CHECK ADD  CONSTRAINT [FK_IPDMedicineIndents_IPDPatientRecords_IPDPatientId] FOREIGN KEY([IPDPatientId])
REFERENCES [Hospital].[IPDPatientRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Pharmacy].[IPDMedicineIndents] CHECK CONSTRAINT [FK_IPDMedicineIndents_IPDPatientRecords_IPDPatientId]
GO
ALTER TABLE [Pharmacy].[IPDMedicineIndents]  WITH CHECK ADD  CONSTRAINT [FK_IPDMedicineIndents_MedicineOutlets_IndentToOutletId] FOREIGN KEY([IndentToOutletId])
REFERENCES [Pharmacy].[MedicineOutlets] ([Id])
GO
ALTER TABLE [Pharmacy].[IPDMedicineIndents] CHECK CONSTRAINT [FK_IPDMedicineIndents_MedicineOutlets_IndentToOutletId]
GO
ALTER TABLE [Pharmacy].[IPDMedicineIndents]  WITH CHECK ADD  CONSTRAINT [FK_IPDMedicineIndents_ServeTypes_ServeTypeId] FOREIGN KEY([ServeTypeId])
REFERENCES [Admin].[ServeTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Pharmacy].[IPDMedicineIndents] CHECK CONSTRAINT [FK_IPDMedicineIndents_ServeTypes_ServeTypeId]
GO
ALTER TABLE [Pharmacy].[OutletIndentDetails]  WITH CHECK ADD  CONSTRAINT [FK_OutletIndentDetails_BrandExtensions_BrandExtensionId] FOREIGN KEY([BrandExtensionId])
REFERENCES [Pharmacy].[BrandExtensions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Pharmacy].[OutletIndentDetails] CHECK CONSTRAINT [FK_OutletIndentDetails_BrandExtensions_BrandExtensionId]
GO
ALTER TABLE [Pharmacy].[OutletIndentDetails]  WITH CHECK ADD  CONSTRAINT [FK_OutletIndentDetails_OutletIndents_OutletIndentId] FOREIGN KEY([OutletIndentId])
REFERENCES [Pharmacy].[OutletIndents] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Pharmacy].[OutletIndentDetails] CHECK CONSTRAINT [FK_OutletIndentDetails_OutletIndents_OutletIndentId]
GO
ALTER TABLE [Pharmacy].[OutletIndents]  WITH CHECK ADD  CONSTRAINT [FK_OutletIndents_MedicineOutlets_FromOutletId] FOREIGN KEY([FromOutletId])
REFERENCES [Pharmacy].[MedicineOutlets] ([Id])
GO
ALTER TABLE [Pharmacy].[OutletIndents] CHECK CONSTRAINT [FK_OutletIndents_MedicineOutlets_FromOutletId]
GO
ALTER TABLE [Pharmacy].[OutletIndents]  WITH CHECK ADD  CONSTRAINT [FK_OutletIndents_MedicineOutlets_ToOutletId] FOREIGN KEY([ToOutletId])
REFERENCES [Pharmacy].[MedicineOutlets] ([Id])
GO
ALTER TABLE [Pharmacy].[OutletIndents] CHECK CONSTRAINT [FK_OutletIndents_MedicineOutlets_ToOutletId]
GO
ALTER TABLE [Pharmacy].[PIPDDueCollections]  WITH CHECK ADD  CONSTRAINT [FK_PIPDDueCollections_IPDPatientRecords_IPDPatientId] FOREIGN KEY([IPDPatientId])
REFERENCES [Hospital].[IPDPatientRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Pharmacy].[PIPDDueCollections] CHECK CONSTRAINT [FK_PIPDDueCollections_IPDPatientRecords_IPDPatientId]
GO
ALTER TABLE [Pharmacy].[PurchaseOrderDetails]  WITH CHECK ADD  CONSTRAINT [FK_PurchaseOrderDetails_PurchaseOrders_OrderId] FOREIGN KEY([OrderId])
REFERENCES [Pharmacy].[PurchaseOrders] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Pharmacy].[PurchaseOrderDetails] CHECK CONSTRAINT [FK_PurchaseOrderDetails_PurchaseOrders_OrderId]
GO
ALTER TABLE [Pharmacy].[PurchaseOrders]  WITH CHECK ADD  CONSTRAINT [FK_PurchaseOrders_Suppliers_OrderToSupplierId] FOREIGN KEY([OrderToSupplierId])
REFERENCES [SupplyChain ].[Suppliers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Pharmacy].[PurchaseOrders] CHECK CONSTRAINT [FK_PurchaseOrders_Suppliers_OrderToSupplierId]
GO
ALTER TABLE [Pharmacy].[RceivePurchOrders]  WITH CHECK ADD  CONSTRAINT [FK_RceivePurchOrders_StockReceives_StockReceiveId] FOREIGN KEY([StockReceiveId])
REFERENCES [Pharmacy].[StockReceives] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Pharmacy].[RceivePurchOrders] CHECK CONSTRAINT [FK_RceivePurchOrders_StockReceives_StockReceiveId]
GO
ALTER TABLE [Pharmacy].[StockAudits]  WITH CHECK ADD  CONSTRAINT [FK_StockAudits_MedicineOutlets_MedicineOutLetId] FOREIGN KEY([MedicineOutletId])
REFERENCES [Pharmacy].[MedicineOutlets] ([Id])
GO
ALTER TABLE [Pharmacy].[StockAudits] CHECK CONSTRAINT [FK_StockAudits_MedicineOutlets_MedicineOutLetId]
GO
ALTER TABLE [Pharmacy].[StockReceiveDetails]  WITH CHECK ADD  CONSTRAINT [FK_StockReceiveDetails_BrandExtensions_BrandExtensionId] FOREIGN KEY([BrandExtensionId])
REFERENCES [Pharmacy].[BrandExtensions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Pharmacy].[StockReceiveDetails] CHECK CONSTRAINT [FK_StockReceiveDetails_BrandExtensions_BrandExtensionId]
GO
ALTER TABLE [Pharmacy].[StockReceiveDetails]  WITH CHECK ADD  CONSTRAINT [FK_StockReceiveDetails_StockReceives_StockReceiveId] FOREIGN KEY([StockReceiveId])
REFERENCES [Pharmacy].[StockReceives] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Pharmacy].[StockReceiveDetails] CHECK CONSTRAINT [FK_StockReceiveDetails_StockReceives_StockReceiveId]
GO
ALTER TABLE [Pharmacy].[StockReceives]  WITH CHECK ADD  CONSTRAINT [FK_StockReceives_MedicineOutlets_OutLetId] FOREIGN KEY([OutletId])
REFERENCES [Pharmacy].[MedicineOutlets] ([Id])
GO
ALTER TABLE [Pharmacy].[StockReceives] CHECK CONSTRAINT [FK_StockReceives_MedicineOutlets_OutLetId]
GO
ALTER TABLE [Pharmacy].[StockReceives]  WITH CHECK ADD  CONSTRAINT [FK_StockReceives_ServeTypes_ReceiveTypeId] FOREIGN KEY([ReceiveTypeId])
REFERENCES [Admin].[ServeTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Pharmacy].[StockReceives] CHECK CONSTRAINT [FK_StockReceives_ServeTypes_ReceiveTypeId]
GO
ALTER TABLE [Pharmacy].[StockReceives]  WITH CHECK ADD  CONSTRAINT [FK_StockReceives_Suppliers_SupplierId] FOREIGN KEY([SupplierId])
REFERENCES [SupplyChain ].[Suppliers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Pharmacy].[StockReceives] CHECK CONSTRAINT [FK_StockReceives_Suppliers_SupplierId]
GO
ALTER TABLE [Pharmacy].[StockReceives]  WITH CHECK ADD  CONSTRAINT [FK_StockReceives_Tenants_TenantId] FOREIGN KEY([TenantId])
REFERENCES [Admin].[Tenants] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Pharmacy].[StockReceives] CHECK CONSTRAINT [FK_StockReceives_Tenants_TenantId]
GO
ALTER TABLE [Pharmacy].[StockTransferDetails]  WITH CHECK ADD  CONSTRAINT [FK_StockTransferDetails_StockTransfer_TransferId] FOREIGN KEY([TransferId])
REFERENCES [Pharmacy].[StockTransfer] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Pharmacy].[StockTransferDetails] CHECK CONSTRAINT [FK_StockTransferDetails_StockTransfer_TransferId]
GO
ALTER TABLE [Pharmacy].[SupplierLedgers]  WITH CHECK ADD  CONSTRAINT [FK_SupplierLedgers_StockReceives_StockReceiveId] FOREIGN KEY([StockReceiveId])
REFERENCES [Pharmacy].[StockReceives] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Pharmacy].[SupplierLedgers] CHECK CONSTRAINT [FK_SupplierLedgers_StockReceives_StockReceiveId]
GO
ALTER TABLE [Pharmacy].[SupplierReturnIndentDetails]  WITH CHECK ADD  CONSTRAINT [FK_SupplierReturnIndentDetails_BrandExtensions_BrandExtensionId] FOREIGN KEY([BrandExtensionId])
REFERENCES [Pharmacy].[BrandExtensions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Pharmacy].[SupplierReturnIndentDetails] CHECK CONSTRAINT [FK_SupplierReturnIndentDetails_BrandExtensions_BrandExtensionId]
GO
ALTER TABLE [Pharmacy].[SupplierReturnIndentDetails]  WITH CHECK ADD  CONSTRAINT [FK_SupplierReturnIndentDetails_LotRecords_LotRecordId] FOREIGN KEY([LotRecordId])
REFERENCES [Pharmacy].[LotRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Pharmacy].[SupplierReturnIndentDetails] CHECK CONSTRAINT [FK_SupplierReturnIndentDetails_LotRecords_LotRecordId]
GO
ALTER TABLE [Pharmacy].[SupplierReturnIndentDetails]  WITH CHECK ADD  CONSTRAINT [FK_SupplierReturnIndentDetails_SupplierReturnIndents_SupplierReturnIndentId] FOREIGN KEY([SupplierReturnIndentId])
REFERENCES [Pharmacy].[SupplierReturnIndents] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Pharmacy].[SupplierReturnIndentDetails] CHECK CONSTRAINT [FK_SupplierReturnIndentDetails_SupplierReturnIndents_SupplierReturnIndentId]
GO
ALTER TABLE [Pharmacy].[SupplierReturnIndents]  WITH CHECK ADD  CONSTRAINT [FK_SupplierReturnIndents_MedicineOutlets_FromOutletId] FOREIGN KEY([FromOutletId])
REFERENCES [Pharmacy].[MedicineOutlets] ([Id])
GO
ALTER TABLE [Pharmacy].[SupplierReturnIndents] CHECK CONSTRAINT [FK_SupplierReturnIndents_MedicineOutlets_FromOutletId]
GO
ALTER TABLE [Pharmacy].[SupplierReturnIndents]  WITH CHECK ADD  CONSTRAINT [FK_SupplierReturnIndents_Suppliers_SupplierId] FOREIGN KEY([SupplierId])
REFERENCES [SupplyChain ].[Suppliers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Pharmacy].[SupplierReturnIndents] CHECK CONSTRAINT [FK_SupplierReturnIndents_Suppliers_SupplierId]
GO
ALTER TABLE [ReAgentManagement].[ReAgentManualUses]  WITH CHECK ADD  CONSTRAINT [FK_ReAgentManualUses_BrandExtensions_BrandExtensionId] FOREIGN KEY([BrandExtensionId])
REFERENCES [SupplyChain ].[BrandExtensions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [ReAgentManagement].[ReAgentManualUses] CHECK CONSTRAINT [FK_ReAgentManualUses_BrandExtensions_BrandExtensionId]
GO
ALTER TABLE [ReAgentManagement].[ReAgentManualUses]  WITH CHECK ADD  CONSTRAINT [FK_ReAgentManualUses_TestItems_TestItemId] FOREIGN KEY([TestItemId])
REFERENCES [Diag].[TestItems] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [ReAgentManagement].[ReAgentManualUses] CHECK CONSTRAINT [FK_ReAgentManualUses_TestItems_TestItemId]
GO
ALTER TABLE [ReAgentManagement].[TestAndRegAgentMappings]  WITH CHECK ADD  CONSTRAINT [FK_TestAndRegAgentMappings_BrandExtensions_BrandExtensionId] FOREIGN KEY([BrandExtensionId])
REFERENCES [SupplyChain ].[BrandExtensions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [ReAgentManagement].[TestAndRegAgentMappings] CHECK CONSTRAINT [FK_TestAndRegAgentMappings_BrandExtensions_BrandExtensionId]
GO
ALTER TABLE [ReAgentManagement].[TestAndRegAgentMappings]  WITH CHECK ADD  CONSTRAINT [FK_TestAndRegAgentMappings_TestItems_TestItemId] FOREIGN KEY([TestItemId])
REFERENCES [Diag].[TestItems] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [ReAgentManagement].[TestAndRegAgentMappings] CHECK CONSTRAINT [FK_TestAndRegAgentMappings_TestItems_TestItemId]
GO
ALTER TABLE [Rx].[AdviceToPatients]  WITH CHECK ADD  CONSTRAINT [FK_AdviceToPatients_VisitHistories_RxVisitId] FOREIGN KEY([RxVisitId])
REFERENCES [Rx].[VisitHistories] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Rx].[AdviceToPatients] CHECK CONSTRAINT [FK_AdviceToPatients_VisitHistories_RxVisitId]
GO
ALTER TABLE [Rx].[Drugs]  WITH CHECK ADD  CONSTRAINT [FK_Drugs_VisitHistories_RxVisitId] FOREIGN KEY([RxVisitId])
REFERENCES [Rx].[VisitHistories] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Rx].[Drugs] CHECK CONSTRAINT [FK_Drugs_VisitHistories_RxVisitId]
GO
ALTER TABLE [Rx].[InitialDatas]  WITH CHECK ADD  CONSTRAINT [FK_InitialDatas_VisitHistories_RxVisitId] FOREIGN KEY([RxVisitId])
REFERENCES [Rx].[VisitHistories] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Rx].[InitialDatas] CHECK CONSTRAINT [FK_InitialDatas_VisitHistories_RxVisitId]
GO
ALTER TABLE [Rx].[Investigations]  WITH CHECK ADD  CONSTRAINT [FK_Investigations_VisitHistories_RxVisitId] FOREIGN KEY([RxVisitId])
REFERENCES [Rx].[VisitHistories] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Rx].[Investigations] CHECK CONSTRAINT [FK_Investigations_VisitHistories_RxVisitId]
GO
ALTER TABLE [Rx].[OPDProdureSuggessions]  WITH CHECK ADD  CONSTRAINT [FK_OPDProdureSuggessions_VisitHistories_RxVisitId] FOREIGN KEY([RxVisitId])
REFERENCES [Rx].[VisitHistories] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Rx].[OPDProdureSuggessions] CHECK CONSTRAINT [FK_OPDProdureSuggessions_VisitHistories_RxVisitId]
GO
ALTER TABLE [Rx].[PatientClinicalimpressions]  WITH CHECK ADD  CONSTRAINT [FK_PatientClinicalimpressions_VisitHistories_RxVisitId] FOREIGN KEY([RxVisitId])
REFERENCES [Rx].[VisitHistories] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Rx].[PatientClinicalimpressions] CHECK CONSTRAINT [FK_PatientClinicalimpressions_VisitHistories_RxVisitId]
GO
ALTER TABLE [Rx].[PatientRelevantHistoryPart1s]  WITH CHECK ADD  CONSTRAINT [FK_PatientRelevantHistoryPart1s_VisitHistories_RxVisitId] FOREIGN KEY([RxVisitId])
REFERENCES [Rx].[VisitHistories] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Rx].[PatientRelevantHistoryPart1s] CHECK CONSTRAINT [FK_PatientRelevantHistoryPart1s_VisitHistories_RxVisitId]
GO
ALTER TABLE [Rx].[PatientRelevantHistoryPart2s]  WITH CHECK ADD  CONSTRAINT [FK_PatientRelevantHistoryPart2s_RelevantHistories_RelevantHistoryId] FOREIGN KEY([RelevantHistoryId])
REFERENCES [Rx].[RelevantHistories] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Rx].[PatientRelevantHistoryPart2s] CHECK CONSTRAINT [FK_PatientRelevantHistoryPart2s_RelevantHistories_RelevantHistoryId]
GO
ALTER TABLE [Rx].[PatientRelevantHistoryPart2s]  WITH CHECK ADD  CONSTRAINT [FK_PatientRelevantHistoryPart2s_VisitHistories_RxVisitId] FOREIGN KEY([RxVisitId])
REFERENCES [Rx].[VisitHistories] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [Rx].[PatientRelevantHistoryPart2s] CHECK CONSTRAINT [FK_PatientRelevantHistoryPart2s_VisitHistories_RxVisitId]
GO
ALTER TABLE [SuperAdmin].[GLAndHospitalServiceSubGroupMappings]  WITH CHECK ADD  CONSTRAINT [FK_GLAndHospitalServiceSubGroupMappings_ServiceSubGroups_ServiceSubGroupId] FOREIGN KEY([ServiceSubGroupId])
REFERENCES [Hospital].[ServiceSubGroups] ([Id])
GO
ALTER TABLE [SuperAdmin].[GLAndHospitalServiceSubGroupMappings] CHECK CONSTRAINT [FK_GLAndHospitalServiceSubGroupMappings_ServiceSubGroups_ServiceSubGroupId]
GO
ALTER TABLE [SuperAdmin].[GLAndPharmacyServiceMappings]  WITH CHECK ADD  CONSTRAINT [FK_GLAndPharmacyServiceMappings_GeneralLedgers_GeneralLedgerId] FOREIGN KEY([GeneralLedgerId])
REFERENCES [Account].[GeneralLedgers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [SuperAdmin].[GLAndPharmacyServiceMappings] CHECK CONSTRAINT [FK_GLAndPharmacyServiceMappings_GeneralLedgers_GeneralLedgerId]
GO
ALTER TABLE [SupplyChain ].[BrandExtensions]  WITH CHECK ADD  CONSTRAINT [FK_BrandExtensions_BrandNames_BrandId] FOREIGN KEY([BrandId])
REFERENCES [SupplyChain ].[BrandNames] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [SupplyChain ].[BrandExtensions] CHECK CONSTRAINT [FK_BrandExtensions_BrandNames_BrandId]
GO
ALTER TABLE [SupplyChain ].[BrandNames]  WITH CHECK ADD  CONSTRAINT [FK_BrandNames_SubGroups_SubGroupId] FOREIGN KEY([SubGroupId])
REFERENCES [SupplyChain ].[SubGroups] ([Id])
GO
ALTER TABLE [SupplyChain ].[BrandNames] CHECK CONSTRAINT [FK_BrandNames_SubGroups_SubGroupId]
GO
ALTER TABLE [SupplyChain ].[ComparativeStudyDetails]  WITH CHECK ADD  CONSTRAINT [FK_ComparativeStudyDetails_ComparativeStudies_ComparativeStudyId] FOREIGN KEY([ComparativeStudyId])
REFERENCES [SupplyChain ].[ComparativeStudies] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [SupplyChain ].[ComparativeStudyDetails] CHECK CONSTRAINT [FK_ComparativeStudyDetails_ComparativeStudies_ComparativeStudyId]
GO
ALTER TABLE [SupplyChain ].[DeptStoreAcesses]  WITH CHECK ADD  CONSTRAINT [FK_DeptStoreAcesses_StoreDepts_DeptId] FOREIGN KEY([DeptId])
REFERENCES [SupplyChain ].[StoreDepts] ([Id])
GO
ALTER TABLE [SupplyChain ].[DeptStoreAcesses] CHECK CONSTRAINT [FK_DeptStoreAcesses_StoreDepts_DeptId]
GO
ALTER TABLE [SupplyChain ].[DeptStoreAcesses]  WITH CHECK ADD  CONSTRAINT [FK_DeptStoreAcesses_Stores_StoreId] FOREIGN KEY([StoreId])
REFERENCES [SupplyChain ].[Stores] ([Id])
GO
ALTER TABLE [SupplyChain ].[DeptStoreAcesses] CHECK CONSTRAINT [FK_DeptStoreAcesses_Stores_StoreId]
GO
ALTER TABLE [SupplyChain ].[GRNFaultDescriptions]  WITH CHECK ADD  CONSTRAINT [FK_GRNFaultDescriptions_BrandExtensions_BrandExtensionId] FOREIGN KEY([BrandExtensionId])
REFERENCES [SupplyChain ].[BrandExtensions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [SupplyChain ].[GRNFaultDescriptions] CHECK CONSTRAINT [FK_GRNFaultDescriptions_BrandExtensions_BrandExtensionId]
GO
ALTER TABLE [SupplyChain ].[GRNFaultDescriptions]  WITH CHECK ADD  CONSTRAINT [FK_GRNFaultDescriptions_GRNs_GRNId] FOREIGN KEY([GRNId])
REFERENCES [SupplyChain ].[GRNs] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [SupplyChain ].[GRNFaultDescriptions] CHECK CONSTRAINT [FK_GRNFaultDescriptions_GRNs_GRNId]
GO
ALTER TABLE [SupplyChain ].[IndentApprovals]  WITH CHECK ADD  CONSTRAINT [FK_IndentApprovals_StoreIndentApprovalSettings_ApprovalLevelId] FOREIGN KEY([ApprovalLevelId])
REFERENCES [SupplyChain ].[StoreIndentApprovalSettings] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [SupplyChain ].[IndentApprovals] CHECK CONSTRAINT [FK_IndentApprovals_StoreIndentApprovalSettings_ApprovalLevelId]
GO
ALTER TABLE [SupplyChain ].[IssueDetails]  WITH CHECK ADD  CONSTRAINT [FK_IssueDetails_BrandExtensions_BrandExtensionId] FOREIGN KEY([BrandExtensionId])
REFERENCES [SupplyChain ].[BrandExtensions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [SupplyChain ].[IssueDetails] CHECK CONSTRAINT [FK_IssueDetails_BrandExtensions_BrandExtensionId]
GO
ALTER TABLE [SupplyChain ].[IssueDetails]  WITH CHECK ADD  CONSTRAINT [FK_IssueDetails_Issues_IssueId] FOREIGN KEY([IssueId])
REFERENCES [SupplyChain ].[Issues] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [SupplyChain ].[IssueDetails] CHECK CONSTRAINT [FK_IssueDetails_Issues_IssueId]
GO
ALTER TABLE [SupplyChain ].[Issues]  WITH CHECK ADD  CONSTRAINT [FK_Issues_ServeTypes_ServeTypeId] FOREIGN KEY([ServeTypeId])
REFERENCES [Admin].[ServeTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [SupplyChain ].[Issues] CHECK CONSTRAINT [FK_Issues_ServeTypes_ServeTypeId]
GO
ALTER TABLE [SupplyChain ].[Issues]  WITH CHECK ADD  CONSTRAINT [FK_Issues_Stores_StoreId] FOREIGN KEY([StoreId])
REFERENCES [SupplyChain ].[Stores] ([Id])
GO
ALTER TABLE [SupplyChain ].[Issues] CHECK CONSTRAINT [FK_Issues_Stores_StoreId]
GO
ALTER TABLE [SupplyChain ].[IssueStoreAcesses]  WITH CHECK ADD  CONSTRAINT [FK_IssueStoreAcesses_Stores_StoreId] FOREIGN KEY([StoreId])
REFERENCES [SupplyChain ].[Stores] ([Id])
GO
ALTER TABLE [SupplyChain ].[IssueStoreAcesses] CHECK CONSTRAINT [FK_IssueStoreAcesses_Stores_StoreId]
GO
ALTER TABLE [SupplyChain ].[PRIndentDetails]  WITH CHECK ADD  CONSTRAINT [FK_PRIndentDetails_BrandExtensions_BrandExtensionId] FOREIGN KEY([BrandExtensionId])
REFERENCES [SupplyChain ].[BrandExtensions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [SupplyChain ].[PRIndentDetails] CHECK CONSTRAINT [FK_PRIndentDetails_BrandExtensions_BrandExtensionId]
GO
ALTER TABLE [SupplyChain ].[PRIndentDetails]  WITH CHECK ADD  CONSTRAINT [FK_PRIndentDetails_PRIndents_PRIndentId] FOREIGN KEY([PRIndentId])
REFERENCES [SupplyChain ].[PRIndents] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [SupplyChain ].[PRIndentDetails] CHECK CONSTRAINT [FK_PRIndentDetails_PRIndents_PRIndentId]
GO
ALTER TABLE [SupplyChain ].[PRIndentDetails]  WITH CHECK ADD  CONSTRAINT [FK_PRIndentDetails_StoreIndents_StoreIndentId] FOREIGN KEY([StoreIndentId])
REFERENCES [SupplyChain ].[StoreIndents] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [SupplyChain ].[PRIndentDetails] CHECK CONSTRAINT [FK_PRIndentDetails_StoreIndents_StoreIndentId]
GO
ALTER TABLE [SupplyChain ].[PRSubmittedDetails]  WITH CHECK ADD  CONSTRAINT [FK_PRSubmittedDetails_PRSubmitteds_PRSubmittedId] FOREIGN KEY([PRSubmittedId])
REFERENCES [SupplyChain ].[PRSubmitteds] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [SupplyChain ].[PRSubmittedDetails] CHECK CONSTRAINT [FK_PRSubmittedDetails_PRSubmitteds_PRSubmittedId]
GO
ALTER TABLE [SupplyChain ].[PurchaseOrderDetails]  WITH CHECK ADD  CONSTRAINT [FK_PurchaseOrderDetails_BrandExtensions_BrandExtensionId] FOREIGN KEY([BrandExtensionId])
REFERENCES [SupplyChain ].[BrandExtensions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [SupplyChain ].[PurchaseOrderDetails] CHECK CONSTRAINT [FK_PurchaseOrderDetails_BrandExtensions_BrandExtensionId]
GO
ALTER TABLE [SupplyChain ].[PurchaseOrderDetails]  WITH CHECK ADD  CONSTRAINT [FK_PurchaseOrderDetails_PurchaseOrders_OrderId] FOREIGN KEY([OrderId])
REFERENCES [SupplyChain ].[PurchaseOrders] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [SupplyChain ].[PurchaseOrderDetails] CHECK CONSTRAINT [FK_PurchaseOrderDetails_PurchaseOrders_OrderId]
GO
ALTER TABLE [SupplyChain ].[PurchaseOrders]  WITH CHECK ADD  CONSTRAINT [FK_PurchaseOrders_Suppliers_OrderToSupplierId] FOREIGN KEY([OrderToSupplierId])
REFERENCES [SupplyChain ].[Suppliers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [SupplyChain ].[PurchaseOrders] CHECK CONSTRAINT [FK_PurchaseOrders_Suppliers_OrderToSupplierId]
GO
ALTER TABLE [SupplyChain ].[PurchaseRequisiontionDetails]  WITH CHECK ADD  CONSTRAINT [FK_PurchaseRequisiontionDetails_BrandExtensions_BrandExtensionId] FOREIGN KEY([BrandExtensionId])
REFERENCES [SupplyChain ].[BrandExtensions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [SupplyChain ].[PurchaseRequisiontionDetails] CHECK CONSTRAINT [FK_PurchaseRequisiontionDetails_BrandExtensions_BrandExtensionId]
GO
ALTER TABLE [SupplyChain ].[PurchaseRequisiontionDetails]  WITH CHECK ADD  CONSTRAINT [FK_PurchaseRequisiontionDetails_PurchaseRequisiontions_PurchaseRequisiontionId] FOREIGN KEY([PurchaseRequisiontionId])
REFERENCES [SupplyChain ].[PurchaseRequisiontions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [SupplyChain ].[PurchaseRequisiontionDetails] CHECK CONSTRAINT [FK_PurchaseRequisiontionDetails_PurchaseRequisiontions_PurchaseRequisiontionId]
GO
ALTER TABLE [SupplyChain ].[PurchaseRequisiontions]  WITH CHECK ADD  CONSTRAINT [FK_PurchaseRequisiontions_MainStores_MainStoreId] FOREIGN KEY([MainStoreId])
REFERENCES [SupplyChain ].[MainStores] ([Id])
GO
ALTER TABLE [SupplyChain ].[PurchaseRequisiontions] CHECK CONSTRAINT [FK_PurchaseRequisiontions_MainStores_MainStoreId]
GO
ALTER TABLE [SupplyChain ].[ReAgentTestMappings]  WITH CHECK ADD  CONSTRAINT [FK_ReAgentTestMappings_BrandExtensions_BrandExtensionId] FOREIGN KEY([BrandExtensionId])
REFERENCES [SupplyChain ].[BrandExtensions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [SupplyChain ].[ReAgentTestMappings] CHECK CONSTRAINT [FK_ReAgentTestMappings_BrandExtensions_BrandExtensionId]
GO
ALTER TABLE [SupplyChain ].[ReAgentTestMappings]  WITH CHECK ADD  CONSTRAINT [FK_ReAgentTestMappings_TestItems_TestItemId] FOREIGN KEY([TestItemId])
REFERENCES [Diag].[TestItems] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [SupplyChain ].[ReAgentTestMappings] CHECK CONSTRAINT [FK_ReAgentTestMappings_TestItems_TestItemId]
GO
ALTER TABLE [SupplyChain ].[RequisitionApprovals]  WITH CHECK ADD  CONSTRAINT [FK_RequisitionApprovals_SCMPurchaseApprovalSettings_ApprovalLevelId] FOREIGN KEY([ApprovalLevelId])
REFERENCES [SupplyChain ].[SCMPurchaseApprovalSettings] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [SupplyChain ].[RequisitionApprovals] CHECK CONSTRAINT [FK_RequisitionApprovals_SCMPurchaseApprovalSettings_ApprovalLevelId]
GO
ALTER TABLE [SupplyChain ].[SCMPurchaseApprovalSettings]  WITH CHECK ADD  CONSTRAINT [FK_SCMPurchaseApprovalSettings_MainStores_MainStoreId] FOREIGN KEY([MainStoreId])
REFERENCES [SupplyChain ].[MainStores] ([Id])
GO
ALTER TABLE [SupplyChain ].[SCMPurchaseApprovalSettings] CHECK CONSTRAINT [FK_SCMPurchaseApprovalSettings_MainStores_MainStoreId]
GO
ALTER TABLE [SupplyChain ].[SStockTransfer]  WITH CHECK ADD  CONSTRAINT [FK_SStockTransfer_ServeTypes_ServeTypeId] FOREIGN KEY([ServeTypeId])
REFERENCES [Admin].[ServeTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [SupplyChain ].[SStockTransfer] CHECK CONSTRAINT [FK_SStockTransfer_ServeTypes_ServeTypeId]
GO
ALTER TABLE [SupplyChain ].[SStockTransferDetails]  WITH CHECK ADD  CONSTRAINT [FK_SStockTransferDetails_SStockTransfer_TransferId] FOREIGN KEY([TransferId])
REFERENCES [SupplyChain ].[SStockTransfer] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [SupplyChain ].[SStockTransferDetails] CHECK CONSTRAINT [FK_SStockTransferDetails_SStockTransfer_TransferId]
GO
ALTER TABLE [SupplyChain ].[StockReceiveDetails]  WITH CHECK ADD  CONSTRAINT [FK_StockReceiveDetails_BrandExtensions_BrandExtensionId] FOREIGN KEY([BrandExtensionId])
REFERENCES [SupplyChain ].[BrandExtensions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [SupplyChain ].[StockReceiveDetails] CHECK CONSTRAINT [FK_StockReceiveDetails_BrandExtensions_BrandExtensionId]
GO
ALTER TABLE [SupplyChain ].[StockReceiveDetails]  WITH CHECK ADD  CONSTRAINT [FK_StockReceiveDetails_LotRecords_LotRecordId] FOREIGN KEY([LotRecordId])
REFERENCES [SupplyChain ].[LotRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [SupplyChain ].[StockReceiveDetails] CHECK CONSTRAINT [FK_StockReceiveDetails_LotRecords_LotRecordId]
GO
ALTER TABLE [SupplyChain ].[StockReceiveDetails]  WITH CHECK ADD  CONSTRAINT [FK_StockReceiveDetails_StockReceives_StockReceiveId] FOREIGN KEY([StockReceiveId])
REFERENCES [SupplyChain ].[StockReceives] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [SupplyChain ].[StockReceiveDetails] CHECK CONSTRAINT [FK_StockReceiveDetails_StockReceives_StockReceiveId]
GO
ALTER TABLE [SupplyChain ].[StockReceives]  WITH CHECK ADD  CONSTRAINT [FK_StockReceives_MainStores_MainStoreId] FOREIGN KEY([MainStoreId])
REFERENCES [SupplyChain ].[MainStores] ([Id])
GO
ALTER TABLE [SupplyChain ].[StockReceives] CHECK CONSTRAINT [FK_StockReceives_MainStores_MainStoreId]
GO
ALTER TABLE [SupplyChain ].[StockReceives]  WITH CHECK ADD  CONSTRAINT [FK_StockReceives_ServeTypes_ReceiveTypeId] FOREIGN KEY([ReceiveTypeId])
REFERENCES [Admin].[ServeTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [SupplyChain ].[StockReceives] CHECK CONSTRAINT [FK_StockReceives_ServeTypes_ReceiveTypeId]
GO
ALTER TABLE [SupplyChain ].[StockReceives]  WITH CHECK ADD  CONSTRAINT [FK_StockReceives_Suppliers_SupplierId] FOREIGN KEY([SupplierId])
REFERENCES [SupplyChain ].[Suppliers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [SupplyChain ].[StockReceives] CHECK CONSTRAINT [FK_StockReceives_Suppliers_SupplierId]
GO
ALTER TABLE [SupplyChain ].[StockReceives]  WITH CHECK ADD  CONSTRAINT [FK_StockReceives_Tenants_TenantId] FOREIGN KEY([TenantId])
REFERENCES [Admin].[Tenants] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [SupplyChain ].[StockReceives] CHECK CONSTRAINT [FK_StockReceives_Tenants_TenantId]
GO
ALTER TABLE [SupplyChain ].[StoreIndentApprovalSettings]  WITH CHECK ADD  CONSTRAINT [FK_StoreIndentApprovalSettings_Stores_StoreId] FOREIGN KEY([StoreId])
REFERENCES [SupplyChain ].[Stores] ([Id])
GO
ALTER TABLE [SupplyChain ].[StoreIndentApprovalSettings] CHECK CONSTRAINT [FK_StoreIndentApprovalSettings_Stores_StoreId]
GO
ALTER TABLE [SupplyChain ].[StoreIndentDetails]  WITH CHECK ADD  CONSTRAINT [FK_StoreIndentDetails_BrandExtensions_BrandExtensionId] FOREIGN KEY([BrandExtensionId])
REFERENCES [SupplyChain ].[BrandExtensions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [SupplyChain ].[StoreIndentDetails] CHECK CONSTRAINT [FK_StoreIndentDetails_BrandExtensions_BrandExtensionId]
GO
ALTER TABLE [SupplyChain ].[StoreIndentDetails]  WITH CHECK ADD  CONSTRAINT [FK_StoreIndentDetails_ServeTypes_ServeTypeId] FOREIGN KEY([ServeTypeId])
REFERENCES [Admin].[ServeTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [SupplyChain ].[StoreIndentDetails] CHECK CONSTRAINT [FK_StoreIndentDetails_ServeTypes_ServeTypeId]
GO
ALTER TABLE [SupplyChain ].[StoreIndentDetails]  WITH CHECK ADD  CONSTRAINT [FK_StoreIndentDetails_StoreIndents_StoreIndentId] FOREIGN KEY([StoreIndentId])
REFERENCES [SupplyChain ].[StoreIndents] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [SupplyChain ].[StoreIndentDetails] CHECK CONSTRAINT [FK_StoreIndentDetails_StoreIndents_StoreIndentId]
GO
ALTER TABLE [SupplyChain ].[StoreIndents]  WITH CHECK ADD  CONSTRAINT [FK_StoreIndents_Stores_StoreId] FOREIGN KEY([StoreId])
REFERENCES [SupplyChain ].[Stores] ([Id])
GO
ALTER TABLE [SupplyChain ].[StoreIndents] CHECK CONSTRAINT [FK_StoreIndents_Stores_StoreId]
GO
ALTER TABLE [SupplyChain ].[SubCategories]  WITH CHECK ADD  CONSTRAINT [FK_SubCategories_ParentCategories_ParentCategoryId] FOREIGN KEY([ParentCategoryId])
REFERENCES [SupplyChain ].[ParentCategories] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [SupplyChain ].[SubCategories] CHECK CONSTRAINT [FK_SubCategories_ParentCategories_ParentCategoryId]
GO
ALTER TABLE [SupplyChain ].[SubGroups]  WITH CHECK ADD  CONSTRAINT [FK_SubGroups_Groups_GroupId] FOREIGN KEY([GroupId])
REFERENCES [SupplyChain ].[Groups] ([Id])
GO
ALTER TABLE [SupplyChain ].[SubGroups] CHECK CONSTRAINT [FK_SubGroups_Groups_GroupId]
GO
ALTER TABLE [SupplyChain ].[Suppliers]  WITH CHECK ADD  CONSTRAINT [FK_Suppliers_SupplierTypes_TypeId] FOREIGN KEY([TypeId])
REFERENCES [SupplyChain ].[SupplierTypes] ([Id])
GO
ALTER TABLE [SupplyChain ].[Suppliers] CHECK CONSTRAINT [FK_Suppliers_SupplierTypes_TypeId]
GO
ALTER TABLE [SupplyChain ].[XrayFilmTestMappings]  WITH CHECK ADD  CONSTRAINT [FK_XrayFilmTestMappings_BrandExtensions_BrandExtensionId] FOREIGN KEY([BrandExtensionId])
REFERENCES [SupplyChain ].[BrandExtensions] ([Id])
GO
ALTER TABLE [SupplyChain ].[XrayFilmTestMappings] CHECK CONSTRAINT [FK_XrayFilmTestMappings_BrandExtensions_BrandExtensionId]
GO
ALTER TABLE [SupplyChain ].[XrayFilmTestMappings]  WITH CHECK ADD  CONSTRAINT [FK_XrayFilmTestMappings_TestItems_TestItemId] FOREIGN KEY([TestItemId])
REFERENCES [Diag].[TestItems] ([Id])
GO
ALTER TABLE [SupplyChain ].[XrayFilmTestMappings] CHECK CONSTRAINT [FK_XrayFilmTestMappings_TestItems_TestItemId]
GO
ALTER TABLE [TransfusionMedicine].[BCParameters]  WITH CHECK ADD  CONSTRAINT [FK_BCParameters_BloodComponents_BloodComponentId] FOREIGN KEY([BloodComponentId])
REFERENCES [TransfusionMedicine].[BloodComponents] ([Id])
GO
ALTER TABLE [TransfusionMedicine].[BCParameters] CHECK CONSTRAINT [FK_BCParameters_BloodComponents_BloodComponentId]
GO
ALTER TABLE [TransfusionMedicine].[BloodDonors]  WITH CHECK ADD  CONSTRAINT [FK_BloodDonors_IPDPatientRecords_IPDPatientRecordId] FOREIGN KEY([IPDPatientRecordId])
REFERENCES [Hospital].[IPDPatientRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [TransfusionMedicine].[BloodDonors] CHECK CONSTRAINT [FK_BloodDonors_IPDPatientRecords_IPDPatientRecordId]
GO
ALTER TABLE [TransfusionMedicine].[CrossMatchingValues]  WITH CHECK ADD  CONSTRAINT [FK_CrossMatchingValues_CrossMatchingRecords_CrossMatchingRecordId] FOREIGN KEY([CrossMatchingRecordId])
REFERENCES [TransfusionMedicine].[CrossMatchingRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [TransfusionMedicine].[CrossMatchingValues] CHECK CONSTRAINT [FK_CrossMatchingValues_CrossMatchingRecords_CrossMatchingRecordId]
GO
ALTER TABLE [TransfusionMedicine].[DonorContributionRecords]  WITH CHECK ADD  CONSTRAINT [FK_DonorContributionRecords_CrossMatchingRecords_CrossMatchingRecordId] FOREIGN KEY([CrossMatchingRecordId])
REFERENCES [TransfusionMedicine].[CrossMatchingRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [TransfusionMedicine].[DonorContributionRecords] CHECK CONSTRAINT [FK_DonorContributionRecords_CrossMatchingRecords_CrossMatchingRecordId]
GO
ALTER TABLE [TransfusionMedicine].[SerologyResults]  WITH CHECK ADD  CONSTRAINT [FK_SerologyResults_SerologyRecords_SerologyRecordId] FOREIGN KEY([SerologyRecordId])
REFERENCES [TransfusionMedicine].[SerologyRecords] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [TransfusionMedicine].[SerologyResults] CHECK CONSTRAINT [FK_SerologyResults_SerologyRecords_SerologyRecordId]
GO

```