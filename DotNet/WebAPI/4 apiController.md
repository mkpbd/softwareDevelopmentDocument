![[word-image-46881-2.webp]]

![[word-image-46881-3.webp]]
##### **Modifying the EmployeeController Class:**

```C#
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace MyFirstWebAPIProject.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        [HttpGet]
        public string Get()
        {
            return "Returning from EmployeeController Get Method";
        }
    }
}

```

With the above changes in place, now run the application and navigate to /**api/employee** URL, and you should see the following result.

![[word-image-46881-4.webp]]

```c#
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace MyFirstWebAPIProject.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        [HttpGet]
        public string Get()
        {
            return "Returning from EmployeeController Get Method";
        }

        [HttpGet]
        public string GetEmployee()
        {
            return "Returning from EmployeeController GetEmployee Method";
        }
    }
}


```

With the above changes in place, now run the application and navigate to **/api/employee** URL, and you should get the following exception.

![[word-image-46881-5.webp]]

```C#
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace MyFirstWebAPIProject.Controllers
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        [HttpGet]
        public string Get()
        {
            return "Returning from EmployeeController Get Method";
        }

        [HttpGet]
        public string GetEmployee()
        {
            return "Returning from EmployeeController GetEmployee Method";
        }
    }
}

```

![[word-image-46881-6.webp]]

![[word-image-46881-7.webp]]
**Note:** In this article, I have just given an introduction to Controllers, and in our upcoming articles, we will discuss how to implement [**GET, POST, PUT, PATCH, and DELETE Methods**](https://dotnettutorials.net/lesson/models-in-asp-net-core-web-api/) in a proper manner.

##### **ApiController Attribute in ASP.NET Core Web API**

The ApiController attribute in ASP.NET Core Web API is a feature introduced in ASP.NET Core 2.1 to enhance the development of HTTP-based APIs. It is applied at the class level and offers several conveniences and conventions that make building clean and well-documented Web APIs easier. Here are some key aspects of the ApiController attribute:

- **Attribute Routing Requirement:** With ApiController, attribute routing becomes a requirement. This means you must use [Route], [HttpGet], [HttpPost], etc., to define the routes for your actions.
- **Automatic HTTP 400 Responses:** It automatically handles model validation errors by providing a standardized response. If the request model does not satisfy the model validation rules, the API responds with a 400 Bad Request without writing additional code.
- **Binding Source Parameter:** The attribute infers the source of parameters for actions. For instance, it assumes [FromBody] for complex type parameters and [FromQuery] for simple types in GET requests. This reduces the need to specify the source of the parameter explicitly.
- **Enhanced Swagger Support:** When used in conjunction with tools like Swashbuckle, it provides better metadata for API documentation. This results in more descriptive Swagger UIs.
##### **Difference Between the Controller and ControllerBase class in ASP.NET Core:**

In ASP.NET Core, Controller and ControllerBase are two different base classes that can be used when building web applications. Understanding their differences is important for deciding which one to inherit from in your own controllers.

###### **ControllerBase Class**

- **Purpose:** Primarily designed for building Web APIs.
- **Features:** It provides access to several properties and methods useful for handling HTTP requests, such as Request, Response, ModelState, and various methods for returning data (Ok, NotFound, BadRequest, etc.). It does not include support for views or rendering HTML.
- **Use Case:** Ideal for RESTful services focusing on returning data (JSON, XML) rather than rendering HTML views.
- **Namespace:** Found in Microsoft.AspNetCore.Mvc.

###### **Controller Class**

- **Purpose:** Designed for handling web pages, typically used in MVC applications.
- **Features:** Inherits from ControllerBase. Includes all the features of ControllerBase plus additional features to support building web pages, such as returning views (View method), handling Razor views, and supporting view-specific features like ViewData and ViewBag.
- **Use Case:** Best suited for applications that need to render HTML, such as traditional MVC web applications.
- **Namespace:** Also found in Microsoft.AspNetCore.Mvc.

##### **Key Differences Between ControllerBase and Controller:**

###### **View Support:**

- ControllerBase is streamlined for API development and does not support view-related features.
- Controller extends ControllerBase with additional features for handling views, making it suitable for MVC applications where you must return HTML pages.

###### **Intended Use:**

- ControllerBase is intended for APIs (returning data formats like JSON or XML).
- The Controller is intended for web applications that use the MVC pattern with views.

###### **Flexibility:**

- ControllerBase offers a lightweight and focused set of functionalities for API development.
- The Controller provides more flexibility and features for handling both APIs and views within the same controller, but it’s heavier due to additional view-related features.


##### **Best Practices**

- **Thin Controllers:** Keep business logic out of controllers and in services or other layers.
- **Use DTOs (Data Transfer Objects):** Avoid exposing your database models directly; map them to DTOs.
- **Consistent Naming Convention:** Follow RESTful naming conventions for actions.
- **Secure Your API:** Implement authentication, authorization, and validate inputs to secure your API.
- **Unit Testing:** Write unit tests for your controllers to ensure reliability and maintainability.
