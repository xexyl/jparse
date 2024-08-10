# jparse - a C JSON parser

**Last updated: _Tue 09 Jul 2024 14:42:06 UTC_**

We will try and update the last update date when this is updated but this is not
guaranteed one way or another; see the log if you must know (`git log
README.md`).


## WARNING: this repo is **NOT YET POPULATED**, see below

`jparse` is a JSON parser (a stand-alone tool and a library) written in C with
the help of `flex(1)` and `bison(1)`. It was co-developed in 2022 by:

*@xexyl* (**Cody Boone Ferguson**, [https://xexyl.net](https://xexyl.net),
[https://ioccc.xexyl.net](https://ioccc.xexyl.net))

and:

*chongo* (**Landon Curt Noll**, [http://www.isthe.com/chongo/index.html](http://www.isthe.com/chongo/index.htm)) /\oo/\


## Current code location

The only place you can get the code for now is at the [mkiocccentry
repo](https://github.com/ioccc-src/mkiocccentry/) at the [jparse
subdirectory](https://github.com/ioccc-src/mkiocccentry/tree/master/jparse).

However, as that is tied to other code in support of the [International
Obfuscated C Code Contest](https://www.ioccc.org), that is not very useful for a
wider population, although one can certainly install it that way if they wish
(see below). We hope this repo will be populated within some months (at the time
of writing it is 09 July 2024) but this is very much dependant on a number of
things that have to be done first.


## **This** README.md file

Due to the above, this is a just a **PLACEHOLDER**
[README.md](https://github.com/xexyl/jparse/blob/master/README.md), for now, as it's
not yet time for the code to be populated. Although it works we want to make use
of it on a wider scale before we make it a separate repo.

The [Makefile that exists
**here**](https://github.com/xexyl/jparse/blob/master/Makefile) is thus **very
volatile** and it **will be HEAVILY MODIFIED**: what exists is a placeholder as
well, mostly to make sure that GitHub workflows work okay and to kind of look
like the [jparse Makefile in the mkiocccentry
repo](https://github.com/ioccc-src/mkiocccentry/blob/master/jparse/Makefile).

The repo was created ahead of the time for population to make it so the code can
more easily be imported without having to do this first. As well we wanted to
set up workflows ahead of time.

For more details on the parser itself, the library and the supplementary tools,
see [the jparse README.md in the
mkiocccentry](https://github.com/ioccc-src/mkiocccentry/tree/master/jparse/README.md).

Nevertheless, you certainly **can** and **may** clone that repo, run `make all` and then `make
install` (as root or via `sudo`) to make use of the parser to validate JSON
files or to make use of the library should you wish to. If you do this and you find
an issue you are **definitely encouraged** to [report it as a bug or perhaps a
feature request](https://github.com/ioccc-src/mkiocccentry/issues/new/choose) at
the **[mkiocccentry repo](https://github.com/ioccc-src/mkiocccentry)** but
**PLEASE** be aware that it might not happen right away (and if it's a feature
request we cannot even guarantee it will be implemented) as we have **higher**
priorities right now.

Until then, `So Long and Thanks for All the Fish`! :-)
