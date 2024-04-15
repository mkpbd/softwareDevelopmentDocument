

# HTTP GET Method

##### **Define Models**

```C#
namespace HTTPMethodDemo.Models
{
    public class Order
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public decimal TotalAmount { get; set; }
    }
}

namespace HTTPMethodDemo.Models
{
    public class User
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public ICollection<Order> Orders { get; set; } = new List<Order>();
    }
}
```

##### **Create a Service**
**UserRepository.cs**
```C#
namespace HTTPMethodDemo.Models
{
    public class UserRepository
    {
        public List<User> Users = new List<User>()
        {
            new User() { Id = 1, Name= "Pranaya", Email = "Pranaya@Example.com" },
            new User() { Id = 2, Name= "Anurag", Email = "Anurag@Example.com" },
            new User() { Id = 3, Name= "Priyanka", Email = " Priyanka@Example.com" }
        };

        public List<Order> Orders = new List<Order>()
        {
            new Order() { Id = 1001, UserId = 1, TotalAmount = 100},
            new Order() { Id = 1002, UserId = 2, TotalAmount = 200},
            new Order() { Id = 1003, UserId = 1, TotalAmount = 300},
            new Order() { Id = 1004, UserId = 2, TotalAmount = 400},
            new Order() { Id = 1005, UserId = 3, TotalAmount = 500}
         };

        // Get All Users
        public IEnumerable<User> GetAll()
        {
            var users = Users.ToList();
            foreach (var user in users)
            {
                user.Orders = Orders.Where(ord => ord.UserId == user.Id).ToList();
            }

            return users;
        }

        // Get a user by ID
        public User GetById(int Id)
        {
            var user = Users.FirstOrDefault(u => u.Id == Id);
            if (user != null)
            {
                user.Orders = Orders.Where(ord => ord.UserId == user.Id).ToList();
            }

            return user;
        }

        // Search users by name
        public IEnumerable<User> SearchByName(string name)
        {
            var users = Users.Where(u => u.Name.Contains(name)).ToList();

            foreach (var user in users)
            {
                user.Orders = Orders.Where(ord => ord.UserId == user.Id).ToList();
            }

            return users;
        }

        // Get orders by user ID
        public IEnumerable<Order> GetOrderByUserId(int UserId)
        {
            var userWithOrders = Orders.Where(ord => ord.UserId == UserId);
            return userWithOrders ?? new List<Order>();
        }
    }
}
```


##### **Registering the Service:**

program.cs

``` c#
builder.Services.AddScoped<UserRepository>();

```
##### **Implement the Controller**
UsersController.cs
```C#
using HTTPMethodDemo.Models;
using Microsoft.AspNetCore.Mvc;

namespace HTTPMethodDemo.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsersController : ControllerBase
    {
        private readonly UserRepository _userRepository;

        public UsersController(UserRepository userRepository)
        {
            _userRepository = userRepository;
        }

        //Endpoint to retrieve all users
        //GET api/users
        [HttpGet]
        public ActionResult<List<User>> GetAllUsers()
        {
            var users = _userRepository.GetAll();
            return Ok(users);
        }

        //Endpoint to fetch details of a specific user by Id
        //GET api/users/1
        [HttpGet]
        [Route("api/users/{Id}")]
        public ActionResult<User> GetUser(int Id)
        {
            var user = _userRepository.GetById(Id);
            if (user == null)
            {
                return NotFound();
            }
            return Ok(user);
        }

        //Endpoint for searching users by name (query parameter)
        //GET api/users/search?name=pranaya
        [HttpGet]
        [Route("search")]
        public ActionResult<List<User>> SearchUsers(string name)
        {
            var users = _userRepository.SearchByName(name);
            if(users == null || !users.Any())
            {
                return NotFound();
            }
            return Ok(users);
        }

        //Endpoint to get all orders for a specific user
        //GET api/users/1/orders
        [HttpGet]
        [Route("api/users/{userId}/orders")]
        public ActionResult<List<Order>> GetUserOrders(int userId)
        {
            var orders = _userRepository.GetOrderByUserId(userId);
            if (orders == null || !orders.Any())
            {
                return NotFound();
            }
            return Ok(orders);
        }
    }
}
```

##### **API: Get All Users along with Orders**
![[word-image-47434-1.webp]]
![[word-image-47434-2.webp]]
![[word-image-47434-3.webp]]


![[word-image-47434-4.webp]]

##### **Modifying the UserRepository:**
```C#
namespace HTTPMethodDemo.Models
{
    public class UserRepository
    {
        public List<User> Users = new List<User>()
        {
            new User() { Id = 1, Name= "Pranaya", Email = "Pranaya@Example.com" },
            new User() { Id = 2, Name= "Anurag", Email = "Anurag@Example.com" },
            new User() { Id = 3, Name= "Priyanka", Email = "Priyanka@Example.com" }
        };

        public List<Order> Orders = new List<Order>()
        {
            new Order() { Id = 1001, UserId = 1, TotalAmount = 100},
            new Order() { Id = 1002, UserId = 2, TotalAmount = 200},
            new Order() { Id = 1003, UserId = 1, TotalAmount = 300},
            new Order() { Id = 1004, UserId = 2, TotalAmount = 400},
            new Order() { Id = 1005, UserId = 3, TotalAmount = 500}
         };

        // Get All Users
        public async Task<IEnumerable<User>> GetAll()
        {
            var users = Users.ToList();
            foreach (var user in users)
            {
                user.Orders = Orders.Where(ord => ord.UserId == user.Id).ToList();
            }
            await Task.Delay(TimeSpan.FromSeconds(1));
            return users;
        }

        // Get a user by ID
        public async Task<User> GetById(int Id)
        {
            var user = Users.FirstOrDefault(u => u.Id == Id);
            if (user != null)
            {
                user.Orders = Orders.Where(ord => ord.UserId == user.Id).ToList();
            }

            await Task.Delay(TimeSpan.FromSeconds(1));
            return user;
        }

        // Search users by name
        public async Task<IEnumerable<User>> SearchByName(string name)
        {
            var users = Users.Where(u => u.Name.Contains(name)).ToList();

            foreach (var user in users)
            {
                user.Orders = Orders.Where(ord => ord.UserId == user.Id).ToList();
            }

            await Task.Delay(TimeSpan.FromSeconds(1));
            return users;
        }

        // Get orders by user ID
        public async Task<IEnumerable<Order>> GetOrderByUserId(int UserId)
        {
            var userWithOrders = Orders.Where(ord => ord.UserId == UserId);
            await Task.Delay(TimeSpan.FromSeconds(1));
            return userWithOrders ?? new List<Order>();
        }
    }
}
```


##### **Modifying the UsersController:**

```C#
using HTTPMethodDemo.Models;
using Microsoft.AspNetCore.Mvc;

namespace HTTPMethodDemo.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsersController : ControllerBase
    {
        private readonly UserRepository _userRepository;

        public UsersController(UserRepository userRepository)
        {
            _userRepository = userRepository;
        }

        //Endpoint to retrieve all users
        //GET api/users
        [HttpGet]
        public async Task<ActionResult<List<User>>> GetAllUsers()
        {
            var users = await _userRepository.GetAllAsync();
            return Ok(users);
        }

        //Endpoint to fetch details of a specific user by Id
        //GET api/users/1
        [HttpGet]
        [Route("api/users/{Id}")]
        public async Task<ActionResult<User>> GetUser(int Id)
        {
            var user = await _userRepository.GetByIdAsync(Id);
            if (user == null)
            {
                return NotFound();
            }
            return Ok(user);
        }

        //Endpoint for searching users by name (query parameter)
        //GET api/users/search?name=pranaya
        [HttpGet]
        [Route("search")]
        public async Task<ActionResult<List<User>>> SearchUsers(string name)
        {
            var users = await _userRepository.SearchByNameAsync(name);
            if(users == null || !users.Any())
            {
                return NotFound();
            }
            return Ok(users);
        }

        //Endpoint to get all orders for a specific user
        //GET api/users/1/orders
        [HttpGet]
        [Route("api/users/{userId}/orders")]
        public async Task<ActionResult<List<Order>>> GetUserOrders(int userId)
        {
            var orders = await _userRepository.GetOrderByUserIdAsync(userId);
            if (orders == null || !orders.Any())
            {
                return NotFound();
            }
            return Ok(orders);
        }
    }
}
```


# HTTP Post Method

##### **Defining a Model**
Product.cs
```C#
namespace HTTPMethodDemo.Models
{
    public class Product
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int Price { get; set; }
        public int Quantity { get; set; }
    }
}
```

##### **Create a Service**
ProductRepository.cs

```C#
namespace HTTPMethodDemo.Models
{
    public class ProductRepository
    {
        public List<Product> Products = new List<Product>()
        {
            new Product() { Id = 1, Name= "Laptop", Price = 1000, Quantity = 10 },
            new Product() { Id = 2, Name= "Desktop", Price = 2000, Quantity = 20 }
        };

        // Add a New Product and return the newly Created Product Id
        public int AddProduct(Product product)
        {
            //Set the Product Id
            product.Id = 3;
            Products.Add(product);

            return product.Id;
        }

        // Get a Product by ID
        public Product GetById(int Id)
        {
            var product = Products.FirstOrDefault(u => u.Id == Id);
            
            return product;
        }
    }
}
```

Program.cs

```c#
builder.Services.AddScoped<ProductRepository>();
```
##### **Creating the Controller**
**ProductsController**

```C#
using HTTPMethodDemo.Models;
using Microsoft.AspNetCore.Mvc;

namespace HTTPMethodDemo.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductController : ControllerBase
    {
        private readonly ProductRepository _productRepository;

        public ProductController(ProductRepository productRepository)
        {
            _productRepository = productRepository;
        }

        // Post method for adding a new product
        // POST api/product
        [HttpPost]
        public IActionResult Post([FromBody] Product product)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            // Add the product to your data store.
            int ProductId = _productRepository.AddProduct(product);
            product.Id = ProductId;

            // Return a 201 Created response with the created resource
            return CreatedAtAction("GetProduct", new { Id = product.Id }, product);
        }

        // GET method for retrieving a product by ID
        // GET api/product/1
        [HttpGet("{Id}")]
        public ActionResult<Product> GetProduct(int Id)
        {
            // Retrieve and return the product from your data store
            var product = _productRepository.GetById(Id);
            if (product == null)
            {
                return NotFound();
            }
            return Ok(product);
        }
    }
}
```

- **[HttpPost]:** This attribute marks a method as a handler for HTTP POST requests.
- **[FromBody]:** This attribute tells ASP.NET Core Framework to get the value of the product parameter from the body of the incoming HTTP request. ASP.NET Core automatically deserializes the JSON in the request body to the Product type.
- **CreatedAtAction:** This method creates a **CreatedAtActionResult** object that produces a 201 Created response. It also adds a Location header to the response that specifies the URI of the newly created resource.

![[word-image-47442-1.webp]]
##### **Modifying the ProductRepository:**
```C#
namespace HTTPMethodDemo.Models
{
    public class ProductRepository
    {
        public List<Product> Products = new List<Product>()
        {
            new Product() { Id = 1, Name= "Laptop", Price = 1000, Quantity = 10 },
            new Product() { Id = 2, Name= "Desktop", Price = 2000, Quantity = 20 }
        };

        // Add a New Product and return the newly Product Id
        public async Task<int> AddProductAsync(Product product)
        {
            //Set the Product Id
            product.Id = 3;
            Products.Add(product);

            await Task.Delay(TimeSpan.FromSeconds(1));

            return product.Id;
        }

        // Get a Product by ID
        public async Task<Product> GetByIdAsync(int Id)
        {
            var product = Products.FirstOrDefault(u => u.Id == Id);

            await Task.Delay(TimeSpan.FromSeconds(1));
            return product;
        }
    }
}
```
##### **Modifying the Product Controller:**
```C#
using HTTPMethodDemo.Models;
using Microsoft.AspNetCore.Mvc;

namespace HTTPMethodDemo.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductController : ControllerBase
    {
        private readonly ProductRepository _productRepository;

        public ProductController(ProductRepository productRepository)
        {
            _productRepository = productRepository;
        }

        // Add a New product
        // POST api/product
        [HttpPost]
        public async Task<IActionResult> Post([FromBody] Product product)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            // Add the product to your data store.
            int ProductId = await _productRepository.AddProductAsync(product);
            product.Id = ProductId;

            // Return a 201 Created response with the created resource
            return CreatedAtAction("GetProduct", new { Id = product.Id }, product);
        }

        // GET method for retrieving a product by ID
        // GET api/product/1
        [HttpGet("{Id}")]
        public async Task<ActionResult<Product>> GetProduct(int Id)
        {
            // Retrieve and return the product from your data store
            var product = await _productRepository.GetByIdAsync(Id);
            if (product == null)
            {
                return NotFound();
            }
            return Ok(product);
        }
    }
}
```

# HTTP PUT Method

##### **Defining a Model**

```C#
namespace HTTPMethodDemo.Models
{
    public class Product
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int Price { get; set; }
        public int Quantity { get; set; }
    }
}
```

##### **Create a Service**
```C#
namespace HTTPMethodDemo.Models
{
    public class ProductRepository
    {
        public List<Product> Products = new List<Product>()
        {
            new Product() { Id = 1, Name= "Laptop", Price = 1000, Quantity = 10 },
            new Product() { Id = 2, Name= "Desktop", Price = 2000, Quantity = 20 }
        };

        public async Task<Product> UpdateProductAsync(Product product)
        {
            //Set the Product Id
            var existingProduct = Products.FirstOrDefault(u => u.Id == product.Id);

            if(existingProduct != null)
            {
                existingProduct.Price = product.Price;
                existingProduct.Quantity = product.Quantity;
                existingProduct.Name = product.Name;

                //Update the Product into the Data
            }
            
            await Task.Delay(TimeSpan.FromSeconds(1));

            return existingProduct;
        }
    }
}
```

##### **Register Service:**
Program.cs
```c#
builder.Services.AddScoped<ProductRepository>();
```

##### **Creating the Controller**
```C#
using HTTPMethodDemo.Models;
using Microsoft.AspNetCore.Mvc;

namespace HTTPMethodDemo.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductController : ControllerBase
    {
        private readonly ProductRepository _productRepository;

        public ProductController(ProductRepository productRepository)
        {
            _productRepository = productRepository;
        }

        // Update an Existing Product
        // PUT: api/Product/1
        [HttpPut("{id}")]
        public async Task<ActionResult<Product>> PutProduct(int id, [FromBody] Product product)
        {
            if (id != product.Id)
            {
                return BadRequest();
            }

            var result = await _productRepository.UpdateProductAsync(product);
            if(result == null)
            {
                return NotFound();
            }

            return Ok(result);
        }
    }
}
```


![[word-image-47447-1.webp]]

# HTTP PATCH Method

- **Partial Update:** The PATCH HTTP Request is used to make partial updates. For example, if you have an object representing a user with names, email, and address fields, a PATCH request might change just the email field without affecting the rest.
- **Idempotency:** PATCH requests are supposed to be idempotent, meaning that multiple identical PATCH requests should have the same effect as a single request. However, in real-time, this depends on the nature of the operation and how it’s implemented on the server
##### **Creating Product Model**

```C#
using System.ComponentModel.DataAnnotations;

namespace HTTPMethodDemo.Models
{
    public class Product
    {
        public int Id { get; set; }
        [Required]
        public string Name { get; set; }
        [Required]
        public int Price { get; set; }
        [Required]
        public int Quantity { get; set; }
        public string? Description { get; set; }
    }
}
```

##### **Create Product Service**

```C#
namespace HTTPMethodDemo.Models
{
    public class ProductRepository
    {
        public List<Product> Products = new List<Product>()
        {
            new Product() { Id = 1, Name= "Laptop", Price = 1000, Quantity = 10, Description = "A high-performance Laptop." },
            new Product() { Id = 2, Name= "Desktop", Price = 2000, Quantity = 20 } //Description is Optional
        };

        public Product GetById(int Id)
        {
            // Find a product by ID
            return Products.FirstOrDefault(p => p.Id == Id);
        }

        public void Update(Product product)
        {
            // Find the index of the product to update
            var index = Products.FindIndex(p => p.Id == product.Id);
            if (index != -1)
            {
                // Update the product at the found index
                Products[index] = product;
            }
        }
    }
}
```

- **Return Type:** The method returns no value, indicating that its primary purpose is to perform an action rather than compute and return data.
- **Parameter:** The method takes a Product object as a parameter, which contains the updated information for a product.
- **FindIndex:** This method searches the product list for the product that matches the given ID. It returns the zero-based index of the first occurrence of a product that meets this condition.

##### **Register Product Repository Service:**
```C#
builder.Services.AddScoped<ProductRepository>();
builder.Services.AddControllers().AddNewtonsoftJson();
```
##### **Implementing the PATCH Endpoint**

**Install-Package Microsoft.AspNetCore.JsonPatch**
**Install-Package Microsoft.AspNetCore.Mvc.NewtonsoftJson**
![[word-image-47452-1.webp]]

##### **Creating Controller with PATCH Action Method:**

```C#
using HTTPMethodDemo.Models;
using Microsoft.AspNetCore.JsonPatch;
using Microsoft.AspNetCore.Mvc;

namespace HTTPMethodDemo.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductController : ControllerBase
    {
        private readonly ProductRepository _productRepository;

        public ProductController(ProductRepository productRepository)
        {
            _productRepository = productRepository;
        }

        [HttpPatch("{Id}")]
        public IActionResult PatchProduct(int Id, [FromBody] JsonPatchDocument<Product> patchDoc)
        {
            if (patchDoc == null)
            {
                return BadRequest();
            }

            var product = _productRepository.GetById(Id);

            if (product == null)
            {
                return NotFound();
            }

            patchDoc.ApplyTo(product, ModelState);

            //The following will not work
            //if (!ModelState.IsValid)
            //{
            //    return BadRequest(ModelState);
            //}

            if (!TryValidateModel(product))
            {
                return BadRequest(ModelState);
            }

            _productRepository.Update(product);

            return Ok(product);
        }
    }
}
```

#### **How to Test the Patch End Point:**

assing JSON data to a PATCH endpoint in ASP.NET Core Web API that accepts a JsonPatchDocument is straightforward but requires adherence to the JSON Patch format specified in RFC 6902. This format defines a series of operations (add, remove, replace, move, and copy) that describe how to modify a JSON 

Your JSON data should be an array of operation objects. Each operation object should have at least three properties: **op** (the operation), **path** (the location within the target document to apply the operation), and **value** (the value to use with the operation, if applicable). For example, we have the following Product model:

![[word-image-47452-2.webp]]

```json
[
  {
    "op": "replace",
    "path": "/Name",
    "value": "Name Updated"
  },
  {
    "op": "remove",
    "path": "/Description"
  }
]
```

![[word-image-47452-3.webp]]

**Request Body:**
```json
[
  {
    "op": "remove",
    "path": "/Name"
  }
]
```
![[word-image-47452-4.webp]]

**Request Body:**

```json
[
  {
    "op": "add",
    "path": "/Description",
    "value": "Description Added"
  }
]
```
![[word-image-47452-5.webp]]

##### **Modifying the ProductRepository:**

```C#
namespace HTTPMethodDemo.Models
{
    public class ProductRepository
    {
        public List<Product> Products = new List<Product>()
        {
            new Product() { Id = 1, Name= "Laptop", Price = 1000, Quantity = 10, Description = "A high-performance Laptop." },
            new Product() { Id = 2, Name= "Desktop", Price = 2000, Quantity = 20 } //Description is Optional
        };

        public async Task<Product> GetByIdAsync(int Id)
        {
            await Task.Delay(TimeSpan.FromSeconds(1));
            // Find a product by ID
            return Products.FirstOrDefault(p => p.Id == Id);
        }

        public async Task UpdateAsync(Product product)
        {
            await Task.Delay(TimeSpan.FromSeconds(1));

            // Find the index of the product to update
            var index = Products.FindIndex(p => p.Id == product.Id);
            if (index != -1)
            {
                // Update the product at the found index
                Products[index] = product;
            }
        }
    }
}
```

##### **Modifying the Product Controller:**

```C#
using HTTPMethodDemo.Models;
using Microsoft.AspNetCore.JsonPatch;
using Microsoft.AspNetCore.Mvc;

namespace HTTPMethodDemo.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductController : ControllerBase
    {
        private readonly ProductRepository _productRepository;

        public ProductController(ProductRepository productRepository)
        {
            _productRepository = productRepository;
        }

        [HttpPatch("{Id}")]
        public async Task<IActionResult> PatchProduct(int Id, [FromBody] JsonPatchDocument<Product> patchDoc)
        {
            if (patchDoc == null)
            {
                return BadRequest();
            }

            var product = await _productRepository.GetByIdAsync(Id);

            if (product == null)
            {
                return NotFound();
            }

            patchDoc.ApplyTo(product, ModelState);

            //The following will not work
            //if (!ModelState.IsValid)
            //{
            //    return BadRequest(ModelState);
            //}

            if (!TryValidateModel(product))
            {
                return BadRequest(ModelState);
            }

            await _productRepository.UpdateAsync(product);

            return Ok(product);
        }
    }
}
```

# HTTP DELETE Method
##### **Define Product Model**


```c#
namespace HTTPMethodDemo.Models
{
    public class Product
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int Price { get; set; }
        public int Quantity { get; set; }
        public string? Description { get; set; }
    }
}
```

##### **Create Product Service**

```C#
namespace HTTPMethodDemo.Models
{
    public class ProductRepository
    {
        public List<Product> Products = new List<Product>()
        {
            new Product() { Id = 1, Name= "Laptop", Price = 1000, Quantity = 10, Description = "A high-performance Laptop." },
            new Product() { Id = 2, Name= "Desktop", Price = 2000, Quantity = 20 } //Description is Optional
        };

        public Product GetById(int Id)
        {
            // Find a product by ID
            return Products.FirstOrDefault(p => p.Id == Id);
        }

        public void DeleteProduct(Product product)
        {
            Products.Remove(product);
        }
    }
}
```

##### **Register Product Repository Service:**

```C#
builder.Services.AddScoped<ProductRepository>();
```

##### **Creating Product Controller:**

```C#
using HTTPMethodDemo.Models;
using Microsoft.AspNetCore.Mvc;

namespace HTTPMethodDemo.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductController : ControllerBase
    {
        private readonly ProductRepository _productRepository;

        public ProductController(ProductRepository productRepository)
        {
            _productRepository = productRepository;
        }

        // DELETE: api/Product/1
        [HttpDelete("{Id}")]
        public IActionResult DeleteProduct(int Id)
        {
            var product =  _productRepository.GetById(Id);
            if (product == null)
            {
                return NotFound();
            }

            _productRepository.DeleteProduct(product);

            // Returns a 204 No Content response
            return NoContent(); 
        }
    }
}
```

![[word-image-47461-1.webp]]

##### **Modifying the ProductRepository:**

```C#
namespace HTTPMethodDemo.Models
{
    public class ProductRepository
    {
        public List<Product> Products = new List<Product>()
        {
            new Product() { Id = 1, Name= "Laptop", Price = 1000, Quantity = 10, Description = "A high-performance Laptop." },
            new Product() { Id = 2, Name= "Desktop", Price = 2000, Quantity = 20 } //Description is Optional
        };

        public async Task<Product> GetByIdAsync(int Id)
        {
            await Task.Delay(TimeSpan.FromSeconds(1));
            // Find a product by ID
            return Products.FirstOrDefault(p => p.Id == Id);
        }

        public async Task DeleteProductAsync(Product product)
        {
            await Task.Delay(TimeSpan.FromSeconds(1));
            Products.Remove(product);
        }
    }
}
```

##### **Modifying the Product Controller:**

```C#
using HTTPMethodDemo.Models;
using Microsoft.AspNetCore.Mvc;

namespace HTTPMethodDemo.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductController : ControllerBase
    {
        private readonly ProductRepository _productRepository;

        public ProductController(ProductRepository productRepository)
        {
            _productRepository = productRepository;
        }

        // DELETE: api/Product/1
        [HttpDelete("{Id}")]
        public async Task<IActionResult> DeleteProduct(int Id)
        {
            var product = await _productRepository.GetByIdAsync(Id);
            if (product == null)
            {
                return NotFound();
            }

            await _productRepository.DeleteProductAsync(product);

            // Returns a 204 No Content response
            return NoContent(); 
        }
    }
}
```

# HTTP HEAD Method

The HTTP HEAD method is similar to the GET method in that it requests a response from the server that contains the headers for a specific resource. However, unlike the GET method, the HEAD method does not return the body of the response.

##### **Creating Controller:**

```C#
using Microsoft.AspNetCore.Mvc;
namespace HTTPMethodDemo.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ResourcesController : ControllerBase
    {
        [HttpGet("GetById/{Id}")]
        public IActionResult GetById(int Id)
        {
            return Ok("Resource Returned");
        }

        // Example method to check if a resource exists
        // URL: api/Resources/CheckResourceExists/1
        [HttpHead("CheckResourceExists/{Id}")]
        public IActionResult CheckResourceExists(int Id)
        {
            // logic to check if the resource exists, e.g., in a database
            // For example, Product with Id, Employee with Id, Order with ID, etc.
            var resourceExists = true;

            if (resourceExists)
            {
                return Ok(); // Returns 200 OK if the resource exists
            }
            else
            {
                return NotFound(); // Returns 404 Not Found if the resource does not exist
            }
        }

        // Detecting Resource Changes and Updates
        // URL: api/Resources//1
        [HttpHead("GetResourceInfo/{Id}")]
        public IActionResult GetResourceHeaders(int Id)
        {
            // logic to retrieve resource details, e.g., from a database
            var resourceMetadata = new
            {
                LastModified = DateTime.UtcNow,
                CustomHeader = "ABCDZYZ"
            };

            Response.Headers.Add("Last-Modified", resourceMetadata.LastModified.ToString("R")); // RFC1123 format
            Response.Headers.Add("CustomHeader", resourceMetadata.CustomHeader);
            return Ok();
        }

        // Retrieving Header Information
        // URL: api/Resources/GetResourceHeaders/1
        [HttpHead("GetResourceHeaders/{Id}")]
        public IActionResult GetResourceInfo(int Id)
        {
            // logic to find resource and get the Resource Headers
            var resource = new
            {
                ContentType = "application/json",
                ContentLength = 1234 //bytes
            };

            if (resource == null)
            {
                return NotFound();
            }

            // Add desired headers
            Response.Headers.Add("Content-Type", resource.ContentType);
            Response.Headers.Add("Content-Length", resource.ContentLength.ToString());
            // Additional headers as needed

            return Ok();
        }
    }
}
```


![[word-image-47466-1.webp]]
##### **API 2: Detecting Resource Changes and Updates**
![[word-image-47466-2.webp]]

##### **API 3: Retrieving Header Information**

![[word-image-47466-3.webp]]

# HTTP OPTIONS Method

- **Purpose:** The OPTIONS method allows clients to determine the features supported for a specific resource or server. For example, it can be used to determine which HTTP methods are supported by a server or endpoint.
- **CORS (Cross-Origin Resource Sharing) Preflight Requests:** In the context of CORS, the OPTIONS method is used as a preflight request to determine whether the actual request is safe to send. Before performing a request with an HTTP method other than GET or POST or with custom headers, browsers can use an OPTIONS request to check the rules defined by the server.
- **Headers:** Responding to an OPTIONS request typically includes headers that specify allowed methods and other options. Common headers such as Allow, which lists the supported HTTP methods (such as GET, POST, PUT, DELETE), and Access-Control-Allow-Methods for CORS, indicate which methods are allowed when accessing the resource from a different origin.
- **No Resource Retrieval:** The OPTIONS method does not retrieve the target resource’s content. It only retrieves the communication options available, making it a safe method that does not cause any side effects on the server.
##### **Attribute Routing**
```C#
using Microsoft.AspNetCore.Mvc;
namespace HTTPMethodDemo.Controllers
{
    [ApiController]
    [Route("api/resource")]
    public class ResourceController : ControllerBase
    {
        // Example of a GET method
        [HttpGet]
        public IActionResult Get()
        {
            return Ok("GET Response");
        }

        // Implementing OPTIONS
        [HttpOptions]
        public IActionResult Options()
        {
            Response.Headers.Add("Allow", "GET, POST, OPTIONS");
            return Ok();
        }
    }
}
```

![[word-image-47473-1.webp]]

![[word-image-47473-2.webp]]

##### **Automatic Handling via CORS Middleware**
Program.cs
```c#
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowSpecificOrigins",
    builder =>
    {
        builder.AllowAnyOrigin()
               .AllowAnyHeader()
               .WithMethods("GET", "POST", "OPTIONS");
    });
});
```

