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


### Step-by-Step Guide to Writing YAML

#### Step 1: Understand the Structure

- A YAML file typically represents a single data structure (e.g., a configuration object).
- Example of a simple YAML structure:

```yaml
name: Alice
age: 25
hobbies:
  - reading
  - hiking
```
- name and age are scalar mappings.
- hobbies is a sequence (list) of scalars.
#### Step 2: Create a YAML File

- Use a text editor (e.g., VS Code) to create a file with a .yml or .yaml extension (e.g., config.yml).
- Ensure proper indentation (2 spaces) and avoid tabs.

#### Step 3: Define Scalars

- Add simple key-value pairs for strings, numbers, or booleans.
```yaml
username: john_doe
port: 8080
enabled: true
```
#### Step 4: Add Sequences

- Use hyphens (-) to create lists.

```ymal
fruits:
  - apple
  - banana
  - orange
```

#### Step 5: Add Nested Mappings

- Nest key-value pairs under other keys with indentation.
```yaml
user:
  name: Bob
  address:
    street: 123 Main St
    city: New York
```

#### Step 6: Use Comments

- Add comments for clarity using #
```yml
# Application configuration
app:
  name: MyApp
  version: 1.0.0
```

```yaml
# Docker Compose configuration
version: '3.8'
services:
  web:
    image: node:18
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
  db:
    image: postgres:13
    environment:
      - POSTGRES_USER=admin
      - POSTGRES_PASSWORD=secret
```

#### Example 1: Simple Application Configuration

**Description**: A YAML file to configure a web application with basic settings.

**Step 1: Define the application name and port**

- Specify the app’s name and the port it runs on. **Step 2: Add a debug flag**
- Include a boolean to enable/disable debugging. **Step 3: Save the YAML**
- Store it as app-config.yml.
```yaml
# Application configuration
app:
  name: MyWebApp
  port: 8080
  debug: true
```

**Explanation**:

- The app key is a mapping containing three scalar values: name (string), port (number), and debug (boolean).
- The comment clarifies the file’s purpose.
- This could be used in a Node.js or Angular app to configure server settings.

#### Example 2: User Profile with Nested Data

**Description**: A YAML file to store a user’s profile, including nested address and hobbies.

**Step 1: Define user details**

- Add name and age as scalars. **Step 2: Add nested address**
- Include a nested mapping for address details. **Step 3: Add a list of hobbies**
- Use a sequence for hobbies. **Step 4: Save the YAML**
- Store it as user-profile.yml.
```yml
# User profile data
user:
  name: Alice Smith
  age: 28
  address:
    street: 456 Elm St
    city: San Francisco
    zip: 94105
  hobbies:
    - reading
    - hiking
    - photography
```
**Explanation**:

- user is a mapping with scalar (name, age), nested mapping (address), and sequence (hobbies) values.
- Proper indentation (2 spaces) is used for nesting.
- This could be used in a database seed file or user management system.

#### Example 3: Docker Compose Configuration

**Description**: A YAML file for a Docker Compose setup with multiple services.

**Step 1: Define services**

- Specify a web and database service. **Step 2: Configure service details**
- Add image, ports, and environment variables. **Step 3: Save the YAML**
- Store it as docker-compose.yml.
```yml
# Docker Compose configuration
version: '3.8'
services:
  web:
    image: node:18
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
  db:
    image: postgres:13
    environment:
      - POSTGRES_USER=admin
      - POSTGRES_PASSWORD=secret
```


**Explanation**:

- version specifies the Docker Compose version.
- services is a mapping with two nested services: web and db.
- Each service has mappings (image, ports, environment) and sequences (ports, environment).
- This is a common YAML use case for containerized applications.

#### xample 4: CI/CD Pipeline (GitHub Actions)

**Description**: A YAML file for a GitHub Actions workflow to build and test a project.

**Step 1: Define the workflow**

- Specify the workflow name and trigger events. **Step 2: Add jobs and steps**
- Configure a job with steps to checkout code and run tests. **Step 3: Save the YAML**
- Store it as .github/workflows/ci.yml.

```yml
# GitHub Actions CI workflow
name: CI Pipeline
on:
  push:
    branches:
      - main
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
      - name: Install dependencies
        run: npm install
      - name: Run tests
        run: npm test
```

**Explanation**:

- name defines the workflow name.
- on specifies the trigger (push to main branch).
- jobs contains a build job with a sequence of steps.
- This is a typical CI/CD configuration for automated testing.

#### Example 5: Anchors and Aliases for Reusability

**Description**: A YAML file demonstrating anchors and aliases to reuse data.

**Step 1: Define reusable data**

- Use an anchor (&) to mark reusable data. **Step 2: Reference the data**
- Use an alias (*) to reuse the anchored data. **Step 3: Save the YAML**
- Store it as shared-config.yml.
```yml
# Configuration with anchors
defaults: &defaults
  timeout: 30
  retries: 3

server:
  api:
    <<: *defaults
    url: https://api.example.com
  db:
    <<: *defaults
    url: postgresql://localhost:5432
```

**Explanation**:

- defaults is an anchor (&defaults) storing reusable settings.
- <<: *defaults merges the anchored data into api and db.
- Each service overrides or adds specific keys (e.g., url).
- This reduces duplication in configuration files.
