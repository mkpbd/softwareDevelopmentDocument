
অবশ্যই! CSS সিলেক্টর (CSS Selectors) হলো সেই প্যাটার্ন বা নিয়ম যা HTML ডকুমেন্টের নির্দিষ্ট এলিমেন্ট(গুলো)কে সিলেক্ট বা নির্বাচন করতে ব্যবহৃত হয়, যাতে তাদের উপর CSS স্টাইল প্রয়োগ করা যায়। সঠিক এলিমেন্ট সিলেক্ট করতে পারা CSS লেখার একটি মৌলিক এবং অত্যন্ত গুরুত্বপূর্ণ দক্ষতা।

CSS সিলেক্টরগুলোকে বিভিন্ন ক্যাটাগরিতে ভাগ করা যায়:

### ১. সাধারণ সিলেক্টর (Basic Selectors)

এগুলো সবচেয়ে মৌলিক এবং বেশি ব্যবহৃত সিলেক্টর।

*   **ইউনিভার্সাল সিলেক্টর (`*`)**: পৃষ্ঠার সমস্ত HTML এলিমেন্ট সিলেক্ট করে।
    ```css
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box; /* প্রায়শই রিসেট করার জন্য ব্যবহৃত হয় */
    }
    ```

*   **টাইপ/ট্যাগ সিলেক্টর (Type Selector or Tag Selector)**: নির্দিষ্ট HTML ট্যাগ নামের এলিমেন্ট সিলেক্ট করে।
    ```css
    p { /* সব <p> এলিমেন্ট */
        color: navy;
        line-height: 1.6;
    }
    h1 { /* সব <h1> এলিমেন্ট */
        font-size: 2em;
    }
    div { /* সব <div> এলিমেন্ট */
        border: 1px solid lightgray;
    }
    ```

*   **ক্লাস সিলেক্টর (`.classname`)**: নির্দিষ্ট `class` অ্যাট্রিবিউট যুক্ত এলিমেন্ট সিলেক্ট করে। একটি এলিমেন্টে একাধিক ক্লাস থাকতে পারে।
    ```html
    <p class="highlight important">এটি একটি গুরুত্বপূর্ণ প্যারাগ্রাফ।</p>
    <div class="box highlight">এটি একটি বক্স।</div>
    ```
    ```css
    .highlight { /* "highlight" ক্লাস যুক্ত সব এলিমেন্ট */
        background-color: yellow;
    }
    .important { /* "important" ক্লাস যুক্ত সব এলিমেন্ট */
        font-weight: bold;
    }
    p.highlight { /* শুধুমাত্র <p> এলিমেন্ট যার "highlight" ক্লাস আছে */
        border: 1px solid orange;
    }
    ```

*   **আইডি সিলেক্টর (`#idname`)**: নির্দিষ্ট `id` অ্যাট্রিবিউট যুক্ত এলিমেন্ট সিলেক্ট করে। একটি পৃষ্ঠায় প্রতিটি `id` ইউনিক বা অনন্য হতে হবে।
    ```html
    <div id="main-header">সাইটের প্রধান হেডার</div>
    ```
    ```css
    #main-header { /* "main-header" আইডি যুক্ত এলিমেন্ট */
        background-color: #333;
        color: white;
        padding: 20px;
    }
    ```
    **নোট:** আইডি সিলেক্টরের স্পেসিফিসিটি (specificity) বা গুরুত্ব ক্লাস বা ট্যাগ সিলেক্টরের চেয়ে বেশি। স্টাইলিং এর জন্য সাধারণত ক্লাস সিলেক্টর বেশি ব্যবহার করা হয় কারণ আইডি ইউনিক হতে হয়।

*   **অ্যাট্রিবিউট সিলেক্টর (`[attribute]`, `[attribute=value]`, ইত্যাদি)**: নির্দিষ্ট অ্যাট্রিবিউট বা অ্যাট্রিবিউটের মান যুক্ত এলিমেন্ট সিলেক্ট করে।
    *   `[attribute]`: যে এলিমেন্টে নির্দিষ্ট `attribute` আছে।
        ```css
        a[target] { /* যে <a> ট্যাগে target অ্যাট্রিবিউট আছে */
            color: green;
        }
        ```
    *   `[attribute=value]`: যে এলিমেন্টে `attribute` এর মান নির্দিষ্ট `value` এর সমান।
        ```css
        input[type="text"] { /* যে <input> ট্যাগের type অ্যাট্রিবিউটের মান "text" */
            border: 1px solid blue;
        }
        ```
    *   `[attribute~=value]`: যে এলিমেন্টে `attribute` এর মানে স্পেস দ্বারা পৃথক করা শব্দগুলোর মধ্যে নির্দিষ্ট `value` শব্দটি আছে।
        ```html
        <p class="text info warning">...</p>
        ```
        ```css
        p[class~="info"] { /* class অ্যাট্রিবিউটে "info" শব্দটি আছে */
            font-style: italic;
        }
        ```
    *   `[attribute|=value]`: যে এলিমেন্টে `attribute` এর মান নির্দিষ্ট `value` অথবা `value-` (হাইফেন সহ) দিয়ে শুরু। (ভাষা কোডের জন্য উপযোগী)
        ```html
        <p lang="en-US">Hello</p>
        <p lang="en-GB">Hello</p>
        <p lang="bn">হ্যালো</p>
        ```
        ```css
        p[lang|="en"] { /* lang অ্যাট্রিবিউট "en" অথবা "en-" দিয়ে শুরু */
            background-color: lightyellow;
        }
        ```
    *   `[attribute^=value]`: যে এলিমেন্টে `attribute` এর মান নির্দিষ্ট `value` দিয়ে শুরু।
        ```css
        a[href^="https://"] { /* href অ্যাট্রিবিউট "https://" দিয়ে শুরু (নিরাপদ লিঙ্ক) */
            text-decoration: underline dotted;
        }
        ```
    *   `[attribute$=value]`: যে এলিমেন্টে `attribute` এর মান নির্দিষ্ট `value` দিয়ে শেষ।
        ```css
        a[href$=".pdf"] { /* href অ্যাট্রিবিউট ".pdf" দিয়ে শেষ (পিডিএফ লিঙ্ক) */
            background-image: url("pdf-icon.png");
            padding-left: 20px;
        }
        ```
    *   `[attribute*=value]`: যে এলিমেন্টে `attribute` এর মানের যেকোনো অংশে নির্দিষ্ট `value` স্ট্রিংটি আছে।
        ```css
        a[href*="example.com"] { /* href অ্যাট্রিবিউটে "example.com" আছে */
            font-weight: bold;
        }
        ```
    *   অ্যাট্রিবিউট সিলেক্টরে কেস-সেনসিটিভিটি নিয়ন্ত্রণের জন্য `i` ফ্ল্যাগ ব্যবহার করা যায় (কিছু ব্রাউজারে): `[attribute=value i]`

### ২. গ্রুপিং সিলেক্টর (Grouping Selector)

একাধিক সিলেক্টরকে কমা (`,`) দিয়ে আলাদা করে গ্রুপ করা যায়, যাতে একই স্টাইল তাদের সবার উপর প্রয়োগ করা যায়।

```css
h1, h2, h3 {
    color: navy;
    font-family: Georgia, serif;
}

p, .note, #summary {
    line-height: 1.8;
}
```
*   **ব্যাখ্যা:** `h1`, `h2`, এবং `h3` সব এলিমেন্টের রঙ নেভি এবং ফন্ট ফ্যামিলি Georgia হবে।

### ৩. কম্বিনেটর (Combinators)

একাধিক সাধারণ সিলেক্টরকে একত্রিত করে তাদের মধ্যে সম্পর্ক স্থাপন করে।

*   **ডিসেন্ড্যান্ট সিলেক্টর (Descendant Selector) (স্পেস)**: প্রথম সিলেক্টরের ভেতরে থাকা (যেকোনো লেভেলে নেস্টেড) দ্বিতীয় সিলেক্টরের এলিমেন্ট সিলেক্ট করে।
    ```html
    <div class="container">
        <p>প্যারাগ্রাফ ১ (সরাসরি চাইল্ড)</p>
        <section>
            <p>প্যারাগ্রাফ ২ (নেস্টেড)</p>
        </section>
    </div>
    ```
    ```css
    .container p { /* ".container" ক্লাসের ভেতরে থাকা সব <p> এলিমেন্ট */
        color: green;
    }
    ```

*   **চাইল্ড সিলেক্টর (Child Selector) (`>`)**: প্রথম সিলেক্টরের সরাসরি চাইল্ড (direct child) দ্বিতীয় সিলেক্টরের এলিমেন্ট সিলেক্ট করে।
    ```html
    <ul id="main-list">
        <li>আইটেম ১ (সরাসরি চাইল্ড)</li>
        <li>
            আইটেম ২ (সরাসরি চাইল্ড)
            <ul> <!-- এটি #main-list এর সরাসরি চাইল্ড নয় -->
                <li>সাব-আইটেম ২.১</li>
            </ul>
        </li>
    </ul>
    ```
    ```css
    #main-list > li { /* "#main-list" এর সরাসরি চাইল্ড <li> এলিমেন্ট */
        font-weight: bold;
    }
    /* উপরের কোডটি "সাব-আইটেম ২.১" কে বোল্ড করবে না */
    ```

*   **অ্যাডজাসেন্ট সিবলিং সিলেক্টর (Adjacent Sibling Selector) (`+`)**: প্রথম সিলেক্টরের ঠিক পরেই (immediately following) থাকা একই প্যারেন্টের দ্বিতীয় সিলেক্টরের এলিমেন্ট সিলেক্ট করে।
    ```html
    <h2>শিরোনাম</h2>
    <p>প্রথম প্যারাগ্রাফ (শিরোনামের ঠিক পরে)</p>
    <p>দ্বিতীয় প্যারাগ্রাফ</p>
    <div>অন্য এলিমেন্ট</div>
    <p>তৃতীয় প্যারাগ্রাফ (div এর পরে)</p>
    ```
    ```css
    h2 + p { /* <h2> এর ঠিক পরে থাকা <p> এলিমেন্ট */
        color: red; /* "প্রথম প্যারাগ্রাফ" লাল হবে */
    }
    /* "দ্বিতীয় প্যারাগ্রাফ" এবং "তৃতীয় প্যারাগ্রাফ" লাল হবে না */
    ```

*   **জেনারেল সিবলিং সিলেক্টর (General Sibling Selector) (`~`)**: প্রথম সিলেক্টরের পরে থাকা (আবশ্যকভাবে ঠিক পরেই নয়) একই প্যারেন্টের দ্বিতীয় সিলেক্টরের সব এলিমেন্ট সিলেক্ট করে।
    ```html
    <h3>উপ-শিরোনাম</h3>
    <p>প্যারাগ্রাফ ক (উপ-শিরোনামের পরে)</p>
    <div>একটি ডিভ</div>
    <p>প্যারাগ্রাফ খ (উপ-শিরোনামের পরে, ডিভের পরে)</p>
    ```
    ```css
    h3 ~ p { /* <h3> এর পরে থাকা সব <p> এলিমেন্ট (একই প্যারেন্টের অধীনে) */
        font-style: italic; /* "প্যারাগ্রাফ ক" এবং "প্যারাগ্রাফ খ" ইটালিক হবে */
    }
    ```

### ৪. সিউডো-ক্লাস (Pseudo-classes)

এলিমেন্টের একটি নির্দিষ্ট অবস্থা (state) বা অবস্থান (position) সিলেক্ট করার জন্য ব্যবহৃত হয়। এগুলোর আগে একটি কোলন (`:`) থাকে।

*   **লিঙ্ক সিউডো-ক্লাস**:
    *   `:link` - এখনো ভিজিট করা হয়নি এমন লিঙ্ক।
    *   `:visited` - ইতোমধ্যে ভিজিট করা হয়েছে এমন লিঙ্ক।
    ```css
    a:link { color: blue; }
    a:visited { color: purple; }
    ```

*   **ইউজার অ্যাকশন সিউডো-ক্লাস**:
    *   `:hover` - মাউস পয়েন্টার যখন এলিমেন্টের উপর থাকে।
    *   `:active` - এলিমেন্টটি যখন সক্রিয় থাকে (যেমন লিঙ্কে ক্লিক করার মুহূর্তে)।
    *   `:focus` - এলিমেন্টটি যখন ফোকাস পায় (যেমন একটি ইনপুট ফিল্ডে ক্লিক করলে বা ট্যাব চেপে গেলে)।
    *   `:focus-visible` - কীবোর্ড নেভিগেশনের মাধ্যমে ফোকাস পেলে (মাউস ক্লিকের ফোকাস থেকে আলাদা করতে)।
    *   `:focus-within` - যদি এলিমেন্ট নিজে অথবা তার কোনো ডিসেন্ড্যান্ট ফোকাস পায়।
    ```css
    button:hover { background-color: lightgray; }
    a:active { color: red; }
    input:focus { border-color: orange; outline-color: orange; }
    .menu-item:focus-visible { box-shadow: 0 0 0 2px blue; }
    form:focus-within { background-color: #eef; }
    ```

*   **ইনপুট সিউডো-ক্লাস**: ফর্ম এলিমেন্টের অবস্থার উপর ভিত্তি করে।
    *   `:checked` - চেক করা রেডিও বাটন বা চেকবক্স।
    *   `:disabled` - নিষ্ক্রিয় (disabled) ফর্ম এলিমেন্ট।
    *   `:enabled` - সক্রিয় (enabled) ফর্ম এলিমেন্ট।
    *   `:required` - `required` অ্যাট্রিবিউট যুক্ত ইনপুট।
    *   `:optional` - `required` অ্যাট্রিবিউট নেই এমন ইনপুট।
    *   `:read-only` - `readonly` অ্যাট্রিবিউট যুক্ত ইনপুট।
    *   `:read-write` - `readonly` অ্যাট্রিবিউট নেই এমন ইনপুট।
    *   `:in-range` - মান যখন `min` এবং `max` অ্যাট্রিবিউটের মধ্যে থাকে।
    *   `:out-of-range` - মান যখন `min` এবং `max` অ্যাট্রিবিউটের বাইরে থাকে।
    *   `:valid` - ইনপুটের মান যখন বৈধ (যেমন ইমেইল ফরম্যাট সঠিক)।
    *   `:invalid` - ইনপুটের মান যখন অবৈধ।
    *   `:default` - ডিফল্টভাবে নির্বাচিত অপশন বা রেডিও/চেকবক্স।
    ```css
    input[type="checkbox"]:checked + label { font-weight: bold; }
    input:disabled { background-color: #eee; }
    input:required { border-left: 3px solid red; }
    input[type="number"]:in-range { background-color: lightgreen; }
    input[type="email"]:invalid { border-color: red; }
    ```

*   **কাঠামোগত সিউডো-ক্লাস (Structural Pseudo-classes)**: ডকুমেন্টের কাঠামোতে এলিমেন্টের অবস্থানের উপর ভিত্তি করে।
    *   `:root` - ডকুমেন্টের রুট এলিমেন্ট (সাধারণত `<html>`)। CSS ভ্যারিয়েবল সংজ্ঞায়িত করার জন্য ব্যবহৃত হয়।
    *   `:empty` - যে এলিমেন্টের কোনো চাইল্ড (টেক্সট নোড সহ) নেই।
    *   `:first-child` - তার প্যারেন্টের প্রথম চাইল্ড এলিমেন্ট।
    *   `:last-child` - তার প্যারেন্টের শেষ চাইল্ড এলিমেন্ট।
    *   `:only-child` - যে এলিমেন্ট তার প্যারেন্টের একমাত্র চাইল্ড।
    *   `:nth-child(n)` - তার প্যারেন্টের n-তম চাইল্ড। `n` হতে পারে একটি সংখ্যা (`1`, `2`), একটি কীওয়ার্ড (`even`, `odd`), অথবা একটি ফর্মুলা (`2n+1`, `3n`, `-n+5`)।
    *   `:nth-last-child(n)` - শেষ থেকে n-তম চাইল্ড।
    *   `:first-of-type` - তার প্যারেন্টের মধ্যে নির্দিষ্ট টাইপের প্রথম এলিমেন্ট।
    *   `:last-of-type` - তার প্যারেন্টের মধ্যে নির্দিষ্ট টাইপের শেষ এলিমেন্ট।
    *   `:only-of-type` - তার প্যারেন্টের মধ্যে নির্দিষ্ট টাইপের একমাত্র এলিমেন্ট।
    *   `:nth-of-type(n)` - তার প্যারেন্টের মধ্যে নির্দিষ্ট টাইপের n-তম এলিমেন্ট।
    *   `:nth-last-of-type(n)` - তার প্যারেন্টের মধ্যে নির্দিষ্ট টাইপের শেষ থেকে n-তম এলিমেন্ট।
    ```css
    :root { --main-color: blue; } /* CSS ভ্যারিয়েবল */
    p:empty { display: none; }
    ul li:first-child { color: green; }
    ul li:last-child { color: red; }
    tr:nth-child(odd) { background-color: #f2f2f2; } /* জেব্রা স্ট্রাইপিং */
    p:first-of-type { font-weight: bold; } /* প্রতিটি সেকশনের প্রথম প্যারাগ্রাফ */
    article h2:nth-of-type(2n) { /* প্রতিটি আর্টিকেলের জোড় সংখ্যার h2 */
        border-bottom: 1px solid #ccc;
    }
    ```

*   **নেগেশন সিউডো-ক্লাস (`:not(selector)`)**: যে এলিমেন্টগুলো বন্ধনীর ভেতরের সিলেক্টরের সাথে মেলে না, তাদের সিলেক্ট করে।
    ```css
    p:not(.special) { /* যে প্যারাগ্রাফগুলোর "special" ক্লাস নেই */
        color: gray;
    }
    input:not([type="submit"]) { /* সাবমিট বাটন ছাড়া অন্য সব ইনপুট */
        margin-bottom: 10px;
    }
    ```

*   **ভাষা সিউডো-ক্লাস (`:lang(language-code)`)**: নির্দিষ্ট `lang` অ্যাট্রিবিউট যুক্ত এলিমেন্ট সিলেক্ট করে।
    ```css
    p:lang(bn) { /* বাংলা ভাষার প্যারাগ্রাফ */
        font-family: "SolaimanLipi", Arial, sans-serif;
    }
    ```

*   **টার্গেট সিউডো-ক্লাস (`:target`)**: URL এর ফ্র্যাগমেন্ট আইডেন্টিফায়ার (হ্যাশ `#` এর পরের অংশ) দ্বারা নির্দেশিত এলিমেন্ট সিলেক্ট করে।
    ```html
    <a href="#section2">সেকশন ২ এ যান</a>
    <div id="section2">এটি সেকশন ২।</div>
    ```
    ```css
    :target { /* যখন URL এ #section2 থাকবে, তখন এই ডিভটি হাইলাইট হবে */
        background-color: lightyellow;
        border: 1px solid gold;
    }
    ```

### ৫. সিউডো-এলিমেন্ট (Pseudo-elements)

এগুলো একটি সিলেক্টরের সাথে যুক্ত হয়ে এলিমেন্টের একটি নির্দিষ্ট অংশকে স্টাইল করতে দেয়, যা ডকুমেন্টে শারীরিকভাবে বিদ্যমান নাও থাকতে পারে। এগুলোর আগে দুটি কোলন (`::`) থাকে (পুরনো ব্রাউজারের জন্য একটি কোলনও কাজ করে)।

*   `::before`: সিলেক্ট করা এলিমেন্টের কন্টেন্টের *আগে* একটি ছদ্ম-এলিমেন্ট তৈরি করে। `content` প্রপার্টি আবশ্যক।
*   `::after`: সিলেক্ট করা এলিমেন্টের কন্টেন্টের *পরে* একটি ছদ্ম-এলিমেন্ট তৈরি করে। `content` প্রপার্টি আবশ্যক।
    ```css
    p.important::before {
        content: "গুরুত্বপূর্ণ: ";
        color: red;
        font-weight: bold;
    }
    a.external::after {
        content: " ↗"; /* একটি তীর চিহ্ন যোগ করে */
        font-size: 0.8em;
    }
    ```

*   `::first-letter`: একটি ব্লক-লেভেল এলিমেন্টের প্রথম অক্ষরকে সিলেক্ট করে (ড্রপ ক্যাপ তৈরির জন্য)।
    ```css
    p.drop-cap::first-letter {
        font-size: 3em;
        float: left;
        margin-right: 0.1em;
        line-height: 0.8;
    }
    ```

*   `::first-line`: একটি ব্লক-লেভেল এলিমেন্টের প্রথম লাইনকে সিলেক্ট করে।
    ```css
    p.intro::first-line {
        font-weight: bold;
        color: darkblue;
    }
    ```

*   `::selection`: ব্যবহারকারী কর্তৃক সিলেক্ট করা (হাইলাইট করা) টেক্সটের অংশকে স্টাইল করে।
    ```css
    ::selection {
        background-color: gold;
        color: black;
    }
    ```

*   `::marker`: লিস্ট আইটেমের মার্কার (বুলেট বা নম্বর) সিলেক্ট করে (`<ul>`, `<ol>`, `<summary>`)।
    ```css
    ul li::marker {
        color: green;
        font-size: 1.2em;
    }
    ol li::marker {
        content: counter(list-item) ") "; /* কাস্টম মার্কার */
        font-weight: bold;
    }
    ```

*   `::placeholder`: ফর্ম ইনপুট ফিল্ডের প্লেসহোল্ডার টেক্সটকে স্টাইল করে।
    ```css
    input::placeholder {
        color: lightgray;
        font-style: italic;
    }
    ```

**সিলেক্টরের স্পেসিফিসিটি (Specificity):**

একাধিক CSS নিয়ম যখন একই এলিমেন্টের উপর প্রযোজ্য হয়, তখন ব্রাউজার কোন নিয়মটি ব্যবহার করবে তা নির্ধারণের জন্য স্পেসিফিসিটি গণনা করে। সাধারণত:

1.  ইনলাইন স্টাইল (HTML `style` অ্যাট্রিবিউট) - সর্বোচ্চ স্পেসিফিসিটি
2.  আইডি সিলেক্টর (`#id`)
3.  ক্লাস সিলেক্টর (`.class`), অ্যাট্রিবিউট সিলেক্টর (`[attr]`), সিউডো-ক্লাস (`:hover`)
4.  টাইপ সিলেক্টর (`p`, `div`), সিউডো-এলিমেন্ট (`::before`)
5.  ইউনিভার্সাল সিলেক্টর (`*`), কম্বিনেটর (`+`, `>`, `~`, স্পেস), নেগেশন সিউডো-ক্লাস (`:not()`) স্পেসিফিসিটি গণনাকে প্রভাবিত করে না, তবে তাদের ভেতরের আর্গুমেন্ট করে।

`!important` রুল ব্যবহার করে যেকোনো স্পেসিফিসিটিকে ওভাররাইড করা যায়, তবে এটি সাধারণত পরিহার করা উচিত কারণ এটি ডিবাগিং কঠিন করে তোলে।

সঠিক এবং কার্যকর সিলেক্টর ব্যবহার করা CSS লেখার একটি গুরুত্বপূর্ণ অংশ, যা কোডকে আরও পরিচ্ছন্ন, রক্ষণাবেক্ষণযোগ্য এবং পারফরম্যান্ট করে তোলে। 


CSS selectors are used to target HTML elements for styling. Below is a comprehensive list of CSS selectors with examples explained in Bangla for clarity. Each selector type is accompanied by a brief description and a practical example in Bangla to help you understand how it works.

---

### **CSS Selector-এর পূর্ণ তালিকা (Full List of CSS Selectors)**

#### **1. Universal Selector (`*`)**
- **বর্ণনা**: সব HTML এলিমেন্ট নির্বাচন করে।
- **উদাহরণ**:
  ```html
  <p>এটি একটি প্যারাগ্রাফ</p>
  <div>এটি একটি ডিভ</div>
  ```
  ```css
  * {
    color: blue;
  }
  ```
  **ব্যাখ্যা**: উপরের কোডে, ওয়েব পেজের সব এলিমেন্টের টেক্সট নীল রঙের হবে।

#### **2. Element/Type Selector / Tags**
- **বর্ণনা**: নির্দিষ্ট HTML ট্যাগ নির্বাচন করে।
- **উদাহরণ**:
  ```html
  <h1>শিরোনাম</h1>
  <p>এটি একটি প্যারাগ্রাফ</p>
  ```
  ```css
  p {
    font-size: 16px;
  }
  ```
  **ব্যাখ্যা**: এখানে শুধু `<p>` ট্যাগের টেক্সটের ফন্ট সাইজ ১৬ পিক্সেল হবে।

#### **3. Class Selector (`.class`)**
- **বর্ণনা**: নির্দিষ্ট ক্লাসের এলিমেন্ট নির্বাচন করে।
- **উদাহরণ**:
  ```html
  <p class="highlight">এটি হাইলাইট করা টেক্সট</p>
  <div class="highlight">এটি হাইলাইট করা ডিভ</div>
  ```
  ```css
  .highlight {
    background-color: yellow;
  }
  ```
  **ব্যাখ্যা**: `highlight` ক্লাসযুক্ত সব এলিমেন্টের ব্যাকগ্রাউন্ড হলুদ হবে।

#### **4. ID Selector (`#id`)**
- **বর্ণনা**: নির্দিষ্ট আইডি-যুক্ত এলিমেন্ট নির্বাচন করে।
- **উদাহরণ**:
  ```html
  <div id="header">এটি হেডার</div>
  ```
  ```css
  #header {
    background-color: green;
  }
  ```
  **ব্যাখ্যা**: `header` আইডি-যুক্ত এলিমেন্টের ব্যাকগ্রাউন্ড সবুজ হবে।

#### **5. Attribute Selector (`[attribute]`)**
- **বর্ণনা**: নির্দিষ্ট অ্যাট্রিবিউট বা অ্যাট্রিবিউট মানের এলিমেন্ট নির্বাচন করে।
- **উদাহরণ**:
  ```html
  <a href="https://example.com">লিঙ্ক</a>
  <input type="text" placeholder="নাম লিখুন">
  ```
  ```css
  [href] {
    color: red;
  }
  [type="text"] {
    border: 1px solid black;
  }
  ```
  **ব্যাখ্যা**: `href` অ্যাট্রিবিউটযুক্ত লিঙ্কের টেক্সট লাল হবে, এবং `type="text"` অ্যাট্রিবিউটযুক্ত ইনপুটের বর্ডার কালো হবে।

#### **6. Descendant Selector (`ancestor descendant`)**
- **বর্ণনা**: কোনো এলিমেন্টের ভেতরের সব নির্দিষ্ট এলিমেন্ট নির্বাচন করে।
- **উদাহরণ**:
  ```html
  <div class="container">
    <p>এটি কন্টেইনারের ভেতরের প্যারাগ্রাফ</p>
  </div>
  ```
  ```css
  .container p {
    color: purple;
  }
  ```
  **ব্যাখ্যা**: `container` ক্লাসের ভেতরের সব `<p>` ট্যাগের টেক্সট বেগুনি হবে।

#### **7. Child Selector (`parent > child`)**
- **বর্ণনা**: শুধুমাত্র সরাসরি চাইল্ড এলিমেন্ট নির্বাচন করে।
- **উদাহরণ**:
  ```html
  <div class="container">
    <p>সরাসরি চাইল্ড</p>
    <div><p>চাইল্ড নয়</p></div>
  </div>
  ```
  ```css
  .container > p {
    font-weight: bold;
  }
  ```
  **ব্যাখ্যা**: `container` ক্লাসের সরাসরি `<p>` চাইল্ডের টেক্সট বোল্ড হবে, কিন্তু ভেতরের ডিভের `<p>` প্রভাবিত হবে না।

#### **8. Adjacent Sibling Selector (`element + element`)**
- **বর্ণনা**: একটি এলিমেন্টের ঠিক পরের সিবলিং এলিমেন্ট নির্বাচন করে।
- **উদাহরণ**:
  ```html
  <h2>শিরোনাম</h2>
  <p>এটি সিবলিং প্যারাগ্রাফ</p>
  ```
  ```css
  h2 + p {
    color: orange;
  }
  ```
  **ব্যাখ্যা**: `<h2>` এর ঠিক পরের `<p>` ট্যাগের টেক্সট কমলা হবে।

#### **9. General Sibling Selector (`element ~ element`)**
- **বর্ণনা**: একটি এলিমেন্টের পরে একই প্যারেন্টের সব সিবলিং এলিমেন্ট নির্বাচন করে।
- **উদাহরণ**:
  ```html
  <h2>শিরোনাম</h2>
  <p>প্রথম প্যারাগ্রাফ</p>
  <p>দ্বিতীয় প্যারাগ্রাফ</p>
  ```
  ```css
  h2 ~ p {
    background-color: lightgray;
  }
  ```
  **ব্যাখ্যা**: `<h2>` এর পরে একই প্যারেন্টের সব `<p>` ট্যাগের ব্যাকগ্রাউন্ড হালকা ধূসর হবে।

#### **10. Pseudo-Class Selector (`:pseudo-class`)**
- **বর্ণনা**: এলিমেন্টের নির্দিষ্ট অবস্থা নির্বাচন করে (যেমন, হোভার, ফোকাস)।
- **উদাহরণ**:
  ```html
  <a href="#">লিঙ্কে ক্লিক করুন</a>
  ```
  ```css
  a:hover {
    color: green;
  }
  ```
  **ব্যাখ্যা**: মাউস লিঙ্কের উপর হোভার করলে টেক্সট সবুজ হবে।

#### **11. Pseudo-Element Selector (`::pseudo-element`)**
- **বর্ণনা**: এলিমেন্টের নির্দিষ্ট অংশ নির্বাচন করে (যেমন, প্রথম অক্ষর, প্রথম লাইন)।
- **উদাহরণ**:
  ```html
  <p>এটি একটি প্যারাগ্রাফ।</p>
  ```
  ```css
  p::first-letter {
    font-size: 24px;
  }
  ```
  **ব্যাখ্যা**: প্যারাগ্রাফের প্রথম অক্ষরের ফন্ট সাইজ ২৪ পিক্সেল হবে।

#### **12. Grouping Selector (`,`)**
- **বর্ণনা**: একাধিক সিলেক্টরকে একত্রে স্টাইল করতে ব্যবহৃত হয়।
- **উদাহরণ**:
  ```html
  <h1>শিরোনাম</h1>
  <p>প্যারাগ্রাফ</p>
  <div>ডিভ</div>
  ```
  ```css
  h1, p, div {
    border: 1px solid blue;
  }
  ```
  **ব্যাখ্যা**: `<h1>`, `<p>`, এবং `<div>` সবগুলোর বর্ডার নীল হবে।

#### **13. Attribute Value Selector (`[attribute="value"]`)**
- **বর্ণনা**: নির্দিষ্ট অ্যাট্রিবিউট এবং তার মানের উপর ভিত্তি করে এলিমেন্ট নির্বাচন করে।
- **উদাহরণ**:
  ```html
  <input type="submit" value="জমা দিন">
  ```
  ```css
  [type="submit"] {
    background-color: blue;
    color: white;
  }
  ```
  **ব্যাখ্যা**: `type="submit"` অ্যাট্রিবিউটযুক্ত ইনপুটের ব্যাকগ্রাউন্ড নীল এবং টেক্সট সাদা হবে।

#### **14. Attribute Contains Selector (`[attribute*="value"]`)**
- **বর্ণনা**: অ্যাট্রিবিউটের মানে নির্দিষ্ট স্ট্রিং থাকলে নির্বাচন করে।
- **উদাহরণ**:
  ```html
  <a href="https://example.com">লিঙ্ক</a>
  ```
  ```css
  [href*="example"] {
    font-style: italic;
  }
  ```
  **ব্যাখ্যা**: `href` অ্যাট্রিবিউটে "example" শব্দ থাকলে টেক্সট ইটালিক হবে।

#### **15. Attribute Starts With Selector (`[attribute^="value"]`)**
- **বর্ণনা**: অ্যাট্রিবিউটের মান নির্দিষ্ট স্ট্রিং দিয়ে শুরু হলে নির্বাচন করে।
- **উদাহরণ**:
  ```html
  <a href="https://example.com">লিঙ্ক</a>
  ```
  ```css
  [href^="https"] {
    color: green;
  }
  ```
  **ব্যাখ্যা**: `href` অ্যাট্রিবিউট যদি "https" দিয়ে শুরু হয়, তবে টেক্সট সবুজ হবে।

#### **16. Attribute Ends With Selector (`[attribute$="value"]`)**
- **বর্ণনা**: অ্যাট্রিবিউটের মান নির্দিষ্ট স্ট্রিং দিয়ে শেষ হলে নির্বাচন করে।
- **উদাহরণ**:
  ```html
  <a href="file.pdf">ডাউনলোড</a>
  ```
  ```css
  [href$=".pdf"] {
    color: red;
  }
  ```
  **ব্যাখ্যা**: `href` অ্যাট্রিবিউট যদি ".pdf" দিয়ে শেষ হয়, তবে টেক্সট লাল হবে।

#### **17. :not() Selector**
- **বর্ণনা**: নির্দিষ্ট শর্তের বিপরীত এলিমেন্ট নির্বাচন করে।
- **উদাহরণ**:
  ```html
  <p>প্যারাগ্রাফ ১</p>
  <p class="special">প্যারাগ্রাফ ২</p>
  ```
  ```css
  p:not(.special) {
    color: gray;
  }
  ```
  **ব্যাখ্যা**: `special` ক্লাস ছাড়া সব `<p>` ট্যাগের টেক্সট ধূসর হবে।

#### **18. :nth-child() Selector**
- **বর্ণনা**: নির্দিষ্ট অবস্থানের চাইল্ড এলিমেন্ট নির্বাচন করে।
- **উদাহরণ**:
  ```html
  <ul>
    <li>আইটেম ১</li>
    <li>আইটেম ২</li>
    <li>আইটেম ৩</li>
  </ul>
  ```
  ```css
  li:nth-child(2) {
    color: blue;
  }
  ```
  **ব্যাখ্যা**: তালিকার দ্বিতীয় `<li>` এলিমেন্টের টেক্সট নীল হবে।

#### **19. :first-child Selector**
- **বর্ণনা**: প্যারেন্টের প্রথম চাইল্ড এলিমেন্ট নির্বাচন করে।
- **উদাহরণ**:
  ```html
  <div>
    <p>প্রথম প্যারাগ্রাফ</p>
    <p>দ্বিতীয় প্যারাগ্রাফ</p>
  </div>
  ```
  ```css
  p:first-child {
    font-weight: bold;
  }
  ```
  **ব্যাখ্যা**: প্রথম `<p>` ট্যাগের টেক্সট বোল্ড হবে।

#### **20. :last-child Selector**
- **বর্ণনা**: প্যারেন্টের শেষ চাইল্ড এলিমেন্ট নির্বাচন করে।
- **উদাহরণ**:
  ```html
  <div>
    <p>প্রথম প্যারাগ্রাফ</p>
    <p>শেষ প্যারাগ্রাফ</p>
  </div>
  ```
  ```css
  p:last-child {
    color: red;
  }
  ```
  **ব্যাখ্যা**: শেষ `<p>` ট্যাগের টেক্সট লাল হবে।

---

### **অতিরিক্ত নোট**
- উপরের সিলেক্টরগুলো CSS-এর সবচেয়ে সাধারণ এবং গুরুত্বপূর্ণ সিলেক্টর। এগুলো ব্যবহার করে আপনি ওয়েব পেজের যেকোনো এলিমেন্টকে নির্দিষ্টভাবে স্টাইল করতে পারেন।
- **প্র্যাকটিস টিপ**: প্রতিটি সিলেক্টর ব্যবহার করে ছোট ছোট HTML ও CSS ফাইল তৈরি করে পরীক্ষা করুন। এতে আপনার ধারণা আরও পরিষ্কার হবে।
- যদি কোনো নির্দিষ্ট সিলেক্টর নিয়ে আরও বিস্তারিত জানতে চান, তাহলে বলুন, আমি আরও গভীরভাবে ব্যাখ্যা করব।

আপনার কি কোনো নির্দিষ্ট সিলেক্টরের উদাহরণ বা আরও ব্যাখ্যা প্রয়োজন?


----

CSS complex selectors are advanced selectors that combine multiple simple selectors (like element, class, or ID selectors) to target HTML elements with greater specificity and flexibility. These selectors are essential for precise styling in complex web layouts. Below is a full list of CSS complex selectors, each with a description and an example explained in Bangla to make it clear and practical.

---

### **CSS Complex Selector-এর পূর্ণ তালিকা (Full List of CSS Complex Selectors)**

Complex selectors are combinations of simple selectors, pseudo-classes, pseudo-elements, or other conditions to target elements more precisely. Here’s the list:

#### **1. Descendant Selector (`ancestor descendant`)**
- **বর্ণনা**: একটি এলিমেন্টের ভেতরে (নেস্টেড) থাকা সব নির্দিষ্ট এলিমেন্ট নির্বাচন করে, এমনকি গভীরভাবে নেস্টেড হলেও।
- **উদাহরণ**:
  ```html
  <div class="container">
    <p>এটি কন্টেইনারের ভেতরের প্যারাগ্রাফ</p>
    <div>
      <p>এটি গভীরভাবে নেস্টেড প্যারাগ্রাফ</p>
    </div>
  </div>
  ```
  ```css
  .container p {
    color: blue;
  }
  ```
  **ব্যাখ্যা**: `container` ক্লাসের ভেতরে থাকা সব `<p>` ট্যাগের টেক্সট নীল হবে, এমনকি গভীরভাবে নেস্টেড থাকলেও।

#### **2. Child Selector (`parent > child`)**
- **বর্ণনা**: শুধুমাত্র সরাসরি চাইল্ড এলিমেন্ট নির্বাচন করে। গভীরভাবে নেস্টেড এলিমেন্ট প্রভাবিত হয় না।
- **উদাহরণ**:
  ```html
  <div class="container">
    <p>সরাসরি চাইল্ড প্যারাগ্রাফ</p>
    <div>
      <p>নেস্টেড প্যারাগ্রাফ</p>
    </div>
  </div>
  ```
  ```css
  .container > p {
    font-weight: bold;
  }
  ```
  **ব্যাখ্যা**: `container` ক্লাসের সরাসরি `<p>` চাইল্ডের টেক্সট বোল্ড হবে, কিন্তু নেস্টেড `<p>` প্রভাবিত হবে না।

#### **3. Adjacent Sibling Selector (`element + element`)**
- **বর্ণনা**: একটি এলিমেন্টের ঠিক পরবর্তী সিবলিং এলিমেন্ট নির্বাচন করে, যদি তারা একই প্যারেন্টের মধ্যে থাকে।
- **উদাহরণ**:
  ```html
  <h2>শিরোনাম</h2>
  <p>এটি সিবলিং প্যারাগ্রাফ</p>
  <p>এটি আরেকটি প্যারাগ্রাফ</p>
  ```
  ```css
  h2 + p {
    color: orange;
  }
  ```
  **ব্যাখ্যা**: `<h2>` এর ঠিক পরবর্তী `<p>` ট্যাগের টেক্সট কমলা হবে। অন্য `<p>` প্রভাবিত হবে না।

#### **4. General Sibling Selector (`element ~ element`)**
- **বর্ণনা**: একটি এলিমেন্টের পরে একই প্যারেন্টের সব সিবলিং এলিমেন্ট নির্বাচন করে।
- **উদাহরণ**:
  ```html
  <h2>শিরোনাম</h2>
  <p>প্রথম প্যারাগ্রাফ</p>
  <div>ডিভ</div>
  <p>দ্বিতীয় প্যারাগ্রাফ</p>
  ```
  ```css
  h2 ~ p {
    background-color: lightgray;
  }
  ```
  **ব্যাখ্যা**: `<h2>` এর পরে একই প্যারেন্টের সব `<p>` ট্যাগের ব্যাকগ্রাউন্ড হালকা ধূসর হবে।

#### **5. Attribute Selector with Combinators**
- **বর্ণনা**: অ্যাট্রিবিউট সিলেক্টরকে অন্য সিলেক্টরের সাথে মিলিয়ে ব্যবহার করা যায়।
- **উদাহরণ**:
  ```html
  <div class="container">
    <a href="https://example.com">লিঙ্ক ১</a>
    <a href="http://example.com">লিঙ্ক ২</a>
  </div>
  ```
  ```css
  .container a[href^="https"] {
    color: green;
  }
  ```
  **ব্যাখ্যা**: `container` ক্লাসের ভেতরে `href` অ্যাট্রিবিউট যেগুলো "https" দিয়ে শুরু হয়, সেগুলোর টেক্সট সবুজ হবে।

#### **6. Pseudo-Class with Combinators**
- **বর্ণনা**: পিউডো-ক্লাস (যেমন `:hover`, `:nth-child`) অন্য সিলেক্টরের সাথে মিলিয়ে জটিল নির্বাচন তৈরি করে।
- **উদাহরণ**:
  ```html
  <ul class="menu">
    <li>আইটেম ১</li>
    <li>আইটেম ২</li>
    <li>আইটেম ৩</li>
  </ul>
  ```
  ```css
  .menu li:nth-child(odd) {
    background-color: lightblue;
  }
  ```
  **ব্যাখ্যা**: `menu` ক্লাসের তালিকায় বিজোড় অবস্থানের `<li>` (১ম, ৩য়) এলিমেন্টের ব্যাকগ্রাউন্ড হালকা নীল হবে।

#### **7. Pseudo-Element with Combinators**
- **বর্ণনা**: পিউডো-এলিমেন্ট (যেমন `::first-letter`, `::before`) অন্য সিলেক্টরের সাথে মিলিয়ে নির্দিষ্ট অংশ স্টাইল করে।
- **উদাহরণ**:
  ```html
  <div class="content">
    <p>এটি একটি প্যারাগ্রাফ।</p>
  </div>
  ```
  ```css
  .content p::first-letter {
    font-size: 24px;
    color: red;
  }
  ```
  **ব্যাখ্যা**: `content` ক্লাসের ভেতরের `<p>` ট্যাগের প্রথম অক্ষরের ফন্ট সাইজ ২৪ পিক্সেল এবং রঙ লাল হবে।

#### **8. Multiple Selector Combination**
- **বর্ণনা**: একাধিক সিলেক্টর (ক্লাস, আইডি, এলিমেন্ট) একত্রে মিলিয়ে আরও নির্দিষ্ট নির্বাচন করে।
- **উদাহরণ**:
  ```html
  <div class="container">
    <h2 class="highlight" id="main-title">প্রধান শিরোনাম</h2>
  </div>
  ```
  ```css
  .container h2.highlight#main-title {
    color: purple;
  }
  ```
  **ব্যাখ্যা**: `container` ক্লাসের ভেতরে `highlight` ক্লাস এবং `main-title` আইডি সম্পন্ন `<h2>` ট্যাগের টেক্সট বেগুনি হবে।

#### **9. :not() with Combinators**
- **বর্ণনা**: `:not()` পিউডো-ক্লাসের সাথে অন্য সিলেক্টর মিলিয়ে বিপরীত শর্তে এলিমেন্ট নির্বাচন করে।
- **উদাহরণ**:
  ```html
  <div class="container">
    <p class="special">বিশেষ প্যারাগ্রাফ</p>
    <p>সাধারণ প্যারাগ্রাফ</p>
  </div>
  ```
  ```css
  .container p:not(.special) {
    color: gray;
  }
  ```
  **ব্যাখ্যা**: `container` ক্লাসের ভেতরে `special` ক্লাস ছাড়া সব `<p>` ট্যাগের টেক্সট ধূসর হবে।

#### **10. :where() Selector**
- **বর্ণনা**: একটি সিলেক্টর গ্রুপের মধ্যে শর্ত মিলে যাওয়া এলিমেন্ট নির্বাচন করে।
- **উদাহরণ**:
  ```html
  <div class="container">
    <p class="text">টেক্সট ১</p>
    <p class="highlight">টেক্সট ২</p>
  </div>
  ```
  ```css
  .container :where(.text, .highlight) {
    font-style: italic;
  }
  ```
  **ব্যাখ্যা**: `container` ক্লাসের ভেতরে `text` বা `highlight` ক্লাসযুক্ত সব এলিমেন্টের টেক্সট ইটালিক হবে।

#### **11. :is() Selector**
- **বর্ণনা**: একাধিক সিলেক্টরের মধ্যে যেকোনো একটির সাথে মিলে গেলে এলিমেন্ট নির্বাচন করে। `:where()`-এর মতো, কিন্তু আরও সুবিধাজনক।
- **উদাহরণ**:
  ```html
  <section>
    <h1>শিরোনাম</h1>
    <p>প্যারাগ্রাফ</p>
    <div>ডিভ</div>
  </section>
  ```
  ```css
  section :is(h1, p) {
    color: blue;
  }
  ```
  **ব্যাখ্যা**: `<section>` এর ভেতরে `<h1>` এবং `<p>` ট্যাগের টেক্সট নীল হবে।

#### **12. Nested Combinators**
- **বর্ণনা**: একাধিক কম্বিনেটর (যেমন চাইল্ড, ডেসেন্ডেন্ট) একত্রে ব্যবহার করে জটিল নির্বাচন তৈরি করে।
- **উদাহরণ**:
  ```html
  <div class="container">
    <article>
      <p class="intro">ভূমিকা</p>
    </article>
  </div>
  ```
  ```css
  .container > article > p.intro {
    font-size: 18px;
  }
  ```
  **ব্যাখ্যা**: `container` ক্লাসের সরাসরি `<article>` চাইল্ডের সরাসরি `<p>` চাইল্ডের মধ্যে `intro` ক্লাসযুক্ত এলিমেন্টের ফন্ট সাইজ ১৮ পিক্সেল হবে।

#### **13. :has() Selector (Experimental)**
- **বর্ণনা**: এমন এলিমেন্ট নির্বাচন করে যার ভেতরে নির্দিষ্ট শর্তের এলিমেন্ট থাকে। (ব্রাউজার সাপোর্ট সীমিত হতে পারে)।
- **উদাহরণ**:
  ```html
  <div>
    <p>প্যারাগ্রাফ</p>
  </div>
  <div>
    <h3>শিরোনাম</h3>
  </div>
  ```
  ```css
  div:has(p) {
    border: 1px solid red;
  }
  ```
  **ব্যাখ্যা**: যে `<div>` এর ভেতরে `<p>` আছে, সেটির বর্ডার লাল হবে।

