
 common requirement in relational databases is establishing relationships between database tables or entities. Whenever we try to establish a relationship between two entities, then one of the entities will act as a Principal Entity, and the other Entity will act as the Dependent Entity.

Let us first understand what is **Principal Entity** and **Dependent Entity** from the relational database point of view.

1. **Principal Entity:** The Entity containing the Primary or Unique Key properties is called Principal Entity.
2. **Dependent Entity:** The Entity which contains the Foreign key properties is called Dependent Entity.




### Before understanding the different types of relationships, let us first understand a few important terms used in database and model classes.

1. **Primary Key:** The Primary key is a column (columns in the case of composite primary key) in the database Table that Uniquely identifies each row.
2. **Foreign Key:** The Foreign key is a column in a table that makes a relationship with another table. The Foreign key Column should point to the Principal Entity’s Primary Key or Unique Key column.
3. **Navigation Properties:** In .NET, the Navigation properties define the type of relationships between the Entities. Based on the requirements, these properties are defined either in the Principal Entity or in the Dependent Entity.

The Navigation Properties are again classified into two types. They are as follows:

1. **Reference Navigation Property:** This property refers to a Single Related Entity, i.e., it is used to implement a One-to-One relationship between two entities.
2. **Collection Navigation Property:** This property refers to a Collection of Entities, i.e., it is used to implement One-to-Many or Many-to-Many relationships between two entities.

##### **Types of Relationships in Database:**

In a relational database, a relationship refers to the association or connection between two tables based on common data elements. Relationships are fundamental to organizing and structuring data to enable efficient querying and retrieval of information. They define how data in different tables are related to each other, allowing us to perform complex queries and analyze the data effectively. There are several types of relationships in a relational database. They are as follows:

1. **One-to-One (1:1)** **Relationship:** In this type of relationship, each record in one table is associated with exactly one record in another table, and vice versa. This is often used when two entities have a unique relationship.
2. **One-to-Many (1:N) Relationship:** In a one-to-many relationship, a single record in one table is related to multiple records in another table. However, each record in the second table is related to only one record in the first table. This is the most common type of relationship used in real-time applications.
3. **Many-to-Many (M:N) Relationship:** A many-to-many relationship exists when multiple records in one table are related to multiple records in another table. This type of relationship is typically implemented using a junction table or associative entity, which breaks down the relationship into two one-to-many relationships.
4. **Self-Referencing Relationship:** This type of relationship occurs when records in a single table are related to other records in the same table. For example, in an organizational structure, an employee might have a manager who is also an employee.

Properly defining and maintaining relationships in a database is crucial for data integrity, consistency, and accuracy. It allows us to avoid data duplication, reduce redundancy, and create a well-structured and normalized database schema. Relational databases, such as MySQL, Oracle, PostgreSQL, and Microsoft SQL Server, provide mechanisms for defining and enforcing these relationships through their table creation and modification features.

##### **Types of Relationships in Entity Framework Core:**

In relational databases, there are four types of relationships between the database tables (One-to-One, One-to-Many, Many-to-Many, and Self-Referencing Relationship).

Entity Framework Core (EF Core) is an Object-Relational Mapping (ORM) framework for .NET that enables developers to work with databases using object-oriented concepts. EF Core uses navigation properties and annotations to define relationships between entities (classes that represent database tables). The Entity Framework supports four types of relationships similar to the database. They are as follows:

1. **One-to-One Relationship**
2. **One-to-Many Relationship**
3. **Many-to-Many Relationship**
4. **Self-Referencing Relationship**



##### **One-to-One Relationships** (1:1)

**Person.cs**

```C#
	namespace EFCoreCodeFirstDemo.Entities
{
    public class Person
    {
        public int PersonId { get; set; }
        public string Name { get; set; }
        public Passport Passport { get; set; }
    }
}

```
**Passport.cs**
```C#
	namespace EFCoreCodeFirstDemo.Entities
{
    public class Passport
    {
        public int PassportId { get; set; }
        public string PassportNumber { get; set; }
        public int PersonId { get; set; }  // Foreign Key
        public Person Person { get; set; }
    }
}

```

##### **How to Configure One-to-One Relationship using Fluent API?**

We can configure the One-to-One required relationship between two entities using both the Data Annotation Attribute and Fluent API. We have already discussed configuring the One-to-One relationship between the two entities using the ForeignKey Data Annotation Attribute.

Now, let us proceed and try to understand how to Configure the One-to-One relationships between two entities using Entity Framework Core Fluent API. To implement this, we must use the following **HasOne(), WithOne(), and HasForeignKey()** Fluent API methods.

- **HasOne():** The **HasOne()** method specifies the navigation property that represents the principal end of the relationship.  Or Primary Key
- **WithOne():** The **WithOne()** method specifies the navigation property on the dependent side Or Froing Key.
- <span style="color:Green">HasForeignKey  TDependent>())</span>   The **HasForeignKey TDependent ()** method is used to specify which property in the dependent entity represents the foreign key.

Next, modify the context class as follows. The following code sets a one-to-one required relationship between the Person and Passport entities using Entity Framework Core Fluent API

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
            // Fluent API Configuration
            // Configure One to One Relationships Between Person and Passport
            modelBuilder.Entity<Person>()
            .HasOne(p => p.Passport) //Person has one Passport
            .WithOne(p => p.Person) //Passport is associated with one Person
            .HasForeignKey<Passport>(p => p.PersonId); //Foreign key in Passport table
        }

        public DbSet<Person> Persons { get; set; }
        public DbSet<Passport> Passports { get; set; }
    }
}

```


![[word-image-43851-1-768x214.webp]]


![[Screenshot_56 1.png]]

![[word-image-43851-3.webp]]
![[DotNet/WebAPI/apiImages/word-image-43851-4.webp]]

```C#
	using EFCoreCodeFirstDemo.Entities;
using System.Net;

namespace EFCoreCodeFirstDemo
{
    internal class Program
    {
        static void Main(string[] args)
        {
            try
            {
                //Creating an Instance of the Context Class
                using EFCoreDbContext context = new EFCoreDbContext();

                //Creating an Instance of Passport Entity
                var passport = new Passport() { PassportNumber = "Pass-1224-xyz"};

                //Creating Person Entity, configuring the Related Passport Entity
                var Person = new Person() { Name = "Pranaya", Passport = passport };

                context.Persons.Add(Person);
                context.SaveChanges();
                Console.WriteLine("Person and Passport Added");
                Console.ReadKey();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}"); ;
            }
        }
    }
}

```

![[DotNet/WebAPI/apiImages/word-image-43851-5.webp]]

**User.cs**

```C#
	namespace EFCoreCodeFirstDemo.Entities
{
    public class User
    {
        public int UserId { get; set; }
        public string Username { get; set; }
        public UserProfile UserProfile { get; set; }
    }
}

```

**UserProfile.cs**

```C# using System.ComponentModel.DataAnnotations;
namespace EFCoreCodeFirstDemo.Entities
{
    public class UserProfile
    {
        [Key]
        public int UserId { get; set; }  // PK and FK
        public string Bio { get; set; }
        public User User { get; set; }
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
            // Fluent API Configuration
            // Configure One to One Relationships User Person and UserProfile
            modelBuilder.Entity<User>()
                .HasOne(u => u.UserProfile) //Person has one UserProfile
                .WithOne(up => up.User) //One UserProfile is associated with one User
                .HasForeignKey<UserProfile>(up => up.UserId); //Foreign key in UserProfile table
        }

        public DbSet<User> Users { get; set; }
        public DbSet<UserProfile> UserProfiles { get; set; }
    }
}

```
![[DotNet/WebAPI/apiImages/word-image-43851-7.webp]]


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
                //Creating an Instance of the Context Class
                using EFCoreDbContext context = new EFCoreDbContext();

                //Creating an Instance of UserProfile Entity
                var userProfile = new UserProfile() { Bio = "Software Developer...."};

                //Creating User Entity, configuring the Related UserProfile Entity
                var user = new User() { Username = "Pranaya", UserProfile = userProfile };

                context.Users.Add(user);
                context.SaveChanges();
                Console.WriteLine("User and UserProfile Added");
                Console.ReadKey();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}"); ;
            }
        }
    }
}

```


![[DotNet/WebAPI/apiImages/word-image-43851-8.webp]]

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
            // Fluent API Configuration
            // Configure One to One Relationships User Person and UserProfile

            modelBuilder.Entity<UserProfile>()
                .HasOne(u => u.User) //UserProfile has one User
                .WithOne(up => up.UserProfile) //One User is associated with one UserProfile
                .HasForeignKey<User>(up => up.UserId); //Foreign key in User table

            //modelBuilder.Entity<User>()
            //    .HasOne(u => u.UserProfile) //Person has one UserProfile
            //    .WithOne(up => up.User) //One UserProfile is associated with one User
            //    .HasForeignKey<UserProfile>(up => up.UserId); //Foreign key in UserProfile table
        }

        public DbSet<User> Users { get; set; }
        public DbSet<UserProfile> UserProfiles { get; set; }
    }
}

```

![[DotNet/WebAPI/apiImages/word-image-43851-10.webp]]

## **One-to-Many Relationships in Entity Framework Core using Fluent API**

The One-To-Many relationship is the most common type of relationship between database tables or entities. In this type of relationship, a row in one table, let’s say Table A, can have many matching rows in another table, let’s say Table B, but a row in Table B can have only one matching row in Table A.

- A collection navigation property in the principal entity points to a collection of dependent entities.
- A foreign key property in the dependent entity pointing back to the principal entity.
- A reference navigation property in the dependent entity pointing back to the principal entity.

##### **Understanding One-to-Many Relationships in EF Core**

In Entity Framework Core (EF Core), you can define a one-to-many relationship between entities using the Fluent API. The Fluent API provides a way to configure the relationships and mappings between entities in a more flexible and detailed manner than using only data annotations.

Let us understand this with an example. We will implement a One-to-Many relationship between the following Author and Book Entities. Consider the following Author and Book classes where the Author entity includes many Book entities, but each book entity is associated with only one Author entity. So, an Author can write multiple Books, but each Book has only one Author.

**Author.cs**

```C#
namespace EFCoreCodeFirstDemo.Entities
{
    public class Author
    {
        public int AuthorId { get; set; }
        public string? Name { get; set; }
        // Navigation property: Collection pointing to dependent entities
        public List<Book>? Books { get; set; }
    }
}

```
**Book.cs**

```C#
	namespace EFCoreCodeFirstDemo.Entities
{
    public class Book
    {
        public int BookId { get; set; }
        public string? Title { get; set; }
        // Foreign key property
        public int AuthorId { get; set; }
        // Navigation property: Points back to the principal entity
        public Author? Author { get; set; }
    }
}

```

##### **How to Configure One-to-Many Relationships Using Fluent API in EF Core?**

1. **HasMany():** Configures a relationship where this entity type has a collection that contains instances of the other type in the relationship. That means it specifies the ‘many’ side of the relationship. 
2. **WithOne():** Configures a relationship where this entity type has a reference that contains an instance of the other type in the relationship. That means it specifies the ‘one’ side of the relationship. 
3. **HasForeignKey():** Configures the property(s) to use as the foreign key for this relationship. That means it specifies which property is the foreign key.
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
            // Fluent API Configuration
            // Configure One to Many Relationships Between Author and Book
            modelBuilder.Entity<Author>()
            .HasMany(a => a.Books) // Author has many Books, specifies the 'many' side of the relationship
            .WithOne(b => b.Author) // Book is associated with one Author, specifies the 'one' side of the relationship
            .HasForeignKey(b => b.AuthorId); // AuthorId is the Foreign key in Book table, specifies which property is the foreign key
        }

        public DbSet<Author> Authors { get; set; }
        public DbSet<Book> Books { get; set; }
    }
}

```

![[One-to-Many-Relationships-in-Entity-Framework-Core.webp]]

![[DotNet/EntityFramework/Images/Screenshot_59.png]]

![[word-image-42205-3.webp]]

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

                //First Create Book Collection
                var books = new List<Book>
                {
                    new Book() { Title = "C#" },
                    new Book() { Title = "LINQ" },
                    new Book() { Title = "ASP.NET Core" }
                };

                //Create an Instance of Author and Assign the books collection
                var author = new Author() { Name="Pranaya", Books = books };
                context.Authors.Add(author);
                context.SaveChanges();
                
                Console.WriteLine("Author and Books Added");

                Console.ReadKey();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}"); ;
            }
        }
    }
}

```
##### **How to Configure Cascade Delete using EF Core Fluent API?**

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
            // Fluent API Configuration
            // Configure One to Many Relationships Between Author and Book
            modelBuilder.Entity<Author>()
            .HasMany(a => a.Books) // Author has many Books, specifies the 'many' side of the relationship
            .WithOne(b => b.Author) // Book is associated with one Author, specifies the 'one' side of the relationship
            .HasForeignKey(b => b.AuthorId) // AuthorId is the Foreign key in Book table, specifies which property is the foreign key
            .OnDelete(DeleteBehavior.Cascade); //This will delete the child record(S) when parent record is deleted
        }

        public DbSet<Author> Authors { get; set; }
        public DbSet<Book> Books { get; set; }
    }
}

```

![[word-image-42205-9.webp]]

![[Screenshot_56 1.png]]
![[word-image-42205-11.webp]]



##### **Modifying the Main Method:**

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

                Author? Id1 = context.Authors.Find(1);
                if (Id1 != null)
                {
                    context.Remove(Id1);
                    context.SaveChanges();
                    Console.WriteLine("Author Deleted");
                }
                else
                {
                    Console.WriteLine("Author Not Exists");
                }
                Console.ReadKey();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}"); ;
            }
        }
    }
}

```

## **Many-to-Many Relationships in Entity Framework Core using Fluent API**

**Student.cs**
```C#
namespace EFCoreCodeFirstDemo.Entities
{
    public class Student
    {
        public int StudentId { get; set; }
        public string? Name { get; set; }

        // Navigation property for the many-to-many relationship
        //One Student Can have Many Courses
        public List<Course> Courses { get; set; }
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
        public string? Description { get; set; }
        //Navigation property for the many-to-many relationship
        //One Course Can be Taken by Many Students
        public List<Student> Students { get; set; }
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
            modelBuilder.Entity<Student>()
                .HasMany(s => s.Courses) // Student can enroll in many Courses
                .WithMany(c => c.Students) // Course can have many Students
                .UsingEntity(j => j.ToTable("StudentCourses"));  //Explicitly set the join table name
        }

        public DbSet<Student> Students { get; set; }
        public DbSet<Course> Courses { get; set; }
    }
}
```

In this Fluent API configuration:

- **HasMany(s => s.Courses):** Specifies that a Student can have many Courses.
- **WithMany(c => c.Students):** Specifies that a Course can have many Students.
- **UsingEntity(j => j.ToTable(“StudentCourses”)):** Explicitly names the join table. If you don’t specify this, EF Core will use a default name based on the two entity names.
![[Many-to-Many-Relationships-in-Entity-Framework-Core.webp]]

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
                //Creating an Instance of Context Class
                using var context = new EFCoreDbContext();

                //Creating List of Courses
                var courses = new List<Course>
                {
                    new Course() { CourseName = "EF Core", Description="It is an ORM Tool"},
                    new Course() { CourseName = "ASP.NET Core", Description ="Open-Source & Cross-Platform" }
                };
                context.Courses.AddRange(courses);
                context.SaveChanges();
                Console.WriteLine("Courses Added");

                //Creating an Instance of Student Class
                var Pranaya = new Student() { Name = "Pranaya", Courses = courses };
                context.Students.Add(Pranaya);

                var Hina = new Student() { Name = "Hina", Courses = courses };
                context.Students.Add(Hina);

                context.SaveChanges();
                Console.WriteLine("Students Added");

                Console.ReadKey();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}"); ;
            }
        }
    }
}
```

### ## **Self-Referencing Relationship in Entity Framework Core**

```C#
namespace EFCoreCodeFirstDemo.Entities
{
    public class Employee
    {
        public int EmployeeId { get; set; }
        public string? Name { get; set; }
        // ForeignKey for Manager
        public int? ManagerId { get; set; }
        // Navigation property for Manager
        public Employee? Manager { get; set; }
        // Navigation property for Subordinates 
        public List<Employee>? Subordinates { get; set; }
    }
}

```

- ManagerId is a foreign key pointing to another Employee (the manager).
- Manager is a reference navigation property pointing to the manager.
- Subordinates is a collection navigation property containing all Subordinates (employees) under the current Employee.
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
            //Configuring the Employee Entity to Represent Self-Referential Relationships
            modelBuilder.Entity<Employee>()
            .HasOne(e => e.Manager)              // Specifies that each employee has one manager.
            .WithMany(e => e.Subordinates)       // Specifies that each manager can have many Subordinates
            .HasForeignKey(e => e.ManagerId)     // Specifies the foreign key property for this relationship.
            .OnDelete(DeleteBehavior.Restrict);  // Optional: Configure delete behavior
        }

        public DbSet<Employee> Employees { get; set; }
    }
}
<div class="open_grepper_editor" title="Edit & Save To Grepper"></div>
```

- **HasOne(e => e.Manager):** Specifies that each Employee has one Manager (who is also an Employee).
- **WithMany(m => m.Subordinates):** Specifies that an Employee (as a manager) can have many Subordinates.
- **HasForeignKey(e => e.ManagerId):** Specifies the foreign key property for the relationship.
![[word-image-42207-2.webp]]

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

                //Create a Manager
                Employee mgr = new Employee() { Name = "Pranaya"};
                context.Add(mgr);
                context.SaveChanges();
                Console.WriteLine("Manager Added");

                Employee emp1 = new Employee() { Name ="Hina", ManagerId = 1};
                context.Add(emp1);
                Employee emp2 = new Employee() { Name ="Ramesh", ManagerId = 1 };
                context.Add(emp2);
                context.SaveChanges();
                Console.WriteLine("Employees Added");

                //List of Employee including Manager
                var listOfEmployees = context.Employees.ToList();
                Console.WriteLine("List of Employees");
                foreach (var emp in listOfEmployees)
                {
                    Console.WriteLine($"\tEmployee ID:{emp.Name}, Name:{emp.Name}");
                }

                //List of Subordinates working under Manager whose Id = 1
                var Manager = context.Employees.Find(1);
                if( Manager != null )
                {
                    Console.WriteLine($"\nList of Employees working under Manager : {Manager.Name}");
                    if (Manager.Subordinates != null)
                    {
                        foreach (var emp in Manager.Subordinates)
                        {
                            Console.WriteLine($"Employee ID:{emp.Name}, Name:{emp.Name}");
                        }
                    }
                }
                
                Console.ReadKey();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error: {ex.Message}"); ;
            }
        }
    }
}

```

##### **Configure Default Schema using Entity Framework Core Fluent API Configuration:**

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
           
        }

        public DbSet<Student> Students { get; set; }
        public DbSet<Standard> Standards { get; set; }
    }
}

```

##### **Map Entity to Table using Fluent API in Entity Framework Core.**

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
        }

        public DbSet<Student> Students { get; set; }
        public DbSet<Standard> Standards { get; set; }
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
            //Map Entity to Table
            modelBuilder.Entity<Student>().ToTable("StudentInfo"); //Default Schema will be dbo
            modelBuilder.Entity<Standard>().ToTable("StandardInfo", "Admin"); // Schema will be Admin
        }

        public DbSet<Student> Students { get; set; }
        public DbSet<Standard> Standards { get; set; }
    }
}

```

##### **HasAlternateKey(), HasIndex(), HasKey() and Ignore() Fluent API methods examples using EF Core**


```C#
modelBuilder.Entity<Employee>()
    .HasAlternateKey(p => p.Email); // Email is an alternate key
modelBuilder.Entity<Employee>()
    .HasIndex(p => p.RegdNumber) // Create an index on the RegdNumber column
    .IsUnique(); // Make the index unique

Single-column primary key
modelBuilder.Entity<Employee>()
    .HasKey(p => p.EmpId); 

Composite key example
modelBuilder.Entity<Order>()
    .HasKey(o => new { o.EmpId, o.RegdNumber });
Single-column primary key
modelBuilder.Entity<Employee>()
    .HasKey(p => p.EmpId); 

Composite key example
modelBuilder.Entity<Order>()
    .HasKey(o => new { o.EmpId, o.RegdNumber });

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
            //Email is an Alternate Key, Applying Unique Constraints
            modelBuilder.Entity<Employee>()
            .HasAlternateKey(p => p.Email);

            //Create an index on the RegdNumber column
            modelBuilder.Entity<Employee>()
                .HasIndex(p => p.RegdNumber)
                .IsUnique(); //Make the index unique and by default non-clustered

            //Single-Column Primary Key
            modelBuilder.Entity<Employee>()
                .HasKey(p => p.EmpId);

            //Exclude TemporaryAddress property from mapping
            modelBuilder.Entity<Employee>()
                .Ignore(p => p.TemporaryAddress);
        }

        public DbSet<Employee> Employees { get; set; }
    }
}

```

