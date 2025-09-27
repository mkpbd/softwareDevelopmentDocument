

```sql
USE [PMCH_Ph_Stock_Management_New]
GO
/****** Object:  View [dbo].[VWDoctors]    Script Date: 09/27/25 6:44:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE     VIEW [dbo].[VWDoctors]
AS
SELECT        Id, DoctorCodeNo, Name + CAST(CASE WHEN ProfessionalIdentity1 IS NULL THEN '' ELSE (',' + ProfessionalIdentity1) END AS nvarchar) + CAST(CASE WHEN ProfessionalIdentity2 IS NULL 
                         THEN '' ELSE (',' + ProfessionalIdentity2) END AS nvarchar) + CAST(CASE WHEN ProfessionalIdentity3 IS NULL THEN '' ELSE (',' + ProfessionalIdentity3) END AS nvarchar) + CAST(CASE WHEN ProfessionalIdentity4 IS NULL 
                         THEN '' ELSE (',' + ProfessionalIdentity4) END AS nvarchar) + CAST(CASE WHEN ProfessionalIdentity3 IS NULL THEN '' ELSE (',' + ProfessionalIdentity3) END AS nvarchar) + CAST(CASE WHEN ProfessionalIdentity5 IS NULL 
                         THEN '' ELSE (',' + ProfessionalIdentity5) END AS nvarchar) + CAST(CASE WHEN ProfessionalIdentity6 IS NULL THEN '' ELSE (',' + ProfessionalIdentity6) END AS nvarchar) AS Name, OPDChamberVisitFeeMaiden,
                         OPDChamberVisitFeeNew, OPDChamberVisitFeeOld, IsChamberPractitioner,ExtraAmount, IsActive
FROM            Marketing.Doctors
GO
/****** Object:  View [Hospital].[VWHospitalPatientDetails1]    Script Date: 09/27/25 6:44:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



---------------------------------------------------------------------------------------------------------------------------------------------------
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ VWHospitalPatientDetails1 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
---------------------------------------------------------------------------------------------------------------------------------------------------
CREATE       VIEW [Hospital].[VWHospitalPatientDetails1]
AS
WITH CteIPDPatient AS (SELECT Id, UHID, InvoicePrefix, InvoiceNo, FullName, AgeYear, AgeMonth, AgeDay, AdmissionDateTime, RefdDoctorId, AssignedDoctorId, AdmittedCabinId, Status, MarketingJOfficerOrMediaId, 
                                                                  ProbableDischargeDateTime, DischargedDateTime, CorporateClientId, DeptId, IsCCCHold, IsPharmacyClaimCleared, StaffRecordId, TenantId, AdmissionByUserId, DischargeByUserId, IsClearedForDischarge, 
                                                                  IsClearedFromPharmacy, IsClearedFromNurseStation, IsClearedFromDoD, IsCCHold, IsNotified, Remarks, MediaId, CreatedBy, CreatedOn, LastModifiedBy, LastModifiedOn, IsDeleted, IsSynced, 
                                                                  IsManualCabinDayCount, CabinChargeCalculationGracePeriodType, AdditionalDoctorIds, BillingMode,IsEMRLoaded,IsTransferredFromOrigin
                                                FROM      Hospital.IPDPatientRecords AS p
                                                WHERE   (DischargedDateTime < AdmissionDateTime) AND (DischargeByUserId = '00000000-0000-0000-0000-000000000000')), CtePateintDemographic AS
    (SELECT p.Id, p.UHID, p.InvoicePrefix, p.InvoiceNo, p.FullName, p.AgeYear, p.AgeMonth, p.AgeDay, p.AdmissionDateTime, p.RefdDoctorId, p.AssignedDoctorId, p.AdmittedCabinId, p.Status, p.MarketingJOfficerOrMediaId, 
                       p.ProbableDischargeDateTime, p.DischargedDateTime, p.CorporateClientId, p.DeptId, p.IsCCCHold, p.IsPharmacyClaimCleared, p.StaffRecordId, p.TenantId, p.AdmissionByUserId, p.DischargeByUserId, p.IsClearedForDischarge, 
                       p.IsClearedFromPharmacy, p.IsClearedFromNurseStation, p.IsClearedFromDoD, p.IsCCHold, p.IsNotified, p.Remarks, p.MediaId, p.CreatedBy, p.CreatedOn, p.LastModifiedBy, p.LastModifiedOn, p.IsDeleted, p.IsSynced, 
                       p.IsManualCabinDayCount, p.CabinChargeCalculationGracePeriodType, p.AdditionalDoctorIds, p.BillingMode, ISNULL(rr.PatientAddress, '') AS Address, ISNULL(rr.MobileNo, '') AS MobileNo, ISNULL(rr.Cpmobile, '') AS Cpmobile, 
                       ISNULL(rr.Sex, '') AS Sex, ISNULL(rr.MembershipType, '') AS MembershipType, ISNULL(rr.MaritalStatus, '') AS MaritalStatus, ISNULL(rr.Profession, '') AS Profession, ISNULL(rr.NationalId, '') AS NationalId, ISNULL(rr.FatherName, '') 
                       AS FatherName, ISNULL(rr.MotherName, '') AS MotherName, ISNULL(rr.PatientAddress, '') AS PatientAddress, ISNULL(rr.Cpname, '') AS Cpname, ISNULL(rr.Cpaddress, '') AS Cpaddress, ISNULL(rr.CareOf, '') AS CareOf, 
                       ISNULL(rr.RelationWithPatient, '') AS RelationWithPatient, ISNULL(rr.BloodGroup, '') AS BloodGroup, ISNULL(rr.CpnationalId, '') AS CpnationalId, ISNULL(rr.SpouseName, '') AS SpouseName, ISNULL(rr.Title, '') AS Title, 
                       ISNULL(rr.Religion, '') AS Religion, p.IsEMRLoaded, p.IsTransferredFromOrigin
     FROM      CteIPDPatient AS p INNER JOIN
                       Hospital.RegRecords AS rr ON p.UHID = rr.UHID and rr.IsDeleted = 0), CteSubLedger AS
    (SELECT DISTINCT Id AS SubLedgerId, InvoiceId, InvoiceNo
     FROM      Account.SubLedgers), CtePateintDemographicWithSubLedger AS
    (SELECT p.Id, p.UHID, p.InvoicePrefix, p.InvoiceNo, p.FullName, p.AgeYear, p.AgeMonth, p.AgeDay, p.AdmissionDateTime, p.RefdDoctorId, p.AssignedDoctorId, p.AdmittedCabinId, p.Status, p.MarketingJOfficerOrMediaId, 
                       p.ProbableDischargeDateTime, p.DischargedDateTime, p.CorporateClientId, p.DeptId, p.IsCCCHold, p.IsPharmacyClaimCleared, p.StaffRecordId, p.TenantId, p.AdmissionByUserId, p.DischargeByUserId, p.IsClearedForDischarge, 
                       p.IsClearedFromPharmacy, p.IsClearedFromNurseStation, p.IsClearedFromDoD, p.IsCCHold, p.IsNotified, p.Remarks, p.MediaId, p.CreatedBy, p.CreatedOn, p.LastModifiedBy, p.LastModifiedOn, p.IsDeleted, p.IsSynced, 
                       p.IsManualCabinDayCount, p.CabinChargeCalculationGracePeriodType, p.AdditionalDoctorIds, p.BillingMode, p.Address, p.MobileNo, p.Cpmobile, p.Sex, p.MembershipType, p.MaritalStatus, p.Profession, p.NationalId, p.FatherName, 
                       p.MotherName, p.PatientAddress, p.Cpname, p.Cpaddress, p.CareOf, p.RelationWithPatient, p.BloodGroup, p.CpnationalId, p.SpouseName, p.Title, p.Religion, l.SubLedgerId,p.IsEMRLoaded,p.IsTransferredFromOrigin
     FROM      CtePateintDemographic AS p LEFT OUTER JOIN
                       CteSubLedger AS l ON p.Id = l.InvoiceId), CtePateintDemographicWithSubLedgerAndAllocationRecords AS
    (SELECT p.Id, p.UHID, p.InvoicePrefix, p.InvoiceNo, p.FullName, p.AgeYear, p.AgeMonth, p.AgeDay, p.AdmissionDateTime, p.RefdDoctorId, p.AssignedDoctorId, p.AdmittedCabinId, p.Status, p.MarketingJOfficerOrMediaId, 
                       p.ProbableDischargeDateTime, p.DischargedDateTime, p.CorporateClientId, p.DeptId, p.IsCCCHold, p.IsPharmacyClaimCleared, p.StaffRecordId, p.TenantId, p.AdmissionByUserId, p.DischargeByUserId, p.IsClearedForDischarge, 
                       p.IsClearedFromPharmacy, p.IsClearedFromNurseStation, p.IsClearedFromDoD, p.IsCCHold, p.IsNotified, p.Remarks, p.MediaId, p.CreatedBy, p.CreatedOn, p.LastModifiedBy, p.LastModifiedOn, p.IsDeleted, p.IsSynced, 
                       p.IsManualCabinDayCount, p.CabinChargeCalculationGracePeriodType, p.AdditionalDoctorIds, p.BillingMode, p.Address, p.MobileNo, p.Cpmobile, p.Sex, p.MembershipType, p.MaritalStatus, p.Profession, p.NationalId, p.FatherName, 
                       p.MotherName, p.PatientAddress, p.Cpname, p.Cpaddress, p.CareOf, p.RelationWithPatient, p.BloodGroup, p.CpnationalId, p.SpouseName, p.Title, p.Religion, p.SubLedgerId, ca.Id AS AllotId, ca.CabinId, ca.AllotType, ISNULL(ca.Status, '') 
                       AS CabinStatus, p.DeptId AS CurrentDeptId, p.IsEMRLoaded,p.IsTransferredFromOrigin
     FROM      CtePateintDemographicWithSubLedger AS p INNER JOIN
                       Hospital.IPDCabinAllocationRecords AS ca ON p.Id = ca.PatientId
     WHERE   (ca.IsOccupiedByPatient = 1) AND (ca.AllotType = 'PAB'))

    SELECT Top(500) p.Id, ISNULL(p.InvoicePrefix, '') AS InvoicePrefix, p.InvoiceNo, p.UHID, p.FullName, p.Address, p.MobileNo, p.Cpmobile, 
                      ISNULL(CASE WHEN p.AgeYear <> '' THEN p.AgeYear + 'Y ' ELSE p.AgeYear END + CASE WHEN p.AgeMonth <> '' THEN p.AgeMonth + 'M ' ELSE p.AgeMonth END + CASE WHEN p.AgeDay <> '' THEN p.AgeDay + 'D' ELSE p.AgeDay END, '') 
                      AS Age, p.Sex, p.MembershipType, p.MaritalStatus, p.Profession, p.NationalId, p.AdmissionDateTime, p.DischargedDateTime, p.AssignedDoctorId, p.RefdDoctorId, ISNULL(d.Name, '') AS AssignedDoctorName, ISNULL(d2.Name, '') 
                      AS RefDoctorName, ISNULL(p.Status, '') AS Status, p.FatherName, p.MotherName, p.PatientAddress, p.Cpname, p.Cpaddress, ISNULL(p.AgeYear, '') AS AgeYear, ISNULL(p.AgeMonth, '') AS AgeMonth, ISNULL(p.AgeDay, '') AS AgeDay, 
                      p.CareOf, p.RelationWithPatient, p.BloodGroup, p.CpnationalId, p.SpouseName, p.AllotId, p.CabinId, p.AllotType, p.TenantId, c.FloorId, p.CabinStatus, ISNULL(Hospital.GetCabinNumber1(p.Id), '') AS CabinNo, ISNULL(ct.CabinType, '') 
                      AS CabinType, c.Id AS Expr1, ISNULL(dept.Name, '') AS DeptName, dept.Id AS HDepartmentId, p.BillingMode, p.ProbableDischargeDateTime, p.Title, p.IsPharmacyClaimCleared, p.AdmissionByUserId, c.CabinTypeId, ISNULL(u.UserName, 
                      '') AS UserName, p.IsClearedForDischarge, p.IsClearedFromPharmacy, p.IsClearedFromNurseStation, p.IsClearedFromDoD, p.IsCCHold, p.IsNotified, ISNULL(ma.Name, '') AS MarketingJOfficerOrMediaName, p.Religion, 
                      p.MarketingJOfficerOrMediaId, p.IsManualCabinDayCount, p.Remarks, c.DisplayOrder, ISNULL(p.SubLedgerId, '00000000-0000-0000-0000-000000000000') AS SubLedgerId, p.IsEMRLoaded,p.IsTransferredFromOrigin,
					  ISNULL(ap.PackageId, '00000000-0000-0000-0000-000000000000') AS PackageId
    FROM     CtePateintDemographicWithSubLedgerAndAllocationRecords AS p INNER JOIN
                      dbo.VWDoctors AS d ON p.AssignedDoctorId = d.Id INNER JOIN
                      dbo.VWDoctors AS d2 ON p.RefdDoctorId = d2.Id INNER JOIN
                      Hospital.Cabins AS c ON p.CabinId = c.Id INNER JOIN
                      Hospital.HDepartments AS dept ON p.CurrentDeptId = dept.Id INNER JOIN
                      Hospital.CabinTypes AS ct ON c.CabinTypeId = ct.Id LEFT OUTER JOIN
                      [Identity].Users AS u ON p.AdmissionByUserId = u.Id LEFT OUTER JOIN
                      Marketing.MarketingJOfficerOrMedias AS ma ON ma.Id = p.MarketingJOfficerOrMediaId left join
					  Hospital.AdmittedPackages ap on p.Id=ap.IPDPatientRecordId
	where ap.IsOccupiedByPatient is null or ap.IsOccupiedByPatient=1
    ORDER BY p.InvoiceNo
GO
/****** Object:  View [dbo].[ViewTotalStockInWithoutLot]    Script Date: 09/27/25 6:44:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     VIEW [dbo].[ViewTotalStockInWithoutLot]
AS
SELECT        srd.BrandExtensionId, sr.OutLetId, SUM(srd.Qty) AS TotalStockIn, SUM(srd.Qty * srd.PurchaseRate) / SUM(srd.Qty) AS PurchaseAvgRate
FROM            Pharmacy.StockReceives AS sr INNER JOIN
                         Pharmacy.StockReceiveDetails AS srd ON sr.Id = srd.StockReceiveId
WHERE        (sr.OPDReturnBillId IN ('00000000-0000-0000-0000-000000000000'))
GROUP BY srd.BrandExtensionId, sr.OutLetId
having SUM(srd.Qty) >0
GO
/****** Object:  View [Pharmacy].[ViewTotalStockOut]    Script Date: 09/27/25 6:44:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE     VIEW [Pharmacy].[ViewTotalStockOut]
AS
SELECT id.BrandExtensionId, i.MedicineOutLetId, id.LotRecordId, SUM(id.Qty) AS TotalStockOut
FROM     Pharmacy.Invoices AS i INNER JOIN
                  Pharmacy.InvoiceDetails AS id ON i.Id = id.InvoiceId
WHERE  (i.ServeTypeId NOT IN (14))
GROUP BY id.BrandExtensionId, i.MedicineOutLetId, id.LotRecordId
GO
/****** Object:  View [dbo].[ViewCurrentStockWithoutLot]    Script Date: 09/27/25 6:44:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE     VIEW [dbo].[ViewCurrentStockWithoutLot]
AS
SELECT        stIn.BrandExtensionId, stIn.OutLetId, SUM(ISNULL(stIn.TotalStockIn, 0)) - SUM(ISNULL(stOut.TotalStockOut, 0)) AS CurrentStock, ISNULL(AVG(stIn.PurchaseAvgRate), 0) AS PurchaseAvgRate
FROM            dbo.ViewTotalStockInWithoutLot AS stIn LEFT OUTER JOIN
                         Pharmacy.ViewTotalStockOut AS stOut ON stIn.BrandExtensionId = stOut.BrandExtensionId AND stIn.OutLetId = stOut.MedicineOutLetId
GROUP BY stIn.BrandExtensionId, stIn.OutLetId
GO
/****** Object:  View [Pharmacy].[BrandDetails]    Script Date: 09/27/25 6:44:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE     VIEW [Pharmacy].[BrandDetails]
AS
SELECT        bext.Id AS ProductId, f.ShortFormation + ' - ' + bn.Name + ' ' + ISNULL(s.Value, '') + ' ' + ISNULL(bext.Unit, '') AS ProductName, g.Name AS Generic, bext.GenericId, m.Name AS Manufacturer, bext.PurchasePrice, bext.SalePrice, 
                         bext.PkgUnit, bext.QtyPerBox, bn.ManufacturerId, f.Id AS FormationId, bext.IsActive
						 -- , sup.Id AS SupllierId
FROM            Pharmacy.BrandNames AS bn INNER JOIN
                         Pharmacy.BrandExtensions AS bext ON bn.Id = bext.BrandId INNER JOIN
                         Pharmacy.Formations AS f ON bext.FormationId = f.Id LEFT OUTER JOIN
                         Pharmacy.Strengths AS s ON bext.StrengthId = s.Id INNER JOIN
                         Pharmacy.Generics AS g ON bext.GenericId = g.Id INNER JOIN
                         Pharmacy.Manufacturers AS m ON bn.ManufacturerId = m.Id 
						 -- LEFT OUTER JOIN [SupplyChain ].Suppliers AS sup ON bn.ManufacturerId = CONVERT(uniqueidentifier, sup.ManufacturerId)
GO
/****** Object:  View [dbo].[ViewBrandAndStockDetailsWithoutlot]    Script Date: 09/27/25 6:44:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewBrandAndStockDetailsWithoutlot]
AS
SELECT   bd.ProductId, bd.ProductName, '00000000-0000-0000-0000-000000000000' AS LotId, '' AS BatchNo, NULL AS ExpireDate, ISNULL(cs.CurrentStock, 0) AS CurrentStock, ISNULL(cs.PurchaseAvgRate, 0) AS PurchaseAvgRate, bd.PurchasePrice, bd.SalePrice, bd.Manufacturer, bd.Generic, bd.GenericId, bd.PkgUnit, bd.QtyPerBox, ISNULL(ro.ROL, 0) 
             AS ROL, ISNULL(cs.OutLetId, '00000000-0000-0000-0000-000000000000') AS OutLetId, bd.ManufacturerId
FROM     Pharmacy.BrandDetails AS bd LEFT OUTER JOIN
             dbo.ViewCurrentStockWithoutLot AS cs ON bd.ProductId = cs.BrandExtensionId LEFT OUTER JOIN
             Pharmacy.ROLRecords AS ro ON bd.ProductId = ro.BrandExtensionId
GO
/****** Object:  View [Canteen].[ProductWiseReceiveDetails]    Script Date: 09/27/25 6:44:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE     VIEW [Canteen].[ProductWiseReceiveDetails]
AS
SELECT        ItemId, SUM(Qty) AS TotalReceive,sr.CanteenOutletId
FROM          Canteen.StockReceiveRecords sr inner join  Canteen.StockReceiveRecordDetails srd on sr.Id=srd.StockReceiveId
GROUP BY ItemId,sr.CanteenOutletId
GO
/****** Object:  View [Canteen].[ProductWiseSaleDetails]    Script Date: 09/27/25 6:44:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE     VIEW [Canteen].[ProductWiseSaleDetails]
AS
SELECT        ProductId, SUM(Qty) AS TotalSoldQty,si.CanteenOutletId
FROM          Canteen.SaleInvoices si left join  Canteen.SaleInvoiceDetails sid on si.Id=sid.InvoiceId
WHERE si.IsDeleted=0
GROUP BY ProductId,si.CanteenOutletId
GO
/****** Object:  View [Canteen].[ProductWiseTransferDetails]    Script Date: 09/27/25 6:44:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE     VIEW [Canteen].[ProductWiseTransferDetails]
AS
SELECT  srd.ItemId,
	SUM(srd.TransferQty) AS TotalTransfer, 
	sr.FromOutletId
	FROM Canteen.CanteenStockTransfers AS sr 
	INNER JOIN Canteen.CanteenStockTransferDetails AS srd ON sr.Id = srd.CanteenStockTransferId
	WHERE (sr.Status = 'Accepted')
	GROUP BY srd.ItemId, sr.FromOutletId
GO
/****** Object:  View [Canteen].[CurrentStockCalculation]    Script Date: 09/27/25 6:44:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE     VIEW [Canteen].[CurrentStockCalculation]
AS
SELECT 
  rd.ItemId, 
  rd.TotalReceive - ISNULL(
    sd.TotalSoldQty, 
    0
  ) - ISNULL(
    td.TotalTransfer, 
    0
  ) AS Stock, 
  isnull(
    rd.CanteenOutletId, 
    sd.CanteenOutletId
  ) CanteenOutletId 
FROM 
  Canteen.ProductWiseReceiveDetails rd
  LEFT OUTER JOIN Canteen.ProductWiseSaleDetails sd ON rd.ItemId = sd.ProductId and rd.CanteenOutletId = sd.CanteenOutletId
  LEFT OUTER JOIN Canteen.ProductWiseTransferDetails td ON td.ItemId = rd.ItemId and rd.CanteenOutletId = td.FromOutletId
GO
/****** Object:  View [Canteen].[ViewStock]    Script Date: 09/27/25 6:44:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    VIEW [Canteen].[ViewStock]
AS
SELECT  --TOP 200
  item.Id, 
  item.GroupId,
  item.Name, 
  ISNULL(sc.Stock, 0) AS Stock, 
  item.PurchaseRate, 
  item.GenaralSaleRate, 
  item.StaffSaleRate, 
  ISNULL(item.Unit, '') AS Unit, 
  item.VatInPercent, 
  item.ItemCode, 
  item.ProductionRate, 
  isnull(sc.CanteenOutletId,'00000000-0000-0000-0000-000000000000') CanteenOutletId,
  isnull(o.Name,'') OutletName,
  item.IsActive
FROM  
  Canteen.Items AS item 
  LEFT OUTER JOIN Canteen.CurrentStockCalculation AS sc ON item.Id = sc.ItemId
  left join Canteen.CanteenOutlets o on o.Id = sc.CanteenOutletId
  where item.IsActive = 1
GO
/****** Object:  View [Pharmacy].[ViewTotalStockIn]    Script Date: 09/27/25 6:44:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE     VIEW [Pharmacy].[ViewTotalStockIn]
AS
SELECT        srd.BrandExtensionId, sr.OutLetId, srd.LotRecordId, SUM(srd.Qty) AS TotalStockIn
FROM            Pharmacy.StockReceives AS sr INNER JOIN
                         Pharmacy.StockReceiveDetails AS srd ON sr.Id = srd.StockReceiveId
WHERE        (sr.OPDReturnBillId IN ('00000000-0000-0000-0000-000000000000'))
GROUP BY srd.BrandExtensionId, sr.OutLetId, srd.LotRecordId
GO
/****** Object:  View [Pharmacy].[ViewCurrentStock]    Script Date: 09/27/25 6:44:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE     VIEW [Pharmacy].[ViewCurrentStock]
AS
SELECT        stIn.BrandExtensionId, stIn.OutLetId, stIn.LotRecordId, SUM(ISNULL(stIn.TotalStockIn, 0)) - SUM(ISNULL(stOut.TotalStockOut, 0)) AS CurrentStock
FROM            Pharmacy.ViewTotalStockIn AS stIn LEFT OUTER JOIN
                         Pharmacy.ViewTotalStockOut AS stOut ON stIn.BrandExtensionId = stOut.BrandExtensionId AND stIn.LotRecordId = stOut.LotRecordId AND stIn.OutLetId = stOut.MedicineOutLetId
GROUP BY stIn.BrandExtensionId, stIn.OutLetId, stIn.LotRecordId
Having  SUM(ISNULL(stIn.TotalStockIn, 0)) - SUM(ISNULL(stOut.TotalStockOut, 0)) >= 0
GO
/****** Object:  View [Pharmacy].[ViewBrandAndStockDetails]    Script Date: 09/27/25 6:44:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ ViewBrandAndStockDetails ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-------------------------------------------------------------------------------------------------------------------------------------------------*/
CREATE VIEW [Pharmacy].[ViewBrandAndStockDetails]
AS
SELECT        bd.ProductId, bd.ProductName, ISNULL(lr.Id, '00000000-0000-0000-0000-000000000000') AS LotId, ISNULL(lr.BatchNo, '') AS BatchNo, ISNULL(lr.ExpireDate, '') AS ExpireDate, ISNULL(cs.CurrentStock, 0) AS CurrentStock, 
                         bd.PurchasePrice, bd.SalePrice, bd.Manufacturer, bd.Generic, bd.GenericId, bd.PkgUnit, bd.QtyPerBox, ISNULL(ro.ROL, 0) AS ROL, ISNULL(cs.OutLetId, '00000000-0000-0000-0000-000000000000') AS OutLetId, 
                         bd.ManufacturerId, bd.FormationId, bd.IsActive, cs.OutLetId AS Expr1
FROM            Pharmacy.BrandDetails AS bd LEFT OUTER JOIN
                         Pharmacy.ViewCurrentStock AS cs ON bd.ProductId = cs.BrandExtensionId LEFT OUTER JOIN
                         Pharmacy.LotRecords AS lr ON cs.LotRecordId = lr.Id LEFT OUTER JOIN
                         Pharmacy.ROLRecords AS ro ON bd.ProductId = ro.BrandExtensionId AND cs.OutLetId = ro.OutletId
WHERE        (bd.IsActive = 1)
GO
/****** Object:  View [Pharmacy].[BrandDetailsWithSupplier]    Script Date: 09/27/25 6:44:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE     VIEW [Pharmacy].[BrandDetailsWithSupplier]
AS
SELECT        bext.Id AS ProductId, f.ShortFormation + ' - ' + bn.Name + ' ' + ISNULL(s.Value, '') + ' ' + ISNULL(bext.Unit, '') AS ProductName, g.Name AS Generic, bext.GenericId, m.Name AS Manufacturer, bext.PurchasePrice, bext.SalePrice, 
                         bext.PkgUnit, bext.QtyPerBox, bn.ManufacturerId, f.Id AS FormationId, bext.IsActive, sup.Id AS SupllierId
FROM            Pharmacy.BrandNames AS bn INNER JOIN
                         Pharmacy.BrandExtensions AS bext ON bn.Id = bext.BrandId INNER JOIN
                         Pharmacy.Formations AS f ON bext.FormationId = f.Id LEFT OUTER JOIN
                         Pharmacy.Strengths AS s ON bext.StrengthId = s.Id INNER JOIN
                         Pharmacy.Generics AS g ON bext.GenericId = g.Id INNER JOIN
                         Pharmacy.Manufacturers AS m ON bn.ManufacturerId = m.Id LEFT OUTER JOIN
                         [SupplyChain ].Suppliers AS sup ON bn.ManufacturerId = CONVERT(uniqueidentifier, sup.ManufacturerId)
GO
/****** Object:  View [Pharmacy].[ViewBrandAndStockDetailsWithSupplier]    Script Date: 09/27/25 6:44:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








/*-------------------------------------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ ViewBrandAndStockDetails ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-------------------------------------------------------------------------------------------------------------------------------------------------*/
CREATE     VIEW [Pharmacy].[ViewBrandAndStockDetailsWithSupplier]
AS
SELECT        bd.ProductId, bd.ProductName, ISNULL(lr.Id, '00000000-0000-0000-0000-000000000000') AS LotId, ISNULL(lr.BatchNo, '') AS BatchNo, ISNULL(lr.ExpireDate, '') AS ExpireDate, ISNULL(cs.CurrentStock, 0) AS CurrentStock, 
                         bd.PurchasePrice, bd.SalePrice, bd.Manufacturer, bd.Generic, bd.GenericId, bd.PkgUnit, bd.QtyPerBox, ISNULL(ro.ROL, 0) AS ROL, ISNULL(cs.OutLetId, '00000000-0000-0000-0000-000000000000') AS OutLetId, 
                         bd.ManufacturerId, bd.FormationId, bd.IsActive, bd.SupllierId
FROM            Pharmacy.BrandDetailsWithSupplier AS bd LEFT OUTER JOIN
                         Pharmacy.ViewCurrentStock AS cs ON bd.ProductId = cs.BrandExtensionId LEFT OUTER JOIN
                         Pharmacy.LotRecords AS lr ON cs.LotRecordId = lr.Id LEFT OUTER JOIN
                         Pharmacy.ROLRecords AS ro ON bd.ProductId = ro.BrandExtensionId AND cs.OutLetId = ro.OutletId
WHERE        (bd.IsActive = 1)
GO
/****** Object:  View [Hospital].[VWHospitalPatientDetails]    Script Date: 09/27/25 6:44:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*-------------------------------------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ VWHospitalPatientDetails ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-------------------------------------------------------------------------------------------------------------------------------------------------*/
CREATE     VIEW [Hospital].[VWHospitalPatientDetails]
AS
	WITH CteSubLedger AS (
	  SELECT 
		DISTINCT Id AS SubLedgerId, 
		InvoiceId, 
		InvoiceNo 
	  FROM 
		Account.SubLedgers
	), 
	CteIPDPatient AS (
	  SELECT 
		Id, 
		UHID, 
		InvoicePrefix, 
		InvoiceNo, 
		FullName, 
		AgeYear, 
		AgeMonth, 
		AgeDay, 
		AdmissionDateTime, 
		RefdDoctorId, 
		AssignedDoctorId, 
		AdmittedCabinId, 
		Status, 
		MarketingJOfficerOrMediaId, 
		ProbableDischargeDateTime, 
		DischargedDateTime, 
		CorporateClientId, 
		DeptId, 
		IsCCCHold, 
		IsPharmacyClaimCleared, 
		StaffRecordId, 
		TenantId, 
		AdmissionByUserId, 
		DischargeByUserId, 
		IsClearedForDischarge, 
		IsClearedFromPharmacy, 
		IsClearedFromNurseStation, 
		IsClearedFromDoD, 
		IsCCHold, 
		IsNotified, 
		Remarks, 
		MediaId, 
		CreatedBy, 
		CreatedOn, 
		LastModifiedBy, 
		LastModifiedOn, 
		IsDeleted, 
		IsSynced, 
		IsManualCabinDayCount, 
		CabinChargeCalculationGracePeriodType, 
		AdditionalDoctorIds, 
		BillingMode, 
		IsEMRLoaded, 
		IsTransferredFromOrigin 
	  FROM 
		Hospital.IPDPatientRecords AS p 
	  WHERE 
		(
		  DischargedDateTime < AdmissionDateTime
		) 
		AND (
		  DischargeByUserId = '00000000-0000-0000-0000-000000000000'
		)
	), 
	CtePateintDemographic AS (
	  SELECT 
		p.Id, 
		p.UHID, 
		p.InvoicePrefix, 
		p.InvoiceNo, 
		p.FullName, 
		p.AgeYear, 
		p.AgeMonth, 
		p.AgeDay, 
		p.AdmissionDateTime, 
		p.RefdDoctorId, 
		p.AssignedDoctorId, 
		p.AdmittedCabinId, 
		p.Status, 
		p.MarketingJOfficerOrMediaId, 
		p.ProbableDischargeDateTime, 
		p.DischargedDateTime, 
		p.CorporateClientId, 
		p.DeptId, 
		p.IsCCCHold, 
		p.IsPharmacyClaimCleared, 
		p.StaffRecordId, 
		p.TenantId, 
		p.AdmissionByUserId, 
		p.DischargeByUserId, 
		p.IsClearedForDischarge, 
		p.IsClearedFromPharmacy, 
		p.IsClearedFromNurseStation, 
		p.IsClearedFromDoD, 
		p.IsCCHold, 
		p.IsNotified, 
		p.Remarks, 
		p.MediaId, 
		p.CreatedBy, 
		p.CreatedOn, 
		p.LastModifiedBy, 
		p.LastModifiedOn, 
		p.IsDeleted, 
		p.IsSynced, 
		p.IsManualCabinDayCount, 
		p.CabinChargeCalculationGracePeriodType, 
		p.AdditionalDoctorIds, 
		p.BillingMode, 
		ISNULL(rr.PatientAddress, '') AS Address, 
		ISNULL(rr.MobileNo, '') AS MobileNo, 
		ISNULL(rr.Cpmobile, '') AS Cpmobile, 
		ISNULL(rr.Sex, '') AS Sex, 
		ISNULL(rr.MembershipType, '') AS MembershipType, 
		ISNULL(rr.MaritalStatus, '') AS MaritalStatus, 
		ISNULL(rr.Profession, '') AS Profession, 
		ISNULL(rr.NationalId, '') AS NationalId, 
		ISNULL(rr.FatherName, '') AS FatherName, 
		ISNULL(rr.MotherName, '') AS MotherName, 
		ISNULL(rr.PatientAddress, '') AS PatientAddress, 
		ISNULL(rr.Cpname, '') AS Cpname, 
		ISNULL(rr.Cpaddress, '') AS Cpaddress, 
		ISNULL(rr.CareOf, '') AS CareOf, 
		ISNULL(rr.RelationWithPatient, '') AS RelationWithPatient, 
		ISNULL(rr.BloodGroup, '') AS BloodGroup, 
		ISNULL(rr.CpnationalId, '') AS CpnationalId, 
		ISNULL(rr.SpouseName, '') AS SpouseName, 
		ISNULL(rr.Title, '') AS Title, 
		ISNULL(rr.Religion, '') AS Religion, 
		p.IsEMRLoaded, 
		p.IsTransferredFromOrigin 
	  FROM 
		CteIPDPatient AS p 
		INNER JOIN Hospital.RegRecords AS rr ON p.UHID = rr.UHID 
		and rr.IsDeleted = 0
	), 
	CtePateintDemographicWithSubLedger AS (
	  SELECT 
		p.Id, 
		p.UHID, 
		p.InvoicePrefix, 
		p.InvoiceNo, 
		p.FullName, 
		p.AgeYear, 
		p.AgeMonth, 
		p.AgeDay, 
		p.AdmissionDateTime, 
		p.RefdDoctorId, 
		p.AssignedDoctorId, 
		p.AdmittedCabinId, 
		p.Status, 
		p.MarketingJOfficerOrMediaId, 
		p.ProbableDischargeDateTime, 
		p.DischargedDateTime, 
		p.CorporateClientId, 
		p.DeptId, 
		p.IsCCCHold, 
		p.IsPharmacyClaimCleared, 
		p.StaffRecordId, 
		p.TenantId, 
		p.AdmissionByUserId, 
		p.DischargeByUserId, 
		p.IsClearedForDischarge, 
		p.IsClearedFromPharmacy, 
		p.IsClearedFromNurseStation, 
		p.IsClearedFromDoD, 
		p.IsCCHold, 
		p.IsNotified, 
		p.Remarks, 
		p.MediaId, 
		p.CreatedBy, 
		p.CreatedOn, 
		p.LastModifiedBy, 
		p.LastModifiedOn, 
		p.IsDeleted, 
		p.IsSynced, 
		p.IsManualCabinDayCount, 
		p.CabinChargeCalculationGracePeriodType, 
		p.AdditionalDoctorIds, 
		p.BillingMode, 
		p.Address, 
		p.MobileNo, 
		p.Cpmobile, 
		p.Sex, 
		p.MembershipType, 
		p.MaritalStatus, 
		p.Profession, 
		p.NationalId, 
		p.FatherName, 
		p.MotherName, 
		p.PatientAddress, 
		p.Cpname, 
		p.Cpaddress, 
		p.CareOf, 
		p.RelationWithPatient, 
		p.BloodGroup, 
		p.CpnationalId, 
		p.SpouseName, 
		p.Title, 
		p.Religion, 
		l.SubLedgerId, 
		p.IsEMRLoaded, 
		p.IsTransferredFromOrigin 
	  FROM 
		CtePateintDemographic AS p 
		LEFT OUTER JOIN CteSubLedger AS l ON p.Id = l.InvoiceId
	), 
	CtePateintDemographicWithSubLedgerAndAllocationRecords AS (
	  SELECT 
		p.Id, 
		p.UHID, 
		p.InvoicePrefix, 
		p.InvoiceNo, 
		p.FullName, 
		p.AgeYear, 
		p.AgeMonth, 
		p.AgeDay, 
		p.AdmissionDateTime, 
		p.RefdDoctorId, 
		p.AssignedDoctorId, 
		p.AdmittedCabinId, 
		p.Status, 
		p.MarketingJOfficerOrMediaId, 
		p.ProbableDischargeDateTime, 
		p.DischargedDateTime, 
		p.CorporateClientId, 
		p.DeptId, 
		p.IsCCCHold, 
		p.IsPharmacyClaimCleared, 
		p.StaffRecordId, 
		p.AdmissionByUserId, 
		p.DischargeByUserId, 
		p.IsClearedForDischarge, 
		p.IsClearedFromPharmacy, 
		p.IsClearedFromNurseStation, 
		p.IsClearedFromDoD, 
		p.IsCCHold, 
		p.IsNotified, 
		p.Remarks, 
		p.MediaId, 
		p.CreatedBy, 
		p.CreatedOn, 
		p.LastModifiedBy, 
		p.LastModifiedOn, 
		p.IsDeleted, 
		p.IsSynced, 
		p.IsManualCabinDayCount, 
		p.CabinChargeCalculationGracePeriodType, 
		p.AdditionalDoctorIds, 
		p.BillingMode, 
		p.Address, 
		p.MobileNo, 
		p.Cpmobile, 
		p.Sex, 
		p.MembershipType, 
		p.MaritalStatus, 
		p.Profession, 
		p.NationalId, 
		p.FatherName, 
		p.MotherName, 
		p.PatientAddress, 
		p.Cpname, 
		p.Cpaddress, 
		p.CareOf, 
		p.RelationWithPatient, 
		p.BloodGroup, 
		p.CpnationalId, 
		p.SpouseName, 
		p.Title, 
		p.Religion, 
		p.SubLedgerId, 
		p.TenantId AS Expr1, 
		ca.Id AS AllotId, 
		ca.CabinId, 
		ca.AllotType, 
		ISNULL(ca.Status, '') AS CabinStatus, 
		p.DeptId AS CurrentDeptId, 
		p.TenantId, 
		p.IsEMRLoaded, 
		p.IsTransferredFromOrigin 
	  FROM 
		CtePateintDemographicWithSubLedger AS p 
		INNER JOIN Hospital.IPDCabinAllocationRecords AS ca ON p.Id = ca.PatientId 
	  WHERE 
		(ca.IsOccupiedByPatient = 1) 
		AND (ca.AllotType = 'PAB')
	) 
	SELECT 
	  TOP (100) PERCENT p.Id, 
	  ISNULL(p.InvoicePrefix, '') AS InvoicePrefix, 
	  p.InvoiceNo, 
	  p.UHID, 
	  p.FullName, 
	  p.Address, 
	  p.MobileNo, 
	  p.Cpmobile, 
	  ISNULL(
		CASE WHEN p.AgeYear <> '' THEN p.AgeYear + 'Y ' ELSE p.AgeYear END + CASE WHEN p.AgeMonth <> '' THEN p.AgeMonth + 'M ' ELSE p.AgeMonth END + CASE WHEN p.AgeDay <> '' THEN p.AgeDay + 'D' ELSE p.AgeDay END, 
		''
	  ) AS Age, 
	  p.Sex, 
	  p.MembershipType, 
	  p.MaritalStatus, 
	  p.Profession, 
	  p.NationalId, 
	  p.AdmissionDateTime, 
	  p.DischargedDateTime, 
	  p.AssignedDoctorId, 
	  p.RefdDoctorId, 
	  ISNULL(d.Name, '') AS AssignedDoctorName, 
	  ISNULL(d2.Name, '') AS RefDoctorName, 
	  ISNULL(p.Status, '') AS Status, 
	  p.FatherName, 
	  p.MotherName, 
	  p.PatientAddress, 
	  p.Cpname, 
	  p.Cpaddress, 
	  ISNULL(p.AgeYear, '') AS AgeYear, 
	  ISNULL(p.AgeMonth, '') AS AgeMonth, 
	  ISNULL(p.AgeDay, '') AS AgeDay, 
	  p.CareOf, 
	  p.RelationWithPatient, 
	  p.BloodGroup, 
	  p.CpnationalId, 
	  p.SpouseName, 
	  p.AllotId, 
	  p.CabinId, 
	  p.AllotType, 
	  c.FloorId, 
	  p.CabinStatus, 
	  --ISNULL(
	  --  Hospital.GetCabinNumber(p.Id), 
	  --  ''
	  --) AS CabinNo, 
	  c.CabinNo,
	  ISNULL(ct.CabinType, '') AS CabinType, 
	  ISNULL(dept.Name, '') AS DeptName, 
	  dept.Id AS HDepartmentId, 
	  p.BillingMode, 
	  p.ProbableDischargeDateTime, 
	  p.Title, 
	  p.IsPharmacyClaimCleared, 
	  p.AdmissionByUserId, 
	  c.CabinTypeId, 
	  ISNULL(u.UserName, '') AS UserName, 
	  p.IsClearedForDischarge, 
	  p.IsClearedFromPharmacy, 
	  p.IsClearedFromNurseStation, 
	  p.IsClearedFromDoD, 
	  p.IsCCHold, 
	  p.IsNotified, 
	  ISNULL(ma.Name, '') AS MarketingJOfficerOrMediaName, 
	  p.Religion, 
	  p.MarketingJOfficerOrMediaId, 
	  p.IsManualCabinDayCount, 
	  p.Remarks, 
	  c.DisplayOrder, 
	  ISNULL(
		p.SubLedgerId, '00000000-0000-0000-0000-000000000000'
	  ) AS SubLedgerId, 
	  p.TenantId, 
	  p.IsEMRLoaded, 
	  p.IsTransferredFromOrigin, 
	  isnull(
		ap.PackageId, '00000000-0000-0000-0000-000000000000'
	  ) PackageId 
	FROM 
	  CtePateintDemographicWithSubLedgerAndAllocationRecords AS p 
	  INNER JOIN dbo.VWDoctors AS d ON p.AssignedDoctorId = d.Id 
	  INNER JOIN dbo.VWDoctors AS d2 ON p.RefdDoctorId = d2.Id 
	  INNER JOIN Hospital.Cabins AS c ON p.CabinId = c.Id 
	  INNER JOIN Hospital.HDepartments AS dept ON p.CurrentDeptId = dept.Id 
	  INNER JOIN Hospital.CabinTypes AS ct ON c.CabinTypeId = ct.Id 
	  LEFT OUTER JOIN [Identity].Users AS u ON p.AdmissionByUserId = u.Id 
	  LEFT OUTER JOIN Marketing.MarketingJOfficerOrMedias AS ma ON ma.Id = p.MarketingJOfficerOrMediaId 
	  left join Hospital.AdmittedPackages ap on p.Id = ap.IPDPatientRecordId 
	where 
	  ap.IsOccupiedByPatient is null 
	  or ap.IsOccupiedByPatient = 1 
	ORDER BY 
	  p.InvoiceNo
	
GO
/****** Object:  View [dbo].[VWSceduleProcedureDetailsCTMRI]    Script Date: 09/27/25 6:44:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VWSceduleProcedureDetailsCTMRI]
AS
SELECT        P.InvoiceNo AS PatientId, rr.FullName AS PatientName, rr.Dob AS BirthDate, rr.Sex, tc.AccessionNumber, tc.SOPInstanceUID, tc.Id AS TestId, ti.Name AS TestName, '' AS ProcedureName, P.EntryDate AS OrderDate, 
                         P.EntryTime AS OrderTime, 'MR' AS Modality, 'MININT-MVJ3B73' AS AETitle, '' AS IPAddress, 0 AS Port, 0 AS UserId, tc.ProcedureStep
FROM            Diag.InvestigationInvoices AS P INNER JOIN
                         Hospital.RegRecords AS rr ON P.UHID = rr.UHID INNER JOIN
                         Diag.InvestigationInvoiceDetails AS tc ON P.Id = tc.InvestigationInvoiceId INNER JOIN
                         Diag.TestItems AS ti ON tc.TestItemId = ti.Id
WHERE        (ti.TestGroupId IN (22, 16))
GO
/****** Object:  View [Hospital].[IPDIndentForwardAndPatientAccessesDetails]    Script Date: 09/27/25 6:44:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [Hospital].[IPDIndentForwardAndPatientAccessesDetails]
AS
select ifpa.Id, ifpa.UserId, ifpa.FloorId, ifpa.DeptId, ifpa.IndentForwardToOutlet, ifpa.IsPatientVisibleByFloor, u.UserName, ISNULL(u.FullName, '') as FullName, ISNULL(f.Name, '') as FloorName, ISNULL(mo.Name,'') as MedicineOutletName, ISNULL(d.Name,'') as DeptName
	from [Hospital].[IPDIndentForwardAndPatientAccesses] ifpa inner join
		 [Identity].[Users] u on ifpa.UserId = u.Id left join
		 [Hospital].[Floors] f on ifpa.FloorId = f.Id inner join
		 [Pharmacy].[MedicineOutlets] mo on ifpa.IndentForwardToOutlet = mo.Id left join
		 [Hospital].[HDepartments] d on ifpa.DeptId = d.Id
GO
/****** Object:  View [HR].[ManualAttendanceDetails]    Script Date: 09/27/25 6:44:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO













CREATE     VIEW [HR].[ManualAttendanceDetails]
AS
select ma.Id, ma.StaffRecordId, ma.BDateTime, ma.InTime, ma.OutTime, ma.UserId,sr.EmployeeNo, sr.EmployeeName,u.UserName
		from [HR].[ManualAttendances] ma left join
		[HR].[StaffRecords] sr on ma.StaffRecordId=sr.Id left join
		[Identity].[Users] u on u.Id=ma.UserId
GO
/****** Object:  View [OPD].[ViewOPDServiceSubSubGroups]    Script Date: 09/27/25 6:44:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE     VIEW [OPD].[ViewOPDServiceSubSubGroups]
AS
SELECT ssg.Id, ssg.Name, ssg.ServiceSubGroupId, sg.Name AS ServiceSubGroup
FROM     Hospital.ServiceSubSubGroups AS ssg INNER JOIN
                  Hospital.ServiceSubGroups AS sg ON ssg.ServiceSubGroupId = sg.Id INNER JOIN
                  Hospital.ServiceGroups AS g ON sg.ServiceGroupId = g.Id
--WHERE  (g.Id = '7C1D56EC-E607-46CE-BC59-89589B2B013A')
WHERE g.Name='OPD Services'

GO
/****** Object:  View [Payroll].[SalaryStartStopRecordDetails]    Script Date: 09/27/25 6:44:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO












CREATE     VIEW [Payroll].[SalaryStartStopRecordDetails]
AS
select ssr.Id, ssr.StaffRecordId, ssr.StopMonth, ssr.StopYear, ssr.StoppedAmount, ssr.StartMonth, ssr.StartYear, ssr.UserId,sr.EmployeeNo, sr.EmployeeName, u.UserName
		from [Payroll].[SalaryStartStopRecords] ssr left join
		     [HR].[StaffRecords] sr on sr.Id=ssr.StaffRecordId left join 
			 [Identity].[Users] u on ssr.UserId=u.Id
GO
/****** Object:  View [Payroll].[ViewIndividualSalaries]    Script Date: 09/27/25 6:44:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE     VIEW [Payroll].[ViewIndividualSalaries]
AS
SELECT Payroll.IndividualSalaries.Id, Payroll.IndividualSalaries.EmployeeId, Payroll.IndividualSalaries.HouseRentInPercentOfBasic, Payroll.IndividualSalaries.MedicalAllownceInPercentOfBasic, Payroll.IndividualSalaries.Conveyance,
                  Payroll.IndividualSalaries.BasicAmount, Payroll.IndividualSalaries.Others, Payroll.IndividualSalaries.SpecialAllowance, Payroll.IndividualSalaries.Pf, Payroll.IndividualSalaries.Cpf, Payroll.IndividualSalaries.TotalSalary,
                  Payroll.IndividualSalaries.OvertimePerHour, Payroll.IndividualSalaries.CreatedBy, Payroll.IndividualSalaries.CreatedOn, Payroll.IndividualSalaries.LastModifiedBy, Payroll.IndividualSalaries.LastModifiedOn,
                  Payroll.IndividualSalaries.IsDeleted, Payroll.IndividualSalaries.IsPFDeductionOn, Payroll.IndividualSalaries.FixedAmount, Payroll.IndividualSalaries.GeneralSalaryPolicyId, Payroll.IndividualSalaries.IncermentTypeId,
                  Payroll.IndividualSalaries.SalaryEvaluationDurationId, HR.StaffRecords.EmployeeNo, HR.StaffRecords.EmployeeName, Payroll.GeneralSalaryPolicies.PolicyName AS GeneralSalaryPolicyGroup,
                  Payroll.IncrementTypes.Name AS IncrementType, Payroll.SalaryEvaluationDurations.Name AS SalaryEvaluationDuration, HR.Designations.Name AS Designation, HR.SubDepartments.Name AS Department, HR.StaffRecords.JoiningDate,
                  Payroll.IndividualSalaries.TaxableAmount, Payroll.IndividualSalaries.OtherAllowance
FROM     Payroll.IndividualSalaries INNER JOIN
                  HR.StaffRecords ON Payroll.IndividualSalaries.EmployeeId = HR.StaffRecords.Id INNER JOIN
                  HR.SubDepartments ON HR.StaffRecords.SubDeptId = HR.SubDepartments.Id INNER JOIN
                  HR.Designations ON HR.Designations.Id = HR.StaffRecords.DesignationId LEFT OUTER JOIN
                  Payroll.GeneralSalaryPolicies ON Payroll.IndividualSalaries.GeneralSalaryPolicyId = Payroll.GeneralSalaryPolicies.Id LEFT OUTER JOIN
                  Payroll.IncrementTypes ON Payroll.IndividualSalaries.IncermentTypeId = Payroll.IncrementTypes.Id LEFT OUTER JOIN
                  Payroll.SalaryEvaluationDurations ON Payroll.IndividualSalaries.SalaryEvaluationDurationId = Payroll.SalaryEvaluationDurations.Id
GO
/****** Object:  View [Pharmacy].[BrandDetails2]    Script Date: 09/27/25 6:44:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






-- drop view [Pharmacy].[BrandDetails2] 
CREATE     VIEW  [Pharmacy].[BrandDetails2]  
AS
	SELECT 
	  bext.Id AS ProductId, 
	  f.ShortFormation + ' - ' + bn.Name + ' ' + ISNULL(s.Value, '') + ' ' + ISNULL(bext.Unit, '') AS ProductName, 
	  g.Name AS Generic, 
	  bext.GenericId, 
	  --isnull((select top 1 PurchaseRate from Pharmacy.StockReceives r join Pharmacy.StockReceiveDetails rd on r.Id = rd.StockReceiveId where rd.BrandExtensionId = bext.Id and ReceiveTypeId = 13 order by EntryDate desc), bext.PurchasePrice) PurchasePrice,
	  --isnull((select top 1 rd.SaleRate from Pharmacy.StockReceives r join Pharmacy.StockReceiveDetails rd on r.Id = rd.StockReceiveId where rd.BrandExtensionId = bext.Id and ReceiveTypeId = 13 order by EntryDate desc), bext.SalePrice) SalePrice,
	  m.Name AS Manufacturer, 
	  bext.PurchasePrice,
	  bext.SalePrice,
	  bext.PkgUnit, 
	  bext.QtyPerBox, 
	  bn.ManufacturerId, 
	  f.Id AS FormationId, 
	  bext.IsActive 
	FROM 
	  Pharmacy.BrandNames AS bn 
	  INNER JOIN Pharmacy.BrandExtensions AS bext ON bn.Id = bext.BrandId 
	  INNER JOIN Pharmacy.Formations AS f ON bext.FormationId = f.Id 
	  LEFT OUTER JOIN Pharmacy.Strengths AS s ON bext.StrengthId = s.Id 
	  INNER JOIN Pharmacy.Generics AS g ON bext.GenericId = g.Id 
	  INNER JOIN Pharmacy.Manufacturers AS m ON bn.ManufacturerId = m.Id

	
	  
GO
/****** Object:  View [Pharmacy].[BrandDetailsWithoutSupplierId]    Script Date: 09/27/25 6:44:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE     VIEW [Pharmacy].[BrandDetailsWithoutSupplierId]
AS
SELECT        bext.Id AS ProductId, f.ShortFormation + ' - ' + bn.Name + ' ' + ISNULL(s.Value, '') + ' ' + ISNULL(bext.Unit, '') AS ProductName, g.Name AS Generic, bext.GenericId, bext.PurchasePrice, bext.SalePrice, bext.PkgUnit, 
                         bext.QtyPerBox, bn.ManufacturerId, f.Id AS FormationId, bext.IsActive
FROM            Pharmacy.BrandNames AS bn INNER JOIN
                         Pharmacy.BrandExtensions AS bext ON bn.Id = bext.BrandId INNER JOIN
                         Pharmacy.Formations AS f ON bext.FormationId = f.Id LEFT OUTER JOIN
                         Pharmacy.Strengths AS s ON bext.StrengthId = s.Id INNER JOIN
                         Pharmacy.Generics AS g ON bext.GenericId = g.Id
GO
/****** Object:  View [Pharmacy].[OutletIndentRecords]    Script Date: 09/27/25 6:44:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










CREATE     VIEW [Pharmacy].[OutletIndentRecords]
AS
select oi.Id,oi.IndentNo,oi.TenantId,convert(Date,oi.IndentDateTime)AS IndentDateTime,oi.Priority,oi.FromOutletId,oi.ToOutletId,mo.Name as FromOutletName, mo1.Name as ToOutletName, Status,st.Name StatusTxt
		from [Pharmacy].[OutletIndents] oi inner join
		 [Pharmacy].[MedicineOutlets] mo on oi.FromOutletId=mo.Id inner join
		 [Pharmacy].[MedicineOutlets] mo1 on oi.ToOutletId=mo1.Id left join
		 [Admin].[ServeTypes] st on oi.Status=st.Id 

GO
/****** Object:  View [Pharmacy].[PharmacyDutyOutletDetails]    Script Date: 09/27/25 6:44:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





---------------------------------------------------------------------------------------------------------------------------------------------------
--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ PharmacyDutyOutletDetails ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
---------------------------------------------------------------------------------------------------------------------------------------------------

CREATE     VIEW [Pharmacy].[PharmacyDutyOutletDetails]
AS
SELECT pdo.Id, pdo.UserId, pdo.TenantId, pdo.OutletId, ISNULL(u.FullName, '') as FullName, u.UserName, u.Email, mo.Name as OutletName,mo.Description
			  FROM [Pharmacy].[PharmacistDutyOutlets] pdo INNER JOIN
			  [Pharmacy].[MedicineOutlets] mo on pdo.OutletId=mo.Id INNER JOIN
			  [Identity].[Users] u on pdo.UserId=u.Id
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[46] 4[15] 2[10] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ProductWiseReceiveDetails (Canteen)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 162
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ProductWiseSaleDetails (Canteen)"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 102
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'Canteen', @level1type=N'VIEW',@level1name=N'CurrentStockCalculation'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'Canteen', @level1type=N'VIEW',@level1name=N'CurrentStockCalculation'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[30] 4[16] 2[11] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "StockReceiveRecordDetails (Canteen)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 212
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'Canteen', @level1type=N'VIEW',@level1name=N'ProductWiseReceiveDetails'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'Canteen', @level1type=N'VIEW',@level1name=N'ProductWiseReceiveDetails'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[52] 4[12] 2[18] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "SaleInvoiceDetails (Canteen)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 252
               Right = 320
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'Canteen', @level1type=N'VIEW',@level1name=N'ProductWiseSaleDetails'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'Canteen', @level1type=N'VIEW',@level1name=N'ProductWiseSaleDetails'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[65] 4[5] 2[13] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "item"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 298
               Right = 212
            End
            DisplayFlags = 280
            TopColumn = 3
         End
         Begin Table = "sc"
            Begin Extent = 
               Top = 6
               Left = 250
               Bottom = 168
               Right = 634
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'Canteen', @level1type=N'VIEW',@level1name=N'ViewStock'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'Canteen', @level1type=N'VIEW',@level1name=N'ViewStock'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[10] 2[45] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "bd"
            Begin Extent = 
               Top = 9
               Left = 57
               Bottom = 206
               Right = 282
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "cs"
            Begin Extent = 
               Top = 207
               Left = 57
               Bottom = 404
               Right = 298
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ro"
            Begin Extent = 
               Top = 405
               Left = 57
               Bottom = 602
               Right = 298
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1000
         Width = 1000
         Width = 1000
         Width = 1000
         Width = 1000
         Width = 1000
         Width = 1000
         Width = 1000
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewBrandAndStockDetailsWithoutlot'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewBrandAndStockDetailsWithoutlot'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "stIn"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 235
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "stOut"
            Begin Extent = 
               Top = 6
               Left = 273
               Bottom = 136
               Right = 473
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewCurrentStockWithoutLot'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewCurrentStockWithoutLot'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "sr"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 271
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "srd"
            Begin Extent = 
               Top = 6
               Left = 309
               Bottom = 136
               Right = 519
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewTotalStockInWithoutLot'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'ViewTotalStockInWithoutLot'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "P"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 257
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "rr"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 282
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tc"
            Begin Extent = 
               Top = 270
               Left = 38
               Bottom = 400
               Right = 301
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ti"
            Begin Extent = 
               Top = 402
               Left = 38
               Bottom = 532
               Right = 371
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VWSceduleProcedureDetailsCTMRI'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VWSceduleProcedureDetailsCTMRI'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[32] 4[3] 2[28] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -96
         Left = 0
      End
      Begin Tables = 
         Begin Table = "p"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 276
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "rr"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 282
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d"
            Begin Extent = 
               Top = 270
               Left = 38
               Bottom = 400
               Right = 319
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d2"
            Begin Extent = 
               Top = 402
               Left = 38
               Bottom = 532
               Right = 319
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ca"
            Begin Extent = 
               Top = 534
               Left = 38
               Bottom = 664
               Right = 268
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 666
               Left = 38
               Bottom = 796
               Right = 212
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "dept"
            Begin Extent = 
               Top = 666
               Left = 250
               Bottom = 796
               Right = 424
            End
            DisplayFlags = 280
            TopColumn = 0
        ' , @level0type=N'SCHEMA',@level0name=N'Hospital', @level1type=N'VIEW',@level1name=N'VWHospitalPatientDetails'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N' End
         Begin Table = "ct"
            Begin Extent = 
               Top = 798
               Left = 38
               Bottom = 928
               Right = 212
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "u"
            Begin Extent = 
               Top = 930
               Left = 38
               Bottom = 1060
               Right = 262
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ma"
            Begin Extent = 
               Top = 798
               Left = 250
               Bottom = 928
               Right = 437
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'Hospital', @level1type=N'VIEW',@level1name=N'VWHospitalPatientDetails'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'Hospital', @level1type=N'VIEW',@level1name=N'VWHospitalPatientDetails'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[33] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -384
         Left = 0
      End
      Begin Tables = 
         Begin Table = "IndividualSalaries (Payroll)"
            Begin Extent = 
               Top = 402
               Left = 38
               Bottom = 715
               Right = 376
            End
            DisplayFlags = 280
            TopColumn = 9
         End
         Begin Table = "StaffRecords (HR)"
            Begin Extent = 
               Top = 270
               Left = 38
               Bottom = 400
               Right = 274
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SubDepartments (HR)"
            Begin Extent = 
               Top = 6
               Left = 462
               Bottom = 136
               Right = 636
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Designations (HR)"
            Begin Extent = 
               Top = 6
               Left = 674
               Bottom = 136
               Right = 914
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "GeneralSalaryPolicies (Payroll)"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 288
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "IncrementTypes (Payroll)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 212
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SalaryEvaluationDurations (Payroll)"
            Begin Extent = 
               Top = 6
            ' , @level0type=N'SCHEMA',@level0name=N'Payroll', @level1type=N'VIEW',@level1name=N'ViewIndividualSalaries'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'   Left = 250
               Bottom = 136
               Right = 424
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'Payroll', @level1type=N'VIEW',@level1name=N'ViewIndividualSalaries'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'Payroll', @level1type=N'VIEW',@level1name=N'ViewIndividualSalaries'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[66] 4[3] 2[19] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "bn"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 370
               Right = 212
            End
            DisplayFlags = 280
            TopColumn = 3
         End
         Begin Table = "bext"
            Begin Extent = 
               Top = 6
               Left = 250
               Bottom = 388
               Right = 424
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "f"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 479
               Right = 212
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s"
            Begin Extent = 
               Top = 138
               Left = 250
               Bottom = 200
               Right = 424
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "g"
            Begin Extent = 
               Top = 270
               Left = 38
               Bottom = 570
               Right = 212
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "m"
            Begin Extent = 
               Top = 270
               Left = 250
               Bottom = 570
               Right = 441
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 11
         Width = 284
         Width = 1500
         Width = 4425
         Width = 1500
         Width ' , @level0type=N'SCHEMA',@level0name=N'Pharmacy', @level1type=N'VIEW',@level1name=N'BrandDetails'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'= 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'Pharmacy', @level1type=N'VIEW',@level1name=N'BrandDetails'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'Pharmacy', @level1type=N'VIEW',@level1name=N'BrandDetails'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Cte2_1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 209
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'Pharmacy', @level1type=N'VIEW',@level1name=N'ViewBrandAndStockDetails'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'Pharmacy', @level1type=N'VIEW',@level1name=N'ViewBrandAndStockDetails'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[36] 4[5] 2[16] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "sr"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 248
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "srd"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 243
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'Pharmacy', @level1type=N'VIEW',@level1name=N'ViewTotalStockIn'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'Pharmacy', @level1type=N'VIEW',@level1name=N'ViewTotalStockIn'
GO

```