# picotap
A tiny TAP generator library and TAP parser in C for Linux, OSX

## Introduction
picotap is a tiny TAP generator library (test) and TAP parser (test harness) written in C.  It was inspired by code in kazuho's github projects.

## Prequisites
C Prequisites:
* tap requires GCC or clang/LLVM on Linux or OSX

If you get stuck in Linux or OSX, try typing `make help` or looking at the Examples directory.

## Building
Try the following:
* `make`
* `make help`
* `make libtap`
* `make ptap`
* `make install`
* `make tests`
* `make runtest`
* `make runtap`

# Examples
## Making a TAP generator (a test) in C
* In `./picotap`, type: `make libtap`
* Include `tap.h` into your test file
* Start your test source with
`plan( 10 ); // If your test plan includes 10 tests`
* Each test is of the form
`ok( condition, "Info about the test" );`
* `condition` can be any expression that resolves to `true`/`false`
* For output to stdout not part of the test plan results
  * Prefix with a `space`, `tab`, or `#`
* Compile your test code by including the path to `tap.h` and linking to `libptap.a`
`cc test.c -I./picotap -L. -lptap -o test.exe`
* See the `picotap/Examples` directory and the `make examples` command in `picotap/Makefile`

## Making a TAP parser run (test harness) in C
* In `./picotap`, type:
`make ptap`
* Execute the test via the tap parser
`./ptap /PATH/TO/test.exe`
* `ptap` will open a pipe to `test.exe`, reading its `stdout` and parse it
* For output to stdout not part of the test plan results
  * Prefix with a `space`, `tab`, or `#`
