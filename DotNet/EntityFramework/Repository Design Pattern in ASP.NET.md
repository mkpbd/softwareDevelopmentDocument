
##### **How Does a Modern Data-driven Application Access Data from a Database?**
![[Pasted image 20240328205252.png]]



##### **What is the Repository Design Pattern?**

The Repository Design Pattern is a widely used design pattern that abstracts the data layer, making your application code more maintainable, scalable, and testable. The Repository pattern allows you to manage the data from a data source (like a database) in a more object-oriented way.

The Repository Design Pattern acts as a middleman or middle layer between the rest of the application and the data access logic. That means a repository pattern isolates all the data access codes from the rest of the application.

![[word-image-44878-2.webp]]

##### **What is a Repository?**

A repository is a class defined for an entity with all the possible database operations. For example, a repository for an employee entity will have the basic CRUD operations and any other possible operations related to the Employee entity.

##### **How to Implement Repository Design Pattern in ASP.NET Core MVC using EF Core?**

We are going to work with the same application that we created in our previous article, where we created the following Employee and Department Entities:

```C#
using System.ComponentModel.DataAnnotations;

namespace CRUDinCoreMVC.Models
{
    public class Employee
    {
        public int EmployeeId { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public string Position { get; set; }
        [Display(Name ="Department Name")]
        public int DepartmentId { get; set; }

        public Department? Department { get; set; }
    }
}

namespace CRUDinCoreMVC.Models
{
    public class Department
    {
        public int DepartmentId { get; set; }
        public string Name { get; set; }
        public List<Employee> Employees { get; set; }
    }
}


```


```C#
using Microsoft.EntityFrameworkCore;

namespace CRUDinCoreMVC.Models
{
    public class EFCoreDbContext : DbContext
    {
        //Constructor calling the Base DbContext Class Constructor
        public EFCoreDbContext(DbContextOptions<EFCoreDbContext> options) : base(options)
        {
        }

        //OnConfiguring() method is used to select and configure the data source
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            //We will store the connection string in AppSettings.json file instead of hard coding here
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
        }

        //Adding Domain Classes as DbSet Properties
        public DbSet<Employee> Employees { get; set; }
        public DbSet<Department> Departments { get; set; }
    }
}
```


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
                pattern: "{controller=Employees}/{action=Index}/{id?}");

            app.Run();
        }
    }
}
```


##### **Create Repository Interfaces**

Define interfaces for your repositories. These interfaces declare the operations you can perform on the entities. A repository typically does at least five operations as follows:

- Selecting all records from a table
- Selecting a single record based on its primary key
- Insert a new record into the database
- Update an existing record in the database
- Delete an existing record in the database
```C#
using CRUDinCoreMVC.Models;

namespace CRUDinCoreMVC.Repository
{
    public interface IEmployeeRepository
    {
        //This method returns all the Employee entities as an enumerable collection
        Task<IEnumerable<Employee>> GetAllAsync();

        //This method accepts an integer parameter representing an Employee ID and
        //returns a single Employee entity matching that Employee ID.
        Task<Employee?> GetByIdAsync(int EmployeeID);

        //This method accepts an Employee object as the parameter and
        //adds that Employee object to the Employees DbSet.
        //mark the entity state as Added
        Task InsertAsync(Employee employee);

        //This method accepts an Employee object as a parameter and
        //marks that Employee object as a modified Employee in the DbSet.
        Task UpdateAsync(Employee employee);

        //This method accepts an EmployeeID as a parameter and
        //removes that Employee entity from the Employees DbSet.
        //Mark the Entity state as Deleted
        Task DeleteAsync(int employeeId);

        //This method Saves changes to the EFCoreDb database.
        Task SaveAsync();
    }
}
```

##### **Adding EmployeeRepository Class**

```C#
using CRUDinCoreMVC.Models;
using Microsoft.EntityFrameworkCore;

namespace CRUDinCoreMVC.Repository
{
    public class EmployeeRepository : IEmployeeRepository
    {
        //The following variable is going to hold the EmployeeDBContext instance
        private readonly EFCoreDbContext _context;

        //Initializing the EmployeeDBContext instance which it received as an argument
        //MVC Framework DI Container will provide the EFCoreDbContext instance
        public EmployeeRepository(EFCoreDbContext context)
        {
            _context = context;
        }

        //Returns all employees from the database.
        public async Task<IEnumerable<Employee>> GetAllAsync()
        {
            return await _context.Employees.Include(e => e.Department).ToListAsync();
        }

        //Retrieves a single employee by their ID.
        public async Task<Employee?> GetByIdAsync(int EmployeeID)
        {
            var employee = await _context.Employees
               .Include(e => e.Department)
               .FirstOrDefaultAsync(m => m.EmployeeId == EmployeeID);

            return employee;
        }

        //Adds a new employee to the database.
        public async Task InsertAsync(Employee employee)
        {
            await _context.Employees.AddAsync(employee);
        }

        //Updates an existing employee's details.
        public async Task UpdateAsync(Employee employee)
        {
            _context.Employees.Update(employee);
        }

        //Deletes an employee from the database
        public async Task DeleteAsync(int employeeId)
        {
            var employee = await _context.Employees.FindAsync(employeeId);
            if (employee != null)
            {
                _context.Employees.Remove(employee);
            }
        }

        //InsertAsync, UpdateAsync, and DeleteAsync methods,
        //remember to call SaveAsync to commit the changes to the database.
        public async Task SaveAsync()
        {
            await _context.SaveChangesAsync();
        }
    }
}
```

##### **Using Employee Repository inside Employees Controller:**

```C#
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using CRUDinCoreMVC.Models;
using CRUDinCoreMVC.Repository;

namespace CRUDinCoreMVC.Controllers
{
    public class EmployeesController : Controller
    {
        //Other Than Employee Entity
        private readonly EFCoreDbContext _context;

        //For Employee Entity
        private readonly IEmployeeRepository _employeeRepository;
        public EmployeesController(IEmployeeRepository employeeRepository, EFCoreDbContext context)
        {
            _employeeRepository = employeeRepository;
            _context = context;
        }

        // GET: Employees
        public async Task<IActionResult> Index()
        {
            var employees = await _employeeRepository.GetAllAsync();
            return View(employees);
        }

        // GET: Employees/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var employee = await _employeeRepository.GetByIdAsync(Convert.ToInt32(id));
            if (employee == null)
            {
                return NotFound();
            }

            return View(employee);
        }

        // GET: Employees/Create
        public IActionResult Create()
        {
            ViewData["DepartmentId"] = new SelectList(_context.Departments, "DepartmentId", "Name");
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
                await _employeeRepository.InsertAsync(employee);

                //Call SaveAsync to Insert the data into the database
                await _employeeRepository.SaveAsync();
                return RedirectToAction(nameof(Index));
            }
            ViewData["DepartmentId"] = new SelectList(_context.Departments, "DepartmentId", "Name", employee.DepartmentId);
            return View(employee);
        }

        // GET: Employees/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null )
            {
                return NotFound();
            }

            var employee = await _employeeRepository.GetByIdAsync(Convert.ToInt32(id));
            if (employee == null)
            {
                return NotFound();
            }
            ViewData["DepartmentId"] = new SelectList(_context.Departments, "DepartmentId", "Name", employee.DepartmentId);
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
                    await _employeeRepository.UpdateAsync(employee);
                    await _employeeRepository.SaveAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    var emp = await _employeeRepository.GetByIdAsync(employee.EmployeeId);
                    if (emp == null)
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
            ViewData["DepartmentId"] = new SelectList(_context.Departments, "DepartmentId", "Name", employee.DepartmentId);
            return View(employee);
        }

        // GET: Employees/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var employee = await _employeeRepository.GetByIdAsync(Convert.ToInt32(id));
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
            var employee = await _employeeRepository.GetByIdAsync(id);
            if (employee != null)
            {
                await _employeeRepository.DeleteAsync(id);
                await _employeeRepository.SaveAsync();
            }
            
            return RedirectToAction(nameof(Index));
        }
    }
}
```

