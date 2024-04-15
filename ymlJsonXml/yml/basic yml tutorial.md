
## Single or Inline Comments in YAML
```Yaml
#  comments Syntax example in YAML file

or
#### comments example
```

## Array 

Here is an example with  array declaration.


```YAML
# comments for array declaration
key1:
   value1 # Arry element
  - value2
  - value3
  - value4
  - value5
```

# YAML - Array & collection

YAML Array list, Objects, strings, numbers, indented styles, dictionaries flow mapping, and block mappings empty arrays and sequences.

This tutorial explains How to represent different array data structures in YAML content formats.

- Array of Scalar Items
- Nested Array
- Array of objects
- String array
- Object with values as an arrays
- empty array and objects
- sequence of elements
- Dictionary of elements
## YAML Array of scalar items

An array is a group of similar values with a single name. In YAML, an Array represents a single key mapped to multiple values. Each value starts with a hyphen `-` symbol followed by a space.

Here is a syntax for `yaml arrays`.
```YAML
key1:
  - value1
  - value2
  - value3
  - value4
  - value5
```

Another way to rewrite in a single line, using square brackets syntax

Multiple values are represented and separated by commas enclosed in square brackets.

```Yaml
key1: [value1,value2,value3,value4,value5]
```

```YAML
key1: [value1,value2
  value3,value4,value5]
```

The json representation is as below.
```JSON
{
  "key1": [
    "value1",
    "value2",
    "value3",
    "value4",
    "value5"
  ]
}
```

## YAML Documents of Arrays without keys

Another way, without a key, arrays can be represented in a single line using square brackets

```Yaml
 [one, two, three, four]
```

or can also be declared in a single line.

```yaml
- one
- two
- three
- four
```

Equivalent JSON is for the above arrays.

```JSON
 [
  "one",
  "two",
  "three",
  "four"
]
```

## YAML Arrays of Objects

Objects contain multiple key and value pairs. An array of objects contains an object list.

Here is a code for the `YAML array of objects example`

```yaml
one:
  - id: 1
    name: franc
  - id: 11
    name: Tom
```

The same above can be the YAML equivalent of the array of objects example as follows.

```Json
{
  "one": [
    {
      "id": 1,
      "name": "franc"
    },
    {
      "id": 11,
      "name": "Tom"
    }
  ]
}
```

## YAML Nested Arrays Examples

Arrays of Arrays are also called multi-dimensional arrays or nested arrays.

YAML nested arrays can be represented in multiple ways.

- use `indentation syntax` as below.

```Yaml
employees:
    -
        id: 213
        name: franc
        others:
            - { department: sales, did: 1}
            - { salary: 5000}
            - { address: USA, pincode: 97845 }
```

equivalent JSON is

```JSON
{
  "employees": [
    {
      "id": 213,
      "name": "franc",
      "others": [
        {
          "department": "sales",
          "did": 1
        },
        {
          "Salary": 5000
        },
        {
          "address": "USA",
          "pincode": 97845
        }
      ]
    }
  ]
}
```

## Arrays of String in YAML

Strings contain a group of characters. It is a scalar type in yaml.

Keys in the string array are optional in YAML. Here is an example of an array of strings with keys.

```Yaml
numbers: [
  one,
  two,
  three,
  four
]
```

Here is an example array of strings without a key

```Yaml
[
  one,
  two,
  three,
  four
]
```

## Arrays of numbers in YAML

Numbers are predefined scalar types in yaml. It accepts integer or floating numbers.

An array of numbers or mixed numbers also can be represented as follows

```YAML
numbers: [
  1,
  2,
  3,
  4
]
```

## Yaml objects with arrays

The object contains key and value pairs. Value can be scalar or an array of scalar items.

```yaml
author: Franc
database:
  driver: com.mysql.jdbc.Driver
  port: 3306
  dbname: students
  username: root
  password: root
support:
  - mysql
  - MongoDB
  - Postgres
```

Equivalent JSOn is

```json
{
  "author": "Franc",
  "database": {
    "driver": "com.mysql.jdbc.Driver",
    "port": 3306,
    "dbname": "students",
    "username": "root",
    "password": "root"
  },
  "support": [
    "mysql",
    "MongoDB",
    "Postgres"
  ]
}
```
## dictionary in yaml example

the dictionary contains keys and values.

In Yaml Dictionary can be represented in two syntaxes.

- Flow mapping
- Block mapping

`Flow mapping dictionary`:

In this, key and value pairs are separated by a comma, and entire pairs are enclosed in `{}` characters.

Here is a syntax for Dictionary Flow Mapping

```Yaml
# dictionary
  mysqldatabase":{
    hostname: localhost,
    port: 3012, username:root,
    password: root
    }
```

`Block mapping Dictionary`: In this key and value pairs are represented using colon `:` Syntax

Following is an example of dictionary Block mapping types of data.

```Yaml
# dictionary
  mysqldatabase:
    hostname: localhost
    port: 3012
    username: root
    password: root
```
Equivalent JSON is
```Json
{
  "mysqldatabase": {
    "hostname": "localhost",
    "port": 3012,
    "username": "root",
    "password": "root"
  }
}
```

# YAML - Naming Convention

YAML file content key and values as given below

```yaml
employeeId: "1"
employeeName: 'aabc'
```



# YAML - Array of objects

`YAML` is a superset of `JSON` to represent data. So, we can specify objects and arrays in YAML.

Let’s have an object in `JSON` as follows.

```json
{
  "id": 1,
  "name": "Franc"
}
```

The above can be presented in yaml as

```yaml
---
id: 1
name: Franc
```

Suppose you have an array of objects in JSON as
```json
[
  {
    "id": 1,
    "name": "Franc"
  },
  {
    "id": 2,
    "name": "John"
  }
]
```

equivalent YAML file mapping

```yaml
---
- id: 1
  name: Franc
- id: 2
  name: Joh
```

Suppose you have a nested array of objects with a string array for one of the properties.

```json
[
  {
    "id": 1,
    "name": "Franc",
    "roles": [
      "admin",
      "hr"
    ]
  },
  {
    "id": 2,
    "name": "John",
    "roles": [
      "admin",
      "finance"
    ]
  }
]
```

**YAML nested array of objects**:

```yaml
---
- id: 1
  name: Franc
  roles:
  - admin
  - hr
- id: 2
  name: John
  roles:
  - admin
  - finance
```

One more example of a `nested objects array` in json

```json
{
  "data": [
    {
      "id": 1,
      "name": "Franc",
      "roles": [
        "admin",
        "hr"
      ]
    },
    {
      "id": 2,
      "name": "John",
      "roles": [
        "admin",
        "finance"
      ]
    }
  ]
}
```

data property contains a nested array of objects which can be `YAML` as follows

```yaml
---
data:
- id: 1
  name: Franc
  roles:
  - admin
  - hr
- id: 2
  name: John
  roles:
  - admin
  - finance
```

# YAML - Datatypes

It contains following datatypes supported

- String
- Number
- Boolean
- Null
- Array
- Map
## Yaml Strings

```yaml
key: value
key1: 'single quote string'
key2: "double quote string"
key3: "must be double quotes for escape characters in a string\n"
```

using Multiline Literal Block String
```yaml
str: |
  Single Line 1
  Single Line 2
  Single Line 3
```

using Multiline Folded Block String

```yaml
str: >
  Single Line 1
  Single Line 2
  Single Line 3
```

boolean values represents `true` and `false`.
```bash
key: true
key: false
key: TRUE
key: FALSE
key: True
key: False
```

It also accepts english words `yes`/`no` or `on`/`off`

## Yaml Numbers

numbers can be integer or floating numeric value.

```bash
# Scalar data types
integerValue: 1                     # integer value
octalNumber: 0123                     # Octal Numeric vale
hexaNumber: 0x4dea1                     # Hexa Decimal Numeric vale
floatingValue: 1                     # floating vale
```




