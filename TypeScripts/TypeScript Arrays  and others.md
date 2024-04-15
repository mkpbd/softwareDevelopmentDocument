TypeScript has a specific syntax for typing arrays.

```ts
const names: string[] = [];  
names.push("Dylan"); // no error  
// names.push(3); // Error: Argument of type 'number' is not assignable to parameter of type 'string'.
```


## Readonly

The `readonly` keyword can prevent arrays from being changed.

```ts
const names: readonly string[] = ["Dylan"];  
names.push("Jack"); // Error: Property 'push' does not exist on type 'readonly string[]'.  
// try removing the readonly modifier and see if it works?
```

## Type Inference

TypeScript can infer the type of an array if it has values.

```ts
const numbers = [1, 2, 3]; // inferred to type number[]  
numbers.push(4); // no error  
// comment line below out to see the successful assignment  
numbers.push("2"); // Error: Argument of type 'string' is not assignable to parameter of type 'number'.  
let head: number = numbers[0]; // no error
```
# TypeScript Tuples
A **tuple** is a typed [array](https://www.w3schools.com/js/js_arrays.asp) with a pre-defined length and types for each index.

Tuples are great because they allow each element in the array to be a known type of value.

To define a tuple, specify the type of each element in the array:
```ts
// define our tuple  
let ourTuple: [number, boolean, string];  
  
// initialize correctly  
ourTuple = [5, false, 'Coding God was here'];
```

As you can see we have a number, boolean and a string. But what happens if we try to set them in the wrong order:

```ts
// define our tuple  
let ourTuple: [number, boolean, string];  
  
// initialized incorrectly which throws an error  
ourTuple = [false, 'Coding God was mistaken', 5];
```

Even though we have a `boolean`, `string`, and `number` the order matters in our tuple and will throw an error.

---
## Readonly Tuple

A good practice is to make your **tuple** `readonly`.

Tuples only have strongly defined types for the initial values:

```ts
// define our tuple  
let ourTuple: [number, boolean, string];  
// initialize correctly  
ourTuple = [5, false, 'Coding God was here'];  
// We have no type safety in our tuple for indexes 3+  
ourTuple.push('Something new and wrong');  
console.log(ourTuple);
```

To learn more about access modifiers like `readonly` go to our section on them here: [TypeScript Classes](https://www.w3schools.com/typescript/typescript_classes.php).

If you have ever used React before you have worked with tuples more than likely.

`useState` returns a tuple of the value and a setter function.

`const [firstName, setFirstName] = useState('Dylan')` is a common example.

Because of the structure we know our first value in our list will be a certain value type in this case a `string` and the second value a `function`.



# TypeScript Object Types

TypeScript has a specific syntax for typing objects.

```ts
const car: { type: string, model: string, year: number } = {  
  type: "Toyota",  
  model: "Corolla",  
  year: 2009  
};
```

## Type Inference

TypeScript can infer the types of properties based on their values.

```ts
const car = {  
  type: "Toyota",  
};  
car.type = "Ford"; // no error  
car.type = 2; // Error: Type 'number' is not assignable to type 'string'.
```

## Optional Properties

Optional properties are properties that don't have to be defined in the object definition.

### Example without an optional property
```ts

const car: { type: string, mileage: number } = { // Error: Property 'mileage' is missing in type '{ type: string; }' but required in type '{ type: string; mileage: number; }'.  
  type: "Toyota",  
};  
car.mileage = 2000;
```

### Example with an optional property
```ts

const car: { type: string, mileage?: number } = { // no error  
  type: "Toyota"  
};  
car.mileage = 2000;
```

## Index Signatures

Index signatures can be used for objects without a defined list of properties.

```ts
const nameAgeMap: { [index: string]: number } = {};  
nameAgeMap.Jack = 25; // no error  
nameAgeMap.Mark = "Fifty"; // Error: Type 'string' is not assignable to type 'number'.
// Index signatures like this one can also be expressed with utility types like `Record<string, number>`.
```

# TypeScript Enums

An **enum** is a special "class" that represents a group of constants (unchangeable variables).

Enums come in two flavors `string` and `numeric`. Lets start with numeric.

---
## Numeric Enums - Default

By default, enums will initialize the first value to `0` and add 1 to each additional value

```ts
enum CardinalDirections {  
  North,  
  East,  
  South,  
  West  
}  
let currentDirection = CardinalDirections.North;  
// logs 0  
console.log(currentDirection);  
// throws error as 'North' is not a valid enum  
currentDirection = 'North'; // Error: "North" is not assignable to type 'CardinalDirections'.

[Try it Yourself »](https://www.w3schools.com/typescript/trytypescript.php?filename=demo_enums_numeric)
```

## Numeric Enums - Initialized

You can set the value of the first numeric enum and have it auto increment from that:
```ts
enum CardinalDirections {  
  North = 1,  
  East,  
  South,  
  West  
}  
// logs 1  
console.log(CardinalDirections.North);  
// logs 4  
console.log(CardinalDirections.West);
```

## Numeric Enums - Fully Initialized

You can assign unique number values for each enum value. Then the values will not incremented automatically:

```ts

enum StatusCodes {  
  NotFound = 404,  
  Success = 200,  
  Accepted = 202,  
  BadRequest = 400  
}  
// logs 404  
console.log(StatusCodes.NotFound);  
// logs 200  
console.log(StatusCodes.Success);
```

# TypeScript Type Aliases and Interfaces

TypeScript allows types to be defined separately from the variables that use them.

Aliases and Interfaces allows types to be easily shared between different variables/objects.

```ts
type CarYear = number  
type CarType = string  
type CarModel = string  
type Car = {  
  year: CarYear,  
  type: CarType,  
  model: CarModel  
}  
  
const carYear: CarYear = 2001  
const carType: CarType = "Toyota"  
const carModel: CarModel = "Corolla"  
const car: Car = {  
  year: carYear,  
  type: carType,  
  model: carModel  
};
```


## Interfaces

Interfaces are similar to type aliases, except they **only** apply to `object` types.

```ts
interface Rectangle {  
  height: number,  
  width: number  
}  
  
const rectangle: Rectangle = {  
  height: 20,  
  width: 10  
};
```

## Extending Interfaces

Interfaces can extend each other's definition.

**Extending** an interface means you are creating a new interface with the same properties as the original, plus something new.

```ts
interface Rectangle {  
  height: number,  
  width: number  
}  
  
interface ColoredRectangle extends Rectangle {  
  color: string  
}  
  
const coloredRectangle: ColoredRectangle = {  
  height: 20,  
  width: 10,  
  color: "red"  
};
```

# TypeScript Union Types

**Union types** are used when a value can be more than a single type.

Such as when a property would be `string` or `number`.
## Union | (OR)

Using the `|` we are saying our parameter is a `string` or `number`:

```ts
function printStatusCode(code: string | number) {  
  console.log(`My status code is ${code}.`)  
}  
printStatusCode(404);  
printStatusCode('404');
```

## Union Type Errors

**Note:** you need to know what your type is when union types are being used to avoid type errors:
```ts

function printStatusCode(code: string | number) {  
  console.log(`My status code is ${code.toUpperCase()}.`) // error: Property 'toUpperCase' does not exist ontype 'string | number'.  
  Property 'toUpperCase' does not exist on type 'number'  
}

In our example we are having an issue invoking `toUpperCase()` as its a `string` method and `number` doesn't have access to it.


```

# TypeScript Functions

TypeScript has a specific syntax for typing function parameters and return values.
## Return Type

The type of the value returned by the function can be explicitly defined.

```ts

// the `: number` here specifies that this function returns a number  
function getTime(): number {  
  return new Date().getTime();  
}
```



## Void Return Type

The type `void` can be used to indicate a function doesn't return any value.

```ts
function printHello(): void {  
  console.log('Hello!');  
}
```

## Parameters

Function parameters are typed with a similar syntax as variable declarations.

```ts
function multiply(a: number, b: number) {  
  return a * b;  
}
```

If no parameter type is defined, TypeScript will default to using `any`, unless additional type information is available as shown in the Default Parameters and Type Alias sections below.


## Optional Parameters

By default TypeScript will assume all parameters are required, but they can be explicitly marked as optional.

```ts
// the `?` operator here marks parameter `c` as optional  
function add(a: number, b: number, c?: number) {  
  return a + b + (c || 0);  
}
```

## Default Parameters

For parameters with default values, the default value goes after the type annotation:

```ts
function pow(value: number, exponent: number = 10) {  
  return value ** exponent;  
}
```
TypeScript can also infer the type from the default value.
## Named Parameters

Typing named parameters follows the same pattern as typing normal parameters.

```ts
function divide({ dividend, divisor }: { dividend: number, divisor: number }) {  
  return dividend / divisor;  
}
```

## Rest Parameters

Rest parameters can be typed like normal parameters, but the type must be an array as rest parameters are always arrays.

```ts
function add(a: number, b: number, ...rest: number[]) {  
  return a + b + rest.reduce((p, c) => p + c, 0);  
}
```

## Type Alias

Function types can be specified separately from functions with type aliases.

```ts
type Negate = (value: number) => number;  
  
// in this function, the parameter `value` automatically gets assigned the type `number` from the type `Negate`  
const negateFunction: Negate = (value) => value * -1;
```

# TypeScript Casting

There are times when working with types where it's necessary to override the type of a variable, such as when incorrect types are provided by a library.

Casting is the process of overriding a type.

## Casting with `as`

A straightforward way to cast a variable is using the `as` keyword, which will directly change the type of the given variable.

```ts
let x: unknown = 'hello';  
console.log((x as string).length);
```

Casting doesn't actually change the type of the data within the variable, for example the following code will not work as expected since the variable `x` is still holds a number.  
```
let x: unknown = 4;  
console.log((x as string).length); // prints undefined since numbers don't have a length


TypeScript will still attempt to typecheck casts to prevent casts that don't seem correct, for example the following will throw a type error since TypeScript knows casting a string to a number doesn't makes sense without converting the data:  

console.log((4 as string).length); // Error: Conversion of type 'number' to type 'string' may be a mistake because neither type sufficiently overlaps with the other. If this was intentional, convert the expression to 'unknown' first.

The Force casting section below covers how to override this.
```
## Casting with `<>`

Using <> works the same as casting with `as`.
```ts


let x: unknown = 'hello';  
console.log((<string>x).length);
```

# TypeScript Classes

TypeScript adds types and visibility modifiers to JavaScript classes.

## Members: Types

The members of a class (properties & methods) are typed using type annotations, similar to variables.


```ts
class Person {  
  name: string;  
}  
  
const person = new Person();  
person.name = "Jane";
```

## Members: Visibility

Class members also be given special modifiers which affect visibility.

There are three main visibility modifiers in TypeScript.

- `public` - (default) allows access to the class member from anywhere
- `private` - only allows access to the class member from within the class
- `protected` - allows access to the class member from itself and any classes that inherit it, which is covered in the inheritance section below
```ts
class Person {  
  private name: string;  
  
  public constructor(name: string) {  
    this.name = name;  
  }  
  
  public getName(): string {  
    return this.name;  
  }  
}  
  
const person = new Person("Jane");  
console.log(person.getName()); // person.name isn't accessible from outside the class since it's private
```

The `this` keyword in a class usually refers to the instance of the class.
## Parameter Properties

TypeScript provides a convenient way to define class members in the constructor, by adding a visibility modifiers to the parameter.

```ts
class Person {  
  // name is a private member variable  
  public constructor(private name: string) {}  
  
  public getName(): string {  
    return this.name;  
  }  
}  
  
const person = new Person("Jane");  
console.log(person.getName());

```

## Readonly

Similar to arrays, the `readonly` keyword can prevent class members from being changed.

```ts
class Person {  
  private readonly name: string;  
  
  public constructor(name: string) {  
    // name cannot be changed after this initial definition, which has to be either at it's declaration or in the constructor.  
    this.name = name;  
  }  
  
  public getName(): string {  
    return this.name;  
  }  
}  
  
const person = new Person("Jane");  
console.log(person.getName());
```


## Inheritance: Implements

Interfaces (covered [here](https://www.w3schools.com/typescript/typescript_aliases_and_interfaces.php)) can be used to define the type a class must follow through the `implements` keyword.
```ts
interface Shape {  
  getArea: () => number;  
}  
  
class Rectangle implements Shape {  
  public constructor(protected readonly width: number, protected readonly height: number) {}  
  
  public getArea(): number {  
    return this.width * this.height;  
  }  
}
```
A class can implement multiple interfaces by listing each one after `implements`, separated by a comma like so: `class Rectangle implements Shape, Colored {`


Classes can extend each other through the `extends` keyword. A class can only extends one other class.

```ts
interface Shape {  
  getArea: () => number;  
}  
  
class Rectangle implements Shape {  
  public constructor(protected readonly width: number, protected readonly height: number) {}  
  
  public getArea(): number {  
    return this.width * this.height;  
  }  
}  
  
class Square extends Rectangle {  
  public constructor(width: number) {  
    super(width, width);  
  }  
  
  // getArea gets inherited from Rectangle  
}
```

## Override

When a class extends another class, it can replace the members of the parent class with the same name.

Newer versions of TypeScript allow explicitly marking this with the `override` keyword.

```ts
interface Shape {  
  getArea: () => number;  
}  
  
class Rectangle implements Shape {  
  // using protected for these members allows access from classes that extend from this class, such as Square  
  public constructor(protected readonly width: number, protected readonly height: number) {}  
  
  public getArea(): number {  
    return this.width * this.height;  
  }  
  
  public toString(): string {  
    return `Rectangle[width=${this.width}, height=${this.height}]`;  
  }  
}  
  
class Square extends Rectangle {  
  public constructor(width: number) {  
    super(width, width);  
  }  
  
  // this toString replaces the toString from Rectangle  
  public override toString(): string {  
    return `Square[width=${this.width}]`;  
  }  
}
```

By default the `override` keyword is optional when overriding a method, and only helps to prevent accidentally overriding a method that does not exist. Use the setting `noImplicitOverride` to force it to be used when overriding.

---
## Abstract Classes

Classes can be written in a way that allows them to be used as a base class for other classes without having to implement all the members. This is done by using the `abstract` keyword. Members that are left unimplemented also use the `abstract` keyword.

```ts
abstract class Polygon {  
  public abstract getArea(): number;  
  
  public toString(): string {  
    return `Polygon[area=${this.getArea()}]`;  
  }  
}  
  
class Rectangle extends Polygon {  
  public constructor(protected readonly width: number, protected readonly height: number) {  
    super();  
  }  
  
  public getArea(): number {  
    return this.width * this.height;  
  }  
}
```

# TypeScript Basic Generics

Generics allow creating 'type variables' which can be used to create classes, functions & type aliases that don't need to explicitly define the types that they use.

Generics makes it easier to write reusable code.

Generics with functions help make more generalized methods which more accurately represent the types used and returned.

```ts
function createPair<S, T>(v1: S, v2: T): [S, T] {  
  return [v1, v2];  
}  
console.log(createPair<string, number>('hello', 42)); // ['hello', 42]
```
## Classes

Generics can be used to create generalized classes, like [Map](https://www.w3schools.com/js/js_maps.asp).

```ts
class NamedValue<T> {  
  private _value: T | undefined;  
  
  constructor(private name: string) {}  
  
  public setValue(value: T) {  
    this._value = value;  
  }  
  
  public getValue(): T | undefined {  
    return this._value;  
  }  
  
  public toString(): string {  
    return `${this.name}: ${this._value}`;  
  }  
}  
  
let value = new NamedValue<number>('myNumber');  
value.setValue(10);  
console.log(value.toString()); // myNumber: 10
```
TypeScript can also infer the type of the generic parameter if it's used in a constructor parameter.


## Type Aliases

Generics in type aliases allow creating types that are more reusable.

```ts
type Wrapped<T> = { value: T };  
  
const wrappedValue: Wrapped<number> = { value: 10 };
```

## Default Value

Generics can be assigned default values which apply if no other value is specified or inferred.
```ts
class NamedValue<T = string> {  
  private _value: T | undefined;  
  
  constructor(private name: string) {}  
  
  public setValue(value: T) {  
    this._value = value;  
  }  
  
  public getValue(): T | undefined {  
    return this._value;  
  }  
  
  public toString(): string {  
    return `${this.name}: ${this._value}`;  
  }  
}  
  
let value = new NamedValue('myNumber');  
value.setValue('myValue');  
console.log(value.toString()); // myNumber: myValue
```



## Extends

Constraints can be added to generics to limit what's allowed. The constraints make it possible to rely on a more specific type when using the generic type.

```ts
function createLoggedPair<S extends string | number, T extends string | number>(v1: S, v2: T): [S, T] {  
  console.log(`creating pair: v1='${v1}', v2='${v2}'`);  
  return [v1, v2];  
}
```


