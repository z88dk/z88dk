# CP/M FCB file driver (`cpm_01_file`)

Newlib **FDSTRUCT** driver that implements unprefixed fcntl (`open` / `creat` /
`read` / `write` / `lseek` / `close`) on **CP/M BDOS FCB** files.

Used by migrated targets when linked under **`-subtype=cpm`**:

| Target | Subtype / startup |
|--------|-------------------|
| rc2014 | `-subtype=cpm` → startup 128 |
| yaz180 | `-subtype=cpm` → startup 64 |
| scz180 | `-subtype=cpm` → startup 64 |

Pulled in via `libsrc/newlib/target/cpm/driver/driver.lst` → `file/cpm_01_file.lst`.

## Dual-stack policy

| API | Backend |
|-----|---------|
| `open` / `read` / `write` / `lseek` / `close` | **This driver** → BDOS FCB (host CP/M volumes, e.g. A:) |
| `f_open` / `f_read` / … (ChaN FatFs) | Third-party `ff` + target/package `diskio` (raw media, e.g. 0:) |
| `printf` / `FILE*` | BDOS console terminals already in the CPM CRT |

`f_*` is **never** an alias for FCB fcntl. Volumes stay independent.

## Hooks

`asm_vopen` calls optional target hooks:

- `asm_target_open_p1` / `asm_target_open_p2` — provided by this driver for CPM subtypes

Classic `libsrc/target/cpm/fcntl/` is the historical FCB implementation for
**`+cpm`**; do not mix those objects with this newlib driver in one binary
(two owners of `open`).

## CRT requirements

CPM subtype CRTs need enough static FD table and stdio heap for console FILEs
plus user `open`s (rc2014 / yaz180 / scz180: `open_max` 16, stdio heap 1024).

## Tests

```bash
make -C test/suites/target_io   # includes test_rc2014_cpm.com
```

## Further reading

- HANDOFF §12 (policy + recipes) — off-tree plan next to the z88dk tree  
- `libsrc/_DEVELOPMENT/EXAMPLES/z80/stdio_target/readme.md` §9 — dual-stack recipes  
- `libsrc/newlib/fcntl/z80/asm_vopen.asm` — open path / heap / hooks  
