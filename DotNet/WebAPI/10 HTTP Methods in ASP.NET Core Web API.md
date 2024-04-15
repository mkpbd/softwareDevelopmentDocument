#### **Types of HTTP Methods:**

The primary or most commonly used HTTP methods are as follows:

1. **GET:** Requests using GET should only retrieve data and should have no other effect.
2. **POST:** The HTTP Post Method Sends data to the server. The Content-Type header indicates the type of the request body. This method is often used when submitting form data, uploading a file, or sending a request body in restful services.
3. **PUT:** This method replaces all current representations of the target resource with the request payload. That means it is used to update all the properties of the target resource.
4. **PATCH:** This HTTP Method is used to update the target resource partially. If you want to update a few properties of the target resource, you need to use the PATCH method instead of the PUT method.
5. **DELETE:** Removes the specified resource.
6. **HEAD:** This is similar to the GET method but asks for the response without the response body. It is used to obtain metadata about the resource, such as the size of the response body, HTTP headers, etc.
7. **OPTIONS:** Describe the communication options for the target resource, i.e., it describes what HTTP methods are supported by the server, what HTTP headers are allowed by the server, etc.

##### **Safe HTTP Methods**
- **GET:** Retrieves data from the server. Multiple GET requests to the same resource are expected to return the same result unless the resource’s state has been changed by other means.
- **HEAD:** Similar to GET, but it only requests the headers of the response. Like GET, HEAD does not modify the server state and is used to obtain meta-information about the resource, such as its size or headers, without downloading its body.
- **OPTIONS:** Used to describe communication options for the target resource, such as which methods are supported and which headers are accepted by the server**.** It does not modify the server state and is safe to call.
##### **Unsafe HTTP Methods**

- **POST:** Used to submit data to the server to create a new resource. So, it can change the state of the server by adding a new resource.
- **PUT:** It replaces all current representations of the target resource with the request payload. It is used to update a resource on the server.
- **DELETE:** It removes the specified resource from the server, changing the state of the server by removing the resource.
- **PATCH:** This is the same as the PUT method, but here it will perform partial updates to a resource. PATCH is considered unsafe because it changes the state of the resource.


##### **HttpGet**

- **Purpose**: Retrieve information about a resource or a collection of resources.
- **Use Case:** Fetching data from the server. It can be a single item by ID or a list of items. It should not change the state of the server.
- **Example:** Retrieving a list of users or a single user by ID.

##### **HttpPost**

- **Purpose:** Create a new resource on the server.
- **Use Case:** Submitting data to be processed by the server. For example, creating a new record in the database.
- **Example:** Adding a new user to a database.

##### **HttpPut**

- **Purpose:** Update an existing resource completely. If the resource does not exist, it can create a new resource with a specific ID, depending on the server’s implementation.
- **Use Case:** Updating an existing entity with new data. This method replaces the entire entity with the provided version.
- **Example:** Updating a user’s information entirely.

##### **HttpPatch**

- **Purpose:** Partially update an existing resource. It allows sending only the changes rather than the entire resource.
- **Use Case:** Applying partial modifications to a resource, such as updating a user’s email without altering other attributes.
- **Example:** Changing a user’s email address.

##### **HttpDelete**

- **Purpose:** Remove a resource from the server.
- **Use Case:** Deleting a resource. It should be used to remove an entity from the server.
- **Example:** Deleting a user from the database.

##### **HttpOptions**

- **Purpose:** Clients can use the OPTIONS method to determine which HTTP methods the server supports. This can be useful in RESTful APIs for supporting cross-origin resource sharing (CORS) preflight requests.
- **Use Case:** Discover the communication options available for a specific URL or server. Determining which operations (HTTP methods) are supported on a server endpoint.
- **Example:** Checking if an endpoint supports PUT requests.

##### **HttpHead**

- **Purpose:** It retrieves the headers of a resource, which are identical to those of a GET request but without the response body.
- **Use Case:** A common use case for the HEAD method is to inspect the content length of a document without downloading it. For example, a client application can use this method to determine if a large file has changed before downloading it, which can save bandwidth and processing time if the file is unchanged. Another example is
- **Example:** Checking if a resource exists before downloading it. Retrieving metadata about the resource, such as content type or content length.

```c#
namespace HTTPMethodDemo.Models
{
    public class Product
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int Price { get; set; }
    }
}
```
 create an API Controller Empty named ProductController and then copy and paste the following code. Here, I am implementing 8 action methods using 7 HTTP methods.
```C#
using HTTPMethodDemo.Models;
using Microsoft.AspNetCore.Mvc;

namespace HTTPMethodDemo.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProductController : ControllerBase
    {
        private List<Product> products = new List<Product>()
        {
            new Product(){Id = 1, Name ="Laptop", Price = 1000},
            new Product(){Id = 2, Name ="Desktop", Price = 2000}
        };

        // GET requests are used to request data from a specified resource.
        // They should not change the state of the server.
        // GET: api/Product
        [HttpGet]
        public async Task<ActionResult<List<Product>>> GetAllProducts()
        {
            //Fetch all the Products
            return Ok(products);
        }

        // GET: api/Product/1
        [HttpGet("{Id}")]
        public async Task<ActionResult<Product>> GetProductById(int Id)
        {
            var product = products.FirstOrDefault(prd => prd.Id == Id);
            if (product == null)
            {
                return NotFound();
            }

            return Ok(product);
        }

        // POST requests are used to send data to the server to create a new resource.
        // The data is included in the body of the request.
        // POST: api/Items
        [HttpPost]
        public async Task<ActionResult<Product>> CreateProduct(Product product)
        {
            //Add the Product to the Database
            product.Id = 3;
            products.Add(product);

            return CreatedAtAction("GetProductById", new { Id = product.Id }, product);
        }

        // PUT requests are used to send data to a specific resource for update.
        // Unlike POST, PUT is idempotent, meaning multiple identical requests should have the same effect as a single one.
        // PUT: api/Product/1
        [HttpPut("{Id}")]
        public async Task<IActionResult> UpdateProduct(int Id, Product product)
        {
            if (Id != product.Id)
            {
                return BadRequest();
            }

            var existingProduct = products.FirstOrDefault(prd => prd.Id == Id);
            if (existingProduct == null)
            {
                return NotFound();
            }

            //Update the Product Name and Price
            existingProduct.Name = product.Name;
            existingProduct.Price = product.Price;

            //Update the Data into the database

            return NoContent();
        }

        // DELETE requests are used to remove a specific resource identified by a URI.
        // DELETE: api/Product/5
        [HttpDelete("{Id}")]
        public async Task<IActionResult> DeleteProduct(int Id)
        {
            var product = products.FirstOrDefault(prd => prd.Id == Id);
            if (product == null)
            {
                return NotFound();
            }

            //Remove the Product
            products.Remove(product);

            return NoContent();
        }

        // PATCH requests are used for making partial updates to an existing resource.
        // This method allows sending a partial list of changes to the resource, reducing bandwidth and processing time.
        // PATCH: api/Product/5
        [HttpPatch("{Id}")]
        public async Task<IActionResult> PatchProduct(int Id, Product product)
        {
            var existingProduct = products.FirstOrDefault(prd => prd.Id == Id);
            if (existingProduct == null)
            {
                return NotFound();
            }

            //Update only the require Properties, not all
            existingProduct.Name = product.Name;

            //Update the data into the database

            return NoContent();
        }

        // Ensure the HEAD method shares the same routing as the GET method for a resource.
        // HEAD: api/Product/5
        [HttpHead("{Id}")]
        public ActionResult<Product> GetProductHead(int Id)
        {
            var product = products.FirstOrDefault(prd => prd.Id == Id);
            if (product == null)
            {
                return NotFound();
            }
            
            return NoContent(); 
            // Or Ok() with no body content
        }

        // For OPTIONS requests, it's common to return an empty body with a 200 OK status code, with the Allow header specifying the allowed methods.
        // OPTIONS: api/Product
        [HttpOptions]
        public IActionResult Options()
        {
            Response.Headers.Add("Allow", "GET,POST,PUT,PATCH,DELETE,HEAD,OPTIONS");
            return Ok();
        }
    }
}
```

##### **Best Practices to Use HTTP Methods in ASP.NET Core Web API**

- Use GET for safe actions that do not alter the state of the resource.
- Use POST to create new resources.
- Use PUT when the client determines the URI of the newly created or updated resource.
- Use PATCH for partial updates to a resource when not all attributes need to be specified.
- Use DELETE to remove resources from the server.
- Use OPTIONS to check which HTTP methods the server allows.
- Use HEAD to retrieve the headers of a resource, which are identical to those of a GET request but without the response body.

