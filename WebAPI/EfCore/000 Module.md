
স্বাগতম! আমি তোমাদের অভিজ্ঞ .NET ও EF Core প্রশিক্ষক। ৫০টি লেসনের এই বিশাল জার্নিতে আমরা একদম শূন্য থেকে শুরু করে EF Core-এর বস হয়ে উঠব। যেহেতু ৫০টি লেসনের সম্পূর্ণ কন্টেন্ট একটি উত্তরে দেওয়া টেকনিক্যালি অসম্ভব (ক্যারেক্টার লিমিটের কারণে), তাই আমি প্রথমে **৫০টি লেসনের সম্পূর্ণ সিলেবাস (Course Outline)** দিচ্ছি এবং এরপর **প্রথম ৫টি লেসন (Lesson 1-5)** সম্পূর্ণ বিস্তারিতভাবে দিচ্ছি।

বাকি লেসনগুলো ধাপে ধাপে (যেমন ৬-১০, ১১-১৫) আমি প্রদান করব। চলুন শুরু করি!

### 📚 সম্পূর্ণ ৫০ লেসনের কোর্স আউটলাইন

**Module 1: শুরু ও বেসিক (Getting Started)**
1. EF Core কী এবং প্রোজেক্ট সেটআপ
2. প্রথম এন্টিটি ও DbContext তৈরি
3. ডাটাবেজ কানেকশন ও প্রোভাইডার কনফিগারেশন
4. মাইগ্রেশন (Migrations): কোড থেকে ডাটাবেজ
5. ডাটা সেভ করা (Create Operation)

**Module 2: বেসিক CRUD ও কুয়েরি**
6. ডাটা পড়া বা রিড করা (Read/Select)
7. ডাটা ফিল্টারিং ও সর্টিং (Filtering & Sorting)
8. ডাটা আপডেট করা (Update Operation)
9. ডাটা ডিলিট করা (Delete Operation)
10. সিঙ্ক্রোনাস বনাম অ্যাসিনক্রোনাস (Async/Await) অপারেশন

**Module 3: মডেলিং ও কনফিগারেশন (Modeling)**
11. কনফিগারেশন প্যাটার্ন: Data Annotations
12. কনফিগারেশন প্যাটার্ন: Fluent API
13. প্রাইমারি কি (Primary Key) ও কম্পোজিট কি
14. প্রপার্টি কনফিগারেশন (Required, MaxLength, Column Name)
15. Enums এবং ডাটা টাইপ কনভার্সন

**Module 4: রিলেশনশিপ (Relationships)**
16. রিলেশনশিপ পরিচিতি ও ফরেন কি
17. One-to-One রিলেশনশিপ
18. One-to-Many রিলেশনশিপ
19. Many-to-Many রিলেশনশিপ (Skip Navigation)
20. ক্যাস্কেড ডিলিট (Cascade Delete) ও রেফারেন্সিয়াল অ্যাকশন

**Module 5: অ্যাডভান্সড কুয়েরি (Advanced Querying)**
21. Eager Loading (Include/ThenInclude)
22. Explicit Loading এবং Lazy Loading
23. Select Loading (প্রজেকশন/DTO তে ডাটা নেওয়া)
24. Raw SQL কুয়েরি (FromSql, ExecuteSql)
25. No-Tracking কুয়েরি (পারফরম্যান্স বুস্ট)

**Module 6: গভীরতর EF Core (Deep Dive)**
26. Shadow Properties (অদৃশ্য প্রপার্টি)
27. Backing Fields (এনক্যাপসুলেশন)
28. Owned Entity Types (Value Objects)
29. Table Splitting এবং Entity Splitting
30. Global Query Filters (Soft Delete ইমপ্লিমেন্টেশন)

**Module 7: ইনহেরিটেন্স ও পলিমরফিজম**
31. ইনহেরিটেন্স ম্যাপিং: TPH (Table Per Hierarchy)
32. ইনহেরিটেন্স ম্যাপিং: TPT (Table Per Type)
33. ইনহেরিটেন্স ম্যাপিং: TPC (Table Per Concrete Type)

**Module 8: ডাটা ম্যানিপুলেশন ও লজিক**
34. বাল্ক আপডেট ও ডিলিট (ExecuteUpdate/Delete)
35. ট্রানজ্যাকশন ম্যানেজমেন্ট (Transactions)
36. ডাটা সিডিং (Data Seeding)
37. জেনারেটেড ভ্যালু (Identity, Computed Columns)
38. কনকারেন্সি কনফ্লিক্ট হ্যান্ডলিং (Concurrency Tokens)

**Module 9: টুলস ও রিভার্স ইঞ্জিনিয়ারিং**
39. রিভার্স ইঞ্জিনিয়ারিং (Scaffolding Existing DB)
40. মাল্টিপল DbContext এবং মাইগ্রেশন ম্যানেজমেন্ট
41. SQL স্ক্রিপ্ট জেনারেশন (Script-Migration)
42. Logging এবং Diagnostics

**Module 10: আর্কিটেকচার, টেস্টিং ও প্রোজেক্ট**
43. EF Core বেস্ট প্র্যাকটিস ও টিপস
44. কম্পাইল্ড কুয়েরি (Compiled Queries)
45. ইন্টারসেপ্টর (Interceptors) - অডিট লগিং
46. ইউনিট টেস্টিং (In-Memory Database)
47. ইউনিট টেস্টিং (SQLite In-Memory Mode)
48. রিপোজিটরি প্যাটার্ন বনাম ডিরেক্ট DbContext
49. EF Core Performance Tuning চেকলিস্ট
50. **ফাইনাল প্রোজেক্ট:** ই-কমার্স ক্যাটালগ API (সম্পূর্ণ ইমপ্লিমেন্টেশন)

