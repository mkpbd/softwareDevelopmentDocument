
##### **Why Content Negotiation in Rest Services?**

We know that there are three pillars of the Restful Web Service and they are:

- The Resource
- The URL
- The Representation

##### **How Does the Content Negotiation Work?**

Content Negotiation primarily involves two HTTP headers: Accept and Content-Type.

- **Accept Header:** Used by the client to specify the media types it is willing and able to understand and process. For instance, a client can use the Accept header to indicate that it prefers to receive data in the JSON format (application/json) or XML format (application/xml).
- **Content-Type Header:** Used by the server to specify the media type of the response content it sends back to the client. It tells the client in what format the response data is encoded, ensuring that the client knows how to parse and process the data received.

###### **Client Request**

The client initiates the content negotiation process by including specific HTTP headers in its request to the server. The most relevant headers for content negotiation are:

- **Accept:** Specifies the media types (MIME types) the client is willing to receive. For example, application/json, application/xml, or text/html.
- **Accept-Language:** Indicates the preferred languages for the response, such as en-US or fr-CA.
- **Accept-Charset:** Specifies the character sets the client prefers, like UTF-8 or ISO-8859-1.
- **Accept-Encoding:** Indicates the encoding schemes (e.g., gzip, deflate) the client can decode.

###### **Server Processing**

Upon receiving the request, the server evaluates the client’s preferences against the available representations of the requested resource. The server uses the following logic:

- **Media Type Selection:** The server selects the most appropriate media type based on the Accept header. It chooses the Representation that best matches the client’s preferences.
- **Language Selection:** The server selects the preferred language based on the Accept-Language header if the resource is available in multiple languages.
- **Character Set and Encoding Selection:** Similarly, the server selects a character set and encoding matching the client’s preferences as specified in the Accept-Charset and Accept-Encoding headers.

###### **Server Response**

The server responds to the client with the selected Representation of the resource. It includes HTTP headers in the response to indicate the chosen format:

- **Content-Type:** Specifies the media type of the returned resource, e.g., application/json or application/xml.
- **Content-Language:** Indicates the language of the response.
- **Content-Encoding:** Specifies the encoding used for the response data.

##### **Example to Understand Content Negotiation in ASP.NET Core Web API:**

```C#
namespace ModelBinding.Models
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

##### **Creating Employee Controller:**

```c#
using Microsoft.AspNetCore.Mvc;
using ModelBinding.Models;

namespace ModelBinding.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        [HttpGet]
        public ActionResult<List<Employee>> GetEmployees()
        {
            var listEmployees = new List<Employee>()
            {
                new Employee(){ Id = 1001, Name = "Anurag", Age = 28, Gender = "Male", Department = "IT" },
                new Employee(){ Id = 1002, Name = "Pranaya", Age = 28, Gender = "Male", Department = "IT" },
            };

            return Ok(listEmployees);
        }
    }
}
```

##### **Testing the API using Accept Header:**

![[word-image-47279-1.webp]]

![[word-image-47279-2.webp]]
![[word-image-47279-3.webp]]

##### **How do you enable the XML Formatter in ASP.NET Core Web API?**

program.cs
```c#
builder.Services.AddControllers()
                .AddXmlSerializerFormatters();
```

![[word-image-47279-4.webp]]

##### **What happens if we specify both application/json and application/xml in the Accept Header?**

![[word-image-47279-5.webp]]

**application/xml;q=0.5,application/json;q=0.8**
![[word-image-47279-6.webp]]

##### **How do you remove the JSON Serializer in ASP.NET Core Web API?**
program.cs
```c#
builder.Services.AddControllers(options =>
{
    // Remove JSON formatter
    options.OutputFormatters.RemoveType<Microsoft.AspNetCore.Mvc.Formatters.SystemTextJsonOutputFormatter>();
}).AddXmlSerializerFormatters(); //Adding XML Formatter
```


##### **How do you return 406 Not Acceptable Status Code if the Accepted Formatter is Not Available in ASP.NET Core Web API?**

```c#
builder.Services.AddControllers(options =>
{
    // Enable 406 Not Acceptable status code
    options.ReturnHttpNotAcceptable = true;
})
// Optionally, configure JSON options or other Formatter settings
.AddJsonOptions(options =>
{
    // Configure JSON serializer settings if needed
    options.JsonSerializerOptions.PropertyNamingPolicy = null;
});
```

![[word-image-47279-7.webp]]

##### **Creating Custom Middleware Component:**

```c#
using System.Text.Json;

namespace ModelBinding.Models
{
    public class CustomNotAcceptableMiddleware
    {
        private readonly RequestDelegate _next;

        public CustomNotAcceptableMiddleware(RequestDelegate next)
        {
            _next = next;
        }

        public async Task Invoke(HttpContext context)
        {
            await _next(context);

            if (context.Response.StatusCode == StatusCodes.Status406NotAcceptable)
            {
                // Retrieve the Accept header from the request
                var acceptHeader = context.Request.Headers["Accept"].ToString();

                // Custom response logic here
                context.Response.ContentType = "application/json";
                var response = new 
                { 
                    Code = StatusCodes.Status406NotAcceptable,
                    ErrorMessage = $"The Requested Format {acceptHeader} is Not Supported." 
                };
                await context.Response.WriteAsync(JsonSerializer.Serialize(response));
            }
        }
    }
}
```

##### **Register the Middleware**
![[word-image-47279-8.webp]]

## **Include and Exclude Properties from Model Binding in ASP.NET Core Web API**

```c#
namespace ModelBinding.Models
{
    public class Employee
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Gender { get; set; }
        public int Age { get; set; }
        public int Salary { get; set; }
        public string Department { get; set; }
    }
}
```

##### **Creating the Employee Controller:**

```C#
using Microsoft.AspNetCore.Mvc;
using ModelBinding.Models;

namespace ModelBinding.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        private List<Employee> listEmployees = new List<Employee>()
        {
            new Employee(){ Id = 1, Name = "Anurag", Age = 28, Salary=1000, Gender = "Male", Department = "IT" },
            new Employee(){ Id = 2, Name = "Pranaya", Age = 28, Salary=2000, Gender = "Male", Department = "IT" },
        };

        [HttpGet]
        public ActionResult<List<Employee>> GetEmployees()
        {
            return Ok(listEmployees);
        }

        [HttpPost]
        public ActionResult<Employee> AddEmployee(Employee employee)
        {
            if(employee != null)
            {
                //Manually Setting the Id and Salary
                employee.Id = listEmployees.Count + 1;
                employee.Salary = 3000;
                listEmployees.Add(employee);
                return Ok(employee);
            }
            return BadRequest();
        }
    }
}
```

![[word-image-47292-1.webp]]
![[word-image-47292-2.webp]]

##### **Using JsonIgnore Attribute:**

```C#
using System.Text.Json.Serialization;
namespace ModelBinding.Models
{
    public class Employee
    {
        [JsonIgnore]
        public int Id { get; set; }
        public string Name { get; set; }
        public string Gender { get; set; }
        public int Age { get; set; }
        [JsonIgnore]
        public int Salary { get; set; }
        public string Department { get; set; }
    }
}
```


![[word-image-47292-3.webp]]

![[word-image-47292-4.webp]]

![[word-image-47292-5.webp]]

##### **Using Custom Model Class:**

```C#
namespace ModelBinding.Models
{
    public class EmployeeDTO
    {
        public string Name { get; set; }
        public string Gender { get; set; }
        public int Age { get; set; }
        public string Department { get; set; }
    }
}
```
##### **Modifying the Employee Controller:**
```C#
using Microsoft.AspNetCore.Mvc;
using ModelBinding.Models;

namespace ModelBinding.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        private List<Employee> listEmployees = new List<Employee>()
        {
            new Employee(){ Id = 1, Name = "Anurag", Age = 28, Salary=1000, Gender = "Male", Department = "IT" },
            new Employee(){ Id = 2, Name = "Pranaya", Age = 28, Salary=2000, Gender = "Male", Department = "IT" },
        };

        [HttpGet]
        public ActionResult<List<EmployeeDTO>> GetEmployees()
        {
            List<EmployeeDTO> employees = new List<EmployeeDTO>();

            foreach (var employee in listEmployees)
            {
                EmployeeDTO emp = new EmployeeDTO()
                {
                    //Setting the Name, Age, Gender, and Department
                    Name = employee.Name,
                    Age = employee.Age,
                    Gender = employee.Gender,
                    Department = employee.Department,
                };
                employees.Add(emp);
            }
            return Ok(employees);
        }

        [HttpPost]
        public ActionResult<EmployeeDTO> AddEmployee(EmployeeDTO employee)
        {
            if(employee != null)
            {
                Employee emp = new Employee()
                {
                    //Manually Setting the Id and Salary
                    Id = listEmployees.Count + 1,
                    Salary = 3000,

                    //Setting the Name, Age, Gender, and Department from EmployeeDTO
                    Name = employee.Name,
                    Age = employee.Age,
                    Gender = employee.Gender,
                    Department = employee.Department,
                };
                
                listEmployees.Add(emp);
                return Ok(employee);
            }
            return BadRequest();
        }
    }
}
```

