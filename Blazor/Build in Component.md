https://learn.microsoft.com/en-us/aspnet/core/blazor/components/?view=aspnetcore-9.0

Blazor-এ বেশ কিছু **বিল্ট-ইন কম্পোনেন্ট** রয়েছে যেগুলো ডিফল্টভাবে ফ্রেমওয়ার্কের সাথে আসে। এখানে সবচেয়ে কমন এবং গুরুত্বপূর্ণ বিল্ট-ইন কম্পোনেন্টগুলির নাম ও সংক্ষিপ্ত বর্ণনা দেওয়া হলো:

---

### **১. রাউটিং এবং নেভিগেশন**

1. **`Router`**
    
    - অ্যাপের রাউটিং ম্যানেজ করে (`App.razor`-এ ব্যবহৃত)।
        
2. **`NavLink`**
    
    - নেভিগেশন লিঙ্ক তৈরি করে এবং অ্যাক্টিভ পেজের জন্য CSS ক্লাস অ্যাড করে।
        
3. **`RedirectTo`**
    
    - রিডাইরেক্ট করার জন্য ব্যবহৃত হয় (Blazor WebAssembly-এ `NavigationManager` বেশি ব্যবহৃত)।
### **২. ফর্ম এবং ইনপুট**

1. **`EditForm`**
    
    - ফর্ম ভ্যালিডেশন এবং সাবমিশন হ্যান্ডল করে।
        
2. **`InputText`**
    
    - টেক্সট ইনপুট ফিল্ডের জন্য (`<input type="text">`)।
        
3. **`InputNumber`**
    
    - সংখ্যা ইনপুটের জন্য (`<input type="number">`)।
        
4. **`InputTextArea`**
    
    - মাল্টি-লাইন টেক্সট ইনপুটের জন্য (`<textarea>`)।
        
5. **`InputCheckbox`**
    
    - চেকবক্স ইনপুটের জন্য (`<input type="checkbox">`)।
        
6. **`InputDate`**
    
    - তারিখ ইনপুটের জন্য (`<input type="date">`)।
        
7. **`InputRadio`**
    
    - রেডিও বাটন গ্রুপের জন্য।
        
8. **`InputSelect`**
    
    - ড্রপডাউন লিস্টের জন্য (`<select>` ট্যাগ)।
        
9. **`ValidationMessage`**
    
    - স্পেসিফিক ফিল্ডের ভ্যালিডেশন এরর মেসেজ শো করে।
        
10. **`ValidationSummary`**
    
    - সমস্ত ভ্যালিডেশন এরর একসাথে শো করে।
        
11. **`DataAnnotationsValidator`**
    
    - ডেটা অ্যানোটেশন-ভিত্তিক ভ্যালিডেশন চালু করে।


### **৩. লেআউট এবং স্ট্রাকচার**

1. **`LayoutComponentBase`**
    
    - লেআউট কম্পোনেন্টের বেস ক্লাস (উদা: `MainLayout.razor`)।
        
2. **`LayoutView`**
    
    - ডাইনামিক লেআউট অ্যাপ্লাই করতে ব্যবহৃত হয়।
        
3. **`Body`**
    
    - লেআউটে কন্টেন্ট রেন্ডার করার জন্য (যেমন `<main>@Body</main>`)।

### **৪. কন্ডিশনাল রেন্ডারিং**

1. **`AuthorizeView`**
    
    - ইউজারের অথেনটিকেশন স্টেট অনুযায়ী UI শো করে।
        
2. **`Authorized`**
    
    - `AuthorizeView`-এর ভিতরে অথেনটিকেটেড ইউজারের জন্য কন্টেন্ট।
        
3. **`NotAuthorized`**
    
    - `AuthorizeView`-এর ভিতরে নন-অথেনটিকেটেড ইউজারের জন্য কন্টেন্ট。
        
4. **`CascadingValue`**
    
    - চাইল্ড কম্পোনেন্টে ভ্যালু ক্যাসকেড করার জন্য।
        
5. **`Virtualize`**
    
    - বড় ডেটা সেটের জন্য অপ্টিমাইজড রেন্ডারিং (লেইজি লোডিং)।

### **৫. এরর হ্যান্ডলিং**

1. **`ErrorBoundary`**
    
    - চাইল্ড কম্পোনেন্টে এরর ক্যাচ করে ফ্রেন্ডলি মেসেজ শো করে।
        

---

### **৬. ডোম এবং HTML হেল্পার্স**

2. **`HeadContent`**
    
    - HTML `<head>` সেকশনে কন্টেন্ট অ্যাড করতে ব্যবহৃত (Blazor WebAssembly)।
        
3. **`PageTitle`**
    
    - পেজের টাইটেল সেট করতে ব্যবহৃত (Blazor WebAssembly)।

### **. অ্যাপ স্ট্রাকচার**

1. **`App`**
    
    - রুট কম্পোনেন্ট (`App.razor` ফাইলে ডিফল্ট)।
        
2. **`RouteView`**
    
    - রাউটেড পেজ রেন্ডার করে (`App.razor`-এ ব্যবহৃত)।
        

---

### **৮. চাইল্ড কন্টেন্ট ম্যানেজমেন্ট**

3. **`ChildContent`**
    
    - প্যারেন্ট কম্পোনেন্ট থেকে চাইল্ড কন্টেন্ট রেন্ডার করতে ব্যবহৃত (উদা: `<Modal> <ChildContent>...</ChildContent> </Modal>`)।

### **৯. লাইফসাইকেল মেথডস**

Blazor কম্পোনেন্টের বেস ক্লাস `ComponentBase`-এ নিম্নলিখিত লাইফসাইকেল মেথডগুলি বিল্ট-ইন:

- `OnInitialized` / `OnInitializedAsync`
    
- `OnParametersSet` / `OnParametersSetAsync`
    
- `OnAfterRender` / `OnAfterRenderAsync`
    
- `StateHasChanged`
    

---

### **১০. অন্যান্য ইউটিলিটি কম্পোনেন্ট**

1. **`FocusOnNavigate`**
    
    - পেজ লোড হওয়ার পর নির্দিষ্ট এলিমেন্টে ফোকাস সেট করে (Blazor WebAssembly)।
        
2. **`DynamicComponent`**
    
    - টাইপ-বেসেড ডাইনামিক কম্পোনেন্ট লোড করতে ব্যবহৃত (Blazor 6.0+).


```C#
<!-- Counter.razor -->
@page "/counter"

<PageTitle>Counter</PageTitle>
<h1>Counter</h1>

<EditForm>
    <InputNumber @bind-Value="currentCount" />
</EditForm>

<button @onclick="IncrementCount">Click me</button>

@code {
    private int currentCount = 0;
    private void IncrementCount() => currentCount++;
}
```

