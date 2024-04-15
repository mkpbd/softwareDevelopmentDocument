##### **What is Model Binding in ASP.NET Core Web API?**

Model Binding in ASP.NET Core Web API is a process that allows the mapping of client request data (from various sources such as the query string, route data, HTTP headers, or the request body) to action method parameters. ASP.NET Core provides a flexible and configurable model binding system that can automatically deserialize request data into complex types.

Model Binding in ASP.NET Core Web API is a process that allows the framework to automatically convert client request data (from query strings, request body, route data, form data, etc.) into .NET objects that are passed into an action method’s parameters.

##### **Model Binding Techniques in ASP.NET Core Web API**

Understanding the various model binding techniques can greatly enhance your ability to process incoming requests efficiently. Model Binding in ASP.NET Core Web API can extract data from various parts of an HTTP request, including:

- Form Data
- Query Strings
- Route Data
- HTTP Headers
- Request Body

##### **FromBody in ASP.NET Core Web API**

- **Usage**: To bind data from the body of an HTTP request. Ideal for POST, PUT or PATCH requests where the message body contains the data.
- **Common Use Cases**: JSON or XML payloads.
- **How It Works**: The [FromBody] attribute indicates that a parameter should be deserialized from the request body. This is commonly used for JSON or XML data sent by the client in a POST, PUT, or PATCH request.
- **Considerations:** The content type of the request (e.g., application/json) must match the expected format.

##### **FromQuery in ASP.NET Core Web API**

- **Usage:** To bind data from the query string.
- **Common Use Cases**: Filtering data in a GET request.
- **How It Works:** Parameters are bound from the query string automatically or can be explicitly specified using the [FromQuery] attribute. It’s useful for simple types like int, string, or custom objects populated from the query string.
- **Considerations:** It’s suitable for non-sensitive data and operations that don’t require complex object payloads.

##### **FromRoute in ASP.NET Core Web API**

- **Usage:** To bind data from the route data.
- **Common Use Cases**: Specifying an item ID in a RESTful URL.
- **How It Works**: The [FromRoute] attribute binds parameters from the route data (URL segments). It’s used for actions that operate on a specific resource identified by a URL segment.
- **Considerations:** The route template must include the parameter, typically specified in the Program.cs or in controllers using Route Attribute and HTTP methods.

##### **FromForm in ASP.NET Core Web API**

- **Usage:** To bind data from posted form fields.
- **Common Use Cases:** Uploading files or receiving form data.
- **How It Works:** The [FromForm] attribute binds action parameters from form data in a multipart/form-data request. It’s commonly used for file uploads or when submitting web forms.
- **Considerations:** It’s particularly useful when the request includes file uploads along with data.

##### **FromHeader in ASP.NET Core Web API**

- **Usage:** To bind data from HTTP headers.
- **Common Use Cases:** Authentication tokens or other metadata.
- **How It Works:** The [FromHeader] attribute maps a parameter to a request header. This is often used for parameters that represent request metadata, such as tokens or versioning information.
- **Considerations:** Header names are case-insensitive and can represent single values or lists.

##### **Custom Model Binding in ASP.NET Core Web API**

Custom model binders can be implemented by extending certain base classes or interfaces provided by ASP.NET Core, such as IModelBinder or ModelBinderProvider. This is useful when the default model binding behaviour needs to be customized or overridden for specific scenarios. You can create a custom model binder when the built-in binders do not meet your requirements.

##### **Best Practices for Model Binding**

- **Use the Correct Binding Source Attributes:** Clearly specify the source of each action method parameter using the appropriate attributes. This improves the readability and maintainability of your code.
- **Validation:** Use model validation to ensure the data bound to your models meets your criteria. ASP.NET Core supports automatic model validation and can return HTTP 400 responses when validation fails.
- **Use Specific Types:** Define models that closely match your API’s data structure to leverage strong typing and validation effectively.
- **Performance Considerations:** Be mindful of the size and complexity of the data being bound, especially for large JSON payloads. Consider using streaming or chunking for handling large amounts of data efficiently.



# Model Binding using FromForm in ASP.NET Core Web API

In ASP.NET Core Web API, model binding refers to the process of mapping request data to action method parameters. The FromForm attribute is used to bind data from an HTTP request form body to a method parameter. This is particularly useful when dealing with forms that submit data via POST requests, especially in scenarios where you’re uploading files or sending data in a format that mimics a traditional HTML form.

##### **FromForm Example in ASP.NET Core Web API**

Here’s a step-by-step example of how to use the [FromForm] attribute in an ASP.NET Core Web API project:

##### **Create a Model**

First, define a model that corresponds to the data you expect to receive from the form. For instance, if you are expecting to receive user information, you might create a model like this. So, create a class file named **UserModel.cs** and then copy and paste the following code:


```C#
namespace ModelBinding.Models
{
    public class UserModel
    {
        public string Name { get; set; }
        public string Email { get; set; }
        // Add other properties as needed
    }
}
```

##### **Create an API Controller** 
```C#
using Microsoft.AspNetCore.Mvc;
using ModelBinding.Models;
namespace ModelBinding.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        [HttpPost]
        public IActionResult CreateUser([FromForm] UserModel user)
        {
            // Handle the user data, e.g., save it to a database
            var response = new
            {
                Success = true,
                Message = $"User {user.Name} created successfully!",
                Code = StatusCodes.Status200OK
            };
            return Ok(response);
        }
    }
}
```

##### **Testing the API**

To test the API, you can use Postman or create a simple HTML form that posts data to your API endpoint. To test using Postman, open Postman, select the method type as POST, provide the endpoint URL in the request body, select form-data, provide the Key name same as your model name, select the type as text and provide the corresponding values, and finally click on the Send button as shown in the below image:
![[word-image-47208-1.webp]]


Once you click on the Send button, then you will get the following response:
![[word-image-47208-2.webp]]

##### **Test using HTML form:**

So, create an HTML file (file with .html or .html extension) and then copy and paste the following code. Please change the port number where your application is running.
```c#

<form action="https://localhost:7121/api/User" method="post">

<input type="text" name="Name" placeholder="Name" required />

<input type="email" name="Email" placeholder="Email" required />

<button type="submit">Submit</button>

</form>
```

Now, once you open the HTML file in a web browser, then it will show the following. Please enter your Name and email and then click on the Submit button as shown in the below image:
![[word-image-47208-4.webp]]
##### **Points to Remember:**

- The [FromForm] attribute is designed to handle application/x-www-form-urlencoded and multipart/form-data content types, which are commonly used for forms.
- For file uploads, use IFormFile within your model and bind it using the [FromForm] attribute.
- Ensure client requests are properly formatted and match the expected model structure to avoid binding issues.

##### **Handling File Uploads Using FromForm in ASP.NET Core Web API:**

The FromForm attribute can also handle file uploads. You can include properties of type IFormFile within your model to bind to uploaded files. Let us understand this with one example. So, modify the UserModel as follows:

```C#
namespace ModelBinding.Models
{
    public class UserModel
    {
        public string Name { get; set; }
        public string Email { get; set; }
        public IFormFile ProfilePicture { get; set; }
        // Add other properties as needed
    }
}
```

##### **Modifying the User Controller:**

Next, modify the User Controller as follows. If your form includes file uploads, your model can include one or more IFormFile properties. The [FromForm] attribute ensures that these files are bound correctly to the model. You can then process these files in your action method, for example, by saving them to a server directory.

```C# 
using Microsoft.AspNetCore.Mvc;
using ModelBinding.Models;
namespace ModelBinding.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        [HttpPost]
        public async Task<IActionResult> CreateUser([FromForm] UserModel user)
        {
            if (user.ProfilePicture != null)
            {
                var uploadsFolderPath = Path.Combine(Directory.GetCurrentDirectory(), "Uploads");
                if (!Directory.Exists(uploadsFolderPath))
                {
                    Directory.CreateDirectory(uploadsFolderPath);
                }

                var filePath = Path.Combine(uploadsFolderPath, user.ProfilePicture.FileName);
                using (var stream = new FileStream(filePath, FileMode.Create))
                {
                    await user.ProfilePicture.CopyToAsync(stream);
                }

                // Handle the user data, e.g., save it to a database
                var response = new
                {
                    Success = true,
                    Message = $"User {user.Name} created successfully!",
                    ProfilePictureName = user?.ProfilePicture?.FileName,
                    Code = StatusCodes.Status200OK
                };
                return Ok(response);
            }
            return BadRequest(ModelState);
        }
    }
}
```

##### **Testing the API**

To test using Postman, open Postman, select the method type as POST, provide the endpoint URL, in the request body select form-data, provide the Key name same as your model name, select the type as text (Name and Email) and file (Profile Picture) as per the data and provide the corresponding values for Name and Email, select the Profile Picture for the File type and finally click on the Send button as shown in the below image. This will also automatically set the Content-Type header value to multipart/form-data in the request header.
![[word-image-47208-5.webp]]


Once you click on the Send button, then you will get the following response:
![[word-image-47208-6.webp]]
![[word-image-47208-7.webp]]

##### **Test using HTML form:**

So, test using HTML and then copy and paste the following code. Please change the port number where your application is running.


```html
<form action="https://localhost:7121/api/User" method="post" enctype="multipart/form-data">
    <input type="text" name="Name" placeholder="Name" required /> </br>
    <input type="email" name="Email" placeholder="Email" required /></br>
    <input type="file" name="ProfilePicture" id="ProfilePicture"></br>
    <button type="submit">Submit</button>
</form>
```

![[word-image-47208-8.webp]]
![[word-image-47208-9.webp]]

## **Model Binding using FromQuery in ASP.NET Core Web API**

##### **What is a Query String in ASP.NET Core Web API?**

A Query String in ASP.NET Core Web API is a part of the URL that comes after the question mark (?) and is used to pass key-value pairs of information to the server. This method of sending data to the server is part of the HTTP request and is typically used for filtering, sorting, or specifying the nature of the request without changing the resource’s URI.

A Query String comprises one or more key-value pairs, where each pair is separated by an ampersand (&). The key and value in each pair are separated by an equals sign (=). For example, in the URL **https://example.com/api/values?Department=IT&Gender=Male**, the query string is Department=IT&Gender=Male, with Department and Gender being the keys and IT and Male their respective values.

##### **Model Binding using FromQuery in ASP.NET Core Web API**

Model binding in ASP.NET Core Web API allows you to map request data to action method parameters automatically. The FromQuery attribute is one of the model binding sources that tells ASP.NET Core to get the value of a method parameter from the query string of the request URL.

This is particularly useful for HTTP GET requests, where you want to retrieve data based on parameters supplied as part of the query string, such as filtering data, pagination, or passing other simple parameters to the server without needing a complex request body.

When a client sends a request to your Web API, the query string values can be automatically bound to the parameters of the corresponding action method, provided the names of the query string parameters match the names of the action method’s parameters. The following are the key points of the FromQuery attribute:

- **Purpose:** FromQuery specifies that an action method parameter should be bound from the query string.
- **Usage Scenario:** Ideal for reading complex data from the query string in HTTP GET requests.
- **How It Works:** ASP.NET Core model binding system automatically maps query parameters from the URL to the parameters in your controller action method marked with [FromQuery].

##### **Example to Understand FromQuery Attribute in ASP.NET Core Web API:**

Let us see an Example to Understand the FromQuery Attribute in ASP.NET Core Web API. First, modify the UserModel class as follows, which will hold the User data.

```C#
namespace ModelBinding.Models
{
    public class UserModel
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Department { get; set; }
        public string Gender { get; set; }
        public int Salary { get; set; }
    }
}
```


##### **Basic Usage:**

To use FromQuery, you need to decorate the parameters of your action method with the [FromQuery] attribute. This tells ASP.NET Core to look for values with matching names in the query string and bind them to the parameters. For a better understanding, please modify the User Controller as follows.

```C#
using Microsoft.AspNetCore.Mvc;
using ModelBinding.Models;
namespace ModelBinding.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private static List<UserModel> Users = new List<UserModel>
        {
            new UserModel { Id = 1, Name = "Rakesh", Department = "IT", Gender = "Male", Salary = 1000 },
            new UserModel { Id = 2, Name = "Priyanka", Department = "IT", Gender = "Female", Salary = 2000  },
            new UserModel { Id = 3, Name = "Suresh", Department = "HR", Gender = "Male", Salary = 3000 },
            new UserModel { Id = 4, Name = "Hina", Department = "HR", Gender = "Female", Salary = 4000 },
            new UserModel { Id = 5, Name = "Pranaya", Department = "HR", Gender = "Male", Salary = 35000 },
            new UserModel { Id = 6, Name = "Pooja", Department = "IT", Gender = "Female", Salary = 2500 },
        };

        [HttpGet]
        public IActionResult GetProducts([FromQuery] string Department)
        {
            // Implementation to retrieve employees based on the Department
            var FilteredUsers = Users.Where(emp => emp.Department.Equals(Department, StringComparison.OrdinalIgnoreCase)).ToList();
            if(FilteredUsers.Count > 0)
            {
                return Ok(FilteredUsers);
            }
            return NotFound($"No Users Found with Department: {Department}");
        }
    }
}
```

![[word-image-47211-1.webp]]

##### **Customizing Query Parameter Names:**

You can customize the query parameter names by specifying the name in the [FromQuery] attribute if the query string parameter name should be different from the method parameter name. For a better understanding, please modify the User Controller as follows:

```C#
using Microsoft.AspNetCore.Mvc;
using ModelBinding.Models;
namespace ModelBinding.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private static List<UserModel> Users = new List<UserModel>
        {
            new UserModel { Id = 1, Name = "Rakesh", Department = "IT", Gender = "Male", Salary = 1000 },
            new UserModel { Id = 2, Name = "Priyanka", Department = "IT", Gender = "Female", Salary = 2000  },
            new UserModel { Id = 3, Name = "Suresh", Department = "HR", Gender = "Male", Salary = 3000 },
            new UserModel { Id = 4, Name = "Hina", Department = "HR", Gender = "Female", Salary = 4000 },
            new UserModel { Id = 5, Name = "Pranaya", Department = "HR", Gender = "Male", Salary = 35000 },
            new UserModel { Id = 6, Name = "Pooja", Department = "IT", Gender = "Female", Salary = 2500 },
        };

        [HttpGet]
        public IActionResult GetProducts([FromQuery(Name ="Dept")] string Department)
        {
            // Implementation to retrieve employees based on the Department
            var FilteredUsers = Users.Where(emp => emp.Department.Equals(Department, StringComparison.OrdinalIgnoreCase)).ToList();
            if (FilteredUsers.Count > 0)
            {
                return Ok(FilteredUsers);
            }
            return NotFound($"No Users Found with Department: {Department}");
        }
    }
}
```
![[word-image-47211-2.webp]]

##### **FromQuery with Complex Type in ASP.NET Core Web API:**

If you have multiple query parameters, it might be cleaner to use a complex type to represent them. ASP.NET Core can bind query string parameters to properties of a complex type.

The FromQuery Attribute can also bind complex types. By default, the ASP.NET Core map the complex type parameter with the request body. But if you want, then you can also map the complex type parameter with the query string. For this, we need to decorate the complex type parameter with the FromQuery Attribute, and the query string keys must match the Complex type properties.

Let us understand this with an example. Suppose we want to search the users by Department and Gender. So, let us first create a class file named **UserSearch.cs** and then copy and paste the following code. We will use this model to map with the query string parameters.

```C#
namespace ModelBinding.Models
{
    public class UserSearch
    {
        public string Department { get; set; }
        public string Gender { get; set; }
    }
}
```
##### **Modifying the User Controller:**

Next, modify the User Controller as follows. Here, we have marked the UserSearch parameter with the FromQuery Attribute, meaning this parameter’s properties will map with the query string parameter.

```C#
using Microsoft.AspNetCore.Mvc;
using ModelBinding.Models;
namespace ModelBinding.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private static List<UserModel> Users = new List<UserModel>
        {
            new UserModel { Id = 1, Name = "Rakesh", Department = "IT", Gender = "Male", Salary = 1000 },
            new UserModel { Id = 2, Name = "Priyanka", Department = "IT", Gender = "Female", Salary = 2000  },
            new UserModel { Id = 3, Name = "Suresh", Department = "HR", Gender = "Male", Salary = 3000 },
            new UserModel { Id = 4, Name = "Hina", Department = "HR", Gender = "Female", Salary = 4000 },
            new UserModel { Id = 5, Name = "Pranaya", Department = "HR", Gender = "Male", Salary = 35000 },
            new UserModel { Id = 6, Name = "Pooja", Department = "IT", Gender = "Female", Salary = 2500 },
        };

        [HttpGet]
        public IActionResult GetUsers([FromQuery] UserSearch userSearch)
        {
            var FilteredUsers = new List<UserModel>();
            if (userSearch != null)
            {
                FilteredUsers = Users.Where(
                       emp => emp.Department.Equals(userSearch.Department, StringComparison.OrdinalIgnoreCase) ||
                       emp.Gender.Equals(userSearch.Gender, StringComparison.OrdinalIgnoreCase)
                       ).ToList();

                if (FilteredUsers.Count > 0)
                {
                    return Ok(FilteredUsers);
                }
                return NotFound($"No Users Found with Department: {userSearch?.Department} and Gender: {userSearch?.Gender}");
            }
            return BadRequest("Invalid Search Criteria");
        }
    }
}
```
![[word-image-47211-3.webp]]
![[word-image-47211-4.webp]]

##### **How to Make the Query String Parameters Optional in ASP.NET Core Web API?**
```C#
namespace ModelBinding.Models
{
    public class UserSearch
    {
        public string? Department { get; set; }
        public string? Gender { get; set; }
    }
}
```

##### **How Does FromQuery Work in ASP.NET Core Web API?**

When a request is made to an ASP.NET Core Web API, the model binding system checks the parameters of the action method being called. If a parameter is decorated with the FromQuery attribute, the model binder looks for a value with a matching name in the query string of the request URL.

- **Parameter Binding:** If the method parameter is a simple type (e.g., int, string, DateTime), model binding looks for a query string parameter with the same name and attempts to convert the value to the parameter type.
- **Complex Type Binding:** For complex types, model binding attempts to map query string parameters to the properties of the complex type. Each property is matched based on the name. For example, if you have a complex object with properties FirstName and LastName, you can pass them in the query string as **?FirstName=John&LastName=Doe**.


# Model Binding Using FromRoute in ASP.NET Core Web API

##### **FromRoute in ASP.NET Core Web API**

Model Binding in ASP.NET Core Web API is a mechanism that enables the application to take client request data (such as route data, query string parameters, request body contents, etc.) and convert it into objects that the controller actions can work with. FromRoute is one of the model binding attributes provided by ASP.NET Core that tells the framework to retrieve the value of a parameter from the route data.

##### **Example to Understand FromRoute Attribute in ASP.NET Core Web API:**

Let us see an Example to Understand the FromRoute Attribute in ASP.NET Core Web API. We are going to use the following Product model. So, create a class file named **Product.cs** and then copy and paste the following code:
```C#
namespace ModelBinding.Models
{
    public class Product
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int Quantity { get; set; }
        public string Categogy { get; set; }
        public int Price { get; set; }
    }
}
```

##### **Basic Example**

Suppose you have an API endpoint that retrieves a specific Product by ID. The ID is part of the URL path. For a better understanding, please create an API Controller with the name Products Controller and then copy and paste the following code:

```C#
using Microsoft.AspNetCore.Mvc;
using ModelBinding.Models;

namespace ModelBinding.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductsController : ControllerBase
    {
        private static List<Product> Products = new List<Product>
        {
            new Product { Id = 1, Name = "Laptop", Categogy = "Electronics", Price = 1000, Quantity = 10 },
            new Product { Id = 2, Name = "Desktop", Categogy = "Electronics", Price = 2000, Quantity = 20 },
            new Product { Id = 3, Name = "Mobile", Categogy = "Electronics", Price = 3000, Quantity = 30 },
            new Product { Id = 4, Name = "Casual Shirts", Categogy = "Apparel", Price = 500, Quantity = 10 },
            new Product { Id = 5, Name = "Formal Shirts", Categogy = "Apparel", Price = 600, Quantity = 30 },
            new Product { Id = 6, Name = "Jackets & Coats", Categogy = "Apparel", Price = 700, Quantity = 20 },
        };

        [HttpGet("{id}")] 
        public IActionResult GetProductById([FromRoute] int id)
        {
            // Logic to retrieve the user by ID
            var product = Products.FirstOrDefault(prd => prd.Id == id);
            if (product != null)
            {
                return Ok(product);
            }
            return NotFound($"No Product Found with Product Id: {id}");
        }
    }
}
```
![[word-image-47212-1.webp]]

##### **How to Assign a Different Name to Route Parameter in ASP.NET Core Web API**

```C#
using Microsoft.AspNetCore.Mvc;
using ModelBinding.Models;

namespace ModelBinding.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductsController : ControllerBase
    {
        private static List<Product> Products = new List<Product>
        {
            new Product { Id = 1, Name = "Laptop", Categogy = "Electronics", Price = 1000, Quantity = 10 },
            new Product { Id = 2, Name = "Desktop", Categogy = "Electronics", Price = 2000, Quantity = 20 },
            new Product { Id = 3, Name = "Mobile", Categogy = "Electronics", Price = 3000, Quantity = 30 },
            new Product { Id = 4, Name = "Casual Shirts", Categogy = "Apparel", Price = 500, Quantity = 10 },
            new Product { Id = 5, Name = "Formal Shirts", Categogy = "Apparel", Price = 600, Quantity = 30 },
            new Product { Id = 6, Name = "Jackets & Coats", Categogy = "Apparel", Price = 700, Quantity = 20 },
        };

        // Assuming your route template specifies a parameter named "Id"
        // but you want to use "ProductId" within your action method
        [HttpGet("{Id}")] 
        public IActionResult GetProductById([FromRoute(Name = "Id")] int ProductId)
        {
            // Now, you can use "ProductId" to refer to the parameter that comes from the route.
            // Fetch the Product by the ProductId and return a response
           
            var product = Products.FirstOrDefault(prd => prd.Id == ProductId);
            if (product != null)
            {
                return Ok(product);
            }
            return NotFound($"No Product Found with Product Id: {ProductId}");
        }
    }
}
```
##### **FromRoute Attribute with Complex Type in ASP.NET Core Web API:**

```c#
namespace ModelBinding.Models
{
    public class ProductRoute
    {
        public string Name { get; set; }
        public string Category { get; set; }
    }
}
```

##### **Modifying the Products Controller:**

Next, modify the Products Controller as follows. Here, we have marked the **ProductRoute** parameter with the **FromRoute** Attribute, meaning this parameter’s properties will map with the Route Data parameter.

```c#
using Microsoft.AspNetCore.Mvc;
using ModelBinding.Models;

namespace ModelBinding.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductsController : ControllerBase
    {
        private static List<Product> Products = new List<Product>
        {
            new Product { Id = 1, Name = "Laptop", Categogy = "Electronics", Price = 1000, Quantity = 10 },
            new Product { Id = 2, Name = "Desktop", Categogy = "Electronics", Price = 2000, Quantity = 20 },
            new Product { Id = 3, Name = "Mobile", Categogy = "Electronics", Price = 3000, Quantity = 30 },
            new Product { Id = 4, Name = "Casual Shirts", Categogy = "Apparel", Price = 500, Quantity = 10 },
            new Product { Id = 5, Name = "Casual Pants", Categogy = "Apparel", Price = 600, Quantity = 30 },
            new Product { Id = 6, Name = "Jackets & Coats", Categogy = "Apparel", Price = 700, Quantity = 20 },
        };

        [HttpGet("{Name}/{Category}")]
        public IActionResult GetProductById([FromRoute] ProductRoute productRoute)
        {
            if(productRoute != null)
            {
                var FilteredProducts = Products.Where(prd => prd.Name.ToLower().StartsWith(productRoute.Name) &&
                prd.Categogy.ToLower() == productRoute?.Category.ToLower()).ToList();

                return Ok(FilteredProducts);
            }
            
            return NotFound($"No Product Found");
        }
    }
}
```
![[word-image-47212-2.webp]]


##### **FromRoute vs FromQuery in ASP.NET Core Web API**

In ASP.NET Core Web API, FromRoute and FromQuery are different attribute bindings that specify how data should be bound to action method parameters. Both serve the purpose of data extraction from the request, but they operate on different parts of the HTTP request. Understanding the distinction between the two is crucial for correctly designing API endpoints and ensuring that data is accurately received and processed by your application.

##### **FromRoute**

- **Usage:** The FromRoute attribute is used to bind parameter values directly from the route of the HTTP request. This is typically used for RESTful URLs where key pieces of data are embedded within the route itself.
- **Example:** Consider an API endpoint designed to fetch a specific user by ID. The route might be defined as /api/users/{id}, where {id} is a placeholder for the user ID. In this case, FromRoute would be used to bind the value of {id} to the action method parameter.
- **Benefits:** It allows for clean and readable URLs and is particularly useful for operations that relate to a specific resource or entity.
- **Limitations:** Since the data is part of the URL, it’s not well-suited for passing complex data or sensitive information.

##### **FromQuery**

- **Usage:** The FromQuery attribute binds parameter values from the query string of the HTTP request. This is useful for operations that require additional, optional, or complex filtering parameters that don’t naturally fit within the route path.
- **Example:** For a search endpoint that allows filtering of results based on various criteria, the URL might look like /api/products?category=electronics&price=100. Here, FromQuery would be used to bind the category and price values to the corresponding parameters in the action method.
- **Benefits:** It supports more flexible and dynamic data retrieval operations, allowing for complex queries with multiple optional parameters.
- **Limitations:** Query strings can become unwieldy with too many parameters, and there are limits to URL length that might restrict the amount of data that can be passed.

##### **Choosing Between FromRoute and FromQuery**

- **RESTful Design:** For endpoints that operate on a specific resource or entity, FromRoute is often the preferred choice, as it aligns with RESTful URL conventions.
- **Complex Filtering or Operations:** When the operation requires complex inputs or when you’re dealing with optional or numerous parameters, FromQuery is more suitable.
- **Security Considerations:** Sensitive information should generally not be passed in URLs, whether in routes or query strings, due to the risk of exposure in server logs or browser histories.



# Model Binding Using FromHeader in ASP.NET Core Web API


```c#
using Microsoft.AspNetCore.Mvc;
namespace ModelBinding.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        [HttpGet]
        public IActionResult GetResource([FromHeader] string Authorization)
        {
            // Implementation
            if(Authorization == null)
            {
                return BadRequest("Authorization Token is Missing");
            }

            return Ok("Request Processed Successfully");
        }
    }
}
```

![[word-image-47240-1.webp]]

you set the Authorization header attribute in the request header, then you will get the 200 OK Status code

![[word-image-47240-2.webp]]

##### **Giving Different Names to Method Parameters:**

```c#
using Microsoft.AspNetCore.Mvc;
namespace ModelBinding.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        [HttpGet]
        public IActionResult GetResource([FromHeader(Name = "Custom-Header")] string customHeader)
        {
            if(customHeader == null)
            {
                return BadRequest("Custom-Header is Missing");
            }

            return Ok("Request Processed Successfully");
        }
    }
}
```

![[word-image-47240-3.webp]]


#### **Binding FromHeader to Complex Type in ASP.NET Core Web API**

```c#
namespace ModelBinding.Models
{
    public class UserPreferences
    {
        public string Language { get; set; }
        public string Theme { get; set; }
    }
}
```

##### **Implement Custom Model Binding**

```c#
using Microsoft.AspNetCore.Mvc.ModelBinding;

namespace ModelBinding.Models
{
    public class HeaderModelBinder : IModelBinder
    {
        public Task BindModelAsync(ModelBindingContext bindingContext)
        {
            if (bindingContext == null)
            {
                throw new ArgumentNullException(nameof(bindingContext));
            }

            var headers = bindingContext.HttpContext.Request.Headers;
            // using  model hear
            var model = new UserPreferences
            {
                Language = headers["Language"],
                Theme = headers["Theme"]
            };

            bindingContext.Result = ModelBindingResult.Success(model);
            return Task.CompletedTask;
        }
    }
}
```

##### **Creating the Custom Model Binder Provider:**

```c#
using Microsoft.AspNetCore.Mvc.ModelBinding;

namespace ModelBinding.Models
{
    public class HeaderModelBinderProvider : IModelBinderProvider
    {
        public IModelBinder GetBinder(ModelBinderProviderContext context)
        {
            if (context == null)
            {
                throw new ArgumentNullException(nameof(context));
            }

            if (context.Metadata.ModelType == typeof(UserPreferences))
            {
                return new HeaderModelBinder();
            }

            return null;
        }
    }
}
```

##### **Register Custom HeaderModelBinderProvider:**
Then, add this provider to the **AddControllers** options in the **Program.cs** class file as follows. Please make sure to include the namespace in the **Program.cs** class file where you defined the HeaderModelBinderProvider class.

```c#
builder.Services.AddControllers(options =>

{

options.ModelBinderProviders.Insert(0, new HeaderModelBinderProvider());

});
```

##### **Use the Model in an Action Method**

```c#
using Microsoft.AspNetCore.Mvc;
using ModelBinding.Models;
namespace ModelBinding.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        [HttpGet]
        public IActionResult GetResource([ModelBinder] UserPreferences userPreferences)
        {
            // Use the userPreferences object as needed
            return Ok(new { Message = "User Preferences Received", Preferences = userPreferences });
        }
    }
}
```

![[word-image-47240-4.webp]]



# Model Binding Using FromBody in ASP.NET Core Web API

**Creating Model:**
```C#
namespace ModelBinding.Models
{
    public class Product
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int Quantity { get; set; }
        public int Price { get; set; }
    }
}
```

**Creating Controller:**

```C#
using Microsoft.AspNetCore.Mvc;
using ModelBinding.Models;

namespace ModelBinding.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductsController : ControllerBase
    {
        [HttpPost]
        public IActionResult CreateProduct([FromBody] Product product)
        {
            // Add the product to the database or in-memory store
            // For demonstration, let's return the product back
            return Ok(product);
        }
    }
}
```

**Method: POST**

**URL: api/products**

**Request Body:**
```JSON
{
  "id": 100,
  "name": "Laptop",
  "quantity": 10,
  "price": 2500
}
```

![[word-image-47249-1.webp]]

##### **Handling Collection or Arrays using FromBody in ASP.NET Core Web API**

```C#
using Microsoft.AspNetCore.Mvc;
using ModelBinding.Models;

namespace ModelBinding.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductsController : ControllerBase
    {
        [HttpPost]
        public IActionResult CreateProduct([FromBody] List<Product> products)
        {
            // Handle multiple products
            // For demonstration, let's return the products back
            return Ok(products);
        }
    }
}
```

**Method: POST**

**URL: api/products**

**Request Body:**

```JSON
[
    {
        "id": 100,
        "name": "Laptop",
        "quantity": 10,
        "price": 2500
    },
    {
        "id": 101,
        "name": "Desktop",
        "quantity": 15,
        "price": 2900
    }
]
```

##### **Customizing Model Binding with Attributes**

```C#
namespace ModelBinding.Models
{
    public class Order
    {
        public int Id { get; set; }
        public List<Product> Products { get; set; }
    }

    public class Product
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int Quantity { get; set; }
        public int Price { get; set; }
    }
}
```

**Next, modify the Products Controller as follows:**

```C#
using Microsoft.AspNetCore.Mvc;
using ModelBinding.Models;

namespace ModelBinding.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductsController : ControllerBase
    {
        [HttpPost("Order")]
        public IActionResult CreateOrder([FromBody] Order order)
        {
            // Process the order
            return Ok(order);
        }
    }
}
```

**Method: POST**

**URL: api/Products/Order**

**Request Body:**

```JSON
{
    "id": 12345,
    "products": [
        {
            "id": 1,
            "name": "Laptop",
            "quantity": 1,
            "price": 2500
        },
        {
            "id": 2,
            "name": "Desktop",
            "quantity": 2,
            "price": 5000
        }
    ]
}
```

##### **Customizing Serialization and Deserialization in ASP.NET Core Web API**
Program.cs
```c#
builder.Services.AddControllers()
.AddJsonOptions(options =>
{
    options.JsonSerializerOptions.PropertyNamingPolicy = null;
});
```

**Response Body:**
![[word-image-47249-2.webp]]



# Custom Model Binding in ASP.NET Core Web API


##### **Implementing Custom Model Binding in ASP.NET Core Web API**

To implement Custom Model Binding in ASP.NET Core Web API, we typically need to create a class that implements either the IModelBinder interface for simple scenarios or the IModelBinderProvider interface for more complex scenarios where you might need to select a binder based on the type of the model or other criteria.

- **IModelBinder:** Requires implementing the BindModelAsync method, which contains the logic to bind data from the request to the model object.
- **IModelBinderProvider:** Used to provide a model binder based on the context, allowing more control over which binder is used for which model.
##### **Define Your Complex Object**

```c#
namespace ModelBinding.Models
{
    public class FilterModel
    {
        public string Name { get; set; }
        public int Age { get; set; }
        public List<string> Interests { get; set; } = new List<string>();
    }
}
```

##### **Implement a Custom Model Binder in ASP.NET Core Web API**

```c#
using Microsoft.AspNetCore.Mvc.ModelBinding;

namespace ModelBinding.Models
{
    public class FilterModelBinder : IModelBinder
    {
        public Task BindModelAsync(ModelBindingContext bindingContext)
        {
            if (bindingContext == null)
            {
                throw new ArgumentNullException(nameof(bindingContext));
            }

            // Retrieve the query string
            var queryString = bindingContext.HttpContext.Request.Query;

            // Instantiate the target object
            var model = new FilterModel();

            // Bind properties
            if (queryString.TryGetValue("Name", out var name))
            {
                model.Name = name;
            }

            if (queryString.TryGetValue("Age", out var age) && int.TryParse(age, out var ageValue))
            {
                model.Age = ageValue;
            }

            if (queryString.TryGetValue("Interests", out var interests))
            {
                model.Interests = interests.ToString().Split(",").ToList();
            }

            // Set the result
            bindingContext.Result = ModelBindingResult.Success(model);

            return Task.CompletedTask;
        }
    }
}
```



#### **Create a Model Binder Provider**
```c#
using Microsoft.AspNetCore.Mvc.ModelBinding;

namespace ModelBinding.Models
{
    public class FilterModelBinderProvider : IModelBinderProvider
    {
        public IModelBinder GetBinder(ModelBinderProviderContext context)
        {
            if (context == null)
            {
                throw new ArgumentNullException(nameof(context));
            }

            if (context.Metadata.ModelType == typeof(FilterModel))
            {
                return new FilterModelBinder();
            }

            return null;
        }
    }
}
```

**Determining Whether to Use the Custom Model Binder**

```c#
if (context.Metadata.ModelType == typeof(FilterModel))

{

return new FilterModelBinder();

}
```

#### **Register the Custom Model Binder Provider**
program.cs
```c#
builder.Services.AddControllers(options =>
{
    // Add our custom model binder at the beginning of the collection
    options.ModelBinderProviders.Insert(0, new FilterModelBinderProvider());
});
```

##### **Use the Complex Type in Your Controller**

```c#
using Microsoft.AspNetCore.Mvc;
using ModelBinding.Models;
namespace ModelBinding.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        [HttpGet]
        public IActionResult GetResource([ModelBinder] FilterModel filter)
        {
            // Use the bound complex object
            return Ok(filter);
        }
    }
}
```

![[word-image-47255-1.webp]]

#### **Binding Data from Multiple Sources using Custom Model Binder:**

##### **Define the Model**
**MyCompositeDataModel.cs**
```c#
namespace ModelBinding.Models
{
    public class MyCompositeDataModel
    {
        public int Id { get; set; }
        public string Name { get; set; }
    }
}
```

##### **Define a Custom Model Binder**

**CompositeObjectModelBinder.cs**

```C#
using Microsoft.AspNetCore.Mvc.ModelBinding;
namespace ModelBinding.Models
{
    public class CompositeObjectModelBinder : IModelBinder
    {
        public Task BindModelAsync(ModelBindingContext bindingContext)
        {
            //Make sure the bindingContext is not null
            if (bindingContext == null)
            {
                throw new ArgumentNullException(nameof(bindingContext));
            }

            //Here, routeData and queryData represent the data collected from the route and query string, respectively.
            //These collections are used to retrieve the specific pieces of data needed to populate the model.
            var routeData = bindingContext.HttpContext.GetRouteData().Values;
            var queryData = bindingContext.HttpContext.Request.Query;

            //If required, then you can also access the header
            var headerData = bindingContext.HttpContext.Request.Headers;

            //Creating and Populating the Model
            var compositeObject = new MyCompositeDataModel
            {
                // These keys must be exist in route data and query string
                Id = Convert.ToInt32(routeData["Id"]),
                Name = queryData["Name"]
            };

            // Setting the Model Binding Result
            bindingContext.Result = ModelBindingResult.Success(compositeObject);
            return Task.CompletedTask;
        }
    }
}
```
##### **Apply the Model Binder:**
```c#
using Microsoft.AspNetCore.Mvc;
using ModelBinding.Models;
namespace ModelBinding.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        [HttpGet("{Id}")]
        public IActionResult GetResource([ModelBinder(BinderType = typeof(CompositeObjectModelBinder))] MyCompositeDataModel compositeObject)
        {
            // Use the compositeObject
            return Ok(compositeObject);
        }
    }
}
```

![[word-image-47255-2.webp]]

# How to Apply Binding Attributes to Model Properties in ASP.NET Core Web API


#### **Using Simple Parameter in Controller Action Method**
create a Controller   BookController.cs

```c#
using Microsoft.AspNetCore.Mvc;
namespace ModelBinding.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class BookController : ControllerBase
    {
        [HttpPost("{Id}")]
        public IActionResult CreateBook([FromRoute]int Id, [FromQuery]string Author, [FromHeader]string Title)
        {
            // Your logic to Store the Data into the database

            //Here, we are simply creating an Anonymous Object and returning the Book details
            var response = new
            {
                BookId = Id,
                BookTitle = Title,
                AuthorName = Author
            };
            return Ok(response);
        }
    }
}
```

##### **Test the API:**

![[word-image-47271-1.webp]]

#### **Using Custom Model Binder:** 

```c#
namespace ModelBinding.Models
{
    public class Book
    {
        // This would be bound from the route
        public int Id { get; set; }

        // This would be bound from the header
        public string Title { get; set; }

        // This would be bound from the query string
        public string Author { get; set; }
    }
}
```

##### **Creating Custom Model Binder:**
**CustomBookModelBinder.cs**
```c#
using Microsoft.AspNetCore.Mvc.ModelBinding;

namespace ModelBinding.Models
{
    public class CustomBookModelBinder : IModelBinder
    {
        public Task BindModelAsync(ModelBindingContext bindingContext)
        {
            var httpContext = bindingContext.HttpContext;

            // Retrieve from Route
            var routeIdValue = bindingContext.ValueProvider.GetValue("Id").FirstValue;
            if (string.IsNullOrEmpty(routeIdValue))
            {
                bindingContext.Result = ModelBindingResult.Failed();
                return Task.CompletedTask;
            }

            // Retrieve from Query String
            var queryAuthorValue = httpContext.Request.Query["Author"].ToString();
            if (string.IsNullOrEmpty(queryAuthorValue))
            {
                bindingContext.Result = ModelBindingResult.Failed();
                return Task.CompletedTask;
            }

            // Retrieve from Header
            var headerTitleValue = httpContext.Request.Headers["Title"].ToString();
            if (string.IsNullOrEmpty(headerTitleValue))
            {
                bindingContext.Result = ModelBindingResult.Failed();
                return Task.CompletedTask;
            }

            //Creating and Populating the Model
            var book = new Book
            {
                // These keys must be exist in route data, query string and header
                Id = int.Parse(routeIdValue),
                Author = queryAuthorValue,
                Title = headerTitleValue
            };

            // Setting the Model Binding Result
            bindingContext.Result = ModelBindingResult.Success(book);
            return Task.CompletedTask;
        }
    }
}
```

**Apply the Model Binder:**

```c#
using Microsoft.AspNetCore.Mvc;
using ModelBinding.Models;
namespace ModelBinding.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class BookController : ControllerBase
    {
        [HttpPost("{Id}")]
        public IActionResult CreateBook([ModelBinder(BinderType = typeof(CustomBookModelBinder))] Book book)
        {
            // Your logic to Store the Data into the database

            return Ok(book);
        }
    }
}
```

![[word-image-47271-2.webp]]

##### **Applying Bind Attribute to Model Properties:**

```C#
using Microsoft.AspNetCore.Mvc;

namespace ModelBinding.Models
{
    public class Book
    {
        [FromRoute(Name = "Id")]
        public int Id { get; set; }

        [FromHeader(Name = "Title")]
        public string Title { get; set; }

        [FromQuery(Name = "Author")]
        public string Author { get; set; }
    }
}
```



```C#
using Microsoft.AspNetCore.Mvc;
using ModelBinding.Models;
namespace ModelBinding.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class BookController : ControllerBase
    {
        [HttpPost("{Id}")]
        public IActionResult CreateBook(Book book)
        {
            // Your logic to Store the Data into the database

            return Ok(book);
        }
    }
}
```
![[word-image-47271-3.webp]]


