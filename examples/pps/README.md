# PPS Examples

These examples are intentionally limited to the PPS target support that
is present in this tree: classic stdio, argc/argv handling, crt0 startup
options and `+pps -subtype=low`.

Build all examples:

```sh
cd examples/pps
make
```

Or build them manually:

```sh
zcc +pps     -clib=default -create-app hello.c        -o build/hello
zcc +pps     -clib=default -create-app argv.c         -o build/argv
zcc +pps     -clib=default -create-app clear_screen.c -o build/clear
zcc +pps -subtype=low -clib=default -create-app hello.c -o build/hello_low
```

`+pps` loads at `$8100` and uses stack `$BFFF`.
`+pps -subtype=low` loads at `$4100` and uses stack `$7FFF`. If a program is
large enough to cross `$7FFF`, set `REGISTER_SP` explicitly instead of
using that stack placement unchanged.

The crt0 leaves the DSS console untouched by default. Use
`CRT_CLEAR_SCREEN=1` when a program needs to clear the screen before
`main()`.
