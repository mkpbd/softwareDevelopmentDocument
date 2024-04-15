





# EF Core DbContext

The EF Core `DbContext` class represents a session with a database and provides an API for communicating with the database with the following capabilities:

- Database Connections
- Data operations such as querying and persistence
- Change Tracking
- Model building
- Data Mapping
- Object caching
- Transaction management

## Data Operations 

The DbContext provides methods for performing the following data operations directly.

- [Adding data](https://www.learnentityframeworkcore.com/dbcontext/adding-data)
- [Modifying data](https://www.learnentityframeworkcore.com/dbcontext/modifying-data)
- [Deleting data](https://www.learnentityframeworkcore.com/dbcontext/deleting-data)
- The `DbContext` also provides [data querying](https://www.learnentityframeworkcore.com/dbset/querying-data) capability via the DbSet property.

## Change Tracking 

The [Change Tracker](https://www.learnentityframeworkcore.com/dbcontext/change-tracker) detects changes made to entities and sets the `EntityState` of an object accordingly. The state of the entity determines the type of operation that the database will be asked to perform upon it, and therefore the SQL that will be generated.

## Model Building 

The `DbContext` builds a [conceptual model](https://www.learnentityframeworkcore.com/model) based on [convention](https://www.learnentityframeworkcore.com/conventions) and [configuration](https://www.learnentityframeworkcore.com/configuration) and maps that to the database. The model and its mappings are built at application startup and are persisted in memory for the lifetime of the application.

## Transaction Management 

When the DbContext `SaveChanges` method is called, a transaction is created and all pending changes are wrapped in it as a single [unit of work](http://martinfowler.com/eaaCatalog/unitOfWork.html). If an error occurs when the changes are applied to the database, they are rolled back and the database is left in an unmodified condition.

# EF Core Insert Entity

The key methods for adding/inserting entities via the `DbContext` are

- `Add<TEntity>(TEntity entity)`
- `Add(object entity)`
- `AddRange(IEnumerable<object> entities)`
- `AddRange(params object[] entities)`
```C#
// with a type parameter
var author = new Author{ FirstName = "William", LastName = "Shakespeare" };
context.Add<Author>(author);
context.SaveChanges();
// without a type parameter
var author = new Author{ FirstName = "William", LastName = "Shakespeare" };
context.Add(author);
context.SaveChanges();
```


``` C#
	var context = new SampleContext();
var author = new Author {
    FirstName = "William",
    LastName = "Shakespeare",
    Books = new List<Book>
    {
        new Book { Title = "Hamlet"},
        new Book { Title = "Othello" },
        new Book { Title = "MacBeth" }
    }
};
context.Add(author);
context.SaveChanges();
```

## EF Core Adding Multiple Records
```C#
var context = new SampleContext();
var author = new Author { FirstName = "Stephen", LastName = "King" };
var books = new List<Book> {
    new Book { Title = "It", Author = author },
    new Book { Title = "Carrie", Author = author },
    new Book { Title = "Misery", Author = author }
};
context.AddRange(books);
context.SaveChanges();
```

```C#
var context = new SampleContext();
var author = new Author { FirstName = "William", LastName = "Shakespeare" };
var book = new Book { Title = "Adventures of Huckleberry Finn" };
context.AddRange(author, book);
context.SaveChanges();

```
# EF Core Update Entity

```C#
var author = context.Authors.First(a => a.AuthorId == 1);
author.FirstName = "Bill";
context.SaveChanges();
```
## Setting EntityState 

You can set the `EntityState` of an entity via the `EntityEntry.State` property, which is made available by the `DbContext.Entry` method.
```C#
public void Save(Author author)
{
    context.Entry(author).State = EntityState.Modified;
    context.SaveChanges();
}
```
## DbContext Update 

The `DbContext` class provides `Update` and `UpdateRange` methods for working with individual or multiple entities.

```C#
public void Save(Author author)
{
    context.Update(author);
    context.SaveChanges();
}
```

## Attach
```C#
var context = new TestContext();
var author = new Author {
    AuthorId = 1,
    FirstName = "William",
    LastName = "Shakespeare"
};
author.Books.Add(new Book {BookId = 1, Title = "Othello" });
context.Attach(author);
context.Entry(author).Property("FirstName").IsModified = true;
context.SaveChanges();
```

# EF Core Delete Entity
the entity to be deleted is obtained by the context, so the context begins tracking it immediately. The `DbContext.Remove` method results in the entity's `EntityState` being set to `Deleted`.

```C#
context.Remove(context.Authors.Single(a => a.AuthorId == 1));
context.SaveChanges();
```

```C#
var context = new SampleContext();
var author = new Author { AuthorId = 1 };
context.Remove(author);
context.SaveChanges();
```

## Setting EntityState 

You can explicitly set the `EntityState` of an entity to `Deleted` via the `EntityEntry.State` property, which is made available by the `DbContext.Entry` method.

```C#
var context = new SampleContext();
var author = new Author { AuthorId = 1 };
context.Entry(author).State = EntityState.Deleted;
context.SaveChanges();
```

## Related Data

```C#
public class Author
{
   public int AuthorId { get; set; }
   public string FirstName { get; set; }
   public string LastName { get; set; }
   public ICollection<Book> Books { get; set; }
}
public class Book
{
   public int BookId { get; set; }
   public string Title { get; set; }
}

var context = new SampleContext();
var author = context.Authors.Single(a => a.AuthorId == 1);
var books = context.Books.Where(b => EF.Property<int>(b, "AuthorId") == 1);
foreach (var book in books)
{
    author.Books.Remove(book);
}
context.Remove(author);
context.SaveChanges();

```

# EF Core ChangeTracker

The Change Tracker records the current state of an entity using one of four values:

- Added
- Unchanged
- Modified
- Deleted

Entities in the `Added` state will be inserted as new records into the database. Entities in the `Modified` state will have their values updated in the database to the current property values. Entities in the `Deleted` state will be removed from the database. No action will be taken in respect of entities marked as `Unchanged`.

- `Add`
- `Attach`
- `Update`
- `Remove`

or by having its `State` property set on the entity entry returned by calling the context's `Entry` method.

## DbContext.Add

```C#
var db = new TestContext();
var book = new Book { 
    Title = "King Lear",
    Author = new Author { 
        FirstName = "William",
        LastName = "Shakespeare"
    }
}
db.Add(book); // Book Added, Author Added
```

```c#
var db = new TestContext();
var book = new Book { Title = "Romeo and Juliet" };
book.Author = db.Authors.Single(a => a.AuthorId == 1);
db.Add(book); // Book Added, Author Unchanged
```

```C#
var db = new TestContext();
var book = new Book { Title = "Romeo and Juliet" }; // Book Added, 
book.Author = db.Authors.Single(a => a.AuthorId == 1); // Author Unchanged
book.Author.FirstName = "Bill"; // Author Modified
db.Add(book);
```

## DbContext.Attach 

Tells EF that the entity already exists in the database, and sets the state of the entity to Unchanged.

```C#
var db = new TestContext();
var book = new Book { BookId = 1 }; 
db.Attach(book); // Book Unchanged
```

## DbContext.Update 

Tells EF that the entity is modified. It will also set all reachable entities as modified if they are not already being tracked.
```C#
var db = new TestContext();
var book = new Book { BookId = 1 }; 
db.Update(book); // Book Modified
```

## DbContext.Remove 

Marks only the root entity as deleted. Cascade deletion will take effect if implemented.

```C#
var db = new TestContext();
var book = new Book { BookId = 1 };
db.Remove(book); // Book Deleted

// Second Example 
var db = new TestContext();
var book = new Book {
    BookId = 1, 
    Author = db.Authors.SingleOrDefault(a => a.AuthorId == 1) 
};
db.Remove(book); // Book Deleted,  Author Unchanged


```
# EF Core DbSet

The `DbSet<TEntity>` class represents a collection for a given entity within the model and is the gateway to database operations against an entity. `DbSet<TEntity>` classes are added as properties to the `DbContext` and are mapped by default to database tables that take the name of the `DbSet<TEntity>` property. The `DbSet` is an implementation of the [Repository pattern](http://martinfowler.com/eaaCatalog/repository.html)

``` C#
	public class SampleContext : DbContext
{
    public DbSet<Book> Books { get; set; }
    public DbSet<Author> Authors { get; set; }
}
public class Author
{
    public int AuthorId { get; set; }
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public ICollection<Book> Books { get; set; }
}
public class Book
{    public int BookId { get; set; }
    public string Title { get; set; }
    public Author Author { get; set; }
    public int AuthorId { get; set; }
}
```

## Basic operations 

The `DbSet` object represents collections of entities _in memory_. Any changes you make to the contents of a `DbSet` will only be committed to the database if the `SaveChanges` method of the `DbContext` is called.

The `DbSet` class exposes several methods that enable you to perform basic CRUD (**C**reate, **R**ead, **U**pdate, **D**elete) operations against entities.

### Adding an entity 

To add a new entity to the collection represented by the `DbSet`, you use the `DbSet.Add` method:

```C#
var author = new Author{
    FirstName = "William",
    LastName = "Shakespeare"
};
using (var context = new SampleContext())
{
    context.Authors.Add(author); // adds the author to the DbSet in memory
    context.SaveChanges(); // commits the changes to the database
}
```

### Retrieving an entity
```C#
using (var context = new SampleContext())
{
    var author = context.Authors.Single(a => a.AuthorId == 1);
}
// Second Example 
	using (var context = new SampleContext())
{
    var author = context.Authors.FirstOrDefault(a => a.LastName == "Shakespeare");
}

// Thrid Example 
using (var context = new SampleContext())
{
    var author = context.Authors.Find(1);
}
```
