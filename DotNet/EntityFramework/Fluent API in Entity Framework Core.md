
##### **luent API in Entity Framework Core:**

Like the Data Annotation Attribute, the Entity Framework Core provides Fluent API, which we can also use to configure the domain classes, which will override the default conventions that the Entity Framework Core follows.

Fluent API in Entity Framework Core (EF Core) provides a way to configure the model classes and relationships between them using C# code rather than attributes. This allows for a more detailed level of configuration that might not be possible using only Data Annotation Attributes. The Fluent API configurations typically reside in the **OnModelCreating** method of our **DbContext** subclass.


![[word-image-42181-1.webp]]

![[word-image-42181-2.webp]]

##### **What is Method Chaining?**

Method chaining is nothing but a technique or process where each method sets the value of a property of an object and then returns an object, and all these methods can be chained together to form a single statement

![[Fluent-API-Configurations-in-Entity-Framework-Core-with-Examples.webp]]

![[word-image-42181-5.webp]]

```C#
	using System;
namespace FluentInterfaceDesignPattern
{
    public class Program
    {
        static void Main(string[] args)
        {
            FluentStudent student = new FluentStudent();
            student.StudentRegedNumber("BQPPR123456")
                   .NameOfTheStudent("Pranaya Rout")
                   .BornOn("10/10/1992")
                   .StudyOn("CSE")
                   .StaysAt("BBSR, Odisha");

            Console.Read();
        }
    }

    public class Student
    {
        public string RegdNo { get; set; }
        public string Name { get; set; }
        public DateTime DOB { get; set; }
        public string Branch { get; set; }
        public string Address { get; set; }
    }

    public class FluentStudent
    {
        private Student student = new Student();
        public FluentStudent StudentRegedNumber(string RegdNo)
        {
            student.RegdNo = RegdNo;
            return this;
        }
        public FluentStudent NameOfTheStudent(string Name)
        {
            student.Name = Name;
            return this;
        }
        public FluentStudent BornOn(string DOB)
        {
            student.DOB = Convert.ToDateTime(DOB);
            return this;
        }
        public FluentStudent StudyOn(string Branch)
        {
            student.Branch = Branch;
            return this;
        }
        public FluentStudent StaysAt(string Address)
        {
            student.Address = Address;
            return this;
        }
    }
}

```

![[word-image-42181-6.webp]]

##### **Fluent API Configurations in Entity Framework Core:**

In EF Core, the Fluent API configures the following things of a model class.

1. **Model-Wide Configuration:** Configures an EF model to database mappings. Configures the default Schema, DB functions, additional data annotation attributes, and entities to be excluded from mapping.
2. **Entity Configuration:** Configures entity to table and relationships mapping. For example, PrimaryKey, AlternateKey, Index, table name, one-to-one, one-to-many, many-to-many relationships, etc.
3. **Property Configuration:** Configures property to column mapping. For example, column name, default value, nullability, Foreignkey, data type, concurrency column, etc.

Now, let us proceed and try to understand the different methods available in each configuration.

##### **Model-Wide Configurations in EF Core**

1. **HasDbFunction():** Configures a database function when targeting a relational database.
2. **HasDefaultSchema()**: Specifies the database schema.
3. **HasAnnotation():** Adds or updates data annotation attributes on the entity.
4. **HasSequence():** Configures a database sequence when targeting a relational database.

##### **Entity Configurations in EF Core:**

1. **HasAlternateKey():** Configures an alternate key in the EF model for the entity.
2. **HasIndex():** Configures an index of the specified properties.
3. **HasKey():** Configures the property or list of properties as Primary Key.
4. **HasMany():** Configures the Many parts of the relationship, where an entity contains the reference collection property of other types for one-to-many or many-to-many relationships.
5. **HasOne():** The HasOne() method specifies the navigation property representing the relationship’s principal end.
6. **WithOne():** The WithOne() method specifies the navigation property on the dependent end.
7. **HasForeignKey TDependent ():** The HasForeignKey TDependent () method is used to specify which property in the dependent entity represents the foreign key.
8. **HasMany():** Configures a relationship where this entity type has a collection that contains instances of the other type in the relationship. That means it specifies the ‘many’ side of the relationship. 
9. **Ignore():** Configures that the class or property should not be mapped to a table or column.
10. **ToTable():** Configures the database table that the entity maps to.

##### **Property Configurations in Entity Framework:**

1. **HasColumnName():** Configures the corresponding column name in the database for the property.
2. **HasColumnType():** Configures the data type of the corresponding column in the database for the property.
3. **HasComputedColumnSql():** Configures the property to map to computed columns when targeting a relational database.
4. **HasDefaultValue()**: Configures the default value for the column the property maps to when targeting a relational database.
5. **HasDefaultValueSql():** Configures the default value expression for the column the property maps to when targeting a relational database.
6. **HasField():** Specifies the backing field for the property.
7. **HasMaxLength():** Configures the maximum data length stored in a property.
8. **IsConcurrencyToken():** Configures the property to be used as an optimistic concurrency token.
9. **IsRequired():** Configures whether the valid value of the property is required or whether null is a valid value.
10. **IsRowVersion():** Configures the property for optimistic concurrency detection.
11. **IsUnicode():** Configures the string property, which can contain Unicode characters or not.
12. **ValueGeneratedNever():** Configures a property that cannot have a generated value when an entity is saved.
13. **ValueGeneratedOnAdd():** Configures that the property has a generated value when saving a new entity.
14. **ValueGeneratedOnAddOrUpdate():** Configures that the property has a generated value when saving a new or existing entity.
15. **ValueGeneratedOnUpdate():** Configures that a property has a generated value when saving an existing entity.


