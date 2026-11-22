---
name: tool-appmake
description: >
  z88dk-appmake: binary to tape/disk/ROM/hex for emulators. Often via zcc -create-app.
---

# Tool — appmake

| | |
|--|--|
| Binary | `z88dk-appmake` |
| Help | z88dk-appmake -h; per-machine options are many |
| Wiki (local draft) | `wiki/tools/Tool---appmake.md` |


Prefer `zcc +target … -create-app` so target config selects the right appmake mode.


## Condensed reference (from wiki / tree)

# Tool — appmake (`z88dk-appmake`)

Appmake turns a raw linked binary into a form loadable by emulators or real hardware (tape, disk, ROM, Intel hex, and more).

## Quick start

Normally invoke via **zcc**:

```text
zcc +zx -vn prog.c -o prog -create-app
```

That runs appmake with the options the target cfg supplies (`-Cz` pass-through from zcc).

**What file you get and how to load it** for the targets we document heavily (`+zx`, `+zxn`, `+cpm`, `+sms`, `+rc2014`, `+hbios`): [Load and run](Load-and-Run). **Worked commands:** [Examples](Examples).

Call appmake directly when you already have a binary:

```text
z88dk-appmake +zx
z88dk-appmake +zxn
z88dk-appmake +cpmdisk -h
z88dk-appmake +hex
z88dk-appmake +rom
z88dk-appmake +sms
```

For per-target options, run `z88dk-appmake +<target>` with no other options (message from the tool itself).

## Capability summary

| | |
|--|--|
| **Binary** | `z88dk-appmake` |
| **Form** | `appmake [+target] [options]` |
| **When** | After link, or via `zcc … -create-app` |
| **Help** | Bare invocation lists `+target` forms. Then `+target` alone for that target’s flags |

… (full reference: in-tree wiki page and live tool help)


## Related

- Driver front end: `tool-zcc`
- Measurement: `methodology-measure`, `tool-ticks`
