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
    
