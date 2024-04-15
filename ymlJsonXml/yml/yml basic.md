### YAML

YAML, originally known as ==Yet Another Markup Language==, was created in 2001 but now stands for YAML Ain't Markup Language.


```yaml
Employees:
- name: John Doe
  department: Engineering
  country: USA
- name: Kate Kateson
  department: IT support
  country: United Kingdom
```


### How to Create a YAML File

To create a YAML file, use either the `.yaml` or `.yml` file extension.

### Multi-Document Support in YAML

Before writing any YAML code, you can add three dashes (`---`) at the start of the file:

```yaml
---
Employees:
- name: John Doe
  department: Engineering
  country: USA
- name: Kate Kateson
  department: IT support
  country: United Kingdom
```
Separate each document with three dashes (`---`):

```yaml
---
Employees:
- name: John Doe
  department: Engineering
  country: USA
- name: Kate Kateson
  department: IT support
  country: United Kingdom
---
Fruit:
 - Oranges
 - Pears
 - Apples
```

You can also use three dots (`...`) to mark the end of the document:

```yaml
---
Employees:
- name: John Doe
  department: Engineering
  country: USA
- name: Kate Kateson
  department: IT support
  country: United Kingdom
...
```

### Indentation in YAML

In YAML, there is an emphasis on indentation and line separation to denote levels and structure in data.

### How to Write A Comment in YAML

To add a comment to comment out a line of code, use the `#` character:

```yaml
---
# Employees in my company
Employees:
- name: John Doe
  department: Engineering
  country: USA
- name: Kate Kateson
  department: IT support
  country: United Kingdom
```

### Explicit Data Types in YAML

Although YAML auto-detects the data types in a file, you can specify the type of data you want to use.

To explicitly specify the type of data, use the `!!` symbol and the name of the data type before the value:

```yaml
# parse this value as a string
date: !!str 2022-11-11

## parse this value as a float (it will be 1.0 instead of 1)
fave_number: !!float 1
```

## An Introduction to YAML Syntax

### Scalars

Scalars in YAML are the data on the page - strings, numbers, booleans, and nulls.

Let's see some examples of how to use each one.

In YAML, strings in some cases can be left unquoted, but you can also wrap them in single (`' '`) or double (`" "`) quotation marks:

```yaml
A string in YAML!

'A string in YAML!'

"A string in YAML!"


```


If you want to write a string that spans across multiple lines and you want to preserve the line breaks, use the pipe symbol (`|`):

```yaml
|
 I am message that spans multiple lines
 I go on and on across lines
 and lines
 and more lines
```

Numbers express numerical data, and in YAML, these include integers (whole numbers), floats (numbers with a decimal point), exponentials, octals, and hexadecimals:

```yaml
# integer
19

# float 
8.7

# exponential
4.5e+13

# octal 
0o23

# hexadecimal
0xFF
```

Booleans in YAML, and other programming languages, have one of two states and are expressed with either `true` or `false`.

### Collections

More often than not, you will not be writing simple scalars in your YAML files - you will be using collections instead.

Collections in YAML can be:

- Sequences (lists/arrays)
- Mappings (dictionaries/hashes)

To write a sequence, use a dash (`-`) followed by a space:

```yaml
- HTML
- CSS
- JavaScript
```

Each item in the sequence (list) is placed on a separate line, with a dash in front of the value.

And each item in the list is on the same level.

That said, you can create a nested sequence (remember, use spaces - not tabs - to create the levels of indentation):

```yaml
- HTML
- CSS
- JavaScript
 - React
 - Angular
 - Vue
```

In the sequence above, `React, Angular and Vue` are sub-items of the item `JavaScript`

Mappings allow you to list keys with values. Key/value pairs are the building blocks of YAML documents.

Use a colon (`:`) followed by a space to create key/value pairs:

```yaml
Employees:
 name: John Doe
 age: 23
 country: USA
```

In the example above, a name gets assigned to a specific value.

The value `John Doe` gets mapped (or assigned) to the `name` key, the value

```yaml
frontend_languages:
 - HTML
 - CSS
 - JavaScript
  - React
  - Angular
  - Vue
```

In the example above, I created a list of `frontend_languages`, where there are multiple values under the same key, `frontend_languages`.


Similarly, you can create a list of objects:

```yaml
Employees:
- name: John Doe
  department: Engineering
  country: USA
- name: Kate Kateson
  department: IT support
  country: United Kingdom
```


