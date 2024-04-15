
## **Routing in ASP.NET Core Web API Application**
Let us understand Routing in ASP.NET Core Web API Application with an example. Please have a look at the following image. On the right-hand side, we have the server, and within the server, we have deployed our ASP.NET Core Web API application. Inside the ASP.NET Core Web API Application, assume we have three controllers, each containing some action methods. On the left-hand side, we have the clients. The client can be a Web Browser, Postman, Fiddler, Swagger, IoTs, Mobile APP, Desktop Application, etc.

![[Pasted image 20240330150936.png]]

##### **How Does the Routing Work in ASP.NET Core Web API?**


Here, we need to understand how the application will come to know which request will be mapped to which controller action method. Basically, the mapping between the URL and resource (controller action method) is nothing but the concept of Routing.

So, Routing in ASP.NET Core Web API is a concept that maps incoming HTTP requests to specific controllers and actions in your application. It determines how the Web API handles an HTTP request.


- **Configuration of Routing:** In ASP.NET Core, routing is configured in the Program.cs file. We need to register the required Web API services to the dependency injection container, and then we need to configure the Routing Middleware to the Request Processing Pipeline.
- **Route Templates:** Each controller action method can be decorated with route attributes defining the templates. These templates specify the URL patterns that the action will handle. The most commonly used attributes are [Route], [HttpGet], [HttpPost], [HttpPut], and [HttpDelete]. The templates can include various segments and parameters (like IDs) that are used to pass data to the controller methods.
- **Route Matching:** When a request is made to the Web API, the routing middleware parses the URL and tries to match it against the defined route templates. The matching process considers the HTTP method (GET, POST, etc.), the URL path, and any constraints defined in the route template.
- **Parameter Binding:** Once a route is matched, any parameters in the route are bound to the action method’s parameters. ASP.NET Core automatically handles the conversion of URL segments to the appropriate method parameter types.
- **Middleware Pipeline:** If a match is found, the request is forwarded through the middleware pipeline until it reaches the appropriate controller action. If no match is found, the framework can return a 404 Not Found response or forward the request to another middleware for further processing.
- **Attribute Routing vs. Conventional Routing:** ASP.NET Core supports two types of routing: Attribute Routing (where routes are defined above actions or controllers using Route Attributes) and Conventional Routing (where routes are defined in a central location, typically in Program.cs class file). Attribute Routing provides more control and is commonly used in ASP.NET Core Web API projects.
- **Routing Constraints:** Constraints can be applied to route parameters to restrict the type of data that matches a particular parameter. For example, you can specify that a certain URL segment must be an integer.
## **Configuring ASP.NET Core Web API Service:**

Let us add the ASP.NET Core Web API services to the dependency injection container so that our application will support the ASP.NET Core Web API Features. We need to configure the required Web API services within the Program class. So, add the following code within the Program.cs class file:

**builder.Services.AddControllers();**

##### **Configuring the Routing Middlewares in ASP.NET Core:**

To enable Routing in ASP.NET Core, we must add the following two middleware components to the HTTP Request Processing Pipeline.

**app.UseRouting();**  
**app.MapControllers();**


In .NET 8, app.UseRouting() and app.MapControllers() are used within the context of an ASP.NET Core application to configure routing and controller endpoints.

- **app.UseRouting():** This middleware enables routing capabilities in your ASP.NET Core application. It is responsible for matching incoming HTTP requests to routes that have been defined in your application. UseRouting should be added to the middleware pipeline before any middleware that requires knowledge of the requested endpoint, like authorization or endpoint-specific middleware.
- **app.MapControllers():** This extension method is used to map attribute-routed controllers. It essentially tells the application to look for controllers in your project and creates routes for them based on the attributes you’ve defined (like [Route], [HttpGet], etc.). This is typically used when you have an API-centric application with controllers handling various HTTP requests.

##### **Adding Controller:**

Let’s add the Home Controller within the Controllers folder. To do so, right-click on the Controllers folder and then select **Add => Controller** from the context menu, which will open the following Add New Scaffolded item window. From the left side, select **API**, and from the middle pane, select **API Controller – Empty** and click on the **Add** button, as shown in the image below.

![[word-image-43851-7-3.webp]]
![[word-image-43851-8-3.webp]]
![[word-image-43851-9-3.webp]]


##### **Adding Attribute Routing in ASP.NET Core Web Application:**

Now, let us add two action methods within the EmployeeController class. Now, please don’t concentrate on the return type and the data that we are returning from the action method; rather, concentrate on the Routing concept.

We want to invoke the GetAllEmployees method with the URL **/Emp/All** and the GetEmployeeById method with the URL **/Emp/ById/102**. To achieve this, we need to use the Route Attribute and decorate the action GetAllEmployees and GetEmployeeById method as **[Route(“Emp/All”)]** and **[Route(“Emp/ById/{Id}”)]** respectively.


```C#
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace RoutingInASPNETCoreWebAPI.Controllers
{
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        [Route("Emp/All")]
        [HttpGet]
        public string GetAllEmployees()
        {
            return "Response from GetAllEmployees Method";
        }

        [Route("Emp/ById/{Id}")]
        [HttpGet]
        public string GetEmployeeById(int Id)
        {
            return $"Response from GetEmployeeById Method Id: {Id}";
        }
    }
}

```

![[word-image-43851-10-2.webp]]

##### **RouteAttribute in ASP.NET Core:**

The RouteAttribute class is used to define the routing configuration for controller actions. The RouteAttribute specifies URLs that can be used to access a controller action. It allows you to define custom and more readable URLs that are not strictly tied to the names of the controllers and actions.

You can apply the RouteAttribute to a controller or an action method. When applied to a controller, it defines a common route prefix for all action methods in that controller. When applied to an action method, it specifies the route for that specific action. Let us have a look at the signature of the Route Attribute. The following image shows the definition of the Route Attribute.

![[word-image-43851-11-1.webp]]
- **Name:** This property retrieves the route’s name, which can be used for generating links using a specific route.
- **Order:** It defines the order of route execution, with lower values indicating higher priority. The default value, if not specified, is 0.
- **Template:** This property holds the route template and can be null.
##### **Conventional Routing in ASP.NET Core Web API:**

```C#
app.MapControllerRoute(
    name: "default",
    pattern: "api/{controller}/{action}/{id?}");

```

##### **Modifying the Employee Controller:**
Next, modify the Employee Controller as follows. Here, we are removing the Route Attribute from the Controller action methods. You must also remove the ApiController attribute, which is decorated with the Controller class. This is because the ApiController attribute will force the action method to use the Route attribute.
```C#
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace RoutingInASPNETCoreWebAPI.Controllers
{
   // [ApiController]
    public class EmployeeController : ControllerBase
    {
        // [Route("Emp/All")]
        [HttpGet]
        public string GetAllEmployees()
        {
            return "Response from GetAllEmployees Method";
        }

        //  [Route("Emp/ById/{Id}")]
        [HttpGet]
        public string GetEmployeeById(int Id)
        {
            return $"Response from GetEmployeeById Method Id: {Id}";
        }
    }
}

```


With the above changes in place, you can access the APIs using **/api/Employee/GetAllEmployees** and **/api/Employee/GetEmployeeById/103** URL, as shown below.


![[word-image-43851-12-1.webp]]

##### **Can we use both Convention-based and Attribute-based Routing in ASP.NET Core Web API?**

Yes, we can use both conventional and attribute-based Routing in ASP.NET Core Web API Applications. The action method that is decorated with a Route Attribute will use Attribute Routing, and the action method without the Route Attribute will use Conventional Routing. For a better understanding, please modify the Employee Controller as follows:

```C#
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace RoutingInASPNETCoreWebAPI.Controllers
{
   // [ApiController]
    public class EmployeeController : ControllerBase
    {
        [Route("Emp/All")]
        [HttpGet]
        public string GetAllEmployees()
        {
            return "Response from GetAllEmployees Method";
        }

        //  [Route("Emp/ById/{Id}")]
        [HttpGet]
        public string GetEmployeeById(int Id)
        {
            return $"Response from GetEmployeeById Method Id: {Id}";
        }
    }
}

```

As you can see in the above code, now we can access the GetAllEmployees method using the Attribute Routing, i.e., **/Emp/All** URL, and we can access the GetEmployeeById action method using the Conventional Routing, i.e., **/api/employee/GetEmployeeById/102** URL as shown in the below image:

![[word-image-43851-13-1.webp]]

# Route Parameters and Query Strings in Routing



![[Pasted image 20240330152818.png]]
![[word-image-327.webp]]

```C#
using Microsoft.AspNetCore.Mvc;
namespace RoutingInASPNETCoreWebAPI.Controllers
{
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        [Route("Employee/{Id}")]
        public string GetEmployeeById(int Id)
        {
            return $"Return Employee Details : {Id}";
        }
    }
}

```


##### **Passing Multiple Dynamic Values in ASP.NET Core Web API Routing:**


![[word-image-329.webp]]

![[word-image-330.webp]]

```C#
using Microsoft.AspNetCore.Mvc;
namespace RoutingInASPNETCoreWebAPI.Controllers
{
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        [Route("Employee/{Id}")]
        public string GetEmployeeById(int Id)
        {
            return $"Return Employee Details : {Id}";
        }

        [Route("Employee/Gender/{Gender}/City/{CityId}")]
        public string GetEmployeesByGenderAndCity(string Gender, int CityId)
        {
            return $"Return Employees with Gender : {Gender}, City: {CityId}";
        }
    }
}

```
![[word-image-331.webp]]

##### **Working with Query Strings in ASP.NET Core Web API Routing:**
 Query Strings are nothing but key-value pairs that you need to pass as part of the URL. Again, you can also pass multiple query strings (i.e., multiple key-value pairs) separated by &. Further, the most important point that you need to remember is that before the first query string or after the domain name, you need to use a question mark (?). The question mark (?) in the URL indicates that the query string is started.
 

![[word-image-332.webp]]

```C#
using Microsoft.AspNetCore.Mvc;
namespace RoutingInASPNETCoreWebAPI.Controllers
{
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        [Route("Employee/Search")]
        public string SearchEmployees(string Department)
        {
            return $"Return Employees with Department : {Department}";
        }
    }
}

```

![[word-image-333.webp]]

##### **How do you pass Multiple Query Strings in ASP.NET Core Web API?**

```C#
using Microsoft.AspNetCore.Mvc;
namespace RoutingInASPNETCoreWebAPI.Controllers
{
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        [Route("Employee/Search")]
        public string SearchEmployees(string? Department, string? Gender, string? City = null)
        {
            return $"Return Employees with Department : {Department}, Gender : {Gender}, City : {City}";
        }
    }
}

```

**/Employee/Search?City=London&Gender=Male&Department=HR**



![[word-image-335.webp]]


##### **Using Query Strings with Model Binding in ASP.NET Core Web API**

You can also use a model to bind query string parameters. So, let us create a model called EmployeeSearch.cs and then copy and paste the following code.

```C#
namespace RoutingInASPNETCoreWebAPI
{
    public class EmployeeSearch
    {
        public string? Department { get; set; }
        public string? Gender { get; set; }
        public string? City { get; set; }
    }
}

```

##### **Modify the EmployeeController:**

By default, the simple type parameters are mapped with query string and complex type parameters are mapped with the request body. But in our example, we need to map the complex type parameter with the Query string value. So, explicitly, we need to tell ASP.NET Core Framework to map the complex type parameter with the query string parameter by using the FromQuery attribute, shown in the example below. So, modify the Employee Controller as follows:

```C#
using Microsoft.AspNetCore.Mvc;
namespace RoutingInASPNETCoreWebAPI.Controllers
{
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        [Route("Employee/Search")]
        public string SearchEmployees([FromQuery]EmployeeSearch employeeSearch)
        {
            return $"Return Employees with Department : {employeeSearch.Department}, Gender : {employeeSearch.Gender}, City : {employeeSearch.City}";
        }
    }
}

```

![[word-image-335 1.webp]]


##### **Accessing Query Strings Directly from HttpContext**

```C#
Cusing Microsoft.AspNetCore.Mvc;
namespace RoutingInASPNETCoreWebAPI.Controllers
{
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        [Route("Employee/Search")]
        public string SearchEmployees()
        {
            var Department = HttpContext.Request.Query["department"].ToString();
            var Gender = HttpContext.Request.Query["gender"].ToString();
            return $"Return Employees with Department : {Department}, Gender : {Gender}";
        }
    }
}

```
![[word-image-335 2.webp]]

##### **Routing with both Route Parameter and Query String in ASP.NET Core Web API**

In ASP.NET Core Web API, combining route parameters and query strings in routing is a common practice. This approach allows for more flexible and expressive URLs to capture essential path information (through route parameters) and provide additional, optional data (through query strings).

```C#
using Microsoft.AspNetCore.Mvc;
namespace RoutingInASPNETCoreWebAPI.Controllers
{
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        // Using both route parameter and query string
        [Route("Employee/{Gender?}")]
        public string GetEmployeesByGenderAndCity(string? Gender, int? CityId, string? Department)
        {
            return $"Return Employees with Gender: {Gender}, City: {CityId}, Department: {Department}";
        }
    }
}

```

![[Routing-with-both-Route-Parameter-and-Query-String-in-ASP.NET-Core-Web-API.webp]]

##### **Route Parameters**

- **Definition:** Route parameters are part of the URL path. They are used to identify a specific resource or a set of resources.
- **Syntax:** Specified within the route template by curly braces, e.g., /api/products/{id}.
- **Usage:** Ideal for essential information required to fulfill the request, such as an entity’s unique identifier.
- **Behavior:** They are a part of the URL’s path. Mandatory by default. If a route parameter is missing, the route won’t match, and the corresponding controller action won’t be called.
- **Binding:** Automatically bind to action method parameters with the same name.
- **Example:** Accessing a specific product by ID – /api/products/42.

##### **Query Strings**

- **Definition:** Query strings are appended to the URL and are used to provide additional, often optional, data for the request.
- **Syntax:** Begins with a ? followed by key=value pairs, e.g., /api/products?category=electronics.
- **Usage:** Suitable for optional data like filtering, sorting, or specifying certain behaviors. Not ideal for identifying resources.
- **Behavior:** Not part of the URL path. Optional by default. The API can still process requests without query string parameters.
- **Binding:** Bind to action method parameters, typically using the [FromQuery] attribute, although explicit attributes are not always necessary.
- **Example:** Filtering products by category – /api/products?category=electronics.

##### **Key Differences**

- **Position in URL:** Route parameters are part of the URL path, while query strings are appended to the URL.
- **Optionality:** Route parameters are generally mandatory, while query strings are optional.
- **Use Cases:** Route parameters identify specific resources (e.g., a particular product). Query strings are used for additional request information (e.g., filters, search terms).
# Multiple URLs for a Single Resource in ASP.NET Core Web API

In ASP.NET Core Web API, you can set up multiple URLs for a single resource using Attribute Routing. Attribute routing allows you to define routes directly on your controllers and actions, providing more flexibility in defining the API’s URL structure. Let us understand how to access a single resource with Multiple URLs with an example. Suppose we have the following resource available in our Employee Controller.

![[Pasted image 20240330154004.png]]

![[word-image-338.webp]]

```C#
using Microsoft.AspNetCore.Mvc;
namespace RoutingInASPNETCoreWebAPI.Controllers
{
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        [Route("Employee/All")]
        [Route("AllEmployees")]
        [Route("Employee/GetAll")]
        [HttpGet]
        public string GetAllEmployees()
        {
            return "Response from GetAllEmployees Method";
        }
    }
}

```

![[word-image-339.webp]]

##### **What happens if we use the same URL for multiple resources?**

This is not accepted in ASP.NET Core Web API. Let us prove this with an example. Let’s say we have the following two resources.

![[word-image-340.webp]]

![[word-image-341.webp]]

```C#
using Microsoft.AspNetCore.Mvc;
namespace RoutingInASPNETCoreWebAPI.Controllers
{
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        [Route("Employee/All")]
        [HttpGet]
        public string GetAllEmployees()
        {
            return "Response from GetAllEmployees Method";
        }

        [Route("Employee/All")]
        [HttpGet]
        public string GetEmployees()
        {
            return "Response from GetEmployees Method";
        }
    }
}

```

![[word-image-342.webp]]

```C#
using Microsoft.AspNetCore.Mvc;
namespace RoutingInASPNETCoreWebAPI.Controllers
{
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        [Route("Employee/GetAll")]
        [Route("EmployeeAll")]
        [HttpGet]
        public string GetAllEmployees()
        {
            return "Response from GetAllEmployees Method";
        }

        [Route("Employee/All")]
        [HttpGet]
        public string GetEmployees()
        {
            return "Response from GetEmployees Method";
        }
    }
}

```

With the above changes in place, you can now access the **GetAllEmployees** resource using two URLs, i.e., **Employee/GetAll** and **EmployeeAll**. On the other hand, you can access the **GetEmployees** resource using the URL **Employee/All,** as shown in the below image.

![[word-image-343.webp]]

##### **When should you set multiple URLs for a single resource in ASP.NET Core Web API?**

In ASP.NET Core Web API, setting multiple URLs for a single resource can be useful in various scenarios, providing flexibility and backward compatibility. Here are some situations where you might consider using multiple URLs for a single resource:

###### **Versioning:**

When you version your API, you might want to support multiple versions simultaneously. Different URLs for different versions allow clients to choose the version they want to interact with. For example:

- **/api/v1/resource**
- **/api/v2/resource**

###### **Endpoint Naming Changes:**

Suppose you need to change the naming conventions of your endpoints over time for better clarity or consistency. In that case, you can introduce new URLs while keeping the old ones for backward compatibility.

- **/api/old-resource-name**
- **/api/new-resource-name**

###### **Route Template Changes:**

If you need to modify the route templates, you might want to keep the old URLs for existing clients while introducing new URLs with updated route templates.

- **[Route(“api/resource”)]**
- **[Route(“api/legacy-resource”)]**

###### **Aliases or Abbreviations:**

You might want to provide alternative URLs with aliases or abbreviations for your resources to make them more user-friendly or for compatibility with other systems.

- **/api/resource**
- **/api/res**

# Token Replacement in ASP.NET Core Web API Routing

##### **What are Tokens in ASP.NET Core Attribute Routing?**

In ASP.NET Core, attribute routing is a feature that allows you to define routes directly on your controllers and actions using attributes. Tokens in attribute routing are placeholders that allow you to capture values from the request URI and use them as parameters in your route templates.

Tokens are enclosed in curly braces {} and can be placed within the route template to capture specific parts of the URI. These captured values can then be used as parameters in your action methods. Here are some common tokens used in attribute routing:

- **{controller}:** Represents the controller name.
- **{action}:** Represents the action method name.
- **{id}:** Represents a parameter named “id” in the route.


##### **Example Without Using Token Replacement in ASP.NET Core Web API**

Before understanding the need and use of token replacement, let us first understand an example without using token replacement. Suppose we have two resources in our Employee Controller, and we want to access the two resources using the controller/action method name. Then, we can do the same without token replacement, as shown in the code below.

```C#
using Microsoft.AspNetCore.Mvc;
namespace RoutingInASPNETCoreWebAPI.Controllers
{
    [ApiController]   
    public class EmployeeController : ControllerBase
    {
        [Route("Employee/GetAllEmployees")]
        [HttpGet]
        public string GetAllEmployees()
        {
            return "Response from GetAllEmployees Method";
        }

        [Route("Employee/GetAllDepartment")]
        [HttpGet]
        public string GetAllDepartment()
        {
            return "Response from GetAllDepartment Method";
        }
    }
}

```

![[word-image-367.webp]]

```C#
using Microsoft.AspNetCore.Mvc;
namespace RoutingInASPNETCoreWebAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class EmployeeController : ControllerBase
    {
        [Route("[action]")]
        [HttpGet]
        public string GetAllEmployees()
        {
            return "Response from GetAllEmployees Method";
        }

        [Route("[action]")]
        [HttpGet]
        public string GetAllDepartment()
        {
            return "Response from GetAllDepartment Method";
        }
    }
}

```

![[word-image-368.webp]]


```C#
using Microsoft.AspNetCore.Mvc;
namespace RoutingInASPNETCoreWebAPI.Controllers
{
    [ApiController]
    [Route("[controller]/[action]")]
    public class EmployeeController : ControllerBase
    {
        [HttpGet]
        public string GetAllEmployees()
        {
            return "Response from GetAllEmployees Method";
        }

        [HttpGet]
        public string GetAllDepartment()
        {
            return "Response from GetAllDepartment Method";
        }
    }
}

```
![[word-image-369.webp]]

##### **Token Replacement with Dynamic Values:**

```C#
[Route("{Id}")]

[HttpGet]

public string GetEmployeeById(int Id)

{

return $"Response from GetEmployeeById Method, Id : {Id}";

}
```


```C#
using Microsoft.AspNetCore.Mvc;
namespace RoutingInASPNETCoreWebAPI.Controllers
{
    [ApiController]
    [Route("[controller]/[action]")]
    public class EmployeeController : ControllerBase
    {
        [HttpGet]
        public string GetAllEmployees()
        {
            return "Response from GetAllEmployees Method";
        }

        [HttpGet]
        public string GetAllDepartment()
        {
            return "Response from GetAllDepartment Method";
        }

        [Route("{Id}")]
        [HttpGet]
        public string GetEmployeeById(int Id)
        {
            return $"Response from GetEmployeeById Method, Id : {Id}";
        }
    }
}

```

![[word-image-370.webp]]

#####  **controller and action token applied to the action method**

```C#
using Microsoft.AspNetCore.Mvc;
namespace RoutingInASPNETCoreWebAPI.Controllers
{
    [ApiController]   
    public class EmployeeController : ControllerBase
    {
        [Route("[controller]/[action]")]
        [HttpGet]
        public string GetAllEmployees()
        {
            return "Response from GetAllEmployees Method";
        }

        [Route("[controller]/[action]")]
        [HttpGet]
        public string GetAllDepartment()
        {
            return "Response from GetAllDepartment Method";
        }

        [Route("[controller]/[action]/{Id}")]
        [HttpGet]
        public string GetEmployeeById(int Id)
        {
            return $"Response from GetEmployeeById Method, Id : {Id}";
        }
    }
}

```

##### **Example to Understand how tokens are used with HTTP methods in Attribute Routing:**

```c#
using Microsoft.AspNetCore.Mvc;
namespace RoutingInASPNETCoreWebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class EmployeeController : ControllerBase
    {
        //GET: /api/Employee
        [HttpGet]
        public string GetAllEmployees()
        {
            return "Response from GetAllEmployees Method";
        }

        //GET: /api/Employee/100
        [HttpGet("{id}")]
        public string GetEmployeeById(int id)
        {
            return $"Response from GetEmployeeById Method, Id : {id}";
        }

        //GET: /api/Employee/department/IT
        [HttpGet("department/{department}")]
        public string GetEmployeeByDepartment(string department)
        {
            return $"Response from GetEmployeeByDepartment Method, Department :{department}";
        }
    }
} 

```

- The [HttpGet] attribute on the **GetAllEmployees** action method specifies a route template of “api/[controller]”, where [controller] is a token that will be replaced with the controller name (Products in this case).
- The [HttpGet(“{id}”)] attribute on the **GetEmployeeById** action method specifies a route template with the **{id}** token, indicating that the action expects an id parameter from the route.
- The **[HttpGet(****“department/{department}”****)]** attribute on the **GetEmployeeByDepartment** action method uses the {**department**} token to capture a category parameter from the route.

# Route Prefix in ASP.NET Core Web API Routing

In ASP.NET Core Web API, the route prefix is one of the important routing concepts that helps organize and access the API endpoints efficiently. It acts as a common path segment prefixed to the URL of all actions within a controller, making it easier to group similar functionalities and manage the API’s structure. This feature is useful in attribute routing, where routes are defined directly on controllers and actions using attributes.

```C#
using Microsoft.AspNetCore.Mvc;
namespace RoutingInASPNETCoreWebAPI.Controllers
{
    [ApiController]   
    public class EmployeeController : ControllerBase
    {
        [Route("employee/all")]
        [HttpGet]
        public string GetAllEmployees()
        {
            return "Response from GetAllEmployees Method";
        }

        [Route("employee/{Id}")]
        [HttpGet]
        public string GetEmployeeById(int Id)
        {
            return $"Response from GetEmployeeById Method, Id : {Id}";
        }

        [Route("employee/department/{Department}")]
        [HttpGet]
        public string GetDepartmentEmployees(string Department)
        {
            return $"Response from GetDepartmentEmployees Method, Department : {Department}";
        }
    }
}

```

![[word-image-371.webp]]

```C#
using Microsoft.AspNetCore.Mvc;
namespace RoutingInASPNETCoreWebAPI.Controllers
{
    [ApiController]
    [Route("employee")]
    public class EmployeeController : ControllerBase
    {
        [Route("all")]
        [HttpGet]
        public string GetAllEmployees()
        {
            return "Response from GetAllEmployees Method";
        }

        [Route("{Id}")]
        [HttpGet]
        public string GetEmployeeById(int Id)
        {
            return $"Response from GetEmployeeById Method, Id : {Id}";
        }

        [Route("department/{Department}")]
        [HttpGet]
        public string GetDepartmentEmployees(string Department)
        {
            return $"Response from GetDepartmentEmployees Method, Department : {Department}";
        }
    }
}

```

![[word-image-372.webp]]

```c#
[Route("department/all")]
[HttpGet]
public string GetAllDepartment()
{
    return "Response from GetAllDepartment Method";
}

```

![[word-image-373.webp]]

![[word-image-374.webp]]

##### **How do you override the Controller Level Route Attribute at the action method level?**

In the ASP.NET Core Application, you can override the Controller level Route Attribute at the action method level by using the **~ (tilde)** symbol. So, modify the GetAllDepartment action method as shown below to use the tilde symbol to override the route defined at the employee controller.

```C#
[Route("~/department/all")]
[HttpGet]
public string GetAllDepartment()
{
    return "Response from GetAllDepartment Method";
}

```

```C#
using Microsoft.AspNetCore.Mvc;
namespace RoutingInASPNETCoreWebAPI.Controllers
{
    [ApiController]
    [Route("employee")]
    public class EmployeeController : ControllerBase
    {
        //[Route("all")]
        [HttpGet("all")]
        public string GetAllEmployees()
        {
            return "Response from GetAllEmployees Method";
        }

        //[Route("{Id}")]
        [HttpGet("{Id}")]
        public string GetEmployeeById(int Id)
        {
            return $"Response from GetEmployeeById Method, Id : {Id}";
        }

        //[Route("department/{Department}")]
        [HttpGet("department/{Department}")]
        public string GetDepartmentEmployees(string Department)
        {
            return $"Response from GetDepartmentEmployees Method, Department : {Department}";
        }

        //[Route("~/department/all")]
        [HttpGet("~/department/all")]
        public string GetAllDepartment()
        {
            return "Response from GetAllDepartment Method";
        }
    }
}

```

**Organizing APIs into Functional Areas**

```C#
[Route("api/billing/[controller]")]
public class InvoicesController : ControllerBase { /*...*/ }

[Route("api/customer/[controller]")]
public class CustomersController : ControllerBase { /*...*/ }

```


**API Versioning**
Route prefixes are particularly useful for versioning APIs. By including the version number in the prefix, you can easily manage and route requests to different versions of your API, allowing for simultaneous support of multiple API versions.
```C#
[Route("api/v1/[controller]")]
public class OrdersV1Controller : ControllerBase { /*...*/ }

[Route("api/v2/[controller]")]
public class OrdersV2Controller : ControllerBase { /*...*/ }
```

##### **Benefits of Using a Route Prefix in ASP.NET Core Web API:**

- **Organizational Clarity:** By grouping all actions within a controller under a common route prefix, you make the API’s structure clearer and more intuitive. This is especially beneficial in large projects with multiple controllers.
- **Simplification of Routes:** Instead of defining the full path for each action, you only need to specify the part of the route that is unique to that action. This reduces redundancy and the potential for typos or inconsistencies in route paths.
- **Versioning:** Route prefixes can be used effectively for API versioning. By including the version in the prefix (e.g., api/v1/users), you can manage multiple versions of your API simultaneously with minimal overlap or confusion.
# Route Constraints in ASP.NET Core Web API

1. **Type: int, double, bool, float, datetime, etc.**
2. **Min: min(number)**
3. **Max: max(number)**
4. **Range: range(10. 15)**
5. **Alpha: alpha**
6. **MinLength: minlength(5)**
7. **MaxLength: maxlength(10)**
8. **Length: length(10)**
9. **Required: required**
10. **Regex: regex(expression)**

##### **ASP.NET Core Web API Attribute Routing with Route Constraints**

Route constraints in ASP.NET Core Web API are used to restrict the HTTP requests that can match a particular route. They enable the API to ensure that the parameters of a route are of a certain type, range, or pattern, which can be essential for the API’s logic and security. Implementing route constraints effectively can lead to more robust and error-free applications.


```C#
using Microsoft.AspNetCore.Mvc;
namespace RoutingInASPNETCoreWebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class EmployeeController : ControllerBase
    {
        [Route("{EmployeeId}")]
        [HttpGet]
        public string GetEmployeeDetails(int EmployeeId)
        {
            return $"Response from GetEmployeeDetails Method, EmployeeId : {EmployeeId}";
        }

        [Route("{EmployeeName}")]
        [HttpGet]
        public string GetEmployeeDetails(string EmployeeName)
        {
            return $"Response from GetEmployeeDetails Method, EmployeeName : {EmployeeName}";
        }
    }
}

```


##### **Example: int type constraint:**

**[Route(“{EmployeeId:int}”)]**

```c#
using Microsoft.AspNetCore.Mvc;
namespace RoutingInASPNETCoreWebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class EmployeeController : ControllerBase
    {
        [Route("{EmployeeId:int}")]
        [HttpGet]
        public string GetEmployeeDetails(int EmployeeId)
        {
            return $"Response from GetEmployeeDetails Method, EmployeeId : {EmployeeId}";
        }

        [Route("{EmployeeName}")]
        [HttpGet]
        public string GetEmployeeDetails(string EmployeeName)
        {
            return $"Response from GetEmployeeDetails Method, EmployeeName : {EmployeeName}";
        }
    }
}

```
![[word-image-394.webp]]

##### **Min(number) constraint in ASP.NET Core:**

```C#
[Route("{EmployeeId:int:min(1000)}")]
[HttpGet]
public string GetEmployeeDetails(int EmployeeId)
{
    return $"Response from GetEmployeeDetails Method, EmployeeId : {EmployeeId}";
}

```

##### **Alpha constraint in ASP.NET Core Web API:**

**[Route(“{EmployeeName:alpha}”)]**

```C#
[Route("{EmployeeName:alpha}")]
[HttpGet]
public string GetEmployeeDetails(string EmployeeName)
{
    return $"Response from GetEmployeeDetails Method, EmployeeName : {EmployeeName}";
}

```

![[word-image-397.webp]]
```C#

[Route("{EmployeeId:int:max(1000)}")]
[HttpGet]
public string GetEmployeeDetails(int EmployeeId)
{
    return $"Response from GetEmployeeDetails Method, EmployeeId : {EmployeeId}";
}
```
![[word-image-400.webp]]

![[word-image-401.webp]]
# Controller Action Return Types in ASP.NET Core Web API

#### **Controller Action Return Types in ASP.NET Core Web API**

In ASP.NET Core Web API, controller actions can return various types of results, ultimately affecting the HTTP response sent to the client. The choice of return type depends on what you need to communicate to the client about the result of the operation performed by the action method. In ASP.NET Core Web API, we can return data from the controller action method in three different ways. They are as follows:

- **Primitive or Complex Types:** Actions can return primitive types (like int, string, etc.) or complex types (such as custom objects). When returning these directly, ASP.NET Core serializes the object into JSON (by default) and sets the content type of the response to application/json.
- **IActionResult:** The IActionResult return type can return various HTTP responses, including status codes, files, and error messages. This return type is useful when an action needs to return different types of responses, such as NotFound(), OK(), BadRequest(), etc.
- **ActionResult<T:** The ActionResult<T return type allows for returning either a response that can be serialized into JSON (or another format) or an action result (like IActionResult). This provides more flexibility in return types, allowing for both the return of data (as type T) and action results like NotFound() or Ok().
- **Specific Result Types:** ASP.NET Core provides several specific result types that implement the IActionResult interface and are used to return specific types of responses. Examples include Ok, BadRequest, NotFound, and File. These result types offer a clearer intention of the HTTP response returned from the API.
- **Void:** Returning void from an action method results in an empty 204 No Content response. This is typically used when an action performs an operation that does not need to return data to the client.
- **Task<IActionResult or Task<ActionResult<T:** For asynchronous operations, actions can return Task<IActionResult or Task<ActionResult<T. This enables the action methods to perform asynchronous operations, like database calls or web service requests, without blocking the calling thread. The framework handles the task completion and writes the result to the response.

##### **Adding Employee Model:**

```
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

##### **Adding Employee Controller:**
```C#
using Microsoft.AspNetCore.Mvc;
namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
    }
}

```

#### **Primitive or Complex Types**

```C#
[HttpGet("Name")]

public string GetName()

{

return "Return from GetName";

}
```

![[word-image-43851-1 1.webp]]

```C#
[HttpGet("Details")]
public Employee GetEmployeeDetails()
{
    return new Employee()
    {
        Id = 1001,
        Name = "Anurag",
        Age = 28,
        City = "Mumbai",
        Gender = "Male",
        Department = "IT"
    };
}

```


![[word-image-43851-2 1.webp]]

```C#
[HttpGet("All")]
public List<Employee> GetAllEmployee()
{
    return new List<Employee>()
            {
                new Employee(){ Id = 1001, Name = "Anurag", Age = 28, City = "Mumbai", Gender = "Male", Department = "IT" },
                new Employee(){ Id = 1002, Name = "Pranaya", Age = 28, City = "Delhi", Gender = "Male", Department = "IT" },
                new Employee(){ Id = 1003, Name = "Priyanka", Age = 27, City = "BBSR", Gender = "Female", Department = "HR"},
            };
}

```

```C#
[HttpGet("All")]
public List<Employee> GetAllEmployee()
{
    return new List<Employee>()
            {
                new Employee(){ Id = 1001, Name = "Anurag", Age = 28, City = "Mumbai", Gender = "Male", Department = "IT" },
                new Employee(){ Id = 1002, Name = "Pranaya", Age = 28, City = "Delhi", Gender = "Male", Department = "IT" },
                new Employee(){ Id = 1003, Name = "Priyanka", Age = 27, City = "BBSR", Gender = "Female", Department = "HR"},
            };
}
<div class="open_grepper_editor" title="Edit & Save To Grepper"></div>
```

##### **Example to Understand IActionResult Return Type in ASP.NET Core Web API:**

```C#
using Microsoft.AspNetCore.Mvc;
using ReturnTypeAndStatusCodes.Models;

namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        [HttpGet("All")]
        //As we are going to return Ok and NotFound Result from this action method
        //So, we are using IActionResult as the return type of this method
        public IActionResult GetAllEmployee()
        {
            //In Real-Time, you will get the data from the database
            //Here, we have hardcoded the data
            var listEmployees = new List<Employee>()
            {
                new Employee(){ Id = 1001, Name = "Anurag", Age = 28, City = "Mumbai", Gender = "Male", Department = "IT" },
                new Employee(){ Id = 1002, Name = "Pranaya", Age = 28, City = "Delhi", Gender = "Male", Department = "IT" },
                new Employee(){ Id = 1003, Name = "Priyanka", Age = 27, City = "BBSR", Gender = "Female", Department = "HR"},
            };

            //If at least of Emplpyee is Present return OK status code and the list of employees
            if (listEmployees.Any())
            {
                return Ok(listEmployees);
            }
            else
            {
                //If no Employee is Present return Not Found Status Code
                return NotFound();
            }
        }
    }
}

```

![[word-image-43851-4 1.webp]]

![[word-image-43851-5 1.webp]]

##### **Returning Not Found Data using IActionResult in ASP.NET Core:**

```C#
[HttpGet("{Id}")]
//As the following method is going to return Ok and NotFound Result
//So, we are using IActionResult as the return type of this method
public IActionResult GetEmployeeDetails(int Id)
{
    //In Real-Time, you will get the data from the database
    //Here, we have hardcoded the data
    var listEmployees = new List<Employee>()
            {
                    new Employee(){ Id = 1001, Name = "Anurag", Age = 28, City = "Mumbai", Gender = "Male", Department = "IT" },
                    new Employee(){ Id = 1002, Name = "Pranaya", Age = 28, City = "Delhi", Gender = "Male", Department = "IT" },
                    new Employee(){ Id = 1003, Name = "Priyanka", Age = 27, City = "BBSR", Gender = "Female", Department = "HR"},
            };

    //Fetch the Employee Data based on the Employee Id
    var employee = listEmployees.FirstOrDefault(emp => emp.Id == Id);

    //If Employee Exists Return OK with the Employee Data
    if (employee != null)
    {
        return Ok(employee);
    }
    else
    {
        //If Employee Does Not Exists Return NotFound
        return NotFound();
    }
}

```

![[returning-iactionresult-type-in-asp-net-core-web-a.webp]]
![[returning-not-found-data-using-iactionresult-in-as.webp]]
![[word-image-43851-8 1.webp]]

- OK()
- NotFound()
- Content()
- File()
- Redirect, Etc.
```C#
using Microsoft.AspNetCore.Mvc;
using ReturnTypeAndStatusCodes.Models;

namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        [HttpGet("All")]
        [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(List<Employee>))]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public IActionResult GetAllEmployee()
        {
            var listEmployees = new List<Employee>()
            {
                new Employee(){ Id = 1001, Name = "Anurag", Age = 28, City = "Mumbai", Gender = "Male", Department = "IT" },
                new Employee(){ Id = 1002, Name = "Pranaya", Age = 28, City = "Delhi", Gender = "Male", Department = "IT" },
                new Employee(){ Id = 1003, Name = "Priyanka", Age = 27, City = "BBSR", Gender = "Female", Department = "HR"},
            };

            if (listEmployees.Any())
            {
                return Ok(listEmployees);
            }
            else
            {
                return NotFound();
            }
        }

        [HttpGet("{Id}")]
        [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(Employee))]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public IActionResult GetEmployeeDetails(int Id)
        {
            var listEmployees = new List<Employee>()
            {
                    new Employee(){ Id = 1001, Name = "Anurag", Age = 28, City = "Mumbai", Gender = "Male", Department = "IT" },
                    new Employee(){ Id = 1002, Name = "Pranaya", Age = 28, City = "Delhi", Gender = "Male", Department = "IT" },
                    new Employee(){ Id = 1003, Name = "Priyanka", Age = 27, City = "BBSR", Gender = "Female", Department = "HR"},
            };

            var employee = listEmployees.FirstOrDefault(emp => emp.Id == Id);

            if (employee != null)
            {
                return Ok(employee);
            }
            else
            {
                return NotFound();
            }
        }
    }
}

```

![[word-image-43851-10 1.webp]]

```C#
using Microsoft.AspNetCore.Mvc;
using ReturnTypeAndStatusCodes.Models;

namespace ReturnTypeAndStatusCodes.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        [HttpGet("All")]
        public async Task<ActionResult<List<Employee>>> GetAllEmployee()
        {
            //Use async operation to get the data from the database
            var listEmployees = new List<Employee>()
            {
                new Employee(){ Id = 1001, Name = "Anurag", Age = 28, City = "Mumbai", Gender = "Male", Department = "IT" },
                new Employee(){ Id = 1002, Name = "Pranaya", Age = 28, City = "Delhi", Gender = "Male", Department = "IT" },
                new Employee(){ Id = 1003, Name = "Priyanka", Age = 27, City = "BBSR", Gender = "Female", Department = "HR"},
            };

            if (listEmployees.Any())
            {
                return Ok(listEmployees);
            }
            else
            {
                return NotFound();
            }
        }

        [HttpGet("{Id}")]
        public async Task<ActionResult<Employee>> GetEmployeeDetails(int Id)
        {
            //Use async operation to get the data from the database
            var listEmployees = new List<Employee>()
            {
                    new Employee(){ Id = 1001, Name = "Anurag", Age = 28, City = "Mumbai", Gender = "Male", Department = "IT" },
                    new Employee(){ Id = 1002, Name = "Pranaya", Age = 28, City = "Delhi", Gender = "Male", Department = "IT" },
                    new Employee(){ Id = 1003, Name = "Priyanka", Age = 27, City = "BBSR", Gender = "Female", Department = "HR"},
            };

            var employee = listEmployees.FirstOrDefault(emp => emp.Id == Id);

            if (employee != null)
            {
                return Ok(employee);
            }
            else
            {
                return NotFound();
            }
        }
    }
}

```


