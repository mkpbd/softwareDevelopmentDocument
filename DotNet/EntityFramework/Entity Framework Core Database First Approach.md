
- **Database: EFCoreDB:**
- **Table: Employees:** This table should contain employee-related information.
- **Table: Departments:** This table should store department details.
- **Views: EmployeeDetails:** A view to aggregate and present detailed employee information.
- **Stored Procedure: GetEmployeeById:** Fetching employee data by their ID.
- **Function: CalculateBonus:** A function to calculate bonuses for employees.
```sql
CREATE DATABASE EFCoreDB;
USE EFCoreDB;

-- Create Departments Database Table
-- This table will store department details. 
-- It has an ID as the primary key and a name for the department.
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY IDENTITY,
    DepartmentName NVARCHAR(100) NOT NULL
);
GO

-- Create Employees Database Table
-- This table will store employee details. 
-- It includes an ID as the primary key, personal details like name and email, 
-- and a foreign key to the Departments table.
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY IDENTITY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100),
    Salary INT,
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);
GO

-- Create EmployeeDetails View
-- Joins data from the Employees and Departments tables to EmployeeDetails View
CREATE VIEW EmployeeDetails AS
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.Email,
    e.Salary,
    d.DepartmentName
FROM Employees e
INNER JOIN Departments d 
ON e.DepartmentID = d.DepartmentID;
GO

-- Create GetEmployeeById Stored Procedure
-- This will return the Employee Details based on the EmployeeID
CREATE PROCEDURE GetEmployeeById
    @EmployeeID INT
AS
BEGIN
    SELECT 
        e.EmployeeID,
        e.FirstName,
        e.LastName,
        e.Email,
        e.Salary,
        e.DepartmentID,
        d.DepartmentName
    FROM Employees e
    INNER JOIN Departments d 
 ON e.DepartmentID = d.DepartmentID
    WHERE e.EmployeeID = @EmployeeID;
END;
GO

-- Create CalculateBonus Stored Function
-- This will calculate and return the Bonus of the Employee Based on the EmployeeID
CREATE FUNCTION CalculateBonus 
(
    @EmployeeID INT
)
RETURNS DECIMAL(12, 2)
AS
BEGIN
    DECLARE @Salary DECIMAL(12, 2);
    DECLARE @Bonus DECIMAL(12, 2);

    -- Assuming there is a Salary column in Employees table
    SELECT @Salary = Salary FROM Employees WHERE EmployeeID = @EmployeeID;

    -- Calculate the bonus which is 25% of the Salary
    SET @Bonus = @Salary * 25 / 100;

    RETURN @Bonus;
END;
```

![[word-image-44735-1.webp]]


```C#
using EFCoreCodeFirstDemo.Models;
namespace EFCoreCodeFirstDemo
{
    public class Program
    {
        static async Task Main(string[] args)
        {
            try
            {
                //Create an Instance of DbContext
                EfcoreDbContext context = new EfcoreDbContext();

                //Adding Departments to the Departments database table
                //We are adding two Departments IT and HR
                Department ITDepartment = new()
                {
                    DepartmentName = "IT",
                };
                context.Add(ITDepartment);

                Department HRDepartment = new()
                {
                    DepartmentName = "HR",
                };
                context.Add(HRDepartment);
                context.SaveChanges();
                Console.WriteLine("\nIT and HR Departments Added...");

                //Create Operations
                //Adding Few Employees to the Employees Database Table
                var employee1 = new Employee { FirstName = "Pranaya", LastName = "Rout", Salary = 550000, Email = "A@Example.com", DepartmentId = ITDepartment.DepartmentId };
                context.Employees.Add(employee1);

                var employee2 = new Employee { FirstName = "Tarun", LastName = "Kumar", Salary = 650000, Email = "B@Example.com", DepartmentId = ITDepartment.DepartmentId };
                context.Employees.Add(employee2);

                var employee3 = new Employee { FirstName = "Hina", LastName = "Sharma", Salary = 750000, Email = "C@Example.com", DepartmentId = HRDepartment.DepartmentId };
                context.Employees.Add(employee3);
                context.SaveChanges();
                Console.WriteLine("\nEmployees Pranaya, Tarun and Hina Added...");
               
                //Read Operations
                //Display All the Employees Details
                Console.WriteLine("\nDisplaying All the Employees Details");
                var employees = context.Employees.ToList();
                foreach (var emp in employees)
                {
                    Console.WriteLine($"\tName: {emp.FirstName} {emp.LastName}, Salary: {emp.Salary}, Department: {emp.Department?.DepartmentName}");
                }

                //Update Operation
                //Update the Salary, Last name and Department of First Employee
                Console.WriteLine("\nUpdating Salary, Last name and Department of First Employee");
                employee1.LastName = "Parida";
                employee1.Salary = 900000;
                employee1.DepartmentId = HRDepartment.DepartmentId;
                context.SaveChanges();
                Console.WriteLine("After Updation");
                Console.WriteLine($"Name: {employee1.FirstName} {employee1.LastName}, Salary: {employee1.Salary}, Department: {employee1.Department?.DepartmentName}");

                //Delete Operation
                //Delete the Third Employee
                Console.WriteLine("\nRemoving Third Employee");
                context.Remove(employee3);
                context.SaveChanges();
                Console.WriteLine("After Remove, All Employees");
                employees = context.Employees.ToList();
                foreach (var emp in employees)
                {
                    Console.WriteLine($"\tName: {emp.FirstName} {emp.LastName}, Salary: {emp.Salary}, Department: {emp.Department?.DepartmentName}");
                }

                Console.Read();
            }

            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}"); ;
            }
        }
    }
}
```

##### **Using Views and Stored Procedures in EF Core DB First Approach:**

```C#
using EFCoreCodeFirstDemo.Models;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;

namespace EFCoreCodeFirstDemo
{
    public class Program
    {
        static async Task Main(string[] args)
        {
            try
            {
                //Create an Instance of DbContext
                EfcoreDbContext context = new EfcoreDbContext();

                Console.WriteLine("Using View");
                var emp = context.EmployeeDetails.FirstOrDefault(emp => emp.EmployeeId == 1);
                Console.WriteLine($"\tName: {emp?.FirstName} {emp?.LastName}, Salary: {emp?.Salary}, Department: {emp?.DepartmentName}");

                //Executing Stored Procedure (GetEmployeeById):
                //As the Stored Procedure Returning an Emloyee Details, we can use FromSqlRaw Method
                Console.WriteLine("Using Stored Procedure");
                var employeeIdParameter = new SqlParameter("@EmployeeID", 1);
                var employee = context.Employees
                                       .FromSqlRaw("EXEC GetEmployeeById @EmployeeID", employeeIdParameter)
                                       .AsEnumerable()
                                       .FirstOrDefault();

                Console.WriteLine($"\tName: {employee?.FirstName} {employee?.LastName}, Salary: {employee?.Salary}, Department: {employee?.Department?.DepartmentName}");

                Console.Read();
            }

            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}"); ;
            }
        }
    }
}
```

##### **Step 1: Project Setup**

**Create a New ASP.NET Core MVC Project:** Open Visual Studio. Create a new project (**CRUDinCoreMVC**) and select the ASP.NET Core Web App (Model-View-Controller) template.

**Install The Packages:** Once you have created the Project, as we are going to work with the SQL Server Database, please install the following two NuGet Packages:

- **Microsoft.EntityFrameworkCore.Tools**
- **Microsoft.EntityFrameworkCore.SqlServer**
![[word-image-44859-1.webp]]
##### **Step 2: Define Models**

```c#
namespace CRUDinCoreMVC.Models
{
    public class Department
    {
        public int DepartmentId { get; set; }
        public string Name { get; set; }

        public List<Employee> Employees { get; set; }
    }
}
namespace CRUDinCoreMVC.Models
{
    public class Employee
    {
        public int EmployeeId { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public string Position { get; set; }
        public int DepartmentId { get; set; }

        public Department? Department { get; set; }
    }
}

```

##### **Step 3: Configure the Database Connection**
**appsettings.json**
```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },

  "AllowedHosts": "*",
  "ConnectionStrings": {
    "EFCoreDBConnection": "Server=LAPTOP-6P5NK25R\\SQLSERVER2022DEV;Database=EFCoreMVCDB;Trusted_Connection=True;TrustServerCertificate=True;"
  }
}
```

##### **Step 4: Configure DbContext**

```C#
using Microsoft.EntityFrameworkCore;
using System.Diagnostics.Metrics;

namespace CRUDinCoreMVC.Models
{
    public class EFCoreDbContext : DbContext
    {
        //Constructor calling the Base DbContext Class Constructor
        public EFCoreDbContext(DbContextOptions<EFCoreDbContext> options) : base(options)
        {
        }

        //OnConfiguring() method is used to select and configure the data source
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)  {  }

        protected override void OnModelCreating(ModelBuilder modelBuilder) { }

        //Adding Domain Classes as DbSet Properties
        public DbSet<Employee> Employees { get; set; }
        public DbSet<Department> Departments { get; set; }
    }
}
```

##### **Step 5: Registering the Connection String and DbContext Class:**

```C#
using CRUDinCoreMVC.Models;
using Microsoft.EntityFrameworkCore;

namespace CRUDinCoreMVC
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            //Configure the ConnectionString and DbContext class
            builder.Services.AddDbContext<EFCoreDbContext>(options =>
            {
                options.UseSqlServer(builder.Configuration.GetConnectionString("EFCoreDBConnection"));
            });

            // Add services to the container.
            builder.Services.AddControllersWithViews();

            var app = builder.Build();

            // Configure the HTTP request pipeline.
            if (!app.Environment.IsDevelopment())
            {
                app.UseExceptionHandler("/Home/Error");
                // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
                app.UseHsts();
            }

            app.UseHttpsRedirection();
            app.UseStaticFiles();

            app.UseRouting();

            app.UseAuthorization();

            app.MapControllerRoute(
                name: "default",
                pattern: "{controller=Home}/{action=Index}/{id?}");

            app.Run();
        }
    }
}
```

##### **Step 6: Database Migration**

![[word-image-44859-2-768x321.webp]]

##### **Step 7: CRUD Operations in ASP.NET Core MVC Using EF Core:**

![[word-image-44859-4-1024x333.webp]]
![[word-image-44859-5-768x478.webp]]
```C#
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using CRUDinCoreMVC.Models;

namespace CRUDinCoreMVC.Controllers
{
    public class EmployeesController : Controller
    {
        private readonly EFCoreDbContext _context;

        public EmployeesController(EFCoreDbContext context)
        {
            _context = context;
        }

        // GET: Employees
        public async Task<IActionResult> Index()
        {
            var eFCoreDbContext = _context.Employees.Include(e => e.Department);
            return View(await eFCoreDbContext.ToListAsync());
        }

        // GET: Employees/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null || _context.Employees == null)
            {
                return NotFound();
            }

            var employee = await _context.Employees
                .Include(e => e.Department)
                .FirstOrDefaultAsync(m => m.EmployeeId == id);
            if (employee == null)
            {
                return NotFound();
            }

            return View(employee);
        }

        // GET: Employees/Create
        public IActionResult Create()
        {
            ViewData["DepartmentId"] = new SelectList(_context.Departments, "DepartmentId", "DepartmentId");
            return View();
        }

        // POST: Employees/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("EmployeeId,Name,Email,Position,DepartmentId")] Employee employee)
        {
            if (ModelState.IsValid)
            {
                _context.Add(employee);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            ViewData["DepartmentId"] = new SelectList(_context.Departments, "DepartmentId", "DepartmentId", employee.DepartmentId);
            return View(employee);
        }

        // GET: Employees/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null || _context.Employees == null)
            {
                return NotFound();
            }

            var employee = await _context.Employees.FindAsync(id);
            if (employee == null)
            {
                return NotFound();
            }
            ViewData["DepartmentId"] = new SelectList(_context.Departments, "DepartmentId", "DepartmentId", employee.DepartmentId);
            return View(employee);
        }

        // POST: Employees/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("EmployeeId,Name,Email,Position,DepartmentId")] Employee employee)
        {
            if (id != employee.EmployeeId)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(employee);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!EmployeeExists(employee.EmployeeId))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            ViewData["DepartmentId"] = new SelectList(_context.Departments, "DepartmentId", "DepartmentId", employee.DepartmentId);
            return View(employee);
        }

        // GET: Employees/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null || _context.Employees == null)
            {
                return NotFound();
            }

            var employee = await _context.Employees
                .Include(e => e.Department)
                .FirstOrDefaultAsync(m => m.EmployeeId == id);
            if (employee == null)
            {
                return NotFound();
            }

            return View(employee);
        }

        // POST: Employees/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            if (_context.Employees == null)
            {
                return Problem("Entity set 'EFCoreDbContext.Employees'  is null.");
            }
            var employee = await _context.Employees.FindAsync(id);
            if (employee != null)
            {
                _context.Employees.Remove(employee);
            }
            
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool EmployeeExists(int id)
        {
          return (_context.Employees?.Any(e => e.EmployeeId == id)).GetValueOrDefault();
        }
    }
}
```

![[word-image-44859-6.webp]]
