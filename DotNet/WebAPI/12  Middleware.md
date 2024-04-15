
##### **HTTP Request Pipeline:**

![[word-image-238.webp]]

But in reality, before hitting the controller action method, the request has to pass through a pipeline. Once the pipeline is completed, then only it navigates the request to the corresponding controller action method as shown in the below image.

![[word-image-239.webp]]

![[word-image-240-768x393.webp]]

##### **Middleware in ASP.NET Core Web API:**

Middleware is a piece of code that is used in the HTTP Request Pipeline. An ASP.NET Core Web API Application can have n numbers of middleware. So, depending upon the requirement, we can configure n numbers of middleware in the application request processing pipeline.

The order of middleware matters a lot in the execution. That means in the order they are configured into the request processing pipeline; in the same order, they are going to be executed when a request comes. Each middleware in the ASP.NET Core Web API Application performs the following tasks.

1. Chooses whether to pass the HTTP Request to the next component in the pipeline. This can be achieved by calling the ==`next ()`== method within the middleware.
2. Can perform work before and after the next component in the pipeline.

ASP.NET Core provides some built-in middleware that is ready to be used, even if you want then you can also create your own custom middleware. The most important point that you need to keep in mind is, in ASP.NET Core a given Middleware component should only have a specific purpose i.e. single responsibility.


##### **Middleware Examples:**

1. **Routing**: If you want to implement Routing in your application, then you need to use Routing Middleware in the HTTP Request Processing pipeline.
2. **Authentication**: If you want to authenticate the user then you need to use Authentication Middleware.
3. **Authorize**: The Authorize Middleware is used to Authorize the users while accessing a specific resource.
4. **Log**: If you want to log request and response while processing, then you need Middleware.
5. **Exception Middleware:** You can also use Middleware to handle the exception globally.

**Note**: The Middleware in ASP.NET Core Web API Application is used to set up the HTTP Request processing pipeline. If you have prior experience of the previous .NET Framework then you may know, HTTP Handlers and HTTP Modules which are basically used to set up the request processing pipeline. It is this pipeline that will determine how the HTTP request and response are going to be processed

##### **How to Configure Middleware Components in ASP.NET Core application?**

![[word-image-241.webp]]
1. **UseDeveloperExceptionPage() Middleware:** The UseDeveloperExceptionPage() middleware will come into picture only when the hosting environment is set to “development”. The UseDeveloperExceptionPage middleware is going to execute when there is an unhandled exception that occurred in the application and since it is in development mode, it is going to show you the detailed information of the exception.
2. **UseRouting() Middleware:** The UseRouting middleware is used to add Endpoint Routing Middleware to the request processing pipeline i.e. it will map the URL (or incoming HTTP Request) to a particular resource.
3. **UseEndpoints() Middleware:** In this middleware, the routing decisions are going to be taken using the Map extension method.
##### **Run, Use, Next, and Map Methods in Middleware:**

In order to work with ASP.NET Core Middleware Components, we need to learn about few methods are as follows:

1. **Run() Method:** The [**Run() Extension Method**](https://dotnettutorials.net/lesson/run-method-in-asp-net-core/) is used to complete the Middleware Execution.
2. **Use() Method:** The Use() Extension Method is used to insert a new Middleware component to the Request Processing Pipeline.
3. **Next() Method:** The Next() Extension Method is used to call the next middleware component in the request processing pipeline.
4. **Map() Method:** The Map() Extension Method is used to map the Middleware to a specific URL.
# Run, Use, and Next Method in ASP.NET Core


![[word-image-305.webp]]

##### **Modifying the Configure Method of Startup class:**

![[word-image-311.webp]]

**Modify the Configure method of the Program class as shown below.**
```c#
public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
{
    app.Run(async context => {
        await context.Response.WriteAsync("Response from Run Middleware");
    });

    if (env.IsDevelopment())
    {
        app.UseDeveloperExceptionPage();
    }

    app.UseRouting();

    app.UseEndpoints(endpoints =>
    {
        endpoints.MapControllers();
    });
}
```


Middleware 

```C#
public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
{
    app.Run(async context => {
        await context.Response.WriteAsync("Response from First Run Middleware");
    });

    app.Run(async context => {
        await context.Response.WriteAsync("Response from Second Run Middleware");
    });

    if (env.IsDevelopment())
    {
        app.UseDeveloperExceptionPage();
    }

    app.UseRouting();

    app.UseEndpoints(endpoints =>
    {
        endpoints.MapControllers();
    });
}
```

##### **Use() and Next() Extension Methods In ASP.NET Core**
##### **Use Method:**
![[word-image-293-768x215.webp]]
![[word-image-294 1.webp]]

```C#
public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
{
    app.Use(async (context, next) =>
    {
        await context.Response.WriteAsync("Getting Response from 1st Middleware \n");
    });

    app.Run(async context => {
        await context.Response.WriteAsync("Response Response from second Middleware \n");
    });
}
```

##### **Example to understand Next Extension Method in ASP.NET Core**

![[word-image-296.webp]]

```C#
public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
{
    app.Use(async (context, next) =>
    {
        await context.Response.WriteAsync("Getting Response from 1st Middleware \n");
        await next();
    });

    app.Run(async context => {
        await context.Response.WriteAsync("Response Response from second Middleware \n");
    });
}
```

##### **Understanding Execution Order of Middleware in ASP.NET Core**

```C#
public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
{
    app.Use(async (context, next) =>
    {
        await context.Response.WriteAsync("Use Middleware1 Incoming Request \n");
        await next();
        await context.Response.WriteAsync("Use Middleware1 Outgoing Response \n");
    });

    app.Use(async (context, next) =>
    {
        await context.Response.WriteAsync("Use Middleware2 Incoming Request \n");
        await next();
        await context.Response.WriteAsync("Use Middleware2 Outgoing Response \n");
    });

    app.Run(async context => {
        await context.Response.WriteAsync("Run Middleware3 Request Handled and Response Generated\n");
    });
}
```

##### **Understanding ASP.NET Core Request Processing Pipeline Execution Order:**

![[word-image-299.webp]]


# Custom Middleware in ASP.NET Core

##### **Creating Custom Middleware in ASP.NET Core**

```c#
using Microsoft.AspNetCore.Http;
using System.Threading.Tasks;
namespace MiddlewareInASPNETCore
{
    public class MyCustomMiddleware1 : IMiddleware
    {
        public async Task InvokeAsync(HttpContext context, RequestDelegate next)
        {
            await context.Response.WriteAsync("Custom Middleware Incoming Request \n");
            await next(context);
            await context.Response.WriteAsync("Custom Middleware Outgoing Response \n");
        }
    }
}
```

**Note:** While calling the next method from any custom middleware components, we need to pass the context object and that you can see in the above code.

##### **Step1: Inject the service to the built-in dependency injection container**
Program.cs
```
services.AddTransient<MyCustomMiddleware1>()
```

```C#
public void ConfigureServices(IServiceCollection services)
{
    services.AddControllers();
    services.AddTransient<MyCustomMiddleware1>();
}
```

##### **Step2: Registering the Custom Middleware in the HTTP Request Processing Pipeline**

```C#
public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
{
    app.Use(async (context, next) =>
    {
        await context.Response.WriteAsync("Use Middleware Incoming Request \n");
        await next();
        await context.Response.WriteAsync("Use Middleware Outgoing Response \n");
    });

    app.UseMiddleware<MyCustomMiddleware1>();

    app.Run(async context => {
        await context.Response.WriteAsync("Run Middleware Component\n");
    });
}
```

