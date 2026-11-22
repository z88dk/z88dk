# CP/M FCB file driver (`cpm_01_file`)

Newlib **FDSTRUCT** driver that implements unprefixed fcntl (`open` / `creat` /
`read` / `write` / `lseek` / `close`) on **CP/M BDOS FCB** files.

## Who uses it

| Target | How |
|--------|-----|
| **`+cpm -clib=new` / `sdcc_ix` / `sdcc_iy`** | Default newlib CP/M CRT (`open_max` 16, stdio heap 1024) |
| `+rc2014 -subtype=cpm` | Hardware target under host CP/M (startup 128) |
| `+yaz180 -subtype=cpm` | Same pattern (startup 64) |
| `+scz180 -subtype=cpm` | Same pattern (startup 64) |

Pulled in via `libsrc/target/cpm/driver/driver.lst` → `file/cpm_01_file.lst`
into `cpm.lib` (sccz80 / sdcc_ix).

## Policy (BDOS only on `+cpm`)

| API | Backend |
|-----|---------|
| `open` / `creat` / `read` / `write` / `lseek` / `close` | **This driver** → BDOS FCB (host CP/M volumes, e.g. A:) |
| `printf` / console `FILE*` | BDOS CON / RDR / PUN / LST terminals in the CPM CRT |
| FatFs `f_*` / physical `diskio` | **Not part of `+cpm`**. Optional only on hardware targets that link `ff` + a package `diskio`. |

On plain `+cpm` there is no FatFs dual-stack and no target physical drivers — full
file access is **BDOS FCB** through this driver.

## Hooks

`asm_vopen` calls optional target hooks:

- `asm_target_open_p1` / `asm_target_open_p2` — provided by this driver

Classic `libsrc/target/cpm/fcntl/` is the historical FCB implementation for
**classic** `+cpm` CLIBs (`default`, `8080`, `8085`, …). Do not mix those objects
with this newlib driver in one binary (two owners of `open`).

## CRT requirements

CRT must reserve FD table slots and stdio heap for console FILEs plus user
`open`s: **`open_max` 16**, **stdio heap 1024** (as in `target/cpm/crt_config.inc`
and the hardware `subtype=cpm` CRT configs).

## Tests

```bash
# FCB open/read/write on +rc2014 -subtype=cpm -clib=new
make -C test/suites/target_io test_rc2014_cpm.com

# +cpm -clib=new link smoke (open/read/write resolve to cpm_01_file)
zcc +cpm -clib=new -vn app.c -o app -create-app
```

## Further reading

- `libsrc/_DEVELOPMENT/EXAMPLES/z80/stdio_target/readme.md` §9 — dual-stack recipes (hardware)  
- `libsrc/newlib/fcntl/z80/asm_vopen.asm` — open path / heap / hooks  
