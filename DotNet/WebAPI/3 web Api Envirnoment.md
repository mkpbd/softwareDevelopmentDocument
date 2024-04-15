##### **Download and Install .NET Core SDK 8 (LTS)**
[**https://dotnet.microsoft.com/en-us/download/dotnet/8.0**](https://dotnet.microsoft.com/en-us/download/dotnet/8.0)

![[word-image-43851-1 1.webp]]

##### **Installing .NET Core SDK:**
![[word-image-43851-2 1.webp]]

##### **Verify Installation of .NET Core SDK.**
![[DotNet/WebAPI/apiImages/word-image-43851-4.webp]]
![[DotNet/WebAPI/apiImages/word-image-43851-5.webp]]
##### **Integrated Development Environment (IDE) for ASP.NET Core Web API Development:**
You can use any of the following IDEs to develop the ASP.NET Core Web API Applications.

1. **Visual Studio 2022**
2. **Visual Studio Code**
3. **.Net Core CLI**
##### **Download Visual Studio 2022:**
[**https://visualstudio.microsoft.com/downloads/**](https://visualstudio.microsoft.com/downloads/)
[**https://dotnettutorials.net/lesson/how-to-download-and-install-visual-studio-in-windows/**](https://dotnettutorials.net/lesson/how-to-download-and-install-visual-studio-in-windows/)


![[Download-Visual-Studio-2022-Community-Edition.webp]]
![[Visual-Studio-Installer.webp]]
![[Integrated-Development-Environment-IDE-for-ASP.NET-Core-Web-API-Development.webp]]

##### **Install SQL Server 2022:**
**[https://www.microsoft.com/en-ie/sql-server/sql-server-downloads](https://www.microsoft.com/en-ie/sql-server/sql-server-downloads)**

![[word-image-11.webp]]

##### **Download and Install SQL Server Management Studio:**
**[https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms)**
![[word-image-12.webp]]
##### **Install Postman:**
**[https://www.postman.com/downloads/](https://www.postman.com/downloads/)**
![[word-image-13.webp]]


## **Creating ASP.NET Core Web API Project in Visual Studio**

![[word-image-43851-1-1 1.webp]]
![[word-image-43851-2-1 1.webp]]

![[word-image-43851-3-1 1.webp]]
![[word-image-43851-4-1 1.webp]]

![[word-image-43851-5-1 1.webp]]

##### **How do you Build the ASP.NET Core Web API Project in Visual Studio?**
![[word-image-43851-6 1.webp]]

##### **How do you run the ASP.NET Core Web API Application in Visual Studio?**

You can run the application in Visual Studio using the HTTP, HTTPS, WSL, and IIS Express options, as shown in the below image. So, from the launch profile, select the https option and click on the https button, as shown in the image below.
![[DotNet/WebAPI/apiImages/word-image-43851-8.webp]]

##### **Differences Between HTTP, HTTPS, WSL, and IIS Express in Visual Studio**

###### **HTTP (Hypertext Transfer Protocol):**

- HTTP is a protocol used for transmitting data over the internet, primarily for webpages.
- It operates at the application layer and facilitates data transfer between web servers and clients (browsers).
- HTTP does not encrypt the data, which makes it less secure. Third parties can intercept sensitive data.

###### **HTTPS (HTTP Secure):**

- HTTPS is the secure version of HTTP. It employs SSL/TLS encryption to secure the data transfer.
- This encryption ensures that the data exchanged between the server and the client is encrypted and secure from interception or tampering.
- For web applications, especially those handling sensitive data like login credentials and payment information, HTTPS is a must to ensure data security and integrity.

###### **WSL (Windows Subsystem for Linux):**

- WSL is a feature in Windows that allows users to run a Linux environment directly on Windows without needing a virtual machine or dual-boot setup.
- It is useful for developers who need to run Linux-based applications, tools, or development environments on a Windows machine.
- In the context of .NET development, WSL allows developers to test and run .NET applications in a Linux environment while using Windows as their primary OS.

###### **IIS Express:**

- IIS Express is a lightweight, self-contained version of IIS (Internet Information Services) optimized for developers.
- It is used within Visual Studio for developing and testing web applications locally.
- IIS Express supports both HTTP and HTTPS and is designed to make it easy to develop and test web applications without requiring administrative privileges or a full IIS installation.

Once you click on the https button, the application will run, and you will get the following swagger page in the browser. Please have a look at the Port number (7237) on which the application is running. The port number might be different on your machine.

![[word-image-43851-9.webp]]
![[DotNet/WebAPI/apiImages/word-image-43851-10.webp]]
## **Default ASP.NET Core Web API Files and Folders**

![[word-image-43851-1-2.webp]]

##### **Dependencies:**

![[word-image-43851-2-2.webp]]


#### **Properties:**

By default, the Properties Folder in the ASP.NET Core Web API Application contains one JSON file called launchsettings.json file. This launchsettings.json file contains configuration settings for launching the application, such as environment variables and application URLs that will be used by .NET Core Framework when we run the application either from Visual Studio or by using .NET Core CLI. Another point you need to remember is that the launchSettings.json file is only used within the local development machine. So, this file will not be required when we publish our ASP.NET Core Web API application on the production server. Now, open the launchSettings.json file; by default, you will see the following settings.

launchsettings.json
```json
{
  "profiles": {
    "http": {
      "commandName": "Project",
      "launchBrowser": true,
      "launchUrl": "swagger",
      "environmentVariables": {
        "ASPNETCORE_ENVIRONMENT": "Development"
      },
      "dotnetRunMessages": true,
      "applicationUrl": "http://localhost:5222"
    },
    "https": {
      "commandName": "Project",
      "launchBrowser": true,
      "launchUrl": "swagger",
      "environmentVariables": {
        "ASPNETCORE_ENVIRONMENT": "Development"
      },
      "dotnetRunMessages": true,
      "applicationUrl": "https://localhost:7237;http://localhost:5222"
    },
    "IIS Express": {
      "commandName": "IISExpress",
      "launchBrowser": true,
      "launchUrl": "swagger",
      "environmentVariables": {
        "ASPNETCORE_ENVIRONMENT": "Development"
      }
    },
    "WSL": {
      "commandName": "WSL2",
      "launchBrowser": true,
      "launchUrl": "https://localhost:7237/swagger",
      "environmentVariables": {
        "ASPNETCORE_ENVIRONMENT": "Development",
        "ASPNETCORE_URLS": "https://localhost:7237;http://localhost:5222"
      },
      "distributionName": ""
    }
  },
  "$schema": "http://json.schemastore.org/launchsettings.json",
  "iisSettings": {
    "windowsAuthentication": false,
    "anonymousAuthentication": true,
    "iisExpress": {
      "applicationUrl": "http://localhost:1064",
      "sslPort": 44312
    }
  }
}

```

##### **HTTP Profile:**

These settings determine the URLs and ports on which your application will listen for incoming HTTP requests. By default, you will get the following settings in the launchsettings.json file for HTTP Profile:

![[word-image-43851-3-2.webp]]
##### **HTTPS Profile:**

These settings determine the URLs and ports on which your application will listen for incoming HTTPS requests. The HTTPS setting usually includes an SSL certificate for secure communication. ASP.NET Core supports automatically generating a development-time SSL certificate for this purpose. By default, you will get the following settings in the launchsettings.json file for HTTPS Profile:

![[word-image-43851-4-2 1.webp]]
##### **WSL Profile:**

If you are developing on Windows but targeting a Linux environment, you need to use WSL. The WSL profile in launchSettings.json allows you to run and debug your application in a Linux-like environment. By default, you will get the following settings in the launchsettings.json file for WSL Profile:

![[word-image-43851-5-2.webp]]

##### **IIS Express Profile:**

IIS Express is a lightweight, self-contained version of IIS optimized for development. By default, you will get the following settings in the launchsettings.json file for the IIS Express Profile:
![[word-image-43851-6-1.webp]]
And for IIS Express, it will use the following settings:
![[word-image-43851-7-1.webp]]

###### **applicationUrl:**

- Specifies the URLs on which the application will listen for incoming HTTP/HTTPS requests.
- Example: “applicationUrl”: “https://localhost:7237;http://localhost:5222”
- This means the application will be accessible at http://localhost:5222 and https://localhost:7237.

###### **environmentVariables:**

- Sets environment variables for the application when the profile is used.
- Example: “environmentVariables”: { “ASPNETCORE_ENVIRONMENT”: “Development” }
- This sets the ASPNETCORE_ENVIRONMENT to Development, enabling development-specific features like detailed error pages. Other possible values are Production, Staging

###### **commandName:**

- Indicates the command to execute the application.
- Common values are “Project”, which runs the project directly using Kestrel, or “IISExpress” for launching with IIS Express
- Example: “commandName”: “Project”

###### **launchBrowser:**

- Determines whether a web browser should be automatically opened to the application URL when the application starts.
- Example: “launchBrowser”: true
- When set to true, a browser window will open and navigate to the application URL upon startup.

###### **launchUrl:**

- Specifies the specific URL or endpoint to open in the browser when launchBrowser is set to true.
- Example: “launchUrl”: “swagger”
- This could open the Swagger UI for API documentation if Swagger is configured in the project.

###### **sslPort:**

- If your application supports HTTPS, this setting specifies the SSL port to be used.
- Example: “sslPort”: 44312
- The application will listen for HTTPS requests on this port.

###### **dotnetRunMessages:**

- Determines whether or not to show messages from the dotnet run command.
- Example: “dotnetRunMessages”: “true”

###### **windowsAuthentication:**

- This parameter is used primarily in the context of IIS or IIS Express.
- It’s a boolean value (true or false) indicating whether Windows Authentication is enabled or not.
- When enabled (“windowsAuthentication”: true), the application will use Windows Authentication to authenticate users. This is often used in intranet environments where users are authenticated via their Windows domain accounts.

###### **anonymousAuthentication:**

- Similar to windowsAuthentication, this is also typically used with IIS or IIS Express.
- It’s a boolean value that enables or disables anonymous authentication.
- When enabled (“anonymousAuthentication”: true), users can access the application without any authentication. This is common for public-facing web applications.

###### **ASPNETCORE_URLS:**

- This is an environment variable used to specify the URLs the application should listen on.
- It overrides the applicationUrl setting in launchSettings.json.
- Example: “ASPNETCORE_URLS”: “https://localhost:7237;http://localhost:5222”
- This tells the application to listen for HTTP requests on port 5222 and HTTPS requests on port 7237.

###### **distributionName:**

- This parameter is relevant when using Windows Subsystem for Linux (WSL) as a development environment.
- It specifies the name of the Linux distribution you want to use with WSL.
- Example: “distributionName”: “Ubuntu-20.04”
- This would mean the application will run using Ubuntu 20.04 in WSL.

#### **Controllers Folder:**

```C#
using Microsoft.AspNetCore.Mvc;

namespace MyFirstWebAPIProject.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class WeatherForecastController : ControllerBase
    {
        private static readonly string[] Summaries = new[]
        {
            "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
        };

        private readonly ILogger<WeatherForecastController> _logger;

        public WeatherForecastController(ILogger<WeatherForecastController> logger)
        {
            _logger = logger;
        }

        [HttpGet(Name = "GetWeatherForecast")]
        public IEnumerable<WeatherForecast> Get()
        {
            return Enumerable.Range(1, 5).Select(index => new WeatherForecast
            {
                Date = DateOnly.FromDateTime(DateTime.Now.AddDays(index)),
                TemperatureC = Random.Shared.Next(-20, 55),
                Summary = Summaries[Random.Shared.Next(Summaries.Length)]
            })
            .ToArray();
        }
    }
}

```

#### **appsettings.json file:**

The next file that we are going to discuss is the appsettings.json file. This is the same as the web.config or app.config of our traditional .NET Framework Application. The appsettings.json file is the application configuration file in the ASP.NET Core Web Application used to store the configuration settings for your application, such as database connection strings, API keys, and logging settings.

If you open the appsettings.json file, you will see the following code by default, created by Visual Studio when we created the ASP.NET Core Web API Application.
```json
	{

"Logging": {

"LogLevel": {

"Default": "Information",

"Microsoft.AspNetCore": "Warning"

}

},

"AllowedHosts": "*"

}
```
##### **Structure and Usage**

- **JSON Format:** The appsettings.json file is structured as a JSON object, making it easy to read and edit.
- **Hierarchical Configuration Data:** Settings are often structured hierarchically. For instance, database connection strings, logging settings, or custom application settings can be organized into separate sections or objects.
- **Environment-Specific Files:** In addition to appsettings.json, you can have environment-specific files like appsettings.Development.json, appsettings.Staging.json, or appsettings.Production.json. These files can override settings in appsettings.json based on the environment the application is running in.

#### **MyFirstWebAPIProject.http file**

The .http file, in an ASP.NET Core Web API project, is a feature provided by certain Integrated Development Environments (IDEs) like JetBrains Rider or Visual Studio Code, Visual Studio with the REST Client extension. These files are used to test HTTP requests directly from the IDE. This feature is particularly useful for testing and debugging APIs. You will find the following code in the **MyFirstWebAPIProject.http** file.

```http
@MyFirstWebAPIProject_HostAddress = http://localhost:5222

GET {{MyFirstWebAPIProject_HostAddress}}/weatherforecast/
Accept: application/json

###

```
##### **Structure**

- **HTTP Requests:** The file contains plain HTTP requests, which you can run directly from the IDE.
- **Syntax:** It uses a simple syntax to define HTTP methods, URLs, headers, and body content.
- **Multiple Requests:** You can define multiple requests in a single file, separated by a line of ###.

##### **How to Use?**
First, run the application using the HTTP profile. Please ensure the port number used to launch the application using the HTTP profile and the port number used in the .http file must be the same.

![[word-image-43851-8-1.webp]]

![[word-image-43851-9-1.webp]]

###### **Advantages**

- **Convenience:** Allows you to test API endpoints directly from the IDE without needing an external tool like Postman or Fiddler.
- **Version Control:** This can be checked into source control, allowing team members to share and collaborate on API tests.
- **Documentation:** Serves as a form of documentation of the API endpoints and their usage.

**Note:** As we progress in this course, we will see how to perform GET, POST, PUT, PATCH, and DELETE requests using this .http file to test our APIS.

#### **Program.cs Class File:**

```C#
namespace MyFirstWebAPIProject
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // Add services to the container.

            builder.Services.AddControllers();
            // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
            builder.Services.AddEndpointsApiExplorer();
            builder.Services.AddSwaggerGen();

            var app = builder.Build();

            // Configure the HTTP request pipeline.
            if (app.Environment.IsDevelopment())
            {
                app.UseSwagger();
                app.UseSwaggerUI();
            }

            app.UseHttpsRedirection();

            app.UseAuthorization();


            app.MapControllers();

            app.Run();
        }
    }
}

```

##### **Adding Services to the DI Container:**

Services required by the app, like MVC, Web API, Entity Framework, custom services, etc., are registered with the dependency injection (DI) container. Services are added to the DI container using the **builder.Services.Add…** methods. AddControllers() is typically used for a Web API to add support for controllers and API-related features.

```C#
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

```
**AddEndpointsApiExplorer:** The AddEndpointsApiExplorer() method is used to enable API Explorer services required for generating the OpenAPI specification. This method adds services necessary for discovering endpoint metadata. This metadata is essential for tools like Swagger to generate accurate and useful documentation for your Web API.

**AddSwaggerGen:** The AddSwaggerGen() method adds Swagger generator services to the project. These services are responsible for generating Swagger documents, which describe the structure and capabilities of your Web API. This method allows for customization of the Swagger documentation, such as setting the title and version and even adding custom descriptions and schemas.

##### **Configuring the HTTP Request Pipeline:**

After building the app, you need to configure the HTTP request pipeline by adding middleware components. The **builder.Build()** creates an instance of WebApplication, which is used to set up the middleware pipeline. The **app.Use…** methods are used to add middleware to the application’s request pipeline. This includes error handling, redirection to HTTPS, static file serving, routing, and authorization.

```c#
var app = builder.Build();
// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}
app.UseHttpsRedirection();
app.UseAuthorization();
app.MapControllers();
app.Run();

```

## **How to Install Swagger API in ASP.NET Core Web API**

![[word-image-43851-1-3.webp]]
![[word-image-43851-2-3.webp]]

##### **Method 2: Installing Swagger API using NuGet Package Manager**

![[word-image-43851-5-3.webp]]

![[word-image-43851-6-2.webp]]

##### **Configure Swagger Services:**

To configure Swagger API, we need to add the **AddEndpointsApiExplorer**() and **AddSwaggerGen()** services to the built-in dependency injection container within the Main method of the Program class, as shown in the code below.

```C#
builder.Services.AddEndpointsApiExplorer();

builder.Services.AddSwaggerGen();
```

##### **Enable Swagger Middleware Components:**

```C#
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

```

```C#
namespace SwaggerDemo
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // Add services to the container.
            builder.Services.AddControllers();

            //Registering Swagger API Services
            builder.Services.AddEndpointsApiExplorer();
            builder.Services.AddSwaggerGen();

            var app = builder.Build();

            // Configure the HTTP request pipeline.

            //Registering Swagger Middlware Components
            if(app.Environment.IsDevelopment())
            {
                app.UseSwagger();
                app.UseSwaggerUI();
            }
            
            app.UseHttpsRedirection();
            app.UseAuthorization();
            app.MapControllers();
            app.Run();
        }
    }
}

```

##### **Run the API:**

Now, we need to Build and Run the project. Then, access the Swagger UI by navigating to the URL: **http://localhost:port swagger,** as shown in the below image.

##### **Run the API:**

Now, we need to Build and Run the project. Then, access the Swagger UI by navigating to the URL: **http://localhost: port swagger,** as shown in the below image.
![[word-image-43851-10-1.webp]]

![[word-image-43851-11.webp]]

##### **Testing the API:**

![[word-image-43851-12.webp]]

![[word-image-43851-13.webp]]
![[word-image-43851-14.webp]]
##### **Customizing Swagger in .NET 8**

Customizing Swagger in .NET 8 allows you to customize the Swagger UI and the generated OpenAPI specification to suit your project’s needs better. This can include custom information, such as API descriptions and contact information, licenses, versions, etc.

You can customize the Swagger metadata by configuring the SwaggerGen options in Program.cs. So, modify the AddSwaggerGen service as follows. As you can see here, we have provided more information about our APIs, like the Title, Version, Description, TermsOfService, Contact, and License.

```C#
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("V10", new OpenApiInfo
    {
        Title = "My Custom API",
        Version = "V10",
        Description = "A Brief Description of My APIs",
        TermsOfService = new Uri("https://dotnettutorials.net/privacy-policy/"),
        Contact = new OpenApiContact
        {
            Name = "Support",
            Email = "support@dotnettutorials.net",
            Url = new Uri("https://dotnettutorials.net/contact/")
        },
        License = new OpenApiLicense
        {
            Name = "Use Under XYZ",
            Url = new Uri("https://dotnettutorials.net/about-us/")
        }
    });
});

app.UseSwaggerUI(c =>

{

c.SwaggerEndpoint("/swagger/V10/swagger.json", "My API V10");

});
```
![[word-image-43851-15.webp]]


