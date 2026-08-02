# Z88DK - The Development Kit for Z80 Computers

![WinXP+](doc/images/windows.png) ![MacOSX](doc/images/mac.png) ![Linux and Other](doc/images/linux.png)

Z88DK is a collection of software development tools that targets the 8080 and z80 family of machines. It allows development of programs in C, assembly language or any mixture of the two. What makes z88dk unique is its ease of use, built-in support for many z80 machines and its extensive set of assembly language library subroutines implementing the C standard and extensions.

## INSTALLATION

There are several ways to install z88dk.

1. Use the [Most Recent Official Release](https://github.com/z88dk/z88dk/releases). Follow these [installation instructions](https://github.com/z88dk/z88dk/wiki/installation).
2. Get the [Nightly Build](http://nightly.z88dk.org/). Every night we build complete binary packages for **Windows** and **macOS** and generate source packages for everyone else. The simple [installation instructions](https://github.com/z88dk/z88dk/wiki/installation) should be followed. Using a nightly build means you can keep up with bugfixes and new features rather than waiting for a formal release. (Use **http://** for the nightly site; HTTPS is not always available.)
3. Use the [Snap package](https://github.com/z88dk/z88dk/wiki/Snap-usage) on Linux.
4. Use the [Docker image](https://hub.docker.com/r/z88dk/z88dk).
5. Use GitHub and build it yourself. The z88dk repository uses git submodules; they are not downloaded by a plain `git clone` unless you ask for them. Prefer `git clone --recursive https://github.com/z88dk/z88dk.git`. On an existing clone: `git submodule update --init --recursive`. Then follow the [Linux / Unix build instructions](https://github.com/z88dk/z88dk/wiki/installation#linux--unix).

After install, set **`PATH`** to include `z88dk/bin` and **`ZCCCFG`** to `z88dk/lib/config`. See the [Getting started](https://github.com/z88dk/z88dk/wiki/Getting-Started) wiki page for a first compile.

## The Tools

The front end of z88dk is called `zcc`. Call it for normal compilations. It accepts C (`.c`), preprocessed C (`.i`), assembly (`.asm` / `.s`), optimised assembly (`.opt`), and object files (`.o`), mixed in any combination, and can process a `@list` of files. Linking produces a binary for the selected target; `-create-app` runs appmake for tapes, disks, ROMs, hex files, and so on.

It is not usually necessary for a new user to invoke the other tools directly.

Many tools have a `z88dk-` prefix to avoid clashing with packages that ship tools of the same name. Documentation often omits the prefix when referring to them.

* `zcc` is the toolchain front end. See [Tool — zcc](https://github.com/z88dk/z88dk/wiki/Tool---zcc).
* `z88dk-sccz80` is z88dk's native C compiler (Small-C lineage; near C90 with extensions). Default for many classic and newlib recipes.
* `z88dk-80cc` is an alternate small-C front end (`-compiler=80cc`). It shares classic-compatible library linkage with sccz80 and appears in some float benchmarks under `support/benchmarks`.
* `z88dk-zsdcc` is z88dk's patched [sdcc](https://sdcc.sourceforge.net/). [Our patch](https://github.com/z88dk/z88dk/tree/master/src/zsdcc) integrates sdcc with z88dk libraries and CRTs. Select with `-clib=sdcc_iy` (preferred) or `-clib=sdcc_ix` on targets that define those CLIBs. See [Compilers](https://github.com/z88dk/z88dk/wiki/Compilers).
* `z88dk-z80asm` is the assembler / linker / librarian (sections, macros, multi-CPU). Not the same project as other tools named “z80asm”. See [Tool — z80asm](https://github.com/z88dk/z88dk/wiki/Tool---z80asm).
* `z88dk-z80nm` lists symbols in object and library files. See [Tool — z80nm](https://github.com/z88dk/z88dk/wiki/Tool---z80nm).
* `z88dk-appmake` turns linked binaries into machine images (hex, tape, disk, ROM, …). See [Tool — appmake](https://github.com/z88dk/z88dk/wiki/Tool---appmake).
* `z88dk-ticks` is a command-line CPU emulator for cycle counts, debugging, and hotspot profiles. Match the CPU model (`-m8085`, …). Help is bare invocation (not `-h`). See [Tool — ticks](https://github.com/z88dk/z88dk/wiki/Tool---ticks).
* `z88dk-gdb` is a gdb client for gdbserver-based debugging (emulators or hardware). See [Tool — gdb](https://github.com/z88dk/z88dk/wiki/Tool-z88dk-gdb).
* `z88dk-dis` is a multi-CPU disassembler (8080/8085, gbz80, z80/z80n, z180, ez80 modes, R800, Rabbit family, kc160). Can load z80asm map files. See [Tool — dis](https://github.com/z88dk/z88dk/wiki/Tool-z88dk-dis).
* `z88dk-lib` installs third-party libraries. Classic packages: `lib/clibs/lib/<target>/` and `include/lib/<target>/`. Newlib packages: libraries under `lib/clibs/{sccz80,sdcc_ix,sdcc_iy}/lib/<target>/` and headers under `include/_DEVELOPMENT/{proto,common}/lib/<target>/`. See [Tool — z88dk-lib](https://github.com/z88dk/z88dk/wiki/Tool---z88dk-lib).
* `z88dk-zx0` / `z88dk-zx7` and `z88dk-dzx0` / `z88dk-dzx7` are host compressors and decompressors; matching decompressors exist in the target libraries.

Not normally run by hand:

* `m4` — macro pass for `.asm.m4` / CRT generation.
* `z88dk-ucpp` — C preprocessor for sccz80 and zsdcc.
* `z88dk-zpragma` — pragma processing.
* `z88dk-copt` — peephole on **compiler** output (not hand-written `libsrc` asm). See [Tool — copt](https://github.com/z88dk/z88dk/wiki/Tool---copt).

Tool map and measurement workflows: [tools](https://github.com/z88dk/z88dk/wiki/tools).

## Benchmarks

The assembly libraries give z88dk strong performance relative to many other Z80 C environments. See the wiki [Benchmarks](https://github.com/z88dk/z88dk/wiki/Benchmarks) page.

Sources, recipes, and cycle counts live under [`support/benchmarks`](https://github.com/z88dk/z88dk/tree/master/support/benchmarks). Each program has a top-level `readme.txt` and toolchain notes (for example `z88dk-classic/`). Timing is typically classic `+test` plus `z88dk-ticks` between `TIMER_START` / `TIMER_STOP` (use `-m8085` for 8085 images).

Floating-point comparisons cover genmath, math48, **mbf32** / **mbf32_8085**, IEEE **math32** / **math32_8085**, and half-precision **math16** / **math16_8085** where published (see [Classic Maths Libraries](https://github.com/z88dk/z88dk/wiki/Classic--Maths-Libraries) and `libsrc/math/float/math32/readme.md`). sccz80 covers z80 and 8085 where applicable; zsdcc is Z80-class only. Some float benches also include **80cc**.

* **Dhrystone 2.1** — synthetic integer benchmark from the 1980s era.
* **Pi** — mainly 32-bit integer performance.
* **Sieve of Eratosthenes** — small-compiler classic; mostly loop overhead.
* **Whetstone 1.2** — synthetic float (includes mbf32 / mbf32_8085).
* **n-body, mandelbrot, fasta, spectral-norm** — float workloads comparing math32, mbf32, and related libraries on z80 and 8085.
* **Program size** — CP/M binary size comparisons for small systems.

## Using cmake to build z88dk projects

CMake can drive Z88DK projects (a toolchain file is provided). See the [CMake](https://github.com/z88dk/z88dk/wiki/CMake) wiki page.

## Using z88dk

Important facts:

* There are **two C library worlds**: **classic** and **newlib** (headers and CRTs differ). See [Headers: classic and newlib](https://github.com/z88dk/z88dk/wiki/Headers-Classic-vs-Newlib).
* There are **several C compilers**: **sccz80** (default many recipes), **zsdcc**, **80cc**, and experimental **ez80-clang**. Classic projects can mix sccz80 and zsdcc objects more freely; newlib projects should use one compiler for the whole link. See [Compilers](https://github.com/z88dk/z88dk/wiki/Compilers).

When you form a compile line you choose a **target** (`+name`), a **compiler**, and a **library** (`-clib=`). That choice depends on the machine and features you need.

The **classic** library is the main library for [over 100 machines](https://github.com/z88dk/z88dk/wiki/Platform). Support depth varies by interest. Start at the [wiki Home](https://github.com/z88dk/z88dk/wiki) or [Getting started](https://github.com/z88dk/z88dk/wiki/Getting-Started). Examples: [`examples/`](https://github.com/z88dk/z88dk/tree/master/examples) (compile lines often at the top of `.c` files). Overview: [Classic-Overview](https://github.com/z88dk/z88dk/wiki/Classic-Overview).

The **newlib** rewrite aims at a large C11-style subset and ROM-friendly layouts. It still matters for targets such as [HBIOS / RomWBW](https://github.com/wwarthen/RomWBW/blob/master/Doc/RomWBW%20System%20Guide.pdf) (`+hbios`), [RC2014](https://rc2014.co.uk/) (`+rc2014`), [SCZ180](https://smallcomputercentral.wordpress.com/sc130-z180-motherboard/) (`+scz180`), [YAZ180](https://github.com/feilipu/yaz180) (`+yaz180`), plus newlib-oriented builds of [SMS](https://en.wikipedia.org/wiki/Master_System), [ZX Spectrum](https://en.wikipedia.org/wiki/ZX_Spectrum), and [Spectrum Next](https://www.specnext.com/). Bare metal: [z80 embedded](https://github.com/z88dk/z88dk/wiki/Platform---Z80-Embedded) (`+z80` / `+embedded`). Docs: [Newlib overview](https://github.com/z88dk/z88dk/wiki/Newlib-Overview) and [Introduction](https://github.com/z88dk/z88dk/wiki/Introduction). Examples: [`libsrc/_DEVELOPMENT/EXAMPLES`](https://github.com/z88dk/z88dk/tree/master/libsrc/_DEVELOPMENT/EXAMPLES).

## Quick links

| Link | What |
|------|------|
| [z88dk.org](https://www.z88dk.org/) / [forum](https://www.z88dk.org/forum/) | Project site and discussion |
| [Install](https://github.com/z88dk/z88dk/wiki/installation) | Installation wiki |
| [Getting started](https://github.com/z88dk/z88dk/wiki/Getting-Started) | First `zcc` compile |
| [Compilers](https://github.com/z88dk/z88dk/wiki/Compilers) | sccz80 / zsdcc / 80cc / clang |
| [Tools](https://github.com/z88dk/z88dk/wiki/tools) | Tool index (including ticks methodology) |
| [Platform index](https://github.com/z88dk/z88dk/wiki/Platform) | Classic target matrix |
| [Bug reporting](https://github.com/z88dk/z88dk/issues) | GitHub issues |
| Classic docs | [Classic-Overview](https://github.com/z88dk/z88dk/wiki/Classic-Overview) · examples [`examples/`](https://github.com/z88dk/z88dk/tree/master/examples) |
| Newlib docs | [Newlib-Overview](https://github.com/z88dk/z88dk/wiki/Newlib-Overview) · examples [`libsrc/_DEVELOPMENT/EXAMPLES`](https://github.com/z88dk/z88dk/tree/master/libsrc/_DEVELOPMENT/EXAMPLES) |
| [RC2014 + z88dk](https://github.com/RC2014Z80/RC2014/wiki/Using-Z88DK) | `+rc2014`, `+hbios`, CP/M on RC2014 |
| [ZX Spectrum (classic wiki)](https://github.com/z88dk/z88dk/wiki/Platform---Sinclair-ZX-Spectrum) | Spectrum platform page |
| [ZX Spectrum newlib getting started](https://github.com/z88dk/z88dk/blob/master/doc/ZXSpectrumZSDCCnewlib_GettingStartedGuide.md) | Newlib Spectrum guide (in-tree) |
| [doc/target/zx](https://github.com/z88dk/z88dk/tree/master/doc/target/zx) | Spectrum tutorial series in `doc/` |
