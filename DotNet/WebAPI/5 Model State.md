1. **Definition:** ASP.NET Core Web API models are typically plain C# classes (POCOs: Plain Old CLR Objects).
2.  **Creating a Model:** A model is usually a simple class with public properties. The properties in the model correspond to the data fields that the API will accept or return.
3.  **Data Annotations for Validation:** Data annotations can be used to define validation rules directly in the model. Common Data Annotation Attributes include [Required], [StringLength], [Range], and more. These Data Annotation Attributes help ensure that the data received by the API meets the specified criteria before the controller actions process it.
4.  **Usage in Controller Actions:** Models are used as parameters in controller actions to receive data from a request (e.g., POST, PUT). They can also be the return type of actions to structure the data sent back to the client. Model binding in ASP.NET Core automatically maps data from the request to the model properties.
5.  **Model State Validation:** ASP.NET Core automatically validates incoming models based on the data annotations. The ModelState.IsValid property can be checked in a controller action to see if the model passed the validation rules. If validation fails, the API can return appropriate error responses.
6.  **DTOs (Data Transfer Objects):** Sometimes, using Data Transfer Objects (DTOs) is beneficial instead of directly exposing the domain models. DTOs can help by including only a subset of the properties or aggregating data from multiple models. This approach enhances security and performance by not exposing more data than necessary and by optimizing the data structure for network transfer.
7.  **AutoMapper for Model Conversion:** AutoMapper or similar libraries can be used to map data between models and DTOs. This simplifies the conversion logic, making the code cleaner and more maintainable.

##### **Creating Basic Model:**

```C#
namespace MyFirstWebAPIProject.Models
{
    public class Product
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public decimal Price { get; set; }
        public string Category { get; set; }
    }
}

```

##### **Model with Data Annotations**

```C#
using System.ComponentModel.DataAnnotations;

namespace MyFirstWebAPIProject.Models
{
    public class User
    {
        public int Id { get; set; }

        [Required]
        [StringLength(100)]
        public string FirstName { get; set; }

        [Required]
        [StringLength(100)]
        public string LastName { get; set; }

        [EmailAddress]
        public string Email { get; set; }
    }
}

```
##### **Model with Relationships**

```C#
namespace MyFirstWebAPIProject.Models
{
    public class Order
    {
        public int OrderId { get; set; }
        public DateTime OrderDate { get; set; }
        public ICollection<OrderDetail> OrderDetails { get; set; }
    }

    public class OrderDetail
    {
        public int OrderDetailId { get; set; }
        public int OrderId { get; set; }
        public int ProductId { get; set; }
        public decimal Price { get; set; }
        public int Quantity { get; set; }

        public Order Order { get; set; }
        public Product Product { get; set; }
    }
}
```

##### **Model with Enumerations**

```C#
namespace MyFirstWebAPIProject.Models
{
    public class Employee
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public Department Department { get; set; }
    }

    public enum Department
    {
        HR, IT, Finance, Marketing
    }
}

```
##### **Model with Fluent Validation**

```C#
namespace MyFirstWebAPIProject.Models
{
    public class Customer
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
    }
}

```

```C#
using FluentValidation;
namespace MyFirstWebAPIProject.Models
{
    public class CustomerValidator : AbstractValidator<Customer>
    {
        public CustomerValidator()
        {
            RuleFor(customer => customer.Name).NotEmpty();
            RuleFor(customer => customer.Email).EmailAddress();
            // Other rules
        }
    }
}

```

##### **Using Models in Controller:**

```c#
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using MyFirstWebAPIProject.Models;

namespace MyFirstWebAPIProject.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductsController : ControllerBase
    {
        private static List<Product> _products = new List<Product>
        {
            new Product { Id = 1, Name = "Laptop", Price = 1000.00m, Category = "Electronics" },
            new Product { Id = 2, Name = "Desktop", Price = 2000.00m, Category = "Electronics" },
            new Product { Id = 3, Name = "Mobile", Price = 3000.00m, Category = "Electronics" },
            // Add more products
        };

        // GET: api/products
        [HttpGet]
        public ActionResult<IEnumerable<Product>> GetProducts()
        {
            return _products;
        }

        // GET: api/products/2
        [HttpGet("{id}")]
        public ActionResult<Product> GetProduct(int id)
        {
            var product = _products.FirstOrDefault(p => p.Id == id);
            if (product == null)
            {
                return NotFound();
            }
            return product;
        }

        // POST: api/products
        [HttpPost]
        public ActionResult<Product> PostProduct(Product product)
        {
            _products.Add(product);
            return CreatedAtAction(nameof(GetProduct), new { id = product.Id }, product);
        }

        // PUT: api/products/5
        [HttpPut("{id}")]
        public IActionResult PutProduct(int id, Product product)
        {
            if (id != product.Id)
            {
                return BadRequest();
            }

            var existingProduct = _products.FirstOrDefault(p => p.Id == id);
            if (existingProduct == null)
            {
                return NotFound();
            }

            existingProduct.Name = product.Name;
            existingProduct.Price = product.Price;
            existingProduct.Category = product.Category;

            // In a real application, here you would update the product in the database

            return NoContent();
        }

        // DELETE: api/products/5
        [HttpDelete("{id}")]
        public IActionResult DeleteProduct(int id)
        {
            var product = _products.FirstOrDefault(p => p.Id == id);
            if (product == null)
            {
                return NotFound();
            }

            _products.Remove(product);

            // In a real application, here you would delete the product from the database

            return NoContent();
        }
    }
}

```


##### **GET Method (Read)**

![[word-image-46882-1-768x600.webp]]

- **[HttpGet]:** Indicates that this action handles HTTP GET requests.
- **ActionResult<IEnumerable <Product:** The action returns an IEnumerable of Product, wrapped in an ActionResult for HTTP response flexibility.

 - **ActionResult<Product:** The action returns a Product, wrapped in an ActionResult for HTTP response flexibility.
- **[HttpGet(“{id}”)]:** Specifies that this action responds to a GET request with an id parameter in the route. This method searches for a product with the given id. If not found, it returns a 404 Not Found response.
##### **POST Method (Create)**


![[word-image-46882-2-768x403.webp]]

- **[HttpPost]:** Indicates handling of POST requests.
- **CreatedAtAction:** Returns a 201 Created response, and the Location header includes the URI of the new product.


##### **PUT Method (Update)**

![[word-image-46882-3-768x526.webp]]

- **[HttpPut(“{id}”)]:** Specifies that this action responds to a PUT request and expects an id in the route.
- The method updates the product if it exists or returns a 404 Not Found response if it doesn’t.

##### **DELETE Method (Delete)**

![[word-image-46882-4-768x538.webp]]

- **[HttpDelete(“{id}”)]:** Indicates that this action handles DELETE requests with an id parameter.
- The method deletes the product if it exists or returns a 404 Not Found response if it doesn’t.


##### **Testing the Products Controller APIs:**

You can test the APIs in many different ways, like using Postman, Fiddler, and Swagger. But .NET 8 provides the .http file, and using that .http file, we can also test the functionality very easily. This .http file name will be the same as your project name. My project’s name is MyFirstWebAPIProject, so Visual Studio creates the MyFirstWebAPIProject.http file.

```http
@MyFirstWebAPIProject_HostAddress = https://localhost:7237

### Get All Products
GET {{MyFirstWebAPIProject_HostAddress}}/api/products
Accept: application/json
###

### Get Product with ID 1
GET {{MyFirstWebAPIProject_HostAddress}}/api/products/1
Accept: application/json
###

### Create a New Product
POST {{MyFirstWebAPIProject_HostAddress}}/api/products
Content-Type: application/json

{
    "Name": "New Product",
    "Price": 39.99,
    "Category": "Books"
}

###

### Update Product with ID 1
PUT {{MyFirstWebAPIProject_HostAddress}}/api/products/1
Content-Type: application/json

{
    "Id": 1,
    "Name": "Updated Product",
    "Price": 49.99,
    "Category": "Electronics"
}

###

### Delete Product with ID 1
DELETE {{MyFirstWebAPIProject_HostAddress}}/api/products/1
###

```


##### **Testing:**

Before testing, ensure your API runs locally and listens on the correct port. Please change the port number to the port number on which your application runs. Open the .http file in your IDE, and you should see “**Send Request**” links above each HTTP request. Click these links to execute the requests, and you’ll see the responses directly in your IDE,

![[word-image-46882-5.webp]]

- Ensure that your API is running and accessible at the specified URL and port.
- The Content-Type: application/json header in the requests tells the server that you’re sending JSON data.
- The format of the JSON payloads in POST and PUT requests should match the expected format of your Product model.
