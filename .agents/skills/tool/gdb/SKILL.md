---
name: tool-gdb
description: >
  z88dk-gdb source-level debug bridge when target supports it. Use for interactive debug beyond ticks.
---

# Tool — gdb

| | |
|--|--|
| Binary | `z88dk-gdb` |
| Help | bare usage |
| Wiki (local draft) | `wiki/tools/Tool-z88dk-gdb.md` |

For cycle counts and hotspots prefer `tool/ticks`.

## Condensed reference (from wiki / tree)

# Tool — gdb (`z88dk-gdb`)

GDB client for z88dk. Connects to a gdbserver (emulator or hardware) for source-level style debugging with symbol files.

## Live usage text

```text
----------------------------------
z88dk-gdb, a gdb client for z88dk.
----------------------------------

See the following for a list of compatible gdb servers: https://github.com/z88dk/z88dk/wiki/Tool-z88dk-gdb

Usage: z88dk-gdb -h <connect host> -p <connect port> -x <debug symbols> [-x <debug symbols>] [-v]
   or: z88dk-gdb -d <device> -x <debug symbols> [-x <debug symbols>] [-v]
```

## Quick forms

```text
z88dk-gdb -h <host> -p <port> -x <symbols>
z88dk-gdb -d <device> -x <symbols>
```

`-v` increases verbosity. You may pass more than one `-x` symbol file.


## Methodology

Use **gdb** when you need source-level debug against a gdbserver (emulator or hardware). For pure cycle counts and PC histograms on a linked binary, prefer [ticks](Tool---ticks) (`-debug`, `hotspot on`) without a remote server.

| Situation | Prefer |
|-----------|--------|
| TIMER / library cycles on `+test` | ticks |
| Hotspot histogram | ticks `hotspot on` |
| IDE + gdbserver (MAME, FUSE, …) | z88dk-gdb |
| Confirm symbol linkage | [z80nm](Tool---z80nm) + map |

## Related

- [Tool — ticks](Tool---ticks) (local cycle emu / debugger)
- Compatible servers: see project issues/docs for current list; confirm against your emulator version.

## Related

- Driver front end: `tool/zcc`
- Measurement: `methodology/measure`, `tool/ticks`
