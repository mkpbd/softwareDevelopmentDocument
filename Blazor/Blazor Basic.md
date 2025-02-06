Blazor-এর লাইফসাইকেল হল একটি কম্পোনেন্ট কীভাবে তৈরি, রেন্ডার, আপডেট এবং ডিস্ট্রয় হয় তার একটি সিরিজ ইভেন্ট। Blazor কম্পোনেন্টের লাইফসাইকেলকে বিভিন্ন পর্যায়ে ভাগ করা যায়। নিচে বাংলায় ব্যাখ্যা করা হল:

### 1. **ইনিশিয়ালাইজেশন (Initialization)**

- **OnInitialized**: এই মেথডটি কম্পোনেন্ট তৈরি হওয়ার সময় কল হয়। এখানে সাধারণত ডেটা ইনিশিয়ালাইজেশন বা API কল করা হয়।
    
- **OnInitializedAsync**: এটি `OnInitialized`-এর অ্যাসিঙ্ক্রোনাস ভার্সন। যদি ডেটা লোড করতে অ্যাসিঙ্ক্রোনাস অপারেশন প্রয়োজন হয়, তাহলে এই মেথড ব্যবহার করা হয়।
    

### 2. **প্যারামিটার সেট (Parameters Set)**

- **OnParametersSet**: যখন কম্পোনেন্টের প্যারামিটার সেট বা আপডেট হয়, তখন এই মেথড কল হয়। উদাহরণস্বরূপ, প্যারেন্ট কম্পোনেন্ট থেকে চাইল্ড কম্পোনেন্টে ডেটা পাঠানো হলে এই মেথড ট্রিগার হয়।
    
- **OnParametersSetAsync**: এটি `OnParametersSet`-এর অ্যাসিঙ্ক্রোনাস ভার্সন।
    

### 3. **রেন্ডারিং (Rendering)**

- **BuildRenderTree**: এই মেথডটি কম্পোনেন্টের UI রেন্ডার করার জন্য কল হয়। সাধারণত ডেভেলপারদের এই মেথড ম্যানুয়ালি কল করার প্রয়োজন হয় না, কারণ Blazor স্বয়ংক্রিয়ভাবে এটি হ্যান্ডল করে।
    

### 4. **আপডেট (Update)**

- **OnAfterRender**: কম্পোনেন্ট রেন্ডার হওয়ার পর এই মেথড কল হয়। এটি প্রথম রেন্ডার এবং পরবর্তী আপডেট উভয় ক্ষেত্রে কাজ করে। এখানে সাধারণত DOM ম্যানিপুলেশন বা JavaScript ইন্টারঅপারেশন করা হয়।
    
- **OnAfterRenderAsync**: এটি `OnAfterRender`-এর অ্যাসিঙ্ক্রোনাস ভার্সন।
    

### 5. **ডিস্ট্রয় (Disposal)**

- **Dispose**: যখন কম্পোনেন্ট ডিস্ট্রয় হয়, তখন এই মেথড কল হয়। এটি সাধারণত রিসোর্স ক্লিনআপ বা আনসাবস্ক্রাইব করার জন্য ব্যবহার করা হয়। `IDisposable` ইন্টারফেস ইমপ্লিমেন্ট করে এই মেথড ব্যবহার করা যায়।
`C# 
	@page "/lifecycle"
@implements IDisposable



Blazor অ্যাপ্লিকেশনের লাইফসাইকেল বিভিন্ন ধাপে বিভক্ত, যা কম্পোনেন্টের জীবনকালের বিভিন্ন পর্যায়ে ঘটে। এই লাইফসাইকেল মেথডগুলি ডেভেলপারদের কম্পোনেন্টের বিভিন্ন পর্যায়ে কাস্টম লজিক প্রয়োগ করার সুযোগ দেয়। নিচে Blazor কম্পোনেন্টের প্রধান লাইফসাইকেল মেথডগুলির একটি তালিকা এবং তাদের বর্ণনা দেওয়া হল:

1. **`OnInitialized` এবং `OnInitializedAsync`**:
   - এই মেথডগুলি কম্পোনেন্ট ইনিশিয়ালাইজ হওয়ার সময় কল করা হয়।
   - `OnInitializedAsync` অ্যাসিঙ্ক্রোনাস অপারেশন সম্পাদনের জন্য ব্যবহৃত হয়।

2. **`OnParametersSet` এবং `OnParametersSetAsync`**:
   - এই মেথডগুলি কম্পোনেন্টের প্যারামিটারগুলি সেট হওয়ার পরে কল করা হয়।
   - প্যারামিটার পরিবর্তনের পরে লজিক প্রয়োগ করার জন্য উপযুক্ত।

3. **`OnAfterRender` এবং `OnAfterRenderAsync`**:
   - এই মেথডগুলি কম্পোনেন্ট রেন্ডার হওয়ার পরে কল করা হয়।
   - DOM উপাদানগুলির সাথে ইন্টারঅ্যাকশন করার জন্য ব্যবহৃত হয়।

4. **`ShouldRender`**:
   - এই মেথডটি নির্ধারণ করে যে কম্পোনেন্টটি পুনরায় রেন্ডার করা উচিত কিনা।
   - রেন্ডারিং প্রক্রিয়াকে অপ্টিমাইজ করার জন্য ব্যবহৃত হয়।

5. **`Dispose` এবং `DisposeAsync`**:
   - এই মেথডগুলি কম্পোনেন্ট ডিস্ট্রয় হওয়ার সময় কল করা হয়।
   - রিসোর্স মুক্তি করার জন্য ব্যবহৃত হয়।

এই লাইফসাইকেল মেথডগুলি ব্যবহার করে, ডেভেলপাররা কম্পোনেন্টের বিভিন্ন পর্যায়ে কাস্টম লজিক প্রয়োগ করতে পারেন, যা অ্যাপ্লিকেশনের পারফরম্যান্স এবং ব্যবহারকারীর অভিজ্ঞতা উন্নত করে।

<h3>Lifecycle Example</h3>
```C#
@code {
    protected override void OnInitialized()
    {
        Console.WriteLine("Component initialized.");
    }

    protected override async Task OnInitializedAsync()
    {
        await Task.Delay(1000); // Simulate async operation
        Console.WriteLine("Async initialization complete.");
    }

    protected override void OnParametersSet()
    {
        Console.WriteLine("Parameters set.");
    }

    protected override void OnAfterRender(bool firstRender)
    {
        if (firstRender)
        {
            Console.WriteLine("First render complete.");
        }
    }

    public void Dispose()
    {
        Console.WriteLine("Component disposed.");
    }
}
```

### সারমর্ম:

- **OnInitialized** এবং **OnInitializedAsync**: কম্পোনেন্ট তৈরি হওয়ার সময় কল হয়।
    
- **OnParametersSet** এবং **OnParametersSetAsync**: প্যারামিটার সেট বা আপডেট হলে কল হয়।
    
- **OnAfterRender** এবং **OnAfterRenderAsync**: কম্পোনেন্ট রেন্ডার হওয়ার পর কল হয়।
    
- **Dispose**: কম্পোনেন্ট ডিস্ট্রয় হলে কল হয়।
    


Blazor-এ **বিল্ট-ইন কম্পোনেন্ট** বলতে বোঝায় এমন কম্পোনেন্ট যা Blazor ফ্রেমওয়ার্কের সাথে ডিফল্টভাবে থাকে এবং যেগুলোকে আপনি সরাসরি আপনার অ্যাপ্লিকেশনে ব্যবহার করতে পারেন। এই কম্পোনেন্টগুলি UI তৈরি, ডেটা বাইন্ডিং, ইভেন্ট হ্যান্ডলিং, রাউটিং ইত্যাদি কাজের জন্য প্রস্তুত করা হয়েছে। নিচে বাংলায় কিছু গুরুত্বপূর্ণ বিল্ট-ইন কম্পোনেন্টের ব্যাখ্যা দেওয়া হলো:

### **১. রাউটিং-এর জন্য কম্পোনেন্ট**

#### **`Router`**

- Blazor অ্যাপে পেজ নেভিগেশন ম্যানেজ করে।
    
- `App.razor` ফাইলে এটি ডিফল্টভাবে থাকে।
    
- উদাহরণ:
```C# 
<Router AppAssembly="@typeof(Program).Assembly">
    <Found Context="routeData">
        <RouteView RouteData="@routeData" DefaultLayout="@typeof(MainLayout)" />
    </Found>
    <NotFound>
        <LayoutView Layout="@typeof(MainLayout)">
            <p>Page not found!</p>
        </LayoutView>
    </NotFound>
</Router>
```

#### **`NavLink`**

- নেভিগেশন লিঙ্ক তৈরি করতে ব্যবহৃত হয়। অ্যাক্টিভ পেজের জন্য CSS ক্লাস অটো অ্যাড করে।
    
```C#
<NavLink href="/counter" class="nav-link">Counter</NavLink>
```

### **২. ফর্ম এবং ইনপুট কম্পোনেন্ট**

Blazor-এ ফর্ম ভ্যালিডেশন এবং ডেটা বাইন্ডিং-এর জন্য বিল্ট-ইন কম্পোনেন্ট রয়েছে:

#### **`EditForm`**

- ফর্ম তৈরি করতে এবং ভ্যালিডেশন ম্যানেজ করতে ব্যবহৃত হয়।
```C#
<EditForm Model="@user" OnValidSubmit="HandleSubmit">
    <DataAnnotationsValidator />
    <ValidationSummary />
    
    <InputText @bind-Value="user.Name" />
    <InputNumber @bind-Value="user.Age" />
    
    <button type="submit">Submit</button>
</EditForm>
```

#### **ইনপুট ফিল্ডস**

- `InputText`, `InputNumber`, `InputCheckbox`, `InputDate` ইত্যাদি কম্পোনেন্ট ডেটা বাইন্ডিং-এর জন্য ব্যবহার করা হয়।
```C#
<InputText @bind-Value="username" placeholder="Enter your name" />
<InputNumber @bind-Value="age" />
```

### **৩. লেআউট কম্পোনেন্ট**

#### **`LayoutView`**

- অ্যাপ্লিকেশনের কমন লেআউট (হেডার, ফুটার) ডিফাইন করতে ব্যবহৃত হয়।
    
- উদাহরণ (`MainLayout.razor`):
```C#
@inherits LayoutComponentBase

<div class="main-layout">
    <header>My App Header</header>
    <main>@Body</main>
    <footer>© 2023 My App</footer>
</div>
```

### **৪. কন্ডিশনাল রেন্ডারিং কম্পোনেন্ট**

#### **`AuthorizeView`**

- ইউজারের অথেনটিকেশন স্টেট অনুযায়ী UI শো করে।
```C#
<AuthorizeView>
    <Authorized>
        <p>Hello, @context.User.Identity.Name!</p>
    </Authorized>
    <NotAuthorized>
        <p>Please log in.</p>
    </NotAuthorized>
</AuthorizeView>
```

### **৫. ত্রুটির জন্য কম্পোনেন্ট**

#### **`ErrorBoundary`**

- চাইল্ড কম্পোনেন্টে কোনো এরর হলে তা ক্যাচ করে ফ্রেন্ডলি মেসেজ শো করে।
```C#
<ErrorBoundary>
    <ChildComponent />
</ErrorBoundary>
```

### **৬. লাইফসাইকেল মেথড সহ কম্পোনেন্ট**

Blazor কম্পোনেন্টের লাইফসাইকেল মেথড (যেমন `OnInitialized`, `OnParametersSet`) ইমপ্লিমেন্ট করে আপনি কম্পোনেন্টের আচরণ কাস্টমাইজ করতে পারেন। উদাহরণ:

```C#
@code {
    protected override void OnInitialized()
    {
        // কম্পোনেন্ট লোড হওয়ার সময় কল হয়
    }
}
```

### **৭. থার্ড-পার্টি কম্পোনেন্ট লাইব্রেরি**

Blazor-এ **Radzen**, **MudBlazor**, **Syncfusion** এর মতো থার্ড-পার্টি লাইব্রেরি ব্যবহার করে আরও এডভান্সড UI কম্পোনেন্ট (ডাটাগ্রিড, চার্ট, ক্যালেন্ডার) যুক্ত করা যায়।

### **কাস্টম কম্পোনেন্ট তৈরি**

আপনি নিজের কম্পোনেন্ট তৈরি করতে পারেন `.razor` এক্সটেনশন ব্যবহার করে। উদাহরণ (`HelloWorld.razor`):

```C#
<h3>Hello, @Name!</h3>

@code {
    [Parameter]
    public string Name { get; set; }
}
```

