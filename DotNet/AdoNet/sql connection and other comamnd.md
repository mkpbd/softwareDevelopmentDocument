##### **What do we discuss in the Introduction Part of this article?**

1. [**Connection**](https://dotnettutorials.net/lesson/ado-net-sqlconnection-class/)
2. [**Command**](https://dotnettutorials.net/lesson/ado-net-sqlcommand-class/)
3. [**DataReader**](https://dotnettutorials.net/lesson/ado-net-sqldatareader/)
4. [**DataAdapter**](https://dotnettutorials.net/lesson/ado-net-sqldataadapter/)
5. [**DataSet**](https://dotnettutorials.net/lesson/ado-net-dataset/)



##### **ADO.NET SqlConnection class Signature in C#:**

Following is the signature of the SqlConnection class. As you can see, it is a sealed class inherited from the DbConnection class and implements the ICloneable interface.
![[word-image-76.webp]]

##### **SqlConnection Class Constructors:**

![[ADO.NET-SqlConnection-Class-Constructirs.webp]]

1. **SqlConnection():** It initializes a new instance of the System.Data.SqlClient.SqlConnection class
2. **SqlConnection(String connectionString):** This constructor is used to initialize a new instance of the System.Data.SqlClient.SqlConnection class when given a string that contains the connection string.
3. **SqlConnection(String connectionString, SqlCredential credential):** It is used to initialize a new instance of the System.Data.SqlClient.SqlConnection class given a connection string that does not use Integrated Security = true and a System.Data.SqlClient.SqlCredential object that contains the user ID and password
##### **C# SqlConnection Class Methods:**

1. **BeginTransaction():** It is used to start a database transaction and returns an object representing the new transaction.
2. **ChangeDatabase(string database):** It is used to change the current database for an open SqlConnection. Here, the parameter database is nothing but the name of the database to use instead of the current database.
3. **ChangePassword(string connectionString, string newPassword):** Changes the SQL Server password for the user indicated in the connection string to the supplied new password. Here, the parameter connectionString is the connection string that contains enough information to connect to the server that you want. The connection string must contain the user ID and the current password. The parameter newPassword is the new password to set. This password must comply with any password security policy set on the server, including minimum length, requirements for specific characters, and so on.
4. **Close():** It is used to close the connection to the database. This is the preferred method of closing any open connection.
5. **CreateCommand():** It Creates and returns a System.Data.SqlClient.SqlCommand object associated with the System.Data.SqlClient.SqlConnection.
6. **GetSchema():** It returns schema information for the data source of this System.Data.SqlClient.SqlConnection.
7. **Open():** This method is used to open a database connection with the property settings specified by the System.Data.SqlClient.SqlConnection.ConnectionString.


# **Using the Constructor, which takes the connection string as the parameter.**

![[word-image-77.webp]]


##### **Using the Parameterless Constructor of C# SqlConnection class:**

![[word-image-78.webp]]
**Note:** The ConnectionString parameter is a string of Key/Value pairs with the information required to create a connection object.

![[word-image-79.webp]]


##### **SqlConnection Example in C#**

![[word-image-80.webp]]


```C#
using System;
using System.Data.SqlClient;
namespace AdoNetConsoleApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            new Program().Connecting();
            Console.ReadKey();
        }

        public void Connecting()
        {
            SqlConnection con = null;
            try
            {
                // Creating Connection  
                string ConnectionString = "data source=.; database=student; integrated security=SSPI";
                con = new SqlConnection(ConnectionString);
                con.Open();
                Console.WriteLine("Connection Established Successfully");
            }
            catch (Exception e)
            {
                Console.WriteLine("OOPs, something went wrong.\n" + e);
            }
            finally
            {   // Closing the connection  
                con.Close();
            }
        }
    }
}
```

##### **How do you store the connection string in the configuration file?**

As we are working with a console application, the configuration file is ***app.config***. So, we need to store the connection string in the **app.config** file as shown below. Give a meaningful name to your connection string. As we will communicate with the SQL Server database, we need to provide the provider name as **System.Data.SqlClient**.

```C#
<connectionStrings>
    <add name="ConnectionString"
         connectionString="data source=.; database=student; integrated security=SSPI"
         providerName="System.Data.SqlClient" />
</connectionStrings>
```
## **How to read the connection string from the app.config file?**




```C#
using System;
using System.Configuration;
using System.Data.SqlClient;
namespace AdoNetConsoleApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                string ConString = ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
                using (SqlConnection connection = new SqlConnection(ConString))
                {
                    connection.Open();
                    Console.WriteLine("Connection Established Successfully");
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("OOPs, something went wrong.\n" + e);
            }
            Console.ReadKey();
        }
    }
}
```


**Execute Commands:**

```C#
string sqlQuery = "SELECT FirstName, LastName FROM Employees";
SqlCommand command = new SqlCommand(sqlQuery, connection);

SqlDataReader reader = command.ExecuteReader();
while (reader.Read())
{
      Console.WriteLine(reader["FirstName"] + " " + reader["LastName"]);
}
reader.Close();
```
###### **Close the Connection:**

After you’re done with the connection, close it to release resources:  
***connection.Close();**

**Using Statement (Recommended**
To ensure that the connection is properly closed, it’s a good practice to use the using statement, which automatically disposes of the resources even if an exception occurs:
``` C#
using (SqlConnection connection = new SqlConnection(connectionString))
{
connection.Open();

// Execute commands and perform operations

} // Connection is automatically closed and disposed here
```


# **What is ADO.NET SqlCommand Class in C#?**
The ADO.NET SqlCommand class in C# stores and executes the SQL statement against the SQL Server database. As you can see in the image below, the **SqlCommand** class is a sealed class and is inherited from the DbCommand class and implements the ICloneable interface. As a sealed class, it cannot be inherited.
![[Pasted image 20240327145052.png]]
##### **Constructors of ADO.NET SqlCommand Class in C#**

The SqlCommand class in C# provides the following five constructors.

![[Constructors-of-ADO.NET-SqlCommand-Class-in-C.webp]]

##### **SqlCommand():**

This constructor is used to initialize a new instance of the System.Data.SqlClient.SqlCommand class.
##### **SqlCommand(string cmdText):**

It is used to initialize a new instance of the System.Data.SqlClient.SqlCommand class with the text of the query. Here, the cmdText is the query text we want to execute.
##### **SqlCommand(string cmdText, SqlConnection connection):**

##### **SqlCommand(string cmdText, SqlConnection connection, SqlTransaction transaction):**

##### **SqlCommand(string cmdText, SqlConnection connection, SqlTransaction transaction, SqlCommandColumnEncryptionSetting columnEncryptionSetting):**

##### **Methods of SqlCommand Class in C#**

1. **BeginExecuteNonQuery():** This method initiates the asynchronous execution of the Transact-SQL statement or stored procedure that is described by this System.Data.SqlClient.SqlCommand.
2. **Cancel():** This method tries to cancel the execution of a System.Data.SqlClient.SqlCommand.
3. **Clone():** This method creates a new System.Data.SqlClient.SqlCommand object is a copy of the current instance.
4. **CreateParameter():** This method creates a new instance of a System.Data.SqlClient.SqlParameter object.
5. **ExecuteReader():** This method Sends the System.Data.SqlClient.SqlCommand.CommandText to the System.Data.SqlClient.SqlCommand.Connection and builds a System.Data.SqlClient.SqlDataReader.
6. **ExecuteScalar():** This method Executes the query and returns the first column of the first row in the result set returned by the query. Additional columns or rows are ignored.
7. **ExecuteNonQuery():** This method executes a Transact-SQL statement against the connection and returns the number of rows affected.
8. **Prepare():** This method creates a prepared version of the command on an instance of SQL Server.
9. **ResetCommandTimeout():** This method resets the CommandTimeout property to its default value.

##### **Example to understand the ADO.NET SqlCommand Object in C#:**
![[word-image-85.webp]]

```SQL
CREATE DATABASE StudentDB;
GO

USE StudentDB;
GO

CREATE TABLE Student(
 Id INT PRIMARY KEY,
 Name VARCHAR(100),
 Email VARCHAR(50),
 Mobile VARCHAR(50)
)
GO

INSERT INTO Student VALUES (101, 'Anurag', 'Anurag@dotnettutorial.net', '1234567890')
INSERT INTO Student VALUES (102, 'Priyanka', 'Priyanka@dotnettutorial.net', '2233445566')
INSERT INTO Student VALUES (103, 'Preety', 'Preety@dotnettutorial.net', '6655443322')
INSERT INTO Student VALUES (104, 'Sambit', 'Sambit@dotnettutorial.net', '9876543210')
GO
```
**Note:** **ExecuteReader**, **ExecuteNonQuery**, and **ExecuteScalar** are the methods that are commonly used. Let us see three examples to understand these methods.

##### **ExecuteReader Method of SqlCommand Object in C#:**

```C#
using System;
using System.Data.SqlClient;
namespace AdoNetConsoleApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                string ConString = "data source=.; database=StudentDB; integrated security=SSPI";
                using (SqlConnection connection = new SqlConnection(ConString))
                {
                    // Creating SqlCommand objcet   
                    SqlCommand cm = new SqlCommand("select * from student", connection);

                    // Opening Connection  
                    connection.Open();

                    // Executing the SQL query  
                    SqlDataReader sdr = cm.ExecuteReader();
                    while (sdr.Read())
                    {
                        Console.WriteLine(sdr["Name"] + ",  " + sdr["Email"] + ",  " + sdr["Mobile"]);
                    }
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("OOPs, something went wrong.\n" + e);
            }
            Console.ReadKey();
        }
    }
}
```

## **Understanding the ADO.NET SqlCommand Object in C#:**

**SqlCommand** using the constructor, which takes two parameters, as shown in the image below. The first parameter is the **command text** we want to execute, and the second parameter is the connection object, which provides the database details on which the command will execute.
![[word-image-87.webp]]

```C#
using System;
using System.Data.SqlClient;
namespace AdoNetConsoleApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                string ConString = "data source=.; database=StudentDB; integrated security=SSPI";
                using (SqlConnection connection = new SqlConnection(ConString))
                {
                    // Creating SqlCommand objcet 
                    SqlCommand cmd = new SqlCommand();
                    cmd.CommandText = "select * from student";
                    cmd.Connection = connection;

                    // Opening Connection  
                    connection.Open();

                    // Executing the SQL query  
                    SqlDataReader sdr = cmd.ExecuteReader();
                    while (sdr.Read())
                    {
                        Console.WriteLine(sdr["Name"] + ",  " + sdr["Email"] + ",  " + sdr["Mobile"]);
                    }
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("OOPs, something went wrong.\n" + e);
            }
            Console.ReadKey();
        }
    }
}
```

##### **ExecuteScalar Method of SqlCommand Object in C#:**
When your T-SQL query or stored procedure returns a single (i.e., scalar) value, then you need to use the **ExecuteScalar** method of the SqlCommand object in C#.   The return type of the ExecuteScalar method is an object, so here, we need to typecast it into an integer type. If you execute the above program, you will get the following output.
```C#

using System;
using System.Data.SqlClient;
namespace AdoNetConsoleApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                string ConString = "data source=.; database=StudentDB; integrated security=SSPI";
                using (SqlConnection connection = new SqlConnection(ConString))
                {
                    // Creating SqlCommand objcet 
                    SqlCommand cmd = new SqlCommand("select count(id) from student", connection);

                    // Opening Connection  
                    connection.Open();

                    // Executing the SQL query  
                    // Since the return type of ExecuteScalar() is object, we are type casting to int datatype
                    int TotalRows = (int)cmd.ExecuteScalar();

                    Console.WriteLine("TotalRows in Student Table :  " + TotalRows);
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("OOPs, something went wrong.\n" + e);
            }
            Console.ReadKey();
        }
    }
}

```

## **ExecuteNonQuery Method of ADO.NET SqlCommand Object in C#:**
hen you want to perform **Insert, Update, or Delete** operations and return the number of rows affected by your query, you need to use the **ExecuteNonQuery** method of the SqlCommand object in C#.
```C#
using System;
using System.Data.SqlClient;
namespace AdoNetConsoleApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                string ConString = "data source=.; database=StudentDB; integrated security=SSPI";
                using (SqlConnection connection = new SqlConnection(ConString))
                {
                    SqlCommand cmd = new SqlCommand("insert into Student values (105, 'Ramesh', 'Ramesh@dotnettutorial.net', '1122334455')", connection);

                    connection.Open();
                    int rowsAffected = cmd.ExecuteNonQuery();
                    Console.WriteLine("Inserted Rows = " + rowsAffected);

                    //Set to CommandText to the update query. We are reusing the command object, 
                    //instead of creating a new command object
                    cmd.CommandText = "update Student set Name = 'Ramesh Changed' where Id = 105";
                    rowsAffected = cmd.ExecuteNonQuery();
                    Console.WriteLine("Updated Rows = " + rowsAffected);

                    //Set to CommandText to the delete query. We are reusing the command object, 
                    //instead of creating a new command object
                    cmd.CommandText = "Delete from Student where Id = 105";
                   
                    rowsAffected = cmd.ExecuteNonQuery();
                    Console.WriteLine("Deleted Rows = " + rowsAffected);
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("OOPs, something went wrong.\n" + e);
            }
            Console.ReadKey();
        }
    }
}
```


**SELECT Query:**  
For executing SELECT queries and retrieving data:
```C#
string sqlQuery = ""select * from student"";
SqlCommand command = new SqlCommand(sqlQuery, connection);

SqlDataReader reader = command.ExecuteReader();
while (reader.Read())
{
   Console.WriteLine(reader["Name"] + ", " + reader["Email"] + ", " + reader["Mobile"]);
}
reader.Close();
```
**Non-Query Command (INSERT, UPDATE, DELETE):**
```C#
string insertQuery = "Insert into Student values (105, 'Ramesh', 'Ramesh@dotnettutorial.net', '1122334455')";
SqlCommand insertCommand = new SqlCommand(insertQuery, connection);
int rowsAffected = insertCommand.ExecuteNonQuery();
```
**Stored Procedures:**

```C#
SqlCommand spCommand = new SqlCommand("StoredProcedureName", connection);
spCommand.CommandType = CommandType.StoredProcedure;

SqlParameter parameter = new SqlParameter("@ParameterName", SqlDbType.VarChar);
parameter.Value = "ParameterValue";
spCommand.Parameters.Add(parameter);

// Execute the stored procedure
SqlDataReader spReader = spCommand.ExecuteReader();
```
**Parameterized Queries:**  
It’s highly recommended to use parameterized queries to prevent SQL injection. You can add parameters to your command to safely pass values:
```C#
string sqlQuery = "SELECT * FROM Employees WHERE Department = @Department";
SqlCommand paramCommand = new SqlCommand(sqlQuery, connection);

paramCommand.Parameters.AddWithValue("@Department", "IT");
SqlDataReader paramReader = paramCommand.ExecuteReader();
```
Always close and dispose of resources when you’re done with them:  
**command.Dispose();**  
**connection.Close();**  
**connection.Dispose();**


###### **Using Statement (Recommended):**

To ensure that resources are properly disposed of, use the using statement:
```C#
using (SqlConnection connection = new SqlConnection(connectionString))
{
   connection.Open();
   using (SqlCommand command = new SqlCommand(sqlQuery, connection))
   {
       // Execute commands and retrieve data
   } // Command is automatically disposed here
} // Connection is automatically closed and disposed here
```

## **ADO.NET SqlDataReader Class in C# with Examples**
- **SqlDataReader is Connection-Oriented.** It means it requires an open or active connection to the data source while reading the data. The data is available as long as the connection with the database exists.
- **SqlDataReader is Read-Only.** It means it is also not possible to change the data using SqlDataReader. You also need to open and close the connection explicitly.
- **Forward-Only:** The SqlDataReader works forwardly, meaning it can only read data in one direction – from the first to the last.

![[word-image-94.webp]]
 ### Property 
 
1. **Connection**: It gets the System.Data.SqlClient.SqlConnection associated with the System.Data.SqlClient.SqlDataReader.
2. **Depth**: It gets a value that indicates the depth of nesting for the current row.
3. **FieldCount**: It gets the number of columns in the current row.
4. **HasRows**: It gets a value that indicates whether the System.Data.SqlClient.SqlDataReader contains one or more rows.
5. **IsClosed**: It retrieves a Boolean value that indicates whether the specified System.Data.SqlClient.SqlDataReader instance has been closed.
6. **RecordsAffected**: It gets the number of rows changed, inserted, or deleted by executing the Transact-SQL statement.
7. **VisibleFieldCount**: It gets the number of fields in the System.Data.SqlClient.SqlDataReader that is not hidden.
8. **Item[String]**: It gets the specified column’s value in its native format, given the column name.
9. **Item[Int32]**: It gets the specified column’s value in its native format given the column ordinal.

### **ADO.NET SqlDataReader Class Methods in C#**:
1. **Close():** It closes the SqlDataReader object.
2. **GetBoolean(int i):** It gets the specified column’s value as a Boolean. Here, parameter i is the zero-based column ordinal.
3. **GetByte(int i):** It gets the specified column’s value as a byte. Here, parameter i is the zero-based column ordinal.
4. **GetChar(int i):** It gets the specified column’s value as a single character. Here, parameter i is the zero-based column ordinal.
5. **GetDateTime(int i):** It gets the value of the specified column as a System.DateTime object. Here, parameter i is the zero-based column ordinal.
6. **GetDecimal(int i):** It gets the value of the specified column as a System.Decimal object. Here, parameter i is the zero-based column ordinal.
7. **GetDouble(int i):** It gets the specified column’s value as a double-precision floating-point number. Here, parameter i is the zero-based column ordinal.
8. **GetFloat(int i):** It gets the specified column’s value as a single-precision floating-point number. Here, parameter i is the zero-based column ordinal.
9. **GetName(int i):** It gets the name of the specified column. Here, parameter i is the zero-based column ordinal.
10. **GetSchemaTable():** It returns a System.Data.DataTable that describes the column metadata of the System.Data.SqlClient.SqlDataReader
11. **GetValue(int i):** It gets the specified column’s value in its native format. Here, parameter i is the zero-based column ordinal.
12. **GetValues(object[] values):** It Populates an array of objects with the column values of the current row. Here, the parameter values are an array of System.Object into which to copy the attribute columns.
13. **NextResult():** It advances the data reader to the next result when reading the results of batch Transact-SQL statements.
14. **Read():** It Advances the System.Data.SqlClient.SqlDataReader to the next record, returns true if there are more rows; otherwise, it is false.


![[word-image-95.webp]]

```SQL
	CREATE DATABASE StudentDB;
GO

USE StudentDB;
GO

CREATE TABLE Student(
 Id INT PRIMARY KEY,
 Name VARCHAR(100),
 Email VARCHAR(50),
 Mobile VARCHAR(50)
)
GO

INSERT INTO Student VALUES (101, 'Anurag', 'Anurag@dotnettutorial.net', '1234567890')
INSERT INTO Student VALUES (102, 'Priyanka', 'Priyanka@dotnettutorial.net', '2233445566')
INSERT INTO Student VALUES (103, 'Preety', 'Preety@dotnettutorial.net', '6655443322')
INSERT INTO Student VALUES (104, 'Sambit', 'Sambit@dotnettutorial.net', '9876543210')
GO
```

##### **Example to Understand ADO.NET SqlDataReader in C#**
```C#
using System;
using System.Data.SqlClient;
namespace AdoNetConsoleApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                string ConString = "data source=.; database=StudentDB; integrated security=SSPI";
                using (SqlConnection connection = new SqlConnection(ConString))
                {
                    // Creating the command object
                    SqlCommand cmd = new SqlCommand("select Name, Email, Mobile from student", connection);

                    // Opening Connection  
                    connection.Open();

                    // Executing the SQL query  
                    SqlDataReader sdr = cmd.ExecuteReader();

                    //Looping through each record
                    while (sdr.Read())
                    {
                        Console.WriteLine(sdr["Name"] + ",  " + sdr["Email"] + ",  " + sdr["Mobile"]);
                    }
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("OOPs, something went wrong.\n" + e);
            }

            Console.ReadKey();
        }
    }
}
```
##### **Example to Understand SqlDataReader in C#**

```C#
using System;
using System.Data.SqlClient;
namespace AdoNetConsoleApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                string ConString = @"data source=.; database=StudentDB; integrated security=SSPI";
                using (SqlConnection connection = new SqlConnection(ConString))
                {
                    // Creating the command object
                    SqlCommand cmd = new SqlCommand("select Name, Email, Mobile from student", connection);
                    // Opening Connection  
                    connection.Open();
                    // Executing the SQL query  
                    SqlDataReader sdr = cmd.ExecuteReader();

                    //Looping through each record
                    while (sdr.Read())
                    {
                        Console.WriteLine(sdr[0] + ",  " + sdr[1] + ",  " + sdr[2]);
                    }
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("OOPs, something went wrong.\n" + e);
            }
            Console.ReadKey();
        }
    }
}
```
##### **Example to Understand SqlDataReader Active and Open Connection in C#**
```C#
using System;
using System.Data.SqlClient;
namespace AdoNetConsoleApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                string ConString = @"data source=.; database=StudentDB; integrated security=SSPI";
                using (SqlConnection connection = new SqlConnection(ConString))
                {
                    // Creating the command object
                    SqlCommand cmd = new SqlCommand("select Name, Email, Mobile from student", connection);
                    // Opening Connection  
                    connection.Open();
                    // Executing the SQL query  
                    SqlDataReader sdr = cmd.ExecuteReader();

                    // Closing the Connection  
                    connection.Close();

                    //Reading Data from Reader will give runtime error as the connection is closed
                    while (sdr.Read())
                    {
                        Console.WriteLine(sdr[0] + ",  " + sdr[1] + ",  " + sdr[2]);
                    }
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("OOPs, something went wrong.\n" + e.Message);
            }
            Console.ReadKey();
        }
    }
}
```

```SQL
CREATE DATABASE ShoppingCartDB;
GO

USE ShoppingCartDB;
GO

CREATE TABLE Customers(
 ID INT PRIMARY KEY,
 Name VARCHAR(100),
 Mobile VARCHAR(50)
)
GO

INSERT INTO Customers VALUES (101, 'Anurag', '1234567890')
INSERT INTO Customers VALUES (102, 'Priyanka', '2233445566')
INSERT INTO Customers VALUES (103, 'Preety', '6655443322')
GO

CREATE TABLE Orders(
 ID INT PRIMARY KEY,
 CustomerId INT,
 Amount INT
)
GO

INSERT INTO Orders VALUES (10011, 103, 20000)
INSERT INTO Orders VALUES (10012, 101, 30000)
INSERT INTO Orders VALUES (10013, 102, 25000)
GO

```


```C#
using System;
using System.Data.SqlClient;
namespace AdoNetConsoleApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                string ConString = @"data source=LAPTOP-ICA2LCQL\SQLEXPRESS; database=ShoppingCartDB; integrated security=SSPI";
                using (SqlConnection connection = new SqlConnection(ConString))
                {
                    // Creating the command object
                    SqlCommand cmd = new SqlCommand("SELECT * FROM Customers; SELECT * FROM Orders", connection);

                    // Opening Connection  
                    connection.Open();

                    // Executing the SQL query  
                    SqlDataReader reader = cmd.ExecuteReader();

                    //Looping through First Result Set
                    Console.WriteLine("First Result Set:");
                    while (reader.Read())
                    {
                        Console.WriteLine(reader[0] + ",  " + reader[1] + ",  " + reader[2]);
                    }

                    //To retrieve the second result set from SqlDataReader object, use the NextResult(). 
                    //The NextResult() method returns true and advances to the next result-set.
                    while (reader.NextResult())
                    {
                        Console.WriteLine("\nSecond Result Set:");
                        //Looping through each record
                        while (reader.Read())
                        {
                            Console.WriteLine(reader[0] + ",  " + reader[1] + ",  " + reader[2]);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Exception Occurred: {ex.Message}");
            }

            Console.ReadKey();
        }
    }
}

```

# **ADO.NET SqlDataAdapter Class in C#**

![[word-image-98.webp]]

![[word-image-99.webp]]

1. **SqlDataAdapter():** Initializes a new instance of the SqlDataAdapter class.
2. **SqlDataAdapter(SqlCommand selectCommand):** Initializes a new instance of the SqlDataAdapter class with the specified SqlCommand. The selectCommand can be a Transact-SQL SELECT statement or a stored procedure.
3. **SqlDataAdapter(string selectCommandText, string selectConnectionString):** Initializes a new instance of the SqlDataAdapter class with the command and a connection string. The selectCommandText can be a Transact-SQL SELECT statement or a stored procedure.
4. **SqlDataAdapter(string selectCommandText, SqlConnection selectConnection)**: Initializes a new instance of the SqlDataAdapter class with the command and a connection string. The selectCommandText can be a Transact-SQL SELECT statement or a stored procedure. If your connection string does not use Integrated Security = true, you can use System.Data.SqlClient.SqlCredential to pass the user ID and password more securely than by specifying the user ID and password as text in the connection string.
##### **Methods of ADO.NET SqlDataAdapter class in C#:**
1. **CloneInternals():** It is used to create a copy of this instance of DataAdapter.
2. **Dispose(Boolean):** It is used to release the unmanaged resources used by the DataAdapter.
3. **Fill(DataSet):** It is used to add rows in the DataSet to match those in the data source.
4. **FillSchema(DataSet, SchemaType, String, IDataReader):** Add a DataTable to the specified DataSet.
5. **GetFillParameters():** It is used to get the parameters set by the user when executing an SQL SELECT statement.
6. **ResetFillLoadOption():** It is used to reset FillLoadOption to its default state.
7. **ShouldSerializeAcceptChangesDuringFill()**: It determines whether the
8. **ShouldSerializeFillLoadOption():** It determines whether the FillLoadOption property should be persisted or not.
9. **ShouldSerializeTableMappings():** It determines whether one or more DataTableMapping objects exist or not.
10. **Update(DataSet):** It is used to call the respective INSERT, UPDATE, or DELETE statements.
![[word-image-100.webp]]

```SQL
CREATE DATABASE StudentDB;
GO

USE StudentDB;
GO

CREATE TABLE Student(
 Id INT PRIMARY KEY,
 Name VARCHAR(100),
 Email VARCHAR(50),
 Mobile VARCHAR(50)
)
GO

INSERT INTO Student VALUES (101, 'Anurag', 'Anurag@dotnettutorial.net', '1234567890')
INSERT INTO Student VALUES (102, 'Priyanka', 'Priyanka@dotnettutorial.net', '2233445566')
INSERT INTO Student VALUES (103, 'Preety', 'Preety@dotnettutorial.net', '6655443322')
INSERT INTO Student VALUES (104, 'Sambit', 'Sambit@dotnettutorial.net', '9876543210')
GO
```
#####  **Understand ADO.NET SqlDataAdapter in C#**
```C#
using System;
using System.Data;
using System.Data.SqlClient;
namespace AdoNetConsoleApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                string ConString = @"data source=LAPTOP-ICA2LCQL\SQLEXPRESS; database=StudentDB; integrated security=SSPI";
                using (SqlConnection connection = new SqlConnection(ConString))
                {
                    SqlDataAdapter da = new SqlDataAdapter("select * from student", connection);

                    //Using Data Table
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    //The following things are done by the Fill method
                    //1. Open the connection
                    //2. Execute Command
                    //3. Retrieve the Result
                    //4. Fill/Store the Retrieve Result in the Data table
                    //5. Close the connection

                    Console.WriteLine("Using Data Table");
                    //Active and Open connection is not required
                    //dt.Rows: Gets the collection of rows that belong to this table
                    //DataRow: Represents a row of data in a DataTable.
                    foreach (DataRow row in dt.Rows)
                    {
                        //Accessing using string Key Name
                        Console.WriteLine(row["Name"] + ",  " + row["Email"] + ",  " + row["Mobile"]);
                        //Accessing using integer index position
                        //Console.WriteLine(row[0] + ",  " + row[1] + ",  " + row[2]);
                    }

                    Console.WriteLine("---------------");

                    //Using DataSet
                    DataSet ds = new DataSet();
                    da.Fill(ds, "student"); //Here, the datatable student will be stored in Index position 0
                    Console.WriteLine("Using Data Set");

                    //Tables: Gets the collection of tables contained in the System.Data.DataSet.
                    //Accessing the datatable from the dataset using the datatable name
                    foreach (DataRow row in ds.Tables["student"].Rows)
                    {
                        //Accessing the data using string Key Name
                        Console.WriteLine(row["Name"] + ",  " + row["Email"] + ",  " + row["Mobile"]);
                        //Accessing the data using integer index position
                        //Console.WriteLine(row[0] + ",  " + row[1] + ",  " + row[2]);
                    }

                    //Accessing the datatable from the dataset using the datatable index position
                    //foreach (DataRow row in ds.Tables[0].Rows)
                    //{
                    //    Console.WriteLine(row["Name"] + ",  " + row["Email"] + ",  " + row["Mobile"]);
                    //}
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("OOPs, something went wrong.\n" + e);
            }

            Console.ReadKey();
        }
    }
}
```
##### **C# SqlDataAdapter using SQL Server Stored Procedure:**

```SQL
CREATE PROCEDURE spGetStudents
AS
BEGIN
 SELECT Id, Name, Email, Mobile 
 FROM Student
END
```
```C#
using System;
using System.Data;
using System.Data.SqlClient;
namespace AdoNetConsoleApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                string ConString = "data source=.; database=StudentDB; integrated security=SSPI";
    using (SqlConnection connection = new SqlConnection(ConString))
         {
                    
           SqlDataAdapter da = new SqlDataAdapter("spGetStudents", connection);
                    da.SelectCommand.CommandType = CommandType.StoredProcedure;
                    
                    DataTable dt = new DataTable();
                    da.Fill(dt);
   foreach (DataRow row in dt.Rows)
              {
      Console.WriteLine(row["Name"] +",  " + row["Email"] + ",  " + row["Mobile"]);
                    }     
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("OOPs, something went wrong.\n" + e);
            }

            Console.ReadKey();
        }
    }
}
```
# **ADO.NET DataTable in C#**

![[word-image-104.webp]]

![[word-image-105.webp]]

1. **DataTable():** This constructor is used to initialize a new instance of the System.Data.DataTable class with no arguments.
2. **DataTable(string tableName):** It initializes a new instance of the System.Data.DataTable class with the specified table name. Here, the Parameters tableName is the name given to the table. If tableName is null or an empty string, a default name is given when added to the System.Data.DataTableCollection.
3. **DataTable(SerializationInfo info, StreamingContext context):** This constructor is used to initialize a new instance of the System.Data.DataTable class with the System.Runtime.Serialization.SerializationInfo and the System.Runtime.Serialization.StreamingContext. Here, the parameter info specifies the data needed to serialize or deserialize an object, and the parameter context specifies the source and destination of a given serialized stream.
4. **DataTable(string tableName, string tableNamespace):** It is used to initialize a new instance of the System.Data.DataTable class using the specified table name and namespace
##### **Properties of ADO.NET DataTable in C#:**
1. **Columns**: It collects the columns that belong to this table.
2. **Constraints**: t is used to get the collection of constraints maintained by this table.
3. **DataSet**: It is used to get the Data Set to which this table belongs.
4. **DefaultView**: It is used to get a customized view of the table that may include a filtered view.
5. **HasErrors**: It is used to get a value indicating whether there are errors in any of the rows in the table of the DataSet.
6. **MinimumCapacity**: It is used to get or set the initial starting size for this table.
7. **PrimaryKey**: It is used to get or set an array of columns that function as primary keys for the data table.
8. **Rows**: It is used to collect the rows that belong to this table.
9. **TableName**: It is used to get or set the name of the DataTable.

##### **Methods of C# DataTable in ADO.NET:**

1. **AcceptChanges()**: It is used to commit all the changes made to this table.
2. **Clear()**: It is used to clear the DataTable of all data.
3. **Clone()**: It is used to clone the structure of the DataTable.
4. **Copy():** It is used to copy both the structure and data of the DataTable.
5. **CreateDataReader():** It returns a DataTableReader corresponding to the data within this DataTable.
6. **CreateInstance():** It is used to create a new instance of DataTable.
7. **GetRowType():** It is used to get the row type.
8. **GetSchema()**: It is used to get the table schema.
9. **ImportRow(DataRow):** It is used to copy a DataRow into a DataTable.
10. **Load(IDataReader):** It is used to fill a DataTable with values from a data source using the supplied IDataReader.
11. **Merge(DataTable, Boolean):** It merges the specified DataTable with the current DataTable.
12. **NewRow():** It creates a new DataRow with the same schema as the table.
13. **Select()**: It is used to get an array of all DataRow objects.
14. **WriteXml(String):** It is used to write the current contents of the DataTable as XML using the specified file.


# **Step 1: Creating DataTable instance**

![[word-image-106.webp]]

##### **Step 2: Adding DataColumn and Defining Schema**
![[word-image-107.webp]]

![[word-image-108.webp]]
![[word-image-109.webp]]
![[word-image-110.webp]]
##### **Creating DataRow Objects in C#:**

![[word-image-111.webp]]
![[word-image-112.webp]]
```C#
using System;
using System.Data;
using System.Data.SqlClient;
namespace AdoNetConsoleApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                //Creating data table instance
                DataTable dataTable = new DataTable("Student");

                //Add the DataColumn using all properties
                DataColumn Id = new DataColumn("ID");
                Id.DataType = typeof(int);
                Id.Unique = true;
                Id.AllowDBNull = false;
                Id.Caption = "Student ID";
                dataTable.Columns.Add(Id);
                
                //Add the DataColumn few properties
                DataColumn Name = new DataColumn("Name");
                Name.MaxLength = 50;
                Name.AllowDBNull = false;
                dataTable.Columns.Add(Name);
                
                //Add the DataColumn using defaults
                DataColumn Email = new DataColumn("Email");
                dataTable.Columns.Add(Email);
                
                //Setting the Primary Key
                dataTable.PrimaryKey = new DataColumn[] { Id };
                
                //Add New DataRow by creating the DataRow object
                DataRow row1 = dataTable.NewRow();
                row1["Id"] = 101;
                row1["Name"] = "Anurag";
                row1["Email"] = "Anurag@dotnettutorials.net";
                dataTable.Rows.Add(row1);

                //Adding new DataRow by simply adding the values
                dataTable.Rows.Add(102, "Mohanty", "Mohanty@dotnettutorials.net");

                foreach (DataRow row in dataTable.Rows)
                {
                    Console.WriteLine(row["Id"] + ",  " + row["Name"] + ",  " + row["Email"]);
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("OOPs, something went wrong.\n" + e);
            }

            Console.ReadKey();
        }
    }
}
```
##### **DataColumn Properties**
1. **AllowDBNull**: This property is used to get or set a value indicating whether the column will accept null values.
2. **Autoincrement**: This property is used when you want to increment the column values automatically.
3. **AutoincrementSeed**: This property is used to get or set the starting value for the auto-incremented column.
4. **AutoincrementStep**: This property is used to get or set the increment used by a column with its Autoincrement property set to true.
5. **Caption**: his property is used to get or set the caption for the column.
6. **ColumnName**: This property is used to get or set the name of the column.
7. **Expression**: This property is used to get or set the expression to filter rows, calculate the values in a column, or create an aggregate column.
8. **MaxLength**: This property is used to get or set the maximum length of a text column.
9. **Unique**: This property is used to get or set a value that indicates whether the values in each row of the column must be unique.

##### **Example to Understand Autoincrement Column in C#:**

```
	using System;
using System.Data;
namespace AdoNetConsoleApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                //Creating data table instance
                DataTable dataTable = new DataTable("Student");
                
                DataColumn Id = new DataColumn
                {
                    ColumnName = "Id",
                    DataType = System.Type.GetType("System.Int32"),
                    AutoIncrement = true,
                    AutoIncrementSeed = 1000,
                    AutoIncrementStep = 10
                };

                dataTable.Columns.Add(Id);
                

                //Add the DataColumn few properties
                DataColumn Name = new DataColumn("Name");
                Name.MaxLength = 50;
                Name.AllowDBNull = false;
                dataTable.Columns.Add(Name);
                
                //Add the DataColumn using defaults
                DataColumn Email = new DataColumn("Email");
                dataTable.Columns.Add(Email);
                
                //Add New DataRow by creating the DataRow object
                DataRow row1 = dataTable.NewRow();
                
                row1["Name"] = "Anurag";
                row1["Email"] = "Anurag@dotnettutorials.net";
                dataTable.Rows.Add(row1);

               
                //Adding new DataRow by simply adding the values
                //Supply null for auto increment column
                dataTable.Rows.Add(null, "Mohanty", "Mohanty@dotnettutorials.net");

                foreach (DataRow row in dataTable.Rows)
                {
                    Console.WriteLine(row["Id"] + ",  " + row["Name"] + ",  " + row["Email"]);
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("OOPs, something went wrong.\n" + e);
            }

            Console.ReadKey();
        }
    }
}
```


## **DataTable Methods in C#**

```SQL
	CREATE DATABASE StudentDB;
GO

USE StudentDB;
GO

CREATE TABLE Student(
 Id INT PRIMARY KEY,
 Name VARCHAR(100),
 Email VARCHAR(50),
 Mobile VARCHAR(50)
)
GO

INSERT INTO Student VALUES (101, 'Anurag', 'Anurag@dotnettutorial.net', '1234567890')
INSERT INTO Student VALUES (102, 'Priyanka', 'Priyanka@dotnettutorial.net', '2233445566')
INSERT INTO Student VALUES (103, 'Preety', 'Preety@dotnettutorial.net', '6655443322')
INSERT INTO Student VALUES (104, 'Sambit', 'Sambit@dotnettutorial.net', '9876543210')
GO
```

```C#
using System;
using System.Data;
using System.Data.SqlClient;

namespace AdoNetConsoleApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                string ConnectionString = "data source=.; database=StudentDB; integrated security=SSPI";
                using (SqlConnection connection = new SqlConnection(ConnectionString))
                {
                    SqlDataAdapter da = new SqlDataAdapter("select * from student", connection);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    
                    foreach (DataRow row in dt.Rows)
                    {
                        Console.WriteLine(row["Name"] + ",  " + row["Email"] + ",  " + row["Mobile"]);
                    }
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("OOPs, something went wrong.\n" + e);
            }

            Console.ReadKey();
        }
    }
}
```

## **Copying and Cloning the DataTable in C#:**
``` C#
using System;
using System.Data;
using System.Data.SqlClient;

namespace AdoNetConsoleApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                string ConnectionString = "data source=.; database=StudentDB; integrated security=SSPI";
                using (SqlConnection connection = new SqlConnection(ConnectionString))
                {
                    SqlDataAdapter da = new SqlDataAdapter("select * from student", connection);
                    DataTable originalDataTable = new DataTable();
                    da.Fill(originalDataTable);
                    Console.WriteLine("Original Data Table : originalDataTable");
                    foreach (DataRow row in originalDataTable.Rows)
                    {
                        Console.WriteLine(row["Name"] + ",  " + row["Email"] + ",  " + row["Mobile"]);
                    }
                    Console.WriteLine();
                    Console.WriteLine("Copy Data Table : copyDataTable");
                    DataTable copyDataTable = originalDataTable.Copy();
                    if (copyDataTable != null)
                    {
                        foreach (DataRow row in copyDataTable.Rows)
                        {
                            Console.WriteLine(row["Name"] + ",  " + row["Email"] + ",  " + row["Mobile"]);
                        }
                    }

                    Console.WriteLine();
                    Console.WriteLine("Clone Data Table : cloneDataTable");
                    DataTable cloneDataTable = originalDataTable.Clone();
                    if (cloneDataTable.Rows.Count > 0)
                    {
                        foreach (DataRow row in cloneDataTable.Rows)
                        {
                            Console.WriteLine(row["Name"] + ",  " + row["Email"] + ",  " + row["Mobile"]);
                        }
                    }
                    else
                    {
                        Console.WriteLine("cloneDataTable is Empty");
                        Console.WriteLine("Adding Data to cloneDataTable");
                        cloneDataTable.Rows.Add(101, "Test1", "Test1@dotnettutorial.net", "1234567890");
                        cloneDataTable.Rows.Add(101, "Test2", "Test1@dotnettutorial.net", "1234567890");

                        foreach (DataRow row in cloneDataTable.Rows)
                        {
                            Console.WriteLine(row["Name"] + ",  " + row["Email"] + ",  " + row["Mobile"]);
                        }
                    }
                    
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("OOPs, something went wrong.\n" + e);
            }

            Console.ReadKey();
        }
    }
}
```

##### **Delete Method Example:**

```C#
using System;
using System.Data;
using System.Data.SqlClient;

namespace AdoNetConsoleApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                string ConnectionString = "data source=.; database=StudentDB; integrated security=SSPI";
                using (SqlConnection connection = new SqlConnection(ConnectionString))
                {
                    SqlDataAdapter da = new SqlDataAdapter("select * from student", connection);
                    DataTable originalDataTable = new DataTable();
                    da.Fill(originalDataTable);

                    Console.WriteLine("Before Deletion");
                    foreach (DataRow row in originalDataTable.Rows)
                    {
                        Console.WriteLine(row["Name"] + ",  " + row["Email"] + ",  " + row["Mobile"]);
                    }

                    Console.WriteLine();
                    foreach (DataRow row in originalDataTable.Rows)
                    {
                        if (Convert.ToInt32(row["Id"]) == 101)
                        {
                            row.Delete();
                            Console.WriteLine("Row with Id 101 Deleted");
                        }
                    }
                    originalDataTable.AcceptChanges();

                    Console.WriteLine();
                    Console.WriteLine("After Deletion");
                    foreach (DataRow row in originalDataTable.Rows)
                    {
                        Console.WriteLine(row["Name"] + ",  " + row["Email"] + ",  " + row["Mobile"]);
                    }
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("OOPs, something went wrong.\n" + e);
            }

            Console.ReadKey();
        }
    }
}
```
##### **Remove method**

```C#
using System;
using System.Data;
using System.Data.SqlClient;

namespace AdoNetConsoleApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                string ConnectionString = "data source=.; database=StudentDB; integrated security=SSPI";
                using (SqlConnection connection = new SqlConnection(ConnectionString))
                {
                    SqlDataAdapter da = new SqlDataAdapter("select * from student", connection);
                    DataTable originalDataTable = new DataTable();
                    da.Fill(originalDataTable);

                    Console.WriteLine("Before Deletion");
                    foreach (DataRow row in originalDataTable.Rows)
                    {
                        Console.WriteLine(row["Name"] + ",  " + row["Email"] + ",  " + row["Mobile"]);
                    }

                    Console.WriteLine();
                    foreach (DataRow row in originalDataTable.Select())
                    {
                        if (Convert.ToInt32(row["Id"]) == 101)
                        {
                            originalDataTable.Rows.Remove(row);
                            Console.WriteLine("Row with Id 101 Deleted");
                        }
                    }
                    
                    Console.WriteLine();
                    Console.WriteLine("After Deletion");
                    foreach (DataRow row in originalDataTable.Rows)
                    {
                        Console.WriteLine(row["Name"] + ",  " + row["Email"] + ",  " + row["Mobile"]);
                    }
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("OOPs, something went wrong.\n" + e);
            }

            Console.ReadKey();
        }
    }
}
```

##### **RejectChanges Method**
```C#
using System;
using System.Data;
using System.Data.SqlClient;

namespace AdoNetConsoleApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                string ConnectionString = "data source=.; database=StudentDB; integrated security=SSPI";
                using (SqlConnection connection = new SqlConnection(ConnectionString))
                {
                    SqlDataAdapter da = new SqlDataAdapter("select * from student", connection);
                    DataTable originalDataTable = new DataTable();
                    da.Fill(originalDataTable);

                    Console.WriteLine("Before Deletion");
                    foreach (DataRow row in originalDataTable.Rows)
                    {
                        Console.WriteLine(row["Name"] + ",  " + row["Email"] + ",  " + row["Mobile"]);
                    }

                    Console.WriteLine();
                    foreach (DataRow row in originalDataTable.Rows)
                    {
                        if (Convert.ToInt32(row["Id"]) == 101)
                        {
                            row.Delete();
                            Console.WriteLine("Row with Id 101 Deleted");
                        }
                    }
                    
                    //Rollbacking the Data
                    originalDataTable.RejectChanges();
                    Console.WriteLine();
                    Console.WriteLine("Rollbacking the Changes");
                    foreach (DataRow row in originalDataTable.Rows)
                    {
                        Console.WriteLine(row["Name"] + ",  " + row["Email"] + ",  " + row["Mobile"]);
                    }
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("OOPs, something went wrong.\n" + e);
            }

            Console.ReadKey();
        }
    }
}
```

## **ADO.NET DataSet in C#**

The DataSet represents a subset of the database in memory. That means the ADO.NET DataSet is a collection of tables containing relational data in memory in tabular format.

It does not require a continuous open or active connection to the database. The DataSet is based on the disconnected architecture. This is the reason why it is used to fetch the data without interacting with any data source. We will discuss the disconnected architecture of the data set in our upcoming articles.

**Note:** The ADO.NET DataSet class is the core component for providing data access in a distributed and disconnected environment. The ADO.NET DataSet class belongs to the **System.Data** namespace.

##### **Signature of DataSet in C#:**

![[word-image-151.webp]]

##### **Creating Customers Data Table:**
![[word-image-152.webp]]

##### **Creating Orders Data Table:**
![[word-image-153.webp]]

##### **Creating DataSet with DataTable:**
![[word-image-154.webp]]

##### **Fetching DataTable from DataSet using index position:**
![[word-image-155.webp]]

##### **Fetching DataTable From DataSet using Name:**
![[word-image-156.webp]]
```C#
using System;
using System.Data;
namespace AdoNetConsoleApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                // Creating Customer Data Table
                DataTable Customer = new DataTable("Customer");

                // Adding Data Columns to the Customer Data Table
                DataColumn CustomerId = new DataColumn("ID", typeof(Int32));
                Customer.Columns.Add(CustomerId);
                DataColumn CustomerName = new DataColumn("Name", typeof(string));
                Customer.Columns.Add(CustomerName);
                DataColumn CustomerMobile = new DataColumn("Mobile", typeof(string));
                Customer.Columns.Add(CustomerMobile);

                //Adding Data Rows into Customer Data Table
                Customer.Rows.Add(101, "Anurag", "2233445566");
                Customer.Rows.Add(202, "Manoj", "1234567890");

                // Creating Orders Data Table
                DataTable Orders = new DataTable("Orders");

                // Adding Data Columns to the Orders Data Table
                DataColumn OrderId = new DataColumn("ID", typeof(System.Int32));
                Orders.Columns.Add(OrderId);
                DataColumn CustId = new DataColumn("CustomerId", typeof(Int32));
                Orders.Columns.Add(CustId);
                DataColumn OrderAmount = new DataColumn("Amount", typeof(int));
                Orders.Columns.Add(OrderAmount);

                //Adding Data Rows into Orders Data Table
                Orders.Rows.Add(10001, 101, 20000);
                Orders.Rows.Add(10002, 102, 30000);

                //Creating DataSet Object
                DataSet dataSet = new DataSet();

                //Adding DataTables into DataSet
                dataSet.Tables.Add(Customer);
                dataSet.Tables.Add(Orders);

                //Fetching Customer Data Table Data
                Console.WriteLine("Customer Table Data: ");
                //Fetching DataTable from Dataset using the Index position
                foreach (DataRow row in dataSet.Tables[0].Rows)
                {
                    //Accessing the data using string column name
                    Console.WriteLine(row["ID"] + ",  " + row["Name"] + ",  " + row["Mobile"]);

                    //Accessing the data using integer index position
                    //Console.WriteLine(row[0] + ",  " + row[1] + ",  " + row[2]);
                }

                Console.WriteLine();

                //Fetching Orders Data Table Data
                Console.WriteLine("Orders Table Data: ");

                //Fetching DataTable from the DataSet using the table name
                foreach (DataRow row in dataSet.Tables["Orders"].Rows)
                {
                    //Accessing the data using string column name
                    Console.WriteLine(row["ID"] + ",  " + row["CustomerId"] + ",  " + row["Amount"]);

                    //Accessing the data using integer index position
                    //Console.WriteLine(row[0] + ",  " + row[1] + ",  " + row[2]);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Exception Occurred: {ex.Message}");
            }
            Console.ReadKey();
        }
    }
}

```

##### **Constructors of DataSet in C#:**

![[word-image-158.webp]]

1. **DataSet():** It initializes a new instance of the System.Data.DataSet class..
2. **DataSet(string dataSetName):** It initializes a new instance of a System.Data.DataSet class with the given name. Here, the string parameter dataSetName specifies the name of the System.Data.DataSet.
3. **DataSet(SerializationInfo info, StreamingContext context):** It initializes a new instance of a System.Data.DataSet class that has the given serialization information and context. The parameter info is the data needed to serialize or deserialize an object. The context specifies the source and destination of a given serialized stream.
4. **DataSet(SerializationInfo info, StreamingContext context, bool ConstructSchema):** It initializes a new instance of the System.Data.DataSet class.
##### **Properties of DataSet in C#:**

The DataSet class provides the following properties.

1. **CaseSensitive**: It is used to get or set a value indicating whether string comparisons within System.Data.DataTable objects are case-sensitive. It returns true if string comparisons are case-sensitive; otherwise, it is false. The default is false.
2. **DefaultViewManager**: It is used to get a custom view of the data contained in the System.Data.DataSet to allow filtering, searching, and navigating using a custom System.Data.DataViewManager.
3. **DataSetName**: It is used to get or set the name of the current System.Data.DataSet.
4. **EnforceConstraints**: It is used to get or set a value indicating whether constraint rules are followed when attempting any update operation.
5. **HasErrors**: It is used to get a value indicating whether there are errors in any of the System.Data.DataTable objects within this System.Data.DataSet.
6. **IsInitialized**: It is used to get a value that indicates whether the System.Data.DataSet is initialized. It returns true to indicate the component has completed initialization; otherwise, it is false.
7. **Prefix**: It is used to get or set an XML prefix that aliases the namespace of the System.Data.DataSet.
8. **Locale**: It is used to get or set the locale information used to compare strings within the table.
9. **Namespace**: It is used to get or set the namespace of the System.Data.DataSet.
10. **Site**: It is used to get or set up a System.ComponentModel.ISite for the System.Data.DataSet.
11. **Relations**: It is used to get the collection of relations that link tables and allow navigation from parent tables to child tables.
12. **Tables**: It is used to get the collection of tables contained in the System.Data.DataSet.


##### **Methods of ADO.NET DataSet Class:**

1. **BeginInit():** It Begins the initialization of a System.Data.DataSet that is used on a form or used by another component. The initialization occurs at run time.
2. **Clear():** It Clears the System.Data.DataSet of any data by removing all rows in all tables.
3. **Clone():** It Copies the structure of the System.Data.DataSet, including all System.Data.DataTable schemas, relations, and constraints. Do not copy any data.
4. **Copy():** It Copies both the structure and data for this System.Data.DataSet.
5. **CreateDataReader():** It Returns a System.Data.DataTableReader with one result set per System.Data.DataTable appears in the System in the same sequence as the tables.Data.DataSet.Tables collection.
6. **CreateDataReader(params DataTable[] dataTables):** It returns a System.Data.DataTableReader with one result set per System.Data.DataTable. Here, the parameter dataTables specifies an array of DataTables providing the order of the result sets to be returned in the System.Data.DataTableReader
7. **EndInit():** It Ends the initialization of a System.Data.DataSet that is used on a form or used by another component. The initialization occurs at run time.
8. **GetXml():** It Returns the XML representation of the data stored in the System.Data.DataSet.
9. **GetXmlSchema():** It Returns the XML Schema for the XML representation of the data stored in the System.Data.DataSet.


### Some Example of DataSet

``` SQL
CREATE DATABASE ShoppingCartDB;
GO

USE ShoppingCartDB;
GO

CREATE TABLE Customers(
 ID INT PRIMARY KEY,
 Name VARCHAR(100),
 Mobile VARCHAR(50)
)
GO

INSERT INTO Customers VALUES (101, 'Anurag', '1234567890')
INSERT INTO Customers VALUES (102, 'Priyanka', '2233445566')
INSERT INTO Customers VALUES (103, 'Preety', '6655443322')
GO

CREATE TABLE Orders(
 ID INT PRIMARY KEY,
 CustomerId INT,
 Amount INT
)
GO

INSERT INTO Orders VALUES (10011, 103, 20000)
INSERT INTO Orders VALUES (10012, 101, 30000)
INSERT INTO Orders VALUES (10013, 102, 25000)
GO
```

```C#
using System;
using System.Data;
using System.Data.SqlClient;

namespace AdoNetConsoleApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                string ConnectionString = @"data source=LAPTOP-ICA2LCQL\SQLEXPRESS; database=ShoppingCartDB; integrated security=SSPI";
                using (SqlConnection connection = new SqlConnection(ConnectionString))
                {
                    //Create the SqlDataAdapter instance by specifying the command text and connection object
                    SqlDataAdapter dataAdapter = new SqlDataAdapter("select * from customers", connection);

                    //Creating DataSet Object
                    DataSet dataSet = new DataSet();

                    //Filling the DataSet using the Fill Method of SqlDataAdapter object
                    //Here, we have not specified the data table name and the data table will be created at index position 0
                    dataAdapter.Fill(dataSet); 

                    //Iterating through the DataSet 
                    //First fetch the Datatable from the dataset and then fetch the rows using the Rows property of Datatable
                    foreach (DataRow row in dataSet.Tables[0].Rows)
                    {
                        //Accessing the Data using the string column name as key
                        Console.WriteLine(row["Id"] + ",  " + row["Name"] + ",  " + row["Mobile"]);

                        //Accessing the Data using the integer index position as key
                        //Console.WriteLine(row["Id"] + ",  " + row["Name"] + ",  " + row["Mobile"]);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Exception Occurred: {ex.Message}");
            }
            Console.ReadKey();
        }
    }
}
```


![[word-image-161.webp]]

**Accessing Data table from DataSet Using Integral Index Position in C#:**
```C#
using System;
using System.Data;
using System.Data.SqlClient;
namespace AdoNetConsoleApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                string ConnectionString = @"data source=LAPTOP-ICA2LCQL\SQLEXPRESS; database=ShoppingCartDB; integrated security=SSPI";
                using (SqlConnection connection = new SqlConnection(ConnectionString))
                {
                    //We have written two Select Statements to return data from customers and orders table
                    SqlDataAdapter dataAdapter = new SqlDataAdapter("select * from customers; select * from orders", connection);
                    DataSet dataSet = new DataSet();
                    //Data Table 1 will be customers data which is at Index Position 0
                    //Data Table 2 will be orders data which is at Index Position 1
                    dataAdapter.Fill(dataSet);

                    // Fetching First Table Data i.e. Customers Data
                    Console.WriteLine("Table 1 Data");
                    //Accessing the Data Table from the DataSet using Integer Index Position
                    foreach (DataRow row in dataSet.Tables[0].Rows)
                    {
                        //Accessing using string column name as keys
                        Console.WriteLine(row["Id"] + ",  " + row["Name"] + ",  " + row["Mobile"]);

                        //Accessing using integer index position as keys
                        //Console.WriteLine(row[0] + ",  " + row[1] + ",  " + row[2]);
                    }
                    Console.WriteLine();

                    // Fetching Second Table Data i.e. Orders Data
                    Console.WriteLine("Table 2 Data");
                    //Accessing the Data Table from the DataSet using Integer Index Position
                    foreach (DataRow row in dataSet.Tables[1].Rows)
                    {
                        //Accessing using string column name as keys
                        //Console.WriteLine(row["Id"] + ",  " + row["CustomerId"] + ",  " + row["Amount"]);

                        //Accessing using integer index position as keys
                        Console.WriteLine(row[0] + ",  " + row[1] + ",  " + row[2]);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Exception Occurred: {ex.Message}");
            }
            Console.ReadKey();
        }
    }
}
```


**Accessing Data table from DataSet Using Default Table Name in C#:**

```C#
using System;
using System.Data;
using System.Data.SqlClient;
namespace AdoNetConsoleApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                string ConnectionString = @"data source=LAPTOP-ICA2LCQL\SQLEXPRESS; database=ShoppingCartDB; integrated security=SSPI";
                using (SqlConnection connection = new SqlConnection(ConnectionString))
                {
                    //We have written two Select Statements to return data from customers and orders table
                    SqlDataAdapter dataAdapter = new SqlDataAdapter("select * from customers; select * from orders", connection);
                    DataSet dataSet = new DataSet();
                    //Data Table 1 will be customers data which is at Index Position 0
                    //Data Table 2 will be orders data which is at Index Position 1
                    dataAdapter.Fill(dataSet);

                    // Fetching First Table Data i.e. Customers Data
                    Console.WriteLine("Table 1 Data");
                    //Accessing the Data Table from the DataSet using Default Table name
                    //By Default, first table name is Table
                    foreach (DataRow row in dataSet.Tables["Table"].Rows)
                    {
                        //Accessing using string column name as keys
                        Console.WriteLine(row["Id"] + ",  " + row["Name"] + ",  " + row["Mobile"]);

                        //Accessing using integer index position as keys
                        //Console.WriteLine(row[0] + ",  " + row[1] + ",  " + row[2]);
                    }
                    Console.WriteLine();

                    // Fetching Second Table Data i.e. Orders Data
                    Console.WriteLine("Table 2 Data");
                    //Accessing the Data Table from the DataSet using Default Table name
                    //By Default, second table name is Table1
                    foreach (DataRow row in dataSet.Tables["Table1"].Rows)
                    {
                        //Accessing using string column name as keys
                        //Console.WriteLine(row["Id"] + ",  " + row["CustomerId"] + ",  " + row["Amount"]);

                        //Accessing using integer index position as keys
                        Console.WriteLine(row[0] + ",  " + row[1] + ",  " + row[2]);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Exception Occurred: {ex.Message}");
            }
            Console.ReadKey();
        }
    }
}
```

##### **How to Set the Data Table name Explicitly in ADO.NET DataSet?**

![[word-image-163.webp]]

```C#
using System;
using System.Data;
using System.Data.SqlClient;
namespace AdoNetConsoleApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                string ConnectionString = @"data source=LAPTOP-ICA2LCQL\SQLEXPRESS; database=ShoppingCartDB; integrated security=SSPI";
                using (SqlConnection connection = new SqlConnection(ConnectionString))
                {
                    //We have written two Select Statements to return data from customers and orders table
                    SqlDataAdapter dataAdapter = new SqlDataAdapter("select * from customers; select * from orders", connection);
                    DataSet dataSet = new DataSet();
                    //Data Table 1 will be customers data which is at Index Position 0
                    //Data Table 2 will be orders data which is at Index Position 1
                    dataAdapter.Fill(dataSet);

                    dataSet.Tables[0].TableName = "Customers";
                    dataSet.Tables[1].TableName = "Orders";

                    // Fetching First Table Data i.e. Customers Data
                    Console.WriteLine("Table 1 Data");
                    //Accessing the Data Table from the DataSet using the Custom Table name
                    foreach (DataRow row in dataSet.Tables["Customers"].Rows)
                    {
                        //Accessing using string column name as keys
                        Console.WriteLine(row["Id"] + ",  " + row["Name"] + ",  " + row["Mobile"]);

                        //Accessing using integer index position as keys
                        //Console.WriteLine(row[0] + ",  " + row[1] + ",  " + row[2]);
                    }
                    Console.WriteLine();

                    // Fetching Second Table Data i.e. Orders Data
                    Console.WriteLine("Table 2 Data");
                    //Accessing the Data Table from the DataSet using the Custom Table name
                    foreach (DataRow row in dataSet.Tables["Orders"].Rows)
                    {
                        //Accessing using string column name as keys
                        //Console.WriteLine(row["Id"] + ",  " + row["CustomerId"] + ",  " + row["Amount"]);

                        //Accessing using integer index position as keys
                        Console.WriteLine(row[0] + ",  " + row[1] + ",  " + row[2]);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Exception Occurred: {ex.Message}");
            }
            Console.ReadKey();
        }
    }
}
```
##### **Example to understand Copy, Clone, and Clear Methods of DataSet Object in C#:**

```C# using System;
using System.Data;
using System.Data.SqlClient;

namespace AdoNetConsoleApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                string ConnectionString = @"data source=LAPTOP-ICA2LCQL\SQLEXPRESS; database=StudentDB; integrated security=SSPI";
                using (SqlConnection connection = new SqlConnection(ConnectionString))
                {
                    SqlDataAdapter da = new SqlDataAdapter("select * from student", connection);
                    DataSet originalDataSet = new DataSet();
                    da.Fill(originalDataSet);

                    Console.WriteLine("Original Data Set:");
                    foreach (DataRow row in originalDataSet.Tables[0].Rows)
                    {
                        Console.WriteLine(row["Name"] + ",  " + row["Email"] + ",  " + row["Mobile"]);
                    }
                    Console.WriteLine();

                    Console.WriteLine("Copy Data Set:");
                    //Copies both the structure and data for this System.Data.DataSet.
                    DataSet copyDataSet = originalDataSet.Copy();
                    if (copyDataSet.Tables != null)
                    {
                        foreach (DataRow row in copyDataSet.Tables[0].Rows)
                        {
                            Console.WriteLine(row["Name"] + ",  " + row["Email"] + ",  " + row["Mobile"]);
                        }
                    }
                    Console.WriteLine();

                    Console.WriteLine("Clone Data Set");
                    // Copies the structure of the DataSet, including all DataTable
                    // schemas, relations, and constraints. Does not copy any data.
                    DataSet cloneDataSet = originalDataSet.Clone();
                    if (cloneDataSet.Tables[0].Rows.Count > 0)
                    {
                        foreach (DataRow row in cloneDataSet.Tables[0].Rows)
                        {
                            Console.WriteLine(row["Name"] + ",  " + row["Email"] + ",  " + row["Mobile"]);
                        }
                    }
                    else
                    {
                        Console.WriteLine("Clone Data Set is Empty");
                        Console.WriteLine("Adding Data to Clone Data Set Table");
                        cloneDataSet.Tables[0].Rows.Add(101, "Test1", "Test1@dotnettutorial.net", "1234567890");
                        cloneDataSet.Tables[0].Rows.Add(101, "Test2", "Test1@dotnettutorial.net", "1234567890");

                        foreach (DataRow row in cloneDataSet.Tables[0].Rows)
                        {
                            Console.WriteLine(row["Name"] + ",  " + row["Email"] + ",  " + row["Mobile"]);
                        }
                    }

                    Console.WriteLine();
                    //Clears the DataSet of any data by removing all rows in all tables.
                    copyDataSet.Clear();
                    if(copyDataSet.Tables[0].Rows.Count > 0)
                    {
                        foreach (DataRow row in copyDataSet.Tables[0].Rows)
                        {
                            Console.WriteLine(row["Name"] + ",  " + row["Email"] + ",  " + row["Mobile"]);
                        }
                    }
                    else
                    {
                        Console.WriteLine("After Clear No Data is Their...");
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Exception Occurred: {ex.Message}");
            }

            Console.ReadKey();
        }
    }
}

```

##### **Example to Remove a DataTable from a Dataset in C#:**

```C#
using System;
using System.Data;
using System.Data.SqlClient;
namespace AdoNetConsoleApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                string ConnectionString = @"data source=LAPTOP-ICA2LCQL\SQLEXPRESS; database=ShoppingCartDB; integrated security=SSPI";
                using (SqlConnection connection = new SqlConnection(ConnectionString))
                {
                    //We have written two Select Statements to return data from customers and orders table
                    SqlDataAdapter dataAdapter = new SqlDataAdapter("select * from customers; select * from orders", connection);
                    DataSet dataSet = new DataSet();
                    //Data Table 1 will be customers data which is at Index Position 0
                    //Data Table 2 will be orders data which is at Index Position 1
                    dataAdapter.Fill(dataSet);

                    dataSet.Tables[0].TableName = "Customers";
                    dataSet.Tables[1].TableName = "Orders";

                    // Fetching First Table Data i.e. Customers Data
                    Console.WriteLine("Customers Data");
                    //Accessing the Data Table from the DataSet using the Custom Table name
                    foreach (DataRow row in dataSet.Tables["Customers"].Rows)
                    {
                        //Accessing using string column name as keys
                        Console.WriteLine(row["Id"] + ",  " + row["Name"] + ",  " + row["Mobile"]);
                    }
                    Console.WriteLine();

                    // Fetching Second Table Data i.e. Orders Data
                    Console.WriteLine("Orders Data");
                    //Accessing the Data Table from the DataSet using the Custom Table name
                    foreach (DataRow row in dataSet.Tables["Orders"].Rows)
                    {
                        //Accessing using integer index position as keys
                        Console.WriteLine(row[0] + ",  " + row[1] + ",  " + row[2]);
                    }

                    Console.WriteLine();
                    //Now, we want to delete the Orders data table from the DataSet
                    if (dataSet.Tables.Contains("Orders") && dataSet.Tables.CanRemove(dataSet.Tables["Orders"]))
                    {
                        Console.WriteLine("Deleting Orders Data Table..");
                        dataSet.Tables.Remove(dataSet.Tables["Orders"]);
                        //dataSet.Tables.Remove(dataSet.Tables[1]);
                    }

                    //Now check whether the DataTable exists or not
                    if (dataSet.Tables.Contains("Orders"))
                    {
                        Console.WriteLine("Orders Data Table Exits");
                    }
                    else
                    {
                        Console.WriteLine("Orders Data Table Not Exits Anymore");
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Exception Occurred: {ex.Message}");
            }
            Console.ReadKey();
        }
    }
}

```


## **ADO.NET Using Stored Procedures in C#**

```SQL
CREATE DATABASE StudentDB;
GO

USE StudentDB;
GO

CREATE TABLE Student(
 [Id] [int] IDENTITY(100,1) PRIMARY KEY,
 [Name] [varchar](100) NULL,
 [Email] [varchar](50) NULL,
 [Mobile] [varchar](50) NULL,
)
GO

INSERT INTO Student VALUES ('Anurag','Anurag@dotnettutorial.net','1234567890')
INSERT INTO Student VALUES ('Priyanka','Priyanka@dotnettutorial.net','2233445566')
INSERT INTO Student VALUES ('Preety','Preety@dotnettutorial.net','6655443322')
INSERT INTO Student VALUES ('Sambit','Sambit@dotnettutorial.net','9876543210')
```

```SQL
CREATE PROCEDURE spGetStudents
AS
BEGIN
     SELECT Id, Name, Email, Mobile
     FROM Student
END
```

![[word-image-148.webp]]

![[word-image-149.webp]]

```C#
using System;
using System.Data;
using System.Data.SqlClient;

namespace ADOUsingStoredProcedure
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                //Store the connection string in the ConnectionString variable
                string ConnectionString = @"data source=LAPTOP-ICA2LCQL\SQLEXPRESS; database=StudentDB; integrated security=SSPI";

                //Create the SqlConnection object
                using (SqlConnection connection = new SqlConnection(ConnectionString))
                {
                    //Create the SqlCommand object by passing the stored procedure name and connection object as parameters
                    SqlCommand cmd = new SqlCommand("spGetStudents", connection)
                    {
                        //Specify the command type as Stored Procedure
                        CommandType = CommandType.StoredProcedure
                    };

                    //Open the Connection
                    connection.Open();

                    //Execute the command i.e. Executing the Stored Procedure using ExecuteReader method
                    //SqlDataReader requires an active and open connection
                    SqlDataReader sdr = cmd.ExecuteReader();

                    //Read the data from the SqlDataReader 
                    //Read() method will returns true as long as data is there in the SqlDataReader
                    while (sdr.Read())
                    {
                        //Accessing the data using the string key as index
                        Console.WriteLine(sdr["Id"] + ",  " + sdr["Name"] + ",  " + sdr["Email"] + ",  " + sdr["Mobile"]);

                        //Accessing the data using the integer index position as key
                        //Console.WriteLine(sdr[0] + ",  " + sdr[1] + ",  " + sdr[2] + ",  " + sdr[3]);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Exception Occurred: {ex.Message}");
            }
            Console.ReadKey();
        }
    }
}
```

```SQL
CREATE PROCEDURE spGetStudentById
(
   @Id INT
)
AS
BEGIN
     SELECT Id, Name, Email, Mobile
     FROM Student
     WHERE Id = @Id
END
```
![[word-image-151 1.webp]]

##### **Understand How to Call a Stored Procedure with Input Parameter in C#:**

```C#
using System;
using System.Data;
using System.Data.SqlClient;

namespace ADOUsingStoredProcedure
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                //Store the connection string in the ConnectionString variable
                string ConnectionString = @"data source=LAPTOP-ICA2LCQL\SQLEXPRESS; database=StudentDB; integrated security=SSPI";

                //Create the SqlConnection object
                using (SqlConnection connection = new SqlConnection(ConnectionString))
                {
                    //Create the SqlCommand object
                    SqlCommand cmd = new SqlCommand()
                    {
                        CommandText = "spGetStudentById", //Specify the Stored procedure name
                        Connection = connection, //Specify the connection object where the stored procedure is going to execute
                        CommandType = CommandType.StoredProcedure //Specify the command type as Stored Procedure
                    };

                    //Create an instance of SqlParameter
                    SqlParameter param1 = new SqlParameter
                    {
                        ParameterName = "@Id", //Parameter name defined in stored procedure
                        SqlDbType = SqlDbType.Int, //Data Type of Parameter
                        Value = 101, //Value passes to the paramtere
                        Direction = ParameterDirection.Input //Specify the parameter as input
                    };

                    //Add the parameter to the Parameters property of SqlCommand object
                    cmd.Parameters.Add(param1);

                    //Open the Connection
                    connection.Open();

                    //Execute the command i.e. Executing the Stored Procedure using ExecuteReader method
                    //SqlDataReader requires an active and open connection
                    SqlDataReader sdr = cmd.ExecuteReader();

                    //Read the data from the SqlDataReader 
                    //Read() method will returns true as long as data is there in the SqlDataReader
                    while (sdr.Read())
                    {
                        //Accessing the data using the string key as index
                        Console.WriteLine(sdr["Id"] + ",  " + sdr["Name"] + ",  " + sdr["Email"] + ",  " + sdr["Mobile"]);

                        //Accessing the data using the integer index position as key
                        //Console.WriteLine(sdr[0] + ",  " + sdr[1] + ",  " + sdr[2] + ",  " + sdr[3]);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Exception Occurred: {ex.Message}");
            }
            Console.ReadKey();
        }
    }
}
```

```SQL
CREATE PROCEDURE spCreateStudent
(
    @Name VARCHAR(100),
    @Email VARCHAR(50),
    @Mobile VARCHAR(50),
    @Id int Out  
)
AS
BEGIN
     INSERT INTO Student VALUES (@Name,@Email,@Mobile)
     SELECT @Id = SCOPE_IDENTITY()  
END
```

![[word-image-153 1.webp]]




```SQL
CREATE DATABASE EmployeeDB;
GO

USE EmployeeDB;
GO

CREATE TABLE Employee(
 Id INT IDENTITY(1000,1) PRIMARY KEY,
 Name VARCHAR(100),
 Email VARCHAR(50),
 Mobile VARCHAR(50),
 Age INT,
 Department VARCHAR(50)
)
GO

INSERT INTO Employee VALUES ('Anurag','Anurag@dotnettutorial.net','1234567890', 25, 'IT')
INSERT INTO Employee VALUES ('Priyanka','Priyanka@dotnettutorial.net','2233445566', 35, 'IT')
INSERT INTO Employee VALUES ('Preety','Preety@dotnettutorial.net','6655443322', 35, 'IT')
INSERT INTO Employee VALUES ('Sambit','Sambit@dotnettutorial.net','9876543210', 25, 'IT')
INSERT INTO Employee VALUES ('Pranaya','Pranaya@dotnettutorial.net','1234567890', 25, 'HR')
INSERT INTO Employee VALUES ('Pratik','Pratik@dotnettutorial.net','2233445566', 35, 'HR')
INSERT INTO Employee VALUES ('Santosh','Santosh@dotnettutorial.net','6655443322', 32, 'HR')
INSERT INTO Employee VALUES ('Rakesh','Rakesh@dotnettutorial.net','9876543210', 27, 'HR')
GO

```

##### **Create SQL Server Stored Procedure with Input Parameters:**

```SqL
CREATE PROCEDURE spGetEmployeesByAgeDept
(
   @Age INT,
   @Dept VARCHAR(50)
)
AS
BEGIN
     SELECT Id, Name, Email, Mobile, Age, Department
     FROM Employee
     WHERE Age = @Age AND Department = @Dept
END

```

```C#
using System;
using System.Data;
using System.Data.SqlClient;

namespace ADOUsingStoredProcedure
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                //Store the connection string in the ConnectionString variable
                string ConnectionString = @"data source=LAPTOP-ICA2LCQL\SQLEXPRESS; database=EmployeeDB; integrated security=SSPI";

                //Creating the connection object using the ConnectionString
                using (SqlConnection connection = new SqlConnection(ConnectionString))
                {
                    //Creating DataSet Object
                    DataSet ds = new DataSet();

                    //Creating SQL Command Object 
                    SqlCommand sqlCmd = new SqlCommand
                    {
                        CommandText = "spGetEmployeesByAgeDept", //Specifying the Stored Procedure Name
                        CommandType = CommandType.StoredProcedure, //We are going to Execute the command is a Stored Procedure
                        Connection = connection //Specifying the connection object whhere the Stored Procedure is going to be execute
                    };

                    //Create the Input Parameter for the Stored Procedure
                    SqlParameter paramAge = new SqlParameter
                    {
                        ParameterName = "@Age", //Parameter name defined in stored procedure
                        SqlDbType = SqlDbType.Int, //Data Type of Parameter
                        Value = 25, //Set the value
                        Direction = ParameterDirection.Input //Specify the parameter as input
                    };
                    //Add the parameter to the SqlCommand object
                    sqlCmd.Parameters.Add(paramAge);

                    //You can also directly add the parameter to the command object using AddWithValue method
                    sqlCmd.Parameters.AddWithValue("@Dept", "IT");

                    //Create SqlDataAdapter object
                    SqlDataAdapter da = new SqlDataAdapter
                    {
                        //Specify the Select Command as the command object we created
                        SelectCommand = sqlCmd
                    };

                    //Call the Fill Method to fill the dataset
                    da.Fill(ds);

                    foreach (DataRow row in ds.Tables[0].Rows)
                    {
                        //Accessing the Data using the string column name as key
                        Console.WriteLine(row["Id"] + ",  " + row["Name"] + ",  " + row["Email"] + ",  " + row["Mobile"] + ",  " + row["Age"] + ",  " + row["Age"]);
                        //Accessing the Data using the integer index position as key
                        //Console.WriteLine(row[0] + ",  " + row[1] + ",  " + row[2] + ",  " + row[3] + ",  " + row[4] + ",  " + row[5]);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Exception Occurred: {ex.Message}");
            }
            Console.ReadKey();
        }
    }
}

```



```C#
using System;
using System.Data;
using System.Data.SqlClient;

namespace ADOUsingStoredProcedure
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                //Store the connection string in the ConnectionString variable
                string ConnectionString = @"data source=LAPTOP-ICA2LCQL\SQLEXPRESS; database=EmployeeDB; integrated security=SSPI";

                //Creating the connection object using the ConnectionString
                using (SqlConnection connection = new SqlConnection(ConnectionString))
                {
                    //Creating DataSet Object
                    DataSet ds = new DataSet();

                    //Creating SQL Command Object 
                    SqlCommand sqlCmd = connection.CreateCommand();
                    //Specifying the Stored Procedure Name
                    sqlCmd.CommandText = "spGetEmployeesByAgeDept";
                    //We are going to Execute the command is a Stored Procedure
                    sqlCmd.CommandType = CommandType.StoredProcedure; 
                    //sqlCmd.Connection = connection; //No need to specify the connection object as the command object is created based on the connection object

                    //Add the parameter to the SqlCommand object directly using the AddWithValue method
                    sqlCmd.Parameters.AddWithValue("@Age", 25);
                    sqlCmd.Parameters.AddWithValue("@Dept", "IT");

                    //Create SqlDataAdapter object by passing the command object as a parameter to the constructor
                    SqlDataAdapter da = new SqlDataAdapter(sqlCmd);

                    //Call the Fill Method to fill the dataset
                    da.Fill(ds);

                    foreach (DataRow row in ds.Tables[0].Rows)
                    {
                        //Accessing the Data using the string column name as key
                        Console.WriteLine(row["Id"] + ",  " + row["Name"] + ",  " + row["Email"] + ",  " + row["Mobile"] + ",  " + row["Age"] + ",  " + row["Age"]);
                        //Accessing the Data using the integer index position as key
                        //Console.WriteLine(row[0] + ",  " + row[1] + ",  " + row[2] + ",  " + row[3] + ",  " + row[4] + ",  " + row[5]);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Exception Occurred: {ex.Message}");
            }
            Console.ReadKey();
        }
    }
}

```

```SqL
CREATE PROCEDURE spGetEmployees
AS
BEGIN
     SELECT Id, Name, Email, Mobile, Age, Department
     FROM Employee
END

```

```C#
using System;
using System.Data;
using System.Data.SqlClient;

namespace ADOUsingStoredProcedure
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                //Store the connection string in the ConnectionString variable
                string ConnectionString = @"data source=LAPTOP-ICA2LCQL\SQLEXPRESS; database=EmployeeDB; integrated security=SSPI";

                //Executing the spGetEmployeesByAgeDept Stored Procedure
                //Create SqlParameter Required by spGetEmployeesByAgeDept Stored Procedure
                SqlParameter[] paramterList = new SqlParameter[]
                {
                    new SqlParameter("@Age", 25),
                 new SqlParameter("@Dept", "IT")
                };

                //Call the Generic Method to Execute the Stored Procedure which returns a DataSet
                DataSet dataSet1 = ExecuteStoredProcedureReturnDataSet(ConnectionString, "spGetEmployeesByAgeDept", paramterList);
                Console.WriteLine("spGetEmployeesByAgeDept Result:");
                foreach (DataRow row in dataSet1.Tables[0].Rows)
                {
                    //Accessing the Data using the string column name as key
                    Console.WriteLine(row["Id"] + ",  " + row["Name"] + ",  " + row["Email"] + ",  " + row["Mobile"] + ",  " + row["Age"] + ",  " + row["Age"]);
                }

                //Executing the spGetEmployees Stored Procedure
                DataSet dataSet2 = ExecuteStoredProcedureReturnDataSet(ConnectionString, "spGetEmployees");
                Console.WriteLine("\nspGetEmployees Result:");
                foreach (DataRow row in dataSet2.Tables[0].Rows)
                {
                    //Accessing the Data using the string column name as key
                    Console.WriteLine(row["Id"] + ",  " + row["Name"] + ",  " + row["Email"] + ",  " + row["Mobile"] + ",  " + row["Age"] + ",  " + row["Age"]);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Exception Occurred: {ex.Message}");
            }
            Console.ReadKey();
        }

        public static DataSet ExecuteStoredProcedureReturnDataSet(string connectionString, string procedureName, params SqlParameter[] paramterList)
        {
            //Create DataSet Object
            DataSet dataSet = new DataSet();

            //Create the connection object using the connectionString parameter which it received as input parameter
            using (var sqlConnection = new SqlConnection(connectionString))
            {
                //Create the command object
                using (var command = sqlConnection.CreateCommand())
                {
                    //Create the SqlDataAdapter object by passing command object as a parameter to the constructor
                    using (SqlDataAdapter sda = new SqlDataAdapter(command))
                    {
                        //Set the command type as StoredProcedure
                        command.CommandType = CommandType.StoredProcedure;

                        //Set the command text as the procedure name which you received as input parameter
                        command.CommandText = procedureName;

                        //If Parameter list is not null, add the parameterlist into Parameters collection of the command object
                        if (paramterList != null)
                        {
                            command.Parameters.AddRange(paramterList);
                        }
                        
                        //Fill the Dataset
                        sda.Fill(dataSet);
                    }
                }
            }
            //Return the DataSet
            return dataSet;
        }
    }
}

```


##### **Views in SQL Server:**

![[Pasted image 20240327162248.png]]

##### **ADO.NET DataView Class in C#:**

```C#
CREATE DATABASE EmployeeDB;
GO

USE EmployeeDB;
GO

CREATE TABLE Employee(
 Id INT PRIMARY KEY,
 Name VARCHAR(100),
 Email VARCHAR(50),
 Mobile VARCHAR(50),
 Age INT,
 Salary INT,
 Department VARCHAR(50)
)
GO

INSERT INTO Employee VALUES (100, 'Anurag','Anurag@dotnettutorial.net','1234567890', 25, 10000, 'IT')
INSERT INTO Employee VALUES (101, 'Priyanka','Priyanka@dotnettutorial.net','2233445566', 26, 15000, 'HR')
INSERT INTO Employee VALUES (102, 'Preety','Preety@dotnettutorial.net','6655443322', 27, 20000, 'IT')
INSERT INTO Employee VALUES (103, 'Sambit','Sambit@dotnettutorial.net','9876543210', 28, 25000, 'HR')
INSERT INTO Employee VALUES (104, 'Pranaya','Pranaya@dotnettutorial.net','1234567890', 25, 10000, 'IT')
INSERT INTO Employee VALUES (105, 'Rakesh','Rakesh@dotnettutorial.net','2233445566', 26, 15000, 'HR')
INSERT INTO Employee VALUES (106, 'Santosh','Santosh@dotnettutorial.net','6655443322', 27, 20000, 'IT')
INSERT INTO Employee VALUES (107, 'Tarun','Tarun@dotnettutorial.net','9876543210', 28, 25000, 'HR')
GO

```

```C#
using System;
using System.Data;
using System.Data.SqlClient;

namespace DataViewClassDemo
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                string ConnectionString = @"data source=LAPTOP-ICA2LCQL\SQLEXPRESS; database=EmployeeDB; integrated security=SSPI";
                using (SqlConnection connection = new SqlConnection(ConnectionString))
                {
                    //Create the SqlDataAdapter instance by specifying the command text and connection object
                    SqlDataAdapter dataAdapter = new SqlDataAdapter("SELECT Id, Name, Email, Mobile, Age, Salary, Department FROM EMPLOYEE", connection);

                    //Creating DataTable Object
                    DataTable EmployeeDataTable = new DataTable();

                    //Filling the DataTable using the Fill Method of SqlDataAdapter object
                    dataAdapter.Fill(EmployeeDataTable);

                    //Creating DataView instance using DataView Constructor
                    //Initializes a new instance of the DataView class with the specified DataTable.
                    DataView dataView1 = new DataView(EmployeeDataTable);
                    Console.WriteLine("Accessing DataView using For Loop:");
                    for (int i = 0; i < dataView1.Count; i++)
                    {
                        Console.WriteLine($"Id: {dataView1[i]["Id"]}, Name: {dataView1[i]["Name"]}, Email: {dataView1[i]["Email"]}, Mobile: {dataView1[i]["Mobile"]}");
                    }

                    //Creating DataView instance using DefaultView property of Data Table
                    DataView dataView2 = EmployeeDataTable.DefaultView;
                    Console.WriteLine("\nAccessing DataView using Foreach Loop:");
                    foreach (DataRowView rowView in dataView2)
                    {
                        DataRow row = rowView.Row;
                        Console.WriteLine($"Id: {row["Id"]}, Age: {row["Age"]}, Salary: {row["Salary"]}, Department: {row["Department"]}");
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Exception Occurred: {ex.Message}");
            }
            Console.ReadKey();
        }
    }
}

```

```C#
using System;
using System.Data;
using System.Data.SqlClient;

namespace DataViewClassDemo
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                string ConnectionString = @"data source=LAPTOP-ICA2LCQL\SQLEXPRESS; database=EmployeeDB; integrated security=SSPI";
                using (SqlConnection connection = new SqlConnection(ConnectionString))
                {
                    //Create the SqlDataAdapter instance by specifying the command text and connection object
                    SqlDataAdapter dataAdapter = new SqlDataAdapter("SELECT Id, Name, Email, Mobile, Age, Salary, Department FROM EMPLOYEE", connection);

                    //Creating DataTable Object
                    DataTable EmployeeDataTable = new DataTable();

                    //Filling the DataTable using the Fill Method of SqlDataAdapter object
                    dataAdapter.Fill(EmployeeDataTable);

                    //Creating DataView instance using DataView Constructor
                    //Initializes a new instance of the DataView class with the specified DataTable
                    DataView dataView1 = new DataView(EmployeeDataTable);
                    dataView1.Sort = "Name ASC";
                    Console.WriteLine("DataView Sorted By: Name ASC");
                    for (int i = 0; i < dataView1.Count; i++)
                    {
                        Console.WriteLine($"Id: {dataView1[i]["Id"]}, Name: {dataView1[i]["Name"]}, Department: {dataView1[i]["Department"]}");
                    }

                    //Creating DataView instance using DataView Constructor
                    //Sorting Based on Multiple Columns Separated by comma
                    DataView dataView2 = new DataView(EmployeeDataTable);
                    dataView2.Sort = "Department DESC, Name ASC";
                    //The above statement is similar to the below statement
                    //dataView2.Sort = "Department DESC, Name";
                    Console.WriteLine("\nDataView Sorted By: Department DESC and Name ASC");
                    foreach (DataRowView rowView in dataView2)
                    {
                        DataRow row = rowView.Row;
                        Console.WriteLine($"Id: {row["Id"]}, Department: {row["Department"]}, Name: {row["Name"]}");
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Exception Occurred: {ex.Message}");
            }
            Console.ReadKey();
        }
    }
}

```

##### **Adding Row in ADO.NET DataView using C#:**

```C#
using System;
using System.Data;
using System.Data.SqlClient;

namespace DataViewClassDemo
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                string ConnectionString = @"data source=LAPTOP-ICA2LCQL\SQLEXPRESS; database=EmployeeDB; integrated security=SSPI";
                using (SqlConnection connection = new SqlConnection(ConnectionString))
                {
                    //Create the SqlDataAdapter instance by specifying the command text and connection object
                    SqlDataAdapter dataAdapter = new SqlDataAdapter("SELECT Id, Name, Email, Mobile, Age, Salary, Department FROM EMPLOYEE", connection);

                    //Creating DataTable Object
                    DataTable EmployeeDataTable = new DataTable();

                    //Filling the DataTable using the Fill Method of SqlDataAdapter object
                    dataAdapter.Fill(EmployeeDataTable);

                    //Creating DataView instance using DataView constructor
                    DataView dataView1 = new DataView(EmployeeDataTable);

                    //Create a new DataRowView by calling the AddNew Method of the dataview object
                    //If you want restrict new row on the data view then set AllowNew property to false
                    dataView1.AllowNew = true;
                    DataRowView newRow = dataView1.AddNew();

                    //Set the newRow column values
                    newRow["Id"] = 108;
                    newRow["Name"] = "New Name";
                    newRow["Mobile"] = "New Mobile";
                    newRow["Age"] = 27;
                    newRow["Salary"] = 20000;
                    newRow["Department"] = "IT";

                    //You can see the new row in the Data View
                    Console.WriteLine($"\nDataView Data");
                    foreach (DataRowView rowView in dataView1)
                    {
                        DataRow row = rowView.Row;
                        Console.WriteLine($"Id: {row["Id"]}, Name: {row["Name"]}, Mobile: {row["Mobile"]}, Department: {row["Department"]}");
                    }

                    //You cannot see the new row in the DataTable
                    Console.WriteLine($"\nDataTable Data:");
                    foreach (DataRow row in EmployeeDataTable.Rows)
                    {
                        Console.WriteLine($"Id: {row["Id"]}, Name: {row["Name"]}, Mobile: {row["Mobile"]}, Department: {row["Department"]}");
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Exception Occurred: {ex.Message}");
            }
            Console.ReadKey();
        }
    }
}

```

##### **Updating Row in ADO.NET DataView**

```C#
using System;
using System.Data;
using System.Data.SqlClient;

namespace DataViewClassDemo
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                string ConnectionString = @"data source=LAPTOP-ICA2LCQL\SQLEXPRESS; database=EmployeeDB; integrated security=SSPI";
                using (SqlConnection connection = new SqlConnection(ConnectionString))
                {
                    //Create the SqlDataAdapter instance by specifying the command text and connection object
                    SqlDataAdapter dataAdapter = new SqlDataAdapter("SELECT Id, Name, Email, Mobile, Age, Salary, Department FROM EMPLOYEE", connection);

                    //Creating DataTable Object
                    DataTable EmployeeDataTable = new DataTable();

                    //Filling the DataTable using the Fill Method of SqlDataAdapter object
                    dataAdapter.Fill(EmployeeDataTable);

                    //Creating DataView instance using DataView constructor
                    DataView dataView1 = new DataView(EmployeeDataTable);

                    //You can see the new row in the Data View
                    Console.WriteLine($"DataView Data Before Update");
                    foreach (DataRowView rowView in dataView1)
                    {
                        DataRow row = rowView.Row;
                        Console.WriteLine($"Id: {row["Id"]}, Name: {row["Name"]}, Salary: {row["Salary"]}, Department: {row["Department"]}");
                    }

                    //If you want restrict the data view to be Updated then set AllowEdit property to false
                    dataView1.AllowEdit = true;

                    //Updating the Salary of IT Department employees by adding 1000 to their current Salary
                    foreach (DataRowView rowView in dataView1)
                    {
                        if(Convert.ToString(rowView["Department"]) == "IT")
                        {
                            //You can  access the column by using string column name
                            rowView["Salary"] = Convert.ToInt32(rowView["Salary"]) + 1000;

                            //You can also access the column by using Integer Index Position
                            //rowView[5] = Convert.ToInt32(rowView[5]) + 1000;
                        }
                    }

                    //You can also access Individual DataView Row as follow
                    //Here, Index position 0 specify the first row
                    //dataView1[0]["Salary"] = Convert.ToInt32(dataView1[0]["Salary"]) + 1000;
                    //dataView1[0][5] = Convert.ToInt32(dataView1[0][5]) + 1000;

                    Console.WriteLine($"\nDataView Data After Update");
                    foreach (DataRowView rowView in dataView1)
                    {
                        DataRow row = rowView.Row;
                        Console.WriteLine($"Id: {row["Id"]}, Name: {row["Name"]}, Salary: {row["Salary"]}, Department: {row["Department"]}");
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Exception Occurred: {ex.Message}");
            }
            Console.ReadKey();
        }
    }
}

```

```C#
using System;
using System.Data;
using System.Data.SqlClient;

namespace DataViewClassDemo
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                string ConnectionString = @"data source=LAPTOP-ICA2LCQL\SQLEXPRESS; database=EmployeeDB; integrated security=SSPI";
                using (SqlConnection connection = new SqlConnection(ConnectionString))
                {
                    //Create the SqlDataAdapter instance by specifying the command text and connection object
                    SqlDataAdapter dataAdapter = new SqlDataAdapter("SELECT Id, Name, Email, Mobile, Age, Salary, Department FROM EMPLOYEE", connection);

                    //Creating DataTable Object
                    DataTable EmployeeDataTable = new DataTable();

                    //Filling the DataTable using the Fill Method of SqlDataAdapter object
                    dataAdapter.Fill(EmployeeDataTable);

                    //Creating DataView instance using DataView constructor
                    DataView dataView1 = new DataView(EmployeeDataTable);

                    //You can see the new row in the Data View
                    Console.WriteLine($"DataView Data Before Delete:");
                    foreach (DataRowView rowView in dataView1)
                    {
                        DataRow row = rowView.Row;
                        Console.WriteLine($"Id: {row["Id"]}, Name: {row["Name"]}, Salary: {row["Salary"]}, Department: {row["Department"]}");
                    }

                    //If you want restrict the delete operation on a dataview then set AllowDelete property to false
                    dataView1.AllowDelete = true;

                    //Deleting IT Department employees from the Data View
                    foreach (DataRowView rowView in dataView1)
                    {
                        if (Convert.ToString(rowView["Department"]) == "IT")
                        {
                            rowView.Delete();
                        }
                    }

                    //You can also delete Individual DataView Row as follow
                    //Here, Index position 0 specify the first row
                    //dataView1[0].Delete();

                    Console.WriteLine($"\nDataView Data After Delete:");
                    foreach (DataRowView rowView in dataView1)
                    {
                        DataRow row = rowView.Row;
                        Console.WriteLine($"Id: {row["Id"]}, Name: {row["Name"]}, Salary: {row["Salary"]}, Department: {row["Department"]}");
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Exception Occurred: {ex.Message}");
            }
            Console.ReadKey();
        }
    }
}

```

##### **What is ADO.NET DataSet?**

![[Pasted image 20240327162555.png]]

