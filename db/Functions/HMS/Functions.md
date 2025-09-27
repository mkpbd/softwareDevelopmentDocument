
```sql
USE [HMS]
GO
/****** Object:  UserDefinedFunction [Account].[fnGetProfitLossReportRetainedEarnings]    Script Date: 09/27/25 6:48:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [Account].[fnGetProfitLossReportRetainedEarnings]
(
	@FilterStartDate date,
	@FilterEndDate date
)
RETURNS float
AS
BEGIN

	--DECLARE @StatementBroadHeadsRevenuID int=2
	DECLARE @StatementBroadHeadsRevenuID uniqueidentifier ='00000000-0000-0000-0000-000000000000'
	DECLARE @StatementSubRevenueHead uniqueidentifier ='810914FC-E16C-4275-8687-0859E5EAE2EA'
	DECLARE @StatementSubOtherIncomeHead uniqueidentifier ='794B5D44-7B63-4020-BF88-004910DBF67D'
	DECLARE @RevenueNote nvarchar(max) ='Details'
	DECLARE @LessNote nvarchar(max) ='Details'
   DECLARE @StatementDepreciationHeadName nvarchar(max) ='Less Depreciation Expenses'

declare @TempSpGetProfitLossReport TABLE   
	(
		ReportOrderID int,
		StatementSubHeadID uniqueidentifier,
		
		Particulars nvarchar(max),
		[Note] nvarchar(max),
		[AmountinTaka] float
	)

	declare  @TempProfitLossDetailsReport table
	(
		ReportOrderID int,
		StatementSubHeadID uniqueidentifier,
		ReportType nvarchar(max),
		Particulars nvarchar(max),
		[Note] nvarchar(max),
		id uniqueidentifier,
		[NatuarofAccount] int,
		[AmountinTaka] float

	)


	insert into @TempProfitLossDetailsReport
	select 1 [ReportOrderID],sub.id, sub.Name [ReportType],  g.Name [Particulars], @RevenueNote [Note], g.Id,n.Id [NatuarofAccount], 0 [AmountinTaka]
	from [Account].[GLMappingWithStatements] gm  
	join [Account].[StatementSubHeads] sub on sub.Id = gm.StatementSubHeadId
	join [account].[StatementBroadHeads] bh on bh.Id = sub.StatementBroadHeadId
	join [Account].[GeneralLedgers] g on g.Id = gm.GeneralLedgerId
	join [Account].[Level5Heads] l5 on l5.Id = g.Level5HeadId
	join [Account].[Level4Heads] l4 on l4.Id = l5.Level4HeadId
	join [Account].[SubCategories] sc on sc.Id = l4.SubCategoryId
	join [Account].[Categories] c on c.Id = sc.CategoryId
	join [Account].[NatureOfAccounts] n on n.Id = c.NatueOfAccountId
	where bh.Id =@StatementBroadHeadsRevenuID and sub.id =@StatementSubRevenueHead
	group by g.Name ,  g.Id,sub.Name,sub.id,n.Id
	return 0

	
	insert into @TempProfitLossDetailsReport
	select 2 [ReportOrderID],sub.id,sub.Name [ReportType],  g.Name [Particulars], @RevenueNote [Note], g.Id,n.Id [NatuarofAccount], 0 [AmountinTaka]
	from [Account].[GLMappingWithStatements] gm  
	join [Account].[StatementSubHeads] sub on sub.Id = gm.StatementSubHeadId
	join [account].[StatementBroadHeads] bh on bh.Id = sub.StatementBroadHeadId
	join [Account].[GeneralLedgers] g on g.Id = gm.GeneralLedgerId
	join [Account].[Level5Heads] l5 on l5.Id = g.Level5HeadId
	join [Account].[Level4Heads] l4 on l4.Id = l5.Level4HeadId
	join [Account].[SubCategories] sc on sc.Id = l4.SubCategoryId
	join [Account].[Categories] c on c.Id = sc.CategoryId
	join [Account].[NatureOfAccounts] n on n.Id = c.NatueOfAccountId
	where bh.Id =@StatementBroadHeadsRevenuID and sub.id =@StatementSubOtherIncomeHead
	group by g.Name ,  g.Id,sub.Name,sub.id,n.Id

	insert into @TempProfitLossDetailsReport
	select 3 [ReportOrderID],sub.id, 'Less '+sub.Name [ReportType],  g.Name [Particulars], @LessNote [Note], g.Id ,n.id [NatuarofAccount], 0 [AmountinTaka]
	from [Account].[GLMappingWithStatements] gm  
	join [Account].[StatementSubHeads] sub on sub.Id = gm.StatementSubHeadId
	join [account].[StatementBroadHeads] bh on bh.Id = sub.StatementBroadHeadId
	join [Account].[GeneralLedgers] g on g.Id = gm.GeneralLedgerId
	join [Account].[Level5Heads] l5 on l5.Id = g.Level5HeadId
	join [Account].[Level4Heads] l4 on l4.Id = l5.Level4HeadId
	join [Account].[SubCategories] sc on sc.Id = l4.SubCategoryId
	join [Account].[Categories] c on c.Id = sc.CategoryId
	join [Account].[NatureOfAccounts] n on n.Id = c.NatueOfAccountId
	where bh.Id =@StatementBroadHeadsRevenuID and sub.id <> @StatementSubRevenueHead and sub.id <> @StatementSubOtherIncomeHead
	group by g.Name ,  g.Id,sub.Name,sub.id,n.Id

	

	declare @TempSpGetProfitLossIDAmount TABLE   
	(
		ID uniqueidentifier,
		[AmountinTaka] float
	)
	
		insert into @TempSpGetProfitLossIDAmount 
		select id, sum(Amount) [AmountinTaka] 
		from 
		(
			select t.id,
			case when t.ReportType =@StatementDepreciationHeadName then 0
			when t.[NatuarofAccount] =1 or t.[NatuarofAccount] =4 then  sum(debit)  -sum(credit) 
			else sum(credit)  -sum(debit) end Amount
			
				from [Account].[VoucherMasters] m
				join [Account].[VoucherMasterDetails] d on m.Id = d.VoucherMasterId
				join [Account].[GeneralLedgers] g on g.Id = d.GeneralLedgerId
				join @TempProfitLossDetailsReport t on t.id = g.Id
				
				where convert(date,m.PostingDate) >=@FilterStartdate
				and convert(date,m.PostingDate) <=@FilterEnddate
				group by t.[NatuarofAccount],t.ReportType,t.id
			)T
			group by T.id

			
	
	insert into @TempSpGetProfitLossReport
	select t.ReportOrderID,t.StatementSubHeadID,ReportType Particulars ,t.Note,sum(a.AmountinTaka) from @TempProfitLossDetailsReport t
	join @TempSpGetProfitLossIDAmount a on a.ID = t.id
	where t.ReportOrderID =1
	group by  t.ReportType,t.ReportOrderID,t.Note,t.StatementSubHeadID


	insert into @TempSpGetProfitLossReport
	select 2,null StatementSubHeadID,'Gross Profit/ (Loss)'	,Note,sum(a.AmountinTaka)
	from @TempProfitLossDetailsReport t
	join @TempSpGetProfitLossIDAmount a on a.ID = t.id
	where ReportOrderID =1
	group by  t.ReportType,t.ReportOrderID,t.Note,t.StatementSubHeadID


	insert into @TempSpGetProfitLossReport
	select t.ReportOrderID,t.StatementSubHeadID,ReportType Particulars ,t.Note,sum(a.AmountinTaka) from @TempProfitLossDetailsReport t
	join @TempSpGetProfitLossIDAmount a on a.ID = t.id
	where t.ReportOrderID =3
	group by  t.ReportType,t.ReportOrderID,t.Note,t.StatementSubHeadID

	


	insert into @TempSpGetProfitLossReport
	select 4 ReportType,null StatementSubHeadID,'Operating Profit/ (Loss)' Particular	,'' Note, sum(GrossAmount) - sum(AmountinTaka) [AmountinTaka]
	from 
	(
		
			select 0 ReportOrderID,'Gross Profit/ (Loss)' Particular,'0' note,0 AmountinTaka,sum(AmountinTaka) GrossAmount
			from @TempSpGetProfitLossReport t
			where t.Particulars ='Gross Profit/ (Loss)'
			

			union all
			
			select  t.ReportOrderID,ReportType Particulars ,t.Note,sum(a.AmountinTaka) AmountinTaka ,0  GrossAmount
			from @TempProfitLossDetailsReport t
			join @TempSpGetProfitLossIDAmount a on a.ID = t.id
			where ReportOrderID =3
			group by  t.ReportType,t.ReportOrderID,t.Note
	)T


	insert into @TempSpGetProfitLossReport
	select 5,null StatementSubHeadID,'Other Income','',isnull(sum(AmountinTaka),0) AmountinTaka
	from 
	(
	
	select t.ReportOrderID,ReportType Particulars ,t.Note,sum(a.AmountinTaka) AmountinTaka from @TempProfitLossDetailsReport t
	join @TempSpGetProfitLossIDAmount a on a.ID = t.id
	where t.ReportOrderID =2
	group by  t.ReportType,t.ReportOrderID,t.Note
	
	)T

	insert into @TempSpGetProfitLossReport
	select 6 ReportType,null StatementSubHeadID,'Net Profit/ (Loss) Before Tax' Particular	,'' Note,sum(Operation) - sum(OtherIncomeAmount) [AmountinTaka]
	from 
	(
		
			select 0 ReportOrderID,sum( AmountinTaka) Operation,0 OtherIncomeAmount
			from @TempSpGetProfitLossReport t
			where t.Particulars ='Operating Profit/ (Loss)'

			union all

			select 0 ReportOrderID,0 Operation,sum( a.AmountinTaka) OtherIncomeAmount
			from @TempProfitLossDetailsReport t
			join @TempSpGetProfitLossIDAmount a on a.ID = t.id
			where t.Particulars ='Other Income'
	)T

	insert into @TempSpGetProfitLossReport
	select 7 ReportType,null StatementSubHeadID,'Less: Income tax expenses' Particular	,'' Note,0 [AmountinTaka]
	 
	insert into @TempSpGetProfitLossReport
	select 8 ReportType,null StatementSubHeadID,'Net Profit/ (Loss) After Tax' Particular	,'' Note,sum(Beforetax) - sum(OtherIncomeAmount) [AmountinTaka]
	from 
	(
		
			select 0 ReportOrderID,sum( AmountinTaka) Beforetax,0 OtherIncomeAmount
			from @TempSpGetProfitLossReport t
			where t.Particulars ='Net Profit/ (Loss) Before Tax'

			union all

			select 0 ReportOrderID,0 Beforetax,sum( AmountinTaka) OtherIncomeAmount
			from @TempSpGetProfitLossReport t
			where t.Particulars ='Less: Income tax expenses'
	)T

	insert into @TempSpGetProfitLossReport
	select 9 ReportType,null StatementSubHeadID,'Less: Generel Reserve' Particular	,'' Note,0 [AmountinTaka]
	
	insert into @TempSpGetProfitLossReport
	select 10 ReportType,null StatementSubHeadID,'Total Profit or Loss' Particular	,'' Note,sum(aftertax) - sum(OtherGeneralAmount) [AmountinTaka]
	from 
	(
		
			select 0 ReportOrderID,sum( AmountinTaka) aftertax,0 OtherGeneralAmount
			from @TempSpGetProfitLossReport t
			where t.Particulars ='Net Profit/ (Loss) After Tax'

			union all

			select 0 ReportOrderID,0 aftertax,sum( AmountinTaka) OtherGeneralAmount
			from @TempSpGetProfitLossReport t
			where t.Particulars ='Less: Generel Reserve'
	)T
	return (select AmountinTaka from @TempSpGetProfitLossReport where  Particulars ='Total Profit or Loss')

END
GO
/****** Object:  UserDefinedFunction [Canteen].[FnGetAllProductName]    Script Date: 09/27/25 6:48:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






 CREATE     FUNCTION [Canteen].[FnGetAllProductName]
(
	@Type nvarchar(max),
	@MasterID bigint
)
RETURNS nvarchar(max)
AS
BEGIN
	DECLARE @AllProductName nvarchar(max)
	DECLARE @product_name nvarchar(max)

	set @AllProductName =''

	IF @Type ='Invoice' 
	BEGIN
		
			DECLARE cursor_product CURSOR
			FOR
				select i.Name from [Canteen].[Items] i
				join [Canteen].[SaleInvoiceDetails] d
					on d.ProductId = i.Id
				join [Canteen].[SaleInvoices] s
					on s.Id = d.InvoiceId
				where s.InvoiceNo = @MasterID
			OPEN cursor_product;
			FETCH NEXT FROM cursor_product INTO 
			@product_name; 
			WHILE @@FETCH_STATUS = 0
			BEGIN
					set  @AllProductName = @AllProductName +'; '+@product_name 
					FETCH NEXT FROM cursor_product INTO 
					@product_name; 
			END

			CLOSE cursor_product;
			DEALLOCATE cursor_product;
 
	END

	set @AllProductName = SUBSTRING(@AllProductName,2,len(@AllProductName))


	RETURN @AllProductName

END
GO
/****** Object:  UserDefinedFunction [Canteen].[FnGetItemWisePurchaseRate]    Script Date: 09/27/25 6:48:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






 CREATE     FUNCTION [Canteen].[FnGetItemWisePurchaseRate]
(
	--@ItemId bigint,
	--@SaleDate datetime
	@ItemID uniqueidentifier,
	--@ID uniqueIdentifier
	@DateInfo date
)
RETURNS Float
AS
BEGIN

	
	DECLARE @SaleDate datetime
	
	--set @SaleDate = '2023-12-26'

	DECLARE @PurchaseRate float
				select @PurchaseRate =
				case when sum(purchaseStock) = 0 then 0 else 
				convert(decimal(18,2),sum(Totalpuchaser)/sum(purchaseStock)) end 
				from
				(
						select
 						 d.Qty purchaseStock,
						 (d.Qty * d.PurchaseRate) Totalpuchaser
						 from 
						 Canteen.StockReceiveRecordDetails d
						 join Canteen.StockReceiveRecords m on m.Id = d.StockReceiveId
						 join Canteen.Items i on i.id = d.ItemId
						 and i.Id = @ItemID
						 where  convert(date,m.RDate ) <=@DateInfo
				)T
	--set  @PurchaseRate =15
	return @PurchaseRate

END



GO
/****** Object:  UserDefinedFunction [Canteen].[GetItemInvoiceAndMealTypesWise]    Script Date: 09/27/25 6:48:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     FUNCTION [Canteen].[GetItemInvoiceAndMealTypesWise] (@InvoiceNo bigint,
@ReportType nvarchar(max),
@MealTypeid uniqueIdentifier

) RETURNS nvarchar(1000) AS 
BEGIN 
DECLARE @AllItemName nvarchar(max)
DECLARE @AllRemarks nvarchar(max)
SET @AllItemName = ''
SET @AllRemarks =''
--(
--SELECT top 1 CabinNo
--FROM Hospital.RegRecords
--INNER JOIN Hospital.IPDPatientRecords ON Hospital.RegRecords.UHID = Hospital.IPDPatientRecords.UHID
--INNER JOIN Hospital.IPDCabinAllocationRecords ON Hospital.IPDPatientRecords.Id = Hospital.IPDCabinAllocationRecords.PatientId
--INNER JOIN Hospital.Cabins ON Hospital.IPDCabinAllocationRecords.CabinId = Hospital.Cabins.Id
--WHERE   Hospital.IPDPatientRecords.InvoiceNo = @AdmissionID 
--order by Hospital.IPDCabinAllocationRecords.AllocationDateTime desc
--)
DECLARE @ItemName varchar(max)
DECLARE @Remarks varchar(max)
IF @ReportType ='ItemAndQty'
BEGIN


DECLARE names_cursor CURSOR Read_Only
FOR
select i.Name +'['+ Convert(nvarchar(max),fdd.Qty) +']'
--from 
	--Canteen.SaleInvoices si
	--JOIN Canteen.SaleInvoiceDetails sid ON SID.InvoiceId=si.Id
	--JOIN canteen.Items i on i.Id  = sid.ProductId 
	--where si.InvoiceNo = @InvoiceNo

	from Canteen.SaleInvoices si
	JOIN Hospital.IPDPatientRecords ir ON ir.id=si.IPDPatientRecordId
	JOIN Canteen.IPDFoodIndents ii ON ii.IPDPatientId=ir.Id
	JOIN  Nutrition.FoodDeliverables fd ON fd.IPDFoodIndentId=ii.Id
	Join Nutrition.FoodDeliverableDetails fdd on fdd.FoodDeliverableId = fd.Id
	JOIN canteen.Items i on i.Id  = fdd.ItemId 
	JOIN Nutrition.MealTypes mt ON mt.id=fd.MealTypeId
	where  si.InvoiceNo = @InvoiceNo
	and (mt.id =@MealTypeid or @MealTypeid='00000000-0000-0000-0000-000000000000' )
	OPEN names_cursor FETCH NEXT
	FROM names_cursor INTO @ItemName WHILE @@Fetch_status = 0 BEGIN
			SET @AllItemName = @AllItemName +' '+@ItemName 
	FETCH NEXT
	FROM names_cursor INTO @ItemName END 
	CLOSE names_cursor 
	DEALLOCATE names_cursor 
	RETURN @AllItemName 
END
ELSE IF @ReportType ='IPDFoodIndentsReturn'
BEGIN


		DECLARE names_cursor CURSOR Read_Only
		FOR
		select distinct isnull(ii.remarks,'')
		 
			from 
	Canteen.SaleInvoices si
	JOIN Hospital.IPDPatientRecords ir ON ir.id=si.IPDPatientRecordId
	JOIN Canteen.IPDFoodIndents ii ON ii.IPDPatientId=ir.Id
			where si.InvoiceNo = @InvoiceNo

			OPEN names_cursor FETCH NEXT
			FROM names_cursor INTO @Remarks WHILE @@Fetch_status = 0 BEGIN
					SET @AllRemarks = @AllRemarks +' '+@Remarks 
			FETCH NEXT
			FROM names_cursor INTO @Remarks END 
			CLOSE names_cursor 
			DEALLOCATE names_cursor 
			RETURN @AllRemarks 


END 
return ''
	END
GO
/****** Object:  UserDefinedFunction [Canteen].[GetItemInvoiceWise]    Script Date: 09/27/25 6:48:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







 CREATE     FUNCTION [Canteen].[GetItemInvoiceWise] (@InvoiceNo bigint,
@ReportType nvarchar(max)

) RETURNS nvarchar(1000) AS 
BEGIN 
DECLARE @AllItemName nvarchar(max)
DECLARE @AllRemarks nvarchar(max)
SET @AllItemName = ''
SET @AllRemarks =''
--(
--SELECT top 1 CabinNo
--FROM Hospital.RegRecords
--INNER JOIN Hospital.IPDPatientRecords ON Hospital.RegRecords.UHID = Hospital.IPDPatientRecords.UHID
--INNER JOIN Hospital.IPDCabinAllocationRecords ON Hospital.IPDPatientRecords.Id = Hospital.IPDCabinAllocationRecords.PatientId
--INNER JOIN Hospital.Cabins ON Hospital.IPDCabinAllocationRecords.CabinId = Hospital.Cabins.Id
--WHERE   Hospital.IPDPatientRecords.InvoiceNo = @AdmissionID 
--order by Hospital.IPDCabinAllocationRecords.AllocationDateTime desc
--)
DECLARE @ItemName varchar(max)
DECLARE @Remarks varchar(max)
IF @ReportType ='ItemAndQty'
BEGIN


DECLARE names_cursor CURSOR Read_Only
FOR
select i.Name +'['+ Convert(nvarchar(max),fdd.Qty) +']'
--from 
	--Canteen.SaleInvoices si
	--JOIN Canteen.SaleInvoiceDetails sid ON SID.InvoiceId=si.Id
	--JOIN canteen.Items i on i.Id  = sid.ProductId 
	--where si.InvoiceNo = @InvoiceNo

	from Canteen.SaleInvoices si
	JOIN Hospital.IPDPatientRecords ir ON ir.id=si.IPDPatientRecordId
	--JOIN Canteen.IPDFoodIndents ii ON ii.IPDPatientId=ir.Id
	--JOIN  Nutrition.FoodDeliverables fd ON fd.IPDFoodIndentId=ii.Id
	Join Canteen.SaleInvoiceDetails  fdd on fdd.InvoiceId = si.Id
	JOIN canteen.Items i on i.Id  = fdd.[ProductId ] 
	where  si.InvoiceNo = @InvoiceNo

	OPEN names_cursor FETCH NEXT
	FROM names_cursor INTO @ItemName WHILE @@Fetch_status = 0 BEGIN
			SET @AllItemName = @AllItemName +' '+@ItemName 
	FETCH NEXT
	FROM names_cursor INTO @ItemName END 
	CLOSE names_cursor 
	DEALLOCATE names_cursor 
	RETURN @AllItemName 
END
ELSE IF @ReportType ='IPDFoodIndentsReturn'
BEGIN


		DECLARE names_cursor CURSOR Read_Only
		FOR
		select distinct isnull(ii.remarks,'')
		 
			from 
	Canteen.SaleInvoices si
	JOIN Hospital.IPDPatientRecords ir ON ir.id=si.IPDPatientRecordId
	JOIN Canteen.IPDFoodIndents ii ON ii.IPDPatientId=ir.Id
			where si.InvoiceNo = @InvoiceNo

			OPEN names_cursor FETCH NEXT
			FROM names_cursor INTO @Remarks WHILE @@Fetch_status = 0 BEGIN
					SET @AllRemarks = @AllRemarks +' '+@Remarks 
			FETCH NEXT
			FROM names_cursor INTO @Remarks END 
			CLOSE names_cursor 
			DEALLOCATE names_cursor 
			RETURN @AllRemarks 


END 
return ''
	END
GO
/****** Object:  UserDefinedFunction [dbo].[FN_SpCSVParamToListTable]    Script Date: 09/27/25 6:48:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







    
     CREATE     FUNCTION [dbo].[FN_SpCSVParamToListTable] (@InStr VARCHAR(MAX))
    RETURNS @TempTab TABLE (OrderNo int, [Value] NVARCHAR(max) NOT NULL)
    AS
    BEGIN
            ;-- Ensure input ends with comma
    
        Declare @orderId int= 1;

		SET @InStr = REPLACE(@InStr + ',', ',,', ',')
    
        DECLARE @SP INT
        DECLARE @VALUE VARCHAR(1000)
    
        WHILE PATINDEX('%,%', @INSTR) <> 0
        BEGIN
            SELECT @SP = PATINDEX('%,%', @INSTR)
    
            SELECT @VALUE = LEFT(@INSTR, @SP - 1)
    
            SELECT @INSTR = STUFF(@INSTR, 1, @SP, '')
    
            INSERT INTO @TempTab (OrderNo, Value)
            VALUES (@orderId, @VALUE)

			set @orderId=@orderId+1;
        END
    
        RETURN
    END
GO
/****** Object:  UserDefinedFunction [dbo].[fnSplitString]    Script Date: 09/27/25 6:48:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








 CREATE     FUNCTION [dbo].[fnSplitString] 
( 
    @string NVARCHAR(MAX), 
    @delimiter CHAR(1) 
) 
RETURNS @output TABLE(splitdata NVARCHAR(MAX) 
) 
BEGIN 
 
    DECLARE @start INT, @end INT 
    SELECT @start = 1, @end = CHARINDEX(@delimiter, @string) 
 
    WHILE @start < LEN(@string) + 1 BEGIN 
        IF @end = 0  
            SET @end = LEN(@string) + 1
       
        INSERT INTO @output (splitdata)  
        VALUES(SUBSTRING(@string, @start, @end - @start)) 
        SET @start = @end + 1 
        SET @end = CHARINDEX(@delimiter, @string, @start)
        
    END 
 
    RETURN 
 
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetCabinNumberAfterDischarge]    Script Date: 09/27/25 6:48:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







 CREATE     FUNCTION [dbo].[GetCabinNumberAfterDischarge] (@AdmissionID bigint) RETURNS nvarchar(1000) 
AS BEGIN 

DECLARE @AllCabinNumber nvarchar(1000)


SET @AllCabinNumber = 
(
SELECT top 1 CabinNo
FROM Hospital.RegRecords
INNER JOIN Hospital.IPDPatientRecords ON Hospital.RegRecords.UHID = Hospital.IPDPatientRecords.UHID
INNER JOIN Hospital.IPDCabinAllocationRecords ON Hospital.IPDPatientRecords.Id = Hospital.IPDCabinAllocationRecords.PatientId
INNER JOIN Hospital.Cabins ON Hospital.IPDCabinAllocationRecords.CabinId = Hospital.Cabins.Id
WHERE   Hospital.IPDPatientRecords.InvoiceNo = @AdmissionID and Hospital.Cabins.CabinTypeId<>'5E070277-BB3F-46AF-8FEB-422A47330C3D'
order by Hospital.IPDCabinAllocationRecords.AllocationDateTime desc
)


----DECLARE @CabinName varchar(50) DECLARE names_cursor
----  CURSOR Read_Only
----  FOR
----  SELECT ',E('+CabinNo+')'
----  FROM Hospital.RegRecords
----  INNER JOIN Hospital.IPDPatientRecords ON Hospital.RegRecords.UHID = Hospital.IPDPatientRecords.UHID
----  INNER JOIN Marketing.Doctors ON Hospital.IPDPatientRecords.AssignedDoctorId = Marketing.Doctors.Id
----  INNER JOIN Marketing.Doctors AS Doctor_1 ON Hospital.IPDPatientRecords.RefdDoctorId = Doctor_1.Id
----  INNER JOIN Hospital.IPDCabinAllocationRecords ON Hospital.IPDPatientRecords.id =Hospital.IPDCabinAllocationRecords.PatientId
----  INNER JOIN Hospital.Cabins ON Hospital.IPDCabinAllocationRecords.CabinId = Hospital.Cabins.Id 
----  WHERE Hospital.IPDPatientRecords.InvoiceNo = @AdmissionID
----  --AND Hospital.IPDCabinAllocationRecords.Status='Occupied'
----  --AND AllotType = 'ExtraBed' 
----  OPEN names_cursor FETCH NEXT
----  FROM names_cursor INTO @CabinName WHILE @@Fetch_status = 0 BEGIN
----SET @AllCabinNumber = @AllCabinNumber + @CabinName FETCH NEXT
----FROM names_cursor INTO @CabinName END CLOSE names_cursor DEALLOCATE names_cursor 
RETURN @AllCabinNumber END



GO
/****** Object:  UserDefinedFunction [dbo].[GetEmptyGuid]    Script Date: 09/27/25 6:48:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[GetEmptyGuid]()
RETURNS UNIQUEIDENTIFIER
AS
BEGIN
    RETURN '00000000-0000-0000-0000-00000000';
END;
GO
/****** Object:  UserDefinedFunction [Diag].[FnGetAllNormalValue]    Script Date: 09/27/25 6:48:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Diag].[FnGetAllNormalValue]
(
	@ReportParameterId bigint
)
RETURNS nvarchar(max)
AS
BEGIN
	DECLARE @AllNormalValue nvarchar(max)
	DECLARE @NormalValue nvarchar(max)
	DECLARE @AgeValue nvarchar(max)

	set @AllNormalValue =''

	
		
			DECLARE cursor_product CURSOR
			FOR
				select av.NormalValue,ag.Name [AgeValue]
				from Diag.AgeVariantNormalValues av 
				join Diag.ReportingAgeGroups ag on ag.Id = av.ReportingAgeGroupId
				where av.ReportParameterId = @ReportParameterId


			OPEN cursor_product;
			FETCH NEXT FROM cursor_product INTO 
			@NormalValue,@AgeValue; 
			WHILE @@FETCH_STATUS = 0
			BEGIN
					set  @AllNormalValue = @AllNormalValue +' '+ @AgeValue +' '+@NormalValue 
					FETCH NEXT FROM cursor_product INTO 
					@NormalValue,@AgeValue; 
			END

			CLOSE cursor_product;
			DEALLOCATE cursor_product;
 
	if @AllNormalValue is null or len(rtrim(ltrim(@AllNormalValue))) =0
	begin
			set @AllNormalValue = null
	end 
	else 
	begin
		set @AllNormalValue = SUBSTRING(@AllNormalValue,2,len(@AllNormalValue))
	end


	RETURN @AllNormalValue

END
GO
/****** Object:  UserDefinedFunction [Diag].[Get_Discount_BaseOn_TestID_PatientID]    Script Date: 09/27/25 6:48:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







 CREATE     FUNCTION [Diag].[Get_Discount_BaseOn_TestID_PatientID] 
(
	@PatientID uniqueidentifier,
	@TestID uniqueidentifier,
	@TestCost float=0
)
RETURNS float
AS
BEGIN
	
	DECLARE @TestDiscount float =0
	DECLARE @TotalDisount float =0
	DECLARE @TotalCost float =0
	
				select @TotalDisount= sum(pl.Credit) 
				from [Diag].[InvestigationInvoiceLedgers] pl 
				where pl.InvestigationInvoiceId = @PatientID
				and pl.TransactionType =1

				select @TotalCost = sum(C.TOTAL) from [Diag].[InvestigationInvoiceDetails] c 
				where c.InvestigationInvoiceId =@PatientID   AND ISNULL(C.IsCancelApproved,0) <> 1

				select @TestDiscount = (@TestCost * (@TotalDisount/@TotalCost))

	RETURN Round( isnull(@TestDiscount,0),2)
	

END
GO
/****** Object:  UserDefinedFunction [Diag].[GetAllMarketingCommisionJMOWisePatientID]    Script Date: 09/27/25 6:48:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     FUNCTION [Diag].[GetAllMarketingCommisionJMOWisePatientID]
(
	@InvoiceNo bigint,
	@PatientID UNIQUEIDENTIFIER
	
)
RETURNS float
AS
BEGIN
	
	DECLARE @CommissionAmount float =0
	DECLARE @TempCommissionAmount float =0

	

   
	
	DECLARE TestCommision_cursor CURSOR FOR  
	select (TC.Total *S.CommissionInPercent)/100  
	from Diag.InvestigationInvoices  p
	join Diag.InvestigationInvoiceDetails  tc on p.id = tc.InvestigationInvoiceId
	join Diag.TestItems  t on t.id = tc.TestItemId
	JOIN Marketing.MarketingJOfficerOrMedias j ON J.Id = P.MarketingJOfficerOrMediaId
	jOIN Marketing.CommissionGroups C ON C.Id = J.CommissionGroupId
	join Marketing.CommissionSetups S ON S.CommissionGroupId = C.Id AND S.TestItemId = T.Id
	where p.id =@PatientId and p.InvoiceNo =@InvoiceNo
	order by t.Name   
	    

	OPEN TestCommision_cursor
	FETCH NEXT FROM TestCommision_cursor INTO @TempCommissionAmount  
		WHILE @@FETCH_STATUS = 0
		BEGIN
			 set @CommissionAmount =@CommissionAmount + @TempCommissionAmount
			 FETCH NEXT FROM TestCommision_cursor INTO @TempCommissionAmount
		END
	CLOSE TestCommision_cursor;
	DEALLOCATE TestCommision_cursor; 


	RETURN @CommissionAmount
END


GO
/****** Object:  UserDefinedFunction [Diag].[GetAllTestNameByPatientID]    Script Date: 09/27/25 6:48:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   FUNCTION [Diag].[GetAllTestNameByPatientID]
(
	@PatientID UNIQUEIDENTIFIER,
	@QueryType nvarchar(max) ='WithPrice'
)
RETURNS nvarchar(max)
AS
BEGIN
	--DECLARE @PatientId bigint
	DECLARE @AllTestName nvarchar(max)
	DECLARE @TempTestName nvarchar(200)
	DECLARE @InvTestPrice float

	set @AllTestName =''
	set @TempTestName = ''
	
	--select @PatientId = P.PatientId from Patients P where P.BillNo = @BillNo

	

   IF @QueryType  ='WithPrice'
   BEGIN

			DECLARE TestName_cursor CURSOR FOR  
			select distinct t.Name,tc.Rate
			from Diag.InvestigationInvoices  p
			join Diag.InvestigationInvoiceDetails  tc on p.id = tc.InvestigationInvoiceId
			join Diag.TestItems  t on t.id = tc.TestItemId
			where p.id =@PatientId
			order by t.Name   
	    

			OPEN TestName_cursor
			FETCH NEXT FROM TestName_cursor INTO @TempTestName ,@InvTestPrice 
				WHILE @@FETCH_STATUS = 0
				BEGIN
					 set @AllTestName = @AllTestName +', ' + @TempTestName +'['+convert(nvarchar(max),@InvTestPrice) +'] '
					 FETCH NEXT FROM TestName_cursor INTO @TempTestName,@InvTestPrice
				END
			CLOSE TestName_cursor;
			DEALLOCATE TestName_cursor; 
   END 
   ELSE
   BEGIN
	DECLARE TestName_cursor CURSOR FOR  
	select distinct t.Name
	from Diag.InvestigationInvoices  p
	join Diag.InvestigationInvoiceDetails  tc on p.id = tc.InvestigationInvoiceId
	join Diag.TestItems  t on t.id = tc.TestItemId
	where p.id =@PatientId
	order by t.Name   
	    

	OPEN TestName_cursor
	FETCH NEXT FROM TestName_cursor INTO @TempTestName  
		WHILE @@FETCH_STATUS = 0
		BEGIN
			 set @AllTestName = @AllTestName +', ' + @TempTestName
			 FETCH NEXT FROM TestName_cursor INTO @TempTestName
		END
	CLOSE TestName_cursor;
	DEALLOCATE TestName_cursor; 

	END
	RETURN substring(@AllTestName,3,len(@AllTestName))
END

----==============================================================================

GO
/****** Object:  UserDefinedFunction [Hospital].[GetAllServiceNameByAdmissionID]    Script Date: 09/27/25 6:48:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






 CREATE     FUNCTION [Hospital].[GetAllServiceNameByAdmissionID]
(
	@AdmissionID UNIQUEIDENTIFIER
)
RETURNS nvarchar(max)
AS
BEGIN
	--DECLARE @PatientId bigint
	DECLARE @AllServiceName nvarchar(max)
	DECLARE @TempServiceName nvarchar(200)

	set @AllServiceName =''
	set @TempServiceName = ''
	
	--select @PatientId = P.PatientId from Patients P where P.BillNo = @BillNo

	

   
	
	DECLARE ServiceName_cursor CURSOR FOR  
	select distinct s.HeadName 
	from 	Hospital.IPDPatientRecords  p
			join Hospital.FinalBills   hb on hb.IPDPatientRecordId = p.id
			join Hospital.FinalBillSummarys  hd on hd.LastModifiedBy  = hb.id
			join Hospital.ServiceExecutingHeads  s on s.ServiceSubSubGroupId = hd.SummaryHeadId

	where p.id =@AdmissionID
	order by s.HeadName  
	    

	OPEN ServiceName_cursor
	FETCH NEXT FROM ServiceName_cursor INTO @TempServiceName  
		WHILE @@FETCH_STATUS = 0
		BEGIN
			 set @AllServiceName = @AllServiceName +', ' + @TempServiceName
			 FETCH NEXT FROM ServiceName_cursor INTO @TempServiceName
		END
	CLOSE ServiceName_cursor;
	DEALLOCATE ServiceName_cursor; 


	RETURN substring(@AllServiceName,3,len(@AllServiceName))
END
GO
/****** Object:  UserDefinedFunction [Hospital].[GetCabinNumber]    Script Date: 09/27/25 6:48:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







  -- select [Hospital].[GetCabinNumber]('F49BCE56-D2B8-4799-D351-08DCEE7C75A4')


   CREATE     FUNCTION [Hospital].[GetCabinNumber] (@AdmissionID uniqueidentifier) RETURNS nvarchar(1000) AS BEGIN DECLARE @AllCabinNumber nvarchar(1000) DECLARE @MaxAllocationId uniqueidentifier 
SET 
  @AllCabinNumber = '' 
Select 
  @MaxAllocationId = Id 
FROM 
  (
    select 
      Top(1) ca.Id 
    from 
      Hospital.IPDPatientRecords p 
      INNER JOIN Marketing.Doctors d ON p.AssignedDoctorId = d.Id 
      INNER JOIN Marketing.Doctors d2 ON p.RefdDoctorId = d2.Id 
      INNER JOIN Hospital.IPDCabinAllocationRecords ca ON p.Id = ca.PatientId 
      INNER JOIN Hospital.Cabins c ON ca.CabinId = c.Id 
	  INNer JOin Hospital.CabinTypes ct on ct.Id = c.CabinTypeId
    WHERE 
      ca.PatientId = @AdmissionID 
      and ct.CabinType <> 'Temporary Bed' 
    order by 
      ca.AllocationDateTime DESC
  ) T 
SELECT 
  @AllCabinNumber = 'P(' + CabinNo + ')' 
FROM 
  Hospital.IPDPatientRecords p 
  INNER JOIN Marketing.Doctors d ON p.AssignedDoctorId = d.Id 
  INNER JOIN Marketing.Doctors d2 ON p.RefdDoctorId = d2.Id 
  INNER JOIN Hospital.IPDCabinAllocationRecords ca ON p.Id = ca.PatientId 
  INNER JOIN Hospital.Cabins c ON ca.CabinId = c.Id 
WHERE 
  ca.Id = @MaxAllocationId -- Patient Bed
  DECLARE @CabinName varchar(50) DECLARE names_cursor CURSOR Read_Only FOR 
SELECT 
  ',E(' + CabinNo + ')' 
FROM 
  Hospital.IPDPatientRecords p 
  INNER JOIN Marketing.Doctors d ON p.AssignedDoctorId = d.Id 
  INNER JOIN Marketing.Doctors d2 ON p.RefdDoctorId = d2.Id 
  INNER JOIN Hospital.IPDCabinAllocationRecords ca ON p.Id = ca.PatientId 
  INNER JOIN Hospital.Cabins c ON ca.CabinId = c.Id 
WHERE 
  ca.PatientId = @AdmissionID 
  AND ca.IsOccupiedByPatient = 1 
  AND AllotType = 'EB' --Extra Bed  
  OPEN names_cursor FETCH next 
FROM 
  names_cursor INTO @CabinName WHILE @@Fetch_status = 0 BEGIN 
SET 
  @AllCabinNumber = @AllCabinNumber + @CabinName FETCH next 
FROM 
  names_cursor INTO @CabinName END CLOSE names_cursor DEALLOCATE names_cursor RETURN @AllCabinNumber  END

GO
/****** Object:  UserDefinedFunction [Hospital].[GetCabinNumber1]    Script Date: 09/27/25 6:48:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









 CREATE     FUNCTION [Hospital].[GetCabinNumber1] ( 
   @AdmissionID uniqueidentifier ) RETURNS nvarchar(1000) AS BEGIN 

DECLARE @AllCabinNumber nvarchar(1000) 
DECLARE @MaxAllocationId  uniqueidentifier

SET @AllCabinNumber ='' 


 Select @MaxAllocationId = Id FROM  ( select Top(1) ca.Id from Hospital.IPDPatientRecords p 
 INNER JOIN  Marketing.Doctors d ON p.AssignedDoctorId =d.Id 
 INNER JOIN Marketing.Doctors d2 ON p.RefdDoctorId = d2.Id 
 INNER JOIN  Hospital.IPDCabinAllocationRecords ca ON p.Id = ca.PatientId 
 INNER JOIN Hospital.Cabins c ON ca.CabinId = c.Id 
 WHERE ca.PatientId = @AdmissionID order by ca.AllocationDateTime DESC) T
 
 SELECT @AllCabinNumber = 'P('+CabinNo+')' FROM  Hospital.IPDPatientRecords p 
 INNER JOIN  Marketing.Doctors d ON p.AssignedDoctorId =d.Id 
 INNER JOIN Marketing.Doctors d2 ON p.RefdDoctorId = d2.Id 
 INNER JOIN  Hospital.IPDCabinAllocationRecords ca ON p.Id = ca.PatientId 
 INNER JOIN Hospital.Cabins c ON ca.CabinId = c.Id 
 WHERE ca.Id = @MaxAllocationId  -- Patient Bed
 
 DECLARE @CabinName varchar(50) DECLARE names_cursor CURSOR Read_Only FOR SELECT ',E('+CabinNo+')' 
 FROM Hospital.IPDPatientRecords p 
 INNER JOIN  Marketing.Doctors d ON p.AssignedDoctorId =d.Id 
 INNER JOIN Marketing.Doctors d2 ON p.RefdDoctorId = d2.Id 
 INNER JOIN  Hospital.IPDCabinAllocationRecords ca ON p.Id = ca.PatientId 
 INNER JOIN Hospital.Cabins c ON ca.CabinId = c.Id 
 WHERE ca.PatientId = @AdmissionID AND ca.IsOccupiedByPatient=1 AND AllotType ='EB'  --Extra Bed  
 
 OPEN names_cursor FETCH next FROM names_cursor INTO @CabinName WHILE @@Fetch_status = 0 
 BEGIN SET @AllCabinNumber = @AllCabinNumber + @CabinName 
      FETCH next FROM names_cursor INTO @CabinName END CLOSE names_cursor 
	      DEALLOCATE names_cursor 
    RETURN @AllCabinNumber END
GO
/****** Object:  UserDefinedFunction [HR].[fnSplit]    Script Date: 09/27/25 6:48:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







 CREATE     FUNCTION [HR].[fnSplit](

    @sInputList VARCHAR(8000) -- List of delimited items

  , @sDelimiter VARCHAR(8000) = ',' -- delimiter that separates items

) RETURNS @List TABLE (item VARCHAR(8000))



BEGIN

DECLARE @sItem VARCHAR(8000)

WHILE CHARINDEX(@sDelimiter,@sInputList,0) <> 0

 BEGIN

 SELECT

  @sItem=RTRIM(LTRIM(SUBSTRING(@sInputList,1,CHARINDEX(@sDelimiter,@sInputList,0)-1))),

  @sInputList=RTRIM(LTRIM(SUBSTRING(@sInputList,CHARINDEX(@sDelimiter,@sInputList,0)+LEN(@sDelimiter),LEN(@sInputList))))

 IF LEN(@sItem) > 0

  INSERT INTO @List SELECT @sItem

 END

IF LEN(@sInputList) > 0

 INSERT INTO @List SELECT @sInputList -- Put the last item in

RETURN

END
GO
/****** Object:  UserDefinedFunction [Payroll].[fnGetTotalDiductionDay]    Script Date: 09/27/25 6:48:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









 CREATE     FUNCTION [Payroll].[fnGetTotalDiductionDay]
(
	@Month int,
	@Year   int,
	@EmployeeID uniqueidentifier
)
RETURNS float
AS
BEGIN
 Declare @TotalDiddectionDay float

 set @TotalDiddectionDay =0

 Declare @FirstDayofthisMonth date
 DECLARE @LastDayofthisMOnth date
 DECLARE @CalculationDate date
 DECLARE @TargerInTime datetime
 DEClare @ActualInTime datetime
 DECLARE @HourDiff int
 DECLARE @MinIDTimedAttendanceLogs bigint

  set @FirstDayofthisMonth =convert(date,convert(varchar(4),@year)+'-'+convert(varchar(2),@month)+'-01')
  SELECT @LastDayofthisMOnth = DATEADD(DD,-(DAY(@FirstDayofthisMonth)), DATEADD(MM, 1, @FirstDayofthisMonth))

  --select @TotalDiddectionDay = DATEDIFF(day,@FirstDayofthisMonth,@LastDayofthisMOnth)
  set @TotalDiddectionDay =0

  set @CalculationDate = @FirstDayofthisMonth

  while(@CalculationDate<=@LastDayofthisMOnth)
  begin
		set @MinIDTimedAttendanceLogs =0
		set @CalculationDate = Dateadd(day,1,@CalculationDate)

		select @TargerInTime= DATEADD(mi, d.LateMinuteApproved ,cast( RoasterDate as datetime) + cast(InTime as datetime)) from HR.DutyRoasterSettings d where d.StaffRecordId = @EmployeeID and d.RoasterDate = @CalculationDate
		
		--select  @TargerInTime= DATEADD(mi,15,@TargerInTime)

		
		select @MinIDTimedAttendanceLogs = min(id) from Payroll.TimedAttendanceLogs t where t.StaffRecordId = @EmployeeID and BDate = @CalculationDate

		IF @MinIDTimedAttendanceLogs > 0
		BEGIN
			select @ActualInTime = t.InSortableDateTime  from Payroll.TimedAttendanceLogs t where id =@MinIDTimedAttendanceLogs --EmployeeId = @EmployeeID and BDate = @CalculationDate

			select @HourDiff=DATEDIFF(MINUTE,@TargerInTime,@ActualInTime)

			--if @HourDiff > 0
			--begin
			--	set @TotalDiddectionDay = @TotalDiddectionDay+ @HourDiff
			--end 

			if @HourDiff > 0 and @HourDiff < 60
			begin
				set @TotalDiddectionDay = @TotalDiddectionDay+ 1
			end
			else if @HourDiff> 60
			begin
				set @TotalDiddectionDay = @TotalDiddectionDay+ ROUND(@HourDiff/60,0) +1
			end

		END
  End



	RETURN  @TotalDiddectionDay


END
GO
/****** Object:  UserDefinedFunction [Payroll].[fnGetTotalMonthHour]    Script Date: 09/27/25 6:48:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









 CREATE     FUNCTION [Payroll].[fnGetTotalMonthHour]
(
	@Month int,
	@Year   int,
	@EmployeeID uniqueidentifier
)
RETURNS float
AS
BEGIN
 Declare @TotalDiddectionDay float

 set @TotalDiddectionDay =0

 Declare @FirstDayofthisMonth date
 DECLARE @LastDayofthisMOnth date
 DECLARE @CalculationDate date
 DECLARE @TargerInTime datetime
 DEClare @ActualInTime datetime
 DECLARE @HourDiff int
 DECLARE @MinIDTimedAttendanceLogs bigint

  set @FirstDayofthisMonth =convert(date,convert(varchar(4),@year)+'-'+convert(varchar(2),@month)+'-01')
  SELECT @LastDayofthisMOnth = DATEADD(DD,-(DAY(@FirstDayofthisMonth)), DATEADD(MM, 1, @FirstDayofthisMonth))
	set @CalculationDate = @FirstDayofthisMonth

  while(@CalculationDate<=@LastDayofthisMOnth)
  begin
		
		set @CalculationDate = Dateadd(day,1,@CalculationDate)

		select @MinIDTimedAttendanceLogs= min(d.Id) 
		from HR.DutyRoasterSettings d where d.StaffRecordId = @EmployeeID and d.RoasterDate = @CalculationDate
		
		if @MinIDTimedAttendanceLogs> 0
		BEGIN

				select @TargerInTime= cast( d.RoasterDate as datetime) + cast(d.InTime as datetime) 
				from HR.DutyRoasterSettings d where d.StaffRecordId = @EmployeeID and RoasterDate = @CalculationDate
		
				select @ActualInTime= cast( d.RoasterDate as datetime) + cast(d.OutTime as datetime) 
				from HR.DutyRoasterSettings d where d.StaffRecordId = @EmployeeID and RoasterDate = @CalculationDate

				select @HourDiff=DATEDIFF(hour,@TargerInTime,@ActualInTime)
		
				if @HourDiff > 0
					begin
						set @TotalDiddectionDay = @TotalDiddectionDay+ @HourDiff
					end
		END
  End



	RETURN  @TotalDiddectionDay


END
GO
/****** Object:  UserDefinedFunction [Pharmacy].[fnGetProductLedger]    Script Date: 09/27/25 6:48:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





---------------------------------------------------------------------------------------------------------------------------------------------------
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ fnGetProductLedger ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
---------------------------------------------------------------------------------------------------------------------------------------------------
 CREATE     FUNCTION [Pharmacy].[fnGetProductLedger]
(
	@FilterStartDate date,
	@FilterEndDate date,
	@OutletId UNIQUEIDENTIFIER,
	@ProductId UNIQUEIDENTIFIER
)
RETURNS float
AS
BEGIN

    DECLARE @CurrentStock   float,
	@ProductStock nvarchar(max),
	@ProductStockFilterEndDate nvarchar(max),
	@Char char ='#',
	@AvgCost char ='@',
	@Outlet char ='$',
	@LastChar char ='*'

	
	

	--return

	

	

		DECLARE @AvgCost_Vat char ='$'
	
		DECLARE @CurrentProduct_ID uniqueidentifier
		DECLARE @CurrentProduct_stock float
		DECLARE @FilterStartProductAvgCost float
		DECLARE @FilterEndProductAvgCost float
		DECLARE @FilterStartProductAvgCostVat float
		DECLARE @FilterEndProductAvgCostVat float
		DECLARE @OpeningOutletID nvarchar(max)

		
		
		declare @tempPharmacyStockInfoesDateWiseHistory TABLE   
		(

			[AutoId] [int] IDENTITY(1,1) NOT NULL,
			ProductWiseStock nvarchar(250)
		)
		
		declare @tempPharmacyStockWiseInfoesDateWiseHistory TABLE   
		(

		
			[AutoId] [int] IDENTITY(1,1) NOT NULL,
			FilterDate date,
			ProductID uniqueidentifier,
			FilterStartDateStock float,
			FilterEndDateStock float,
			FilterStartProductAvgCost float,
			OutletID uniqueidentifier
		)


		
		
		

		select @ProductStock= t.ProductStock from [Pharmacy].[PharmacyStockInfoesDateWiseHistories] t where t.FilterDate = @FilterStartDate
		
		



		insert into @tempPharmacyStockInfoesDateWiseHistory
			(ProductWiseStock)
			select * from dbo.fnSplitString(@ProductStock,',')

			


		

--==========================================================--
DECLARE @ProductCurrentStock nvarchar(max)

DECLARE cursor_product CURSOR
FOR 
	select  ProductWiseStock from @tempPharmacyStockInfoesDateWiseHistory order by AutoId

OPEN cursor_product;

FETCH NEXT FROM cursor_product INTO 
    @ProductCurrentStock;

WHILE @@FETCH_STATUS = 0
    BEGIN

		
select  @CurrentProduct_ID = SUBSTRING(@ProductCurrentStock,0,CHARINDEX(@Char,@ProductCurrentStock))
		select  @CurrentProduct_stock = convert(float, SUBSTRING(@ProductCurrentStock,CHARINDEX(@Char,@ProductCurrentStock)+1, 
		--len(@ProductCurrentStock) -CHARINDEX(@Char,@ProductCurrentStock)
		(CHARINDEX(@AvgCost,@ProductCurrentStock) - CHARINDEX(@Char,@ProductCurrentStock) -1 )

		))

				select  @FilterStartProductAvgCost = 
				convert(float, SUBSTRING(@ProductCurrentStock,CHARINDEX(@AvgCost,@ProductCurrentStock)+1, 
				--len(@ProductCurrentStock) -CHARINDEX(@AvgCost,@ProductCurrentStock)
				(CHARINDEX(@AvgCost_Vat,@ProductCurrentStock)) -(CHARINDEX(@AvgCost,@ProductCurrentStock)+1)
				))

				--print @ProductCurrentStock
				--print (CHARINDEX(@Outlet,@ProductCurrentStock))
				--print ( CHARINDEX(@LastChar,@ProductCurrentStock))
				select @OpeningOutletID = substring(@ProductCurrentStock,CHARINDEX(@Outlet,@ProductCurrentStock)+1,
				( CHARINDEX(@LastChar,@ProductCurrentStock) - (CHARINDEX(@Outlet,@ProductCurrentStock))-1 )
				
				)

				--print @ProductCurrentStock
				--print (CHARINDEX(@Outlet,@ProductCurrentStock))
				--print ( CHARINDEX(@LastChar,@ProductCurrentStock))
				select @OpeningOutletID = substring(@ProductCurrentStock,CHARINDEX(@Outlet,@ProductCurrentStock)+1,
				( CHARINDEX(@LastChar,@ProductCurrentStock) - (CHARINDEX(@Outlet,@ProductCurrentStock))-1 )
				
				)
				--print @OpeningOutletID

		insert into @tempPharmacyStockWiseInfoesDateWiseHistory
		(FilterDate,ProductID,FilterStartDateStock,FilterStartProductAvgCost,OutletID)
		select @FilterStartDate,Convert(uniqueidentifier, @CurrentProduct_ID),@CurrentProduct_stock,@FilterStartProductAvgCost,@OpeningOutletID

	  FETCH NEXT FROM cursor_product INTO 
		@ProductCurrentStock
	;
    END;

CLOSE cursor_product;

DEALLOCATE cursor_product;

--==========================================================--




DECLARE @OpeningQty float =0


select @OpeningQty = isnull(FilterStartDateStock,0) from @tempPharmacyStockWiseInfoesDateWiseHistory where ProductID =@ProductId
and OutletID = @OutletId


		return @OpeningQty
END


GO

```