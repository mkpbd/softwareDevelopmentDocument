
##### **nstall the Necessary NuGet Package:**
![[word-image-46368-1.webp]]

##### **Create a Model:**
```C#
namespace FileUploadInMVC.Models
{
    public class Employee
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Departmet { get; set; }
        public long Salary { get; set; }
        public string Position { get; set; }
        public DateTime DateOfJoining { get; set; }
    }
}
```

##### **Update the Context Class:**
```C#
using Microsoft.EntityFrameworkCore;

namespace FileUploadInMVC.Models
{
    public class EFCoreDbContext : DbContext
    {
        public EFCoreDbContext() : base()
        {
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            //Configuring the Connection String
            optionsBuilder.UseSqlServer(@"Server=LAPTOP-6P5NK25R\SQLSERVER2022DEV;Database=FileHandlingDB;Trusted_Connection=True;TrustServerCertificate=True;");
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
        }

        //Adding Domain Classes as DbSet Properties
        public DbSet<FileModel> Files { get; set; }
        public DbSet<Employee> Employees { get; set; }
    }
}
```

##### **Create a Method to Generate the Excel File:**

```C#
using ClosedXML.Excel;
namespace FileUploadInMVC.Models
{
    public class ExcelFileHandling
    {
        //This Method will Create an Excel Sheet and Store it in the Memory Stream Object
        //And return thar Memory Stream Object
        public MemoryStream CreateExcelFile(List<Employee> employees)
        {
            //Create an Instance of Workbook, i.e., Creates a new Excel workbook
            var workbook = new XLWorkbook();

            //Add a Worksheets with the workbook
            //Worksheets name is Employees
            IXLWorksheet worksheet = workbook.Worksheets.Add("Employees");

            //Create the Cell
            //First Row is going to be Header Row
            worksheet.Cell(1, 1).Value = "ID"; //First Row and First Column
            worksheet.Cell(1, 2).Value = "Name"; //First Row and Second Column
            worksheet.Cell(1, 3).Value = "Departmet"; //First Row and Third Column
            worksheet.Cell(1, 4).Value = "Salary"; //First Row and Fourth Column
            worksheet.Cell(1, 5).Value = "Position"; //First Row and Fifth Column
            worksheet.Cell(1, 6).Value = "Date of Joining"; //First Row and Sixth Column

            //Data is going to stored from Row 2
            int row = 2;

            //Loop Through Each Employees and Populate the worksheet
            //For Each Employee increase row by 1
            foreach (var emp in employees)
            {
                worksheet.Cell(row, 1).Value = emp.Id;
                worksheet.Cell(row, 2).Value = emp.Name;
                worksheet.Cell(row, 3).Value = emp.Departmet;
                worksheet.Cell(row, 4).Value = emp.Salary;
                worksheet.Cell(row, 5).Value = emp.Position;
                worksheet.Cell(row, 6).Value = emp.DateOfJoining;
                row++; //Increasing the Data Row by 1
            }

            //Create an Memory Stream Object
            var stream = new MemoryStream();

            //Saves the current workbook to the Memory Stream Object.
            workbook.SaveAs(stream);

            //The Position property gets or sets the current position within the stream.
            //This is the next position a read, write, or seek operation will occur from.
            stream.Position = 0;

            return stream;
        }
    }
}
```

##### **Create a Controller Action to Download the File:**

```C#
public IActionResult ExportToExcel()
{
    //Get the Employee data from the database
    EFCoreDbContext dbContext = new EFCoreDbContext();
    var employees = dbContext.Employees.ToList();

    //Create an Instance of ExcelFileHandling
    ExcelFileHandling excelFileHandling = new ExcelFileHandling();
    //Call the CreateExcelFile method by passing the list of Employee
    var stream = excelFileHandling.CreateExcelFile(employees);

    //Give a Name to your Excel File
    string excelName = $"Employees-{Guid.NewGuid()}.xlsx";

    // 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' is the MIME type for Excel files
    return File(stream, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", excelName);
}
```


## **Import Excel Data to Database in ASP.NET Core MVC**

```C#
//This Method will Stream Object as an input which contains the Excel file
//And then convert that Excel file to List of Employees
public List<Employee> ParseExcelFile(Stream stream)
{
    var employees = new List<Employee>();

    //Create a workbook instance
    //Opens an existing workbook from a stream.
    using (var workbook = new XLWorkbook(stream))
    {
        //Lets assume the First Worksheet contains the data
        var worksheet = workbook.Worksheet(1);

        //Lets assume first row contains the header, so skip the first row
        var rows = worksheet.RangeUsed().RowsUsed().Skip(1);

        //Loop Through all the Rows except the first row which contains the header data
        foreach (var row in rows)
        {
            //Create an Instance of Employee object and populate it with the Excel Data Row
            var employee = new Employee
            {
                Name = row.Cell(1).GetValue<string>(),
                Departmet = row.Cell(2).GetValue<string>(),
                Salary = row.Cell(3).GetValue<long>(),
                Position = row.Cell(4).GetValue<string>(),
                DateOfJoining = row.Cell(5).GetValue<DateTime>(),
            };

            //Add the Employee to the List of Employees
            employees.Add(employee);
        }
    }

    //Finally return the List of Employees
    return employees;
}
```

##### **Create a Controller Action to Handle File Upload and Import:**

```C#
[HttpPost]
public async Task<IActionResult> ImportFromExcel(IFormFile file)
{
    if (file != null && file.Length > 0)
    {
        //Create an Instance of ExcelFileHandling
        ExcelFileHandling excelFileHandling = new ExcelFileHandling();

        //Call the CreateExcelFile method by passing the stream object which contains the Excel file
        var employees = excelFileHandling.ParseExcelFile(file.OpenReadStream());

        // Now save these employees to the database
        using (var context = new EFCoreDbContext())
        {
            await context.Employees.AddRangeAsync(employees);
            await context.SaveChangesAsync();
        }

        return View("UploadSuccess"); // Redirect to a view showing success or list of products
    }

    return View(); // Redirect back to upload view in case of failure
}
```
##### **Create a View for Excel File Upload:**

```C#
public IActionResult ImportExcel()
{
    return View();
}
```

```C#
@{
    ViewData["Title"] = "ImportExcel";
}

<h1>ImportExcel</h1>
<hr />
<div class="row">
    <div class="col-md-12">
        <form method="post" asp-controller="FileUpload" asp-action="ImportFromExcel"
              enctype="multipart/form-data">
            <div asp-validation-summary="All" class="text-danger"></div>
            <input type="file" name="file" class="form-control" />
            <button type="submit" name="Upload" class="btn btn-primary">Upload</button>
        </form>
    </div>
</div>
```

