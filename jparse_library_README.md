# Information on the jparse C library

In this document we describe the `jparse` C library so you can get an idea of
how to use it in a C application that needs to parse and process valid JSON
documents, whether in a file (on disk or stdin, or even over a network) or a
string.

For information on the `jparse` repo, see the [jparse repo
README.md](https://github.com/xexyl/jparse/blob/master/README.md).

For information on the `jparse` utilities see
[jparse_utils_README.md](https://github.com/xexyl/jparse/blob/master/jparse_utils_README.md).

For information on the testing suite see
[test_jparse/README.md](https://github.com/xexyl/jparse/blob/master/test_jparse/README.md).

We also do recommend that you read the
[json_README.md](https://github.com/xexyl/jparse/blob/master/json_README.md)
document to better understand the JSON terms used in this repo.

# Table of Contents

- [jparse library](#jparse-library)
- [jparse library example](#jparse-library-example)
- [jparse header files](#jparse-header-files)
- [Linking in the jparse library](#linking-jparse)
- [Re-entrancy](#re-entrancy)
- [jparse&lparen;3&rparen; details](#jparse-details)
    - [struct json: the core struct](#struct-json)
    - [enum item_type: the different JSON types](#enum-item-type)
    - [JSON structs](#json-structs)
- [JSON debug output](#json-debug-output)
    - [JTYPE_NUMBER: JSON number debug output](#jtype-number-debug-output)
    - [JTYPE_STRING: JSON string debug output](#jtype-string-debug-output)
    - [JTYPE_BOOL: JSON boolean debug output](#jtype-boolean-debug-output)
    - [JTYPE_NULL: JSON null debug output](#jtype-null-debug-output)
    - [JTYPE_MEMBER: JSON member debug output](#jtype-member-debug-output)
    - [JTYPE_OBJECT: JSON object debug output](#jtype-object-debug-output)
    - [JTYPE_ARRAY: JSON array debug output](#jtype-array-debug-output)
    - [JTYPE_ELEMENTS: JSON elements debug output](#jtype-elements-debug-output)
- [jparse API overview](#jparse-api-overview)


<div id="jparse-library"></div>

# jparse library

As a library, `jparse` is much more useful that the `jparse(1)` tool, as it
allows one to parse JSON in their application and then interact with the parsed
tree.

In order to use the library, you will need to `#include` the necessary header
files and then link in the libraries (jparse and the dependency libraries).


Before we give you information about header files and linking in the libraries,
we will give you an example (or at least refer you to a simple example). This
way, you can hopefully follow it a bit better.


<div id="jparse-library-example"></div>

# jparse library example

For a relatively simple example program that uses the library, take a look at
[jparse_main.c](https://github.com/xexyl/jparse/blob/master/jparse_main.c). As
we already gave details on how to use it, we will not do that here. It is,
however, a nice example program to give you a basic idea of how to use the
library, especially as it is commented nicely.

As you will see, in the case of this tool, we include
[jparse_main.h](https://github.com/xexyl/jparse/blob/master/jparse_main.h),
which includes the two most useful header files,
[jparse.h](https://github.com/xexyl/jparse/blob/master/jparse.h) and
[util.h](https://github.com/xexyl/jparse/blob/master/util.h), the former of
which is required (in actuality, `jparse.h` includes it, but it does not hurt to
include it anyway due to inclusion guards).

Below we give finer details on using the library.


<div id="jparse-header-files"></div>

# jparse header files

For this we will assume that you have installed `jparse` into a standard
location. If you wish to not install it, then you will have to change how you
`#include` the files a bit, as well as how you link in the libraries.

While we do not (yet?) show every header file that is installed, the two most
useful ones are `jparse.h` and `util.h`, found in the `jparse/` subdirectory
(again, when installed).

Thus in your program source you might have:

```c
#include <jparse/jparse.h>
#include <jparse/util.h>
```

Again, if you need a simple example program that uses the library, see the
`jparse(1)` source code,
[jparse_main.c](https://github.com/xexyl/jparse/blob/master/jparse_main.c).


<div id="linking-jparse"></div>

# Linking in the jparse library

In order to use the library you will have to link the static libraries (the
`jparse(3)` library as well as the `dbg` and `dyn_array` libraries) into your
program.

To do this you should pass to the compiler `-ljparse -ldbg -ldyn_array`. For
instance to compile
[json_main.c](https://github.com/xexyl/jparse/blob/master/jparse_main.c), with
the `#include` lines changed to:

```c
#include <jparse/jparse.h>
#include <jparse/util.h>
```

we can compile it like:

```sh
cc jparse_main.c -o jparse -ljparse -ldbg -ldyn_array
```

and expect to find `jparse` in the current working directory.

If you need an example for a Makefile, take a look at the
[Makefile](https://github.com/xexyl/jparse/blob/master/Makefile)'s
`jparse_main.o` and `jparse` rules, to give you an idea.

Once your code has been compiled and linked into an executable, you should be
good to go, although it naturally will obfuscate your code a bit! :-)

<div id="jparse-details"></div>

# jparse(3) details

Here we will give a few details on the core of the `jparse` library, though we
recommend you check the header files and source files noted below, for more
thorough details.

For much more details, please see the header file
[json_parse.h](https://github.com/xexyl/jparse/blob/master/json_parse.h) and the
source file
[json_parse.c](https://github.com/xexyl/jparse/blob/master/json_parse.c).


<div id="struct-json"></div>

## struct json: the core struct

In brief, for now at least, the core struct `json`, is defined as:

```c
/*
 * struct json - item for the JSON parse tree
 *
 * For the parse tree we have this struct and its associated union.
 */
struct json
{
    enum item_type type;		/* union item specifier */
    union json_union {
	struct json_number number;	/* JTYPE_NUMBER - value is number (integer or floating point) */
	struct json_string string;	/* JTYPE_STRING - value is a string */
	struct json_boolean boolean;	/* JTYPE_BOOL - value is a JSON boolean */
	struct json_null null;		/* JTYPE_NULL - value is a JSON null value */
	struct json_member member;	/* JTYPE_MEMBER - value is a JSON member: name : value */
	struct json_object object;	/* JTYPE_OBJECT - value is a JSON { members } */
	struct json_array array;	/* JTYPE_ARRAY - value is a JSON [ elements ] */
	struct json_elements elements;	/* JTYPE_ELEMENTS - zero or more JSON values */
    } item;

    /*
     * JSON parse tree links
     */
    struct json *parent;	/* parent node in the JSON parse tree, or NULL if tree root or unlinked */
};
```

Please read the comments for more details. Below we will include the enum and
give a brief list of each struct.


<div id="enum-item-type"></div>

## enum item_type: the different JSON types

The enum `item_type` corresponds to structs in the form of `json_foo` (such as
`struct json_string` for `JTYPE_STRING`) that are contained in the `struct json`
listed above. Below we will list the structs, with the purpose of each.
For more details please see the comments in
[json_parse.h](https://github.com/xexyl/jparse/blob/master/json_parse.h).

The `enum item_type` is as follows:

```c
/*
 * item_type - JSON item type - an enum for each union item member in struct json
 */
enum item_type {
    JTYPE_UNSET	    = 0,    /* JSON item has not been set - must be the value 0 */
    JTYPE_NUMBER,	    /* JSON item is a number - see struct json_number */
    JTYPE_STRING,	    /* JSON item is a string - see struct json_string */
    JTYPE_BOOL,		    /* JSON item is a boolean - see struct json_boolean */
    JTYPE_NULL,		    /* JSON item is a null - see struct json_null */
    JTYPE_MEMBER,	    /* JSON item is a member */
    JTYPE_OBJECT,	    /* JSON item is a { members } */
    JTYPE_ARRAY,	    /* JSON item is a [ elements ] */
    JTYPE_ELEMENTS,	    /* JSON item for building a JSON array */
};
```

<div id="json-structs"></div>

## JSON structs

The following is a list of each structure for the various JSON
types. These structures each correspond to a `JTYPE_` of the enum `item_type`,
found above, defined in
[json_parse.h](https://github.com/xexyl/jparse/blob/master/json_parse.h).

For now (at least), there are no details about the structures; that might come
later but you are invited to look at the header file
[json_parse.h](https://github.com/xexyl/jparse/blob/master/json_parse.h) as well
as how they are used in the various source files, especially
[json_parse.c](https://github.com/xexyl/jparse/blob/master/json_parse.c), for
more details.

Here are the structures:

- `json_number`: for JSON numbers (all kinds)
- `json_string`: for JSON strings
- `json_boolean`: for JSON booleans (`true`, `false`)
- `json_null`: for the JSON null (`null`, not a string)
- `json_member`: for JSON members
- `json_object`: for JSON objects
- `json_array`: for JSON arrays (this **MUST** be the same as `json_elements`!)
- `json_elements`: for JSON elements (this **MUST** be the same as `json_array`!)

In the case of `struct json_object`, `struct json_array` and `struct
json_elements`, the pointer to the i-th JSON value in the JSON type, if i < len,
is `foo.set[i-1]`.

For now, please see the comments for each struct in
[json_parse.h](https://github.com/xexyl/jparse/blob/master/json_parse.h) for
details on what the struct members are and what they are for.


<div id="re-entrancy"></div>
<div id="reentrancy"></div>

# Re-entrancy

Although the scanner and parser are both re-entrant, only one parse at the same
time in a process has been tested. The testing of more than one parse at the
same time might be done at a later time but that will likely only happen if a
tool requires it.

If it's not clear: this means that having more than one parse active in the same
process at the same time is untested so even though it should be okay there
might be some issues that have yet to be discovered.



<div id="json-debug-output"></div>

# JSON debug output

In order to help with seeing what JSON data was parsed, the library has debug
output code. In programs that use the `jparse(3)` library, there exists the `-J
level` option. Although some of it might be clear, when it comes to numbers and
strings, there are many flags that we describe below. Other types we also
describe, though there isn't much to those.

The printing code is in a number of functions (the static `fpr*()` functions) that
are called by `vjson_fprint()` found in
[json_util.c](https://github.com/xexyl/jparse/blob/master/json_util.c).

We will try and simplify this as much as possible, without sacrificing details
(as much as possible) but this might not be that easy to do.

In all cases, if you see the `p` flag it means the data was parsed successfully.
If you see the `c` flag it means the data was converted. It is possible for JSON
to be parsed successfully but not be converted, for instance if the number is so
big it does not fit in a C type. These flags will be shown in the examples
below.

In all cases if you see text in the form of `JSON tree[%d]` it is the debug
level that is not a forced level; otherwise, if it is forced it'll just be `JSON
tree node`.

In all cases the `lvl` indicates the depth.

In all cases the `type JTYPE_FOO` indicates the JSON type, for instance
`JTYPE_NUMBER` for numbers, `JTYPE_STRING` for strings, `JTYPE_NULL` for `null`
etc.

In the case of JSON types like arrays that have other members/objects, the debug
output will show those as well.

The other things depend on the type of JSON data.

<div id="jtype-number-debug-output"></div>

## JTYPE_NUMBER: JSON number debug output

There are a quite a few flags that indicate certain things when parsing JSON
numbers. The general form of the debug output is:

The output in general is in the form of:

```
JSON tree[3]:	lvl: 0	type: JTYPE_NUMBER	{p,c:-I8163264illlSSomffiddildldi}: value:	-5
```

where `type: JTYPE_NUMBER` indicates it is a number of some kind, and the flags
identify details about the number and the `value` is the value of the number,
assuming it was converted.

The flags are described below and are associated with the value.
The example above are the flags for a `JTYPE_NUMBER`, although there are others,
all of which will be described below; the code that prints these flags comes
from the `fprnumber()` function.

The flags after the parsed and converted flags (as described above), if present,
are in the following order:

0. `-`: a negative number.

1. `F`: the number is a floating point number.

2. `E`: the number is in E notation (e.g. `1e10`).

3. `I`: the number was converted to some integer type (see below).

4. `8`: the number was converted to `int8_t`.

5. `u8`: the number was converted to `uint8_t`.

6. `16`: the number was converted to `int16_t`.

7. `u16`: the number was converted to `uint16_t`.

8. `32`: the number was converted to `int32_t`.

9. `u32`: the number was converted to `uint32_t`.

10. `64`: the number was converted to `int64_t`.

11. `u64`: the number was converted to `uint64_t`.

12. `i`: the number was converted to `signed int`.

13. `ui`: the number was converted to `unsigned int` (cannot be < 0).

14. `l`: the number was converted to `long int`.

15. `ul`: the number was converted to `unsigned long int`.

16. `ll`: the number was converted to `long long int`.

17. `ull`: the number was converted to `unsigned long long int`.

18. `SS`: the number was converted to `ssize_t`.

19. `s`: the number was converted to `size_t`.

20. `o`: the number was converted to `off_t`.

21. `m`: the number was converted to `intmax_t`.

22. `um`: the number was converted to `uintmax_t`.

23. `f`: the number was converted to `float`.

24. `d`: the number was converted to `double`.

25. `di`: if `double_sized` (flag `d`, JSON float converted to `double`) set,
then `as_double` is an integer.

26. `ld`: the number was converted to `long double`.

27. `ldi`: if `longdouble_sized` (flag `ld`, JSON float converted to `long
double)` set, then `as_longdouble` is an integer.

<div id="jtype-string-debug-output"></div>

## JTYPE_STRING: JSON string debug output

There are a number of flags that indicate certain things when parsing JSON
strings. The general form of the debug output is:

```
JSON tree[5]:	lvl: 0	type: JTYPE_STRING	len{p,c:qPa}: 3	value:	"foo"
```

where `type: JTYPE_STRING` indicates it is a JSON string, `len{...}: 3`
indicates a length of 3 with the flags described below, and the value is the
string `"foo"`.

The code that prints this comes from the function `fprstring()`.

The following flags, if present, mean the below, in the following order, and are
for `JTYPE_STRING`:


0. `q`: the original string JSON string included surrounding double quotes (`"`s)

1. `=`: the encoded string is identical to the decoded string (JSON decoding was
not required).

2. `/`: `/` was found after decoding.

3. `p`: all chars are POSIX portable safe plus `+` and maybe `/` after decoding

4. `a`: first char is alphanumeric after decoding

5. `U`: UPPER case chars found after decoding.


<div id="jtype-bool-debug-output"></div>

## JTYPE_BOOL: JSON boolean debug output

For JSON booleans, it is quite simple, with the form of either:

```
JSON tree[3]:	lvl: 0	type: JTYPE_BOOL	{pc}value: false
```

for `false` or:

```
JSON tree[3]:	lvl: 0	type: JTYPE_BOOL	{pc}value: true
```

for `true` where `JTYPE_BOOL` is for JSON booleans.

The code that prints this comes from the function `fprboolean()`.

<div id="jtype-null-debug-output"></div>

## JTYPE_NULL: JSON null debug output

For JSON null (`null`, not a string), it looks like:

```
JSON tree[3]:	lvl: 0	type: JTYPE_NULL	{pc}: value: null
```

where `JTYPE_NULL` indicates a `null` object.

This is done in `fprnull()`.


<div id="jtype-member-debug-output"></div>

## JTYPE_MEMBER: JSON member debug output

The general form for debug output of JSON members is:

```
JSON tree[5]:   lvl: 2  type: JTYPE_MEMBER      {pc}name: "foo"
```

where `type: JTYPE_MEMBER` indicates that it is a JSON member and `name:
"foo"` indicates the name is `"foo"`.

This is done in `fprmember()`.

<div id="jtype-object-debug-output"></div>

## JTYPE_OBJECT: JSON object debug output

The general form for a JSON object is:

```
JSON tree[5]:   lvl: 0  type: JTYPE_OBJECT      {pc}len: 2
```

where `JTYPE_OBJECT` indicates it is a JSON object and `len` indicates the
length, or the number of JSON members in the object. If 0, the object has 0
members.


<div id="jtype-array-debug-output"></div>

## JTYPE_ARRAY: JSON array debug output

For JSON arrays the general form is:

```
JSON tree[5]:   lvl: 0  type: JTYPE_ARRAY       {pc}len: 1
```

where `JTYPE_ARRAY` indicates it is a JSON array and the `len` indicates the
number of JSON values in the JSON array. If 0, the array is empty.

**NOTE**: the structure `json_array` **MUST** be the same as the structure
`json_elements` because the function `json_parse_array()` converts by just
changing the JSON item type.

<div id="jtype-elements-debug-output"></div>

## JTYPE_ELEMENTS: JSON elements debug output

For JSON elements the form is:

```
JSON tree[5]:   lvl: 0  type: JTYPE_ELEMENTS    {pc}len: 4
```

where `JTYPE_ELEMENTS` indicates JSON elements and the `len` is the  number of
JSON values in the JSON elements. If 0, it is empty (no values).

**NOTE**: the structure, `json_elements` **MUST** be identical to the structure
`json_array` because the function `json_parse_array()` converts by changing the
JSON item type.



<div id="jparse-api-overview"></div>

# jparse API overview

To get an overview of the API, try from the repo directory:

```sh
man ./man/man3/jparse.3
```

or if installed:

```sh
man 3 jparse
```

which gives more information about the most important functions.
