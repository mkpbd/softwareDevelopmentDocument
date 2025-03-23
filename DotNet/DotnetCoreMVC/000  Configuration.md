

```C#
// Program.cs
 public static void Main(string[] args)
 {
     // Creating the Web Host and Configuring the Services 
     var builder = WebApplication.CreateBuilder(args);


	// Add MVC services to the service container.

     // For MVC Web Applications:
     builder.Services.AddControllersWithViews();
 // This includes support for controllers and views.
	//builder.Services.AddMvc();

     // Building the Application
     var app = builder.Build();

     // Setting Up Endpoints, Routing, and Middleware Components
     // Configure the HTTP request pipeline.
     if (!app.Environment.IsDevelopment())
     {
     // Developer Exception page 
         app.UseExceptionHandler("/Home/Error");
         // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
         app.UseHsts();
     }

     app.UseHttpsRedirection();
 // Enable routing middleware, which matches incoming HTTP requests to endpoints defined in the application
     app.UseRouting();

     app.UseAuthorization();

     app.MapStaticAssets();
     // Map the default controller route (convention: {controller=Home}/{action=Index}/{id?})

// This means if no specific route is provided, it will default to HomeController and Index action
// app.MapDefaultControllerRoute();
     app.MapControllerRoute(
         name: "default",
         pattern: "{controller=Home}/{action=Index}/{id?}")
         .WithStaticAssets();

     // Running the Application
     app.Run();
 }
```


![[word-image-53295-2-27.webp]]

##### **Controller**
	 AddRazorPages()
##### **Model Binding**
	AddControllers(), AddControllersWithViews(), AddRazorPages(), and AddMvc()
##### **API Explorer**
	AddRazorPages()
	AddControllers(),
##### **Authorization**
	AddControllers(), AddControllersWithViews(), AddRazorPages(), and AddMvc()
##### **CORS (Cross-Origin Resource Sharing)**
	 AddControllers(), AddControllersWithViews(), and AddMvc(), facilitating cross-domain interactions. AddRazorPages()
##### **Validation**
	AddControllers(), AddControllersWithViews(), AddRazorPages(), and AddMvc()

##### **Formatter Mapping**

	 AddControllers(), AddControllersWithViews(), and AddMvc(),AddRazorPages()
##### **Antiforgery**
	AddControllersWithViews(), AddRazorPages(), and AddMvc(),AddControllers()

##### **TempData**
	AddControllersWithViews(), AddRazorPages(), and AddMvc(),
		AddControllers()

##### **Views**
		AddControllersWithViews() and AddMvc(), AddControllers(), AddRazorPages()
##### **Pages**
	 AddRazorPages() and AddMvc(), 
##### **Tag Helpers**
	AddControllersWithViews(), AddRazorPages(), and AddMvc()
##### **Memory Cache**
	AddControllersWithViews(), AddRazorPages(), and AddMvc()


##### **Which Method to Use in Our Application?**

This depends on which type of application you want to create.

**For Web API Applications (RESTful Services):**

- Use: AddControllers()
- Reason: Provides the necessary features for API development without the overhead of views or Razor Pages.

**For MVC Web Applications:**

- Use: AddControllersWithViews()
- Reason: Supports both controllers and views, aligning with the traditional MVC pattern.

**For Razor Pages Applications:**

- Use: AddRazorPages()
- Reason: Designed for page-focused development without the need for controllers or views.

**For Mixed Applications (MVC + Razor Pages):**

- Use: AddMvc()
- Reason: Combines the capabilities of both MVC and Razor Pages, offering maximum flexibility at the cost of including all related features.
