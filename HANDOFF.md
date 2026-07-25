# Plan & Report: newlib-target-migration

**Branch:** `newlib-target-migration`  
**Workspace:** `/home/phillip/Z80/z88dk`  
**CPUs:** Z80, 8085, and Z80 derivatives (Z180 / related)

---

## 1. Goals (authoritative)

1. **Serial I/O abstraction (simplified)**  
   Implement a simplified serial interface abstraction for newlib stdio, grounded in the existing `character_00` driver class under `libsrc/newlib/drivers/character/`, coordinated with target input support patterns from `libsrc/newlib/input/` (and target-local input where present), usable by targets that live under (or will live under) the target tree.  
   **Must retain** existing CRT/m4 capabilities: instantiate **multiple** serial interfaces (not only the default stdin/stdout pair), and **dup / overload** FILEs onto existing FDSTRUCTs (e.g. `stderr` as dup of `stdout`, `ttyerr` as dup of `ttyout`, or user-defined extras) via `m4_file_dup` and optional `crt_driver_instantiation.asm.m4`.

2. **Dependency inventory (+ classic dual-tree care)**  
   Identify which additional `libsrc/newlib/*` drivers/systems are required so the following targets can be fully hosted under `libsrc/target/` (not `libsrc/newlib/target/`).  
   Also identify which newlib packages (`alloc`, `fcntl`, `threads`, `stdio`, `im2`, `input`, …) have **classic alternative implementations** under `libsrc/classic/` (or shared `libsrc/*`), and whether any can be carefully shared or bridged — **without aggressively merging the two directories** (high risk of ABI/symbol/runtime damage to classic targets).

3. **Targets in scope**  
   - `rc2014` (Z80 **and** 8085; different compilation methods)  
   - `scz180` (Z180)  
   - `yaz180` (Z180)  
   - `hbios` (Z80 / RomWBW HBIOS)

4. **CRT0 clarity (m4 pipeline first)**  
   As part of (1), fully understand and document the **m4 CRT0 generation tool chain**: how GNU m4 (via `zcc` and library makefiles) reads CRT configuration and generalised CRT sources under the target tree to emit the effective CRT0, including preparation of **public and private** config `.inc` / `.h` for each target and subtype. Only then regularise CRT0 process as needed.

5. **End state**  
   - No residual tree under `libsrc/newlib/target/{rc2014,scz180,yaz180,hbios}` once migration is complete.  
   - All required target drivers/devices/CRTs/config live under `libsrc/target/<name>/` (or shared classic/newlib locations that are not target-specific).  
   - Build and `lib/config/*.cfg` paths updated accordingly.

6. **Verification (correctness + linkage)**  
   After structural/serial/migration work, validate with **`z88dk-ticks`** (not only “it links”):
   - **rc2014 Z80** and **rc2014 8085** across the full optional math matrix (§7).  
   - Float **suite** (`test/suites/math`) where targets already have recipes, plus **benchmarks** under `support/benchmarks` with TIMER + ticks for pass/result sanity.  
   - **newlib `+cpm` is out of scope** for this project (conflicts with classic/cpm); do not extend regression gates to cpm until a later effort.

This document is both **discovery report** (current state) and **implementation plan** (phased work).

---

## 2. Current architecture (findings)

### 2.1 Two target homes today

| Location | Role today |
|----------|------------|
| `libsrc/newlib/target/<name>/` | Full **newlib** targets: config m4, CRT m4, devices, terminal drivers, library `.lst`, built into `libsrc/newlib/lib/{sccz80,sdcc_ix}/<name>.lib` |
| `libsrc/target/<name>/` | **Classic** target fragments and some shared APIs |

**Already split examples:**

| Target | `newlib/target` | `libsrc/target` |
|--------|-----------------|-----------------|
| **rc2014** | Full newlib (z80 + 8085 devices, terminals, CRT, diskio/ide/ram) | Classic `stdio/fgetc_cons_*` + `fputc_cons_*` + `rc2014-8085.lst` only |
| **hbios** | Newlib CRT + terminal + time drivers | Full HBIOS API (`z80/asm_hbios*.asm`, C wrappers) + **input/** (`in_inkey` etc.) + readme |
| **scz180** | Full newlib only | *none* |
| **yaz180** | Full newlib only | *none* |

Library lists already reach *out* of `newlib/target` into classic-style paths, e.g.:

- `@../target/hbios/hbios_sccz80.lst` (scz180 + hbios newlib libs)
- `@../target/hbios/input/input_sccz80.lst` (hbios newlib lib)
- `@../target/cpm-libs/cpm_sccz80.lst` and `@target//cpm/driver/driver.lst` (CP/M shared)

So migration is not greenfield: **hbios primitives and input already live under `libsrc/target/hbios`**, while CRT/stdio drivers remain under newlib.

### 2.2 Stdio / serial stack (three layers)

```
┌─────────────────────────────────────────────────────────────┐
│  stdio (libsrc/newlib/stdio)                                │
│  FILE → FDSTRUCT → message dispatch (GETC/PUTC/WRIT/…)      │
└────────────────────────────┬────────────────────────────────┘
                             │
     ┌───────────────────────┼───────────────────────┐
     ▼                       ▼                       ▼
 character_00            console_01              memstream / etc.
 (serial text/bin)       (line-edit terminal)
     │                       │
     │ ICHAR_MSG_GETC        │ ITERM_MSG_* + oterm
     ▼                       ▼
 device layer            device layer
 (acia_getc/putc,        (same device layer)
  uart_*, sio_*, asci_*)
```

| Layer | Path | Role |
|-------|------|------|
| **stdio core** | `libsrc/newlib/stdio` | FILE, printf/scanf, messages |
| **character_00** | `libsrc/newlib/drivers/character/` | Abstract serial/text character driver; implement one message (`ICHAR_MSG_GETC` / ochar putc) |
| **console_01** | `libsrc/newlib/drivers/terminal/console_01/` | Full input terminal (line editing, echo, ioctl); used by all current `rc_01_*` drivers |
| **Concrete terminals** | `…/target/*/driver/terminal/rc_01_{input,output}_*` | Per-UART/ACIA/SIO/ASCI/HBIOS thin adapters over `console_01` |
| **Device** | `…/target/*/device/{acia,uart,sio,asci,…}` | Buffered IRQ serial: `*_getc`, `*_putc`, `*_pollc`, `*_init`, flush |
| **Classic cons** | `libsrc/target/rc2014/stdio/f{get,put}c_cons_*` | Blocking classic consoles; **duplicate** device buffer logic for 8085 hybrid |

**Finding:** `character_00` is already the intended **simple** serial stdio abstraction. Today it is mostly infrastructure (also reused by `console_01` for read/eatc/seek). Targets instantiate the **heavy** `console_01`/`rc_01_*` path, not thin `character_00` derivatives.

**Goal (1)** is therefore: define and wire a **simplified serial solution** that:

- Documents the device contract (`pollc` / `getc` / `putc` / flush / init).
- Provides thin `character_00`-derived (or equivalent) instantiable drivers + m4 static constructors for serial ports.
- Keeps `console_01`/`rc_01_*` available where line editing is wanted, but makes the simple path first-class for ROM/serial targets.
- Aligns high-level **input** (`libsrc/newlib/input/*` and `libsrc/target/hbios/input`) with how targets expose keys vs serial (cpm input vs hbios input vs none on bare serial).
- **Preserves multi-instance and FILE-dup CRT features** (see §3.2) — simplification must not collapse to a single hard-wired stdin/stdout-only path.

### 2.3 Input systems (not the same as serial)

| Package | Used by | Notes |
|---------|---------|--------|
| `libsrc/newlib/input/cpm/` | rc2014, scz180, yaz180 newlib libs | CP/M-style key API |
| `libsrc/target/hbios/input/` | hbios newlib lib | HBIOS key poll/wait |
| `libsrc/newlib/input/{zx,sms,basic,ep}` | other targets | out of scope except as reference |

Serial terminals do **not** replace `input/*`; they serve stdio. Input is a separate API surface that some subtypes still link.

### 2.4 CRT0 process (current) — overview

There are **two distinct m4-driven pipelines**. Both must be understood before migration or serial/CRT work.

| Pipeline | When | Tool | Inputs | Outputs |
|----------|------|------|--------|---------|
| **A. Config / library build** | `make -C libsrc/newlib <target>` (and classic 8085 rule) | host `m4` | `config.m4` / `config_8085.m4` + `config/*.m4` + `src/m4/z88dk.m4` helpers | `config_<target>_private.inc`, `config_<target>_public.inc`, `config_<target>.h` (+ 8085-named variants) |
| **B. Per-program CRT0 expansion** | every `zcc +target …` link | `zcc` → host `m4` → assembler | `<target>_crt.asm.m4`, `startup/*`, `crt_config.inc`, `crt_memory_map.inc`, driver `*.m4`, `zcc_opt.def`, `lib/crt/newlib/*` | temporary pure `.asm` CRT0 object linked into the binary |

Shared infrastructure: `lib/crt/newlib/*.inc` (defaults, page zero z80/z180/8085, SP init, rules, file instantiate m4) and `src/m4/z88dk.m4`.

Per target: `<target>_crt.asm.m4` selects startup via `__STARTUP` / `-startup=N` / `SUBTYPE` in `lib/config/<target>.cfg`.

### 2.4.1 Pipeline A — config public / private / C header (library build time)

Master file: `libsrc/newlib/target/<name>/config.m4` (rc2014 also has `config_8085.m4`).

It `include`s fragment files under `config/`:

- `config_target.m4`, `config_cpu.m4` (or `config_cpu_8085.m4`), `config_clib.m4`, `config_clib_const.m4`
- device fragments: e.g. `config_acia.m4`, `config_uart.m4`, `config_sio.m4`, …
- sometimes shared: e.g. `target/cpm/config/config_cpm.m4`

**Three m4 define modes** (mutually selected by makefile flags):

| Flag | Output file (rc2014 Z80 example) | Content style |
|------|----------------------------------|---------------|
| `-DCFG_ASM_DEF` | `config_rc2014_private.inc` | `defc __SYMBOL = value` — **private** library build values; copied to `obj/config_private.inc` for assembling the target `.lib` |
| `-DCFG_ASM_PUB` | `config_rc2014_public.inc` | `PUBLIC __SYMBOL` (and related) — **public** symbols for programs/CRT includes |
| `-DCFG_C_DEF` | `config_rc2014.h` | C `#define` — exposed via `include/_DEVELOPMENT/.../arch.h` |

Makefile pattern (`libsrc/newlib/Makefile`):

```text
m4 -DCFG_ASM_DEF … target/$(1)/config.m4 > target/$(1)/config_$(1)_private.inc
m4 -DCFG_ASM_PUB … target/$(1)/config.m4 > target/$(1)/config_$(1)_public.inc
m4 -DCFG_C_DEF   … target/$(1)/config.m4 > target/$(1)/config_$(1).h
cp …_private.inc → target/$(1)/obj/config_private.inc
```

**8085 split (rc2014 only):** classic `libsrc/Makefile` runs the same three m4 modes on `config_8085.m4` → `config_rc2014-8085_{private,public}.inc` + `.h`. Include path style inside that master file uses `newlib/target/rc2014/config/...` (cwd = `libsrc/`), unlike the newlib makefile’s `target/rc2014/...` (cwd = `libsrc/newlib/`). Migration must normalise both.

Helpers in `src/m4/z88dk.m4`: `Z88DK_H2ASMDEF`, `Z88DK_H2ASMPUB`, `Z88DK_PROCESS_CONSTANTS_H`, etc. (used heavily by some targets; fragments mostly open-code `ifdef(CFG_ASM_*)`).

**Who includes what:**

| Consumer | File |
|----------|------|
| CRT startup (Z80) | `include "config_rc2014_public.inc"` |
| CRT startup (8085 hybrid) | `include "config_rc2014-8085_public.inc"` |
| Device/driver asm at lib build | `config_private.inc` / `config_rc2014-8085_private.inc` |
| C code | `config_rc2014.h` / `config_rc2014-8085.h` via arch.h |

### 2.4.2 Pipeline B — CRT0 generation at `zcc` time (program link)

This is the “m4 tool generates crt0” path the project must master.

```text
lib/config/<target>.cfg
  CRT0 / -crt0=…/<target>_crt.asm.m4
  SUBTYPE → -startup=N  (+ maybe -clib=…, -m8085)

zcc
  1. Write zcc_opt.def  (defc startup = N, pragmas, pragma-define…)
  2. Map important pragmas → m4 --define=
       startup              → __STARTUP
       startupoffset        → __STARTUP_OFFSET
       CRT_INCLUDE_DRIVER_INSTANTIATION → M4__CRT_INCLUDE_DRIVER_INSTANTIATION
       CRT_ITERM_EDIT_BUFFER_SIZE       → M4__CRT_ITERM_EDIT_BUFFER_SIZE
       CRT_APPEND_MMAP / __MMAP         → M4__*
  3. m4 include paths:
       -I <dir of crt0>          # target home (drivers, startup, crt_*.inc)
       -I <zcc_opt.def directory>
       -I DESTDIR/src/m4         # z88dk.m4
  4. Run: m4 … <target>_crt.asm.m4  →  temporary .asm
  5. Assemble + link that CRT0 first among objects
```

**Selector file** `<target>_crt.asm.m4`:

1. `include(zcc_opt.def)` (via m4) — gets `__STARTUP` default if not already defined.  
2. `ifelse(__STARTUP, N, …)` branches.  
3. Each branch sets `defc __CRTCFG = k` and `defc __MMAP = …`, then `include(startup/<target>_crt_N.asm.m4)`.  
4. Special: `__STARTUP == -1` → user-supplied `crt.asm.m4`.

**Generalised startup file** `startup/<target>_crt_N.asm.m4` (template expanded by m4):

1. `include(z88dk.m4)`  
2. `include "config_<target>_public.inc"` (or 8085 public)  
3. `include "crt/newlib/crt_defaults.inc"` (+ `crt_defaults_8085.inc` for hybrid)  
4. `include "crt_config.inc"` — **per-target CRT configuration tables** keyed by `__CRTCFG` → many `TAR__crt_*` / `TAR__clib_*` defaults (org, model, stack, heaps, eidi, …)  
5. `include crt/newlib/crt_rules.inc` + target `*_rules.inc` — resolve precedence:

   ```text
   user pragma (CRT_ORG_CODE, …)  >  TAR__* (from crt_config)  >  DEF__* (from crt_defaults)
   → final __crt_* / __clib_* symbols
   ```

6. `include crt_memory_map.inc` (m4 + asm; may pull `crt_memory_model_z80.inc` / z180)  
7. **Driver instantiation (m4 macros)** — the serial/stdio attach point:

   ```text
   include clib_instantiate_begin.m4
   include driver/terminal/rc_01_input_*.m4
   m4_rc_01_input_*( _stdin, … )
   include driver/terminal/rc_01_output_*.m4
   m4_rc_01_output_*( _stdout, … )
   m4_file_dup(_stderr, …)
   include clib_instantiate_end.m4
   ```

   Or user override: `crt_driver_instantiation.asm.m4` when `M4__CRT_INCLUDE_DRIVER_INSTANTIATION`.

8. Classic hybrid (8085 startups): instead of (7), alias `fgetc_cons` / `fputc_cons` to classic cons symbols; still use same public config + `crt_config` / page zero 8085.  
9. Runtime prologue: page zero, di/sp, data/bss init, call `_main`, exit — via `lib/crt/newlib/*.inc`.

**`crt_config.inc` is subtype configuration, not CPU config:**  
`__CRTCFG` index (set in selector from startup N) chooses ROM/app/cpm/8085-acia/… memory and clib defaults. Example rc2014: startup 0 → `__CRTCFG=0` (acia rom model); startup 2 → `__CRTCFG=1` (8085 acia); …  

**Path sensitivity:** m4 resolves `include(\`driver/terminal/…\`)` relative to `-I` target home. Moving trees requires keeping `-crt0=` and `-Ca-I` / `-Cl-I` / m4 `-I` consistent (`lib/config/*.cfg` today points at `libsrc/newlib/target/<name>`).

### 2.4.3 Artefacts checklist per target / subtype

| Artefact | Produced by | Per target | Per subtype |
|----------|-------------|------------|-------------|
| `config/*_*.m4` fragments | hand-maintained | yes | 8085 uses different master + cpu fragment |
| `config_*_private.inc` | Pipeline A | yes (+ 8085 variant) | values may differ by CPU config master |
| `config_*_public.inc` | Pipeline A | yes (+ 8085 variant) | CRT includes the matching public file |
| `config_*.h` | Pipeline A | yes | C API |
| `crt_config.inc` | hand-maintained | yes | **yes** (`IF __CRTCFG = k`) |
| `crt_memory_map.inc` | hand-maintained | yes | via `__MMAP` / m4 flags |
| `<target>_crt.asm.m4` selector | hand-maintained | yes | branches per startup N |
| `startup/*_crt_N.asm.m4` | hand-maintained | yes | **one file per subtype/startup** |
| driver `*.m4` instantiators | hand-maintained | yes | which macros invoked depends on startup |
| expanded CRT `.asm` | Pipeline B (zcc) | ephemeral | ephemeral |
| target `.lib` | z80asm + library lst | yes | 8085 classic clib separate |

### 2.4.4 CRT subtype tables (current)

Maps `SUBTYPE` → startup N → CRT template. Full m4 expand detail (public config file, `__CRTCFG`, drivers) is completed in Phase 1.

#### rc2014 (`lib/config/rc2014.cfg`)

| SUBTYPE | startup | CPU / clib | CRT file | Console model |
|---------|--------:|------------|----------|---------------|
| `acia` | 0 | Z80 newlib | `rc2014_crt_0` | newlib `rc_01_*` ACIA |
| `acia85` | 2 | **8085** `clib=rc2014-8085` | `rc2014_crt_2` | **classic** `fgetc/fputc_cons_acia` + hybrid CRT |
| `sio` | 4 | Z80 newlib | `rc2014_crt_4` | SIO A/B terminals |
| `uart` | 8 | Z80 newlib | `rc2014_crt_8` | 16550 A/B |
| `uart85` | 16 | **8085** hybrid | `rc2014_crt_16` | classic UART cons |
| `basic` | 32 | Z80 newlib (default) | `rc2014_crt_32` | BASIC I/O drivers |
| `basic85` | 64 | **8085** hybrid | `rc2014_crt_64` | classic BASIC cons |
| `cpm` | 128 | Z80 newlib | `rc2014_crt_128` | CP/M BDOS consoles |
| `none` | 256 | Z80 newlib | `rc2014_crt_256` | no drivers |

Default OPTIONS: `-clib=sdcc_iy -subtype=basic`.

#### scz180

| SUBTYPE | startup | Notes |
|---------|--------:|-------|
| `rom` | 0 | ASCI0/1 terminals |
| `hbios` | 8 | HBIOS0/1 terminals (default OPTIONS) |
| `cpm` | 64 | CP/M native consoles |
| `none` | 256 | no drivers |

CPU: `-mz180`. Libs: sccz80 + sdcc_ix/iy.

#### yaz180

| SUBTYPE | startup | Notes |
|---------|--------:|-------|
| `rom` | 0 | ASCI terminals |
| `app` | 16 | application model (default OPTIONS) |
| `cpm` | 64 | CP/M |
| `none` | 256 | no drivers |

CPU: `-mz180`. Extra devices: APU/am9511a, I2C/pca9665, ppide, diskio, time.

#### hbios

| SUBTYPE | startup | Notes |
|---------|--------:|-------|
| `default` | 0 | HBIOS terminal pair |
| `none` | 256 | no drivers |

CPU: `-mz80`. CLIB new only (no sdcc_ix/iy lines in cfg today). Depends on `libsrc/target/hbios` API + input.

### 2.5 rc2014_8085: crosslinked classic + newlib (critical)

This subtype is **not** pure newlib.

**Build (`libsrc/Makefile` → `rc2014-8085_clib.lib`):**

1. m4 `newlib/target/rc2014/config_8085.m4` → `config_rc2014-8085_{private,public}.inc` + `.h`
2. `buildgeneric,rc2014,portable` (classic portable pieces)
3. Link with `@libsrc/target/rc2014/rc2014-8085.lst`:

```
target/rc2014/stdio/fputc_cons_{basic,acia,uarta,uartb}
target/rc2014/stdio/fgetc_cons_{basic,acia,uarta,uartb}
@newlib/target/rc2014/device/device_8085_sccz80.lst   # acia/uart/8255 8080 code
@newlib/target/rc2014/driver/driver_8085_sccz80.lst   # ide + diskio 8085
@classic/stdio/stdio.lst
```

**Runtime clib (`CLIB rc2014-8085`):**

- `-m8085`, `startuplib=8085_crt0`, `-lrc2014-8085_clib`, `-lndos`
- Still uses **newlib CRT m4**: `rc2014_crt.asm.m4` with startups 2/16/64
- Those CRTs include `crt_defaults_8085.inc`, page zero 8085, **and** classic `fgetc_cons`/`fputc_cons` aliases — not `rc_01_*` FDSTRUCT instantiation
- Include paths still point at `libsrc/newlib/target/rc2014` for config

**Implication for migration:** moving trees must preserve **two** build products:

| Product | CPU | Style | Entry |
|---------|-----|-------|-------|
| `rc2014.lib` (sccz80/sdcc_ix) | Z80 | pure newlib | `make -C libsrc/newlib rc2014` |
| `rc2014-8085_clib.lib` | 8085 | classic clib + newlib devices/CRT fragments | `make -C libsrc rc2014-8085_clib.lib` |

Any path rewrite must update both the newlib library `.lst` and the classic `rc2014-8085.lst` / Makefile rules.

### 2.6 Newlib library composition (what each target pulls)

Common to all four (approximate):

- Core: adt, alloc, compress, ctype, error, fcntl, fonts, im2, inttypes, libgen, locale, math, network, setjmp, **stdio**, stdlib, string, threads, time, `newlib/drivers`
- Arch: `arch/z80` or `arch/z180` + `l/l_z80` or `l/l_z180`
- Target-local: `default/`, `device/`, `driver/`

| Target | Extra / special |
|--------|-----------------|
| rc2014 | cpm-libs, cpm/driver, input/cpm, devices acia/sio/uart/8255, terminals rc_01_*, ide, diskio, ram shadow |
| scz180 | cpm-libs, cpm/driver, **hbios** API lst, input/cpm, asci, csio SD, terminals asci+hbios, time, z180 math |
| yaz180 | cpm-libs, cpm/driver, input/cpm, asci, 8255, am9511a, pca9665, apu, i2c, ppide, diskio, time, z180 math |
| hbios | **target/hbios** API + input (not newlib/input/cpm), terminals hbios0/1, time; **no** cpm-libs in sccz80 list |

### 2.7 Source volume (approx, excluding `obj/`)

| Target | Source-ish files (asm/m4/lst/inc) | Notes |
|--------|----------------------------------:|-------|
| rc2014 | largest | dual CPU + many terminals |
| yaz180 | large | i2c/apu/disk |
| scz180 | medium | asci+csio+hbios terminals |
| hbios | smaller newlib side | bulk API already in `libsrc/target/hbios` |

---

## 2.8 Newlib vs classic dual directories (integration caution)

z88dk already maintains **two parallel C library lineages**. Target migration and serial work sit at their intersection (especially **rc2014_8085**). Aggressive unification of `libsrc/newlib/*` with `libsrc/classic/*` is **out of scope as a bulk merge** and is expected to break classic targets if done carelessly.

### 2.8.1 Layout of the two lineages

| Concern | Newlib / development | Classic |
|---------|----------------------|---------|
| Root | `libsrc/newlib/{stdio,fcntl,alloc,threads,drivers,im2,input,…}` | `libsrc/classic/{stdio,fcntl,alloc,threading,input,interrupts,…}` |
| Target libs | `libsrc/newlib/lib/{sccz80,sdcc_ix}/<target>.lib` | `libsrc/*_clib.lib` via `libsrc/Makefile` + `libsrc/target/*` |
| Stdio model | `FILE` → **FDSTRUCT** → driver messages (`STDIO_MSG_*`) | `fgetc_cons` / `fputc_cons` / conio / ansi; printf via classic table |
| Alloc | `newlib/alloc/malloc` (heap + mutex, multi-heap) + shared `libsrc/alloc/{balloc,obstack}` | `classic/alloc/malloc-classic` (`HeapAlloc`…), `farmalloc` |
| fcntl | Full `open/read/write/ioctl` on FDSTRUCT table | **dummy** stubs (`ndos`) or target-specific / `gen_rnd`; not FDSTRUCT |
| Threads | `newlib/threads` — `mtx_*` (C11-ish), used by stdio/alloc locks | `classic/threading/preempt` — cooperative/preemptive tasks + semaphores (**different API**) |
| Input | `newlib/input/{cpm,zx,…}` | `classic/input` (`in_GetKey`, …) |
| IRQs | `newlib/im2` | `classic/interrupts/{im1,im2,nmi}` |
| Already shared | `libsrc/{string,stdlib,ctype,error,adt,time,setjmp,math,l,compress,…}` pulled into **both** library lists | same |

Classic already documents careful ordering, e.g. classic `z80.lst` comment: include **alloc before strings** so classic `strdup` wins over a newlib-inherited one — evidence that **partial cross-linking exists and is fragile**.

### 2.8.2 How in-scope targets use each lineage today

| Target / clib | Stdio | Alloc | fcntl | Threads | Notes |
|---------------|-------|-------|-------|---------|-------|
| rc2014 / scz180 / yaz180 / hbios **newlib** | newlib stdio + drivers | `libsrc/alloc` + newlib malloc | newlib fcntl | newlib threads (often locks only) | Full newlib stack in `*_sccz80.lst` |
| **rc2014-8085** hybrid | **classic** `stdio.lst` + `f*cons_*` | classic via `8085_clib` / generic | classic **ndos** dummy (`-lndos`) | not newlib threads | `rc2014_8085_sccz80.lst` has newlib stdio/fcntl/alloc/threads **commented out** on purpose |
| Pure classic targets | classic only | classic malloc | dummy/target fcntl | optional preempt | Must not be disturbed |

### 2.8.3 Integration candidates (careful, selective)

Classify possible “integration” — **not** directory merges.

| Package | Integration opportunity | Risk if aggressive | Recommended approach |
|---------|------------------------|--------------------|----------------------|
| **Device serial** (acia/uart/sio/asci) | Share **one** device implementation; classic `f*cons` and newlib drivers both call it | Medium if symbols/sections clash | **Yes — primary goal** for serial abstraction; thin classic wrap |
| **character_00 / console_01** | Newlib-only stdio drivers | High if forced into classic FILE-less programs | Stay newlib; do not replace classic cons globally |
| **stdio core** | Theoretical single printf | **Very high** (ABI, float, IX, FILE layout) | **Do not merge**; keep parallel |
| **fcntl** | Newlib needs FDSTRUCT + drivers; classic needs stubs or DOS | **Very high** (open/read symbols) | Keep parallel; hybrid uses ndos, never newlib fcntl |
| **alloc / malloc** | Both export `malloc`/`free` | **High** symbol collision; heap metadata differs | Keep parallel; document which clib links which; optional later bridge only behind distinct names |
| **alloc balloc/obstack** | Already under shared `libsrc/alloc` | Low if lists stay consistent | Prefer shared path; no classic fork needed |
| **threads / mutex** | newlib `mtx_*` embedded in FILE/heap; classic preempt different | **Very high** if mixed | Never mix in one binary; newlib can keep mutexes as spin/no-op when multithread opt off |
| **im2** | Overlapping “install ISR” ideas | Medium (naming, register save 8080 vs z80) | Inventory only; share only if API identical; prefer target-local ISRs for serial |
| **input** | Similar `in_*` names, different backends | Medium | Keep separate packages; hbios input already under `libsrc/target/hbios` |
| **string/stdlib/ctype/…** | Already shared | Low if link order preserved | Continue sharing; do not “integrate” further without list audit |

### 2.8.4 Hard rules (classic safety)

1. **No bulk merge** of `libsrc/newlib/{stdio,fcntl,threads,alloc/malloc}` into `libsrc/classic/` or vice versa.  
2. **Do not change classic default link sets** (`classic/*.lst`, generic `*_clib` composition) unless a dedicated classic-compatible change is reviewed.  
3. **Hybrid targets** may use **newlib devices + classic stdio** (current rc2014-8085 pattern) or pure newlib — never newlib stdio **and** classic `f*cons` competing for the same `printf`/`getchar` symbols in one link.  
4. **Symbol ownership:** if a symbol exists in both lineages (`malloc`, `open`, `printf`, `close`, …), a given clib must pull **exactly one** definition; prefer explicit lst comments (as in `rc2014_8085_sccz80.lst`).  
5. **Newlib drivers assume FDSTRUCT + optional mtx;** classic cons assume blocking poll loops — bridges go at the **device** layer, not by rewriting classic stdio.  
6. Any experiment that links newlib fcntl/stdio into a classic clib is a **research spike**, isolated branch, not default migration work.

### 2.8.5 Work item for goal (2) expansion

When identifying “additional newlib drivers/systems needed for migration,” also produce a **dual-tree matrix**:

- Required by pure newlib subtypes (must move or stay shared).  
- Explicitly **excluded** by hybrid classic subtypes.  
- Classic packages that must remain available unchanged for hybrid build (`classic/stdio`, ndos/dummy fcntl, `8085_crt0`, classic malloc via `8085_clib`).  
- Optional later bridges (device-only, documented).

---

## 3. Serial abstraction — design proposal

### 3.1 Device contract (document + keep)

Stable symbols already used across targets (naming varies slightly by device):

| Operation | Typical symbol | Semantics |
|-----------|----------------|-----------|
| init | `*_init` | hardware + buffers |
| putc | `*_putc` | Tx, may block or buffer |
| getc | `*_getc` | Rx; carry/Z empty policy must be documented |
| pollc | `*_pollc` | non-blocking availability |
| peekc | `*_peekc` | optional |
| flush Rx/Tx | `*_flush_Rx` / `*_flush_Tx` | |

**Simplification work:**

1. Write a short contract doc (in-tree, e.g. `libsrc/newlib/drivers/character/readme.txt` or target-neutral `libsrc/target/shared/serial/README`) covering return conventions for Z80 vs 8085 copies.
2. Prefer **one** buffer implementation shared by classic cons and newlib device where rc2014 currently duplicates logic (`fgetc_cons_acia` vs `acia_getc`).
3. Add thin stdio drivers:

   - `character_00` subclass per port **or** generic “serial character” driver parameterised by function pointers / EXTERN entry points.
   - m4 instantiators parallel to `m4_rc_01_input_acia` but lighter (no full iterm message surface).
   - Instantiators must remain **re-callable** so multiple ports (A/B, ASCI0/1, HBIOS0/1, user extras) can each get their own FILE/FDSTRUCT pair in one CRT.

4. CRT choice matrix (clarify in each `*_crt.asm.m4` header):

   | Need | Driver class |
   |------|----------------|
   | printf/scanf, no line edit | `character_00` + device |
   | cooked terminal, editing | `console_01` / `rc_01_*` (current) |
   | 8085 classic stdio | `fgetc_cons` / `fputc_cons` over same device |

5. **Input** remains orthogonal: link `input/cpm` or `target/hbios/input` only when the subtype needs `in_inkey` / pause APIs; do not force serial drivers to implement them.

### 3.2 Retained CRT features: multi-port + FILE dup / overload

These are **existing features** and are **non-negotiable** for the simplified abstraction and all migrations.

#### Multi-port serial instantiation

Default startups already attach more than one interface when hardware has two channels, e.g. rc2014 `sio` (`rc2014_crt_4`):

| FILE labels | Typical binding |
|-------------|-----------------|
| `_stdin` / `_stdout` | primary port (e.g. SIO A, ASCI0, HBIOS0) |
| `_stderr` | **dup** of primary output FDSTRUCT (`m4_file_dup`) |
| `_ttyin` / `_ttyout` | secondary port (e.g. SIO B, ASCI1, HBIOS1) |
| `_ttyerr` | **dup** of secondary output FDSTRUCT |

Pattern (from current m4 CRTs):

```text
m4_rc_01_input_sioa(_stdin,  __i_fcntl_fdstruct_1, …)
m4_rc_01_output_sioa(_stdout, …)
m4_file_dup(_stderr, 0x80, __i_fcntl_fdstruct_1)   ; stderr → same fd as stdout

m4_rc_01_input_siob(_ttyin,  __i_fcntl_fdstruct_4, …)
m4_rc_01_output_siob(_ttyout, …)
m4_file_dup(_ttyerr, 0x80, __i_fcntl_fdstruct_4)   ; ttyerr → same fd as ttyout
```

Requirements for any new/simplified instantiator:

1. May be invoked **N times** in one CRT with distinct FILE labels and distinct device backends.  
2. Continues to cooperate with `clib_instantiate_begin/end.m4` counters (`__I_STDIO_NUM_FILE`, `__I_FCNTL_NUM_FD`).  
3. Does not assume it is the only serial driver in the CRT.  
4. Secondary ports and user-added ports remain first-class (not “debug only”).

#### FILE dup / overload (`m4_file_dup`)

`lib/crt/newlib/m4_file_dup.m4`:

- Creates a FILE (optional label) whose jump targets an **existing** FDSTRUCT.  
- Increments FDSTRUCT refcount.  
- Used for **stderr overloading stdout**, **ttyerr overloading ttyout**, and any user “alias this FILE to that fd” layout.

Must remain available and documented for:

- Default startups (stderr/ttyerr as today).  
- User CRTs and `crt_driver_instantiation.asm.m4` when `CRT_INCLUDE_DRIVER_INSTANTIATION` / `M4__CRT_INCLUDE_DRIVER_INSTANTIATION` is set.  
- Simplified `character_00` paths: dup works on FDSTRUCT identity, independent of whether the underlying driver is `rc_01_*` or thin serial.

#### User-supplied driver instantiation (retain)

When `M4__CRT_INCLUDE_DRIVER_INSTANTIATION != 0`, startups include `crt_driver_instantiation.asm.m4` instead of the default block. That path must keep working so users can:

- Attach extra UARTs / ACIAs beyond the stock map.  
- Dup or rebind stderr/stdout arbitrarily.  
- Mix simplified serial drivers with full terminals if desired.

**Regression checks (Phase 3 / migration smoke):**

| Check | Example |
|-------|---------|
| stderr shares stdout fd | link subtype with `m4_file_dup(_stderr,…)`; write both FILEs |
| dual port | `+rc2014 -subtype=sio` (or scz180 rom) exposes tty* symbols |
| custom instantiation | build with `CRT_INCLUDE_DRIVER_INSTANTIATION` + local `crt_driver_instantiation.asm.m4` that adds a third port or rebinds stderr |

### 3.3 CRT0 clarification deliverables

For each target, produce a single “CRT map” comment block (and optional table in a context doc) listing:

- SUBTYPE ↔ startup N ↔ `__CRTCFG` ↔ config public inc (z80 vs 8085) ↔ drivers instantiated ↔ CPU flags

Shared sequence already common (keep; document once):

1. config public  
2. `crt_defaults` (+ `crt_defaults_8085` when hybrid)  
3. `crt_config` / rules / target rules  
4. memory map  
5. driver instantiate (or classic cons aliases)  
6. page zero / start di / SP / cmdline  
7. section init / call `_main` / exit  

Optional refactor (later phase, not blocking migration): extract repeated “select startup” m4 into a shared macro include under `lib/crt/newlib/` to reduce copy-paste across the four targets.

---

## 4. Migration inventory — what moves to `libsrc/target/`

### 4.1 Principle

| Stays under `libsrc/newlib/` | Moves to `libsrc/target/<name>/` |
|------------------------------|----------------------------------|
| stdio, fcntl, drivers/{character,terminal,tty,general,memstream}, im2, threads, input/{cpm,zx,…} as **shared** packages | Entire target tree: config, CRT, startup, device, driver, default, library lists, rules |
| math/arch shared | Target-specific devices and terminals |

**hbios exception already started:** API + input stay/expand under `libsrc/target/hbios`; newlib-only CRT/terminal/time join them.

### 4.2 Per-target move list

#### rc2014 → `libsrc/target/rc2014/`

Merge with existing classic stdio + lst:

| Subtree | Action |
|---------|--------|
| `config*.m4`, generated `config_rc2014*.{h,inc}` | Move; rebuild rules |
| `rc2014_crt.asm.m4`, `startup/*`, `crt_*.inc`, `rc2014_rules.inc` | Move |
| `device/{acia,sio,uart,8255}` including `8080/` | Move |
| `driver/{terminal,ide,diskio,ram}` | Move |
| `default/*`, `library/*` | Move; fix `@` paths |
| Existing `stdio/f*cons_*`, `rc2014-8085.lst` | Keep; retarget includes from `newlib/target/rc2014/...` → `target/rc2014/...` |

#### scz180 → `libsrc/target/scz180/` (new directory)

| Subtree | Action |
|---------|--------|
| config, CRT, startup, rules | Move |
| `device/{asci,csio}` | Move |
| `driver/{terminal,time}` | Move (hbios terminal m4 may symlink/share with hbios) |
| `default/*` (RST stubs, ISRs) | Move |
| library lst | Move; keep `@../target/hbios/...` refs |

#### yaz180 → `libsrc/target/yaz180/` (new)

| Subtree | Action |
|---------|--------|
| config, CRT, startup | Move |
| `device/{asci,8255,am9511a,pca9665}` | Move |
| `driver/{terminal,diskio,i2c,ppide,apu,time}` | Move |
| default, library | Move |

#### hbios → complete under `libsrc/target/hbios/`

| Subtree | Action |
|---------|--------|
| Existing API + input | Stay |
| `newlib/target/hbios/{config,crt,startup,driver/terminal,driver/time,library,rules}` | Move into `libsrc/target/hbios/` |
| Unify library lists so newlib build consumes only `libsrc/target/hbios` | Required |

### 4.3 Shared systems that must remain available (not “target-local”)

These are **required** for the four targets’ **newlib** builds but should **not** be copied into each target:

| System | Path | Consumers |
|--------|------|-----------|
| stdio | `newlib/stdio` | newlib clibs only |
| character_00 + console_01 + tty | `newlib/drivers` | newlib terminal/serial |
| fcntl | `newlib/fcntl` | newlib clibs only (**not** 8085 hybrid) |
| im2 | `newlib/im2` | newlib interrupt helpers |
| threads | `newlib/threads` | newlib libs (mutex support) |
| input/cpm | `newlib/input/cpm` | rc2014, scz180, yaz180 newlib |
| cpm drivers / cpm-libs | `libsrc/target/cpm*`, `target/cpm-libs` | cpm subtypes |
| arch z80/z180, l_*, math, adt, alloc, … | existing libsrc trees | all |
| crt/newlib shared includes | `lib/crt/newlib` | all newlib CRTs (+ hybrid CRT templates) |

**Classic packages required by hybrid rc2014-8085 (do not “migrate away” or replace with newlib equivalents):**

| System | Path | Role |
|--------|------|------|
| classic stdio | `libsrc/classic/stdio` | printf/scanf/getchar stack for 8085 |
| classic cons | `libsrc/target/rc2014/stdio/f*cons_*` | blocking consoles |
| ndos / dummy fcntl | classic fcntl dummy via `-lndos` | stub open/close/… |
| 8085 crt0 lib | `8085_crt0` / classic crt0s | compiler support, not newlib fcntl |
| classic malloc | via `8085_clib` / malloc-classic | heap for classic programs |

See §2.8 for dual-tree rules.

### 4.4 Duplicated / shareable driver candidates (optional consolidation)

| Opportunity | Targets |
|-------------|---------|
| ASCI device + `rc_01_*_asci*` | scz180, yaz180 (near-duplicates) |
| HBIOS terminal drivers | hbios, scz180 (scz180 has local m4 copies) |
| IDE/PPIDE/diskio patterns | rc2014, yaz180 |
| ACIA/UART 8080 sources | only rc2014, but classic cons should call device API |

Consolidation is **recommended after** physical move, not as a blocker.

---

## 5. Build process (today → after migration)

### 5.1 Building libraries today

```bash
# Newlib multi-target libs (includes the four)
make -C libsrc/newlib rc2014 scz180 yaz180 hbios
# → libsrc/newlib/lib/sccz80/{rc2014,scz180,yaz180,hbios}.lib
# → libsrc/newlib/lib/sdcc_ix/{...}.lib  (where defined)

# Classic hybrid 8085 rc2014
make -C libsrc rc2014-8085_clib.lib
# → libsrc/rc2014-8085_clib.lib (and install into lib/clibs as per tree practice)
```

Config generation:

- Z80: `m4 target/<name>/config.m4` inside `libsrc/newlib` makefile  
- 8085: `m4 newlib/target/rc2014/config_8085.m4` inside **classic** `libsrc/Makefile`

### 5.2 User compile examples (must keep working)

```bash
# Z80 newlib RC2014
zcc +rc2014 -subtype=uart -clib=sdcc_iy app.c -o app

# 8085 hybrid
zcc +rc2014 -subtype=acia85 app.c -o app
# (forces -m8085 -clib=rc2014-8085)

# SCZ180 / YAZ180 / HBIOS
zcc +scz180 -subtype=hbios -clib=sdcc_iy app.c -o app
zcc +yaz180 -subtype=app -clib=sdcc_iy app.c -o app
zcc +hbios -clib=new app.c -o app
```

### 5.3 Build system changes required for migration

1. **`libsrc/newlib/Makefile`** (and/or classic-aligned install)  
   - Build these four from `libsrc/target/<name>/`; update `ALLTARGETS` paths, `config.m4` location, `-I` and `@library/*.lst` roots.  
   - **Library output:** relocate to the **same arrangement as classic targets** (decision §11.1) — e.g. classic-style `libsrc` / `lib/clibs` install paths — not leave permanently only under `libsrc/newlib/lib/`.

2. **`libsrc/Makefile`** (rc2014-8085)  
   - Point m4 and lst at `target/rc2014/...` only (no `newlib/target`).

3. **`lib/config/{rc2014,scz180,yaz180,hbios}.cfg`**  
   - `-Ca-I`, `-Cl-I`, `-crt0=` paths: `libsrc/newlib/target/X` → `libsrc/target/X`.

4. **`include/_DEVELOPMENT/{common,proto}/arch.h`**  
   - `#include` paths for `config_*.h`.

5. **All `.lst` internal paths**  
   - Replace `target//rc2014/...` and `newlib/target/rc2014/...` with consistent `target/rc2014/...` relative to `libsrc/`.

6. **Docs / examples / wiki** if they hardcode `newlib/target/...`.

7. **Verification smoke** after each target move (Section 7).

### 5.4 Proposed target directory layout (end state)

```
libsrc/target/rc2014/
  config/  config*.m4  config_rc2014*.{h,inc}
  crt/ or startup/  rc2014_crt.asm.m4  rules
  device/{acia,sio,uart,8255}/...
  driver/{terminal,ide,diskio,ram}/...
  stdio/   # classic f*cons_* (8085)
  library/*.lst
  rc2014-8085.lst
  default/

libsrc/target/scz180/   # analogous
libsrc/target/yaz180/
libsrc/target/hbios/    # API + input + newlib CRT/drivers merged
```

`libsrc/newlib/target/` retains only non-migrated targets (cpm, z80, z180, zx, zxn, sms, math*, am9511, m, …) until/unless those move later.

---

## 6. Phased implementation plan

### Phase 0 — Context files & policy (short)

- Add project **context files** (not session handoffs): goals, scope, open decisions.  
- Freeze naming: device API, `character_00` vs `rc_01_*`, 8085 hybrid rules.  
- Record **dual-tree policy** (§2.8 hard rules): no aggressive newlib↔classic directory merge.  
- Decide library **output** location policy (recommend: keep `libsrc/newlib/lib/`).  
- Keep **`context.md` at repo root** (project context; not a session paste).  
- Capture **pre-change baselines** for §7.3–7.4 (math suite + key benches on rc2014 z80/8085 only) into context or adjacent notes.

**Exit criteria:** `context.md` present at repo root; policy decisions recorded (including classic safety); baseline table started or complete.

### Phase 1 — Step 1: Master the m4 CRT0 + config generation (blocking)

This phase is **mandatory before** serial redesign or tree moves. Goal: deep, written understanding of how CRT0 and public/private configs are produced for every in-scope target/subtype.

#### 1.1 Config pipeline (library build — public / private / C)

For each of `rc2014` (z80 + 8085 masters), `scz180`, `yaz180`, `hbios`:

1. Trace `config.m4` / `config_8085.m4` include graph (`config/*.m4`, shared cpm config if any).  
2. Re-run (or dry-document) the three m4 modes:

   | Mode | Flag | Output |
   |------|------|--------|
   | private | `CFG_ASM_DEF` | `config_*_private.inc` → `obj/config_private.inc` |
   | public | `CFG_ASM_PUB` | `config_*_public.inc` (CRT + app include) |
   | C | `CFG_C_DEF` | `config_*.h` (arch.h) |

3. Document which symbols each subtype/CPU needs from public vs private (I/O ports, buffer sizes, CPU class).  
4. Note path differences: newlib makefile cwd vs classic 8085 m4 include prefixes.  
5. Record rebuild triggers: “edit `config_*.m4` → must rebuild target lib”.

**Deliverable:** context section “Config generation” with tables per target (and rc2014-8085).

#### 1.2 CRT0 pipeline (zcc link-time m4)

1. Document `zcc` flow from `lib/config/<target>.cfg` (`-crt0=…_crt.asm.m4`, `SUBTYPE` → `-startup=N`) through `zcc_opt.def` and `important_pragmas` → m4 `--define=__STARTUP=…`.  
2. Document m4 `-I` set: target home, zcc_opt dir, `src/m4` (`z88dk.m4`).  
3. For **each subtype** of each target, walk:

   ```text
   selector (_crt.asm.m4)
     → __CRTCFG / __MMAP
     → startup/*_crt_N.asm.m4
     → config_*_public.inc
     → crt_defaults(+_8085) + crt_config.inc[TAR__*] + crt_rules
     → crt_memory_map
     → driver m4 instantiation OR classic f*cons aliases
     → page zero / start / main / exit includes
   ```

4. Map `__CRTCFG` rows in each `crt_config.inc` to subtypes.  
5. List driver m4 macros invoked per startup (serial attach surface).  
6. Optional practical check: `zcc +rc2014 -subtype=acia -m …` or `zcc -m4` style stop-after-m4 to inspect expanded CRT asm for one subtype.

**Deliverable:** context section “CRT0 m4 generation” + complete subtype → file → drivers → config matrix (expands §2.4.4 tables).

#### 1.3 Implications captured for later phases

- Migration must move **selector, startup templates, crt_config, crt_memory_map, config masters/fragments, driver m4** together; update cfg `-crt0=` and m4 `-I`.  
- Simplified serial abstraction will add/change **driver m4 instantiators** and possibly new startup branches or instantiation blocks — not a separate binary format.  
- Public/private config for serial ports (base addresses, buffer sizes) stay in Pipeline A; CRT only selects which drivers to instantiate.

**Exit criteria:** written CRT0/config pipeline doc in context files; matrix complete for all subtypes; team can explain public vs private vs `crt_config` vs startup m4 without reading this plan alone.

### Phase 2 — Dual-tree inventory (goal 2 expansion; parallel with serial design)

Complete the matrix of newlib packages vs classic alternatives for systems the four targets touch:

| Package | Newlib path | Classic / shared path | Used by newlib targets? | Used by rc2014-8085? | Bridge allowed? |
|---------|-------------|----------------------|-------------------------|----------------------|-----------------|
| stdio | `newlib/stdio` | `classic/stdio` | yes | classic only | device-level only |
| fcntl | `newlib/fcntl` | `classic/fcntl` (+ ndos) | yes | ndos | **no** full bridge |
| alloc | `newlib/alloc/malloc` + `libsrc/alloc` | `classic/alloc/*` | yes | classic clib | no symbol merge |
| threads | `newlib/threads` | `classic/threading/preempt` | linked | no | **no** |
| drivers | `newlib/drivers` | n/a (classic cons) | yes | no | n/a |
| im2 | `newlib/im2` | `classic/interrupts/im2` | yes | via clib as needed | inventory only |
| input | `newlib/input/*` | `classic/input`, `target/hbios/input` | varies | no | keep separate |

**Exit criteria:** dual-tree matrix in context files; explicit “do not touch” list for classic lst/makefiles; list of safe bridge points (device serial only by default).

### Phase 3 — Serial abstraction (depends on Phase 1; respects Phase 2)

1. Document device + `character_00` contracts (device layer vs CRT m4 instantiation).  
2. Prototype simplified serial as `character_00` concrete driver + **re-entrant m4 instantiator** (usable multiple times per CRT) + optional CRT startup or instantiation switch (still Pipeline B).  
3. Ensure config symbols used by the device remain correct in public/private incs (Pipeline A rebuild).  
4. Keep **`m4_file_dup`** and default patterns: `_stderr` → primary output FDSTRUCT; dual-port startups still create `_ttyin`/`_ttyout`/`_ttyerr` where applicable.  
5. Preserve **`CRT_INCLUDE_DRIVER_INSTANTIATION`** / user `crt_driver_instantiation.asm.m4` for extra ports and custom stderr/stdout overloads.  
6. Refactor classic `fgetc_cons_acia` / `fputc_cons_acia` to call device `acia_getc`/`acia_putc` (or shared helper) — **only** this class of classic change (thin wrap); do not rewrite classic printf/fcntl.  
7. Extend pattern to UART (and SIO/ASCI as needed).  
8. Smoke Z80 newlib + 8085 hybrid; regression: multi-port subtype + stderr dup + optional custom instantiation (§3.2 checks).

**Exit criteria:** simplified serial path works; multi-port + `m4_file_dup` (stderr/stdout overload) still work; user driver instantiation still works; 8085 hybrid still works via shared device + classic stdio; no classic fcntl/stdio core edits unless proven regression-free on classic targets; **§7.3–7.4 math/ticks gate green** (rc2014 z80 + 8085 math matrices).

### Phase 4 — CRT0 light cleanup (after understanding)

- Uniform headers on all `*_crt.asm.m4` / startup files (subtype map aligned with Phase 1 matrix).  
- Fix misleading comments (e.g. wrong startup numbers in file banners where found).  
- Optional shared m4 selector include under `lib/crt/newlib/`.  
- Do **not** change behaviour unless serial work requires it.

**Exit criteria:** CRT map accurate for all subtypes in context doc and file headers.

### Phase 5 — Migrate hbios (smallest newlib surface; classic already partial)

**After move:** de-duplicate any shared HBIOS terminal/API pieces **before** Phase 6.

1. Move newlib hbios CRT/driver/config into `libsrc/target/hbios/`.  
2. Update hbios library lists, cfg, arch.h, newlib Makefile.  
3. Update scz180 references to hbios paths if needed.  
4. Remove `libsrc/newlib/target/hbios`.  
5. Build + smoke `zcc +hbios`.

### Phase 6 — Migrate scz180

1. Create `libsrc/target/scz180/` with full tree (**config m4 + CRT m4 + crt_config + startups + drivers** as one unit — Phase 1 matrix).  
2. Fix lst/cfg/makefile/arch.h; re-verify Pipeline A outputs and one Pipeline B expand/link per subtype.  
3. Remove `libsrc/newlib/target/scz180`.  
4. Smoke subtypes rom / hbios / cpm / none.

### Phase 7 — Migrate yaz180

1. Same as scz180 for yaz180 tree (larger device set).  
2. Smoke rom / app / cpm / none; exercise APU/I2C only if existing tests exist.

### Phase 8 — Migrate rc2014 (hardest; dual CPU + dual config masters + classic hybrid)

1. Move newlib rc2014 tree into `libsrc/target/rc2014/` merging with classic stdio **paths** (classic cons files stay classic; do not replace with newlib stdio).  
2. Update **both** config masters (`config.m4` and `config_8085.m4`) include paths and rebuild rules for public/private/h.  
3. Update:
   - newlib `rc2014` library build  
   - classic `rc2014-8085_clib` rule and lst (keep newlib fcntl/stdio/threads **out** of hybrid lst)  
   - `rc2014.cfg` (both CLIB new* and `rc2014-8085`) — especially `-crt0=` and m4 `-I`  
   - arch.h, includes in asm (`INCLUDE "newlib/target/rc2014/..."` → new paths)  
4. Remove `libsrc/newlib/target/rc2014`.  
5. Full subtype matrix smoke (Z80 + 8085), including m4 expand sanity on acia vs acia85; regression-check a pure classic 8085 target build if shared objects moved.

### Phase 9 — Close-out

- `rg 'newlib/target/(rc2014|scz180|yaz180|hbios)'` must be empty (except historical docs if any).  
- Context/report updated with final layout, CRT/config pipeline notes, and dual-tree matrix.  
- **Full verification gate §7.3–7.4:** rc2014 Z80 math matrix, rc2014 8085 math matrix — via **`z88dk-ticks`** with correctness (suite and/or printed RESULT), plus agreed benchmarks. (cpm out of scope.)  
- Optional PR split: **m4/CRT docs** → dual-tree inventory → serial abstraction → hbios → scz180 → yaz180 → rc2014.

---

## 7. Verification strategy

Structural checks remain necessary but **not sufficient**. Post-change acceptance requires **`z88dk-ticks`** correctness and math **linkage** for rc2014 (both CPUs) and newlib **cpm**, plus selected benchmarks.

### 7.1 Environment

```bash
export PATH=/home/phillip/Z80/z88dk/bin:$PATH
export ZCCCFG=/home/phillip/Z80/z88dk/lib/config
```

Typical ticks patterns (from tree / suites):

```bash
# +test style (classic 8085 / portable)
z88dk-ticks -m8085 prog.bin -x prog.map -start TIMER_START -end TIMER_STOP -counter 999999999999
z88dk-ticks prog.bin -x prog.map -start TIMER_START -end TIMER_STOP -counter 999999999999

# suite helper already uses e.g. z88dk-ticks -w 30; rc2014 suite uses -pc 0x9000
# see test/suites/make.config: runtest / runtest_8085 / runtest_rc2014
```

### 7.2 Structural / CRT (every migration step)

| Check | Command / method |
|-------|------------------|
| Config gen (Pipeline A) | `make -C libsrc/newlib <target>`; confirm `config_*_{private,public}.inc` + `.h` refresh |
| 8085 config gen | `make -C libsrc rc2014-8085_clib.lib` (runs `config_8085.m4` triple) |
| CRT m4 expand (Pipeline B) | link a hello per subtype; optional inspect expanded CRT |
| Newlib libs | `make -C libsrc/newlib rc2014 scz180 yaz180 hbios cpm` clean build as needed |
| 8085 hybrid lib | `make -C libsrc rc2014-8085_clib.lib` |
| Z80 subtype link | `zcc +rc2014 -subtype=<…> -clib=new` / `sdcc_iy` hello |
| 8085 subtype link | `zcc +rc2014 -subtype=acia85` / `uart85` / `basic85` |
| scz180/yaz180/hbios | one-file link per subtype |
| Path regression | `rg` for old `newlib/target/{rc2014,scz180,yaz180,hbios}` after moves |
| Multi-port + stderr dup | dual-port subtype (`sio` / scz180 `rom`); `_tty*` + `m4_file_dup` |
| Custom driver instantiation | `CRT_INCLUDE_DRIVER_INSTANTIATION` + local `crt_driver_instantiation.asm.m4` |

### 7.3 Math library matrix — **rc2014 Z80** (newlib)

Link and **run under `z88dk-ticks`** (suite and/or float-heavy bench). Flags as commonly used in-tree:

| Math | Link flags (canonical) | Notes |
|------|------------------------|-------|
| **math48 (`-lm`)** | `-lm` → **math48** on Z80 rc2014 newlib | Existing suite: `test_math48_rc2014` via `compile_rc2014 … -lm` |
| **mbf32** | `--math-mbf32` | Confirm alias resolves `mbf32` + 32-bit float pragmas |
| **math32** | `--math32` or `-lmath32` | Suite recipe `test_math32_rc2014` exists (ensure in `all` if needed) |
| **am9511** | `--math-am9511` / `--am9511` / `-lam9511` | Suite: `test_9511_rc2014` |
| **math16** | `--math16` (often with math32 companion as in suite) | Suite: `test_math16` pattern; also exercise on `+rc2014` if not only `+test` |

**Minimum Z80 rc2014 math gate:**

```bash
# Prefer suite where recipes exist
make -C test/suites/math test_math48_rc2014_CODE.bin   # runs ticks via runtest_rc2014
make -C test/suites/math test_9511_rc2014_CODE.bin
make -C test/suites/math test_math32_rc2014_CODE.bin    # add to all: if missing from default all

# Expand coverage: mbf32 + math16 on +rc2014 -clib=new -subtype=basic (or cpm)
# using same FPSOURCES/math.c pattern as suite, or a small float self-check.
```

**Benchmarks (ticks + plausible RESULT):** at least one of `support/benchmarks/{n-body,mandelbrot,spectral-norm,fasta,whetstone}/` built with `+rc2014` newlib and each math lib that the bench supports; use `-DTIMER -m` and `z88dk-ticks … -start TIMER_START -end TIMER_STOP`. Spectral-norm readme already shows `+rc2014 -subtype=cpm` with `--math32` / `--am9511`.

### 7.4 Math library matrix — **rc2014 8085** (hybrid classic)

| Math | Link flags | Notes |
|------|------------|-------|
| **default / `-lm`** | `-lm` → **genmath** on rc2014-8085 | Confirmed project decision |
| **mbf32** | `--math-mbf32` | Suite: `test_mbf32_8085` on `+test -clib=8085`; also build **`+rc2014 -subtype=acia85`** (or uart85/basic85) with `--math-mbf32` and ticks `-m8085` |
| **math32** | `--math32` / `-lmath32_8085` | Suite: `test_math32_8085`; plus rc2014-8085 subtype link |
| **am9511** | `--math-am9511` | Suite: `test_9511_8085`; plus rc2014-8085 subtype link |

**Minimum 8085 gate:**

```bash
make -C test/suites/math test_mbf32_8085.bin test_math32_8085.bin test_9511_8085.bin
# each runtest_8085 → z88dk-ticks -m8085

# Target-faithful hybrid (CRT + devices + classic stdio), each math:
zcc +rc2014 -subtype=basic85 -vn -O2 -DSTATIC -DTIMER -D__Z88DK \
  float_probe.c -o probe.bin -m --math-mbf32   # and -lm / --math32 / --math-am9511
z88dk-ticks -m8085 probe.bin -x probe.map -start TIMER_START -end TIMER_STOP -counter 999999999999
```

Use a small **float probe** (or suite `math.c`) that prints/checks known values so ticks run is not only “did not crash” but **correct results**.

### 7.5 Math + benchmarks — **newlib `+cpm`** (**out of scope**)

**Decision:** newlib `cpm` is **out of scope** for migration and for project regression gates (would conflict with classic/cpm work). Do not block this project on `+cpm` math/bench matrices. A later effort may revisit.

### 7.6 When to run which gate

| Milestone | Structural §7.2 | Math suite (rc2014 z80 + 8085) | Benchmarks + ticks |
|-----------|-----------------|--------------------------------|--------------------|
| Phase 1–2 (docs only) | optional | optional baseline capture | baseline optional |
| Phase 3 serial / device share | yes (rc2014 z80+8085) | **yes** full §7.3–7.4 | at least n-body or mandelbrot one math each CPU |
| Each target migrate (5–8) | yes that target | rc2014 if touched | rc2014 if touched |
| Phase 9 close-out | full | **full §7.3–7.4** | full agreed bench set |

### 7.7 Baseline discipline

Before first code change that can affect codegen/link:

1. Capture suite pass/fail and a short table of bench ticks + RESULT for rc2014 z80, rc2014 8085, and cpm newlib for each math in §7.3–7.5.  
2. Store in project context files (not necessarily committed).  
3. Close-out compares to baselines; document intentional deltas.

---

## 8. Risks and mitigations

| Risk | Mitigation |
|------|------------|
| Incomplete CRT/m4 understanding before moves | **Phase 1 is blocking**; no tree move until matrix + pipeline doc done |
| **rc2014_8085** path dual-maintenance | Migrate rc2014 last; checklist for classic + newlib + both config masters |
| Broken m4 `-I` / `-crt0=` after move | Smoke expand/link every subtype; cfg path checklist from Phase 1 |
| Broken relative `@` lst paths | Build after every path edit; prefer paths relative to `libsrc/` |
| scz180/yaz180 ASCI drift if de-duplicated too early | Move first, share later |
| character_00 simplification changes behaviour vs console_01 | Keep old startups default; add new startup or pragma for simple serial |
| Losing multi-port or stderr-dup when simplifying | Explicit §3.2 retain list; m4 instantiators re-entrant; smoke sio/dual-port + `m4_file_dup` |
| **Aggressive newlib↔classic merge** | Forbidden by policy; bridges only at device layer; dual-tree matrix in Phase 2 |
| Accidental newlib fcntl/stdio into hybrid lst | Keep hybrid lst comments; link smoke for `acia85` after every rc2014 edit |
| Math lib fails to link on rc2014 after path moves | Full §7.3–7.4 matrix; fix lst/cfg `@{ZCC_LIBCPU}` / lib search paths |
| Silent numeric regression | Suite assert + bench RESULT vs baselines under ticks — not link-only |
| Public/private config drift (wrong ports/sizes) | Rebuild lib after any `config/*.m4` edit; compare public vs private symbol sets |
| Config header install / arch.h | Update both common and proto arch.h |
| Large `obj/` trees | `install-clean` / target-clean after moves |

---

## 9. Recommended sequencing summary

```text
Phase 0  Context files + policy (incl. dual-tree safety)
Phase 1  ★ m4 CRT0 + config public/private understanding (blocking)
Phase 2  ★ Dual-tree inventory (alloc/fcntl/threads/stdio/… vs classic)
Phase 3  Serial abstraction (device share + character_00; multi-port + file_dup retained; classic cons thin wrap only)
Phase 4  CRT0 documentation cleanup / light regularisation
Phase 5  Migrate hbios → then de-dupe shared drivers before continuing
Phase 6  Migrate scz180 → de-dupe vs hbios/asci as applicable before continuing
Phase 7  Migrate yaz180 → de-dupe vs scz180/asci before continuing
Phase 8  Migrate rc2014 (+ 8085 hybrid + dual config masters; classic stack preserved)
Phase 9  Grep-clean + full z88dk-ticks math/bench gate (rc2014 z80+8085 only)
```

**rc2014 must not move before** path strategy is proven on a smaller target **and** Phase 1 CRT/config matrix is complete. **Classic cores:** no change unless proven not to regress classic targets. **De-duplication:** after each move (or after a related cluster of moves), **before** continuing to the next target. **Math/bench ticks gates** (§7.3–7.4) required at serial work and close-out. **cpm** out of scope.

---

## 10. Deliverables of this plan (report)

1. Goals and end-state definition  
2. Current dual-tree and hybrid 8085 analysis  
3. **m4 tool chains:** library config generation (public/private/C) and zcc CRT0 expansion  
4. Artefact checklist per target/subtype (config incs, crt_config, startups, driver m4)  
5. **Newlib vs classic package matrix** (alloc, fcntl, threads, stdio, im2, input, …) and hard integration rules  
6. Serial stack analysis and simplified abstraction proposal (**incl. multi-port + `m4_file_dup` / stderr overload retention**)  
7. Full CRT/subtype tables for rc2014, scz180, yaz180, hbios  
8. Driver/system inventory for migration vs shared newlib vs classic-only hybrid deps  
9. Build process (today and after)  
10. Phased implementation plan with verification and risks  
11. **Verification matrix:** `z88dk-ticks` + math libs for rc2014 Z80/8085; benchmark RESULT baselines  

---

## 11. Decisions (resolved)

| # | Topic | Decision |
|---|--------|----------|
| **1** | Library **output** location | **Relocate to same arrangement as classic targets** (not leave forever under `libsrc/newlib/lib/…` only). Align install/link paths with classic `libsrc/target` / `lib/clibs` practice as part of migration. |
| **2** | Simple serial rollout | Still open if needed at implementation: prefer **additive** (new startup or instantiation option); defaults keep current terminal behaviour unless agreed otherwise. Multi-port + `m4_file_dup` always retained. |
| **3** | ASCI / HBIOS (and similar) **de-duplication** | **After each move, before continuing** to the next target (not deferred to end-of-project). |
| **4** | **cpm** newlib target | **Out of scope** for now (conflicts with classic/cpm). Neither migration nor project regression gates. |
| **5** | Context file location | **`context.md` at repo root**. |
| **6** | Classic core changes | **No change** to classic core (stdio/fcntl/malloc/threads/printf, etc.) **unless proven not to cause regression on classic targets**. Thin `f*cons` → device wrap only if that proof bar is met. |
| **7** | Multi-port / FILE dup | **Required** (not optional); see §3.2. |
| **8** | cpm regression testing | **In line with (4): out of scope** for now. |
| **9** | **`-lm` identity** | **rc2014-8085:** `-lm` → **genmath**. **rc2014 Z80 (newlib):** `-lm` → **math48**. |

### Defaults going forward

- Library artefacts: classic-like target layout (§11.1).  
- Serial: additive simplified path; multi-port + file_dup retained.  
- De-dupe: post-move, pre-next-target.  
- cpm: out of scope (migrate + regress).  
- Context: `context.md` repo root.  
- Classic core: no change without classic regression proof.  
- Math gates: rc2014 z80 + 8085 only; `-lm` as above.
