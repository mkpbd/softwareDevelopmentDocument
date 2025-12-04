
Hallow Amigos! 👋 আমি তোমাদের সেই Cool UI/UX এবং Frontend Expert ভাইয়া। আজ আমরা এমন একটা জিনিস শিখব যেটা শুনলে নতুন ডেভেলপাররা ভয়ে পালাবে, কিন্তু শিখলে নিজেকে "সুপারহিরো" মনে হবে। জিনিসটা হলো **RxJS** (Reactive Extensions for JavaScript)!

চিন্তা করো না, আমরা কোনো বোরিং লেকচার দেব না। আমরা শিখব চা-এর দোকানের আড্ডা, রিক্সাওয়ালা মামা আর আমাদের দৈনন্দিন জীবনের আজব সব উদাহরণের মাধ্যমে।

RxJS এর লেটেস্ট ভার্সন দিয়ে সাজানো **"RxJS এর রোলার কোস্টার"** কোর্সের ২০টি এপিসোড নিচে দেওয়া হলো:

---

### **Phase 1: RxJS কি এবং কেন? (Foundation)**

**Lesson 1: Reactive Programming - আসলে জিনিসটা খায় না মাথায় দেয়?**
*   **Topic:** Introduction to Reactive Programming.
*   **Fun Example:** তুমি যখন বৃষ্টির জন্য অপেক্ষা করো (Passive) vs. বৃষ্টি শুরু হলে দৌড়ে কাপড় তুলতে যাও (Reactive)।
*   **Concept:** Stream কি? Data কেন পানির মতো প্রবাহিত হয়?

**Lesson 2: সেটআপ ও হ্যালো ওয়ার্ল্ড (Environment Setup)**
*   **Topic:** Setting up RxJS with NPM/Angular/React.
*   **Fun Example:** বিরিয়ানি রান্না করার আগে যেমন হাড়ি-পাতিল ধুয়ে নিতে হয়, তেমনি প্রোজেক্ট সেটআপ।
*   **Action:** `npm install rxjs` এবং প্রথম কোড রান করা।

**Lesson 3: Promise vs Observable - প্রেমিকা vs স্ত্রী!**
*   **Topic:** Difference between Promise and Observable.
*   **Fun Example:**
    *   **Promise:** পিৎজা অর্ডার দিয়েছো, একবারই আসবে (One value)।
    *   **Observable:** নেটফ্লিক্স সিরিজ, একটার পর একটা এপিসোড আসতেই থাকে (Stream of values)।
*   **Key takeaway:** Observable cancel করা যায়, Promise যায় না।

**Lesson 4: Observable এর জন্ম (Creating Observables)**
*   **Topic:** `new Observable()`
*   **Fun Example:** একটা ইউটিউব চ্যানেল খোলা। তুমি ভিডিও আপলোড করলেই মানুষ দেখবে।
*   **Code:** `next()`, `error()`, `complete()` এর মানে বোঝা।

**Lesson 5: Subscriber - যে আসলে বাশঁটা খায় (Subscribe & Observer)**
*   **Topic:** `.subscribe()`
*   **Fun Example:** ইউটিউব চ্যানেল খুলেছো কিন্তু সাবস্ক্রাইবার নাই—লাভ আছে? ডাটা পেতে হলে `subscribe` করতেই হবে।
*   **Observer Object:** `next` (আহ কি শান্তি), `error` (ধুরো ছাই), `complete` (খেলা শেষ)।

---

### **Phase 2: অপারেটরদের খেলা (Operators - The Basics)**

**Lesson 6: Creation Operators (of, from)**
*   **Topic:** `of`, `from`.
*   **Fun Example:**
    *   `of`: পকেট থেকে চকোলেট বের করে দেওয়া।
    *   `from`: ফলের ঝুড়ি (Array) থেকে একটা একটা করে ফল বের করে দেওয়া।

**Lesson 7: Pipe - পানির লাইনের মিস্ত্রি (Pipeable Operators)**
*   **Topic:** `.pipe()` function.
*   **Fun Example:** পানির পাইপের মধ্যে ফিল্টার লাগানো, যাতে ময়লা পানি পরিষ্কার হয়ে আসে। ডাটাকে মডিফাই করার জায়গা হলো Pipe।

**Lesson 8: Map Operator - কাঁচা আম থেকে আচার**
*   **Topic:** `map()`
*   **Fun Example:** ইনপুট আসছে "কাঁচা আম", `map` এর ভেতর প্রসেস হয়ে আউটপুট বের হচ্ছে "আচার"।
*   **Code:** `x => x * 10` (যা আসবে, ১০ গুণ হয়ে বের হবে)।

**Lesson 9: Filter Operator - ছাঁকনি দিয়ে চা ছাঁকা**
*   **Topic:** `filter()`
*   **Fun Example:** চায়ের পাতা (unwanted data) ফেলে দিয়ে শুধু লিকারটা (wanted data) কাপে নেওয়া।
*   **Code:** শুধু জোড় সংখ্যা বা শুধু ভ্যালিড ইউজারকে পাস করা।

**Lesson 10: Tap Operator - গোয়েন্দাগিরি (Side Effects)**
*   **Topic:** `tap()`
*   **Fun Example:** গোয়েন্দা যেমন কারো কথা আড়ি পেতে শোনে কিন্তু কথার মাঝখানে ব্যাঘাত ঘটায় না, `tap` ঠিক তাই। ডাটা চেঞ্জ করে না, শুধু `console.log` বা লোডিং স্পিনার দেখাতে কাজে লাগে।

---

### **Phase 3: ইউজার ইন্টার‍্যাকশন ও টাইমিং (Flow Control)**

**Lesson 11: fromEvent - ক্লিকবাজি!**
*   **Topic:** DOM Events to Observable.
*   **Fun Example:** মাউস দিয়ে বাটনে ক্লিক করা আর মেশিনগানের মতো গুলি বের হওয়া (Click Stream)।

**Lesson 12: DebounceTime - একটু থামো ভাই!**
*   **Topic:** `debounceTime()`
*   **Fun Example:** সার্চ বক্সে টাইপ করছো। প্রতি অক্ষরে রিকোয়েস্ট পাঠালে সার্ভার ক্র্যাশ করবে। `debounceTime` বলে, "তোর টাইপ করা শেষ হোক, তারপর আমি খুঁজব।" (যেমন লিফটের দরজা—কেউ আসলে আবার খুলে যায়)।

**Lesson 13: ThrottleTime - মেশিনগানের কুলডাউন**
*   **Topic:** `throttleTime()`
*   **Fun Example:** গেম খেলার সময় গুলি শেষ, রিলোড করতে সময় লাগে। হাজারবার ক্লিক করলেও কাজ হবে না নির্দিষ্ট সময় পর পর কাজ হবে।

**Lesson 14: Take & TakeUntil - আর পারছিনা!**
*   **Topic:** `take()`, `takeUntil()`.
*   **Fun Example:**
    *   `take(3)`: বিয়ের বাফেতে গিয়ে মাত্র ৩ পিস রোস্ট নেওয়া।
    *   `takeUntil(timer)`: বস না আসা পর্যন্ত আড্ডা দেওয়া। বস আসলো (Trigger), আড্ডা বন্ধ।

---

### **Phase 4: কঠিন জিনিস সহজে (Advanced Operators - Flattening)**
*(এটা RxJS এর সবচেয়ে কঠিন পার্ট, কিন্তু আমরা শিখব মামা-ভাগ্নের গল্প দিয়ে)*

**Lesson 15: MergeMap - মাল্টিটাস্কিং মামা**
*   **Topic:** `mergeMap` (Parallel execution).
*   **Fun Example:** ব্যাংকের ক্যাশ কাউন্টার ৫টা খোলা। ১০ জন কাস্টমার আসলে ৫ জন একসাথে সেবা পাবে। কেউ কারোর জন্য ওয়েট করবে না।

**Lesson 16: ConcatMap - লাইনে দাঁড়ান ভাই!**
*   **Topic:** `concatMap` (Sequential execution).
*   **Fun Example:** এটিএম বুথ একটাই। আগের জন টাকা তুলে বের না হওয়া পর্যন্ত পরের জন ঢুকতে পারবে না। ১ নম্বর রিকোয়েস্ট শেষ হলে ২ নম্বর শুরু হবে।

**Lesson 17: SwitchMap - নতুন প্রেমিকা! (The Most Important Lesson)**
*   **Topic:** `switchMap` (Cancelling previous inner observable).
*   **Fun Example:** তুমি একজনকে প্রপোজ করেছো, রিপ্লাই আসেনি। এর মধ্যে আরেকজনকে ভালো লেগে গেল। আগেরজনকে ভুলে গিয়ে নতুনজনের পেছনে ছোটা।
*   **Use Case:** সার্চ বক্সে নতুন কিছু লিখলে আগের সার্চ রিকোয়েস্ট ক্যানসেল হয়ে যায়।

**Lesson 18: CombineLatest & ForkJoin - খিচুড়ি রান্না**
*   **Topic:** Combining Observables.
*   **Fun Example:**
    *   `ForkJoin`: ডাল, চাল, মশলা সব রেডি হওয়ার পরই হাড়ি চুলায় উঠবে (সব রিকোয়েস্ট কমপ্লিট হলে রেজাল্ট দিবে)।
    *   `CombineLatest`: যখনই চালের দাম বাড়ে, তখনই খিচুড়ির দাম আপডেট হয়।

---

### **Phase 5: এরর হ্যান্ডলিং ও মেমোরি (Expert Zone)**

**Lesson 19: CatchError & Retry - ফেল করলে আবার পরীক্ষা**
*   **Topic:** Error Handling.
*   **Fun Example:** ইন্টারনেটের লাইন কেটে গেছে (Error)। RxJS বলবে, "কান্নাকাটি না করে অল্টারনেটিভ লাইন (CatchError) চালু কর অথবা ৩ বার ট্রাই কর (Retry) কানেক্ট করার।"

**Lesson 20: Subject & BehaviorSubject - মাইকিং করা**
*   **Topic:** Multicasting & State Management.
*   **Fun Example:**
    *   **Observable:** কানে কানে কথা বলা (Unicast).
    *   **Subject:** পাড়ার মোড়ে মাইকিং করা (Multicast - সবাই একসাথে শুনে).
    *   **BehaviorSubject:** যে পরে আসবে সেও জানবে লাস্ট কি ঘোষণা দেওয়া হয়েছে (Initial Value থাকে)।

---

### **Bonus: The "Unsubscribe" Trap!**
*   **মেমোরি লিক (Memory Leak):** সাবস্ক্রাইব করে আনসাবস্ক্রাইব না করা মানে হলো—বাসা ছেড়ে দিয়েছো কিন্তু বাড়িওয়ালাকে চাবি দাওনি, মাস শেষে ভাড়ার বিল ঠিকই আসবে! আমরা শিখব কিভাবে `AsyncPipe` বা `destroy$` দিয়ে ক্লিন কোড লিখতে হয়।

---

**Ready to start?** তাহলে প্রথম লেসন দিয়ে শুরু করা যাক! 🚀