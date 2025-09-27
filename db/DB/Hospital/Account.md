

```sql
USE [HMS]
GO
/****** Object:  Table [Account].[AccountGroups]    Script Date: 09/27/25 11:38:10 AM ******/
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
/****** Object:  Table [Account].[AttachedFileWithVouchers]    Script Date: 09/27/25 11:38:10 AM ******/
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
/****** Object:  Table [Account].[Banks]    Script Date: 09/27/25 11:38:10 AM ******/
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
/****** Object:  Table [Account].[Categories]    Script Date: 09/27/25 11:38:10 AM ******/
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
/****** Object:  Table [Account].[COADescription]    Script Date: 09/27/25 11:38:10 AM ******/
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
/****** Object:  Table [Account].[Configuration]    Script Date: 09/27/25 11:38:10 AM ******/
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
/****** Object:  Table [Account].[ConsultantGlobalLedgers]    Script Date: 09/27/25 11:38:10 AM ******/
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
/****** Object:  Table [Account].[CostCenters]    Script Date: 09/27/25 11:38:10 AM ******/
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
/****** Object:  Table [Account].[DueCollection]    Script Date: 09/27/25 11:38:10 AM ******/
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
/****** Object:  Table [Account].[FiscalYears]    Script Date: 09/27/25 11:38:10 AM ******/
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
/****** Object:  Table [Account].[FSLI]    Script Date: 09/27/25 11:38:10 AM ******/
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
/****** Object:  Table [Account].[GeneralLedgers]    Script Date: 09/27/25 11:38:10 AM ******/
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
/****** Object:  Table [Account].[GLItemDescription]    Script Date: 09/27/25 11:38:10 AM ******/
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
/****** Object:  Table [Account].[GLMappingWithStatements]    Script Date: 09/27/25 11:38:10 AM ******/
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
/****** Object:  Table [Account].[HISandDiagMediaPaymentRecordDetails]    Script Date: 09/27/25 11:38:10 AM ******/
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
/****** Object:  Table [Account].[HISandDiagMediaPaymentRecords]    Script Date: 09/27/25 11:38:10 AM ******/
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
/****** Object:  Table [Account].[IPDPatientGlobalLedgers]    Script Date: 09/27/25 11:38:10 AM ******/
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
/****** Object:  Table [Account].[JournalTypes]    Script Date: 09/27/25 11:38:10 AM ******/
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
/****** Object:  Table [Account].[Level4Heads]    Script Date: 09/27/25 11:38:10 AM ******/
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
/****** Object:  Table [Account].[Level5Heads]    Script Date: 09/27/25 11:38:10 AM ******/
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
/****** Object:  Table [Account].[LoyalMemberLedgers]    Script Date: 09/27/25 11:38:10 AM ******/
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
/****** Object:  Table [Account].[LoyalMembers]    Script Date: 09/27/25 11:38:10 AM ******/
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
/****** Object:  Table [Account].[MainSubAccountsRelations]    Script Date: 09/27/25 11:38:10 AM ******/
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
/****** Object:  Table [Account].[MasterStatements]    Script Date: 09/27/25 11:38:10 AM ******/
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
/****** Object:  Table [Account].[NatureOfAccounts]    Script Date: 09/27/25 11:38:10 AM ******/
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
/****** Object:  Table [Account].[POSTerminals]    Script Date: 09/27/25 11:38:10 AM ******/
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
/****** Object:  Table [Account].[RadiologicalReportingFeePaymentRecordDetails]    Script Date: 09/27/25 11:38:10 AM ******/
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
/****** Object:  Table [Account].[RadiologicalReportingFeePaymentRecords]    Script Date: 09/27/25 11:38:10 AM ******/
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
/****** Object:  Table [Account].[StatementBroadHeads]    Script Date: 09/27/25 11:38:10 AM ******/
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
/****** Object:  Table [Account].[StatementSubHeads]    Script Date: 09/27/25 11:38:10 AM ******/
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
/****** Object:  Table [Account].[SubCategories]    Script Date: 09/27/25 11:38:10 AM ******/
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
/****** Object:  Table [Account].[SubLedgers]    Script Date: 09/27/25 11:38:10 AM ******/
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
/****** Object:  Table [Account].[SubLedgerTypes]    Script Date: 09/27/25 11:38:10 AM ******/
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
/****** Object:  Table [Account].[SupplierGlobalLedgers]    Script Date: 09/27/25 11:38:10 AM ******/
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
/****** Object:  Table [Account].[VoucherMasterDetails]    Script Date: 09/27/25 11:38:10 AM ******/
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
/****** Object:  Table [Account].[VoucherMasters]    Script Date: 09/27/25 11:38:10 AM ******/
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
/****** Object:  Table [Account].[VoucherTypes]    Script Date: 09/27/25 11:38:10 AM ******/
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

```