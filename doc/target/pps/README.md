# Peters Plus Sprinter (`+pps`)

The `+pps` target builds raw Estex DSS EXE files for the Peters Plus
Sprinter. The 512-byte EXE header is emitted by crt0, so no separate
appmake conversion is needed:

```sh
zcc +pps -clib=default -create-app hello.c -o hello
```

Copy the result to a DSS disk image or FAT media as an 8.3 EXE name.

## Memory Layouts

`+pps` has two predefined layouts:

| Target | Code | Stack | Use case |
| ------ | ---- | ----- | -------- |
| `+pps` | `$8100` | `$BFFF` | Default program loaded into WIN2. |
| `+pps_low` | `$4100` | `$7FFF` | Low-origin layout starting in WIN1. |

`+pps_low` is the same crt0 with:

```sh
-pragma-define:CRT_ORG_CODE=0x4100 -pragma-define:CRT_STACK=0x7FFF
```

This only changes where the program starts and where the initial stack
is placed.

For larger programs that need to start at `$4100` and may use more than
one 16 KB window, choose the stack address explicitly. For example:

```sh
zcc +pps -clib=default -create-app \
    -pragma-define:CRT_ORG_CODE=0x4100 \
    -pragma-define:CRT_STACK=0xBFFF \
    big.c -o big
```

The important part is not the exact value above, but that `CRT_STACK`
must be compatible with the program's code, data and heap. If the image
or heap can grow through `$7FFF`, do not use the `+pps_low` stack
unchanged.

## Startup Screen

The PPS crt0 leaves the DSS console as it was on entry. It does not
clear the screen or reset the current colours by default.

Programs that want the old blank-screen startup can opt in:

```sh
zcc +pps -clib=default -create-app -pragma-define:CRT_CLEAR_SCREEN=1 clear_screen.c -o clear
```

or in source:

```c
#pragma output CRT_CLEAR_SCREEN = 1
```

The default `printf` path writes through the native DSS console output,
so it preserves the current DSS colour attributes and translates `\n`
to the CR/LF cursor-control sequence expected by DSS. `-clib=ansi`
still uses the ANSI terminal path.

## Command Line

DSS passes the command tail in a CP/M-style PSP buffer, normally with a
leading space before the first argument. The PPS crt0 normalizes that
buffer before z88dk's standard command-line parser runs, so `main(int
argc, char **argv)` does not receive an extra empty argument.

Example:

```sh
zcc +pps -clib=default -create-app examples/pps/argv.c -o argv
```

Running:

```text
ARGV.EXE one two
```

prints `argc = 3`, with `argv[1] == "one"` and `argv[2] == "two"`.

## Examples

Small smoke tests live in `examples/pps`:

```sh
cd examples/pps
make
```

The examples cover standard console output, command-line parsing,
opt-in screen clearing and the low-memory target.
