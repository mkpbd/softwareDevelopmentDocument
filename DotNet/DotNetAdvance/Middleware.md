## Dot Net Middleware কী এবং কীভাবে কাজ করে ধাপে ধাপে শিখি।

### মিডলওয়্যার কী? (What is Middleware?)

সহজ ভাষায়, মিডলওয়্যার হলো আপনার ওয়েব অ্যাপ্লিকেশনের জন্য একজন "গেটকিপার" বা "সিকিউরিটি গার্ড"। যখন বাইরে থেকে কোনো ব্যবহারকারী আপনার ওয়েবসাইটে কোনো অনুরোধ (Request) পাঠায়, তখন সেই অনুরোধটি সরাসরি আপনার মূল কোডের কাছে যাওয়ার আগে কয়েকটি ধাপ বা স্তর পার করে যায়। এই প্রতিটি ধাপই হলো একটি মিডলওয়্যার।

**উদাহরণ:**
ধরুন, আপনি একটি অফিসে ঢুকতে চান।
1.  প্রথমে গেটে থাকা গার্ড আপনার পরিচয়পত্র (ID Card) দেখতে চাইবে। (এটা একটা মিডলওয়্যার - **Authentication**)
2.  তারপর তিনি চেক করবেন যে আপনার ওই বিল্ডিংয়ের নির্দিষ্ট ফ্লোরে যাওয়ার অনুমতি আছে কি না। (এটা আরেকটা মিডলওয়্যার - **Authorization**)
3.  ভেতরে ঢোকার পর রিসেপশনিস্ট আপনাকে সঠিক পথে পাঠিয়ে দেবে। (এটাও একটা মিডলওয়্যার - **Routing**)

ডট নেট অ্যাপ্লিকেশনেও ঠিক এভাবেই একটি HTTP Request কয়েকটি মিডলওয়্যারের মধ্য দিয়ে যায় এবং সবশেষে আপনার Controller বা Endpoint-এ পৌঁছায়।

---

### ধাপ ১: মিডলওয়্যার পাইপলাইন (The Middleware Pipeline)

মিডলওয়্যারগুলো একটির পর একটি চেইনের মতো সাজানো থাকে। এই চেইনকেই বলা হয় **"মিডলওয়্যার পাইপলাইন" (Middleware Pipeline)**।

যখন একটি Request আসে:
*   Request টি পাইপলাইনের প্রথম মিডলওয়্যারের কাছে যায়।
*   প্রথম মিডলওয়্যার তার কাজ শেষ করে Request টিকে পরবর্তী মিডলওয়্যারের কাছে পাঠিয়ে দেয় (`next()` ফাংশন ব্যবহার করে)।
*   এভাবে Request টি এক এক করে সবগুলো মিডলওয়্যার পার করে।
*   সবশেষে, যখন Response তৈরি হয়, তখন সেটি আবার উল্টো পথে একই মিডলওয়্যারগুলোর মধ্য দিয়ে ফিরে যায়।



---

### ধাপ ২: মিডলওয়্যার কোথায় লেখা হয়?

.NET 6 বা তার নতুন ভার্সনে, মিডলওয়্যারগুলো `Program.cs` ফাইলে কনফিগার করা হয়। আপনি `app` নামের একটি ভেরিয়েবল দেখতে পাবেন, যেটি `IApplicationBuilder`-এর একটি ইনস্ট্যান্স। এই `app` ভেরিয়েবল ব্যবহার করেই আমরা মিডলওয়্যার add করি।

একটি সাধারণ `Program.cs` ফাইল দেখতে এমন হয়:

```csharp
var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllersWithViews();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

// --- এই অংশেই মিডলওয়্যারগুলো যোগ করা হয় ---
app.UseHttpsRedirection();
app.UseStaticFiles(); // CSS, JavaScript, Image ফাইল দেখানোর জন্য।

app.UseRouting(); // কোন URL কোন Controller-এ যাবে তা ঠিক করার জন্য।

app.UseAuthentication(); // ব্যবহারকারী কে, তা যাচাই করার জন্য।
app.UseAuthorization(); // ব্যবহারকারীর অনুমতি আছে কি না, তা যাচাই করার জন্য।

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
```

**গুরুত্বপূর্ণ বিষয়:** মিডলওয়্যার যোগ করার **ক্রম (Order)** খুবই গুরুত্বপূর্ণ। যেমন, আগে পরিচয় (`UseAuthentication`) যাচাই করতে হবে, তারপর অনুমতি (`UseAuthorization`) চেক করতে হবে। উল্টোটা করলে কাজ করবে না।

---

### ধাপ ৩: কিছু বিল্ট-ইন মিডলওয়্যার (Common Built-in Middlewares)

ডট নেট আমাদের ব্যবহারের জন্য অনেক দরকারি মিডলওয়্যার তৈরি করে রেখেছে। যেমন:

*   **`app.UseStaticFiles()`**: আপনার `wwwroot` ফোল্ডারে থাকা স্ট্যাটিক ফাইল (যেমন: CSS, JavaScript, ছবি) ব্যবহারকারীদের কাছে পৌঁছে দেওয়ার জন্য এই মিডলওয়্যার ব্যবহার করা হয়।
*   **`app.UseRouting()`**: এটি gelen Request-এর URL দেখে ঠিক করে যে কোন Controller বা কোন Razor Page-এ অনুরোধটি যাবে।
*   **`app.UseAuthentication()`**: ব্যবহারকারী লগইন করা কি না বা তার পরিচয় কী, তা যাচাই করে।
*   **`app.UseAuthorization()`**: ব্যবহারকারীর নির্দিষ্ট কোনো পেজ বা ডেটা দেখার অনুমতি আছে কি না, তা যাচাই করে।
*   **`app.UseExceptionHandler()`**: অ্যাপ্লিকেশনে কোনো ত্রুটি (Error) হলে ব্যবহারকারীকে একটি সুন্দর Error পেজ দেখানোর জন্য এটি ব্যবহার হয়।
*   **`app.UseHttpsRedirection()`**: কোনো ব্যবহারকারী `http` দিয়ে সাইট ভিজিট করলে তাকে স্বয়ংক্রিয়ভাবে `https` (নিরাপদ) লিঙ্কে পাঠিয়ে দেয়।

---

### ধাপ ৪: নিজের কাস্টম মিডলওয়্যার তৈরি করা (Creating Custom Middleware)

আপনি চাইলে নিজের প্রয়োজন অনুযায়ী মিডলওয়্যার তৈরি করতে পারেন। এটি দুইভাবে করা যায়।

#### পদ্ধতি ১: `app.Use()` ব্যবহার করে (সহজ উপায়)

এটি সবচেয়ে সহজ পদ্ধতি। `Program.cs` ফাইলেই সরাসরি একটি ছোট মিডলওয়্যার লেখা যায়।

**উদাহরণ:** প্রতিটি Request আসার সময় কনসোলে একটি মেসেজ দেখানোর জন্য একটি মিডলওয়্যার।

`Program.cs` ফাইলে `app.UseRouting()` এর আগে নিচের কোডটি যোগ করুন:

```csharp
// ... আগের কোড

app.Use(async (context, next) =>
{
    // Request যখন মিডলওয়্যারের ভেতরে আসছে
    Console.WriteLine("Request is passing through my custom middleware (Before)...");

    // পরবর্তী মিডলওয়্যারের কাছে Request পাঠিয়ে দেওয়া হচ্ছে
    await next.Invoke();

    // Response যখন ফিরে যাচ্ছে
    Console.WriteLine("Response is passing through my custom middleware (After)...");
});

app.UseRouting();

// ... পরের কোড
```

**ব্যাখ্যা:**
*   `context`: এটি `HttpContext` অবজেক্ট, যার মধ্যে Request এবং Response সম্পর্কিত সব তথ্য থাকে।
*   `next`: এটি একটি ডেলিগেট (delegate), যা পাইপলাইনের পরবর্তী মিডলওয়্যারকে কল করে। আপনি যদি `await next.Invoke()` কল না করেন, তাহলে পাইপলাইনটি এখানেই থেমে যাবে এবং পরের মিডলওয়্যারগুলো আর কাজ করবে না। একে **Short-circuiting** বলে।

#### পদ্ধতি ২: একটি আলাদা ক্লাস তৈরি করে (ভালো ও পরিচ্ছন্ন উপায়)

বড় অ্যাপ্লিকেশনের জন্য মিডলওয়্যারকে একটি আলাদা ক্লাসে লেখা ভালো অভ্যাস।

**ধাপ ক: ক্লাস তৈরি করুন**
প্রথমে একটি নতুন ক্লাস তৈরি করুন, যেমন `MyCustomMiddleware.cs`:

```csharp
public class MyCustomMiddleware
{
    private readonly RequestDelegate _next;

    public MyCustomMiddleware(RequestDelegate next)
    {
        _next = next;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        // Request আসার সময়কার কাজ
        Console.WriteLine($"Request received for path: {context.Request.Path}");

        // পরবর্তী মিডলওয়্যারকে কল করা
        await _next(context);

        // Response যাওয়ার সময়কার কাজ
    }
}
```

**ধাপ খ: এক্সটেনশন মেথড তৈরি করুন (ঐচ্ছিক কিন্তু ভালো)**
এই মিডলওয়্যারটি সহজে ব্যবহার করার জন্য একটি এক্সটেনশন মেথড তৈরি করা হয়।

```csharp
public static class MyCustomMiddlewareExtensions
{
    public static IApplicationBuilder UseMyCustomMiddleware(this IApplicationBuilder builder)
    {
        return builder.UseMiddleware<MyCustomMiddleware>();
    }
}
```

**ধাপ গ: `Program.cs`-এ ব্যবহার করুন**
এখন `Program.cs` ফাইলে খুব সহজে আপনার মিডলওয়্যারটি যোগ করতে পারবেন।

```csharp
// ... আগের কোড

app.UseHttpsRedirection();
app.UseStaticFiles();

// আপনার কাস্টম মিডলওয়্যার যোগ করুন
app.UseMyCustomMiddleware();

app.UseRouting();

// ... পরের কোড
```

---

### ধাপ ৫: টার্মিনাল মিডলওয়্যার (`app.Run`)

কিছু মিডলওয়্যার আছে যারা Request-কে পরবর্তী মিডলওয়্যারের কাছে পাঠায় না। এরা পাইপলাইনকে থামিয়ে দেয় এবং সরাসরি একটি Response পাঠিয়ে দেয়। এদেরকে **Terminal Middleware** বলে।

`app.Run()` হলো এমনই একটি টার্মিনাল মিডলওয়্যার। এর পরে কোনো মিডলওয়্যার কাজ করে না।

**উদাহরণ:**
```csharp
app.Run(async context =>
{
    await context.Response.WriteAsync("Hello from the end of the pipeline!");
});

// app.Run() এর পরে লেখা কোনো মিডলওয়্যার কাজ করবে না।
app.UseRouting(); // এটি আর কখনও কল হবে না।
```

### সারসংক্ষেপ

1.  **মিডলওয়্যার** হলো একটি পাইপলাইন, যা HTTP Request এবং Response প্রসেস করে।
2.  প্রতিটি মিডলওয়্যার একটি নির্দিষ্ট কাজ করে (যেমন: লগিং, অথেন্টিকেশন, রাউটিং)।
3.  `Program.cs` ফাইলে `app.Use...()` ব্যবহার করে মিডলওয়্যার যোগ করা হয়।
4.  মিডলওয়্যারের **ক্রম (Order)** খুবই গুরুত্বপূর্ণ।
5.  `next()` ব্যবহার করে Request-কে পরবর্তী মিডলওয়্যারের কাছে পাঠানো হয়।
6.  আপনি নিজের প্রয়োজনে **কাস্টম মিডলওয়্যার** তৈরি করতে পারেন।
7.  `app.Run()` একটি **টার্মিনাল মিডলওয়্যার**, যা পাইপলাইন শেষ করে দেয়।




## একটি খুবই বাস্তবসম্মত এবং সহজ উদাহরণ দিয়ে একটি কাস্টম প্রোডাক্ট মিডলওয়্যার (Product Middleware) তৈরি করি।

### আমাদের লক্ষ্য (Our Goal)

ধরুন, আমাদের একটি API আছে যা প্রোডাক্টের তথ্য দেয় (`/api/products`)। আমরা চাই, শুধুমাত্র সেইসব রিকোয়েস্ট এই API অ্যাক্সেস করতে পারবে, যাদের কাছে একটি বিশেষ "সিক্রেট কী" (Secret Key) আছে। এই কী-টি রিকোয়েস্টের হেডারে (Header) পাঠাতে হবে।

**নিয়ম:**
1.  যদি কোনো রিকোয়েস্ট `/api/products` পাথে আসে, আমাদের মিডলওয়্যার চেক করবে।
2.  রিকোয়েস্টের হেডারে `X-Api-Key` নামে একটি কী থাকতে হবে।
3.  যদি কী-এর ভ্যালু `MySecretKey123` হয়, তবেই রিকোয়েস্টটি সামনে এগোতে পারবে।
4.  যদি কী না থাকে বা ভুল হয়, তাহলে মিডলওয়্যারটি একটি `401 Unauthorized` এরর মেসেজ পাঠিয়ে রিকোয়েস্টটি থামিয়ে দেবে।

---

### ধাপ ১: মিডলওয়্যার ক্লাস তৈরি করা (Create the Middleware Class)

প্রথমে, আমরা একটি নতুন ক্লাস ফাইল তৈরি করব। নাম দিলাম `ApiKeyMiddleware.cs`।

```csharp
// ApiKeyMiddleware.cs

public class ApiKeyMiddleware
{
    private readonly RequestDelegate _next;
    private const string API_KEY_HEADER_NAME = "X-Api-Key";
    private const string CORRECT_API_KEY = "MySecretKey123"; // বাস্তবে এটি appsettings.json থেকে আসবে

    public ApiKeyMiddleware(RequestDelegate next)
    {
        _next = next;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        // শুধুমাত্র /api/products পাথের জন্য এই মিডলওয়্যার কাজ করবে
        if (context.Request.Path.StartsWithSegments("/api/products"))
        {
            // হেডার থেকে API Key বের করার চেষ্টা করি
            if (!context.Request.Headers.TryGetValue(API_KEY_HEADER_NAME, out var extractedApiKey))
            {
                // হেডারেই কী পাওয়া যায়নি
                context.Response.StatusCode = 401; // Unauthorized
                await context.Response.WriteAsync("API Key was not provided.");
                return; // পাইপলাইন এখানেই থামিয়ে দাও
            }

            // কী পাওয়া গেছে, কিন্তু ভ্যালু সঠিক কি না চেক করি
            if (!CORRECT_API_KEY.Equals(extractedApiKey))
            {
                // কী ভুল
                context.Response.StatusCode = 401; // Unauthorized
                await context.Response.WriteAsync("Unauthorized client. Invalid API Key.");
                return; // পাইপলাইন এখানেই থামিয়ে দাও
            }
        }

        // যদি কী সঠিক হয় অথবা রিকোয়েস্টটি /api/products পাথের না হয়,
        // তাহলে পরের মিডলওয়্যারের কাছে পাঠিয়ে দাও
        await _next(context);
    }
}
```

**ব্যাখ্যা:**
*   `InvokeAsync` মেথডের ভেতরে আমরা প্রথমে চেক করছি রিকোয়েস্টের পাথ `/api/products` দিয়ে শুরু হয়েছে কি না।
*   `context.Request.Headers.TryGetValue(...)` দিয়ে আমরা হেডার থেকে `X-Api-Key` খুঁজে বের করছি।
*   যদি কী না পাওয়া যায় বা ভুল হয়, আমরা স্ট্যাটাস কোড `401` সেট করে একটি মেসেজ পাঠাচ্ছি এবং `return;` দিয়ে রিকোয়েস্ট প্রসেসিং থামিয়ে দিচ্ছি। এই প্রক্রিয়াকে **Short-circuiting the pipeline** বলে।
*   সবকিছু ঠিক থাকলে `await _next(context);` কল হবে এবং রিকোয়েস্টটি পাইপলাইনের পরবর্তী ধাপে যাবে।

---

### ধাপ ২: এক্সটেনশন মেথড তৈরি করা (Create the Extension Method)

`Program.cs` ফাইলে আমাদের মিডলওয়্যারটি সহজে ব্যবহার করার জন্য একটি এক্সটেনশন মেথড তৈরি করব। এটি একটি ভালো অভ্যাস।

একটি নতুন ফাইল `ApiKeyMiddlewareExtensions.cs` তৈরি করুন।

```csharp
// ApiKeyMiddlewareExtensions.cs

public static class ApiKeyMiddlewareExtensions
{
    public static IApplicationBuilder UseApiKeyMiddleware(this IApplicationBuilder builder)
    {
        return builder.UseMiddleware<ApiKeyMiddleware>();
    }
}
```

---

### ধাপ ৩: `Program.cs` ফাইলে মিডলওয়্যারটি ব্যবহার করা

এখন আমাদের `Program.cs` ফাইলে এই মিডলওয়্যারটি যোগ করতে হবে।

**গুরুত্বপূর্ণ:** এই মিডলওয়্যারটি অবশ্যই রাউটিং (`UseRouting`) এবং অথোরাইজেশন (`UseAuthorization`) এর **আগে** যোগ করতে হবে, যাতে অবৈধ রিকোয়েস্টগুলো শুরুতেই আটকে যায়।

```csharp
var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllers(); // API কন্ট্রোলার ব্যবহারের জন্য

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage();
}

app.UseHttpsRedirection();

// আমাদের কাস্টম প্রোডাক্ট মিডলওয়্যারটি এখানে যোগ করুন
app.UseApiKeyMiddleware();

app.UseRouting();

app.UseAuthorization();

// একটি সিম্পল API এন্ডপয়েন্ট তৈরি করি পরীক্ষার জন্য
app.MapGet("/api/products", () => 
    new { ProductId = 101, ProductName = "Gaming Mouse", Price = 1200 }
);

// সাধারণ হোমপেজের জন্য একটি এন্ডপয়েন্ট
app.MapGet("/", () => "Welcome to the homepage! No API Key needed here.");

app.Run();
```

---

### ধাপ ৪: কীভাবে পরীক্ষা করবেন (How to Test)

আপনি Postman, Insomnia অথবা ব্রাউজারের Fetch API ব্যবহার করে এটি পরীক্ষা করতে পারেন।

**কেস ১: সঠিক API Key দিয়ে রিকোয়েস্ট**
*   **URL:** `https://localhost:xxxx/api/products` (আপনার লোকালহোস্ট পোর্ট নম্বর দিন)
*   **Method:** GET
*   **Headers:**
    *   `Key`: `X-Api-Key`
    *   `Value`: `MySecretKey123`

**ফলাফল (Result):**
*   **Status:** `200 OK`
*   **Body:** `{"productId":101,"productName":"Gaming Mouse","price":1200}`

**কেস ২: ভুল বা কোনো API Key ছাড়া রিকোয়েস্ট**
*   **URL:** `https://localhost:xxxx/api/products`
*   **Method:** GET
*   **Headers:** (কোনো হেডার দেবেন না অথবা ভুল কী দিন)

**ফলাফল (Result):**
*   **Status:** `401 Unauthorized`
*   **Body:** `API Key was not provided.` অথবা `Unauthorized client. Invalid API Key.`

**কেস ৩: সাধারণ পেজে রিকোয়েস্ট**
*   **URL:** `https://localhost:xxxx/`
*   **Method:** GET

**ফলাফল (Result):**
*   **Status:** `200 OK`
*   **Body:** `Welcome to the homepage! No API Key needed here.`
    (কারণ আমাদের মিডলওয়্যারটি শুধুমাত্র `/api/products` পাথের জন্য কাজ করে)।

এই উদাহরণটি দেখায় যে কীভাবে মিডলওয়্যার ব্যবহার করে আপনি আপনার অ্যাপ্লিকেশনের নির্দিষ্ট অংশকে সুরক্ষিত করতে পারেন এবং কন্ট্রোলারের কোডকে পরিষ্কার রাখতে পারেন।