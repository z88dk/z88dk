# Custom newlib stdio drivers (application-side, generic `+z80`)

Shows how to implement **stdin / stdout / stderr** for a program by supplying a custom
driver instantiation file, without adding a full z88dk target.

Must customize the asm functions under `terminal/term_01_output_char/` (and input) for the
real hardware or emulator.

**Post-migration targets** (`hbios`, `scz180`, `yaz180`, `rc2014`, and new targets under
`libsrc/target/`) wire stdio inside the **target CRT0** and library instead. See:

→ **[../stdio_target/readme.md](../stdio_target/readme.md)** — how newlib CRT0 + stdio are
produced for migrated targets, and a checklist for adding a new newlib target.

---

## Files

| File | Role |
|------|------|
| `crt_driver_instantiation.asm.m4` | Static FILE/FDSTRUCT setup (stdin, stdout, stderr dup) |
| `zpragma.inc` | `#pragma output CRT_INCLUDE_DRIVER_INSTANTIATION = 1` |
| `terminal/term_01_*.m4` + `.asm` | Example console_01-style char terminal drivers |
| `test.c` | Tiny printf/scanf loop |
| `zproject.lst` | Sources to link |

The CRT includes `crt_driver_instantiation.asm.m4` when the pragma is set (same hook used by
target startups when `M4__CRT_INCLUDE_DRIVER_INSTANTIATION != 0`).

## Compile

sccz80:

```bash
zcc +z80 -vn -clib=new @zproject.lst -o test -pragma-include:zpragma.inc -create-app
```

zsdcc:

```bash
zcc +z80 -vn -clib=sdcc_iy -SO3 --max-allocs-per-node200000 @zproject.lst -o test -pragma-include:zpragma.inc -create-app
```

## Notes

- `m4_file_dup(_stderr, …)` attaches stderr to the same FDSTRUCT as stdout.
- Input is tied to the output terminal FDSTRUCT so echo/line editing can write back.
- For multi-port serial or production targets, prefer the target CRT pattern in
  `stdio_target/` rather than copying this tree into every application.
