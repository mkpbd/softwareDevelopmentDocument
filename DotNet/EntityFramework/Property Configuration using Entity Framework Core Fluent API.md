- **HasColumnName():** We need to use the EF Core Fluent API HasColumnName method to configure the column name for a property. This method allows us to specify the name of the column in the database that corresponds to the property.
- **HasColumnType():** We need to use the EF Core Fluent API HasColumnType method to configure the data type of a column. This method allows us to specify the data type that the column should have in the database.
- **HasColumnOrder():** We need to use the EF Core Fluent API HasColumnOrder method to configure the order of a column in the database table. This method allows us to specify the position of the column relative to other columns in the table.

```C#
namespace EFCoreCodeFirstDemo.Entities
{
    public class Student
    {
        public int StudentId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public DateTime DateOfBirth { get; set; }
    }
}
```

```C#
using Microsoft.EntityFrameworkCore;
namespace EFCoreCodeFirstDemo.Entities
{
    public class EFCoreDbContext : DbContext
    {
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            //Configuring the Connection String
            optionsBuilder.UseSqlServer(@"Server=LAPTOP-6P5NK25R\SQLSERVER2022DEV;Database=EFCoreDB;Trusted_Connection=True;TrustServerCertificate=True;");
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            //Configure Column Name, Order, and Type

            // Configure DateOfBirth column
            modelBuilder.Entity<Student>()
                        .Property(p => p.DateOfBirth)
                        .HasColumnName("DOB")
                        .HasColumnOrder(2)
                        .HasColumnType("datetime2");

            // Configure StudentId column
            modelBuilder.Entity<Student>()
                        .Property(p => p.StudentId)
                        .HasColumnType("int")
                        .HasColumnOrder(0);

            // Configure FirstName column
            modelBuilder.Entity<Student>()
                         .Property(p => p.FirstName)
                         .HasColumnType("nvarchar(50)")
                         .HasColumnOrder(1);

            // Configure LastName column
            modelBuilder.Entity<Student>()
                        .Property(p => p.LastName)
                        .HasColumnOrder(3);
        }

        public DbSet<Student> Students { get; set; }
    }
}
```

![[word-image-43992-1-768x321.webp]]

![[word-image-43992-2.webp]]

```C#
namespace EFCoreCodeFirstDemo.Entities
{
    public class Student
    {
        public int StudentId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public decimal Height { get; set; }
        public byte[] Photo { get; set; }
    }
}
```

```C#
using Microsoft.EntityFrameworkCore;
namespace EFCoreCodeFirstDemo.Entities
{
    public class EFCoreDbContext : DbContext
    {
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            //Configuring the Connection String
            optionsBuilder.UseSqlServer(@"Server=LAPTOP-6P5NK25R\SQLSERVER2022DEV;Database=EFCoreDB;Trusted_Connection=True;TrustServerCertificate=True;");
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            //Set FirstName column size to 50, by default data type as nvarchar i.e. variable length
            modelBuilder.Entity<Student>()
                    .Property(p => p.FirstName)
                    .HasMaxLength(50);

            //Set LastName column size to 50 and change datatype to nchar
            //IsFixedLength() change datatype from nvarchar to nchar
            modelBuilder.Entity<Student>()
                    .Property(p => p.LastName)
                    .HasMaxLength(50)
                    .IsFixedLength();

            //Set Height column size to decimal(2,2)
            modelBuilder.Entity<Student>()
                .Property(p => p.Height)
                .HasPrecision(2, 2);

            //Set Photo column size to 1024 Byte
            modelBuilder.Entity<Student>()
                    .Property(p => p.Photo)
                    .HasMaxLength(50);
        }

        public DbSet<Student> Students { get; set; }
    }
}
```

```C#
using Microsoft.EntityFrameworkCore;
namespace EFCoreCodeFirstDemo.Entities
{
    public class EFCoreDbContext : DbContext
    {
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            //Configuring the Connection String
            optionsBuilder.UseSqlServer(@"Server=LAPTOP-6P5NK25R\SQLSERVER2022DEV;Database=EFCoreDB;Trusted_Connection=True;TrustServerCertificate=True;");
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            //Configure NOT NULL for FirstName column which is by default NULL 
            modelBuilder.Entity<Student>()
                    .Property(p => p.FirstName)
                    .IsRequired(); //By Default True

            //Configure NULL for LastName column which is by default NULL 
            modelBuilder.Entity<Student>()
                .Property(p => p.LastName)
                .IsRequired(true);

            //Configure NULL for MiddleName column as NULL 
            modelBuilder.Entity<Student>()
                .Property(p => p.MiddleName)
                .IsRequired(false);
        }

        public DbSet<Student> Students { get; set; }
    }
}
```

##### **How to Ignore Table and Column Mapping using EF Core Fluent API?**

```C#
using Microsoft.EntityFrameworkCore;
namespace EFCoreCodeFirstDemo.Entities
{
    public class EFCoreDbContext : DbContext
    {
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            //Configuring the Connection String
            optionsBuilder.UseSqlServer(@"Server=LAPTOP-6P5NK25R\SQLSERVER2022DEV;Database=EFCoreDB;Trusted_Connection=True;TrustServerCertificate=True;");
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            //Ignore the Branch Property while generating the database
            modelBuilder.Entity<Student>().Ignore(t => t.Branch);
            //Ignore the Standard Entity while generating the database
			modelBuilder.Ignore<Standard>();
        }

        public DbSet<Student> Students { get; set; }
        public DbSet<Standard> Standards { get; set; }
        
    }
}
```



##### **How to Save a Disconnected Entity in Entity Framework?**
![[word-image-44140-1.webp]]

##### **How to Call Stored Procedure in Entity Framework Core**
###### **Executing a Stored Procedure that Returns Data:**

If your stored procedure returns data, you can execute the Stored Procedure using the **FromSqlRaw** or **FromSqlInterpolated** methods and map the results to entity types. Suppose you have a stored procedure named **GetCustomers** that returns a set of customers.
```C#
var customers = context.Customers.FromSqlRaw("EXEC GetCustomers").ToList();
//Using interpolated syntax (which is safer from SQL injection):
var customers = context.Customers.FromSqlInterpolated($"EXEC GetCustomers").ToList();
```

**Executing a Stored Procedure for INSERT, UPDATE, DELETE**
```C#
context.Database.ExecuteSqlRaw("EXEC UpdateCustomer @CustomerId, @Name", parameters: new[] { customerIdParameter, nameParameter });
//Using interpolated syntax:
context.Database.ExecuteSqlInterpolated($"EXEC UpdateCustomer {customerId}, {name}");
```

**Stored Procedure with Output Parameters**

```C#
//Input Parameter
var customerIdParameter = new SqlParameter("CustomerId", 1);
//Output Parameter
var customerNameParameter = new SqlParameter
{
    ParameterName = "CustomerName",
    SqlDbType = SqlDbType.VarChar,
    Direction = ParameterDirection.Output,
    Size = 50
};

context.Database.ExecuteSqlRaw("EXEC GetCustomerName @CustomerId, @CustomerName OUTPUT", customerIdParameter, customerNameParameter);

var customerName = customerNameParameter.Value.ToString();
```

```C#
using EFCoreCodeFirstDemo.Entities;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using System.Data;

namespace EFCoreCodeFirstDemo
{
    public class Program
    {
        static async Task Main(string[] args)
        {
            try
            {
                Student student1 = new Student()
                {
                    FirstName = "Pranaya",
                    LastName = "Rout",
                    Branch = "CSE",
                    Gender = "Male"
                };

                Student student2 = new Student()
                {
                    FirstName = "Hina",
                    LastName = "Sharma",
                    Branch = "CSE",
                    Gender = "Female"
                };

                //Call the AddStudent Method to add a new Student into the Database
                int Id1 = AddStudent(student1);
                Console.WriteLine($"Newly Added Student Id: {Id1}");
                int Id2 = AddStudent(student2);
                Console.WriteLine($"Newly Added Student Id: {Id2}");

                //Call the GetStudentById Method to Retrieve a Single Student from the Database
                var student = GetStudentById(1);
                Console.WriteLine("\nGetStudentById: 1");
                Console.WriteLine($"Id:{student?.StudentId}, Name: {student?.FirstName} {student?.LastName}, Branch: {student?.Branch}, Gender:{student?.Gender}");

                //Call the GetAllStudents Method to Retrieve All Students from the Database
                List<Student> students = GetAllStudents() ?? new List<Student>();
                Console.WriteLine("\nGetAllStudents");
                foreach (var std in students)
                {
                    Console.WriteLine($"Id:{student?.StudentId}, Name: {student?.FirstName} {student?.LastName}, Branch: {student?.Branch}, Gender:{student?.Gender}");
                }

                //Let us Update the Student Whose Id = 1 i.e.student object
                if (student != null)
                {
                    student.FirstName = "Prateek";
                    student.LastName = "Sahoo";

                    //Call the UpdateStudent Method to Update an Existing Student in the Database
                    UpdateStudent(student);
                   
                    student = GetStudentById(student.StudentId);
                    Console.WriteLine("After Updation");
                    Console.WriteLine($"Id:{student?.StudentId}, Name: {student?.FirstName} {student?.LastName}, Branch: {student?.Branch}, Gender:{student?.Gender}");
                }

                //Let us Delete the Student Whose Id = 1 i.e. student object
                if (student != null)
                {
                    DeleteStudent(student.StudentId);
                }

                Console.Read();
            }

            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}"); ;
            }
        }
    
        //The following Method is going to add a New Student into the database
        //And return the new StudentId
        public static int AddStudent(Student student)
        {
            int result = 0;
            try
            {
                using var context = new EFCoreDbContext();

                var FirstNameParam = new SqlParameter("@FirstName", SqlDbType.NVarChar)
                {
                    Value = student.FirstName
                };

                var LastNameParam = new SqlParameter("@LastName", SqlDbType.NVarChar)
                {
                    Value = student.LastName
                };

                var BranchParam = new SqlParameter("@Branch", SqlDbType.NVarChar)
                {
                    Value = student.Branch
                };

                var GenderParam = new SqlParameter("@Gender", SqlDbType.NVarChar)
                {
                    Value = student.Gender
                };

                var StudentIdOutParam = new SqlParameter("@StudentId", SqlDbType.Int)
                {
                    Direction = ParameterDirection.Output
                };

                int NumberOfRowsAffected = context.Database.ExecuteSqlRaw("EXEC spInsertStudent @FirstName, @LastName, @Branch, @Gender, @StudentId OUTPUT",
                    FirstNameParam, LastNameParam, BranchParam, GenderParam, StudentIdOutParam);

                if (NumberOfRowsAffected > 0)
                {
                    // Retrieve the value of the OUT parameter
                    result = (int) StudentIdOutParam.Value;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"AddStudent: Error Occurred: {ex.Message}");
            }
            return result;
        }

        //The following Method is going to return a Single Student from the database based on Student Id
        //And return the new StudentId
        public static Student? GetStudentById(int StudentId)
        {
            Student? student = null;

            try
            {
                using var context = new EFCoreDbContext();

                var StudentIdParam = new SqlParameter("@StudentId", SqlDbType.Int)
                {
                    Value = StudentId
                };

                //Returning A Single Student Entity
                //Execute the non-composable part of your query first using FromSqlRaw or SqlQuery, and
                //materialize the results by calling ToList, ToArray, or AsEnumerable to ensure the data is retrieved from the database
                var result = context.Students
                .FromSqlRaw("EXEC spGetStudentByStudentId @StudentId", StudentIdParam)
                .ToList(); //Materialize the result

                if(result.Count > 0)
                {
                    student = result.FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"GetStudentById: Error Occurred: {ex.Message}");
            }
            return student;
        }

        //The following Method is going to return all Students from the database 
        public static List<Student>? GetAllStudents()
        {
            List<Student>? students = new List<Student>();
            try
            {
                using var context = new EFCoreDbContext();

                //Returning All Students
                students = context.Students
                .FromSqlRaw("EXEC spGetAllStudents")
                .ToList();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"GetAllStudents: Error Occurred: {ex.Message}");
            }
            return students;
        }

        //The following Method is going to Update an Existing Student into the database
        public static void UpdateStudent(Student student)
        {
            try
            {
                using var context = new EFCoreDbContext();

                var StudentIdParam = new SqlParameter("@StudentId", SqlDbType.Int)
                {
                    Value = student.StudentId
                };

                var FirstNameParam = new SqlParameter("@FirstName", SqlDbType.NVarChar)
                {
                    Value = student.FirstName
                };

                var LastNameParam = new SqlParameter("@LastName", SqlDbType.NVarChar)
                {
                    Value = student.LastName
                };

                var BranchParam = new SqlParameter("@Branch", SqlDbType.NVarChar)
                {
                    Value = student.Branch
                };

                var GenderParam = new SqlParameter("@Gender", SqlDbType.NVarChar)
                {
                    Value = student.Gender
                };

                //result: Returns the number of rows affected
                var result = context.Database.ExecuteSqlRaw("EXEC spUpdateStudent @StudentId, @FirstName , @LastName, @Branch, @Gender",
                    StudentIdParam, FirstNameParam, LastNameParam, BranchParam, GenderParam);

                if (result > 0)
                {
                    Console.WriteLine($"\nEntity with StudentId: {student.StudentId} Updated in the Database");
                }
                else
                {
                    Console.WriteLine($"\nEntity with StudentId: {student.StudentId} Not Updated in the Database");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"AddStudent: Error Occurred: {ex.Message}");
            }
        }

        //The following Method is going to Delete an Existing Student from the database based on Student Id
        //And return the new StudentId
        public static Student? DeleteStudent(int StudentId)
        {
            Student? student = null;
            try
            {
                using var context = new EFCoreDbContext();

                var StudentIdParam = new SqlParameter("@StudentId", SqlDbType.Int)
                {
                    Value = StudentId
                };

                //Deleting an Existing Student Entity
                //result: Returns the number of rows affected
                var result = context.Database.ExecuteSqlRaw("EXEC spDeleteStudent @StudentId", StudentIdParam);
                if(result > 0)
                {
                    Console.WriteLine($"\nEntity with StudentId: {StudentId} Deleted from the Database");
                }
                else
                {
                    Console.WriteLine($"\nEntity with StudentId: {StudentId} Not Deleted from the Database");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"DeleteStudent: Error Occurred: {ex.Message}");
            }
            return student;
        }
    }
}
```


## **Seed Data in Entity Framework Core (EF Core)**

```C#
using System.ComponentModel.DataAnnotations.Schema;
namespace EFCoreCodeFirstDemo.Entities
{
    [Table("CountryMaster")]
    public class Country
    {
        public int CountryId { get; set; }
        public string CountryName { get; set; }
        public string CountryCode { get; set; }
    }

    [Table("StateMaster")]
    public class State
    {
        public int StateId { get; set; }
        public string StateName { get; set; }
        public int CountryId { get; set; }
    }

    [Table("CityMaster")]
    public class City
    {
        public int CityId { get; set; }
        public string CityName { get; set; }
        public int StateId { get; set; }
    }
}
```
##### **Add Seed Data to Your DbContext:**

```C#
using Microsoft.EntityFrameworkCore;
namespace EFCoreCodeFirstDemo.Entities
{
    public class EFCoreDbContext : DbContext
    {
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            //Configuring the Connection String
            optionsBuilder.UseSqlServer(@"Server=LAPTOP-6P5NK25R\SQLSERVER2022DEV;Database=EFCoreDB;Trusted_Connection=True;TrustServerCertificate=True;");
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            //Seeding Country Master Data using HasData method
            modelBuilder.Entity<Country>().HasData(
               new() { CountryId = 1, CountryName = "INDIA", CountryCode = "IND" },
               new() { CountryId = 2, CountryName = "Austrailla", CountryCode = "AUS" }
           );

            //Seeding State Master Data using HasData method
            modelBuilder.Entity<State>().HasData(
                new() {StateId =1, StateName = "ODISHA", CountryId = 1 },
                new() {StateId =2, StateName = "DELHI", CountryId = 1 }
            );

            //Seeding City Master Data using HasData method
            modelBuilder.Entity<City>().HasData(
                new() {CityId =1, CityName = "Bhubaneswar", StateId = 1 },
                new() {CityId =2, CityName = "Cuttack", StateId = 1 }
           );
        }

        public DbSet<Country> CountryMaster { get; set; }
        public DbSet<State> StateMaster { get; set; }
        public DbSet<City> CityMaster { get; set; }
    }
}
```

##### **Verify the Seed Data:**
```C#
using EFCoreCodeFirstDemo.Entities;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using System.Data;

namespace EFCoreCodeFirstDemo
{
    public class Program
    {
        static async Task Main(string[] args)
        {
            try
            {
                using (EFCoreDbContext context = new EFCoreDbContext())
                {
                    Console.WriteLine("Country Master:");
                    var Countries = context.CountryMaster.ToList();
                    foreach (var country in Countries)
                    {
                        Console.WriteLine($"\tCountry ID: {country.CountryId}, Name: {country.CountryName}, Code: {country.CountryCode}");
                    }
                    Console.WriteLine("State Master:");
                    var States = context.StateMaster.ToList();
                    foreach (var state in States)
                    {
                        Console.WriteLine($"\tState ID: {state.StateId}, Name: {state.StateName}");
                    }
                    Console.WriteLine("City Master:");
                    var Cities = context.CityMaster.ToList();
                    foreach (var city in Cities)
                    {
                        Console.WriteLine($"\tCity ID: {city.CityId}, Name: {city.CityName}");
                    }
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

