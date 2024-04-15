JSON stands for **J**ava**S**cript **O**bject **N**otation

JSON is a **text format** for storing and transporting data

JSON is "self-describing" and easy to understand

## JSON Example
```JSON
'{"name":"John", "age":30, "car":null}'
```
JavaScript has a built in function for converting JSON strings into JavaScript objects:

`JSON.parse()`

JavaScript also has a built in function for converting an object into a JSON string:

`JSON.stringify()`


# JSON Syntax

## JSON Syntax Rules

JSON syntax is derived from JavaScript object notation syntax:

- Data is in name/value pairs
- Data is separated by commas
- Curly braces hold objects
- Square brackets hold arrays

---

## JSON Data - A Name and a Value

JSON data is written as name/value pairs (aka key/value pairs).

A name/value pair consists of a field name (in double quotes), followed by a colon, followed by a value:

```json
{"name":"John"}
{name:"John"}
```
## JSON Values

In **JSON**, _values_ must be one of the following data types:

- a string
- a number
- an object
- an array
- a boolean
- null

In **JavaScript** values can be all of the above, plus any other valid JavaScript expression, including:

- a function
- a date
- undefined

In JSON, _string values_ must be written with double quotes:

```json
person = {name:"John", age:31, city:"New York"};
```
## Valid Data Types

```json
// string 
{"name":"John"}
//## JSON Numbers
{"age":30}
//json object 
{  
"employee":{"name":"John", "age":30, "city":"New York"}  
}
// JSON Arrays
{  
"employees":["John", "Anna", "Peter"]  
}
// JSON Booleans
{"sale":true}

//Json Null
{"middlename":null}


```

# `JSON.parse()`

```js

'{"name":"John", "age":30, "city":"New York"}'

 // Use the JavaScript function `JSON.parse()` to convert text into a JavaScript object:
const obj = JSON.parse('{"name":"John", "age":30, "city":"New York"}');
```
Make sure the text is in JSON format, or else you will get a syntax error.

## Array as JSON

```js
const text = '["Ford", "BMW", "Audi", "Fiat"]';  
const myArr = JSON.parse(text)
```

# `JSON.stringify()`

```js
const obj = {name: "John", age: 30, city: "New York"};
```
Use the JavaScript function `JSON.stringify()` to convert it into a string.

```js
const myJSON = JSON.stringify(obj);
```
The result will be a string following the JSON notation.

`myJSON` is now a string, and ready to be sent to a server:

