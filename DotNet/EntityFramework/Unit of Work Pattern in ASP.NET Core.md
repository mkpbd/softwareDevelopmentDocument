
##### **Unit of Work in Repository Pattern in ASP.NET Core MVC using EF Core**

The Unit of Work pattern is often used with the Repository Pattern in ASP.NET Core MVC applications using Entity Framework Core (EF Core). It provides a way to group one or more operations (like insert, update, delete) into a single transaction, ensuring that all operations succeed or fail together. This pattern is particularly useful for maintaining the integrity of the data across multiple operations.

![[word-image-44895-1.webp]]

![[word-image-44895-2-1024x269.webp]]

##### **Creating Domain Entities:**
**Employee.cs**

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
```

**Department.cs**

```C#
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

##### **Creating the DbContext**

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

##### **Implementing the Repository Pattern:**

**IGenericRepository.cs**
```C#
namespace CRUDinCoreMVC.GenericRepository
{
    //Here, we are creating the IGenericRepository interface as a Generic Interface
    //Here, we are applying the Generic Constraint, i.e., T is going to be a class
    public interface IGenericRepository<T> where T : class
    {
        Task<IEnumerable<T>> GetAllAsync();
        Task<T?> GetByIdAsync(object Id);
        Task InsertAsync(T Entity);
        Task UpdateAsync(T Entity);
        Task DeleteAsync(object Id);
        Task SaveAsync();
    }
}
```

**GenericRepository.cs**

```C#
using CRUDinCoreMVC.Models;
using Microsoft.EntityFrameworkCore;
namespace CRUDinCoreMVC.GenericRepository
{
    //The following GenericRepository class Implement the IGenericRepository Interface
    public class GenericRepository<T> : IGenericRepository<T> where T : class
    {
        //The following variable is going to hold the EFCoreDbContext instance
        protected readonly EFCoreDbContext _context;

        //The following Variable is going to hold the DbSet Entity
        protected readonly DbSet<T> _dbSet;

        public GenericRepository(EFCoreDbContext context)
        {
            //we are initializing the context object and DbSet variable
            _context = context;

            //Whatever Entity name we specify while creating the instance of GenericRepository
            //That Entity name  will be stored in the DbSet<T> variable
            _dbSet = context.Set<T>();
        }

        //This method will return all the Records from the table
        public async Task<IEnumerable<T>> GetAllAsync()
        {
            return await _dbSet.ToListAsync();
        }

        //This method will return the specified record from the table based on the Primary Key Column
        public async Task<T?> GetByIdAsync(object Id)
        {
            return await _dbSet.FindAsync(Id);
        }

        //This method will Insert one object into the table
        public async Task InsertAsync(T Entity)
        {
            //It will mark the Entity state as Added
            await _dbSet.AddAsync(Entity);
        }

        //This method is going to update an Existing Entity
        public async Task UpdateAsync(T Entity)
        {
            //It will mark the Entity state as Modified
            _dbSet.Update(Entity);
        }

        //This method is going to remove an existing record from the table
        public async Task DeleteAsync(object Id)
        {
            //First, fetch the record from the table
            var entity = await _dbSet.FindAsync(Id);
            if (entity != null)
            {
                //This will mark the Entity State as Deleted
                _dbSet.Remove(entity);
            }
        }

        //This method will make the changes permanent in the database
        public async Task SaveAsync()
        {
            await _context.SaveChangesAsync();
        }
    }
}
```

**IEmployeeRepository.cs**

```C#
using CRUDinCoreMVC.GenericRepository;
using CRUDinCoreMVC.Models;

namespace CRUDinCoreMVC.Repository
{
    public interface IEmployeeRepository : IGenericRepository<Employee>
    {
        //Here, you need to define the operations which are specific to Employee Entity

        //This method returns all the Employee entities along with Department data
        Task<IEnumerable<Employee>> GetAllEmployeesAsync();

        //This method returns one the Employee along with Department data based on the Employee Id
        Task<Employee?> GetEmployeeByIdAsync(int EmployeeID);

        //This method will return Employees by Departmentid
        Task<IEnumerable<Employee>> GetEmployeesByDepartmentAsync(int Departmentid);
    }
}
```

**EmployeeRepository.cs**

```C#
using CRUDinCoreMVC.GenericRepository;
using CRUDinCoreMVC.Models;
using Microsoft.EntityFrameworkCore;

namespace CRUDinCoreMVC.Repository
{
    public class EmployeeRepository : GenericRepository<Employee>, IEmployeeRepository
    {
        public EmployeeRepository(EFCoreDbContext context) : base(context) { }

        //Returns all employees from the database including the Department Data
        public async Task<IEnumerable<Employee>> GetAllEmployeesAsync()
        {
            return await _context.Employees.Include(e => e.Department).ToListAsync();
        }

        //Retrieves a single employee by their ID along with Department data.
        public async Task<Employee?> GetEmployeeByIdAsync(int EmployeeID)
        {
            var employee = await _context.Employees
               .Include(e => e.Department)
               .FirstOrDefaultAsync(m => m.EmployeeId == EmployeeID);

            return employee;
        }

        //Retrieves Employees by Departmentid
        public async Task<IEnumerable<Employee>> GetEmployeesByDepartmentAsync(int DepartmentId)
        {
            return await _context.Employees
                .Where(emp => emp.DepartmentId == DepartmentId)
                .Include(e => e.Department).ToListAsync();
        }
    }
}
```

**DepartmentRepository.cs**
```C#
using CRUDinCoreMVC.GenericRepository;
using CRUDinCoreMVC.Models;

namespace CRUDinCoreMVC.Repository
{
    //Note: if you want to add some methods specific to the Department Entity, you can define here
    public interface IDepartmentRepository : IGenericRepository<Department>
    {
    }

    public class DepartmentRepository : GenericRepository<Department>, IDepartmentRepository
    {
        public DepartmentRepository(EFCoreDbContext context) : base(context) { }
    }
}
```
##### **Implementing the Unit of Work Pattern in ASP.NET Core MVC**

 Add a folder with the name **UOW** within the project root directory. Once the folder is added, add one interface named **IUnitOfWork.cs** within the UOW folder and copy and paste the following code. As you can see in the code below, we are declaring the operations that are required to implement the Unit of Work, like Creating the Transaction, Committing the Transaction, Roll Backing the Transaction, and the SaveChanges method, which will make the changes permanent in the database.
```C#
using CRUDinCoreMVC.Repository;
namespace CRUDinCoreMVC.UOW
{
    public interface IUnitOfWork
    {
        //Define the Specific Repositories
        EmployeeRepository Employees { get; }
        DepartmentRepository Departments { get; }

        //This Method will Start the database Transaction
        void CreateTransaction();

        //This Method will Commit the database Transaction
        void Commit();

        //This Method will Rollback the database Transaction
        void Rollback();

        //This Method will call the SaveChanges method
        Task Save();
    }
}
```

##### **Implement IUnitOfWork Interface:**

```C#
using Microsoft.EntityFrameworkCore.Storage;
using Microsoft.EntityFrameworkCore;
using CRUDinCoreMVC.Models;
using CRUDinCoreMVC.Repository;

namespace CRUDinCoreMVC.UOW
{
    //Generic UnitOfWork Class
    //Implementing the IUnitOfWork and IDisposable Interfaces
    public class UnitOfWork : IUnitOfWork, IDisposable
    {
        //The following varibale will hold DbContext Instance
        public EFCoreDbContext Context = null;

        //The following varibale will hold the Transaction Instance
        private IDbContextTransaction? _objTran = null;

        //Using the following variable we can call the Operations of GenericRepository and EmployeeRepository
        public EmployeeRepository Employees { get; private set; }

        //Using the following variable we can call the Operations of GenericRepository and DepartmentRepository
        public DepartmentRepository Departments { get; private set; }

        //Initializing the Context, Employees, and Departments objects
        public UnitOfWork(EFCoreDbContext _Context)
        {
            Context = _Context;
            Employees = new EmployeeRepository(Context);
            Departments = new DepartmentRepository(Context);
        }

        //The CreateTransaction() method will create a database Transaction so that we can do database operations
        //by applying do everything and do nothing principle
        public void CreateTransaction()
        {
            //It will Begin the transaction on the underlying connection
            _objTran = Context.Database.BeginTransaction();
        }

        //If all the Transactions are completed successfully then we need to call this Commit() 
        //method to Save the changes permanently in the database
        public void Commit()
        {
            //Commits the underlying store transaction
            _objTran?.Commit();
        }

        //If at least one of the Transaction is Failed then we need to call this Rollback() 
        //method to Rollback the database changes to its previous state
        public void Rollback()
        {
            //Rolls back the underlying store transaction
            _objTran?.Rollback();

            //The Dispose Method will clean up this transaction object and ensures Entity Framework
            //is no longer using that transaction.
            _objTran?.Dispose();
        }

        //The Save() Method will Call the DbContext Class SaveChanges method 
        //So whenever we do a transaction we need to call this Save() method 
        //so that it will make the changes in the database permanently
        public async Task Save()
        {
            try
            {
                //Calling DbContext Class SaveChanges method 
                await Context.SaveChangesAsync();
            }
            catch (DbUpdateException ex)
            {
                // Handle the exception, possibly logging the details
                // The InnerException often contains more specific details
                throw new Exception(ex.Message, ex);
            }
        }

        public void Dispose()
        {
            Context.Dispose();
        }
    }
}
```

##### **Configuring Dependency Injection:**

```C#
using CRUDinCoreMVC.Models;
using CRUDinCoreMVC.UOW;
using Microsoft.EntityFrameworkCore;

namespace CRUDinCoreMVC
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            //Configure the ConnectionString and DbContext Class
            builder.Services.AddDbContext<EFCoreDbContext>(options =>
            {
                options.UseSqlServer(builder.Configuration.GetConnectionString("EFCoreDBConnection"));
            });

            // Add services to the container.
            builder.Services.AddControllersWithViews();

            //Registering the UnitOfWork
            builder.Services.AddScoped<IUnitOfWork, UnitOfWork>();

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

            //Setting the Employees and Index action method as the default Route
            app.MapControllerRoute(
                name: "default",
                pattern: "{controller=Employees}/{action=Index}/{id?}");

            app.Run();
        }
    }
}
```

##### **Using the Unit of Work in Controllers**

```C#
	using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using CRUDinCoreMVC.Models;
using CRUDinCoreMVC.UOW;

namespace CRUDinCoreMVC.Controllers
{
    public class EmployeesController : Controller
    {
        //The following variable will hold the IUnitOfWork Instance
        private readonly IUnitOfWork _unitOfWork;

        public EmployeesController(IUnitOfWork unitOfWork)
        {
            _unitOfWork = unitOfWork;
        }

        // GET: Employees
        public async Task<IActionResult> Index()
        {
            //Use Employee Repository to Fetch all the employees along with the Department Data
            var employees = await _unitOfWork.Employees.GetAllEmployeesAsync();

            return View(employees);
        }

        // GET: Employees/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            //Use Employee Repository to Fetch Employees along with the Department Data by Employee Id
            var employee = await _unitOfWork.Employees.GetEmployeeByIdAsync(Convert.ToInt32(id));
            if (employee == null)
            {
                return NotFound();
            }

            return View(employee);
        }

        // GET: Employees/Create
        public async Task<IActionResult> Create()
        {
            ViewData["DepartmentId"] = new SelectList(await _unitOfWork.Departments.GetAllAsync(), "DepartmentId", "Name");
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
                try
                {
                    //Begin The Tranaction
                    _unitOfWork.CreateTransaction();

                    //Use Generic Reposiory to Insert a new employee
                    await _unitOfWork.Employees.InsertAsync(employee);

                    //Call SaveAsync to Insert the data into the database
                    //await _repository.SaveAsync();

                    //Save Changes to database
                    await _unitOfWork.Save();

                    //Commit the Changes to database
                    _unitOfWork.Commit();
                    
                    return RedirectToAction(nameof(Index));
                }
                catch (Exception)
                {
                    //Rollback Transaction
                    _unitOfWork.Rollback();
                    //Log The Exception
                }
            }
            ViewData["DepartmentId"] = new SelectList(await _unitOfWork.Departments.GetAllAsync(), "DepartmentId", "Name", employee.DepartmentId);
            return View(employee);
        }

        // GET: Employees/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var employee = await _unitOfWork.Employees.GetByIdAsync(id);
            if (employee == null)
            {
                return NotFound();
            }
            ViewData["DepartmentId"] = new SelectList(await _unitOfWork.Departments.GetAllAsync(), "DepartmentId", "Name", employee.DepartmentId);
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
                    //Begin The Tranaction
                    _unitOfWork.CreateTransaction();

                    //Use Generic Reposiory to Insert a new employee
                    await _unitOfWork.Employees.UpdateAsync(employee);

                    //Save Changes to database
                    await _unitOfWork.Save();

                    //Commit the Changes to database
                    _unitOfWork.Commit();

                    return RedirectToAction(nameof(Index));
                }
                catch (DbUpdateConcurrencyException)
                {
                    //Rollback Transaction
                    _unitOfWork.Rollback();
                }
            }
            ViewData["DepartmentId"] = new SelectList(await _unitOfWork.Departments.GetAllAsync(), "DepartmentId", "Name", employee.DepartmentId);
            return View(employee);
        }

        // GET: Employees/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            //Use Employee Repository to Fetch Employees along with the Department Data by Employee Id
            var employee = await _unitOfWork.Employees.GetEmployeeByIdAsync(Convert.ToInt32(id));

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
            //Begin The Tranaction
            _unitOfWork.CreateTransaction();

            var employee = await _unitOfWork.Employees.GetByIdAsync(id);
            if (employee != null)
            {
                try
                {
                    await _unitOfWork.Employees.DeleteAsync(id);

                    //Save Changes to database
                    await _unitOfWork.Save();

                    //Commit the Changes to database
                    _unitOfWork.Commit();
                }
                catch (Exception)
                {
                    //Rollback Transaction
                    _unitOfWork.Rollback();
                }
            }

            return RedirectToAction(nameof(Index));
        }
    }
}
```

