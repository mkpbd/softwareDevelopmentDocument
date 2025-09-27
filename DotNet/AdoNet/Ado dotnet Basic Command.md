



![[DotNet/AdoNet/images/word-image-66.webp]]

![[word-image-67.webp]]


![[DotNet/AdoNet/images/word-image-68.webp]]



![[word-image-70.webp]]

##### **Summary of ADO.NET using SQL Server:**
Using ADO.NET with SQL Server involves establishing a connection to the SQL Server database, executing queries, retrieving and manipulating data, and managing transactions. Here’s an overview of how you can use ADO.NET with SQL Server:

**Import Required Namespaces:**
Step 1:
```C#
using System;

using System.Data;

using System.Data.SqlClient;
```

###### **Establish a Connection:**

Create a connection string with the necessary details to connect to your SQL Server database, such as the server name, database name, and authentication credentials.
Step 2: 

```C#
	string connectionString = "Server=MyDatabaseServerAddress;Database=MyDataBase;User Id=MyUserName;Password=MyPassword;";

SqlConnection connection = new SqlConnection(connectionString);

connection.Open();
```

###### **Execute Queries:**

Use the SqlCommand class to create and execute SQL queries against the database. You can perform various types of queries, such as SELECT, INSERT, UPDATE, DELETE, and stored procedures.

``` C#
string sqlQuery = "SELECT * FROM Employees";

SqlCommand command = new SqlCommand(sqlQuery, connection);

SqlDataReader reader = command.ExecuteReader();

while (reader.Read())

{

// Process the data from the reader

}

reader.Close();
```

###### **Retrieve Data:**

Use the SqlDataReader to retrieve and process data returned by SELECT queries. Iterate through the rows using the Read() method and access column values using indexer or GetString(), GetInt32(), etc., methods.

###### **Update Data:**

For data modification (UPDATE, INSERT, DELETE), you can use the ExecuteNonQuery() method of SqlCommand.

```C#
string updateQuery = "UPDATE Employees SET Salary = 50000 WHERE Department = 'IT'";

SqlCommand updateCommand = new SqlCommand(updateQuery, connection);

int rowsAffected = updateCommand.ExecuteNonQuery();
```

**Use Transactions:**
You can manage transactions using the SqlTransaction class. Transactions ensure that a group of operations is completed entirely or rolled back if an error occurs.

```C# 
	SqlTransaction transaction = connection.BeginTransaction();
try

{

// Perform data operations within the transaction

transaction.Commit();

}

catch (Exception ex)

{

transaction.Rollback();

}
```

###### **Close Connection:**

Always close the connection when you’re done using it to free up resources.
```C#
connection.Close();
```




##### **Establish a Connection to the SQL Server database and create a table using ADO.NET.**
```C#
	using System;
using System.Data.SqlClient;
namespace AdoNetConsoleApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            new Program().CreateTable();
            Console.ReadKey();
        }
        public void CreateTable()
        {
            SqlConnection con = null;
            try
            {
                // Creating Connection  
                con = new SqlConnection("data source=.; database=student; integrated security=SSPI");

                // writing sql query  
                SqlCommand cm = new SqlCommand("create table student(id int not null, name varchar(100), email varchar(50), join_date date)", con);  

                // Opening Connection  
                con.Open();

                // Executing the SQL query  
                cm.ExecuteNonQuery();

                // Displaying a message  
                Console.WriteLine("Table created Successfully");
            }
            catch (Exception e)
            {
                Console.WriteLine("OOPs, something went wrong." + e);
            }
            // Closing the connection  
            finally
            {
                con.Close();
            }
        }
    }
}
```

##### **Inserting Record using C# and ADO.NET:**
```C#
using System;
using System.Data.SqlClient;
namespace AdoNetConsoleApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            new Program().InsertRecord();
            Console.ReadKey();
        }
        public void InsertRecord()
        {
            SqlConnection con = null;
            try
            {
                // Creating Connection  
                con = new SqlConnection("data source=.; database=student; integrated security=SSPI");

                // writing sql query  
                SqlCommand cm = new SqlCommand("insert into student (id, name, email, join_date) values ('101', 'Ronald Trump', 'ronald@example.com', '1/12/2017')", con); 
                
                // Opening Connection  
                con.Open();

                // Executing the SQL query  
                cm.ExecuteNonQuery();

                // Displaying a message  
                Console.WriteLine("Record Inserted Successfully");
            }
            catch (Exception e)
            {
                Console.WriteLine("OOPs, something went wrong." + e);
            }
            // Closing the connection  
            finally
            {
                con.Close();
            }
        }
    }
}
```

##### **Retrieve Record using C# and ADO.NET.**

```C#
using System;
using System.Data.SqlClient;
namespace AdoNetConsoleApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            new Program().DisplayData();
            Console.ReadKey();
        }
        public void DisplayData()
        {
            SqlConnection con = null;
            try
            {
                // Creating Connection  
                con = new SqlConnection("data source=.; database=student; integrated security=SSPI");

                // writing sql query  
                SqlCommand cm = new SqlCommand("Select * from student", con);

                // Opening Connection  
                con.Open();

                // Executing the SQL query  
                SqlDataReader sdr = cm.ExecuteReader();

                // Iterating Data  
                while (sdr.Read())
                {
                    // Displaying Record  
                    Console.WriteLine(sdr["id"] + " " + sdr["name"] + " " + sdr["email"]); 
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("OOPs, something went wrong." + e);
            }
            // Closing the connection  
            finally
            {
                con.Close();
            }
        }
    }
}
```

##### **Deleting Record from SQL Server database using C# and ADO.NET**
```C#
using System;
using System.Data.SqlClient;
namespace AdoNetConsoleApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            new Program().DeleteData();
            Console.ReadKey();
        }
        public void DeleteData()
        {
            SqlConnection con = null;
            try
            {
                // Creating Connection  
                con = new SqlConnection("data source=.; database=student; integrated security=SSPI");

                // writing sql query  
                SqlCommand cm = new SqlCommand("delete from student where id = '101'", con);

                // Opening Connection  
                con.Open();

                // Executing the SQL query  
                cm.ExecuteNonQuery();
                Console.WriteLine("Record Deleted Successfully");
            }
            catch (Exception e)
            {
                Console.WriteLine("OOPs, something went wrong." + e);
            }
            // Closing the connection  
            finally
            {
                con.Close();
            }
        }
    }
}
```

