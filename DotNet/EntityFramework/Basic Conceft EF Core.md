[Overview of Entity Framework Core - EF Core | Microsoft Learn](https://learn.microsoft.com/en-gb/ef/core/)


![[Pasted image 20240328103904.png]]


![[Pasted image 20240328103938.png]]



![[Pasted image 20240328103949.png]]



![[Pasted image 20240328104016.png]]


## Install Entity Framework Core DB provider
**Select on the Menu: Tools-> NuGet Package Manager->Manage NuGet Packages For Solution)**.
**Microsoft.EntityFrameworkCore.SqlServer**
![[Screenshot_55.png]]


## Entity Framework Features



<span style="color:green"> Cross-Platform:  </span> Entity Framework Core is a cross-platform framework that can run on Windows, Linux, and Mac.

<span style="color:green">Modeling: </span> Entity Framework (EF) creates an EDM (Entity Data Model), which is based on POCO (Plain Old CLR Object) entities with get/set properties of different data types. It uses this model when we have to query and to save the entity data to the underlying database.

<span style="color:green">Querying: </span>  Entity Framework allows us to use the LINQ Queries to retrieve the data from the database. The database provider will translate these LINQ queries to the database-specific query language (e.g., SQL for a relational database). Entity Framework also allows us to execute raw SQL queries directly to the database.

**Change Tracking:** Entity Framework keeps track of the changes that occurred to instances of the entities (Property Values) which needs to be submitted to the database.

**Saving:** Entity Framework executes the INSERT, UPDATE, and DELETE commands to the database based on the changes that occurred to the entities when we call the "**SaveChanges()**" method. Entity Framework also provides the asynchronous "**SaveChangesAsync()**" method.

**Concurrency:** Entity Framework uses Optimistic Concurrency by default to protect overwriting changes made by another user when data was fetched from the database.

**Transactions:** Entity Framework automates the management of the transaction while querying or saving the data. It also provides the options to customize the transaction management.

**Caching:** Entity Framework includes the first level of caching out of the box. So, repeated querying will return the data from the cache instead of hitting the database.

**Built-in Conventions:** Entity Framework follows the conventions over the configuration programming pattern, and includes a set of default rules which automatically configure the Entity Framework model.

**Configuration:** Entity Framework allows us to configure the Entity Framework model by using the data annotation attribute or Fluent API to override the default conventions.

**Migrations:** Entity Framework provides a set of the migration commands which can be executed on the NuGet Package Manager Console or the command-line interface to create or manage the database schema.


## What is an Entity in Entity Framework?
An entity in Entity Framework is a class that maps to a database table. This class must be included as a DbSet type property in the DbContext class. Entity Framework API maps each entity to a table and each property of an entity to a column in the database.
```C#
public class Student  
{  
    public int StuID { get; set; }  
    public string StuName { get; set; }  
    public DateTime? DateOfBirth { get; set; }  
    public byte[] Photo { get; set; }  
    public decimal Height { get; set; }  
    public float Weight { get; set; }  
  
    public Grade Grade { get; set; }  
}  
  
public class Grade  
{  
    public int GrdId { get; set; }  
    public string GrdName { get; set; }  
    public string Section { get; set; }  
  
    public ICollection<Student> Students { get; set; }  
}  
```

The above class becomes the entity when they are included as DbSet properties in a context class (Class which is derives from DbContext)

```C# 
public class SchoolContext : DbContext  
    {  
        public SchoolContext()  
        {  
  
        }  
  
        public DbSet<Student> Students { get; set; }  
        public DbSet<Grade> Grades { get; set; }  
    }  
```
In the above context class, Students and Grades properties are the type of DbSet TEntity  which is called as the set of entity. Student and Grades are entity. Entity Framework API will create the Students and Grades tables in a database.

![[Pasted image 20240328105910.png]]

An Entity can include two types of properties: **Scalar Properties** and **Navigation Properties**.

#### **Scalar Property:** 
The type of primitive property is called scalar properties. Each scalar property maps to a column in the database table which stores the real data. For example, StudentID, StudentName, DateofBirth, height, and weight are the scalar properties in the Student entity class.

```C# 
public class Student  
    {  
        // scalar properties  
        public int StudentID { get; set; }  
        public string StudentName { get; set; }  
        public DateTime? Dateofbirth { get; set; }  
          
        public decimal height { get; set; }  
        public float weight { get; set; }  
     //reference navigation properties  
        public Grade Grade { get; set; }  
    }  
```

Entity Framework API will create a column in the database table for each scalar property.

![[Pasted image 20240328110401.png]]


## Navigation Property

Navigation Property represents the relationship with another entity. We have two types of Navigation property: **Reference Navigation, Collection Navigation**.

### Reference Navigation Property

If an entity includes the property of another type of the entity, then it is called as **Reference Navigation Property**. It points to a single entity and represents the multiplicity of one (1) in the entity-relationship.

Entity Framework API will create a ForeignKey column in the table for the navigation properties that point to a PrimaryKey of another table in the database. For example, Grade is reference navigation properties in the following Student Entity Class.

```C#
public class Student  
  {  
      // scalar properties  
      public int StudentID { get; set; }  
      public string StudentName { get; set; }  
      public DateTime? DateOfBirth { get; set; }  
          public decimal Height { get; set; }  
      public float Weight { get; set; }  
  
      //reference navigation property  
      public Grade Grade { get; set; }  
  }  
```

In the database, Entity Framework API will create a ForeignKey **Grade_GradeID** in the Student Table.
### Collection Navigation Property

If an entity includes a property of the generic collection of an entity type, then it is called a collection navigation property.

Entity Framework API does not create any column for the navigation property in the related table of an entity. Still, it creates a column in the table of the generic collection entity. For example, a Grade entity contains a generic collection navigation property ICollection  Student.




# Entity Framework Architecture 

![[Pasted image 20240328112520.png]]

**EDM (Entity Data Model):** EDM consists of three parts. These three parts are:

Conceptual Model, Mapping, and Storage Model.

**Conceptual Model:** The conceptual model contains the modal classes and their relationships. The conceptual model is independent of the database design table.

**Storage Model:** The storage model is the database design model which includes tables, views, stored procedure, their relationships, and keys.

**Mapping:** Mapping consists the information about how the conceptual model is mapped to the storage model.

**LINQ-to-Entities:** LINQ-to-Entities (L2E) is a query language that is used to write queries against the model of the object. It returns the entities, which is defined in the conceptual model. We can use our LINQ-to-SQL skills here.

**Entity SQL:** Entity SQL is another query language (for EF 6 only), just like LINQ to Entities. However, it is a little more difficult than L2E, and the developer will have to learn it separately.

**Object Service:** Object Service is the main entry point for accessing the data from the database and return it. Object Service is responsible for materialization, and materialization is the process of converting the data returned from an entity client data provider to an entry object structure.

**Entity Client Data Provider:** The main responsibility of this layer is to convert the LINQ-to-Entities or Entity SQL Queries into a SQL Query, which is understood by the database. It communicates with the ADO.NET data provider, which in turn sends or retrieves the data from the database.

**ADO.NET Data Provider:** This layer communicates with the database using the Standard ADO.Net.


```C# 
	1. public class SchoolContext : DbContext  
2. {  
3.     public SchoolContext()  
4.     {  

6.     }  
7.     // Entities          
8.     public DbSet<Student> Students { get; set; }  
9.     public DbSet<StudentAddress> StudentAddresses { get; set; }  
10.     public DbSet<Grade> Grades { get; set; }  
11. }
```

At runtime, Entity Framework API will create an instance of a dynamic proxy for the above Student Entity. The type of dynamic proxy for Students will be System.Data.Entity.DynamicProxies.Student, as shown below:

![[Pasted image 20240328112732.png]]

We use ObjectContext.GetObjectType() to find the wrapped type by the dynamic proxy as shown below:
![[Pasted image 20240328112759.png]]

## EntityState in EntityFramework

Entity Framework API maintains the state of each entity during its lifetime. Each entity has a state, which is based on the operation performed on it by the context class.

- Added
- Modified
- Deleted
- Unchanged
- Detached

