
## What is TypeScript?

TypeScript is a syntactic superset of JavaScript which adds **static typing**.

This basically means that TypeScript adds syntax on top of JavaScript, allowing developers to add **types**.

TypeScript being a "Syntactic Superset" means that it shares the same base syntax as JavaScript, but adds something to it.

TypeScript uses compile time type checking. Which means it checks if the specified types match **before** running the code, not **while** running the code.

## Installing the Compiler

npm install typescript --save-dev

npx tsc

## Configuring the compiler

By default the TypeScript compiler will print a help message when run in an empty project.

The compiler can be configured using a `tsconfig.json` file.

You can have TypeScript create `tsconfig.json` with the recommended settings with:

npx tsc --init

tsconfig.json

``` Json
{  
  "include": ["src"],  
  "compilerOptions": {  
    "outDir": "./build"  
  }  
}
```

# TypeScript Simple Types

There are three main primitives in JavaScript and TypeScript.

- `boolean` - true or false values
- `number` - whole numbers and floating point values
- `string` - text values like "TypeScript Rocks"

There are also 2 less common primitives used in later versions of Javascript and TypeScript.

- `bigint` - whole numbers and floating point values, but allows larger negative and positive numbers than the `number` type.
- `symbol` are used to create a globally unique identifier.

## Type Assignment

When creating a variable, there are two main ways TypeScript assigns a type:

- Explicit
- Implicit

In both examples below `firstName` is of type `string`

```ts

let firstName: string = "Dylan";
```

**Explicit** type assignment are easier to read and more intentional.

**Note:** Having TypeScript  guess the type of a value is called **infer**.

Implicit assignment forces TypeScript to **infer** the value.

**Implicit** type assignment are shorter, faster to type, and often used when developing and testing.

## Error In Type Assignment

```ts
let firstName: string = "Dylan"; // type string  
firstName = 33; // attempts to re-assign the value to a different type
```


**Implicit** type assignment would have made `firstName` less noticeable as a `string`, but both will throw an error:
```ts
let firstName = "Dylan"; // inferred to type string  
firstName = 33; // attempts to re-assign the value to a different type
```
**JavaScript** will **not** throw an error for mismatched types.

## Unable to Infer

TypeScript may not always properly infer what the type of a variable may be. In such cases, it will set the type to `any` which disables type checking.


```ts
	// Implicit any as JSON.parse doesn't know what type of data it returns so it can be "any" thing...  
const json = JSON.parse("55");  
// Most expect json to be an object, but it can be a string or a number like this example  
console.log(typeof json);
```


This behavior can be disabled by enabling `noImplicitAny` as an option in a TypeScript's project `tsconfig.json`. That is a JSON config file for customizing how some of TypeScript behaves.

**Note:** you may see primitive types capitalized like `Boolean`.

`boolean !== Boolean`  
For this tutorial just know to use the lower-cased values, the upper-case ones are for very specific circumstances.



# TypeScript Special Types

TypeScript has special types that may not refer to any specific type of data.

## Type: any

`any` is a type that disables type checking and effectively allows all types to be used.

The example below does not use `any` and will throw an error:
```ts
let u = true;  
u = "string"; // Error: Type 'string' is not assignable to type 'boolean'.  
Math.round(u); // Error: Argument of type 'boolean' is not assignable to parameter of type 'number'.
```

Setting `any` to the special type `any` disables type checking:

```ts
let v: any = true;  
v = "string"; // no error as it can be "any" type  
Math.round(v); // no error as it can be "any" type
```



`any` can be a useful way to get past errors since it disables type checking, but TypeScript will not be able provide type safety, and tools which rely on type data, such as auto completion, will not work. Remember, it should be avoided at "any" cost...


## Type: unknown

`unknown` is a similar, but safer alternative to `any`.

TypeScript will prevent `unknown` types from being used, as shown in the below example:

```ts
let w: unknown = 1;  
w = "string"; // no error  
w = {  
  runANonExistentMethod: () => {  
    console.log("I think therefore I am");  
  }  
} as { runANonExistentMethod: () => void}  
// How can we avoid the error for the code commented out below when we don't know the type?  
// w.runANonExistentMethod(); // Error: Object is of type 'unknown'.  
if(typeof w === 'object' && w !== null) {  
  (w as { runANonExistentMethod: Function }).runANonExistentMethod();  
}  
// Although we have to cast multiple times we can do a check in the if to secure our type and have a safer casting
```

Compare the example above to the previous example, with `any`.

`unknown` is best used when you don't know the type of data being typed. To add a type later, you'll need to cast it.

Casting is when we use the "as" keyword to say property or variable is of the casted type.


## Type: never

`never` effectively throws an error whenever it is defined.

let x: never = true; // Error: Type 'boolean' is not assignable to type 'never'.

`never` is rarely used, especially by itself, its primary use is in advanced generics.

## Type: undefined & null

`undefined` and `null` are types that refer to the JavaScript primitives `undefined` and `null` respectively.
```ts
let y: undefined = undefined;  
let z: null = null;
```



