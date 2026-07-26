# Newlib stdio + CRT0 for targets under `libsrc/target/` (post-migration)

This note is a companion to [`../stdio/`](../stdio/), which shows **application-side** custom
driver instantiation on the generic `+z80` target (override CRT drivers with a local
`crt_driver_instantiation.asm.m4`).

Here we document how **stdin / stdout / stderr** (and optional extra FILEs) are produced for
**newlib targets hosted under `libsrc/target/<name>/`** after the migration of `hbios`,
`scz180`, `yaz180`, and `rc2014`. Use this as a checklist when adding a **new** newlib target
with the newlib CRT0 pipeline and newlib stdio.

Migrated reference implementations (live trees):

| Target | Home | Typical default serial drivers |
|--------|------|--------------------------------|
| **hbios** | `libsrc/target/hbios/` | `rc_01_{input,output}_hbios0` (+ hbios1 as tty*) |
| **scz180** | `libsrc/target/scz180/` | ASCI / HBIOS terminals (shares hbios pieces where identical) |
| **yaz180** | `libsrc/target/yaz180/` | ASCI0/ASCI1 (local ASCI, not shared with scz180) |
| **rc2014** | `libsrc/target/rc2014/` | ACIA / SIO / UART / BASIC / CP/M consoles by subtype |

---

## 1. Stdio stack (unchanged model)

```text
  C: printf / scanf / FILE*
           │
           ▼
  libsrc/newlib/stdio   (FILE, FDSTRUCT, message dispatch)
           │
     ┌─────┴─────┐
     ▼           ▼
 character_00   console_01          (abstract drivers)
 (simple I/O)   (line-edit terminal)
     │           │
     ▼           ▼
 target driver thin adapters
   e.g. rc_01_input_hbios0 / rc_01_output_uarta / rc_00_* character
     │
     ▼
 target device layer
   e.g. device/acia, device/uart, HBIOS API, ASCI
```

- **stdio** and **fcntl** (FDSTRUCT, fd table) stay under `libsrc/newlib/`.
- **Terminal / character drivers** for a target live under  
  `libsrc/target/<name>/driver/…` (and sometimes shared `libsrc/target/hbios/…`).
- **Device** code (IRQ buffers, `*_getc` / `*_putc`) lives under  
  `libsrc/target/<name>/device/…` or classic HBIOS API paths.

Defaults for most startups use **console_01** via `rc_01_*` (line editing, echo, cook).  
Simpler serial-only paths use **character_00** via `rc_00_*` (see  
`libsrc/newlib/drivers/character/readme.txt` and rc2014 `driver/character/`).

---

## 2. Layout of a post-migration newlib target

```text
libsrc/target/<name>/
  config.m4                 # master config (pipeline A)
  config/<fragments>.m4
  config_<name>.h           # generated
  config_<name>_{public,private}.inc
  crt_config.inc
  crt_memory_map.inc
  <name>_crt.asm.m4         # CRT0 selector (pipeline B entry)
  <name>_rules.inc
  startup/<name>_crt_N.asm.m4
  driver/…                  # terminals, diskio, … + *.m4 instantiators
  device/…                  # optional hardware
  library/<name>_sccz80.lst
  library/<name>_sdcc_ix.lst
  library/…                 # pulls newlib/stdio, fcntl, drivers, target lists

lib/config/<name>.cfg       # zcc: CRT0 path, CLIB, SUBTYPE → -startup=N
lib/clibs/sccz80/<name>.lib # build product (and sdcc_ix/)
```

Shared newlib pieces (do **not** copy into the target):

- `lib/crt/newlib/*` — CRT defaults, page zero, `m4_file_dup`, `clib_instantiate_*.m4`
- `libsrc/newlib/stdio`, `fcntl`, `drivers/terminal/console_01`, `drivers/character`
- `src/m4/z88dk.m4`

Register the target as migrated in `libsrc/newlib/Makefile`:

```make
MIGRATED_TARGETS = hbios scz180 yaz180 rc2014   # add <name>
```

Sources are then taken from `../target/<name>` instead of `newlib/target/<name>`.

---

## 3. Two m4 pipelines (must both work)

### Pipeline A — config at library build time

```bash
make -C libsrc/newlib <name>
```

Runs host `m4` on `libsrc/target/<name>/config.m4` three ways:

| Flag | Output |
|------|--------|
| `-DCFG_ASM_DEF` | `config_<name>_private.inc` → `obj/config_private.inc` for assembling the target `.lib` |
| `-DCFG_ASM_PUB` | `config_<name>_public.inc` — CRT and apps |
| `-DCFG_C_DEF` | `config_<name>.h` — via `include/_DEVELOPMENT/…/arch.h` |

Library objects and the final archive go to **classic-aligned** product dirs:

```text
lib/clibs/sccz80/<name>.lib
lib/clibs/sdcc_ix/<name>.lib
```

Third-party packages (`z88dk-lib +<name> -f …`) install under:

```text
lib/clibs/{sccz80,sdcc_ix,sdcc_iy}/lib/<name>/
include/_DEVELOPMENT/{proto,common}/lib/<name>/
```

### Pipeline B — CRT0 at every `zcc +<name>` link

`lib/config/<name>.cfg` points at the selector m4, e.g. hbios:

```text
CLIB  new … -lhbios -LDESTDIR/lib/clibs/sccz80 \
      -Ca-IDESTDIR/libsrc/target/hbios \
      -Cl-IDESTDIR/libsrc/target/hbios \
      -crt0=DESTDIR/libsrc/target/hbios/hbios_crt.asm.m4
```

`zcc` writes `zcc_opt.def` (`startup`, pragmas), runs m4 with include paths for the
target home + `src/m4`, expands `<name>_crt.asm.m4` → temporary CRT `.asm`, assembles and
links it first.

Selector pattern (`hbios_crt.asm.m4`): map `__STARTUP` / `-startup=N` / `SUBTYPE` to
`startup/<name>_crt_N.asm.m4` and `__CRTCFG`.

---

## 4. Where stdin / stdout / stderr are created

Instantiation is **static**, inside the CRT m4 for each startup, between:

```m4
include(`crt/newlib/clib_instantiate_begin.m4')
… drivers …
include(`crt/newlib/clib_instantiate_end.m4')
```

### Default path (shipped startup)

Excerpt from `libsrc/target/hbios/startup/hbios_crt_0.asm.m4` (pattern used by all migrated
targets):

```m4
ifelse(eval(M4__CRT_INCLUDE_DRIVER_INSTANTIATION == 0), 1,
`
   include(`driver/terminal/rc_01_input_hbios0.m4')
   m4_rc_01_input_hbios0(_stdin, __i_fcntl_fdstruct_1, CRT_ITERM_TERMINAL_FLAGS, M4__CRT_ITERM_EDIT_BUFFER_SIZE)

   include(`driver/terminal/rc_01_output_hbios0.m4')
   m4_rc_01_output_hbios0(_stdout, CRT_OTERM_TERMINAL_FLAGS)

   include(`crt/newlib/m4_file_dup.m4')
   m4_file_dup(_stderr, 0x80, __i_fcntl_fdstruct_1)

   ; optional second port as ttyin / ttyout / ttyerr …
',
`
   include(`crt_driver_instantiation.asm.m4')
')
```

| Piece | Role |
|-------|------|
| `m4_rc_01_input_*(_stdin, __i_fcntl_fdstruct_1, flags, edit_sz)` | FILE `stdin` tied to output FDSTRUCT of stdout; line editor buffer |
| `m4_rc_01_output_*(_stdout, flags)` | FILE `stdout` |
| `m4_file_dup(_stderr, 0x80, __i_fcntl_fdstruct_1)` | `stderr` is a **dup** of stdout’s FDSTRUCT (same device) |
| Extra ports | Call the m4 macro again with new FILE labels (`_ttyin`, …) |

Driver m4 files live next to the driver asm, e.g.  
`libsrc/target/hbios/driver/terminal/rc_01_input_hbios0.m4`.

### Application override (same mechanism as `../stdio/`)

```c
#pragma output CRT_INCLUDE_DRIVER_INSTANTIATION = 1
```

Then supply `crt_driver_instantiation.asm.m4` in the project (see `../stdio/crt_driver_instantiation.asm.m4`).  
The CRT includes that file instead of the default driver block. Multi-port and `m4_file_dup`
must still be respected if you need stderr/ttyerr semantics.

### Subtype `none` / high startup numbers

Startups such as hbios/yaz180 **256** instantiate **no** default drivers: empty stdio until the
user provides `crt_driver_instantiation.asm.m4` (or opens devices at runtime where supported).

---

## 5. Library list must pull newlib stdio

`library/<name>_sccz80.lst` (and `_sdcc_ix.lst`) should include at least:

```text
@../newlib/stdio/stdio_sccz80.lst
@../newlib/fcntl/fcntl_sccz80.lst
@../newlib/drivers/drivers.lst
@../target/<name>/driver/driver_sccz80.lst
```

(plus alloc, string, target devices, etc. as needed).  
Without `stdio` + `fcntl` + drivers, CRTs can link but FILEs will not be usable.

Build:

```bash
export PATH=…/z88dk/bin:$PATH ZCCCFG=…/z88dk/lib/config
make -C libsrc/newlib <name>
```

---

## 6. Minimal checklist: add a new newlib target

1. **Tree** under `libsrc/target/<name>/` (config, CRT selector, startups, drivers, library lists).
2. **`MIGRATED_TARGETS`** in `libsrc/newlib/Makefile` (if sources live under `libsrc/target/`).
3. **`lib/config/<name>.cfg`**
   - `CLIB new` / `sdcc_ix` / `sdcc_iy` with  
     `-crt0=…/libsrc/target/<name>/<name>_crt.asm.m4`  
     `-Ca-I` / `-Cl-I` → target dir  
     `-l<name>` and `-LDESTDIR/lib/clibs/sccz80` or `…/sdcc_ix`  
   - `SUBTYPE` → `-startup=N` matching the CRT selector.
4. **`arch.h`** (common + proto): map `config_<name>.h` if the target exposes arch defines.
5. **Stdio drivers**
   - Prefer reusing `console_01` via thin `rc_01_*` adapters over a documented device contract  
     (`getc` / `putc` / `pollc` / flush / init — see character readme).
   - Ship m4 instantiators; wire them in each `startup/*_crt_N.asm.m4`.
   - Dup stderr (and ttyerr) with `m4_file_dup` unless a distinct error device is required.
6. **Library lists** include `newlib/stdio`, `fcntl`, `drivers`, and target driver/device lists.
7. **Build + smoke**
   ```bash
   make -C libsrc/newlib <name>
   zcc +<name> -clib=new -vn hello.c -o hello -create-app
   zcc +<name> -clib=sdcc_iy -vn hello.c -o hello -create-app
   ```
8. **Optional:** subtype `none` + documented `CRT_INCLUDE_DRIVER_INSTANTIATION` for bare boards.
9. **Do not** merge classic stdio cores into the newlib path; hybrid designs (e.g. rc2014-8085)
   keep classic `f*cons` + newlib devices/CRT only where that model is intentional.

---

## 7. Pre-migration example vs this guide

| | [`../stdio/`](../stdio/) | This guide (`stdio_target/`) |
|--|--------------------------|------------------------------|
| Purpose | Teach custom **per-program** driver instantiation | Teach **target** CRT + library layout for newlib stdio |
| Typical command | `zcc +z80 -clib=new @zproject.lst … -pragma-include:zpragma.inc` | `zcc +hbios` / `+rc2014` / … with target cfg CRT0 |
| Driver home | Copy under the app (`terminal/term_01_*`) | `libsrc/target/<name>/driver/…` built into `<name>.lib` |
| When to use | One-off boards, experiments, override defaults | Permanent target support in z88dk |

Both use the same primitives: driver m4 instantiators, `m4_file_dup`,  
`CRT_INCLUDE_DRIVER_INSTANTIATION`, and `lib/crt/newlib/*`.

---

## 8. Further reading

- `libsrc/newlib/drivers/character/readme.txt` — character_00 contract; multi-port + dup  
- `lib/crt/newlib/` — CRT includes and file-instantiation m4  
- Live CRTs: `libsrc/target/hbios/startup/`, `…/rc2014/startup/`, `…/yaz180/startup/`  
- Config examples: `lib/config/hbios.cfg`, `lib/config/rc2014.cfg`  
- Product paths: `lib/clibs/sccz80/`, `lib/clibs/sdcc_ix/` (and third-party `lib/<target>/` under those)
