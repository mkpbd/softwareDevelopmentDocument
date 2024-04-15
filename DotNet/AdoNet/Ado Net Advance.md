



```SQL
	CREATE DATABASE BankDB;
GO

USE BankDB;
GO

CREATE TABLE Accounts
(
     AccountNumber VARCHAR(60) PRIMARY KEY,
     CustomerName VARCHAR(60),
     Balance int
);
GO

INSERT INTO Accounts VALUES('Account1', 'James', 1000);
INSERT INTO Accounts VALUES('Account2', 'Smith', 1000);
GO

```

![[word-image-86.webp]]

**tep 1:** First you need to create and open the connection object. And the following two statements exactly do the same thing.  
**SqlConnection connection = new SqlConnection(ConnectionString)**  
**connection.Open();**

**Step 2:** Then you need to create the SqlTransaction object and to do so, you need to call the BeginTransaction method on the connection object. The following piece of code does the same.  
**SqlTransaction transaction = connection.BeginTransaction();**

**Step 3:** Then you need to create the command object and while creating the command object, we need to text (in this case of the UPDATE statement) that we want to execute in the database, the connection object where we want to execute the command, and the transaction object which will execute the command as part of the transaction. And then we need to call the ExecuteNonQuery method to execute the DML Statement. The following code exactly does the same thing.  
**// Associate the first update command with the transaction**  
**SqlCommand cmd = new SqlCommand(“UPDATE Accounts SET Balance = Balance – 500 WHERE AccountNumber = ‘Account1′”, connection, transaction);**  
**cmd.ExecuteNonQuery();**

**// Associate the second update command with the transaction**  
**cmd = new SqlCommand(“UPDATE Accounts SET Balance = Balance + 500 WHERE AccountNumber = ‘Account2′”, connection, transaction);**  
**cmd.ExecuteNonQuery();**

**Step 4:** If everything goes well then commit the transaction i.e. if both the UPDATE statements are executed successfully, then commit the transaction. To do so call the Commit method on the transaction object as follows.  
**transaction.Commit();**

**Step 4:** If anything goes wrong then roll back the transaction. To do so call the Rollback method on the transaction object as follows.  
**transaction.Rollback();**


##  **Understand ADO.NET Transactions using C#:**

```C#
using System;
using System.Data.SqlClient;

namespace ADOTransactionsDemo
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                Console.WriteLine("Before Transaction");
                GetAccountsData();

                //Doing the Transaction
                MoneyTransfer();

                //Verifying the Data After Transaction
                Console.WriteLine("After Transaction");
                
                GetAccountsData();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Exception Occurred: {ex.Message}");
            }
            Console.ReadKey();
        }

        private static void MoneyTransfer()
        {
            //Store the connection string in a variable
            string ConnectionString = @"data source=LAPTOP-ICA2LCQL\SQLEXPRESS; initial catalog=BankDB; integrated security=True";
            
            //Creating the connection object
            using (SqlConnection connection = new SqlConnection(ConnectionString))
            {
                //Open the connection
                //The connection needs to be open before we begin a transaction
                connection.Open();

                // Create the transaction object by calling the BeginTransaction method on connection object
                SqlTransaction transaction = connection.BeginTransaction();

                try
                {
                    // Associate the first update command with the transaction
                    SqlCommand cmd = new SqlCommand("UPDATE Accounts SET Balance = Balance - 500 WHERE AccountNumber = 'Account1'", connection, transaction);
                    //Execute the First Update Command
                    cmd.ExecuteNonQuery();

                    // Associate the second update command with the transaction
                    cmd = new SqlCommand("UPDATE Accounts SET Balance = Balance + 500 WHERE AccountNumber = 'Account2'", connection, transaction);
                    //Execute the Second Update Command
                    cmd.ExecuteNonQuery();

                    // If everythinhg goes well then commit the transaction
                    transaction.Commit();
                    Console.WriteLine("Transaction Committed");
                }
                catch(Exception EX)
                {
                    // If anything goes wrong, then Rollback the transaction
                    transaction.Rollback();
                    Console.WriteLine("Transaction Rollback");
                }
            }
        }

        private static void GetAccountsData()
        {
            //Store the connection string in a variable
            string ConnectionString = @"data source=LAPTOP-ICA2LCQL\SQLEXPRESS; initial catalog=BankDB; integrated security=True";

            //Create the connection object
            using (SqlConnection connection = new SqlConnection(ConnectionString))
            {
                connection.Open();
                SqlCommand cmd = new SqlCommand("Select * from Accounts", connection);
                SqlDataReader sdr = cmd.ExecuteReader();
                while (sdr.Read())
                {
                    Console.WriteLine(sdr["AccountNumber"] + ",  " + sdr["CustomerName"] + ",  " + sdr["Balance"]);
                }
            }
        }
    }
}
```



```C#
using System;
using System.Data.SqlClient;

namespace ADOTransactionsDemo
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                Console.WriteLine("Before Transaction");
                GetAccountsData();

                //Doing the Transaction
                MoneyTransfer();

                //Verifying the Data After Transaction
                Console.WriteLine("After Transaction");
                
                GetAccountsData();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Exception Occurred: {ex.Message}");
            }
            Console.ReadKey();
        }

        private static void MoneyTransfer()
        {
            //Store the connection string in a variable
            string ConnectionString = @"data source=LAPTOP-ICA2LCQL\SQLEXPRESS; initial catalog=BankDB; integrated security=True";
            
            //Creating the connection object
            using (SqlConnection connection = new SqlConnection(ConnectionString))
            {
                //Open the connection
                //The connection needs to be open before we begin a transaction
                connection.Open();

                // Create the transaction object by calling the BeginTransaction method on connection object
                SqlTransaction transaction = connection.BeginTransaction();

                try
                {
                    // Associate the first update command with the transaction
                    SqlCommand cmd = new SqlCommand("UPDATE Accounts SET Balance = Balance - 500 WHERE AccountNumber = 'Account1'", connection, transaction);
                    //Execute the First Update Command
                    cmd.ExecuteNonQuery();

                    // Associate the second update command with the transaction
                    //MyAccounts table does not exists, so it will throw an exception
                    cmd = new SqlCommand("UPDATE MyAccounts SET Balance = Balance + 500 WHERE AccountNumber = 'Account2'", connection, transaction);
                    //Execute the Second Update Command
                    cmd.ExecuteNonQuery();

                    // If everythinhg goes well then commit the transaction
                    transaction.Commit();
                    Console.WriteLine("Transaction Committed");
                }
                catch(Exception ex)
                {
                    // If anything goes wrong, then Rollback the transaction
                    transaction.Rollback();
                    Console.WriteLine("Transaction Rollback");
                }
            }
        }

        private static void GetAccountsData()
        {
            //Store the connection string in a variable
            string ConnectionString = @"data source=LAPTOP-ICA2LCQL\SQLEXPRESS; initial catalog=BankDB; integrated security=True";

            //Create the connection object
            using (SqlConnection connection = new SqlConnection(ConnectionString))
            {
                connection.Open();
                SqlCommand cmd = new SqlCommand("Select * from Accounts", connection);
                SqlDataReader sdr = cmd.ExecuteReader();
                while (sdr.Read())
                {
                    Console.WriteLine(sdr["AccountNumber"] + ",  " + sdr["CustomerName"] + ",  " + sdr["Balance"]);
                }
            }
        }
    }
}
```

## **ADO.NET Distributed Transactions**

##### **What is a Transaction in C#?**

A Transaction is a set of operations (multiple DML Operations) that ensures either all the database operations succeed or all of them failed to ensure data consistency. This means the job is never half done, either all of it is done or nothing is done. So, a transaction is a unit of work and the transactions ensure the consistency and integrity of a database.

The ADO.NET supports both single database transactions as well as distributed transactions. In C#, the Single Database Transaction is implemented using BeginTransaction which belongs to **System.Data** namespace and the Distributed Transaction implemented using TransactionScope which belongs to **System.Transactions** namespace.

**Note:** In our previous article, we discussed how to implement Single Database Transactions in C# and ADO.NET, and in this article, we are going to discuss how to implement Distributed Transactions with one real-time example.


##### **What are Distributed Transactions in C#?**

A distributed transaction is a transaction that uses different data sources or in simple words, we can say that the transaction going to perform DML Operations on more than one database. Distributed transactions allow us to perform several operations on different systems as a single unit i.e. either succeeded or failed completely. If this is not clear at the moment don’t worry, we will try to understand this concept with one real-time example.


##### **Understand Distributed Transactions in C# using ADO.NET:**


![[word-image-32693-1.webp]]


```sql
CREATE DATABASE AXISBankDB;
GO

USE AXISBankDB;
GO

CREATE TABLE Accounts
(
     AccountNumber INT PRIMARY KEY,
     CustomerName VARCHAR(60),
     Balance INT
);
GO
INSERT INTO Accounts VALUES(1001, 'James', 5000);
INSERT INTO Accounts VALUES(1002, 'Smith', 6000);
GO

CREATE TABLE TransactionDetails
(
     TransactionDetailsID INT PRIMARY KEY IDENTITY(1, 1),
     AccountNumber INT FOREIGN KEY REFERENCES Accounts(AccountNumber),
     Amount INT,
  TransactionDetails VARCHAR(500),
  TransactionType VARCHAR(5),
  CreatedDate Date DEFAULT GETDATE()
);
GO

INSERT INTO TransactionDetails VALUES(1001, 7000, 'Deposited', 'CR', GETDATE());
INSERT INTO TransactionDetails VALUES(1001, 2000, 'Withdraw', 'DR', GETDATE());
INSERT INTO TransactionDetails VALUES(1002, 9000, 'Deposited', 'CR', GETDATE());
INSERT INTO TransactionDetails VALUES(1002, 3000, 'Withdraw', 'DR', GETDATE());
GO

CREATE DATABASE ICICIBankDB;
GO

USE ICICIBankDB;
GO

CREATE TABLE Accounts
(
     AccountNumber INT PRIMARY KEY,
     CustomerName VARCHAR(60),
     Balance INT
);
GO
INSERT INTO Accounts VALUES(50001, 'Sara', 15000);
INSERT INTO Accounts VALUES(50002, 'Pam', 16000);
GO

CREATE TABLE TransactionDetails
(
     TransactionDetailsID INT PRIMARY KEY IDENTITY(1, 1),
     AccountNumber INT FOREIGN KEY REFERENCES Accounts(AccountNumber),
     Amount INT,
  TransactionDetails VARCHAR(500),
  TransactionType VARCHAR(5),
  CreatedDate DATE DEFAULT GETDATE()
);
GO

INSERT INTO TransactionDetails VALUES(50001, 20000, 'Deposited', 'CR', GETDATE());
INSERT INTO TransactionDetails VALUES(50001, 5000, 'Withdraw', 'DR', GETDATE());
INSERT INTO TransactionDetails VALUES(50002, 26000,'Deposited', 'CR', GETDATE());
INSERT INTO TransactionDetails VALUES(50002, 10000, 'Withdraw', 'DR', GETDATE());
GO

```
##### **How to Implement Distributed Transaction in C# and ADO.NET?**
In order to create and use distributed transactions, first of all, we need to create an instance of the TransactionScope class. It is also possible to open multiple database connections within the same transaction scope. The transaction scope will decide whether to create a local transaction or a distributed transaction. The transaction scope automatically converts a local transaction to a distributed transaction if required.

If you open a single connection then it will be a single transaction and when you open subsequent connections in the transaction scope, the transaction scope promotes the transaction to a distributed transaction.
##### **Steps of Creating Distributed Transaction using ADO.NET:**

We need to follow the following five steps to implement distributed transactions in C#.

1. Create an Instance of TransactionScope class.
2. Open the connection.
3. Perform the DML (INSERT, UPDATE, and DELETE) operations as per your business requirements.
4. If all your DML (INSERT, UPDATE, and DELETE) operations are completed successfully, then mark the transaction as completed.
5. Dispose the TransactionScope object.

**Note:** If all the DML (INSERT, UPDATE, and DELETE) operations succeeded in a transaction scope, then call the Complete method on the TransactionScope object to indicate that the transaction was completed successfully.


##### **How to terminate a Distributed Transaction in C#?**

To terminate a distributed transaction in C#, we just need to call the Dispose method on the TransactionScope object. When we call the Dispose Method on the TransactionScope object, then the transaction is either committed or rolled back, depending on whether you called the Complete method or not:

1. If you called the Complete method on the TransactionScope object before its disposal, the transaction manager commits the transaction.
2. If you did not call the Complete method on the TransactionScope object before its disposal, the transaction manager rolls back the transaction.



##### **What is TransactionScope in C#?**

A transaction scope defines a block of code that participates in a transaction. If the code block is completed successfully, then the transaction manager commits the transaction. Otherwise, the transaction manager rolls back the transaction. To use TransactionScope, you need to add a reference to the System.Transactions assembly and then you need to import the System.Transactions namespace into your application.


##### **Understand ADO.NET Distributed Transaction in C#:**

```C#
using System;
using System.Data.SqlClient;
//First Add Reference to System.Transactions DLL and then import the same
using System.Transactions;
namespace AdoNetConsoleApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            //Connection String Pointing to AXISBankDB
            string connStringAXIXBank = @"data source=LAPTOP-ICA2LCQL\SQLEXPRESS; database=AXISBankDB; integrated security=TRUE";

            //Connection String Pointing to ICICIBankDB
            string connStringICICIBank = @"data source=LAPTOP-ICA2LCQL\SQLEXPRESS; database=ICICIBankDB; integrated security=TRUE";

            //For Distributaed Transaction, we need to create an instance of TransactionScope
            //Here, we are using the using block which will dispose the transactionScope object automatically
            using (TransactionScope transactionScope = new TransactionScope())
            {
                //We need to Deduct Money from the accounts table of a user of AXIXBankDB
                //So, first connecttion object pointing to AXIXBankDB
                using (SqlConnection connectionAxisbank = new SqlConnection(connStringAXIXBank))
                {
                    //Create the command object
                    using (SqlCommand cmdAxisbank = new SqlCommand())
                    {
                        //Point the command object to execute the command in the AXIXBankDB
                        cmdAxisbank.Connection = connectionAxisbank;
                        connectionAxisbank.Open();

                        //First Update the Balance in AXIXBankDB 
                        cmdAxisbank.CommandText = "UPDATE Accounts SET Balance = Balance - 1000 WHERE AccountNumber = 1001";
                        int rowsAffectedA = cmdAxisbank.ExecuteNonQuery();

                        //Then make an entry into the TransactionDetails table in AXIXBankDB
                        cmdAxisbank.CommandText = "INSERT INTO TransactionDetails (AccountNumber, Amount, TransactionDetails, TransactionType) VALUES(1001, 1000, 'Transafer' , 'DR')";
                        int rowsAffectedB = cmdAxisbank.ExecuteNonQuery();

                        //If First two DML Operations are succeded, then only go inside and do the rest operations
                        if (rowsAffectedA > 0 && rowsAffectedB > 0)
                        {
                            Console.WriteLine("1000 deducted from Account Number: 1001 from Axis Bank");
                            //The second connection pointing to ICICIBankDB where we are going to perform the rest operations
                            using (SqlConnection connectionICICIBank = new SqlConnection(connStringICICIBank))
                            {
                                using (SqlCommand cmdICICIBank = new SqlCommand())
                                {
                                    //Point the command object to execute the command in the ICICIBankDB
                                    cmdICICIBank.Connection = connectionICICIBank;
                                    connectionICICIBank.Open();
                                    //First Update the Balance in ICICIBankDB
                                    cmdICICIBank.CommandText = "UPDATE Accounts SET Balance = Balance + 1000 WHERE AccountNumber = 50001";
                                    int rowsAffectedC = cmdICICIBank.ExecuteNonQuery();

                                    //Then make an entry into the TransactionDetails table of ICICIBankDB
                                    cmdICICIBank.CommandText = "INSERT INTO TransactionDetails (AccountNumber, Amount, TransactionDetails, TransactionType) VALUES(50001, 1000, 'Transafer', 'CR')";
                                    int rowsAffectedD = cmdICICIBank.ExecuteNonQuery();

                                    //If the above two DML operations are succeded, then call the Complete
                                    if (rowsAffectedC > 0 && rowsAffectedD > 0)
                                    {
                                        //The Complete() mark the transaction as completed successfully
                                        transactionScope.Complete();
                                        Console.WriteLine("1000 Deposited to Account Number: 50001 to ICICI Bank");
                                        Console.WriteLine("Transaction Completed");
                                    }
                                    else
                                    {
                                        Console.WriteLine("Transaction Failed..");
                                    }
                                } // Dispose the cmdICICIBank command object.

                            } // Dispose the connectionICICIBank connection.
                        }
                        else
                        {
                            Console.WriteLine("Transaction Failed..");
                        }
                    } // Dispose the cmdAxisbank command object.

                } // Dispose connectionAxisbank connection.

            } // Dispose TransactionScope object, to commit or rollback transaction.

            Console.ReadKey();
        }
    }
}

```


## **ADO.NET Connection Pooling**

When we use ADO.NET in our C# Applications, what we do is, first we will create the connection object, then open the connection, then perform some database operations and finally close the connection as shown in the below image.

![[Pasted image 20240327165700.png]]


Now the creation of a connection object and opening the connection object is quite expensive. In other words, when we say, open the connection, it will internally do a lot of things i.e. opens the socket, some kind of handshaking is happening, the connection string is parsed to check whether the connection string format is proper, or not, the Authentication mechanism is executed, and lots of other series of steps have happened internally before the connection object gets connected to the underlying database. For a better understanding, please have a look at the below image.

![[word-image-48.webp]]


Once the connection object is open, then you can perform the database CRUD operation and once the DB Operations are performed, you can close the connection. This creation of a connection object is quite expensive and you would like to avoid the above things again and again when you need to create the connection object in C#.


![[word-image-49.webp]]

So, connection pooling means, once the connection object is open, rather than going and recreating the connection object, again and again, what ADO.NET does is, it takes the connection object and puts it into a place called pooler. In the pooler, the object will be cached, and later if somebody says **connection.Open** then rather than executing the series of steps, it takes the connection object from the pool and starts executing.

##### **Connection Pooling Example in C# ADO.NET:**
 The most important point that you need to remember is by default connection pooling is enabled in ADO.NET.  Here, we are using a big for loop and in each iteration, we are creating the connection object, opening the connection, doing some operation (intentionally using thread sleep to check the connection pooling), and closing the connection object.

##### **Understand Connection Pooling in C#**

By default, the connection pooling is enabled in C# ADO.NET. If you want then you can **Pooling=true**; in the connection string which will enable the connection pooling in ADO.NET. In the following example, we set the pooling value to true and then created 1000 connection objects. Please execute the below code and see the time taken by ADO.NET when connection pooling is enabled.

```C#
using System;
using System.Data.SqlClient;
using System.Diagnostics;
namespace ConnectionPooling
{
    class Program
    {
        static void Main(string[] args)
        {
            var stopwatch = new Stopwatch();

            string ConnectionString = "data source=LAPTOP-ICA2LCQL\\SQLEXPRESS; initial catalog=ADODB; integrated security=True; Pooling=true;";
            stopwatch.Start();

            for (int i = 0; i < 1000; i++)
            {
                SqlConnection connection = new SqlConnection(ConnectionString);
                connection.Open();
                connection.Close();
            }

            stopwatch.Stop();
            Console.WriteLine($"Pooling=true, Time : {stopwatch.ElapsedMilliseconds} ms");
            Console.ReadKey();
        }
    }
}

```
**Output:** **Pooling=true, Time : 163 ms**

Even though the loop is going to be executed 1000 times, we should not see too many connection objects get created rather the connection objects are going to be fetched from the connection pool. It will use the same connection object from the pool again and again. And hence you can see, it simply takes 163 ms. If you remove the Pooling=true; from the connection string, then also it is going to fetch the connection object from the pool as by default connection pooling is enabled in ADO.N

##### **Without Connection Pooling in C# ADO.NET**

```C#
using System;
using System.Data.SqlClient;
using System.Diagnostics;
namespace ConnectionPooling
{
    class Program
    {
        static void Main(string[] args)
        {
            var stopwatch = new Stopwatch();

            string ConnectionString = "data source=LAPTOP-ICA2LCQL\\SQLEXPRESS; initial catalog=ADODB; integrated security=True; Pooling=false;";
            stopwatch.Start();

            for (int i = 0; i < 1000; i++)
            {
                SqlConnection connection = new SqlConnection(ConnectionString);
                connection.Open();
                connection.Close();
            }

            stopwatch.Stop();
            Console.WriteLine($"Pooling=false, Time : {stopwatch.ElapsedMilliseconds} ms");
            Console.ReadKey();
        }
    }
}

```

##### **How to Verify Connection Pooling is Used in ADO.NET?**

![[word-image-50.webp]]

![[word-image-51.webp]]

![[word-image-52.webp]]

![[word-image-53.webp]]

```C#
using System;
using System.Data.SqlClient;
using System.Threading;
namespace ConnectionPooling
{
    class Program
    {
        static void Main(string[] args)
        {
            string ConnectionString = "data source=LAPTOP-ICA2LCQL\\SQLEXPRESS; initial catalog=ADODB; integrated security=True; Pooling=true;";
           
            for (int i = 0; i < 1000; i++)
            {
                SqlConnection connection = new SqlConnection(ConnectionString);
                connection.Open();
                Thread.Sleep(100);
                connection.Close();
            }

            Console.ReadKey();
        }
    }
}

```

![[word-image-54-768x484.webp]]

![[word-image-55-768x622.webp]]


![[word-image-56.webp]]
![[word-image-57.webp]]

```C#
using System;
using System.Data.SqlClient;
using System.Threading;
namespace ConnectionPooling
{
    class Program
    {
        static void Main(string[] args)
        {
            string ConnectionString = "data source=LAPTOP-ICA2LCQL\\SQLEXPRESS; initial catalog=ADODB; integrated security=True; Pooling=false;";
           
            for (int i = 0; i < 1000; i++)
            {
                SqlConnection connection = new SqlConnection(ConnectionString);
                connection.Open();
                Thread.Sleep(100);
                connection.Close();
            }

            Console.ReadKey();
        }
    }
}

```


![[word-image-58 1.webp]]
![[word-image-59.webp]]


![[word-image-60.webp]]

##### **two connection objects with the same connection string**

```C#
using System;
using System.Data.SqlClient;
namespace ConnectionPooling
{
    class Program
    {
        static void Main(string[] args)
        {
            string ConnectionString1 = "data source=LAPTOP-ICA2LCQL\\SQLEXPRESS; initial catalog=ADODB; integrated security=True; Pooling=true;";
            string ConnectionString2 = "data source=LAPTOP-ICA2LCQL\\SQLEXPRESS; initial catalog=ADODB; integrated security=True; Pooling=true;";

            SqlConnection connection1 = new SqlConnection(ConnectionString1);
            connection1.Open();
            connection1.Close();

            SqlConnection connection2 = new SqlConnection(ConnectionString2);
            connection2.Open();
            connection2.Close();
        }
    }
}

```

##### **two connection objects with the different connection string**

```C#
using System;
using System.Data.SqlClient;
namespace ConnectionPooling
{
    class Program
    {
        static void Main(string[] args)
        {
            string ConnectionString1 = "data source=LAPTOP-ICA2LCQL\\SQLEXPRESS; initial catalog=ADODB; integrated security=True; Pooling=true;";
            string ConnectionString2 = "data source=localhost\\SQLEXPRESS; initial catalog=ADODB; integrated security=True; Pooling=true;";

            SqlConnection connection1 = new SqlConnection(ConnectionString1);
            connection1.Open();
            
            SqlConnection connection2 = new SqlConnection(ConnectionString2);
            connection2.Open();

            Console.ReadLine();

            connection1.Close();
            connection2.Close();
        }
    }
}

```

![[word-image-61.webp]]

## **ADO.NET Architecture**
![[Pasted image 20240327180611.png]]

1. [**Connection**](https://dotnettutorials.net/lesson/ado-net-sqlconnection-class/)
2. [**Command**](https://dotnettutorials.net/lesson/ado-net-sqlcommand-class/)
3. [**DataReader**](https://dotnettutorials.net/lesson/ado-net-sqldatareader/)
4. [**DataAdapter**](https://dotnettutorials.net/lesson/ado-net-sqldataadapter/)
5. [**DataSet**](https://dotnettutorials.net/lesson/ado-net-dataset/)
6. **DataView**

![[word-image-63.webp]]

## **Bulk INSERT and UPDATE in C# and ADO.NET using Stored Procedure**

``` Sql
CREATE DATABASE EmployeeDB;
GO

USE EmployeeDB;
GO

CREATE TABLE Employee(
 Id INT PRIMARY KEY,
 Name VARCHAR(100),
 Email VARCHAR(50),
 Mobile VARCHAR(50),
)
GO

INSERT INTO Employee VALUES (100, 'Anurag','Anurag@dotnettutorial.net','1234567890')
INSERT INTO Employee VALUES (101, 'Priyanka','Priyanka@dotnettutorial.net','2233445566')
INSERT INTO Employee VALUES (102, 'Preety','Preety@dotnettutorial.net','6655443322')
INSERT INTO Employee VALUES (103, 'Sambit','Sambit@dotnettutorial.net','9876543210')
GO

```

``` Sql
CREATE TYPE EmployeeType AS TABLE(
 Id INT NULL,
 Name VARCHAR(100) NULL,
 Email VARCHAR(50) NULL,
 Mobile VARCHAR(50) NULL
)
GO
<div class="open_grepper_editor" title="Edit & Save To Grepper"></div>
```
![[word-image-32803-2.webp]]


``` SQL
CREATE PROCEDURE SP_Bulk_Insert_Update_Employees
      @Employees EmployeeType READONLY
AS
BEGIN
      SET NOCOUNT ON;
 
      MERGE INTO Employee E1
      USING @Employees E2
      ON E1.Id=E2.Id
      WHEN MATCHED THEN
      UPDATE SET 
         E1.Name = E2.Name,
         E1.Email = E2.Email,
         E1.Mobile = E2.Mobile
      WHEN NOT MATCHED THEN
      INSERT VALUES(E2.Id, E2.Name, E2.Email, E2.Mobile);
END

```


```Sql
CREATE PROCEDURE SP_Bulk_Insert_Update_Employees_Without_MERGE
      @Employees EmployeeType READONLY
AS
BEGIN
      SET NOCOUNT ON;
      --UPDATE EXISTING RECORDS
      UPDATE Employee 
      SET 
         Name = E2.Name,
         Email = E2.Email,
         Mobile = E2.Mobile
      FROM Employee E1
      INNER JOIN @Employees E2
      ON E1.Id=E2.Id
 
      --INSERT NON-EXISTING RECORDS
      INSERT INTO Employee
      SELECT Id, Name, Email, Mobile
      FROM @Employees 
      WHERE Id NOT IN(SELECT Id FROM Employee)
END

```



##### **  understand how to Perform Bulk Insert and Update using C# ADO.NET:**

```C#
	using System;
using System.Data;
using System.Data.SqlClient;
namespace BulkInsertUpdateUsingADO
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                //Storing the connection string in a variable
                string ConnectionString = @"data source=LAPTOP-ICA2LCQL\SQLEXPRESS; database=EmployeeDB; integrated security=SSPI";

                //Creating Data Table
                DataTable EmployeeDataTable = new DataTable("Employees");

                //Add Columns to the Data Table as per the columns defined in the Table Type Parameter
                DataColumn Id = new DataColumn("Id");
                EmployeeDataTable.Columns.Add(Id);

                DataColumn Name = new DataColumn("Name");
                EmployeeDataTable.Columns.Add(Name);

                DataColumn Email = new DataColumn("Email");
                EmployeeDataTable.Columns.Add(Email);

                DataColumn Mobile = new DataColumn("Mobile");
                EmployeeDataTable.Columns.Add(Mobile);

                //Adding Multiple Rows into the DataTable
                //Follwoing Rows are going to be updated
                EmployeeDataTable.Rows.Add(101, "ABC", "ABC@dotnettutorials.net", "12345");
                EmployeeDataTable.Rows.Add(102, "PQR", "PQR@dotnettutorials.net", "11223");
                EmployeeDataTable.Rows.Add(103, "XYZ", "XYZ@dotnettutorials.net", "23432");

                //Following Rows are going to be Inserted
                EmployeeDataTable.Rows.Add(106, "A", "A@dotnettutorials.net", "12345");
                EmployeeDataTable.Rows.Add(107, "B", "B@dotnettutorials.net", "23456");
                EmployeeDataTable.Rows.Add(108, "C", "C@dotnettutorials.net", "34567");
                EmployeeDataTable.Rows.Add(109, "D", "D@dotnettutorials.net", "45678");
                EmployeeDataTable.Rows.Add(110, "E", "E@dotnettutorials.net", "56789");
                EmployeeDataTable.Rows.Add(111, "F", "F@dotnettutorials.net", "67890");

                //Creating the connection object
                using (SqlConnection connection = new SqlConnection(ConnectionString))
                {
                    //You can pass any stored procedure
                    //As I am using Higher version of SQL Server, so, I am using the Stored Procedure which uses MERGE Function
                    using (SqlCommand cmd = new SqlCommand("SP_Bulk_Insert_Update_Employees", connection))
                    {
                        //Set the command type as StoredProcedure
                        cmd.CommandType = CommandType.StoredProcedure;

                        //Add the input parameter required by the stored procedure
                        cmd.Parameters.AddWithValue("@Employees", EmployeeDataTable);

                        //Open the connection
                        connection.Open();

                        //Execute the command
                        cmd.ExecuteNonQuery();
                    }
                }

                Console.WriteLine("BULK INSERT UPDATE Successful");
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


##### **Example to Understand Batch Operations in C# ADO.NET**

```sql 
CREATE DATABASE EmployeeDB;
GO

USE EmployeeDB;
GO

CREATE TABLE Employee(
 Id INT IDENTITY(100, 1) PRIMARY KEY,
 Name VARCHAR(100),
 Email VARCHAR(50),
 Mobile VARCHAR(50),
)
GO

INSERT INTO Employee VALUES ('Anurag','Anurag@dotnettutorial.net','1234567890')
INSERT INTO Employee VALUES ('Priyanka','Priyanka@dotnettutorial.net','2233445566')
INSERT INTO Employee VALUES ('Preety','Preety@dotnettutorial.net','6655443322')
INSERT INTO Employee VALUES ('Sambit','Sambit@dotnettutorial.net','9876543210')
GO

```
##### **Batch INSERT Operations in C# using ADO.NET DataAdapter:**

![[word-image-32820-2.webp]]

**Let us understand the above code in detail step by step:**

1. **Step 1:** Create an Instance of SqlDataAdapter class as using this instance we are going to perform the Batch Insert Operation.
2. **Step 2:** As we are going to perform the Batch INSERT, so we need to set the InsertCommand property of the SqlDataAdapter instance to the command object. The command object must include the command text (i.e. the INSERT Query) and connection object where we want to execute the INSERT query.
3. **Step 3:** Then we need to add the parameters which are required for our INSERT query. You can see, in our INSERT query, we are using three parameters i.e. @Name, @Email, @Mobile. So, we need to add these parameters in the Parameters collection and also, we need to specify the source column name from where the value is coming i.e. the data table column names.
4. **Step 4:** In the next step, we need to set the UpdateRowSource property value to None as we are simply going to ignore the output parameter and return values.
5. **Step 5:** Next, we need to set the batch size i.e. how many rows or records we want to send to the database server as a batch.
6. **Step 6:** Finally, we need to call the Update method on the SqlDataAdapter instance by passing the data table and the data table should have some data to be inserted into the database.
```C#
using System;
using System.Data;
using System.Data.SqlClient;

namespace BatchOperationUsingSqlDataAdapter
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                //Creating Data Table
                DataTable EmployeeDataTable = new DataTable("Employees");

                //Add Columns to the Data Table as per the columns defined in the Table Type Parameter
                DataColumn Name = new DataColumn("Name");
                EmployeeDataTable.Columns.Add(Name);

                DataColumn Email = new DataColumn("Email");
                EmployeeDataTable.Columns.Add(Email);

                DataColumn Mobile = new DataColumn("Mobile");
                EmployeeDataTable.Columns.Add(Mobile);

                //Follwoing Rows are going to be Inserted
                EmployeeDataTable.Rows.Add("A", "A@dotnettutorials.net", "12345");
                EmployeeDataTable.Rows.Add("B", "B@dotnettutorials.net", "23456");
                EmployeeDataTable.Rows.Add( "C", "C@dotnettutorials.net", "34567");
                EmployeeDataTable.Rows.Add( "D", "D@dotnettutorials.net", "45678");
                EmployeeDataTable.Rows.Add( "E", "E@dotnettutorials.net", "56789");
                EmployeeDataTable.Rows.Add( "F", "F@dotnettutorials.net", "67890");

                BatchInsert(EmployeeDataTable, 3);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Exception Occurred: {ex.Message}");
            }

            Console.ReadKey();
        }
        public static void BatchInsert(DataTable dataTable, int batchSize)
        {
            // connection string.  
            string connectionString = @"data source=LAPTOP-ICA2LCQL\SQLEXPRESS; database=EmployeeDB; integrated security=SSPI";

            // Connect to the EmployeeDB database.  
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                // Create a SqlDataAdapter object 
                SqlDataAdapter adapter = new SqlDataAdapter();

                // Set the INSERT Command and Parameter.  
                string InsertQuery = "INSERT INTO Employee (Name, Email, Mobile) VALUES (@Name, @Email, @Mobile);";
                adapter.InsertCommand = new SqlCommand(InsertQuery, connection);
                adapter.InsertCommand.Parameters.Add("@Name", SqlDbType.NVarChar, 50, "Name");
                adapter.InsertCommand.Parameters.Add("@Email", SqlDbType.NVarChar, 50, "Email");
                adapter.InsertCommand.Parameters.Add("@Mobile", SqlDbType.NVarChar, 50, "Mobile");
                //Set UpdatedRowSource value as None
                adapter.InsertCommand.UpdatedRowSource = UpdateRowSource.None;

                // Set the batch size.  
                adapter.UpdateBatchSize = batchSize;

                // Execute the update.  
                adapter.Update(dataTable);

                Console.WriteLine($"Batch Insert with size {batchSize} Successful");
            }
        }
    }
} 

```

##### **Batch UPDATE Operations in C# using ADO.NET DataAdapter:**

```C#
using System;
using System.Data;
using System.Data.SqlClient;

namespace BatchOperationUsingSqlDataAdapter
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                // Connection string.  
                string connectionString = @"data source=LAPTOP-ICA2LCQL\SQLEXPRESS; database=EmployeeDB; integrated security=SSPI";

                // Connect to the EmployeeDB database.  
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    // Create a SqlDataAdapter  
                    SqlDataAdapter adapter = new SqlDataAdapter("SELECT * FROM EMPLOYEE", connection);
                    //Fetch the Employee Data and Store it in the DataTable
                    DataTable dataTable = new DataTable();
                    adapter.Fill(dataTable);

                    // Set the UPDATE command and parameters.
                    string UpdateQuery = "UPDATE Employee SET Name=@Name, Email=@Email, Mobile=@Mobile WHERE ID=@EmployeeID;";
                    adapter.UpdateCommand = new SqlCommand(UpdateQuery, connection);
                    adapter.UpdateCommand.Parameters.Add("@Name", SqlDbType.NVarChar, 50, "Name");
                    adapter.UpdateCommand.Parameters.Add("@Email", SqlDbType.NVarChar, 50, "Email");
                    adapter.UpdateCommand.Parameters.Add("@Mobile", SqlDbType.NVarChar, 50, "Mobile");
                    adapter.UpdateCommand.Parameters.Add("@EmployeeID", SqlDbType.Int, 4, "ID");
                    //Set UpdatedRowSource value as None
                    //Any Returned parameters or rows are Ignored.
                    adapter.UpdateCommand.UpdatedRowSource = UpdateRowSource.None;

                    //Change the Column Values of Few Rows
                    DataRow Row1 = dataTable.Rows[0];
                    Row1["Name"] = "Name Changed";
                    DataRow Row2 = dataTable.Rows[1];
                    Row2["Email"] = "Email Changed";
                    DataRow Row3 = dataTable.Rows[2];
                    Row2["Mobile"] = "Mobile Changed";

                    // Set the batch size.  
                    adapter.UpdateBatchSize = 2;

                    // Execute the update.  
                    adapter.Update(dataTable);

                    Console.WriteLine($"Batch UPDATE with size 2 Successful");
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

##### **Batch DELETE Operations in C# using ADO.NET DataAdapter in C#:**
```C#
using System;
using System.Data;
using System.Data.SqlClient;

namespace BatchOperationUsingSqlDataAdapter
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                // Connection string.  
                string connectionString = @"data source=LAPTOP-ICA2LCQL\SQLEXPRESS; database=EmployeeDB; integrated security=SSPI";

                // Connect to the EmployeeDB database.  
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    // Create a SqlDataAdapter  
                    SqlDataAdapter adapter = new SqlDataAdapter("SELECT * FROM EMPLOYEE WHERE Id > 105", connection);
                    //Fetch the Employee Data and Store it in the DataTable
                    DataTable dataTable = new DataTable();
                    adapter.Fill(dataTable);

                    // Set the DELETE command and parameter.
                    string DeleteQuery = "DELETE FROM Employee WHERE ID=@EmployeeID;";
                    adapter.DeleteCommand = new SqlCommand(DeleteQuery, connection);
                    adapter.DeleteCommand.Parameters.Add("@EmployeeID", SqlDbType.Int, 4, "Id");
                    //Set UpdatedRowSource value as None
                    adapter.DeleteCommand.UpdatedRowSource = UpdateRowSource.None;

                    // Set the batch size.  
                    adapter.UpdateBatchSize = 2;

                    foreach (DataRow row in dataTable.Rows)
                    {
                        //Delete the Data Row from the Data Table
                        row.Delete();
                    }

                    // Execute the update.  
                    adapter.Update(dataTable);

                    Console.WriteLine($"Batch DELETE with size 2 Successful");
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

##### **erforming Batch INSERT, UPDATE, and DELETE using a Single Update:**

![[word-image-29911-6-2.webp]]


##### **Example to Understand Batch INSERT, UPDATE and DELETE Operations in C# using Data Adapter:**

```sql
TRUNCATE TABLE Employee;

GO

INSERT INTO Employee VALUES ('Anurag','Anurag@dotnettutorial.net','1234567890')

INSERT INTO Employee VALUES ('Priyanka','Priyanka@dotnettutorial.net','2233445566')

INSERT INTO Employee VALUES ('Preety','Preety@dotnettutorial.net','6655443322')

INSERT INTO Employee VALUES ('Sambit','Sambit@dotnettutorial.net','9876543210')

GO
```

```C#
using System;
using System.Data;
using System.Data.SqlClient;
namespace BatchOperationUsingSqlDataAdapter
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                BatchUpdate();
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Exception Occurred: {ex.Message}");
            }

            Console.ReadKey();
        }

        public static void BatchUpdate()
        {
            // Connection string  
            string connectionString = @"data source=LAPTOP-ICA2LCQL\SQLEXPRESS; database=EmployeeDB; integrated security=SSPI";

            // Connect to the EmployeeDB database.  
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                // Create SqlDataAdapter Instance and Fetch the Employee data and store in the Data Table 
                SqlDataAdapter adapter = new SqlDataAdapter("SELECT * FROM EMPLOYEE", connection);
                DataTable EmployeeDataTable = new DataTable();
                adapter.Fill(EmployeeDataTable);

                //Add Few Records into the DataTable
                //These Data Row has been added to a DataRowCollection, and
                //the AcceptChange method has not been called.
                //This will cause the InsertCommand to fire in a Batch operation
                //while performing using ADO.NET Data Adapter.
                EmployeeDataTable.Rows.Add(104, "Pranaya", "Pranaya@dotnettutorials.net", "1234512345");
                EmployeeDataTable.Rows.Add(105, "Kumar", "Kumar@dotnettutorials.net", "2345623456");
                
                // Set the INSERT Command and the required Parameter.  
                string InsertQuery = "INSERT INTO Employee (Name, Email, Mobile) VALUES (@Name, @Email, @Mobile);";
                adapter.InsertCommand = new SqlCommand(InsertQuery, connection);
                adapter.InsertCommand.Parameters.Add("@Name", SqlDbType.NVarChar, 50, "Name");
                adapter.InsertCommand.Parameters.Add("@Email", SqlDbType.NVarChar, 50, "Email");
                adapter.InsertCommand.Parameters.Add("@Mobile", SqlDbType.NVarChar, 50, "Mobile");
                adapter.InsertCommand.UpdatedRowSource = UpdateRowSource.None;

                // Set the UPDATE command and parameters.
                string UpdateQuery = "UPDATE Employee SET Name=@Name, Email=@Email, Mobile=@Mobile WHERE ID=@EmployeeID;";
                adapter.UpdateCommand = new SqlCommand(UpdateQuery, connection);
                adapter.UpdateCommand.Parameters.Add("@Name", SqlDbType.NVarChar, 50, "Name");
                adapter.UpdateCommand.Parameters.Add("@Email", SqlDbType.NVarChar, 50, "Email");
                adapter.UpdateCommand.Parameters.Add("@Mobile", SqlDbType.NVarChar, 50, "Mobile");
                adapter.UpdateCommand.Parameters.Add("@EmployeeID", SqlDbType.Int, 4, "ID");
                adapter.UpdateCommand.UpdatedRowSource = UpdateRowSource.None;

                //Change the Column Values of Few Rows
                //These rows has been modified and the AcceptChanges has not been called.
                //This will cause the UpdateCommand to fire in a Batch operation
                //while performing using ADO.NET Data Adapter.
                DataRow Row1 = EmployeeDataTable.Rows[0];
                Row1["Name"] = "Name Changed";
                DataRow Row2 = EmployeeDataTable.Rows[1];
                Row2["Email"] = "Email Changed";
                // Set the DELETE command and its required parameter.
                string DeleteQuery = "DELETE FROM Employee WHERE ID=@EmployeeID;";
                adapter.DeleteCommand = new SqlCommand(DeleteQuery, connection);
                adapter.DeleteCommand.Parameters.Add("@EmployeeID", SqlDbType.Int, 4, "Id");
                adapter.DeleteCommand.UpdatedRowSource = UpdateRowSource.None;
                foreach (DataRow row in EmployeeDataTable.Rows)
                {
                    //Delete Third and Fourth Row
                    if (Convert.ToInt32(row["Id"]) == 102 || Convert.ToInt32(row["Id"]) == 103)
                    {
                        //The Data Row has been deleted using the Delete method of the DataRow object.
                        //This will cause the DeleteCommand to fire in a Batch operation while performing
                        //using ADO.NET Data Adapter.
                        row.Delete();
                    }
                }
                // Set the batch size.  
                adapter.UpdateBatchSize = 2;
                // Execute the Update method
                adapter.Update(EmployeeDataTable);
                Console.WriteLine($"Batch Operations with size 2 Completed Successfully");
            }
        }
    }
}

```



##### **ADO.NET Connection-Oriented Data Access Architecture:**

![[word-image-32862-1.webp]]

```sql
CREATE DATABASE EmployeeDB;
GO

USE EmployeeDB;
GO

CREATE TABLE Employee(
 Id INT IDENTITY(100, 1) PRIMARY KEY,
 Name VARCHAR(100),
 Email VARCHAR(50),
 Mobile VARCHAR(50),
)
GO

INSERT INTO Employee VALUES ('Anurag','Anurag@dotnettutorial.net','1234567890')
INSERT INTO Employee VALUES ('Priyanka','Priyanka@dotnettutorial.net','2233445566')
INSERT INTO Employee VALUES ('Preety','Preety@dotnettutorial.net','6655443322')
INSERT INTO Employee VALUES ('Sambit','Sambit@dotnettutorial.net','9876543210')
GO

```

```C#
using System;
using System.Data.SqlClient;
namespace ConnectionOrientedArchitecture
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                string ConString = @"data source=LAPTOP-ICA2LCQL\SQLEXPRESS; database=EmployeeDB; integrated security=SSPI";
                using (SqlConnection connection = new SqlConnection(ConString))
                {
                    // Creating the command object
                    SqlCommand cmd = new SqlCommand("select Name, Email, Mobile from Employee", connection);

                    // Opening Connection  
                    connection.Open();

                    // Executing the SQL query  
                    SqlDataReader sdr = cmd.ExecuteReader();

                    //Looping through each record
                    //SqlDataReader works in Connection Oriented Architecture
                    //So, it requires an active and open connection while reading the data
                    //from the database
                    while (sdr.Read())
                    {
                        Console.WriteLine(sdr["Name"] + ",  " + sdr["Email"] + ",  " + sdr["Mobile"]);
                    }
                }//Here, the connection is going to be closed automatically
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

##### **Using ADO.NET Data Reader to Fetch the Data from the Database:**

```C#
using System;
using System.Data.SqlClient;
namespace ConnectionOrientedArchitecture
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                string ConString = @"data source=LAPTOP-ICA2LCQL\SQLEXPRESS; database=EmployeeDB; integrated security=SSPI";
                using (SqlConnection connection = new SqlConnection(ConString))
                {
                    // Creating the command object
                    SqlCommand cmd = new SqlCommand("select Name, Email, Mobile from Employee", connection);

                    // Opening Connection  
                    connection.Open();

                    // Executing the SQL query  
                    SqlDataReader sdr = cmd.ExecuteReader();

                    //Looping through each record
                    //SqlDataReader works in Connection Oriented Architecture
                    //So, it requires an active and open connection while reading the data
                    //from the database
                    while (sdr.Read())
                    {
                        Console.WriteLine(sdr["Name"] + ",  " + sdr["Email"] + ",  " + sdr["Mobile"]);
                    }
                }//Here, the connection is going to be closed automatically
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
using System.Data.SqlClient;
namespace ConnectionOrientedArchitecture
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                string ConString = @"data source=LAPTOP-ICA2LCQL\SQLEXPRESS; database=EmployeeDB; integrated security=SSPI";
                using (SqlConnection connection = new SqlConnection(ConString))
                {
                    // Creating the command object
                    SqlCommand cmd = new SqlCommand("select Name, Email, Mobile from Employee", connection);

                    // Opening Connection  
                    connection.Open();

                    // Executing the SQL query  
                    SqlDataReader sdr = cmd.ExecuteReader();

                    //Looping through each record
                    //SqlDataReader works in Connection Oriented Architecture
                    //So, it requires an active and open connection while reading the data
                    //from the database
                    while (sdr.Read())
                    {
                        //Read-only, you cannot modify the data
                        //sdr["Name"] = "PKR";
                        Console.WriteLine(sdr["Name"] + ",  " + sdr["Email"] + ",  " + sdr["Mobile"]);
                        connection.Close();//Here, the connection is closed
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

##### **ADO.NET Disconnection-Oriented Data Access Architecture:**

![[word-image-32862-5.webp]]

```C#
using System;
using System.Data;
using System.Data.SqlClient;
namespace BatchOperationUsingSqlDataAdapter
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                // Connection string.  
                string connectionString = @"data source=LAPTOP-ICA2LCQL\SQLEXPRESS; database=EmployeeDB; integrated security=SSPI";

                // Connect to the EmployeeDB database.  
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    // Create a SqlDataAdapter  
                    SqlDataAdapter adapter = new SqlDataAdapter("SELECT * FROM EMPLOYEE", connection);
                    //Fetch the Employee Data and Store it in the DataTable
                    DataTable dataTable = new DataTable();

                    //The Fill method will open the connection, fetch the data, fill the data in
                    //the data table and close the connection automatically
                    adapter.Fill(dataTable); 

                    // Set the UPDATE command and parameters.
                    string UpdateQuery = "UPDATE Employee SET Name=@Name, Email=@Email, Mobile=@Mobile WHERE ID=@EmployeeID;";
                    adapter.UpdateCommand = new SqlCommand(UpdateQuery, connection);
                    adapter.UpdateCommand.Parameters.Add("@Name", SqlDbType.NVarChar, 50, "Name");
                    adapter.UpdateCommand.Parameters.Add("@Email", SqlDbType.NVarChar, 50, "Email");
                    adapter.UpdateCommand.Parameters.Add("@Mobile", SqlDbType.NVarChar, 50, "Mobile");
                    adapter.UpdateCommand.Parameters.Add("@EmployeeID", SqlDbType.Int, 4, "ID");
                    //Set UpdatedRowSource value as None
                    //Any Returned parameters or rows are Ignored.
                    adapter.UpdateCommand.UpdatedRowSource = UpdateRowSource.None;

                    //Change the Column Values of Few Rows
                    DataRow Row1 = dataTable.Rows[0];
                    Row1["Name"] = "Name Changed";
                    DataRow Row2 = dataTable.Rows[1];
                    Row2["Email"] = "Email Changed";
                    DataRow Row3 = dataTable.Rows[2];
                    Row2["Mobile"] = "Mobile Changed";

                    // Execute the update.  
                    //The Update method will open the connection, execute the Update command by takking
                    //the data table data and then close the connection automatically
                    adapter.Update(dataTable);

                    Console.WriteLine($"Updated Data Saved into the DataBase");
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

## **ADO.NET SqlCommandBuilder in C#**

Step 1: First create an instance of the ADO.NET SqlDataAdapter class and then we need to set the SelectCommand property of the SqlDataAdapter object to one select query as follows:  
**SqlDataAdapter dataAdapter = new SqlDataAdapter();**  
**dataAdapter.SelectCommand = new SqlCommand(“SELECT * FROM Employee”, connection);**

Step 2: In the next step, we need to create an instance of SqlCommandBuilder class and we also need to store the SqlDataAdapter object created in step1 with the DataAdapter property of the SqlCommandBuilder object as follows:  
**SqlCommandBuilder commandBuilder = new SqlCommandBuilder();**  
**commandBuilder.DataAdapter = dataAdapter;**

```sql
CREATE DATABASE EmployeeDB
GO

Use EmployeeDB
GO

CREATE TABLE Employee
(
 ID INT IDENTITY PRIMARY KEY,
 Name VARCHAR(50),
 Gender VARCHAR(20),
 Salary INT,
 Department VARCHAR(50)
)
GO

INSERT INTO Employee VALUES('Pranaya Kumar','Male', 9000, 'IT')
INSERT INTO Employee VALUES('Priyanka Dewangan','Female', 7600, 'HR')
INSERT INTO Employee VALUES('Anurag Mohanty','Male', 9800, 'IT')
INSERT INTO Employee VALUES('Rakesh Kumar','Male', 9900, 'IT')
INSERT INTO Employee VALUES('Tarun Mallick','Male', 4400, 'HR')
INSERT INTO Employee VALUES('Santosh Jena','Male', 3200, 'HR')
INSERT INTO Employee VALUES('Bikash Rout','Male', 9830, 'HR')
INSERT INTO Employee VALUES('Rohit Sharma','Male', 7200, 'IT')
INSERT INTO Employee VALUES('Preety Tiwari','Female', 8700, 'IT')
INSERT INTO Employee VALUES('Hina Sharma','Female', 6800, 'HR')
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
            string ConnectionString = @"data source=LAPTOP-ICA2LCQL\SQLEXPRESS; database=EmployeeDB; integrated security=SSPI";
            using (SqlConnection connection = new SqlConnection(ConnectionString))
            {
                //Create the SqlDataAdapter instance by specifying the command text and connection object
                SqlDataAdapter dataAdapter = new SqlDataAdapter("SELECT * FROM Employee WHERE Gender='Male'", connection);

                //SqlDataAdapter dataAdapter = new SqlDataAdapter();
                //dataAdapter.SelectCommand = new SqlCommand("SELECT * FROM Employee WHERE Gender='Male'", connection);

                // Associate SqlDataAdapter object with SqlCommandBuilder.
                // At this point SqlCommandBuilder should generate T-SQL statements automatically
                SqlCommandBuilder commandBuilder = new SqlCommandBuilder(dataAdapter);

                //SqlCommandBuilder commandBuilder = new SqlCommandBuilder();
                //commandBuilder.DataAdapter = dataAdapter;

                //Creating DataSet Object
                DataSet dataSet = new DataSet();

                //Filling the DataSet using the Fill Method of SqlDataAdapter object
                dataAdapter.Fill(dataSet);

                //Iterating through the DataSet 
                foreach (DataRow row in dataSet.Tables[0].Rows)
                {
                    //Accessing the Data using the string column name as key
                    Console.WriteLine($"Id: {row["Id"]}, Name: {row[1]}, Salary: {row[2]}, Gender: {row["Gender"]}, Department: {row["Department"]}");
                }

                //Now Update First Row i.e. Index Position 0
                DataRow dataRow = dataSet.Tables[0].Rows[0];
                dataRow["Name"] = "Name Updated";
                dataRow["Gender"] = "Female";
                dataRow["Salary"] = 50000;
                dataRow["Department"] = "Payroll";

                //Provide the DataSet and the DataTable name to the Update method
                //Here, SqlCommandBuilder will automatically generate the UPDATE SQL Statement 
                int rowsUpdated = dataAdapter.Update(dataSet, dataSet.Tables[0].TableName);

                //The GetUpdateCommand() method will return the auto generated UPDATE Command
                Console.WriteLine($"\nUPDATE Command: {commandBuilder.GetUpdateCommand().CommandText}");
                if (rowsUpdated == 0)
                {
                    Console.WriteLine("\nNo Rows Updated");
                }
                else
                {
                    Console.WriteLine($"\n{rowsUpdated} Row(s) Updated");
                }

                //First fetch the DataTable
                DataTable EmployeeTable = dataSet.Tables[0];

                //Create a new Row
                DataRow newRow = EmployeeTable.NewRow();
                newRow["Name"] = "Pranaya Rout";
                newRow["Gender"] = "Male";
                newRow["Salary"] = 450000;
                newRow["Department"] = "Payroll";
                EmployeeTable.Rows.Add(newRow);

                //Provide the DataSet and the DataTable name to the Update method
                //Here, SqlCommandBuilder will automatically generate the INSERT SQL Statement
                int rowsInserted = dataAdapter.Update(dataSet, dataSet.Tables[0].TableName);

                //The GetInsertCommand() method will return the auto generated INSERT Command
                Console.WriteLine($"\nINSERT Command: {commandBuilder.GetInsertCommand().CommandText}");
                if (rowsInserted == 0)
                {
                    Console.WriteLine("\nNo Rows Inserted");
                }
                else
                {
                    Console.WriteLine($"\n{rowsUpdated} Row(s) Inserted");
                }

                //Now Delete 3nd Row i.e. Index Position 2
                dataSet.Tables[0].Rows[2].Delete();
                //Provide the DataSet and the DataTable name to the Update method
                //Here, SqlCommandBuilder will automatically generate the DELETE SQL Statement
                int rowsDeleted = dataAdapter.Update(dataSet, dataSet.Tables[0].TableName);

                //The GetDeleteCommand() method will return the auto generated DELETE Command
                Console.WriteLine($"\nDELETE Command: {commandBuilder.GetDeleteCommand().CommandText}");
                if (rowsDeleted == 0)
                {
                    Console.WriteLine("\nNo Rows Deleted");
                }
                else
                {
                    Console.WriteLine($"\n{rowsUpdated} Row(s) Deleted");
                }
            }

            Console.ReadKey();
        }
    }
}

```

