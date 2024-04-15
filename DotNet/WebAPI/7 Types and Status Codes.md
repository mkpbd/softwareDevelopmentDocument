# HTTP Status Codes in ASP.NET Core Web API

##### **Successful Responses**

- **200 OK** – The HTTP 200 OK success status response code indicates that the request has succeeded. This is often used for GET and POST requests that are processed successfully.
- **201 Created** – The request has succeeded, and a new resource has been created as a result. This is typically used in response to a POST request.
- **202 Accepted**– The 202 Status Code indicates that the request has been accepted for processing, but the processing has not been completed. 
- **204 No Content** – The server successfully processed the request but is not returning any content. This is often used for DELETE requests.

###### **Redirection Messages**

- **301 Moved Permanently –** This response code indicates that the URI of the requested resource has been changed permanently. Future requests should use the new URI.
- **302 Found:** This response code indicates that the resource is temporarily under a different URI. As the redirection might be altered occasionally, the client should continue using the original URI for future requests.

##### **Client Error Responses**

- **400 Bad Request –** The server cannot or will not process the request due to something that is perceived to be a client error (e.g., malformed request syntax).
- **401 Unauthorized** – Although the HTTP standard specifies “unauthorized”, semantically, this response means “unauthenticated”. That is, the client must authenticate itself to get the requested response.
- **403 Forbidden** – The client does not have access rights to the content; that is, it is unauthorized, so the server refuses to give the requested resource. Unlike 401, the client’s identity is known to the server.
- **404 Not Found** – The server can not find the requested resource. In the browser, this means the URL is not recognized. In an API, this can also mean that the endpoint is valid, but the resource itself does not exist.
- **405 Method Not Allowed** – The 405 Method Not Allowed response status code indicates that the server knows the request method but is not supported by the target resource. For example, we have one method which is a POST method in the server and we trying to access that method from the client using GET Verb, then, in that case, you will get a 405-status code.

##### **Server Error Responses**

- **500 Internal Server Error –** The server has encountered a situation it doesn’t know how to handle.
- **501 Not Implemented –** The server either does not recognize the request method or lacks the ability to fulfil the request.
- **503 Service Unavailable –** The server is not ready to handle the request. Common causes include a server that is down for maintenance or overloaded.
- **504 Gateway Timeout.** The 504 Gateway Timeout server error response code indicates that the server while acting as a gateway or proxy, did not get a response in time from the upstream server that is needed to complete the request.

### **200 HTTP Status Code:**

In ASP.NET Core Web API, the HTTP status code 200 OK indicates that a request has been successfully processed. This status code is commonly used in RESTful APIs for GET, PUT, POST, and DELETE operations when they are completed successfully and, in some cases, return data.

##### **Returning Ok():**

![[word-image-43851-1-1 1.webp]]
![[word-image-43851-2-1 1.webp]]
![[word-image-43851-3-1 1.webp]]
![[word-image-43851-4-1 1.webp]]
![[word-image-43851-5-1 1.webp]]

```C#
using Microsoft.AspNetCore.Mvc;
namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        [HttpGet("GetEmployees")]
        public IActionResult GetEmployees()
        {
            //Do Some Operation
            return Ok();
        }
    }
}

```

![[word-image-43851-6 1.webp]]

##### **Creating Employee Model:**

```C#
namespace ReturnTypeAndStatusCodes.Models
{
    public class Employee
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Gender { get; set; }
        public string City { get; set; }
        public int Age { get; set; }
        public string Department { get; set; }
    }
}

```

```C#
using ReturnTypeAndStatusCodes.Models;
using Microsoft.AspNetCore.Mvc;
namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        [HttpGet("GetEmployees")]
        public ActionResult<List<Employee>> GetEmployees()
        {
            var listEmployees = new List<Employee>()
            {
                new Employee(){ Id = 1001, Name = "Anurag", Age = 28, City = "Mumbai", Gender = "Male", Department = "IT" },
                new Employee(){ Id = 1002, Name = "Pranaya", Age = 28, City = "Delhi", Gender = "Male", Department = "IT" },
                new Employee(){ Id = 1003, Name = "Priyanka", Age = 27, City = "BBSR", Gender = "Female", Department = "HR"},
            };

            return Ok(listEmployees);
        }
    }
}

```

![[DotNet/WebAPI/apiImages/word-image-43851-7.webp]]

##### **Returning OkObjectResult Directly**

```C#
using ReturnTypeAndStatusCodes.Models;
using Microsoft.AspNetCore.Mvc;
namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        [HttpGet("GetEmployees")]
        public ActionResult<List<Employee>> GetEmployees()
        {
            var listEmployees = new List<Employee>()
            {
                new Employee(){ Id = 1001, Name = "Anurag", Age = 28, City = "Mumbai", Gender = "Male", Department = "IT" },
                new Employee(){ Id = 1002, Name = "Pranaya", Age = 28, City = "Delhi", Gender = "Male", Department = "IT" },
                new Employee(){ Id = 1003, Name = "Priyanka", Age = 27, City = "BBSR", Gender = "Female", Department = "HR"},
            };

            return new OkObjectResult(listEmployees); // Equivalent to Ok(listEmployees)
        }
    }
}

```

##### **Manual Status Code Setting in ASP.NET Core Web API**

```C#
using ReturnTypeAndStatusCodes.Models;
using Microsoft.AspNetCore.Mvc;
namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        [HttpGet("GetEmployees")]
        public ActionResult<List<Employee>> GetEmployees()
        {
            var listEmployees = new List<Employee>()
            {
                new Employee(){ Id = 1001, Name = "Anurag", Age = 28, City = "Mumbai", Gender = "Male", Department = "IT" },
                new Employee(){ Id = 1002, Name = "Pranaya", Age = 28, City = "Delhi", Gender = "Male", Department = "IT" },
                new Employee(){ Id = 1003, Name = "Priyanka", Age = 27, City = "BBSR", Gender = "Female", Department = "HR"},
            };

            return StatusCode(200, listEmployees); // Manually setting 200 OK
        }
    }
}

```

##### **200 HTTP Status Code Real-Time Examples in ASP.NET Core Web API**

```C#
namespace ReturnTypeAndStatusCodes.Models
{
    public class Employee
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Gender { get; set; }
        public int Age { get; set; }
        public string Department { get; set; }
    }
}

```

##### **Modifying the Employee Controller:**

```C#
using ReturnTypeAndStatusCodes.Models;
using Microsoft.AspNetCore.Mvc;
namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        //Data Source
        private static List<Employee> Employees = new List<Employee>
        {
            new Employee { Id = 1, Name = "Rakesh", Age = 25, Gender = "Male", Department = "IT" },
            new Employee { Id = 2, Name = "Hina", Age = 26, Gender = "Female", Department = "HR" },
            new Employee { Id = 3, Name = "Suresh", Age = 27, Gender = "Male", Department = "IT" },
        };

        //URL: GET /api/employee
        [HttpGet]
        public ActionResult<Employee> GetAllEmployees()
        {
            // 200 OK with all the employees in the response body
            return Ok(Employees);
        }

        //URL: GET /api/employee/1
        [HttpGet("{id}")]
        public ActionResult<Employee> GetEmployee(int id)
        {
            var employee = Employees.FirstOrDefault(emp => emp.Id == id); 
            if (employee == null)
            {
                // 404 Not Found if the employee does not exist
                return NotFound(); 
            }
            // 200 OK with the employee in the response body
            return Ok(employee); 
        }

        //URL:POST /api/employee
        [HttpPost]
        public ActionResult<Employee> CreateOrUpdateEmployee(Employee employee)
        {
            var existingEmployee = Employees.FirstOrDefault(emp => emp.Id == employee.Id);
            if (existingEmployee != null)
            {
                // Update the existing employee
                existingEmployee.Name = employee.Name;
                existingEmployee.Age = employee.Age;
                existingEmployee.Gender = employee.Gender;
                employee.Department = employee.Department;

                // 200 OK with the updated employee
                return Ok(existingEmployee); 
            }
            else
            {
                // Add a new employee
                employee.Id = Employees.Count() + 1;
                Employees.Add(employee); 
                return CreatedAtAction(nameof(GetEmployee), new { id = employee.Id }, employee);
            }
        }

        //URL:PUT /api/employee/1
        [HttpPut("{id}")]
        public ActionResult<Employee> UpdateEmployee(int id, Employee employee)
        {
            if (id != employee.Id)
            {
                // 400 Bad Request if the ID does not match
                return BadRequest();
            }

            var existingEmployee = Employees.FirstOrDefault(emp => emp.Id == employee.Id);
            if (existingEmployee == null)
            {
                // 404 Not Found if the employee does not exist
                return NotFound(); 
            }

            // Update the existing employee
            existingEmployee.Name = employee.Name;
            existingEmployee.Age = employee.Age;
            existingEmployee.Gender = employee.Gender;
            employee.Department = employee.Department;

            // 200 OK with the updated employee
            return Ok(existingEmployee); 
        }

        //URL:DELETE /api/employee/1
        [HttpDelete("{id}")]
        public ActionResult<Employee> DeleteEmployee(int id)
        {
            var employee = Employees.FirstOrDefault(emp => emp.Id == id);
            if (employee == null)
            {
                // 404 Not Found if the employee does not exist
                return NotFound(); 
            }

            // Delete the employee
            Employees.Remove(employee); 
            return Ok(employee); // 200 OK with the deleted employee's details
        }
    }
}

```
- **Returning 200 OK for a GET Request:** A GET request retrieves data. The 200 OK Response often includes the requested data in the body.
- **Returning 200 OK for a POST Request:** Although it’s more common to return a 201 Created for a POST request, there are scenarios where you might want to return 200 OK, especially if the operation is idempotent and the resource already exists.
- **Returning 200 OK for a PUT Request:** A PUT request is typically used for updating resources. A 200 OK response indicates that the update was successful.
- **Returning 200 OK for a DELETE Request:** While a 204 No Content response is commonly used for DELETE operations to indicate success without returning any content, you can also use 200 OK if you want to return information about the deleted resource.

##### **Testing the APIs:**

You can test the APIs in many ways, like using Postman, Fiddler, and Swagger. But .NET 8 provides the .http file, and using that .http file, we can also test the functionality very easily.

```http
@MyFirstWebAPIProject_HostAddress = https://localhost:7128

### Get All Employees
GET {{MyFirstWebAPIProject_HostAddress}}/api/employee
Accept: application/json
###

### Get Employee with ID 1
GET {{MyFirstWebAPIProject_HostAddress}}/api/employee/1
Accept: application/json
###

### Create a New Employee
POST {{MyFirstWebAPIProject_HostAddress}}/api/employee
Content-Type: application/json

{
  "name": "Suresh",
  "gender": "Male",
  "age": 35,
  "department": "HR"
}

###

### Update Employee with ID 1
PUT {{MyFirstWebAPIProject_HostAddress}}/api/employee/1
Content-Type: application/json

{
    "Id": 1,
    "name": "Suresh",
    "gender": "Male",
    "age": 35,
    "department": "HR"
}

###

### Delete Employee with ID 1
DELETE {{MyFirstWebAPIProject_HostAddress}}/api/employee/1
###

```

##### **Using IActionResult and** **ActionResult** **as the Return Type:**

```C#
using ReturnTypeAndStatusCodes.Models;
using Microsoft.AspNetCore.Mvc;
namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        //Data Source
        private static List<Employee> Employees = new List<Employee>
        {
            new Employee { Id = 1, Name = "Rakesh", Age = 25, Gender = "Male", Department = "IT" },
            new Employee { Id = 2, Name = "Hina", Age = 26, Gender = "Female", Department = "HR" },
            new Employee { Id = 3, Name = "Suresh", Age = 27, Gender = "Male", Department = "IT" },
        };

        //URL: GET /api/employee
        [HttpGet]
        public ActionResult GetAllEmployees()
        {
            // 200 OK with all the employees in the response body
            return Ok(Employees);
        }

        //URL: GET /api/employee/1
        [HttpGet("{id}")]
        public ActionResult GetEmployee(int id)
        {
            var employee = Employees.FirstOrDefault(emp => emp.Id == id); 
            if (employee == null)
            {
                // 404 Not Found if the employee does not exist
                return NotFound(); 
            }
            // 200 OK with the employee in the response body
            return Ok(employee); 
        }

        //URL:POST /api/employee
        [HttpPost]
        public IActionResult CreateOrUpdateEmployee(Employee employee)
        {
            var existingEmployee = Employees.FirstOrDefault(emp => emp.Id == employee.Id);
            if (existingEmployee != null)
            {
                // Update the existing employee
                existingEmployee.Name = employee.Name;
                existingEmployee.Age = employee.Age;
                existingEmployee.Gender = employee.Gender;
                employee.Department = employee.Department;

                // 200 OK with the updated employee
                return Ok(existingEmployee); 
            }
            else
            {
                // Add a new employee
                employee.Id = Employees.Count() + 1;
                Employees.Add(employee); 
                return CreatedAtAction(nameof(GetEmployee), new { id = employee.Id }, employee);
            }
        }

        //URL:PUT /api/employee/1
        [HttpPut("{id}")]
        public IActionResult UpdateEmployee(int id, Employee employee)
        {
            if (id != employee.Id)
            {
                // 400 Bad Request if the ID does not match
                return BadRequest();
            }

            var existingEmployee = Employees.FirstOrDefault(emp => emp.Id == employee.Id);
            if (existingEmployee == null)
            {
                // 404 Not Found if the employee does not exist
                return NotFound(); 
            }

            // Update the existing employee
            existingEmployee.Name = employee.Name;
            existingEmployee.Age = employee.Age;
            existingEmployee.Gender = employee.Gender;
            employee.Department = employee.Department;

            // 200 OK with the updated employee
            return Ok(existingEmployee); 
        }

        //URL:DELETE /api/employee/1
        [HttpDelete("{id}")]
        public ActionResult<Employee> DeleteEmployee(int id)
        {
            var employee = Employees.FirstOrDefault(emp => emp.Id == id);
            if (employee == null)
            {
                // 404 Not Found if the employee does not exist
                return NotFound(); 
            }

            // Delete the employee
            Employees.Remove(employee); 
            return Ok(employee); // 200 OK with the deleted employee's details
        }
    }
}

```


```C# 
using ReturnTypeAndStatusCodes.Models;
using Microsoft.AspNetCore.Mvc;
namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        //Data Source
        private static List<Employee> Employees = new List<Employee>
        {
            new Employee { Id = 1, Name = "Rakesh", Age = 25, Gender = "Male", Department = "IT" },
            new Employee { Id = 2, Name = "Hina", Age = 26, Gender = "Female", Department = "HR" },
            new Employee { Id = 3, Name = "Suresh", Age = 27, Gender = "Male", Department = "IT" },
        };

        //URL: GET /api/employee
        [HttpGet]
        public async Task<ActionResult> GetAllEmployees()
        {
            //Do Some IO Bound Operation 
            //Delaying the Execution for 1000 MS
            await Task.Delay(TimeSpan.FromMilliseconds(1000));
            // 200 OK with all the employees in the response body
            return Ok(Employees);
        }

        //URL: GET /api/employee/1
        [HttpGet("{id}")]
        public async Task<ActionResult<Employee>> GetEmployee(int id)
        {
            //Do Some IO Bound Operation 
            //Delaying the Execution for 1000 MS
            await Task.Delay(TimeSpan.FromMilliseconds(1000));

            var employee = Employees.FirstOrDefault(emp => emp.Id == id); 
            if (employee == null)
            {
                // 404 Not Found if the employee does not exist
                return NotFound(); 
            }
            // 200 OK with the employee in the response body
            return Ok(employee); 
        }

        //URL:POST /api/employee
        [HttpPost]
        public async Task<IActionResult> CreateOrUpdateEmployee(Employee employee)
        {
            //Do Some IO Bound Operation 
            //Delaying the Execution for 1000 MS
            await Task.Delay(TimeSpan.FromMilliseconds(1000));

            var existingEmployee = Employees.FirstOrDefault(emp => emp.Id == employee.Id);
            if (existingEmployee != null)
            {
                // Update the existing employee
                existingEmployee.Name = employee.Name;
                existingEmployee.Age = employee.Age;
                existingEmployee.Gender = employee.Gender;
                employee.Department = employee.Department;

                // 200 OK with the updated employee
                return Ok(existingEmployee); 
            }
            else
            {
                // Add a new employee
                employee.Id = Employees.Count() + 1;
                Employees.Add(employee); 
                return CreatedAtAction(nameof(GetEmployee), new { id = employee.Id }, employee);
            }
        }

        //URL:PUT /api/employee/1
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateEmployee(int id, Employee employee)
        {
            //Do Some IO Bound Operation 
            //Delaying the Execution for 1000 MS
            await Task.Delay(TimeSpan.FromMilliseconds(1000));

            if (id != employee.Id)
            {
                // 400 Bad Request if the ID does not match
                return BadRequest();
            }

            var existingEmployee = Employees.FirstOrDefault(emp => emp.Id == employee.Id);
            if (existingEmployee == null)
            {
                // 404 Not Found if the employee does not exist
                return NotFound(); 
            }

            // Update the existing employee
            existingEmployee.Name = employee.Name;
            existingEmployee.Age = employee.Age;
            existingEmployee.Gender = employee.Gender;
            employee.Department = employee.Department;

            // 200 OK with the updated employee
            return Ok(existingEmployee); 
        }

        //URL:DELETE /api/employee/1
        [HttpDelete("{id}")]
        public ActionResult<Employee> DeleteEmployee(int id)
        {
            var employee = Employees.FirstOrDefault(emp => emp.Id == id);
            if (employee == null)
            {
                // 404 Not Found if the employee does not exist
                return NotFound(); 
            }

            // Delete the employee
            Employees.Remove(employee); 
            return Ok(employee); // 200 OK with the deleted employee's details
        }
    }
} 

```

# 201 HTTP Status Code in ASP.NET Core Web API

- **Meaning:** The 201 Status Code signifies that the server has successfully created a new resource as a result of the request. It is a positive acknowledgement from the server indicating that the operation requested by the client was successful.
- **Headers:** When a 201 Created status is returned, it is often accompanied by a Location header. This header specifies the URL of the newly created resource. The body of the response might also include a representation of the resource with details of its state.
- **Use Cases:** Common scenarios where a 201 Created Status Code might be returned include creating a new user account, posting a new message in a forum, uploading a file, or any action where a new entity is added to the server’s data store.

##### **How to Return 201 HTTP Status Code in ASP.NET Core Web API**

```C#
namespace ReturnTypeAndStatusCodes.Models
{
    public class Employee
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Gender { get; set; }
        public int Age { get; set; }
        public string Department { get; set; }
    }
}

```

##### **Using the CreatedAtAction Method in ASP.NET Core Web API**


```C#
using ReturnTypeAndStatusCodes.Models;
using Microsoft.AspNetCore.Mvc;
namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        //Data Source
        private static List<Employee> Employees = new List<Employee>
        {
            new Employee { Id = 1, Name = "Rakesh", Age = 25, Gender = "Male", Department = "IT" },
            new Employee { Id = 2, Name = "Hina", Age = 26, Gender = "Female", Department = "HR" },
            new Employee { Id = 3, Name = "Suresh", Age = 27, Gender = "Male", Department = "IT" },
        };

        [HttpPost]
        public ActionResult<Employee> CreateEmployee(Employee employee)
        {
            // Add and save employee in your database or storage
            employee.Id = Employees.Count + 1;
            Employees.Add(employee);

            // Assuming you have an API for getting the resource
            // GetEmployee is the name of the action method which takes the employee id and return the employee
            return CreatedAtAction(nameof(GetEmployee), new { id = employee.Id }, employee);
        }

        [HttpGet("{id}")]
        public ActionResult<Employee> GetEmployee(int id)
        {
            var employee = Employees.FirstOrDefault(emp => emp.Id == id);
            if (employee == null)
            {
                // 404 Not Found if the employee does not exist
                return NotFound();
            }
            // 200 OK with the employee in the response body
            return Ok(employee);
        }
    }
} 

```


![[word-image-47044-1.webp]]
![[word-image-47044-2.webp]]
![[word-image-47044-3.webp]]


##### **Using the CreatedAtRoute Method in ASP.NET Core Web API**


```C#
using ReturnTypeAndStatusCodes.Models;
using Microsoft.AspNetCore.Mvc;
namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        //Data Source
        private static List<Employee> Employees = new List<Employee>
        {
            new Employee { Id = 1, Name = "Rakesh", Age = 25, Gender = "Male", Department = "IT" },
            new Employee { Id = 2, Name = "Hina", Age = 26, Gender = "Female", Department = "HR" },
            new Employee { Id = 3, Name = "Suresh", Age = 27, Gender = "Male", Department = "IT" },
        };

        [HttpPost]
        public ActionResult<Employee> CreateEmployee(Employee employee)
        {
            // Add and save employee in your database or storage
            employee.Id = Employees.Count + 1;
            Employees.Add(employee);

            // Assuming you have a named route for getting the resource
            // GetGetEmployeeRoute is the Route name of the Resource which takes the id and return the employee
            return CreatedAtRoute("GetGetEmployeeRoute", new { id = employee.Id }, employee);
        }

        //Generate Resource with Route Name
        [HttpGet("{id}", Name = "GetGetEmployeeRoute")]
        public ActionResult<Employee> GetEmployee(int id)
        {
            var employee = Employees.FirstOrDefault(emp => emp.Id == id);
            if (employee == null)
            {
                // 404 Not Found if the employee does not exist
                return NotFound();
            }
            // 200 OK with the employee in the response body
            return Ok(employee);
        }
    }
}

```



```C#
using ReturnTypeAndStatusCodes.Models;
using Microsoft.AspNetCore.Mvc;
namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        //Data Source
        private static List<Employee> Employees = new List<Employee>
        {
            new Employee { Id = 1, Name = "Rakesh", Age = 25, Gender = "Male", Department = "IT" },
            new Employee { Id = 2, Name = "Hina", Age = 26, Gender = "Female", Department = "HR" },
            new Employee { Id = 3, Name = "Suresh", Age = 27, Gender = "Male", Department = "IT" },
        };

        [HttpPost]
        public ActionResult<Employee> CreateEmployee(Employee employee)
        {
            // Add and save employee in your database or storage
            employee.Id = Employees.Count + 1;
            Employees.Add(employee);

            // Assuming you have a named route for getting the resource
            // GetGetEmployeeRoute is the Route name of the Resource which takes the id and return the employee
            return CreatedAtRoute("GetGetEmployeeRoute", new { id = employee.Id }, employee);
        }

        //Generate Resource with Route Name
        [HttpGet("{id}", Name = "GetGetEmployeeRoute")]
        public ActionResult<Employee> GetEmployee(int id)
        {
            var employee = Employees.FirstOrDefault(emp => emp.Id == id);
            if (employee == null)
            {
                // 404 Not Found if the employee does not exist
                return NotFound();
            }
            // 200 OK with the employee in the response body
            return Ok(employee);
        }
    }
}

```


##### **How to Return 201 Status Code without Data:**


```C#
using ReturnTypeAndStatusCodes.Models;
using Microsoft.AspNetCore.Mvc;
namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        //Data Source
        private static List<Employee> Employees = new List<Employee>
        {
            new Employee { Id = 1, Name = "Rakesh", Age = 25, Gender = "Male", Department = "IT" },
            new Employee { Id = 2, Name = "Hina", Age = 26, Gender = "Female", Department = "HR" },
            new Employee { Id = 3, Name = "Suresh", Age = 27, Gender = "Male", Department = "IT" },
        };

        [HttpPost]
        public ActionResult<Employee> CreateEmployee(Employee employee)
        {
            // Add and save employee in your database or storage
            employee.Id = Employees.Count + 1;
            Employees.Add(employee);

            //CreatedAtRoute Method takes the Route name 
            //With the Newly Created Resource Data
            //GetGetEmployeeRoute is the Route Name
            //return CreatedAtRoute("GetGetEmployeeRoute", new { id = employee.Id }, employee);

            //Without the Newly Created Resource Data
            //GetGetEmployeeRoute is the Route Name
            //return CreatedAtRoute("GetGetEmployeeRoute", new { id = employee.Id }, null);

            //CreatedAtAction Method takes the Action Method
            //With the Newly Created Resource Data
            //GetEmployee is the Action Method Name
            //return CreatedAtAction("GetEmployee", new { id = employee.Id }, employee);

            //Without the Newly Created Resource Data
            //GetEmployee is the Action Method Name
            return CreatedAtAction("GetEmployee", new { id = employee.Id }, null);
        }

        //Generate Resource with Route Name
        [HttpGet("{id}", Name = "GetGetEmployeeRoute")]
        public ActionResult<Employee> GetEmployee(int id)
        {
            var employee = Employees.FirstOrDefault(emp => emp.Id == id);
            if (employee == null)
            {
                // 404 Not Found if the employee does not exist
                return NotFound();
            }
            // 200 OK with the employee in the response body
            return Ok(employee);
        }
    }
}

```

- **Created():** This method will return 201 Status Code without the URL Location header. This method will not include the data in the response body.
- **Created(Uri uri, object value):** This method will return 201 Status Code without URL Location header. This method will include the data in the response body. The meaning of the parameters are as follows:
- **Created(string uri, object value):** This method will return 201 Status Code without URL Location header and response body.
```C#
using ReturnTypeAndStatusCodes.Models;
using Microsoft.AspNetCore.Mvc;
namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        //Data Source
        private static List<Employee> Employees = new List<Employee>
        {
            new Employee { Id = 1, Name = "Rakesh", Age = 25, Gender = "Male", Department = "IT" },
            new Employee { Id = 2, Name = "Hina", Age = 26, Gender = "Female", Department = "HR" },
            new Employee { Id = 3, Name = "Suresh", Age = 27, Gender = "Male", Department = "IT" },
        };

        //POST: api/Employee/CreateEmployee1
        [HttpPost]
        public ActionResult<Employee> CreateEmployee1(Employee employee)
        {
            // Add and save employee in your database or storage
            employee.Id = Employees.Count + 1;
            Employees.Add(employee);

            //Method without Location Header
            return Created();
        }

        //POST: api/Employee/CreateEmployee2
        [HttpPost]
        public ActionResult<Employee> CreateEmployee2(Employee employee)
        {
            // Add and save employee in your database or storage
            employee.Id = Employees.Count + 1;
            Employees.Add(employee);

            //Method without Location Header and Response Body using Uri
            //GetEmployeeById is the Route Name
            //var locationUri = new Uri(Url.Link("GetEmployeeById", new { id = employee?.Id }));

            var locationUri = new Uri($"https://localhost:7128/api/Employee/GetEmployee/{employee?.Id}");

            return Created(locationUri, employee);
        }

        //POST: api/Employee/CreateEmployee3
        [HttpPost]
        public ActionResult<Employee> CreateEmployee3(Employee employee)
        {
            // Add and save employee in your database or storage
            employee.Id = Employees.Count + 1;
            Employees.Add(employee);

            //Method without Location Header and Response Body using string Uri
            //GetEmployee is the action name
            //var locationUri = Url.Action("GetEmployee", "Employee", new { id = employee?.Id }, Request.Scheme);
            var locationUri = $"https://localhost:7128/api/Employee/GetEmployee/{employee?.Id}";
            return Created(locationUri, employee);
        }

        //GET: api/Employee/GetEmployee/1
        [HttpGet("{id}", Name = "GetEmployeeById")]
        public ActionResult<Employee> GetEmployee(int id)
        {
            var employee = Employees.FirstOrDefault(emp => emp.Id == id);
            if (employee == null)
            {
                // 404 Not Found if the employee does not exist
                return NotFound();
            }
            // 200 OK with the employee in the response body
            return Ok(employee);
        }
    }
}

```

# 202 HTTP Status Code in ASP.NET Core Web API


The 202 Accepted HTTP status code is a response status code indicating that the request has been accepted for processing, but the processing has not been completed. The 202 Status Code is primarily intended for situations where a request is being processed asynchronously, meaning the server has received the request, but the outcome has not yet been determined. The following are the Key characteristics of the 202 Status Code:

- **Asynchronous Processing:** It is used when a server accepts a request to be processed, but the processing occurs asynchronously. This implies that the server does not provide an immediate response or outcome of the request processing in the HTTP response.
- **Temporary Status:** The 202 Status Code does not necessarily indicate the final outcome of the request processing. It only signifies that the request was valid and has been accepted to be processed, which could eventually succeed or fail based on further internal processing.
- **Response Body:** While not strictly required, the response body of a 202 Status Code typically includes a message indicating the request’s current status or a link to where the status of the request can be monitored.
- **Location Header:** The response might include a Location header pointing to a URL where the status of the request can be checked. This allows clients to monitor the progress or outcome of the request.
- **Use Cases:** Common scenarios for using the 202 Status Code include batch processing, long-running processes, or other operations where immediate completion is not possible or expected. For example, submitting a request for generating a report that requires significant computation time might return a 202 Status Code, with details on how to check for the report’s completion status later.



#### **Using Accepted in ASP.NET Core Web API:**

The Accepted method is used to return a 202 Accepted status code. This status code indicates that the request has been accepted for processing, but the processing has not been completed. The Accepted method can be used in scenarios where the action has been queued or started but not finished. The following three overloaded versions of the Accepted method are available in ASP.NET Core.

- **Accepted():** Returns a 202 Accepted response without additional URI or content.
- **Accepted(object value):** Returns a 202 Accepted response with a serializable object that can be included in the response body.
- **Accepted(Uri uri):** Returns a 202 Accepted response with a URI indicating where the status of the request can be monitored.
- **Accepted(string uri):** Returns a 202 Accepted response with a string URI indicating where the status of the request can be monitored.
- **Accepted(Uri uri, object value):** Returns a 202 Accepted response with a URI indicating where the status of the request can be monitored and an optional object that can be included in the response body.
- **Accepted(string uri, object value):** Returns a 202 Accepted response with a string URI indicating where the status of the request can be monitored and an optional object that can be included in the response body.

```C#
using Microsoft.AspNetCore.Mvc;
namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class JobController : ControllerBase
    {
        //POST: api/Job/CreateJobAsyncWithoutData
        [HttpPost]
        public async Task<IActionResult> CreateJobAsyncWithoutData()
        {
            // Logic to start asynchronous processing and we are not blocking the thread
            // The LongRunningTask will take 60 seconds to complete
            // The main thread will not block till the LongRunningTask is completed
            LongRunningTask();

            // Return 202 Accepted without any data
            return Accepted();
        }

        //POST: api/Job/CreateJobAsyncWithData
        [HttpPost]
        public async Task<IActionResult> CreateJobAsyncWithData()
        {
            // Logic to start asynchronous processing and we are not blocking the thread
            LongRunningTask();

            var resourceStatus = new 
            { 
                Status = "Processing", 
                EstimatedCompletionTime = "2 hours" 
            };

            // Return 202 Accepted with data
            return Accepted(resourceStatus);
        }

        //POST: api/Job/CreateJobWithLocation
        [HttpPost]
        public async Task<IActionResult> CreateJobWithLocation()
        {
            // Logic to start asynchronous processing and we are not blocking the thread
            LongRunningTask();

            //Let is asume the Processing JobId is 123
            var processingJobId = 123;

            // The following Location URI we will return along with 202 Status Code
            // Location URI to check status
            //var locationUri = new Uri($"https://localhost:7248/api/Job/GetStatus/{processingJobId}");
            var locationUri = $"https://localhost:7248/api/Job/GetStatus/{processingJobId}";

            // Return a 202 Accepted status code with a location URI
            return Accepted(locationUri);
        }

        //POST: api/Job/CreateJobWithLocationAndData
        [HttpPost]
        public async Task<IActionResult> CreateJobWithLocationAndData()
        {
            // Logic to start asynchronous processing and we are not blocking the thread
            LongRunningTask();

            //Let is asume the Processing JobId is 123
            var processingJobId = 123;

            //The following data we will return along with 202 Status Code
            var resourceStatus = new 
            { 
                Status = "Processing", 
                EstimatedCompletionTime = "2 hours",
                Jobid = processingJobId
            };

            // The following Location URI we will return along with the Data and 202 Status Code
            // Location URI to check status
            // var locationUri = $"https://localhost:7248/api/Job/GetStatus/{processingJobId}";
            var locationUri = new Uri($"https://localhost:7248/api/Job/GetStatus/{processingJobId}");

            // Return a 202 Accepted status code with a location URI and a response body
            return Accepted(locationUri, resourceStatus);
        }

        //GET:  api/Job/GetStatus/123
        [HttpGet("{JobId}")]
        public IActionResult GetStatus(int JobId)
        {
            //Return the Current Status of the Jon
            var resourceStatus = new { Status = "Processing", EstimatedCompletionTime = "2 hours" };
            return Ok(resourceStatus);
        }

        //This is the method which is going to perform the time-consuming asynchronous operation
        private async Task LongRunningTask()
        {
            // Simulate a long-running task
            await Task.Delay(TimeSpan.FromSeconds(120)); // 60 Seconds delay
            // Task logic here
        }
    }
}

```


![[word-image-47053-1.webp]]

**Method: POST**

**Response Body:** The Response body will contain the data

![[word-image-47053-2.webp]]

![[word-image-47053-3.webp]]
**Response Body:** The Response body will contain the data
![[word-image-47053-4.webp]]

**Response Header:** The response header will contain the Location URI, which you can use to get the current status.
![[word-image-47053-5.webp]]
**Response Body:** The Response body will contain the data


![[word-image-47053-6.webp]]

#### **Using AcceptedAtAction in ASP.NET Core Web API:**

- **AcceptedAtAction(string actionName):** Returns a 202 Accepted response with a Location header pointing to the specified action.
- **AcceptedAtAction(string actionName):** Returns a 202 Accepted response with a Location header pointing to the specified action and controller.
- **AcceptedAtAction(string actionName, object routeValues):** Returns a 202 Accepted response with a Location header pointing to the specified action, using the provided route values to generate the URI.
- **AcceptedAtAction(string actionName, string controllerName, object routeValues, object value):** Returns a 202 Accepted response with a Location header pointing to the specified action and controller, using the provided route values to generate the URI, and includes a serializable object in the response body.
```C#
using Microsoft.AspNetCore.Mvc;
namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class JobController : ControllerBase
    {
        //POST: api/Job/CreateJobWithLocation
        [HttpPost]
        public async Task<IActionResult> CreateJobWithLocation()
        {
            // Logic to start asynchronous processing and we are not blocking the thread
            LongRunningTask();

            //Let is asume the Processing JobId is 123
            var processingJobId = 123;

            // Assuming the job has an ID assigned after being added
            // Passing object value as null as we don't want to return any data
            // Here, GetStatus is the Action Method Name
            return AcceptedAtAction("GetStatus", new { JobId = processingJobId }, null);
        }

        //POST: api/Job/CreateJobWithLocationAndData
        [HttpPost]
        public async Task<IActionResult> CreateJobWithLocationAndData()
        {
            // Logic to start asynchronous processing and we are not blocking the thread
            LongRunningTask();

            //Let us asume the Processing JobId is 123
            var processingJobId = 123;

            //The following data we will return along with 202 Status Code
            var resourceStatus = new { Status = "Processing", EstimatedCompletionTime = "2 hours" };

            // Here, GetStatus is the Action Method Name and Job is the Controller Name
            // return AcceptedAtAction("GetStatus", new { JobId = processingJobId }, resourceStatus);
            return AcceptedAtAction("GetStatus", "Job", new { JobId = processingJobId }, resourceStatus);
        }

        //GET:  api/Job/GetStatus/123
        [HttpGet("{JobId}")]
        public IActionResult GetStatus(int JobId)
        {
            //Return the Current Status of the Job
            var resourceStatus = new { Status = "Processing", EstimatedCompletionTime = "2 hours" };
            return Ok(resourceStatus);
        }

        //This is the method which is going to perform the time consuming asynchronous operation
        private async Task LongRunningTask()
        {
            // Simulate a long-running task
            await Task.Delay(TimeSpan.FromSeconds(60)); // 60 Seconds Delay
            // Task logic here
        }
    }
}

```

#### **Using AcceptedAtRoute in ASP.NET Core Web API**

```C#
using Microsoft.AspNetCore.Mvc;
namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class JobController : ControllerBase
    {
        //POST: api/Job/CreateJobWithLocation
        [HttpPost]
        public async Task<IActionResult> CreateJobWithLocation()
        {
            // Logic to start asynchronous processing and we are not blocking the thread
            LongRunningTask();

            //Let is asume the Processing JobId is 123
            var processingJobId = 123;

            // Assuming the job has an ID assigned after being added
            // GetJobStatus is the Route Name
            // Passing object value as null as we don't want to return any data
            return AcceptedAtRoute("GetJobStatus", new { JobId = processingJobId }, null);
        }

        //POST: api/Job/CreateJobWithLocationAndData
        [HttpPost]
        public async Task<IActionResult> CreateJobWithLocationAndData()
        {
            // Logic to start asynchronous processing and we are not blocking the thread
            LongRunningTask();

            //Let is asume the Processing JobId is 123
            var processingJobId = 123; 

            //The following data we will return along with 202 Status Code
            var resourceStatus = new { Status = "Processing", EstimatedCompletionTime = "2 hours" };

            // GetJobStatus is the Route Name
            return AcceptedAtRoute("GetJobStatus", new { JobId = processingJobId }, resourceStatus);
        }

        //GET:  api/Job/GetStatus/123
        //We have assigned the Route Name as GetJobStatus
        [HttpGet("{JobId}",Name ="GetJobStatus")]
        public IActionResult GetStatus(int JobId)
        {
            //Return the Current Status of the Job
            var resourceStatus = new { Status = "Processing", EstimatedCompletionTime = "2 hours" };
            return Ok(resourceStatus);
        }

        //This is the method which is going to perform the time consuming asynchronous operation
        private async Task LongRunningTask()
        {
            // Simulate a long-running task
            await Task.Delay(TimeSpan.FromSeconds(60)); // 60 Seconds Delay
            // Task logic here
        }
    }
}

```

## **204 HTTP Status Code in ASP.NET Core Web API**

##### **204 HTTP Status Code**

The 204 No Content HTTP Status Code is a success status response code indicating that the request has succeeded, but the client doesn’t need to navigate away from its current page. This status code is commonly used in situations where the request is successful, and the response does not return any content, such as when an operation has been processed successfully on the server, but there is no additional content to send in the response payload.

Use cases for a 204 No Content response might include:

- **AJAX Calls:** In web development, making asynchronous requests where the client might only need to know that the action was successful without requiring any data to be returned. For instance, after submitting a form via AJAX, the page does not need to be refreshed or updated with new content.
- **APIs:** For RESTful APIs, when performing operations like DELETE, the server successfully processes the request but does not need to return any entity-body.
- **Signal Success:** Indicating to the client that their request was processed successfully, but there’s no new information to send back.
##### **Using NoContent Method to Return 204 Status Code**

```c#
namespace ReturnTypeAndStatusCodes.Models
{
    public class Employee
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Gender { get; set; }
        public int Age { get; set; }
        public string Department { get; set; }
    }
}

```

```C#
using ReturnTypeAndStatusCodes.Models;
using Microsoft.AspNetCore.Mvc;
namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        //Data Source
        private static List<Employee> Employees = new List<Employee>
        {
            new Employee { Id = 1, Name = "Rakesh", Age = 25, Gender = "Male", Department = "IT" },
            new Employee { Id = 2, Name = "Hina", Age = 26, Gender = "Female", Department = "HR" },
            new Employee { Id = 3, Name = "Suresh", Age = 27, Gender = "Male", Department = "IT" },
        };

        //An example PUT method that uses the 204 No Content response
        //PUT: api/Employee/5
        [HttpPut("{id}")]
        public IActionResult UpdateEmployee(int id, Employee employee)
        {
            if (id != employee.Id)
            {
                return BadRequest();
            }

            var existingEmployee = Employees.FirstOrDefault(emp => emp.Id == id);
            if (existingEmployee == null)
            {
                return NotFound();
            }

            existingEmployee.Name = employee.Name;
            existingEmployee.Age = employee.Age;
            existingEmployee.Gender = employee.Gender;
            existingEmployee.Department = employee.Department;
            // In a real application, here you would update the product in the database

            // If the employee is successfully updated, return a 204 No Content response.
            // This indicates to the client that the request was successful but there is no content to send back.
            return NoContent();
        }

        //An example DELETE method that uses the 204 No Content response
        //DELETE: api/Employee/5
        [HttpDelete("{id}")]
        public IActionResult DeleteEmployee(int id)
        {
            var existingEmployee = Employees.FirstOrDefault(emp => emp.Id == id);
            if (existingEmployee == null)
            {
                return NotFound();
            }
            Employees.Remove(existingEmployee);
            // In a real application, here you would delete the product from the database

            // If the employee is successfully deleted, return a 204 No Content response.
            // This indicates to the client that the request was successful but there is no content to send back.
            return NoContent();
        }
    }
}

```

##### **Testing the APIs:**

```json
{
  "id": 1,
  "name": "Pranaya",
  "gender": "Make",
  "age": 25,
  "department": "IT"
}

```

![[word-image-47072-1.webp]]

![[word-image-47072-2.webp]]

**Response Body:** The Response body will be empty with a 204 HTTP Status Code.

![[word-image-47072-4.webp]]

##### **Returning 204 Status Code Directly**

```C#
using ReturnTypeAndStatusCodes.Models;
using Microsoft.AspNetCore.Mvc;
namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        //Data Source
        private static List<Employee> Employees = new List<Employee>
        {
            new Employee { Id = 1, Name = "Rakesh", Age = 25, Gender = "Male", Department = "IT" },
            new Employee { Id = 2, Name = "Hina", Age = 26, Gender = "Female", Department = "HR" },
            new Employee { Id = 3, Name = "Suresh", Age = 27, Gender = "Male", Department = "IT" },
        };

        //An example PUT method that uses the 204 No Content response
        //PUT: api/Employee/5
        [HttpPut("{id}")]
        public IActionResult UpdateEmployee(int id, Employee employee)
        {
            if (id != employee.Id)
            {
                return BadRequest();
            }

            var existingEmployee = Employees.FirstOrDefault(emp => emp.Id == id);
            if (existingEmployee == null)
            {
                return NotFound();
            }

            existingEmployee.Name = employee.Name;
            existingEmployee.Age = employee.Age;
            existingEmployee.Gender = employee.Gender;
            existingEmployee.Department = employee.Department;
            // In a real application, here you would update the product in the database

            // Explicitly return a 204
            return StatusCode(StatusCodes.Status204NoContent); 
        }

        //An example DELETE method that uses the 204 No Content response
        //DELETE: api/Employee/5
        [HttpDelete("{id}")]
        public IActionResult DeleteEmployee(int id)
        {
            var existingEmployee = Employees.FirstOrDefault(emp => emp.Id == id);
            if (existingEmployee == null)
            {
                return NotFound();
            }
            Employees.Remove(existingEmployee);
            // In a real application, here you would delete the product from the database

            // Explicitly return a 204
            return StatusCode(StatusCodes.Status204NoContent);
        }
    }
}

```

```c#
using ReturnTypeAndStatusCodes.Models;
using Microsoft.AspNetCore.Mvc;
namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        //Data Source
        private static List<Employee> Employees = new List<Employee>
        {
            new Employee { Id = 1, Name = "Rakesh", Age = 25, Gender = "Male", Department = "IT" },
            new Employee { Id = 2, Name = "Hina", Age = 26, Gender = "Female", Department = "HR" },
            new Employee { Id = 3, Name = "Suresh", Age = 27, Gender = "Male", Department = "IT" },
        };

        //An example PUT method that uses the 204 No Content response
        //PUT: api/Employee/5
        [HttpPut("{id}")]
        public IActionResult UpdateEmployee(int id, Employee employee)
        {
            if (id != employee.Id)
            {
                return BadRequest();
            }

            var existingEmployee = Employees.FirstOrDefault(emp => emp.Id == id);
            if (existingEmployee == null)
            {
                return NotFound();
            }

            existingEmployee.Name = employee.Name;
            existingEmployee.Age = employee.Age;
            existingEmployee.Gender = employee.Gender;
            existingEmployee.Department = employee.Department;
            // In a real application, here you would update the product in the database

            // Explicitly return a 204
            return StatusCode(StatusCodes.Status204NoContent); 
        }

        //An example DELETE method that uses the 204 No Content response
        //DELETE: api/Employee/5
        [HttpDelete("{id}")]
        public IActionResult DeleteEmployee(int id)
        {
            var existingEmployee = Employees.FirstOrDefault(emp => emp.Id == id);
            if (existingEmployee == null)
            {
                return NotFound();
            }
            Employees.Remove(existingEmployee);
            // In a real application, here you would delete the product from the database

            // Explicitly return a 204
            return StatusCode(StatusCodes.Status204NoContent);
        }
    }
}

```

##### **Best Practices and Considerations**

- **Use Case:** The 204 No Content status is best used for operations that do not need to return any data. Common use cases include DELETE operations, where the client does not need any further information about the deleted resource, or POST/PUT operations, where the result does not need to be communicated back to the client.
- **Client Handling:** Ensure that your client-side application correctly handles a 204 response, especially since no data will be returned. This might mean simply acknowledging the success of the operation and updating the UI accordingly.
- **Error Handling:** If your operation fails (for example, if the item to be deleted or updated is not found), return an appropriate error status code (such as 404 Not Found) along with any relevant error messages.
## **301 HTTP Status Code in ASP.NET Core Web API**

##### **301 HTTP Status Code**

The HTTP status code 301, known as “Moved Permanently,” is a response code that indicates that the requested resource has been permanently moved to a new URL. When a web server returns this response, it also provides the new URL in the location header of the HTTP response. Clients, such as web browsers or search engines, are expected to update their links to the resource by replacing the old URL with the new one provided.

- **Definition:** Indicates that the requested resource has been permanently moved to a new location.
- **Purpose:** Used by web servers to inform the client that the resource they are trying to access has been permanently moved to a new URL. It is an effective way to redirect traffic from an old URL to a new one without losing search engine rankings.
- **Location Header:** Accompanied by a ‘Location’ header, which contains the URL of the redirected resource. Clients are expected to follow this new URL to access the resource.
- **SEO Impact:** A 301 redirect is crucial for maintaining search engine rankings. When a URL is changed, a 301 redirect ensures that links pointing to the old URL contribute to the link equity of the new URL, preserving its search engine ranking.
- **Usage:** Typically used in website migration scenarios, URL structure changes, or when content is permanently moved to a new location.
- **Client Behavior:** Upon receiving a 301 Status Code, web clients (browsers) automatically follow the redirect to the new URL provided in the location header, usually without user intervention.

##### **RedirectPermanent Method:**

```C#
using Microsoft.AspNetCore.Mvc;
namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        [HttpGet("old-route")]
        public IActionResult GetFromOldRoute()
        {
            // The URL of the new location for the resource
            //string newUrl = "https://localhost:7128/api/Employee/new-route";
            string newUrl = Url.Action("GetFromNewRoute", "Employee");

            // Redirects permanently to the new URL with a 301 HTTP status code
            return RedirectPermanent(newUrl);
        }

        [HttpGet("new-route")]
        public IActionResult GetFromNewRoute()
        {
            // Code to handle the request at the new location
            return Ok("This is the new location for the resource.");
        }
    }
}

```
![[word-image-47086-1 1.webp]]


![[word-image-47086-2.webp]]

##### **Manually Creating a RedirectResult with a 301 Status Code:**

```C#
using Microsoft.AspNetCore.Mvc;
namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        [HttpGet("old-route")]
        public IActionResult GetFromOldRoute()
        {
            // The URL of the new location for the resource
            //string newUrl = "https://localhost:7128/api/Employee/new-route";
            string newUrl = Url.Action("GetFromNewRoute", "Employee");

            // Redirects permanently to the new URL with a 301 HTTP status code
            return new RedirectResult(newUrl, permanent: true);
        }

        [HttpGet("new-route")]
        public IActionResult GetFromNewRoute()
        {
            // Code to handle the request at the new location
            return Ok("This is the new location for the resource.");
        }
    }
}

```

##### **Setting StatusCode and Location Header Manually:**

```C#
using Microsoft.AspNetCore.Mvc;
namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        [HttpGet("old-route")]
        public IActionResult GetFromOldRoute()
        {
            // The URL of the new location for the resource
            //string newUrl = "https://localhost:7128/api/Employee/new-route";
            string newUrl = Url.Action("GetFromNewRoute", "Employee");

            // Redirects permanently to the new URL with a 301 HTTP status code
            Response.StatusCode = 301; // HTTP 301 Moved Permanently
            Response.Headers["Location"] = newUrl;
            return new EmptyResult();
        }

        [HttpGet("new-route")]
        public IActionResult GetFromNewRoute()
        {
            // Code to handle the request at the new location
            return Ok("This is the new location for the resource.");
        }
    }
}

```


## **302 HTTP Status Code in ASP.NET Core Web API**

The HTTP 302 status code is used to indicate a redirection. Specifically, it means “Found” or sometimes referred to as “Temporary Redirect.” When a web server responds with this status code, it tells the client (for example, a web browser) that the requested resource has been temporarily moved to a different URI (Uniform Resource Identifier). Unlike the HTTP 301 status code, which indicates a permanent redirect, a 302 redirect suggests that the redirection might be temporary and the original location should be used for future requests. The following are the key characteristics of the HTTP 302 Status Code:

- **Client Request:** The client requests a resource from the server using a specific URI.
- **Server Response with 302:** The server responds with a 302 Status Code, indicating that the requested resource temporarily resides at a different URI. The server includes this new URI in the response’s Location header.
- **Client Follows Redirect:** The client then makes a new request to the URI provided in the Location header.
- **Server Responds to New Request:** The server responds to this new request, potentially with a 200 OK status code if the resource is successfully retrieved.


##### **Redirect Method**

```C#
using Microsoft.AspNetCore.Mvc;
namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        [HttpGet]
        [Route("OldEndpoint")]
        public IActionResult GetFromOldEndpoint()
        {
            // The URL of the new location for the resource
            //string newUrl = "https://localhost:7128//api/Employee/NewEndpoint";
            string newUrl = Url.Action("GetFromNewEndpoint", "Employee");
            
            //return Redirect("/api/Employee/NewEndpoint");

            // Temporary redirect to the new endpoint
            return Redirect(newUrl);
        }

        [HttpGet]
        [Route("NewEndpoint")]
        public IActionResult GetFromNewEndpoint()
        {
            // Handle the request as usual
            return Ok("This is the new endpoint.");
        }
    }
}

```

![[word-image-47094-1.webp]]

```C#
using Microsoft.AspNetCore.Mvc;
namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        [HttpGet]
        [Route("OldEndpoint")]
        public IActionResult GetFromOldEndpoint()
        {
            // The URL of the new location for the resource
            //string newUrl = "https://localhost:7128//api/Employee/NewEndpoint";
            string newUrl = Url.Action("GetFromNewEndpoint", "Employee");
            // Redirects permanently to the new URL with a 301 HTTP status code

            // Temporary redirect to the new URL with a 301 HTTP status code
            return new RedirectResult(newUrl, permanent: false);
        }

        [HttpGet]
        [Route("NewEndpoint")]
        public IActionResult GetFromNewEndpoint()
        {
            // Handle the request as usual
            return Ok("This is the new endpoint.");
        }
    }
}

```

##### **Setting StatusCode and Location Header Manually:**

```C#
using Microsoft.AspNetCore.Mvc;
namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        [HttpGet]
        [Route("OldEndpoint")]
        public IActionResult GetFromOldEndpoint()
        {
            // The URL of the new location for the resource
            //string newUrl = "https://localhost:7128//api/Employee/NewEndpoint";
            string newUrl = Url.Action("GetFromNewEndpoint", "Employee");

            // Redirects Temporarily to the new URL with a 302 HTTP status code
            Response.StatusCode = 302; // HTTP 302 Redirect Temporarily
            Response.Headers.Location = newUrl;
            return new EmptyResult();
        }

        [HttpGet]
        [Route("NewEndpoint")]
        public IActionResult GetFromNewEndpoint()
        {
            // Handle the request as usual
            return Ok("This is the new endpoint.");
        }
    }
}

```

# 400 HTTP Status Code in ASP.NET Core Web API

##### **400 HTTP Status Code**

The 400 HTTP Status Code indicates that the request sent to the server by the client was somehow incorrect or corrupted, and the server couldn’t understand it. The 400 Status Code belongs to the 4xx class of status codes, which are used for indicating client errors. The 400 Status Code means “Bad Request.” It is a generic error response indicating that the server cannot process the request due to client error. Common causes for a 400 Bad Request error can include:

- Incorrectly formatted URL.
- Invalid or missing request parameters.
- Malformed request headers.
- Payloads that are too large.
- Syntax errors in the request body (e.g., invalid JSON or XML).

To resolve a 400 Bad Request error, the client should:

- Verify the syntax of the request URL.
- Check that the request adheres to the expected format, including headers, query parameters, and the request body.
- Ensure that the size of the request payload is within the server’s accepted limits.
- Correct any data formatting issues (such as JSON, XML, etc.) in the request body.

When developing web applications, it’s important for developers to handle 400 errors. This might involve providing informative error messages to the user or logging detailed information for debugging purposes.

##### **Using BadRequest Method**

```C#
using System.ComponentModel.DataAnnotations;

namespace ReturnTypeAndStatusCodes.Models
{
    public class Employee
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Gender { get; set; }
        public string City { get; set; }
        public int Age { get; set; }
        public string Department { get; set; }
    }
}

```

```C#
using Microsoft.AspNetCore.Mvc;
using ReturnTypeAndStatusCodes.Models;

namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        [HttpPost]
        public IActionResult CreateEmployee([FromBody] Employee employee)
        {
            if (!ModelState.IsValid)
            {
                // Returns a 400 Status Code with model state errors
                return BadRequest(ModelState); 
            }

            // Process the request...

            // Returns a 200 Status Code indicating success
            return Ok(); 
        }
    }
}

```

![[word-image-47120-1.webp]]
![[word-image-47120-2.webp]]
##### **Returning BadRequestObjectResult Directly**

```C#
using Microsoft.AspNetCore.Mvc;
using ReturnTypeAndStatusCodes.Models;

namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    //[ApiController]
    public class EmployeeController : ControllerBase
    {
        [HttpPost]
        public IActionResult CreateEmployee([FromBody] Employee employee)
        {
            if (!ModelState.IsValid)
            {
                var errorResponse = new { Error = "Invalid Data Provided" };
                // Returns a 400 status code with a custom error object
                return new BadRequestObjectResult(errorResponse); 
            }

            // Process the request...

            // Returns a 200 Status Code indicating success
            return Ok(); 
        }
    }
}

```


##### **Problem Details for API Errors**

ASP.NET Core supports the use of the ProblemDetails object as part of RFC 7807, which provides a standardized way to convey error details in HTTP responses. This can be used to provide more detailed information about what went wrong. The ProblemDetails object includes several properties that you can set to provide detailed error information:

- **Type:** A URI reference that identifies the problem type. This is intended to be dereferenced by the client to obtain detailed information about the problem type.
- **Title:** A short, human-readable summary of the problem type.
- **Status:** The HTTP status code generated by the server for this occurrence of the problem.
- **Detail:** A human-readable explanation specific to this occurrence of the problem.
- **Instance:** A URI reference that identifies the specific occurrence of the problem.
```C#
using Microsoft.AspNetCore.Mvc;
using ReturnTypeAndStatusCodes.Models;
using System.Diagnostics;

namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    //[ApiController]
    public class EmployeeController : ControllerBase
    {
        [HttpPost]
        public IActionResult CreateEmployee([FromBody] Employee employee)
        {
            if (!ModelState.IsValid)
            {
                // Returns a 400 Status Code with model state errors
                var problemDetails = new ProblemDetails()
                { 
                    Title = "Validation Errors Occurred.", 
                    Detail = "See the Errors Property for Details.",
                    Type = "https://tools.ietf.org/html/rfc7231#section-6.5.1",
                    Status = StatusCodes.Status400BadRequest,
                    Instance = HttpContext.Request.Path,
                    Extensions = { { "traceId", Activity.Current?.Id ?? HttpContext.TraceIdentifier } }
                };
                return BadRequest(problemDetails);
            }

            // Process the request...

            // Returns a 200 Status Code indicating success
            return Ok(); 
        }
    }
}

```

![[word-image-47120-3.webp]]

##### **Using ValidationProblemDetails Object**

```C#
using Microsoft.AspNetCore.Mvc;
using ReturnTypeAndStatusCodes.Models;

namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    //[ApiController]
    public class EmployeeController : ControllerBase
    {
        [HttpPost]
        public IActionResult CreateEmployee([FromBody] Employee employee)
        {
            if (!ModelState.IsValid)
            {
                // Returns a 400 Status Code with model state errors
                var problemDetails = new ValidationProblemDetails(ModelState)
                { 
                    Title = "Validation errors occurred.", 
                    Detail = "See the errors property for details.",
                    Type = "https://tools.ietf.org/html/rfc7231#section-6.5.1",
                    Status = StatusCodes.Status400BadRequest,
                    Instance = HttpContext.Request.Path
                };
                return BadRequest(problemDetails);
            }

            // Process the request...

            // Returns a 200 Status Code indicating success
            return Ok(); 
        }
    }
}

```

##### **Manual 400 HTTP Response in ASP.NET Core Web API**

```C#
using Microsoft.AspNetCore.Mvc;
using ReturnTypeAndStatusCodes.Models;

namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    //[ApiController]
    public class EmployeeController : ControllerBase
    {
        [HttpPost]
        public IActionResult CreateEmployee([FromBody] Employee employee)
        {
            if (!ModelState.IsValid)
            {
                // Manually setting the status code to 400
                Response.StatusCode = 400;

                // You can still return a body
                return new ObjectResult(new { Error = "Invalid data provided" }); 
            }

            // Process the request...

            // Returns a 200 Status Code indicating success
            return Ok(); 
        }
    }
}
```

##### **400 HTTP Status Code Real-Time Examples in ASP.NET Core Web API**

```C#
[HttpPost]
public IActionResult CreateEmployee([FromBody] Employee employee)
{
    if (!ModelState.IsValid)
    {
        // Returns 400 with validation errors
        return BadRequest(ModelState);
    }

    // Process the valid product...

    // Returns a 200 Status Code indicating success
    return Ok();
}

```

##### **Malformed JSON**

```json
{
  "id": 1,
  "age": 25
  "department": "IT"
}

```
![[word-image-47120-5.webp]]

##### **Missing Required Parameters**

```C#
[HttpGet]
public IActionResult GetUserInfo([FromQuery] string EmployeeId)
{
    if (string.IsNullOrEmpty(EmployeeId))
    {
        return BadRequest("EmployeeId is required.");
    }
    // Retrieve and return user information...

    // Returns a 200 Status Code indicating success
    return Ok();
}

```

##### **Invalid Query Strings**

```C#
[HttpGet]
public IActionResult GetOrders([FromQuery] DateTime startDate, [FromQuery] DateTime endDate)
{
    if (endDate < startDate)
    {
        return BadRequest("EndDate must be greater than StartDate.");
    }
    // Retrieve and return orders...

    // Returns a 200 Status Code indicating success
    return Ok();
}

```

## **401 HTTP Status Code in ASP.NET Core Web API**

##### **401 HTTP Status Code**

The 401 HTTP Status Code indicates an “Unauthorized” response. This status code is sent by a web server when access to the requested resource requires authentication, and either the authentication has not been provided or has failed. It suggests that the client needs to authenticate themselves in order to get the requested response. The following are the key points about the 401 HTTP Status Code:

- **Authentication Required:** The primary purpose of this status code is to inform the client that they must authenticate themselves to get the requested response.
- **WWW-Authenticate Header:** When a server sends a 401 response, it also includes a WWW-Authenticate header field, indicating the authentication method that should be used to gain access. This header provides the information required for the client to initiate the authentication process.
- **Client Action:** Upon receiving a 401 response, the client may submit a new request with the appropriate authentication credentials. This is usually done by including an Authorization header in the request with the credentials.
- **Difference from 403 Forbidden:** A 401 status code is different from a 403 Forbidden status code, which indicates that the server understands the client’s request but refuses to authorize it. In contrast, 401 suggests that the request could be authorized if credentials were provided.

##### **401 HTTP Status Code in ASP.NET Core Web API**

- **No Authentication Information:** The request did not contain any authentication information. This is common when the API endpoint expects a token (like JWT), and the request is made without it.
- **Invalid Authentication Information:** The request contains authentication information, but it is invalid or expired. This can happen if the token is not valid, is expired, or does not have the correct permissions to access the resource.
- **Authentication Scheme Not Supported:** The authentication information is provided using a scheme that is not supported or not correctly implemented in the API.
```C#
using Microsoft.AspNetCore.Mvc;

namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        [HttpGet]
        public IActionResult SecureResource()
        {
            // Your authentication logic here
            // Assuming this is the result of your auth check
            bool isAuthenticated = false; 

            if (!isAuthenticated)
            {
                return Unauthorized(); // Returns a 401 Unauthorized response
            }

            // Proceed with normal action if authenticated
            return Ok("Authenticated and Authorized Access.");
        }
    }
}

```

![[word-image-47129-1.webp]]

```C#
using Microsoft.AspNetCore.Mvc;

namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        [HttpGet]
        public IActionResult SecureResource()
        {
            // Your authentication logic here
            // Assuming this is the result of your auth check
            bool isAuthenticated = false; 

            if (!isAuthenticated)
            {
               // Returns a 401 Unauthorized response
                return Unauthorized(new { message = "Access denied. Please provide valid credentials." });
            }

            // Proceed with normal action if authenticated
            return Ok("Authenticated and Authorized Access.");
        }
    }
}

```

![[word-image-47129-2.webp]]

```C#
using Microsoft.AspNetCore.Mvc;

namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        [HttpGet]
        public IActionResult SecureResource()
        {
            // Your authentication logic here
            // Assuming this is the result of your auth check
            bool isAuthenticated = false;

            if (!isAuthenticated)
            {
                // Returns a 401 Unauthorized response
                var errorResponse = new
                {
                    StatusCode = StatusCodes.Status401Unauthorized,
                    Message = "Access denied. Please provide valid credentials."
                };

                // Use StatusCode method to return 401 Unauthorized status and custom data
                return StatusCode(StatusCodes.Status401Unauthorized, errorResponse);
            }

            // Proceed with normal action if authenticated
            return Ok("Authenticated and Authorized Access.");
        }
    }
} 

```

![[word-image-43851-3-3.webp]]

##### **Custom Middleware to Handle 401 Unauthorized Error**

```C#
namespace ReturnTypeAndStatusCodes.Models
{
    public class CustomAuthenticationMiddleware
    {
        private readonly RequestDelegate _next;

        public CustomAuthenticationMiddleware(RequestDelegate next)
        {
            _next = next;
        }

        public async Task InvokeAsync(HttpContext context)
        {
            // Custom authorization logic here
            bool isAuthorized = CheckAuthorization(context);

            if (!isAuthorized)
            {
                context.Response.StatusCode = StatusCodes.Status401Unauthorized;
                context.Response.ContentType = "application/json";

                var customResponse = new
                {
                    status = 401,
                    message = "Unauthorized. Please Provide Valid Credentials"
                };

                await context.Response.WriteAsync(System.Text.Json.JsonSerializer.Serialize(customResponse));
                return; // Short-circuit the pipeline
            }

            await _next(context);
        }

        private bool CheckAuthorization(HttpContext context)
        {
            // Implement your authorization logic here
            // For example, check for a specific header or token
            return false; // Simulate unauthorized
        }
    }
}

```

##### **Registration the Middleware**

```C#
using Microsoft.AspNetCore.Mvc;

namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        [HttpGet]
        public IActionResult SecureResource()
        {
            // Proceed with normal action if authenticated
            return Ok("Authenticated and Authorized Access.");
        }
    }
}

```

![[word-image-43851-4-2 1.webp]]

## **403 HTTP Status Code in ASP.NET Core Web API**
##### **403 HTTP Status Code**

The 403 HTTP Status Code indicates that the server understands the request but refuses to authorize it. This status is different from a 401 Unauthorized response, which suggests that the client’s request lacks valid authentication credentials. The 403 Forbidden Status Code explicitly indicates that authentication, whether provided or not, will not grant access to the requested resource. Essentially, the server is saying, “I understand your request, but I won’t fulfill it because you don’t have permission to access this content.” The following are the Key points about the 403 Forbidden Status Code:

**Unauthorized vs. Forbidden:** Unlike the 401 Unauthorized status, which suggests trying again with proper credentials, a 403 Forbidden status indicates that no amount of authentication will change the server’s decision to deny access to the resource.


**Use Cases:** A server might return a 403 status for various reasons, such as:

- The client’s credentials do not grant them access to the requested resource.
- The request is understood but not allowed for security reasons or due to the server’s access control policies.
- Specific resources are intentionally hidden for certain users, regardless of authentication.

**Resolution Steps:** When encountering a 403 Forbidden error, users can attempt several steps to resolve the issue, including:

- Verifying the URL is correct and does not contain typos.
- Check if the resource is intended to be publicly accessible and whether you have permission to access it.
- Clearing the browser’s cache and cookies as outdated or corrupt stored data can sometimes cause this error.
- Contact the website or server administrator for information on why access is denied or to request access if it’s a resource you should legitimately be able to access.
##### **How to Return 403 HTTP Status Code in ASP.NET Core Web API?**

```C#
using Microsoft.AspNetCore.Mvc;

namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        [HttpGet]
        public IActionResult GetResource()
        {
            // Your logic here
            // For example, check if the user has the right permissions to access the resource
            bool hasPermission = CheckUserPermission();

            if (!hasPermission)
            {
                // User does not have the required permissions
                // Return a 403 Forbidden response
                return StatusCode(StatusCodes.Status403Forbidden);
            }

            // If the user has permission, continue to handle the request
            // For example, return the requested resource
            return Ok("Resource Content Here");
        }

        private bool CheckUserPermission()
        {
            //Logic to Check the User Permission
            return false;
        }
    }
}

```

![[word-image-47135-1.webp]]

```C#
using Microsoft.AspNetCore.Mvc;

namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        [HttpGet]
        public IActionResult GetResource()
        {
            // Your logic here
            // For example, check if the user has the right permissions to access the resource
            bool hasPermission = CheckUserPermission();

            if (!hasPermission)
            {
                // User does not have the required permissions
                // Return a 403 Forbidden response
               
                var errorResponse = new 
                {
                    StatusCode = StatusCodes.Status403Forbidden,
                    Message = "Access denied. You do not have permission to access this resource."
                };

                // Use StatusCode method to return 403 Forbidden status and custom data
                return StatusCode(StatusCodes.Status403Forbidden, errorResponse);
            }

            // If the user has permission, continue to handle the request
            // For example, return the requested resource
            return Ok("Resource Content Here");
        }

        private bool CheckUserPermission()
        {
            //Logic to Check the User Permission
            return false;
        }
    }
}

```

![[word-image-47135-2.webp]]

##### **Custom Middleware to Handle 403 Forbidden Error**

```C#
using System.Text.Json;

namespace ReturnTypeAndStatusCodes.Models
{
    public class CustomAuthorizationMiddleware
    {
        private readonly RequestDelegate _next;

        public CustomAuthorizationMiddleware(RequestDelegate next)
        {
            _next = next;
        }

        public async Task Invoke(HttpContext context)
        {
            // Custom logic to determine authorization
            bool isAuthorized = CheckUserAuthorization(context);

            if (!isAuthorized)
            {
                context.Response.StatusCode = StatusCodes.Status403Forbidden;
                context.Response.ContentType = "application/json";

                var customResponse = new
                {
                    Code = 403,
                    Message = "Access is denied due to insufficient permissions."
                };

                var responseJson = JsonSerializer.Serialize(customResponse);

                await context.Response.WriteAsync(responseJson);

                return; // Short-circuit the pipeline
            }

            await _next(context);
        }

        private bool CheckUserAuthorization(HttpContext context)
        {
            // Implement your authorization logic here
            // returning false to handle Forbidden scenario
            return false; 
        }
    }
}

```

## **404 HTTP Status Code in ASP.NET Core Web API**

##### **404 HTTP Status Code**

The 404 “Not Found” HTTP status code is an error message that indicates the server could not find the requested resource. This status code is a standard response in the HTTP protocol, signaling to the client (typically a web browser) that the URL they have requested does not exist on the server. It’s one of the most recognizable and common errors encountered on the internet.

###### **Common Causes of a 404 Error:**

- **Incorrect URL:** The most common cause is simply that the URL was typed incorrectly into the browser’s address bar.
- **Moved or Deleted Content:** If a webpage or resource was moved to a different URL without proper redirection or if it was deleted, a 404 error will occur when attempting to access it.
- **Broken or Dead Links:** Links on a website that points to resources that have been moved or removed will lead to a 404 error when clicked.
- **Domain Name Issues:** If the domain name cannot be resolved to the correct server or if it’s not properly configured, a 404 error might occur.
- **Server Configuration Issues:** Incorrect configuration on the server side can lead to resources not being found, even if they exist.

###### **Handling a 404 Error:**

- **For Web Users:** If you encounter a 404 error, double-check the URL for typos. You can also try navigating to the homepage of the website and searching for the content you’re looking for.
- **For Webmasters and Developers:** It’s important to regularly check for broken links on your website and fix them. Implementing meaningful 404 error pages that guide users to a working part of your site can improve user experience. Additionally, setting up proper redirects for content that has moved can prevent 404 errors from occurring.
##### **How to Return 404 HTTP Status Code in ASP.NET Core Web API?**

```C#
using Microsoft.AspNetCore.Mvc;

namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        [HttpGet("{id}")]
        public IActionResult GetResource(int id)
        {
            var resource = FindResourceById(id);

            if (resource == null)
            {
                // Resource not found, return 404
                return NotFound();
            }

            // Resource found, return it with 200 OK status
            return Ok(resource);
        }

        // Mock method to simulate resource lookup
        private object FindResourceById(int id)
        {
            // Assume this method returns null if the resource is not found
            // In a real application, you would query your database or data source here
            return null;
        }
    }
}

```

![[word-image-47152-1.webp]]

##### **Returning 404 with Custom Error Message:**

You can also pass an object to the NotFound method that includes details about why the resource was not found.

```C#
using Microsoft.AspNetCore.Mvc;

namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        [HttpGet("{id}")]
        public IActionResult GetResource(int id)
        {
            var resource = FindResourceById(id);

            if (resource == null)
            {
                // Resource not found, return 404
                var customResponse = new { message = $"No Employee Found with the Id: {id}" };
                return NotFound(customResponse);
            }

            // Resource found, return it with 200 OK status
            return Ok(resource);
        }

        // Mock method to simulate resource lookup
        private object FindResourceById(int id)
        {
            // Assume this method returns null if the resource is not found
            // In a real application, you would query your database or data source here
            return null;
        }
    }
}

```

##### **Manually Returning 404 Status Code in ASP.NET Core Web API:**

```C#
using Microsoft.AspNetCore.Mvc;

namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        [HttpGet("{id}")]
        public IActionResult GetResource(int id)
        {
            var resource = FindResourceById(id);

            if (resource == null)
            {
                // Resource not found, return 404
                var customResponse = new { message = $"No Employee Found with the Id: {id}" };
                return StatusCode(StatusCodes.Status404NotFound, customResponse);
            }

            // Resource found, return it with 200 OK status
            return Ok(resource);
        }

        // Mock method to simulate resource lookup
        private object FindResourceById(int id)
        {
            // Assume this method returns null if the resource is not found
            // In a real application, you would query your database or data source here
            return null;
        }
    }
}

```

![[word-image-47152-3.webp]]

##### **Endpoint Does Not Exist Example in ASP.NET Core Web API**

In ASP.NET Core Web API, when you attempt to access an endpoint that does not exist, it means that the route you are trying to reach is not defined in the application. This can happen for a variety of reasons, such as typos in the URL, forgetting to define the route in your controller, or the route being removed but still being referenced elsewhere. By default, ASP.NET Core will respond with a 404 Status Code (Not Found) for such requests.

##### **Create a Middleware Class**
First, you need to create a middleware class that checks if the HTTP response is a 404 and, if so, modifies the response accordingly. So, create a class file named **NotFoundCustomMiddleware.cs** a

```C#
using System.Text.Json;

namespace ReturnTypeAndStatusCodes.Models
{
    public class NotFoundCustomMiddleware
    {
        private readonly RequestDelegate _next;

        public NotFoundCustomMiddleware(RequestDelegate next)
        {
            _next = next;
        }

        public async Task Invoke(HttpContext context)
        {
            await _next(context);

            if (context.Response.StatusCode == 404 && !context.Response.HasStarted)
            {
                context.Response.ContentType = "application/json";
                var customResponse = new
                {
                    Code = 404,
                    Message = "Endpoint does not exist"
                };

                var responseJson = JsonSerializer.Serialize(customResponse);

                await context.Response.WriteAsync(responseJson);
            }
        }
    }
}

```

###### **The class is composed of the following key components:**

- **Private Field (private readonly RequestDelegate _next):** This field holds the RequestDelegate passed to the constructor. It’s used to invoke the next middleware in the pipeline.
- **Constructor (public NotFoundCustomMiddleware(RequestDelegate next)):** The constructor accepts a RequestDelegate named next. This delegate represents the next middleware in the pipeline. The constructor stores this delegate in a private field for later use.
- **Invoke Method (public async Task Invoke(HttpContext context)):** This is the method that gets called when the middleware is executed. It takes an HttpContext object as a parameter, which provides information about the current HTTP request and response.
![[word-image-47152-4.webp]]

## **405 HTTP Status Code in ASP.NET Core Web API**


The 405 HTTP status code is defined as “Method Not Allowed.” This response is sent by a server when it recognizes the request method (e.g., GET, POST, DELETE, PUT, etc.), but the method is not supported or allowed for the requested resource. It indicates that the web server has understood the request but refuses to authorize the requested method.


##### **Attribute Routing and HTTP Method Attributes**
```C#
using Microsoft.AspNetCore.Mvc;

namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SampleController : ControllerBase
    {
        // This action only supports POST method
        [HttpPost]
        public IActionResult PostAction()
        {
            return Ok("Data processed");
        }
    }
}

```
![[word-image-47162-1.webp]]

##### **Missing HTTP Method Attribute in ASP.NET Core Web API**

```C#
using Microsoft.AspNetCore.Mvc;
namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    public class SampleController : ControllerBase
    {
        public IActionResult UnifiedMethod()
        {
            if (HttpContext.Request.Method == HttpMethod.Post.Method)
            {
                return Ok("Handled POST request");
            }
            else if (HttpContext.Request.Method == HttpMethod.Put.Method)
            {
                return Ok("Handled PUT request");
            }
            else
            {
                var customResponse = new
                {
                    Code = 405,
                    Message = "Support Method are POST and PUT"
                };
                // Explicitly return 405 for Unsupported Methods
                return StatusCode(StatusCodes.Status405MethodNotAllowed, customResponse);
            }
        }
    }
}

```

![[word-image-47162-3.webp]]

##### **Custom Middleware for Handling 405 Method Not Allowed in ASP.NET Core Web API**

```C#
using System.Net;
using System.Text.Json;

namespace ReturnTypeAndStatusCodes.Models
{
    public class MethodNotAllowedMiddleware
    {
        private readonly RequestDelegate _next;

        public MethodNotAllowedMiddleware(RequestDelegate next)
        {
            _next = next;
        }

        public async Task Invoke(HttpContext context)
        {
            await _next(context);
            if (context.Response.StatusCode == (int)HttpStatusCode.MethodNotAllowed)
            {
                context.Response.ContentType = "application/json";
                var customResponse = new
                {
                    Code = 405,
                    Message = "HTTP Method not allowed"
                };
                var responseJson = JsonSerializer.Serialize(customResponse);
                await context.Response.WriteAsync(responseJson);
            }
        }
    }
}

```

##### **Modifying the Sample Controller as follows:**

```C#
using Microsoft.AspNetCore.Mvc;

namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SampleController : ControllerBase
    {
        // This action only supports POST method
        [HttpPost]
        public IActionResult PostAction()
        {
            return Ok("Data processed");
        }
    }
}

```

![[word-image-47162-4.webp]]

# Configure Allowed HTTP Methods Globally in ASP.NET Core Web API

##### **Create a Middleware Class**

First, create a middleware class that inspects the HTTP method of each request. So, create a class file named **HttpMethodMiddleware.cs** and copy and paste the following code. The following HttpMethodMiddleware class is a custom middleware component. It is used to filter incoming HTTP requests based on the HTTP method (e.g., GET, POST, PUT, DELETE) and only to allow requests that use specified methods. Requests that use disallowed methods are rejected with a “405 Method Not Allowed” status code.

```C#
using System.Text.Json;

namespace ReturnTypeAndStatusCodes.Models
{
    public class HttpMethodMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly string[] _allowedMethods;

        public HttpMethodMiddleware(RequestDelegate next, string[] allowedMethods)
        {
            _next = next;
            _allowedMethods = allowedMethods;
        }

        public async Task InvokeAsync(HttpContext context)
        {
            if (!_allowedMethods.Contains(context.Request.Method))
            {
                context.Response.StatusCode = StatusCodes.Status405MethodNotAllowed;
                context.Response.ContentType = "application/json";
                var customResponse = new
                {
                    Code = 405,
                    Message = "HTTP Method not allowed"
                };
                var responseJson = JsonSerializer.Serialize(customResponse);
                await context.Response.WriteAsync(responseJson);

                return; //Short Circuiting the Request Processing Pipeline 
            }

            await _next(context);
        }
    }
}

```

- **RequestDelegate _next:** This is a function delegate that represents the next middleware in the ASP.NET Core request processing pipeline. Middleware components are called in sequence, and each one can choose to pass the request to the next component by calling _next.
- **string[] _allowedMethods:** This array holds the list of HTTP methods allowed by this middleware. Any request that does not use one of these methods will be rejected.
- **Constructor:** The HttpMethodMiddleware Constructor initializes the middleware with the next delegate to call in the pipeline and the list of allowed HTTP methods.
- **public async Task InvokeAsync(HttpContext context):** This method is called by the ASP.NET Core runtime to process an HTTP request. It takes an HttpContext object as a parameter, which provides information about the incoming request and a way to modify the outgoing response.
- **if (!_allowedMethods.Contains(context.Request.Method)):** This line checks if the HTTP method of the incoming request is in the list of allowed methods. context.Request.Method returns the HTTP method of the request (e.g., “GET”, “POST”, “PUT”, “DELETE”).
- **context.Response.StatusCode = StatusCodes.Status405MethodNotAllowed;:** If the request’s method is not allowed, this line sets the response status code to “405 Method Not Allowed”. This tells the client that the method used in the request is not supported by the resource.
- **context.Response.ContentType = “application/json”;:** This statement sets the response’s ContentType to application/json. This is important for informing the client that the response body is in JSON format.
- It then writes a JSON string to the response body with a custom error message indicating that the HTTP method used in the request is not allowed. This is done using context.Response.WriteAsync(…), which asynchronously writes the specified data to the HTTP response body.
- **return;:** This statement exits the method early, preventing the request from being passed further down the middleware pipeline.
- **await _next(context);:** If the request’s method is allowed, this line passes the request to the next middleware in the pipeline for further processing.
##### **Register the Middleware**

```C#
var allowedMethods = new[] { "GET", "POST", "DELETE" };

// Use a lambda to manually instantiate the middleware
app.Use(async (context, next) =>
{
    var middleware = new HttpMethodMiddleware(next, allowedMethods);
    await middleware.InvokeAsync(context);
});

```

##### **Creating Controller:**

```C#
using Microsoft.AspNetCore.Mvc;

namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SampleController : ControllerBase
    {
        // This action only supports GET method
        [HttpGet]
        public IActionResult GetAction()
        {
            return Ok("GetAction Data processed");
        }

        // This action only supports POST method
        [HttpPost]
        public IActionResult PostAction()
        {
            return Ok("PostAction Data Processed");
        }

        // This action only supports PUT method
        [HttpPut]
        public IActionResult PutAction()
        {
            return Ok("PutAction Data processed");
        }

        // This action only supports PUT method
        [HttpPatch]
        public IActionResult PatchAction()
        {
            return Ok("PatchAction Data processed");
        }

        // This action only supports DELETE method
        [HttpDelete]
        public IActionResult DeleteAction()
        {
            return Ok("DeleteAction Data processed");
        }
    }
}

```

![[word-image-47171-1.webp]]
![[word-image-47171-2.webp]]

#### **Global Action Filter to Handle 405 Status Code**

You can create a global action filter that checks the HTTP method of incoming requests and decides whether to allow or reject them. This filter can then be added to the MVC options in the Program.cs. So, create a class file named **HttpMethodFilter.cs** and copy and paste the following code.

```C#
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.AspNetCore.Mvc;

namespace ReturnTypeAndStatusCodes.Models
{
    public class HttpMethodFilter : IActionFilter
    {
        private readonly string[] _allowedMethods;

        public HttpMethodFilter(string[] allowedMethods)
        {
            _allowedMethods = allowedMethods;
        }

        public void OnActionExecuting(ActionExecutingContext context)
        {
            if (!_allowedMethods.Contains(context.HttpContext.Request.Method))
            {
                var customResponse = new
                {
                    Code = 405,
                    Message = "HTTP Method not allowed"
                };

                context.Result = new ObjectResult(customResponse)
                {
                    StatusCode = 405
                };
            }
        }

        public void OnActionExecuted(ActionExecutedContext context)
        {
        }
    }
}

```
##### **Registering the Filter Globally:**

Please add the following code to the Program.cs class file. As you can see, while adding the filter, we are specifying which HTTP methods are allowed for our application.
```C#
builder.Services.AddControllers(options =>
{
    options.Filters.Add(new HttpMethodFilter(new[] { "GET", "POST", "DELETE" }));
});
```


# 500 HTTP Status Code in ASP.NET Core Web API

##### **500 HTTP Status Code**

The 500 Internal Server Error is a generic HTTP status code indicating that the server encountered an unexpected condition that prevented it from fulfilling the request. This error falls within the range of 5xx error codes, which signify issues on the server side, as opposed to 4xx error codes that indicate client-side errors. Here are some key points about the 500 Internal Server Error:

##### **Using StatusCode Method:**

```C#
using Microsoft.AspNetCore.Mvc;

namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        [HttpGet]
        public IActionResult GetEmployee()
        {
            try
            {
                // Your logic here
                int x = 10, y = 0;
                int z = x / y; //This statement will throw exception
                return Ok();
            }
            catch (Exception ex)
            {
                // Log the exception details
                
                var customResponse = new
                {
                    Code = 500,
                    Message = "Internal Server Error",

                    // Do not expose the actual error to the client
                    ErrorMessage = ex.Message
                };

                return StatusCode(StatusCodes.Status500InternalServerError, customResponse);
            }
        }
    }
}

```

![[word-image-47177-1.webp]]


```C#
using Microsoft.AspNetCore.Mvc;

namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        [HttpGet]
        public IActionResult GetEmployee()
        {
            try
            {
                // Your logic here
                int x = 10, y = 0;
                int z = x / y; //This statement will throw exception
                return Ok();
            }
            catch (Exception ex)
            {
                // Log the exception details
                
                var customResponse = new
                {
                    Code = 500,
                    Message = "Internal Server Error",

                    // Do not expose the actual error to the client
                    ErrorMessage = ex.Message
                };

                return new ObjectResult(customResponse) 
                { 
                    StatusCode = StatusCodes.Status500InternalServerError 
                };
                
            }
        }
    }
}

```

##### **Using ObjectResult Directly:**

```C#
using Microsoft.AspNetCore.Mvc;

namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        [HttpGet]
        public IActionResult GetEmployee()
        {
            try
            {
                // Your logic here
                int x = 10, y = 0;
                int z = x / y; //This statement will throw exception
                return Ok();
            }
            catch (Exception ex)
            {
                // Log the exception details
                
                var customResponse = new
                {
                    Code = 500,
                    Message = "Internal Server Error",

                    // Do not expose the actual error to the client
                    ErrorMessage = ex.Message
                };

                return new ObjectResult(customResponse) 
                { 
                    StatusCode = StatusCodes.Status500InternalServerError 
                };
                
            }
        }
    }
}

```

![[word-image-47177-2.webp]]

##### **Custom Middleware for Global Error Handling:**

```C#
using System.Text.Json;

namespace ReturnTypeAndStatusCodes.Models
{
    public class ErrorHandlingMiddleware
    {
        private readonly RequestDelegate _next;

        public ErrorHandlingMiddleware(RequestDelegate next)
        {
            _next = next;
        }

        public async Task Invoke(HttpContext context)
        {
            try
            {
                await _next(context);
            }
            catch (Exception ex)
            {
                context.Response.StatusCode = StatusCodes.Status500InternalServerError;
                context.Response.ContentType = "application/json";
                var customErrorResponse = new
                {
                    Code = 500,
                    Message = "Internal Server Error Occurred",
                    ExceptionDetails = ex.Message
                };

                //Log the Exception Details

                var responseJson = JsonSerializer.Serialize(customErrorResponse);
                await context.Response.WriteAsync(responseJson);
            }
        }
    }
}

```

##### **Modifying the Employee Controller:**

```C#
using Microsoft.AspNetCore.Mvc;

namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        [HttpGet]
        public IActionResult GetEmployee()
        {
            // Your logic here
            int x = 10, y = 0;
            int z = x / y; //This statement will throw exception
            return Ok();
        }
    }
}

```

![[Pasted image 20240330185346.png]]

# 501 HTTP Status Code in ASP.NET Core Web API

The 501 HTTP Status Code is defined as “Not Implemented.” It indicates that the server does not support the functionality required to fulfill the request. This response is typically sent when the server lacks the ability to perform a particular action. For example, if a client sends a request method to the server that it does not know how to handle, such as a PUT or DELETE method that the server does not support for any resource, the server might respond with a 501 Status Code. Here are key points regarding the 501 Status Code:

- **Server Capability:** The 501 Status Code signifies that the server either does not recognize the request method or lacks the capability to complete the request. It implies that the server itself might be capable of supporting the request in the future but currently does not.
- **Client Action:** From a client’s perspective, receiving a 501 response typically means nothing wrong. Instead, the issue lies with the server’s ability to handle the request. The client may need to check the request method or consult with the server’s documentation or support to understand what methods are supported.
- **Temporary or Permanent:** The nature of this error could be either temporary or permanent, depending on whether the server plans to implement the functionality in the future or if it intends never to support the specific request method or action.

##### **Using StatusCode Method**

```C#
using Microsoft.AspNetCore.Mvc;

namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SampleController : ControllerBase
    {
        //URL: GET api/Sample/SendEmail
        [HttpGet("SendEmail")]
        public IActionResult SendEmail()
        {
            var customResponse = new
            {
                Code = 501,
                Message = "Email Feature Is Not Implemented",
            };

            //Returning Not Implemented
            return StatusCode(StatusCodes.Status501NotImplemented, customResponse);
        }
    }
}

```

![[word-image-47187-1.webp]]

##### **Custom ActionResult**

```C#
using Microsoft.AspNetCore.Mvc;
using System.Net;

namespace ReturnTypeAndStatusCodes.Models
{
    public class NotImplementedResult : IActionResult
    {
        public Task ExecuteResultAsync(ActionContext context)
        {
            var customResponse = new
            {
                Code = 501,
                Message = "Feature Is Not Implemented",
            };

            var objectResult = new ObjectResult(customResponse)
            {
                StatusCode = (int)HttpStatusCode.NotImplemented
            };

            return objectResult.ExecuteResultAsync(context);
        }
    }
}

```

```C#
using Microsoft.AspNetCore.Mvc;
using ReturnTypeAndStatusCodes.Models;

namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SampleController : ControllerBase
    {
        //URL: GET api/Sample/SendEmail
        [HttpGet("SendEmail")]
        public IActionResult SendEmail()
        {
            return new NotImplementedResult();
        }
    }
}

```

# 503 HTTP Status Code in ASP.NET Core Web API

The HTTP 503 Status Code, known as “Service Unavailable,” is an error response code indicating that the server is not ready to handle the request. This unavailability can be due to several reasons, such as the server being overloaded with requests, undergoing maintenance, or experiencing temporary technical issues.

##### **How to Return 503 HTTP Status Code in ASP.NET Core Web API**
**Configure appsettings.json**

```json
"IsApplicationUnderMaintenance": "true"
```
##### **Implement a Custom Middleware Component:**
Create a new class file named **MaintenanceMiddleware.cs,** then copy and paste the following code. This middleware will intercept requests and return a 503 Status Code if the application is under maintenance. The following MaintenanceMiddleware class checks if the application is under maintenance and, if so, returns a 503 Service Unavailable response.

```C#
using System.Text.Json;

namespace ReturnTypeAndStatusCodes.Models
{
    public class MaintenanceMiddleware
    {
        private readonly RequestDelegate _next;

        public MaintenanceMiddleware(RequestDelegate next)
        {
            _next = next;
        }

        public async Task Invoke(HttpContext httpContext, IConfiguration configuration)
        {
            // Implement your logic here
            // Read a Configuration Value which indicates whether the server Is Under Maintenance 
            bool IsUnderMaintenance = Convert.ToBoolean(configuration["IsApplicationUnderMaintenance"]);

            if (IsUnderMaintenance)
            {
                httpContext.Response.StatusCode = StatusCodes.Status503ServiceUnavailable;
                httpContext.Response.ContentType = "application/json";
                httpContext.Response.Headers.Add("Retry-After", "120");
                var customResponse = new
                {
                    Code = 503,
                    Message = "Service is under maintenance. Please try again later.",
                };

                var responseJson = JsonSerializer.Serialize(customResponse);

                await httpContext.Response.WriteAsync(responseJson);
            }
            else
            {
                await _next(httpContext);
            }
        }
    }
}

```

- **_next:** A field of type RequestDelegate. This delegate represents the next middleware in the pipeline. It’s stored in a private read-only field, ensuring it’s only set once during construction and cannot be changed.
- **Constructor:** The constructor takes a RequestDelegate called next as a parameter. This delegate points to the next middleware in the application’s request pipeline. The passed-in delegate is assigned to the _next field, allowing this middleware to call the next one in the pipeline.
- **Invoke:** This method is required for a class to function as middleware in ASP.NET Core. It must take an HttpContext as a parameter and return a Task. The HttpContext represents information about the current HTTP request and provides methods to deal with the response.
- Inside the Invoke method, we are reading the IsApplicationUnderMaintenance configuration key value from the appsettings.json file. If its value is true, then we are creating a 503 custom error message and returning that to the client. Otherwise, we will proceed with the normal execution flow.

##### **Register the Middleware**

```C#
using Microsoft.AspNetCore.Mvc;
namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SampleController : ControllerBase
    {
        [HttpGet]
        public IActionResult GetResource()
        {
            return Ok("Service is Available");
        }
    }
}

```

![[word-image-47193-1.webp]]

# 504 HTTP Status Code in ASP.NET Core Web API

- **Retry the request:** Simply refreshing the browser or retrying the action after a brief wait can sometimes resolve the issue if it was caused by a temporary glitch or overload.
- **Check network connectivity:** Ensuring there are no network issues on the client side that could be preventing communication with the server.
- **Contact the website or service provider:** If the issue persists, reaching out to the website or service’s support team can help, as they may be aware of the issue and can provide updates or workarounds.
##### **Directly in an Action Method:**

```C#
using Microsoft.AspNetCore.Mvc;
namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SampleController : ControllerBase
    {
        [HttpGet]
        public async Task<IActionResult> GetResource()
        {
            //Creating an Instance of CancellationTokenSource
            CancellationTokenSource cancellationTokenSource = new CancellationTokenSource();
            
            //Setting the Duration to 5 Seconds after which it will cancel the execution
            cancellationTokenSource.CancelAfter(5000);

            try
            {
                await LongRunningTask(cancellationTokenSource.Token);

                return Ok("Operation Successful");
            }
            catch (Exception ex)
            {
                //Log the Error Message

                // Return a 504 Gateway Timeout response
                var customResponse = new
                {
                    Code = 504,
                    Message = $"The request timed out waiting for an external service.",

                    //Do Not Expose the Actual Error Message to the Client
                    //ErrorMessage = ex.Message
                };
                
                return StatusCode(504, customResponse);
            }
        }

        public static async Task LongRunningTask(CancellationToken token)
        {
            //Actual Service Call and Database Call goes here

            for (int i = 0; i < 10; i++)
            {
                if (token.IsCancellationRequested)
                {
                    throw new TaskCanceledException();
                }

                //Delaying the Execution for 10 Secons
                await Task.Delay(1000);
            }
        }
    }
}

```
![[word-image-47200-1.webp]]

##### **Using Custom Middleware to Handle 504 Gateway Timeout Error in ASP.NET Core Web API:**
If you want to apply this behaviour globally, consider implementing a custom middleware component. Middleware allows you to inspect and modify HTTP requests and responses flowing through your application’s pipeline.

So, create a class file named **TimeoutMiddleware.cs** and copy and paste the following code. The following middleware will check for a specific condition (like a timeout exception) and set the response status code accordingly:
```C#
using System.Text.Json;

namespace ReturnTypeAndStatusCodes.Models
{
    public class TimeoutMiddleware
    {
        private readonly RequestDelegate _next;

        public TimeoutMiddleware(RequestDelegate next)
        {
            _next = next;
        }

        public async Task Invoke(HttpContext httpContext)
        {
            try
            {
                await _next(httpContext);
            }
            catch (TimeoutException)
            {
                if (!httpContext.Response.HasStarted)
                {
                    httpContext.Response.Clear();
                    httpContext.Response.StatusCode = 504; // Gateway Timeout

                    httpContext.Response.ContentType = "application/json";
                    var customResponse = new
                    {
                        Code = 504,
                        Message = "Server did not receive a timely response from an upstream server.",
                    };

                    var responseJson = JsonSerializer.Serialize(customResponse);
                    await httpContext.Response.WriteAsync(responseJson);
                }
            }
        }
    }
}

```


- **RequestDelegate _next:** This private field holds the next piece of middleware in the application pipeline. A RequestDelegate is a function that handles an HTTP request and returns a Task. In the context of middleware, this delegate represents the next middleware component that should be invoked.
- **Constructor:** The constructor takes a RequestDelegate named next as a parameter. This delegate points to the next middleware in the pipeline. The passed delegate is assigned to the _next field, allowing the current middleware to call the next one in the sequence.
- **Invoke Method:** The Invoke method is the core of any middleware component. It is called by the ASP.NET Core framework for each HTTP request. The method takes an HttpContext object as a parameter, which represents all HTTP-specific information about an individual HTTP request.
- **await _next(httpContext):** This line asynchronously invokes the next middleware in the pipeline, passing along the HttpContext object. By calling _next, the middleware defers control to the subsequent middleware, allowing the request to progress further through the pipeline.
- **catch (TimeoutException):** This block catches any TimeoutException thrown by the downstream middleware or the application code. A TimeoutException typically indicates that a task or operation has not been completed in an expected time frame.
- **Response Handling:** Before modifying the response, it checks if the response has not already started using httpContext.Response.HasStarted. This is crucial because headers and status codes can only be modified before any part of the response body is written. If the response has not started, the middleware:
    1. Clears any existing content in the response by calling httpContext.Response.Clear().
    2. Sets the HTTP status code to 504 (Gateway Timeout) to indicate that the server, acting as a gateway or proxy, did not receive a timely response from an upstream server.
    3. Write a custom error message to the response body explaining the issue.

##### **Modifying the Sample Controller:**

```C#
using Microsoft.AspNetCore.Mvc;
namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SampleController : ControllerBase
    {
        [HttpGet]
        public IActionResult GetResource()
        {
            throw new TimeoutException("The operation took longer than the allowed time.");
        }
    }
}

```

![[word-image-47200-2.webp]]

##### **Causes of a 504 Gateway Timeout Error**

- **Network Issues:** The most common cause is Network Issues between your server and the upstream server it’s trying to communicate with.
- **Server Overload:** The upstream server might be overloaded and unable to handle the request in a timely manner.
- **Faulty Firewall Configurations:** Sometimes, firewall or security configurations can block or delay communications between servers.
- **DNS Issues:** Incorrect DNS configurations can lead to your server being unable to resolve the address of the upstream service.
- **Timeout Configurations:** If the timeout settings for the upstream request are too short, this can lead to premature 504 errors.

##### **Handling 504 Errors in ASP.NET Core Web API**

To handle 504 Gateway Timeout errors effectively in an ASP.NET Core Web API, consider the following strategies:

- **Error Handling Middleware:** Implement custom middleware to catch and log 504 errors. This can help in diagnosing whether the issue is within your control or due to external services.
- **Increase Timeout Settings:** If the issue is related to short timeout periods, consider increasing the timeout settings for your HTTP client requests in your API.
- **Retry Mechanisms:** Implement retry logic for requests to upstream services. 
- **Monitoring and Alerts:** Utilize application performance monitoring (APM) tools to track these errors. Setting up alerts for 504 errors can help in quickly identifying and responding to issues.
- **Communicate with Upstream Services:** If a particular service is consistently causing 504 errors, communication with the service provider is necessary. They might be unaware of the issues or could provide guidance on mitigating them.
