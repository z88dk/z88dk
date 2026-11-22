---
name: tool-z88dk-lib
description: >
  z88dk-lib library packaging helper. Use when installing or packaging clibs per project docs.
---

# Tool — z88dk-lib

| | |
|--|--|
| Binary | `z88dk-lib` |
| Help | wiki Tool---z88dk-lib |
| Wiki (local draft) | `wiki/tools/Tool---z88dk-lib.md` |



## Condensed reference (from wiki / tree)

# Tool — z88dk-lib

Installer for **third-party** libraries (FatFs, diskio, freertos packages, and similar).

## Usage (live)

```text

Z88DK-LIB v25141-6b30e0885e-20260716
Third Party Library Installer

Usage:

  z88dk-lib +target [flags] libname1 libname2 ...
  +target      : select target
  -f           : overwrite or delete files without confirmation
  -r, --remove : remove listed libraries from z88dk instead of adding

  z88dk-lib +target
  list installed libraries for target
```

## Install paths (README)

| World | Libraries | Headers |
|-------|-----------|---------|
| Classic | `lib/clibs/lib/<target>/` | `include/lib/<target>/` |
| Newlib | `lib/clibs/{sccz80,sdcc_ix,sdcc_iy}/lib/<target>/` | `include/_DEVELOPMENT/{proto,common}/lib/<target>/` |

Common headers under newlib are often generated from **proto** via m4.

## Related

- [Newlib File I/O and FatFs](Newlib_File_IO_and_FatFs)
- [Headers: classic and newlib](Headers-Classic-vs-Newlib)
- Package sources often: https://github.com/feilipu/z88dk-libraries

## Related

- Driver front end: `tool-zcc`
- Measurement: `methodology-measure`, `tool-ticks`
