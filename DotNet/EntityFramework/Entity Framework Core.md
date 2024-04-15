
##### **What is ORM?**

The term ORM stands for Object-Relational Mapper, and it automatically creates classes based on database tables and vice versa is also true. It can also generate the necessary SQL to create the database based on the classes.

ORM Framework generates the necessary SQL (to perform the CRUD operation) that the underlying database can understand. So, in simple words, we can say that the ORM Framework eliminates the need for most of the data access code that, as a developer, we generally write.

![[c-users-pranaya-pictures-entity-framework-core-pn.webp]]

##### **EF Core Code First Approach:**
![[c-users-pranaya-pictures-entity-framework-core-co.webp]]

##### **EF Core Database First Approach:**

![[c-users-pranaya-pictures-ef-core-database-first-a.webp]]

##### **EF Core Database Providers:**
![[c-users-pranaya-pictures-ef-core-database-provide.webp]]
Install EF Core


![[word-image-29911-8-7.webp]]

![[word-image-29911-11-5.webp]]

![[word-image-29911-12-4.webp]]

![[word-image-29911-15-3.webp]]

###### **Database Migrations:**

- **Creating Migrations:** Generate code files that represent the model changes, which can be applied to the database schema.
- **Updating the Database:** Apply migrations to update the database schema to the latest version of the migration.
- **Removing Migrations:** Remove the latest migration, allowing you to make additional changes before regenerating the migration.
- **Generating SQL Scripts:** Produce SQL scripts from migrations and this is useful when direct database updates are not feasible (e.g., in strict production environments).

**Database Scaffolding:** EF Core Tools can create code-first model files from an existing database. This is useful when we have an existing database and want to represent it as a code-first model in our application.

**View DbContext Model:** EF Core Tools enable creating a visual representation (DGML file) of DbContext to understand entity relationships and structure.

###### **PowerShell Commands (Package Manager Console in Visual Studio):**

1. Add-Migration
2. Update-Database
3. Remove-Migration
4. Scaffold-DbContext

###### **.NET CLI Commands:**

1. dotnet ef migrations add
2. dotnet ef database update
3. dotnet ef migrations remove
4. dotnet ef dbcontext scaffold

To use EF Core Tools, developers typically install **Microsoft.EntityFrameworkCore.Tools** NuGet package for PowerShell commands and **Microsoft.EntityFrameworkCore.Design** package for .NET CLI commands.

## **DbContext Class in Entity Framework Core**

**Object Set Representation**
**Change Tracking**
**Database Operations**
**Configuration**
**Querying**

**Lazy Loading**

**Caching**

**Unit of Work:**
**Connection Management**
**Migrations**
**Relationship Management**
**Database Provider Agnosticism**
```C#
	using Microsoft.EntityFrameworkCore.Metadata.Internal;
using System.ComponentModel.DataAnnotations.Schema;

namespace EFCoreCodeFirstDemo.Entities
{
    public class Student
    {
        public int StudentId { get; set; }
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public DateTime? DateOfBirth { get; set; }

        [Column(TypeName = "decimal(18,4)")]
        public decimal Height { get; set; }

        [Column(TypeName = "decimal(18,4)")]
        public float Weight { get; set; }
        public virtual Standard? Standard { get; set; }
    }
}

```

```C#
namespace EFCoreCodeFirstDemo.Entities
{
    public class Standard
    {
        public int StandardId { get; set; }
        public string? StandardName { get; set; }
        public string? Description { get; set; }
        public ICollection<Student>? Students { get; set; }
    }
}

```

```C#
using Microsoft.EntityFrameworkCore;
namespace EFCoreCodeFirstDemo.Entities
{
    public class EFCoreDbContext : DbContext
    {
        //Constructor calling the Base DbContext Class Constructor
        public EFCoreDbContext() : base()
        {
        }

        //OnConfiguring() method is used to select and configure the data source
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            //use this to configure the contex
        }

        //OnModelCreating() method is used to configure the model using ModelBuilder Fluent API
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            //use this to configure the model
        }

        //Adding Domain Classes as DbSet Properties
        public DbSet<Student> Students { get; set; }
        public DbSet<Standard> Standards { get; set; }
    }
}

```


##### **DbContext Methods in Entity Framework Core:**

1. **Add**: Adds a new entity to DbContext with an Added state and starts tracking it. This new entity data will be inserted into the database when SaveChanges() is called.
2. **AddAsync**: Asynchronous method for adding a new entity to DbContext with Added state and starts tracking it. This new entity data will be inserted into the database when SaveChangesAsync() is called.
3. **AddRange**: Adds a collection of new entities to DbContext with Added state and starts tracking it. This new entity data will be inserted into the database when SaveChanges() is called.
4. **AddRangeAsync**: Asynchronous method for adding a collection of new entities, which will be saved on SaveChangesAsync().
5. **Attach**: Attaches a new or existing entity to DbContext with an Unchanged state and starts tracking it. In this case, nothing will happen when we call the SaveChanges method, as the entity state is not modified.
6. **AttachRange**: Attaches a collection of new or existing entities to DbContext with an Unchanged state and starts tracking it. In this case, nothing will happen when we call the SaveChanges method, as the entity state is not modified.
7. **Entry**: Gets an EntityEntry for the given entity. The entry provides access to change tracking information and operations for the entity.  So, using this method, we can manually set the Entity State, which DbContext will also track.
8. **Find**: Find an entity with the given primary key values.
9. **FindAsync**: Asynchronous method for finding an entity with the given primary key values.
10. **Remove**: It sets the Deleted state to the specified entity, which will delete the data when SaveChanges() is called.
11. **RemoveRange**: Sets Deleted state to a collection of entities that will delete the data in a single DB round trip when SaveChanges() is called.
12. **SaveChanges:** Execute INSERT, UPDATE, or DELETE commands to the database for the entities with Added, Modified, or Deleted state.
13. **SaveChangesAsync**: Asynchronous method of SaveChanges()
14. **Set**: Creates a DbSet TEntity that can be used to query and save instances of TEntity.
15. **Update**: Attaches disconnected entity with Modified state and starts tracking it. The data will be saved when SaveChagnes() is called.
16. **UpdateRange**: Attaches a collection of disconnected entities with a Modified state and starts tracking it. The data will be saved when SaveChagnes() is called.
17. **OnConfiguring**: Override this method to configure the database (and other options) for this context. This method is called for each instance of the context that is created.
18. **OnModelCreating**: Override this method to configure further the model discovered by convention from the entity types exposed in DbSet TEntity properties on your derived context.
##### **Providing Connection String in OnConfiguring Method of DbContext Class:**

```C# 
	using Microsoft.EntityFrameworkCore;
namespace EFCoreCodeFirstDemo.Entities
{
    public class EFCoreDbContext : DbContext
    {
        //Constructor calling the Base DbContext Class Constructor
        public EFCoreDbContext() 
        {
        }

        //OnConfiguring() method is used to select and configure the data source
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            //Configuring the Connection String
            optionsBuilder.UseSqlServer(@"Server=LAPTOP-6P5NK25R\SQLSERVER2022DEV;Database=EFCoreDB1;Trusted_Connection=True;TrustServerCertificate=True;");
        }

        //OnModelCreating() method is used to configure the model using ModelBuilder Fluent API
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            //use this to configure the model
        }

        //Adding Domain Classes as DbSet Properties
        public DbSet<Student> Students { get; set; }
        public DbSet<Standard> Standards { get; set; }
    }
}

```

##### **Adding Entity Framework Core Migration:**

![[word-image-41569-1.webp]]

![[word-image-41569-2-768x165.webp]]

![[word-image-41569-3.webp]]

![[word-image-41569-4-768x206.webp]]

##### **Reading or Writing Data using DbContext Class:**

```C#
using EFCoreCodeFirstDemo.Entities;
namespace EFCoreCodeFirstDemo
{
    internal class Program
    {
        static void Main(string[] args)
        {
            using var context = new EFCoreDbContext();
            try
            {
                //Create a New Student Object
                var student = new Student()
                {
                    FirstName = "Pranaya",
                    LastName = "Rout",
                    Height = 5.10M,
                    Weight = 50
                };

                //Add the Student into context object using DbSet Property and Add method
                context.Students.Add(student);

                //Call the SaveChanges method to make the changes Permanent into the Database
                context.SaveChanges();

                Console.WriteLine("Student Saved Successfully...");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}"); ;
            }
        }
    }
}
```

##### **How to use AppSettings.json files in .NET Core Console Application?**

![[word-image-29911-1-1.webp]]

![[word-image-29911-3.webp]]
![[word-image-29911-4.webp]]
#####  **appsettings.json**

``` json
	{
  "ConnectionStrings": {
    "SQLServerConnection": "Server=LAPTOP-6P5NK25R\\SQLSERVER2022DEV;Database=EFCoreDB1;Trusted_Connection=True;TrustServerCertificate=True;"
  }
}

```

##### **How to Fetch the Connection String from the appsettings.json file?**

**Step 1: Import the following namespace.**  
**using Microsoft.Extensions.Configuration;**

**Step 2: Load the Configuration File.**  
**var configBuilder = new ConfigurationBuilder().AddJsonFile(“appsettings.json”).Build();**

**Step 3: Get the Section to Read from the Configuration File**  
**var configSection = configBuilder.GetSection(“ConnectionStrings”);**

**Step 4: Get the Configuration Values based on the Config key.**  
**var connectionString = configSection[“SQLServerConnection”] ?? null;**


```C#
using Microsoft.EntityFrameworkCore;
//Step1: Import the following Namespace
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace EFCoreCodeFirstDemo.Entities
{
    public class EFCoreDbContext : DbContext
    {
        //Constructor calling the Base DbContext Class Constructor
        public EFCoreDbContext() : base()
        {
        }

        //OnConfiguring() method is used to select and configure the data source
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            //Get the Connection String from appsettings.json file

            //Step2: Load the Configuration File.
            var configBuilder = new ConfigurationBuilder().AddJsonFile("appsettings.json").Build();

            // Step3: Get the Section to Read from the Configuration File
            var configSection = configBuilder.GetSection("ConnectionStrings");

            // Step4: Get the Configuration Values based on the Config key.
            var connectionString = configSection["SQLServerConnection"] ?? null;
            
            //Configuring the Connection String
            optionsBuilder.UseSqlServer(connectionString);
        }

        //OnModelCreating() method is used to configure the model using ModelBuilder Fluent API
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            //use this to configure the model
        }

        //Adding Domain Classes as DbSet Properties
        public DbSet<Student> Students { get; set; }
        public DbSet<Standard> Standards { get; set; }
    }
}

```

```C#
using EFCoreCodeFirstDemo.Entities;
namespace EFCoreCodeFirstDemo
{
    internal class Program
    {
        static void Main(string[] args)
        {
            using var context = new EFCoreDbContext();
            try
            {
                //Create a New Student Object
                var student = new Student()
                {
                    FirstName = "Pranaya",
                    LastName = "Rout",
                    Height = 5.10M,
                    Weight = 50
                };

                //Add the Student into context object using DbSet Property and Add method
                context.Students.Add(student);

                //Call the SaveChanges method to make the changes Permanent into the Database
                context.SaveChanges();

                Console.WriteLine("Student Saved Successfully...");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}"); ;
            }
        }
    }
}

```

## **CRUD Operations in Entity Framework Core (EF Core)**

![[word-image-41668-1-768x328.webp]]

```C#
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace EFCoreCodeFirstDemo.Entities
{
    public class EFCoreDbContext : DbContext
    {
        //Constructor calling the Base DbContext Class Constructor
        public EFCoreDbContext() : base()
        {
        }

        //OnConfiguring() method is used to select and configure the data source
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            //To Display the Generated the Database Script
            optionsBuilder.LogTo(Console.WriteLine, LogLevel.Information);

            //Configuring the Connection String
            optionsBuilder.UseSqlServer(@"Server=LAPTOP-6P5NK25R\SQLSERVER2022DEV;Database=EFCoreDB1;Trusted_Connection=True;TrustServerCertificate=True;");
        }

        //OnModelCreating() method is used to configure the model using ModelBuilder Fluent API
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            //use this to configure the model
        }

        //Adding Domain Classes as DbSet Properties
        public DbSet<Student> Students { get; set; }
        public DbSet<Standard> Standards { get; set; }
    }
}

```


```C#
using EFCoreCodeFirstDemo.Entities;
namespace EFCoreCodeFirstDemo
{
    public class Program
    {
        static void Main(string[] args)
        {
            try
            {
                //Create a new student which you want to add to the database
                var newStudent = new Student()
                {
                    FirstName = "Pranaya",
                    LastName = "Rout",
                    DateOfBirth = new DateTime(1988, 02, 29),
                    Height = 5.10m,
                    Weight = 72
                };

                //Create DBContext object
                using var context = new EFCoreDbContext();

                //Add Student Entity into Context Object

                //Method1: Add Student Entity Using DbSet.Add Method
                context.Students.Add(newStudent);

                //Method2: Add Student Entity Using DbContext.Add Method with Type Parameter
                //context.Add<Student>(newStudent);

                //Method2: Add Student Entity Using DbContext.Add Method without Type Parameter
                //context.Add(newStudent);

                //Now the Entity State will be in Added State
                Console.WriteLine($"Before SaveChanges Entity State: {context.Entry(newStudent).State}");

                //Call SaveChanges method to save student entity into database
                context.SaveChanges();

                //Now the Entity State will change from Added State to Unchanged State
                Console.WriteLine($"After SaveChanges Entity State: {context.Entry(newStudent).State}");

                Console.WriteLine("Student Saved Successfully...");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}"); ;
            }

            Console.ReadKey();
        }
    }
}
```

```C#
	using EFCoreCodeFirstDemo.Entities;
namespace EFCoreCodeFirstDemo
{
    public class Program
    {
        static void Main(string[] args)
        {
            try
            {
                //Create DBContext object
                using var context = new EFCoreDbContext();

                //Fetch the Student from database whose Id = 1
                var student = context.Students.Find(1);

                if(student != null)
                {
                    //At this point Entity State will be Unchanged
                    Console.WriteLine($"Before Updating Entity State: {context.Entry(student).State}");

                    //Update the first name and last name
                    student.FirstName = "Prateek";
                    student.LastName = "Sahu";

                    //At this point Entity State will be Modified
                    Console.WriteLine($"After Updating Entity State: {context.Entry(student).State}");
                    
                    //Call SaveChanges method to update student data into database
                    context.SaveChanges();

                    //Now the Entity State will change from Modified State to Unchanged State
                    Console.WriteLine($"After SaveChanges Entity State: {context.Entry(student).State}");

                    Console.WriteLine("Student Updated Successfully...");
                }
                else
                {
                    Console.WriteLine("Invalid Student ID : 1");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}"); ;
            }

            Console.ReadKey();
        }
    }
}

```

## **Entity States in Entity Framework Core (EF Core)**

![[word-image-41670-1.webp]]

##### **Entity Lifecycle in Entity Framework Core**

![[Entity-Lifecycle-in-Entity-Framework-Core-1024x379.webp]]

##### **Attaching a New Entity to the Context**

If you have a new entity and if you attach the entity to the context object using the DbSet or DbContext attach method, then the context object will track the entity with Added state only, not Unchanged state. Once you call the SaveChanges method, It will insert that entity into the database and change the state from Added to Unchanged.

```C#
using EFCoreCodeFirstDemo.Entities;
using Microsoft.EntityFrameworkCore;
namespace EFCoreCodeFirstDemo
{
    public class Program
    {
        static void Main(string[] args)
        {
            try
            {
                //Create DBContext object
                using var context = new EFCoreDbContext();

                //Create an Existing student which you want to add to the database
                var existingStudent = new Student()
                {
                    FirstName = "Rakesh",
                    LastName = "Kumar",
                    DateOfBirth = new DateTime(1988, 02, 29),
                    Height = 5.10m,
                    Weight = 72
                };

                //Attaching the Entity to the Context
                context.Students.Attach(existingStudent);
                //context.Attach<Student>(existingStudent);
                //context.Attach(existingStudent);

                //Or you can also attach an existing entity as follows by updating the entity state
                //context.Entry(existingStudent).State = EntityState.Unchanged;

                //Check the Entity State Before SaveChanges
                Console.WriteLine($"Before SaveChanges Entity State: {context.Entry(existingStudent).State}");

                context.SaveChanges();

                //Check the Entity State After Calling the SaveChanges Method of Context Object
                Console.WriteLine($"After SaveChanges Entity State: {context.Entry(existingStudent).State}");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}"); ;
            }

            Console.ReadKey();
        }
    }
}
```

##### **What is LINQ?**

The LINQ (Language Integrated Query) is part of a language but not a complete language. Microsoft introduced LINQ with .NET Framework 3.5 and C# 3.0, available in the **System.Linq** namespace.

LINQ provides a Common Query Syntax that allows us to query the data from various sources. Using a single query, we can get or set the data from various data sources such as SQL Server database, XML documents, ADO.NET Datasets, and other in-memory objects such as Collections, Generics, etc. Please read the [**Architecture of LINQ**](https://dotnettutorials.net/lesson/introduction-to-linq/) article.


##### **What is Projection?**

Projection is nothing but the mechanism which is used to select the data from a data source. You can select the data in the same form (i.e., the original data in its original state). It is also possible to create a new form of data by performing some operations on it.

For example, in the database table, there is a Salary column. If you want, you can get the Salary Column Values as it is, i.e., in their original form. But, if you want to modify the Salary column values by adding a bonus amount of 10,000, then it is also possible. Don’t worry if this is unclear now; we will understand this with real-time examples.

##### **LINQ Query Methods:**

The LINQ Standard Query Methods are implemented as Extension Methods, and those methods can be used with LINQ-to-Entities queries. The following are examples of some of the standard LINQ Query methods.

1. **First() or FirstOrDefault()**
2. **Single()or SingleOrDefault()**
3. **ToList()**
4. **Count()**
5. **Min() and Max()**
6. **Sum()**
7. **Distinct()**
8. **Last() or LastOrDefault()**
9. **Average(), and many more**

**Note:** Besides the above LINQ Extension methods, you can use the DbSet Find() method to search an entity based on the primary key value.

```C#
using EFCoreCodeFirstDemo.Entities;
namespace EFCoreCodeFirstDemo
{
    internal class Program
    {
        static void Main(string[] args)
        {
            try
            {
                using var context = new EFCoreDbContext();

                //It will return the data from the database by executing SELECT SQL Statement
                var student = context.Students.Find(1);
                Console.WriteLine($"FirstName: {student?.FirstName}, LastName: {student?.LastName}");
                
                //It will return the data from the context object as the context object tracking the same data
                var student2 = context.Students.Find(1);
                Console.WriteLine($"FirstName: {student2?.FirstName}, LastName: {student2?.LastName}");

                //It will return the data from the database by executing SELECT SQL Statement
                var student3 = context.Students.Find(2);
                Console.WriteLine($"FirstName: {student3?.FirstName}, LastName: {student3?.LastName}");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}"); ;
            }
        }
    }
}

```
##### **Example to Understand DbSet Find() Method in EF Core:**

```C#
using EFCoreCodeFirstDemo.Entities;
namespace EFCoreCodeFirstDemo
{
    internal class Program
    {
        static void Main(string[] args)
        {
            try
            {
                using var context = new EFCoreDbContext();

                //It will return the data from the database by executing SELECT SQL Statement
                var student = context.Students.Find(1);
                Console.WriteLine($"FirstName: {student?.FirstName}, LastName: {student?.LastName}");
                
                //It will return the data from the context object as the context object tracking the same data
                var student2 = context.Students.Find(1);
                Console.WriteLine($"FirstName: {student2?.FirstName}, LastName: {student2?.LastName}");

                //It will return the data from the database by executing SELECT SQL Statement
                var student3 = context.Students.Find(2);
                Console.WriteLine($"FirstName: {student3?.FirstName}, LastName: {student3?.LastName}");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}"); ;
            }
        }
    }
}

```

```C#
using EFCoreCodeFirstDemo.Entities;
namespace EFCoreCodeFirstDemo
{
    internal class Program
    {
        static void Main(string[] args)
        {
            try
            {
                using var context = new EFCoreDbContext();

                //FirstOrDefault method using Method Syntax
                var student1 = context.Students.FirstOrDefault(s => s.FirstName == "Pranaya");
                Console.WriteLine($"FirstName: {student1?.FirstName}, LastName: {student1?.LastName}");
                
                //First method using Method Syntax
                var student2 = context.Students.First(s => s.FirstName == "Pranaya");
                Console.WriteLine($"FirstName: {student2?.FirstName}, LastName: {student2?.LastName}");

                //FirstOrDefault method using Query Syntax
                var student3 = (from s in context.Students
                                where s.FirstName == "Pranaya"
                                select s).FirstOrDefault();
                Console.WriteLine($"FirstName: {student3?.FirstName}, LastName: {student3?.LastName}");

                //First method using Query Syntax
                var student4 = (from s in context.Students
                                where s.FirstName == "Pranaya"
                                select s).First();
                Console.WriteLine($"FirstName: {student4?.FirstName}, LastName: {student4?.LastName}");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}"); ;
            }
        }
    }
}

```

```C#
	using EFCoreCodeFirstDemo.Entities;
namespace EFCoreCodeFirstDemo
{
    internal class Program
    {
        static void Main(string[] args)
        {
            try
            {
                //Creating an Instance of Context class
                using var context = new EFCoreDbContext();

                //Creating a Variable
                string FirstName = "Pranaya";

                //Using the Variable
                var student = context.Students
                              .FirstOrDefault(s => s.FirstName == FirstName);

                Console.WriteLine($"FirstName: {student?.FirstName}, LastName: {student?.LastName}");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}"); ;
            }
        }
    }
}

```

##### **LINQ ToList Method:**

```c#
	using EFCoreCodeFirstDemo.Entities;
namespace EFCoreCodeFirstDemo
{
    internal class Program
    {
        static void Main(string[] args)
        {
            try
            {
                //Creating an Instance of Context class
                using var context = new EFCoreDbContext();

                //Fetching All the Students from Students table
                var studentList = context.Students.ToList();

                //Displaying all the Student information
                foreach (var student in studentList)
                {
                    Console.WriteLine($"FirstName: {student?.FirstName}, LastName: {student?.LastName}");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}"); ;
            }
        }
    }
}

```

##### **LINQ OrderBy Method:**
```
using EFCoreCodeFirstDemo.Entities;
namespace EFCoreCodeFirstDemo
{
    internal class Program
    {
        static void Main(string[] args)
        {
            try
            {
                //Creating an Instance of Context class
                using var context = new EFCoreDbContext();

                //Order By using Query syntax
                var studentsQS = from s in context.Students
                                 orderby s.FirstName ascending
                                 select s;
                
                //Order By using Method syntax
                var studentsMS = context.Students.OrderBy(s => s.FirstName).ToList();

                //Displaying the Records
                foreach (var student in studentsQS)
                {
                    Console.WriteLine($"\tFirstName: {student?.FirstName}, LastName: {student?.LastName}");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}"); ;
            }
        }
    }
}

```

##### **Anonymous Object Result:**


```C#
	using EFCoreCodeFirstDemo.Entities;
namespace EFCoreCodeFirstDemo
{
    internal class Program
    {
        static void Main(string[] args)
        {
            try
            {
                //Creating an Instance of Context class
                using var context = new EFCoreDbContext();

                // Query Syntax to Project the Result to an Anonymous Type
                var selectQuery = (from std in context.Students
                                   select new
                                   {
                                       firstName = std.FirstName,
                                       lastName = std.LastName,
                                       height = std.Height
                                   });

                //Displaying the Record
                foreach (var student in selectQuery)
                {
                    Console.WriteLine($"FirstName: {student?.firstName}, LastName: {student?.lastName}, Height: {student?.height}");
                }

                //Method Syntax to Project the Result to an Anonymous Type
                var selectMethod = context.Students.
                                              Select(std => new
                                              {
                                                  firstName = std.FirstName,
                                                  lastName = std.LastName,
                                                  height = std.Height
                                              }).ToList();

                //Displaying the Record
                foreach (var student in selectMethod)
                {
                    Console.WriteLine($"FirstName: {student?.firstName}, LastName: {student?.lastName}, Height: {student?.height}");
                }

            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}"); ;
            }
        }
    }
}

```

##### **LINQ Join Method:**

The LINQ Inner join returns only the matching records from both the data sources while the non-matching elements are removed from the result set. So, if you have two data sources, let us say Students and Standards, and when you perform the LINQ inner join, only the matching records, i.e., the records in both Students and Standards tables, are included in the result set. For a better understanding, please have a look at the following example.

```C#
using EFCoreCodeFirstDemo.Entities;
namespace EFCoreCodeFirstDemo
{
    internal class Program
    {
        static void Main(string[] args)
        {
            try
            {
                //Creating an Instance of Context class
                using var context = new EFCoreDbContext();

                //Join using Method Syntax
                var JoinUsingMS = context.Students //Outer Data Source
                            .Join(
                            context.Standards,  //Inner Data Source
                            student => student.Standard.StandardId, //Inner Key Selector
                            standard => standard.StandardId, //Outer Key selector
                            (student, standard) => new //Projecting the data into an anonymous type
                            {
                                StudentName = student.FirstName + " " + student.LastName,
                                StandrdId = standard.StandardId,
                                StandardDescriptin = standard.Description,
                                StudentHeight = student.Height
                            }).ToList();

                foreach (var student in JoinUsingMS)
                {
                    Console.WriteLine($"Name: {student?.StudentName}, StandrdId: {student?.StandrdId}, Height: {student?.StudentHeight}");
                }

                //Join using Query Syntax
                var JoinUsingQS = (from student in context.Students
                                   join standard in context.Standards
                                   on student.Standard.StandardId equals standard.StandardId
                                   select new
                                   {
                                       StudentName = student.FirstName + " " + student.LastName,
                                       StandrdId = standard.StandardId,
                                       StudentHeight = student.Height
                                   }).ToList();
                foreach (var student in JoinUsingQS)
                {
                    Console.WriteLine($"Name: {student?.StudentName}, StandrdId: {student?.StandrdId}, Height: {student?.StudentHeight}");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}"); ;
            }
        }
    }
}

```


## **Eager Loading in Entity Framework Core (EF Core)**


Eager loading in Entity Framework Core is a technique used to load related data of an entity as part of the initial query. It’s an efficient way to retrieve all necessary data in a single database query, avoiding the need for multiple round-trip calls to the database. This is useful when you know you need related data for each entity and want to optimize performance by minimizing the number of queries. Eager loading is achieved using the Include and ThenInclude methods within a LINQ query:

##### **What is Eager Loading in Entity Framework Core?**

Eager Loading in Entity Framework Core loads related entities whenever we load the main entity in a single query. This helps reduce the number of database queries or round-trips and improves performance by retrieving all necessary data in one go. This approach is efficient as it saves bandwidth and server CPU time. Eager loading is especially useful when we want to access properties of related entities without triggering additional database requests. Entity Framework Core achieves this by using JOINs to load the related entities instead of separate SQL queries.

**Student.cs**
```C# 
	namespace EFCoreCodeFirstDemo.Entities
{
    public class Student
    {
        public int StudentId { get; set; }
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public int? StandardId { get; set; }
        public virtual Standard? Standard { get; set; }
        public virtual StudentAddress? StudentAddress { get; set; }
        public virtual ICollection<Course> Courses { get; set; } = new List<Course>();
    }
}

```

**Standard.cs**

```C#
namespace EFCoreCodeFirstDemo.Entities
{
    public class Standard
    {
        public int StandardId { get; set; }
        public string? StandardName { get; set; }
        public string? Description { get; set; }
        public virtual ICollection<Student> Students { get; set; } = new List<Student>();
        public virtual ICollection<Teacher> Teachers { get; set; } = new List<Teacher>();
    }
}

```
**StudentAddress.cs**
```C#
using System.ComponentModel.DataAnnotations;
namespace EFCoreCodeFirstDemo.Entities
{
    public class StudentAddress
    {
        [Key]
        public int StudentId { get; set; }
        public string? Address1 { get; set; }
        public string? Address2 { get; set; }
        public string? Mobile { get; set; }
        public string? Email { get; set; }
        public virtual Student Student { get; set; } = null!;
    }
}

```

**Course.cs**

```C#
	namespace EFCoreCodeFirstDemo.Entities
{
    public class Course
    {
        public int CourseId { get; set; }
        public string? CourseName { get; set; }
        public int? TeacherId { get; set; }
        public virtual Teacher? Teacher { get; set; }
        public virtual ICollection<Student> Students { get; set; } = new List<Student>();
    }
}

```

**Teacher.cs**

```C#
	namespace EFCoreCodeFirstDemo.Entities
{
    public class Teacher
    {
        public int TeacherId { get; set; }
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public int? StandardId { get; set; }
        public virtual ICollection<Course> Courses { get; set; } = new List<Course>();
        public virtual Standard? Standard { get; set; }
    }
}

```

##### **Modifying the Context Class:**

```c#
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
namespace EFCoreCodeFirstDemo.Entities
{
    public class EFCoreDbContext : DbContext
    {
        //Constructor calling the Base DbContext Class Constructor
        public EFCoreDbContext() : base()
        {
        }

        //OnConfiguring() method is used to select and configure the data source
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            //To Display the Generated the Database Script
            optionsBuilder.LogTo(Console.WriteLine, LogLevel.Information);

            //Configuring the Connection String
            optionsBuilder.UseSqlServer(@"Server=LAPTOP-6P5NK25R\SQLSERVER2022DEV;Database=EFCoreDB1;Trusted_Connection=True;TrustServerCertificate=True;");
        }

        //OnModelCreating() method is used to configure the model using ModelBuilder Fluent API
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            //Use this to configure the model using Fluent API
        }

        //Adding Domain Classes as DbSet Properties
        public virtual DbSet<Course> Courses { get; set; }
        public virtual DbSet<Standard> Standards { get; set; }
        public virtual DbSet<Student> Students { get; set; }
        public virtual DbSet<StudentAddress> StudentAddresses { get; set; }
        public virtual DbSet<Teacher> Teachers { get; set; }
    }
}

```


![[word-image-41710-1-768x536.webp]]


![[word-image-41710-2-768x100 1.webp]]

![[word-image-41710-5-768x100.webp]]

##### **Eager Loading in EF Core:**

So, to understand Eager Loading in EF Core, we need to have some data in the database table. So, please execute the following SQL Script to insert some dummy data into the respective database tables using SSMS

```sql
	-- Use EFCoreDB1
USE EFCoreDB1;
GO

-- Standards table data
INSERT INTO Standards VALUES('STD1', 'Outstanding');
INSERT INTO Standards VALUES('STD2', 'Good');
INSERT INTO Standards VALUES('STD3', 'Average');
INSERT INTO Standards VALUES('STD4', 'Below Average');
GO

-- Teachers table data
INSERT INTO Teachers VALUES('Anurag', 'Mohanty', 1);
INSERT INTO Teachers VALUES('Preety', 'Tiwary', 2);
INSERT INTO Teachers VALUES('Priyanka', 'Dewangan', 3);
INSERT INTO Teachers VALUES('Sambit', 'Satapathy', 3);
INSERT INTO Teachers VALUES('Hina', 'Sharma', 2);
INSERT INTO Teachers VALUES('Sushanta', 'Jena', 1);
GO

-- Courses table data
INSERT INTO Courses VALUES('.NET', 1);
INSERT INTO Courses VALUES('Java', 2);
INSERT INTO Courses VALUES('PHP', 3);
INSERT INTO Courses VALUES('Oracle', 4);
INSERT INTO Courses VALUES('Android', 5);
INSERT INTO Courses VALUES('Python', 6);
GO

-- Students table data
INSERT INTO Students VALUES('Pranaya', 'Rout', 1);
INSERT INTO Students VALUES('Prateek', 'Sahu', 2);
INSERT INTO Students VALUES('Anurag', 'Mohanty', 3);
INSERT INTO Students VALUES('Hina', 'Sharma', 4);
GO


-- StudentAddresses table data
INSERT INTO StudentAddresses VALUES(1, 'Lane1', 'Lane2', '1111111111', '1@dotnettutorials.net');
INSERT INTO StudentAddresses VALUES(2, 'Lane3', 'Lane4', '2222222222', '2@dotnettutorials.net');
INSERT INTO StudentAddresses VALUES(3, 'Lane5', 'Lane6', '3333333333', '3@dotnettutorials.net');
INSERT INTO StudentAddresses VALUES(4, 'Lane7', 'Lane8', '4444444444', '4@dotnettutorials.net');
GO

-- StudentCourse table data
INSERT INTO CourseStudent VALUES(1,1);
INSERT INTO CourseStudent VALUES(2,1);
INSERT INTO CourseStudent VALUES(3,2);
INSERT INTO CourseStudent VALUES(4,2);
INSERT INTO CourseStudent VALUES(1,3);
INSERT INTO CourseStudent VALUES(6,3);
INSERT INTO CourseStudent VALUES(5,4);
INSERT INTO CourseStudent VALUES(6,4);
GO

```

##### **How many ways can we load the Related Entities in Entity Framework Core?**

In Entity Framework Core, we can load the related entities in three ways. They are **Eager Loading**, **Lazy Loading**, and **Explicit Loading**. All these three techniques, i.e., Eager Loading, Lazy Loading, and Explicit Loading, refer to loading the related entities of the main entity. The only difference is they define when to load the related or child entities of the main entity.



![[word-image-41710-7-768x380.webp]]

#####  **Understand Eager Loading in EF Core:**

```C# using EFCoreCodeFirstDemo.Entities;
using Microsoft.EntityFrameworkCore;
namespace EFCoreCodeFirstDemo
{
    internal class Program
    {
        static void Main(string[] args)
        {
            try
            {
                var context = new EFCoreDbContext();

                //Loading Related Entities using Eager Loading
                //While Loading the Student table data, it also load the Standard table data
                
                //Eager Loading using Method Syntax
                //Specifying the Related Entity Name using Lambda Expression
                var students = context.Students
                             .Include(std => std.Standard)
                             .ToList();

                //Specifying the Related Entity Name using String Name
                //var students = context.Students
                //             .Include("Standard")
                //             .ToList();

                //Eager Loading using Query Syntax
                //Specifying the Related Entity Name using Lambda Expression
                //var students = (from s in context.Students.Include(std => std.Standard)
                //                 select s).ToList();

                //Specifying the Related Entity Name using String Name
                //var students = (from s in context.Students.Include("Standard")
                //                 select s).ToList();

                //Printing all the Student and Standard details
                foreach (var student in students)
                {
                    Console.WriteLine($"Firstname: {student.FirstName}, Lastname: {student.LastName}, StandardName: {student.Standard?.StandardName}, Description: {student.Standard?.Description}");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}"); ;
            }
        }
    }
}

```

##### **FromSql() Method in EF Core:**

Using the FromSql() Method in EF Core, we can specify the RAW T-SQL Statements executed in the database. The Include() extension method in EF Core can also be used after the FromSql() method.


```C#
using EFCoreCodeFirstDemo.Entities;
using Microsoft.EntityFrameworkCore;
namespace EFCoreCodeFirstDemo
{
    internal class Program
    {
        static void Main(string[] args)
        {
            try
            {
                var context = new EFCoreDbContext();

                //Loading Related Entities using Eager Loading
                //While Loading the Student Information, also load the related Standard data

                //Create the SQL Statement using FormattableString object
                FormattableString sql = $"Select * from Students WHERE FirstName = 'Pranaya'";

                //Pass the FormattableString Object to the FromSql Method
                var StudentWithStandard = context.Students
                        .FromSql(sql)
                        .Include(s => s.Standard) //Eager Load the Related Standard data
                        .FirstOrDefault();

                //Printing the Student and Standard details
                Console.WriteLine($"Firstname: {StudentWithStandard?.FirstName}, Lastname: {StudentWithStandard?.LastName}, " +
                    $"StandardName: {StudentWithStandard?.Standard?.StandardName}, Description: {StudentWithStandard?.Standard?.Description}");

            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}"); ;
            }
        }
    }
}

```

##### **How to Load Multiple Related Entities Using Include Method in EF Core?**

![[word-image-41710-10-768x380.webp]]

```C#
	using EFCoreCodeFirstDemo.Entities;
using Microsoft.EntityFrameworkCore;
namespace EFCoreCodeFirstDemo
{
    internal class Program
    {
        static void Main(string[] args)
        {
            try
            {
                var context = new EFCoreDbContext();

                //Loading Related Entities using Eager Loading
                //While Loading the Student table data, it is also going to load the Standard, StudentAddress and Courses tables data
                
                //Eager Loading Multiple Entities using Method Synatx
                var students = context.Students
                    .Include(x => x.Standard)
                    .Include(x => x.StudentAddress)
                    .Include(x => x.Courses)
                    .ToList();

                //Eager Loading Multiple Entities using Query Synatx
                //var students = (from s in context.Students
                //                 .Include(x => x.Standard)
                //                 .Include(x => x.StudentAddress)
                //                 .Include(x => x.Courses)
                //                 select s).ToList();

                //Printing all the Student and Standard details
                foreach (var student in students)
                {
                    Console.WriteLine($"Student Name: {student.FirstName} {student.LastName}, StandardName: {student.Standard?.StandardName}, Address: {student.StudentAddress?.Address1}");
                    foreach (var course in student.Courses)
                    {
                        Console.WriteLine($"\tCourse ID: {course.CourseId} Course Name: {course.CourseName}");
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}"); ;
            }
        }
    }
}

```

##### **ThenInclude Method in EF Core:**

It is also possible to eagerly load multiple levels of related entities in Entity Framework Core. Entity Framework Core introduced the new **ThenInclude()** extension method to load multiple levels of related entities.

```C#
	using EFCoreCodeFirstDemo.Entities;
using Microsoft.EntityFrameworkCore;
namespace EFCoreCodeFirstDemo
{
    internal class Program
    {
        static void Main(string[] args)
        {
            try
            {
                var context = new EFCoreDbContext();

                //Loading Related Entities using Eager Loading
                //While Loading the Student table data, it is also going to load the Standard, StudentAddress and Courses tables data

                //Method Synatx

                var student = context.Students.Where(s => s.FirstName == "Pranaya")
                        .Include(s => s.Standard)
                        .ThenInclude(std => std.Teachers)
                        .FirstOrDefault();

                Console.WriteLine($"Firstname: {student?.FirstName}, Lastname: {student?.LastName}, StandardName: {student?.Standard?.StandardName}, Description: {student?.Standard?.Description}");

                if(student?.Standard != null)
                {
                    //You can also access the Teacher collection here
                    foreach (var teacher in student.Standard.Teachers)
                    {
                        Console.WriteLine($"\tTeacher ID: {teacher.TeacherId}, Name: {teacher.FirstName} {teacher.LastName}");
                    }
                }
               
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}"); ;
            }
        }
    }
}

```

##### **Projection Query in EF Core:**

We can also load multiple related entities using the projection query instead of the Include() or ThenInclude() methods. The following example demonstrates the projection query to load the Student, Standard, and Teacher entities. In the below example, the Select extension method is used to include the Student, Standard, and Teacher entities in the result. This will execute the same SQL query as ThenInclude() method.

```C#
	using EFCoreCodeFirstDemo.Entities;
using Microsoft.EntityFrameworkCore;
namespace EFCoreCodeFirstDemo
{
    internal class Program
    {
        static void Main(string[] args)
        {
            try
            {
                var context = new EFCoreDbContext();

                //Loading Related Entities using Eager Loading
                //While Loading the Student table data, it is also going to load the Standard, StudentAddress and Courses tables data

                var teachers = new List<Teacher>();
                var std = context.Students.Where(s => s.FirstName == "Pranaya")
                         .Select(s => new
                         {
                             Student = s,
                             Standard = s.Standard,
                             Teachers = (s.Standard != null)? s.Standard.Teachers : teachers
                         })
                         .FirstOrDefault();

                Console.WriteLine($"Firstname: {std?.Student?.FirstName}, Lastname: {std?.Student?.LastName}, StandardName: {std?.Student?.Standard?.StandardName}, Description: {std?.Student?.Standard?.Description}");

                if(std?.Student?.Standard != null)
                {
                    //You can also access the Teacher collection here
                    foreach (var teacher in std.Student.Standard.Teachers)
                    {
                        Console.WriteLine($"\tTeacher ID: {teacher.TeacherId}, Name: {teacher.FirstName} {teacher.LastName}");
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}"); ;
            }
        }
    }
}

```

## **Lazy Loading in Entity Framework (EF) Core**

##### **What is Lazy Loading in Entity Framework Core?**

Lazy Loading is a Process where Entity Framework Core loads the related entities on demand. That means the related entities or child entities are loaded only when it is being accessed for the first time. So, in simple words, we can say that Lazy loading delays the loading of related entities until you specifically request it. 

Lazy loading in Entity Framework Core is a pattern where related data is automatically loaded from the database as soon as the navigation property on an entity is accessed for the first time. This approach can simplify the code and avoid loading unnecessary data.


##### **Understand Lazy Loading in Entity Framework Core:**

Let us understand Lazy Loading in EF Core with an example. Please have a look at the following Student entity. Looking at the Student class, you will find a navigation property for the StudentAddress entity. At the same time, you will also find a navigation property for Standard and a collection navigation property for Courses Entities.

![[word-image-41728-1.webp]]

In Lazy Loading, the context object first loads the Student entity data from the database. Then, it will load the related entities when you access those navigation properties for the first time. If you are not accessing the Navigation Properties, it will not load those related data from the database.

##### **How to Implement Lazy Loading in EF Core?**

We can implement Lazy loading in Entity Framework Core in two ways. They are as follows:

1. **Lazy Loading With Proxies**
2. **Lazy loading Without Proxies**

#### **Lazy Loading With Proxies in EF Core:**

To enable Lazy Loading using Proxies in Entity Framework Core, the first step is to install the Proxy Package provided by Microsoft. This can be done by installing **Microsoft.EntityFrameworkCore.Proxies** package, which will add all the necessary proxies. There are three steps involved in enabling Lazy Loading using Proxies.

1. **Install Proxies Package**
2. **Enable Lazy Loading using UseLazyLoadingProxies**
3. **Mark the Navigation Property as a Virtual**

##### **Step 1:** **Install Microsoft.EntityFrameworkCore.Proxies Package**

So, open NuGet Package Manager UI by selecting **Tools => NuGet Package Manager => Manage NuGet Packages for Solution** from the Visual Studio Menu, which will open the following window. From this window, select the Search tab, then search for **Microsoft.EntityFrameworkCore.Proxies** package and select **Microsoft.EntityFrameworkCore.Proxies** package and click the Install button, as shown in the image below.

![[word-image-41728-2.webp]]

```C#
	using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
namespace EFCoreCodeFirstDemo.Entities
{
    public class EFCoreDbContext : DbContext
    {
        //Constructor calling the Base DbContext Class Constructor
        public EFCoreDbContext() : base()
        {
        }

        //OnConfiguring() method is used to select and configure the data source
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            //To Display the Generated the Database Script
            optionsBuilder.LogTo(Console.WriteLine, LogLevel.Information);

            //Enabling Lazy Loading
            optionsBuilder.UseLazyLoadingProxies();

            //Configuring the Connection String
            optionsBuilder.UseSqlServer(@"Server=LAPTOP-6P5NK25R\SQLSERVER2022DEV;Database=EFCoreDB1;Trusted_Connection=True;TrustServerCertificate=True;");
        }

        //OnModelCreating() method is used to configure the model using ModelBuilder Fluent API
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            //Use this to configure the model using Fluent API
        }

        //Adding Domain Classes as DbSet Properties
        public virtual DbSet<Course> Courses { get; set; }

        public virtual DbSet<Standard> Standards { get; set; }

        public virtual DbSet<Student> Students { get; set; }

        public virtual DbSet<StudentAddress> StudentAddresses { get; set; }

        public virtual DbSet<Teacher> Teachers { get; set; }
    }
}

```





## **Default Conventions in Entity Framework Core (EF Core)**


Entity Framework Core (EF Core) uses a set of default conventions that determines how to map between our database and entity classes. These conventions help us reduce the configuration code to achieve this mapping.

In previous articles, we demonstrated examples of using Entity Framework Core. We observed that the EF Core automatically configured primary keys, foreign keys, indexers, relationships between tables, and appropriate data types for columns from the domain classes without requiring extra configurations.

###### **Students.cs**

```C#
	namespace EFCoreCodeFirstDemo.Entities
{
    public class Student
    {
        public int StudentId { get; set; }
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
        public DateTime? DOB { get; set; }
        public byte[]? Photo { get; set; }
        public decimal? Height { get; set; }
        public float? Weight { get; set; }
        public bool IsPassout { get; set; }
        public virtual Standard? Standard { get; set; }
        public int GradeId { get; set; }
        public Grade? Grade { get; set; }
    }
}


```

**Standard.cs**

```C#
namespace EFCoreCodeFirstDemo.Entities
{
    public class Standard
    {
        public int Id { get; set; }
        public string? StandardName { get; set; }
        public string? Description { get; set; }
        public virtual IList<Student>? Students { get; set; }
    }
}

```

**Grade.cs**

```C#
using System.ComponentModel.DataAnnotations;
namespace EFCoreCodeFirstDemo.Entities
{
    public class Grade
    {
        public int GradeId { get; set; }
        public string? GradeName { get; set; }
        public string? Section { get; set; }
        public virtual IList<Student>? Students { get; set; }
    }
}

```

##### **Creating the Context Class:**

```C#
using Microsoft.EntityFrameworkCore;
namespace EFCoreCodeFirstDemo.Entities
{
    public class EFCoreDbContext : DbContext
    {
        //Constructor calling the Base DbContext Class Constructor
        public EFCoreDbContext() : base()
        {
        }

        //OnConfiguring() method is used to select and configure the data source
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            //Configuring the Connection String
            optionsBuilder.UseSqlServer(@"Server=LAPTOP-6P5NK25R\SQLSERVER2022DEV;Database=EFCoreDB;Trusted_Connection=True;TrustServerCertificate=True;");
        }

        //OnModelCreating() method is used to configure the model using ModelBuilder Fluent API
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            //Use this to configure the model using Fluent API
        }

        //Adding Domain Classes as DbSet Properties
        //In The database it will create the table with the name Students
        public DbSet<Student> Students { get; set; }

        //In The database it will create the table with the name Standard
        public DbSet<Standard> Standard { get; set; }
    }
}

```

 **add-migration**   modelName
 **update-database**  ![[word-image-41779-4.webp]]
![[word-image-41779-5.webp]]

![[word-image-41779-6.webp]]

##### **Null and Not Null Columns:**

![[word-image-41779-8.webp]]

##### **Column Data Type**

![[word-image-41779-9.webp]]

##### **Data Modelling Attributes in EF Core**

1.  **Table**
2. **Column**
3. **Index**
4. **ForeignKey**
5. **NotMapped**
6. **InverseProperty**
7. **ComplexType**
8. **DatabaseGenerated**

##### **Validation Related Attributes**

1. **Key**
2. **Timestamp**
3. **ConcurrencyCheck**
4. **Required**
5. **MinLength**
6. **MaxLength**
7. **StringLength**

## **Table Attribute in Entity Framework Core**

![[Pasted image 20240328125314.png]]

```C#
	using System.ComponentModel.DataAnnotations.Schema;
namespace EFCoreCodeFirstDemo.Entities
{
    [Table("StudentInfo")]
    public class Student
    {
        public int StudentId { get; set; }
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
    }
}

```

```C#
	using System.ComponentModel.DataAnnotations.Schema;
namespace EFCoreCodeFirstDemo.Entities
{
    [Table("StudentInfo", Schema = "Admin")]
    public class Student
    {
        public int StudentId { get; set; }
        public string? FirstName { get; set; }
        public string? LastName { get; set; }
    }
}
```

## **Column Data Annotation Attribute in Entity Framework Core**

![[word-image-41827-1.webp]]

```C#
	using System.ComponentModel.DataAnnotations.Schema;
namespace EFCoreCodeFirstDemo.Entities
{
    [Table("StudentInfo", Schema = "Admin")]
    public class Student
    {
        public int StudentId { get; set; }
        [Column]
        public string? FirstName { get; set; }
        [Column("LName")]
        public string? LastName { get; set; }
    }
}
```



``` c#
	using System.ComponentModel.DataAnnotations.Schema;
namespace EFCoreCodeFirstDemo.Entities
{
    [Table("StudentInfo", Schema = "Admin")]
    public class Student
    {
        public int StudentId { get; set; }
        [Column]
        public string? FirstName { get; set; }
        [Column("LName")]
        public string? LastName { get; set; }
        [Column("DOB", TypeName = "DateTime2")]
        public DateTime DateOfBirth { get; set; }
    }
}

```

```C#
	using System.ComponentModel.DataAnnotations.Schema;
namespace EFCoreCodeFirstDemo.Entities
{
    [Table("CollegeStudentInfo", Schema = "Admin")]
    public class CollegeStudent
    {
        //Primary Key: Order Must be 0
        [Column(Order = 0)]
        public int CollegeStudentId { get; set; }
        [Column(Order = 2)]
        public string? FirstName { get; set; }
        [Column("LName", Order = 4)]
        public string? LastName { get; set; }
        [Column("DOB", Order = 3, TypeName = "DateTime2")]
        public DateTime DateOfBirth { get; set; }
        [Column(Order = 1)]
        public string? Mobile { get; set; }
    }
}

```

