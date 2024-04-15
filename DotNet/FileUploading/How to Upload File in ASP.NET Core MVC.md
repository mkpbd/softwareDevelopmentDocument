
ASP.NET Core MVC provides multiple ways to upload, process, and save files. It supports uploading single and multiple files. ASP.NET core MVC provides two general ways to upload files.

- **Buffering**
- **Streaming**
##### **Buffering in File Uploading:**

Buffering refers to the process of reading an entire file **into memory** before being processed or uploaded. In ASP.NET Core, buffering can be achieved using the **IFormFile** interface when handling file uploads

##### **Streaming in File Uploading:**

Streaming, in contrast, involves reading and processing a file in chunks as the data arrives. This can be done in ASP.NET Core using asynchronous streaming APIs.


```C#
@{
    ViewData["Title"] = "File Upload Page";
}

<h2>Single File Upload</h2>
<hr />
<div class="row">
    <div class="col-md-12">
        <form method="post" asp-controller="FileUpload" asp-action="SingleFileUpload"
              enctype="multipart/form-data">
            <div asp-validation-summary="All" class="text-danger"></div>
            <input type="file" name="SingleFile" class="form-control" />
            <button type="submit" name="Upload" class="btn btn-primary">Upload</button>
        </form>
    </div>
</div>
```

1. Here, the form control has **method = post**, **asp-controller=” FileUpload”** **asp-action=”SingleFileUpload**” attributes. The SingleFileUpload action method in the FileUpload controller will be executed upon submission of the form.
2. The name attribute of the file type input is **SingleFile**
##### **Handling the File Upload in the Controller:**

```C#
using Microsoft.AspNetCore.Mvc;

namespace FileUploadInMVC.Controllers
{
    public class FileUploadController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public async Task<IActionResult> SingleFileUpload(IFormFile SingleFile)
        {
            if (ModelState.IsValid)
            {
                if (SingleFile != null && SingleFile.Length > 0)
                {
                    var filePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot/uploads", SingleFile.FileName);

                    //Using Buffering
                    using (var stream = System.IO.File.Create(filePath))
                    {
                        // The file is saved in a buffer before being processed
                        await SingleFile.CopyToAsync(stream);
                    }

                    //Using Streaming
                    //using (var stream = new FileStream(filePath, FileMode.Create, FileAccess.Write))
                    //{
                    //    await SingleFile.CopyToAsync(stream);
                    //}

                    // Process the file here (e.g., save to the database, storage, etc.)
                    return View("UploadSuccess");
                }
            }

            return View("Index");
        }
    }
}
```

![[word-image-41759-6-1.webp]]

##### **IFormFile Interface:**

IFormFile is a C# representation of the file used to process or save the file. The IFormFile represents a file sent with the HTTP Request. Use this approach to upload files of relatively smaller sizes

![[word-image-41759-1.webp]]

##### **Properties of IFormFile Interface:**

1. **ContentType { get; }:** Gets the raw Content-Type header of the uploaded file.
2. **ContentDisposition { get; }:** Gets the raw Content-Disposition header of the uploaded file.
3. **Headers { get; }:** Gets the header dictionary of the uploaded file.
4. **Length { get; }:** Gets the file length in bytes.
5. **Name { get; }:** Gets the form field name from the Content-Disposition header.
6. **FileName { get; }:** Gets the file name from the Content-Disposition header.

##### **Methods of IFormFile Interface:**

1. **CopyTo(Stream target):** Copies the uploaded file’s contents to the target stream. Here, the parameter target specifies the stream to copy the file contents.
2. **CopyToAsync(Stream target, CancellationToken cancellationToken = default):** Asynchronously copies the uploaded file’s contents to the target stream. Here, the parameter target specifies the stream to copy the file contents.
3. **OpenReadStream():** Opens the request stream for reading the uploaded file.
![[word-image-41759-7-1.webp]]


## **How to Restrict Uploaded File Size in ASP.NET Core MVC:**

##### **Using the [RequestSizeLimit] Attribute**

```C#
[HttpPost]
[RequestSizeLimit(1000000)] // Limit to 1 MB
public async Task<IActionResult> SingleFileUpload(IFormFile SingleFile)
{
    if (ModelState.IsValid)
    {
        if (SingleFile != null && SingleFile.Length > 0)
        {
            var filePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot/uploads", SingleFile.FileName);

            //Using Buffering
            //using (var stream = System.IO.File.Create(filePath))
            //{
            //    // The file is saved in a buffer before being processed
            //    await SingleFile.CopyToAsync(stream);
            //}

            //Using Streaming
            using (var stream = new FileStream(filePath, FileMode.Create, FileAccess.Write))
            {
                await SingleFile.CopyToAsync(stream);
            }

            // Process the file here (e.g., save to the database, storage, etc.)
            return View("UploadSuccess");
        }
    }

    return View("Index");
}
```

## **How to Restrict Uploaded File Type in ASP.NET Core MVC**

##### **Validating File Extension and MIME Type in the Controller:**
```C#
[HttpPost]
// [RequestSizeLimit(10000000)] // Limit to 10 MB
public async Task<IActionResult> SingleFileUpload(IFormFile SingleFile)
{
    if (SingleFile == null || SingleFile.Length == 0)
    {
        ModelState.AddModelError("", "File not selected");
        return View("Index");
    }

    var permittedExtensions = new[] { ".jpg", ".png", ".gif" };
    var extension = Path.GetExtension(SingleFile.FileName).ToLowerInvariant();

    if (string.IsNullOrEmpty(extension) || !permittedExtensions.Contains(extension))
    {
        ModelState.AddModelError("", "Invalid file type.");
    }

    // Optional: Validate MIME type as well
    var mimeType = SingleFile.ContentType;
    var permittedMimeTypes = new[] { "image/jpeg", "image/png", "image/gif" };
    if (!permittedMimeTypes.Contains(mimeType))
    {
        ModelState.AddModelError("", "Invalid MIME type.");
    }

    //Validating the File Size
    if (SingleFile.Length > 10000000) // Limit to 10 MB
    {
        ModelState.AddModelError("", "The file is too large.");
    }

    if (ModelState.IsValid)
    {
        var filePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot/uploads", SingleFile.FileName);

        //Using Buffering
        //using (var stream = System.IO.File.Create(filePath))
        //{
        //    // The file is saved in a buffer before being processed
        //    await SingleFile.CopyToAsync(stream);
        //}

        //Using Streaming
        using (var stream = new FileStream(filePath, FileMode.Create, FileAccess.Write))
        {
            await SingleFile.CopyToAsync(stream);
        }

        // Process the file here (e.g., save to the database, storage, etc.)
        return View("UploadSuccess");
    }

    return View("Index");
}
```

##### **Client-Side Validation (Optional but Recommended):**

```c#
@{
    ViewData["Title"] = "File Upload Page";
}

<h2>Single File Upload</h2>
<hr />
<div class="row">
    <div class="col-md-12">
        <form method="post" asp-controller="FileUpload" asp-action="SingleFileUpload"
              enctype="multipart/form-data">
            <div asp-validation-summary="All" class="text-danger"></div>
            <input type="file" name="SingleFile" accept=".jpg,.png,.gif" class="form-control" />
            <button type="submit" name="Upload" class="btn btn-primary">Upload</button>
        </form>
    </div>
</div>
```

# How to Save Uploaded file to Database in ASP.NET Core MVC

##### **Create a Model for the File**

```C#
namespace FileUploadInMVC.Models
{
    public class FileModel
    {
        public int Id { get; set; }
        public string FileName { get; set; }
        public byte[] Data { get; set; }
        public long Length { get; set; }
        public string ContentType { get; set; }
        // Other properties as per your requirements
    }
}
```

##### **Set Up the Database Context**

```C#
using Microsoft.EntityFrameworkCore;

namespace FileUploadInMVC.Models
{
    public class EFCoreDbContext : DbContext
    {
        public EFCoreDbContext() : base()
        {
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            //Configuring the Connection String
            optionsBuilder.UseSqlServer(@"Server=LAPTOP-6P5NK25R\SQLSERVER2022DEV;Database=FileHandlingDB;Trusted_Connection=True;TrustServerCertificate=True;");
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
        }

        //Adding Domain Classes as DbSet Properties
        public DbSet<FileModel> Files { get; set; }
    }
}
```
![[word-image-46324-1-768x314.webp]]


##### **Modifying the FileUpload Controller:**
```C#
using FileUploadInMVC.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.IO;
using System.Linq;

namespace FileUploadInMVC.Controllers
{
    public class FileUploadController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }

        [HttpPost]
        [RequestSizeLimit(10000000)] // Limit to 10 MB
        public async Task<IActionResult> SingleFileUpload(IFormFile SingleFile)
        {
            if (SingleFile == null || SingleFile.Length == 0)
            {
                ModelState.AddModelError("", "File not selected");
                return View("Index");
            }

            var permittedExtensions = new[] { ".jpg", ".png", ".gif" };
            var extension = Path.GetExtension(SingleFile.FileName).ToLowerInvariant();

            if (string.IsNullOrEmpty(extension) || !permittedExtensions.Contains(extension))
            {
                ModelState.AddModelError("", "Invalid file type.");
            }

            // Optional: Validate MIME type as well
            var mimeType = SingleFile.ContentType;
            var permittedMimeTypes = new[] { "image/jpeg", "image/png", "image/gif" };
            if (!permittedMimeTypes.Contains(mimeType))
            {
                ModelState.AddModelError("", "Invalid MIME type.");
            }

            if (ModelState.IsValid)
            {
                //Creating a unique File Name
                var uniqueFileName = Guid.NewGuid().ToString() + Path.GetExtension(SingleFile.FileName);

                var filePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot/uploads", uniqueFileName);

                //Using Buffering
                //using (var stream = System.IO.File.Create(filePath))
                //{
                //    // The file is saved in a buffer before being processed
                //    await SingleFile.CopyToAsync(stream);
                //}

                //Using Streaming
                using (var stream = new FileStream(filePath, FileMode.Create, FileAccess.Write))
                {
                    //This will save to Local folder
                    await SingleFile.CopyToAsync(stream);
                }

                // Create an instance of FileModel
                var fileModel = new FileModel
                {
                    FileName = uniqueFileName,
                    Length = SingleFile.Length,
                    ContentType = mimeType,
                    Data = ConvertToByteArray(filePath)
                };

                // Save to database
                EFCoreDbContext _context = new EFCoreDbContext();
                _context.Files.Add(fileModel);
                await _context.SaveChangesAsync();

                // Process the file here (e.g., save to the database, storage, etc.)
                return View("UploadSuccess");
            }

            return View("Index");
        }

        //This method will convert the uploaded file into byte array
        private byte[] ConvertToByteArray(string filePath)
        {
            byte[] fileData;

            //Create a File Stream Object to read the data
            using (FileStream fs = new FileStream(filePath, FileMode.Open, FileAccess.Read))
            {
                using (BinaryReader reader = new BinaryReader(fs))
                {
                    fileData = reader.ReadBytes((int)fs.Length);
                }
            }

            return fileData;
        }
    }
}
```

```C#
public async Task<IActionResult> ShowImages()
{
    EFCoreDbContext _context = new EFCoreDbContext();
    // Assuming 'Files' is your DbSet of images
    var images = await _context.Files.ToListAsync();
    return View(images);
}
```

##### **Create an Action Method to Serve Images**

```C#
public async Task<IActionResult> GetImage(int id)
{
    EFCoreDbContext _context = new EFCoreDbContext();
    var image = await _context.Files.FirstOrDefaultAsync(f => f.Id == id);

    if (image == null)
    {
        return NotFound();
    }

    // Assuming ContentType is stored in your model
    return File(image.Data, image.ContentType);
}
```

##### **Display Images in the View**

```C#
@model IEnumerable<FileModel>
@{
    ViewData["Title"] = "ShowImages";
}

<h1>Uploaded Images</h1>

<div class="row">
    <div class="col-md-4">
        @foreach (var image in Model)
        {
            <img src="@Url.Action("GetImage", new { id = image.Id })" width="200" height="200" alt="Image Not Availanle" class="img-fluid" />
        }
    </div>
</div>
```

## **How to Delete Images in ASP.NET Core MVC**

```C#
[HttpPost]
public async Task<IActionResult> DeleteImage(int id)
{
    //First check whether Id exists in the database
    EFCoreDbContext _context = new EFCoreDbContext();
    var image = await _context.Files.FirstOrDefaultAsync(f => f.Id == id);
    if (image == null)
    {
        // Handle the case where the image is not found
        return NotFound();
    }

    // Delete the file from the file system
    var filePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot/uploads", image.FileName);
    if (System.IO.File.Exists(filePath))
    {
        System.IO.File.Delete(filePath);
    }

    // Delete the record from the database
    _context.Files.Remove(image);
    await _context.SaveChangesAsync();

    return RedirectToAction("ShowImages"); // Redirect to the list of images page
}
```


```C#
@model IEnumerable<FileModel>
@{
    ViewData["Title"] = "ShowImages";
}

<h1>Uploaded Images</h1>

<div class="row">
    <div class="col-md-4">
        @foreach (var image in Model)
        {
            <img src="@Url.Action("GetImage", new { id = image.Id })" width="200" height="200" alt="Image Not Availanle" class="img-fluid" />
            <form method="post" asp-action="DeleteImage" asp-controller="FileUpload" asp-route-id="@image.Id">
                <input type="hidden" name="id" value="@image.Id" />
                <button type="submit" class="text-danger">Delete</button>
            </form>
        }
    </div>
</div>
```

