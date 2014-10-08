# Parsing JSON

Source Code to the [Parsing JSON Blog Posts](). Follow along from the tags:

- [01-happiest-of-paths](https://github.com/jeffh/ParsingJSON/tree/01-happiest-of-paths) - The initial code of parsing JSON. Adding tests.
- [02-handle-error-message](https://github.com/jeffh/ParsingJSON/tree/02-handle-error-message) - Handling error message JSON object. Adding tests.
- [03-error-handling-height-key](https://github.com/jeffh/ParsingJSON/tree/03-error-handling-height-key) - Handling some more errors. Adding tests.
- [04-refactor-into-methods](https://github.com/jeffh/ParsingJSON/tree/04-refactor-into-methods) - Refactor code into separate methods.
- [05-convert-most-methods-into-using-mappers](https://github.com/jeffh/ParsingJSON/tree/05-convert-most-methods-into-using-mappers) - Refactor into classes.
- [06-full-refactor-to-one-protocol](https://github.com/jeffh/ParsingJSON/tree/06-full-refactor-to-one-protocol) - More aggressive refactors into classes.
- [07-adding-optional-elements-for-arrays](https://github.com/jeffh/ParsingJSON/tree/07-adding-optional-elements-for-arrays) - Added support for optional mapping.

To setup, clone this repo:

```
git clone https://github.com/jeffh/ParsingJSON.git
```

JSON parsing that is common in Objective-C is actually a [Data
Mapping](http://en.wikipedia.org/wiki/Data_mapping) problem. The articles cover
formulating the problem and building an abstraction to try and maximize the
code reuse.

Note: If you just want a library to use, the writing is all based off of the
[Hydrant project](https://github.com/jeffh/Hydrant). This isn't intended for
production use

# Tests
To verify my work (and prevent sleepless nights), the code here is tested. They
use the [Cedar testing framework](https://github.com/pivotal/cedar). Using ⌘-U
will run the tests. The fact that this project is a static library is merely a
random choice.

# The End Result
The end result of the series is a single `Mapper` protocol which individual
mappers conform to.  Each class solves a small part of the bigger problem,
which allows composition and code reused with little assumption of other
followers of the protocol.

This design, while more verbose, can cover more scenarios that is harder to do
with a single-object API and allows developers the same flexibility of
extending this code for more special cases. An example is optionally dropping
bad JSON objects inside an array.

Those with a keen eye may notice that the overall structure is a more immutable
and functional design. The object-oriented syntax does significantly balloon
the code size which most functional programming languages minimize.
