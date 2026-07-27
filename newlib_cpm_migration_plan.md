# Plan: newlib `+cpm` source migration (§13)

> **TEMPORARY — DELETE BEFORE PR MERGE**  
> Working document for the `newlib-cpm-migration` branch only.  
> Do **not** leave this file in the repository when the migration PR is merged.  
> Remove it in the final PR hygiene pass (or as a last pre-merge commit).

**Branch:** `newlib-cpm-migration` (tip `fe33ce01e0` = post-#3023 master)  
**Workspace:** `/home/phillip/Z80/z88dk`

---

## 1. Goal

Move **newlib** CP/M sources from `libsrc/newlib/target/cpm/` into `libsrc/target/cpm/` **without** breaking classic `+cpm`, and strengthen the newlib character/stdio story so CP/M **logical devices** are named and usable with stdio — while respecting that classic is **all CPUs**, **150+ machine targets**, and **non-disk media**.

Also close the gap reported in **[#3022](https://github.com/z88dk/z88dk/issues/3022)** for portable newlib `+cpm` FILE I/O (see §1.1).

### 1.1 Coverage vs GitHub #3022 (issue body)

Reporter (`ravn`): `zcc +cpm -clib=new` + `fopen("f","w")` → undefined `asm_target_open_p1` / `_p2`. Asks whether a BDOS FCB disk-file driver + optional device-name vs filename dispatcher would be welcome.

Maintainer direction (comments): classic remains the long-term home for 150+ targets; newlib keeps compatibility / useful abstractions; do **not** migrate all machines to newlib; #3023 was the hardware-target template; feilipu: newlib cpm migration preserves serial abstraction, does not disturb classic subtypes.

| #3022 ask | Plan / status |
|-----------|----------------|
| Implement `asm_target_open_p1` / `_p2` | **Done** — `cpm_01_file` (BDOS FCB, `STDIO_MSG_*`) |
| Disk driver modelled on newlib drivers + classic FCB | **Done** — same driver used by rc2014/yaz180/scz180 `-subtype=cpm` |
| Link from `+cpm -clib=new` | **Done** — rebuild `cpm.lib` + CRT `open_max` 16 / stdio heap 1024 |
| `fopen` needs free `FILE*` pool | **Done** — CRT `fopen_max` 10 (> 6 static streams) |
| Device-name vs filename dispatcher (`CRT:` / `LPT:` / … vs `A:FILE.TXT`) | **Plan C2–C3** (logical device names + IOBYTE / FILE* binding) — **not** required for the raw #3022 link error; filename FCB path is enough for disk files |
| No FatFs / physical diskio on plain `+cpm` | **Agreed** — BDOS only |
| Do not move 150+ classic subtypes to newlib | **Plan §2.1–2.2** — CLIB-only newlib; classic multi-CPU untouched |
| Preserve serial / character abstraction | **Plan §2.4–2.5** + #3023 character_00 model |

**Bottom line:** #3022’s blocking item (missing target open → no disk FILE I/O on newlib `+cpm`) is covered by the FCB work already applied, plus `fopen_max`. The optional device-name dispatcher is the IOBYTE/logical-device work already in this plan (C2–C3), not a separate third stack.

---

## 2. Design constraints (must keep front-of-mind)

### 2.1 Classic CP/M supports *all* CPU types (mixed-tree hazard)

Classic `+cpm` is a **multi-CPU product family**, not “Z80 only with a few exceptions”. From `cpm.cfg` CLIBs and classic lists:

| CPU / CLIB | Product / notes |
|------------|-----------------|
| **Z80** | `default`, `ansi`, … → `cpm_clib` |
| **Z80 IXIY** | `ixiy` → `cpmixiy_clib` (some machines force this) |
| **Z180** | `z180` → `cpmz180_clib` |
| **8080** | `8080` → `cpm8080_clib` (+ `cpm_8080.lst` and related) |
| **8085** | `8085` → `cpm8085_clib` |
| **gbz80 / others** | Where the classic toolchain and lists support them for CP/M-class targets |

**Newlib CP/M is Z80 and “above” only** — `-clib=new` / `sdcc_ix` / `sdcc_iy` → `lib/clibs/{sccz80,sdcc_ix}/cpm.lib`. It does **not** build for 8080, 8085, or gbz80.

**After the move we are deliberately placing a Z80+ newlib stack into a tree that already serves every classic CPU.** That is the central structural risk:

- Same directory root (`libsrc/target/cpm/`) will hold classic multi-CPU objects and newlib Z80-class objects.
- Classic Make / `*.lst` / `cpm_8080.lst` / machine libs must **never** pick up newlib asm (Z80-only opcodes, newlib calling convention, SDCC/IX paths).
- Newlib `cpm_*.lst` must **never** pull classic fcntl C, machine gfx, or 8080-safe consoles into `cpm.lib`.
- Path includes, CRT0 selection, and `cpm.cfg` CLIB lines are the **only** bridge; subtypes stay classic-owned.

Isolation is not optional polish — it is the definition of a successful migrate.

### 2.2 150+ classic machine targets: gfx, CRT0, and subtype ownership

Classic CP/M has **over 150 machine targets / subtypes** (today `cpm.cfg` lists on the order of **~138 `SUBTYPE` entries**, plus related machine libraries and CRT specials). These are not a thin “output container” layer:

- **Disk / image containers** (imd, raw, dsk, kdi, …) and `-Cz+cpmdisk` formats.
- **Graphics** solutions under `libsrc/target/cpm/graphics/`, GSX (`gsx/`), machine-specific libs (`-lalphatro_cpm`, `-lbondwell`, TMS99x8 pragmas, fatpix, CRT_ORG_GRAPHICS, …).
- **CRT0 / org / stack** solutions that are machine-specific (`-zorg=…`, `REGISTER_SP`, classic `cpm_crt0`, forced `-clib=8080` / `ixiy` on individual subtypes).
- **Console** variants (generic_console, VT52, H19, ansi columns/rows, CLS codes).

**None of this moves to newlib in §13.** Subtypes remain **classic-owned**. Newlib is selected by **CLIB only** (`-clib=new` / sdcc_*), not by converting machine subtypes. A reviewer must not read “migrate +cpm” as “150 machines now on newlib.”

### 2.3 File I/O is not only FCB disk (tape and other media)

Data may be written to or read from **more than FCB disk files**:

| Path | Who | Notes |
|------|-----|--------|
| **FCB + BDOS** (open/read/write/…) | Classic fcntl; newlib dual-stack bridge (§12) | “Normal” CP/M disk files |
| **FatFs `f_*`** | Optional link (`-lff` …) on hardware stacks | Independent of FCB; dual-stack |
| **`-lndos` / no-disk** | Classic | Apps with no file system |
| **Tape / cassette / other file types** | Machine- or BIOS-specific classic paths | Not the newlib FCB bridge |
| **Character physical devices** (RDR/PUN/LST, paper tape logical PTR/PTP) | BDOS 3/4/5; classic `stdrdr_dev` / `stdpun_dev` / `stdlst_dev`; newlib `stdrdr`/`stdpun`/`stdlst` | Stream media, not FCB records |
| **Machine devices** | Subtype libs / BIOS | Stay classic or system-specific |

**Implication for §13:** newlib character/stdio work (IOBYTE, logical names, `tty*`) covers **BDOS character units and named logical devices**. It does **not** absorb classic tape drivers or reimplement every media type under `open()`. Tape and other non-FCB file types remain classic / machine / BIOS territory unless a later, explicit work item says otherwise.

### 2.4 CP/M character I/O: IOBYTE + four physical devices  **(new requirement)**

Per [IOBYTE](https://www.seasip.info/Cpm/iobyte.html) and BDOS device model ([CP/M archive](https://www.seasip.info/Cpm/index.html)):

**Physical devices** (BIOS/BDOS; IOBYTE lives at page-0 address 3; BDOS 7/8 get/set):

| Physical | Bits in IOBYTE | BDOS (typical) | Newlib today |
|----------|----------------|----------------|--------------|
| **CONSOLE** | 1–0 | 1/2/6/9/10/11… | `stdin`/`stdout`/`stderr` via cons or dcio drivers |
| **READER** | 3–2 | 3 | `stdrdr` ← `cpm_00_input_reader` |
| **PUNCH** | 5–4 | 4 | `stdpun` ← `cpm_00_output_punch` |
| **LIST** | 7–6 | 5 | `stdlst` ← `cpm_00_output_list` |

**Logical device names** (selected **per physical slot** by IOBYTE value):

| Value | CONSOLE | READER | PUNCH | LIST |
|-------|---------|--------|-------|------|
| 00 | **TTY:** | **TTY:** | **TTY:** | **TTY:** |
| 01 | **CRT:** | **PTR:** | **PTP:** | **CRT:** |
| 10 | **BAT:** | **UR1:** | **UP1:** | **LPT:** |
| 11 | **UC1:** | **UR2:** | **UP2:** | **UL1:** |

Notes from Seasip:

- **BAT** = batch: console **input** follows current **Reader**; console **output** follows current **List**.
- **CRT** = standard keyboard + screen; **LPT** = line printer; **PTR/PTP** = paper tape reader/punch; **TTY** = teletype (e.g. serial); **U\*** = user/implementation-defined.

**Already in newlib CRT** (`cpm_crt.asm.m4` / startups 0 and 4):

- Instantiates **physical** FILEs: stdin/stdout/stderr, **stdrdr**, **stdpun**, **stdlst**.
- Declared in newlib `stdio.h` as `extern FILE *stdrdr/stdpun/stdlst`.
- Drivers are **character_00**-class (good fit with #3023 serial abstraction).

**Also in newlib stdio (global decls):** `ttyin` / `ttyout` / `ttyerr` — the usual **second serial/teletype** FILE triple (input / output / error-dup), already declared in `stdio.h` for multi-port targets. On many hardware targets these are a second console_01/character pair; on **newlib `+cpm` they are not necessarily instantiated today**, but they are part of the logical device story: **TTY:** (and apps that expect a distinct teletype stream) should be able to use `ttyin`/`ttyout`/`ttyerr` the same way SIO/HBIOS CRTs do.

**Gaps vs this note:**

- No first-class **enumeration of logical names** (CRT, TTY, LPT, PTP, PTR, BAT, UC1, UL1, UP1, UR1, UP2, UR2) in a CP/M header for apps.
- **`ttyin` / `ttyout` / `ttyerr` not wired** on default newlib CP/M CRTs (even though declared in `stdio.h`).
- No clear API to open/bind a **logical** device name to a `FILE*` / fd via stdio (`fopen`/`freopen`/`fdopen` patterns) while IOBYTE/BIOS still perform the real routing for BDOS CON/RDR/PUN/LST calls.
- BAT semantics are IOBYTE/BIOS behaviour, not a fifth physical driver.


### 2.5 Reference: RC2014 CP/M-IDE is a CP/M *implementation*

CP/M-IDE is not merely a “sample that prints to two UARTs”. It is a **full CP/M system** (shell + CCP/BDOS + BIOS) that must understand:

1. **Physical ports** (real hardware: UARTA/UARTB, SIO A/B, ACIA, …)  
2. **Logical CP/M devices** (CRT, TTY, LPT, PTR, PTP, BAT, U*, …)  
3. **Mapping physical ↔ logical** in **two layers** that must stay coherent:
   - **C program (shell / ROM monitor)** — before and while talking to the user  
   - **Assembly CP/M (BIOS, and BDOS via IOBYTE)** — after CP/M is loaded and running  

Sources: `RC2014/ROMs/CPM-IDE/**/main.c`, `cpm22bios.asm`, `cpm22.asm` (dual-serial UART/SIO variants; ACIA is single-port).

#### Layer A — C shell (stdio + physical FILE* + IOBYTE seed)

Dual-port builds (`*-uart`, `*-sio`):

1. **Physical ports are bound at CRT link time** to two FILE triples (not via `fopen("CRT:")`):
   - Port A / **CRT hardware:** `stdin` / `stdout` / `stderr`  
   - Port B / **TTY hardware:** `ttyin` / `ttyout` / `ttyerr`  
2. Shell keeps `FILE *input`, `*output`, `*error` and selects which **physical** triple is active:
   - `:` on UARTA → `stdin/stdout/stderr`, `bios_iobyte = 0x81` (CON → **CRT:**)  
   - `:` on UARTB → `ttyin/ttyout/ttyerr`, `bios_iobyte = 0x80` (CON → **TTY:**)  
3. UI uses **`fprintf(output, …)` / read `input`** — one code path, physical port chosen by FILE*.  
4. Shell **writes the IOBYTE seed** (`bios_iobyte`) so the later assembly BIOS knows which logical CON (and related slots) the user chose.

Single-port ACIA: only `stdout`/`stdin`; no `tty*` switch — still a CP/M implementation, just one physical console.

#### Layer B — Assembly CP/M (BIOS maps IOBYTE → physical ports)

When the shell starts CP/M:

1. BIOS copies shell seed into page-0 IOBYTE (`_bios_iobyte` → `_cpm_iobyte` at `$0003`).  
2. **BDOS** character calls (CONIN/CONOUT, READER, PUNCH, LIST, …) go through **BIOS**, which **interprets IOBYTE** and calls the matching **physical** driver (UARTA vs UARTB, etc.).  
3. Example (`cpm22bios.asm`): CONIN checks IOBYTE CON field → CRT path (`_uarta_getc`) vs TTY path (`_uartb_getc`); BAT redirects; LIST/PUNCH bits select CRT/TTY/LPT/… as implemented.

So: **C layer** = “which FILE* do I use *now*, and what IOBYTE should CP/M inherit?”  
**ASM layer** = “for BDOS physical unit X with IOBYTE Y, which UART/device do I call?”

Both layers need the **same physical→logical vocabulary** or CP/M and the shell disagree after warm boot / CCP.

#### Contrast with generic newlib `+cpm -clib=new` (this migrate)

| | CP/M-IDE (implementation) | Newlib `+cpm` **application** CRT |
|--|---------------------------|-------------------------------------|
| Role | Provides BIOS+BDOS+shell; **defines** physical→logical map | Runs **under** an existing CP/M; uses BDOS (and whatever BIOS IOBYTE does) |
| Physical ports | Known at build time (UARTA/B, SIO, …) as z88dk drivers | Abstracted: BDOS CON/RDR/PUN/LST only (BIOS behind) |
| Logical names | Encoded in shell IOBYTE values + BIOS jump tables | Need **headers + stdio names** so apps can talk CRT/TTY/LPT/… without hardcoding `$0003` bits |
| `ttyin/out/err` | Real second port FILEs in the **implementation** CRT | Declared in stdio; optional second stream for apps when useful; not a second BIOS |
| `stdrdr/stdpun/stdlst` | Secondary to shell UI; BIOS still implements RDR/PUN/LST | Instantiated for apps via BDOS 3/4/5 |
| FatFs | Implementation uses `f_*` for IDE volumes | Apps may link FatFs on hardware; not part of IOBYTE |

#### Plan implications

- Treat CP/M-IDE as the **reference CP/M implementation** of physical↔logical mapping (C + ASM), not as “just a dual-UART demo”.  
- **Generic newlib +cpm apps** sit *above* BDOS: they need enumerated logical devices + FILE* (`stdin`, `tty*`, `stdrdr`, …) and IOBYTE get/set helpers so they can cooperate with a BIOS like CP/M-IDE’s.  
- **Hardware targets that *are* CP/M implementations** (or load one) must keep shell/CRT FILE binding and BIOS IOBYTE tables aligned — same lesson as CP/M-IDE.  
- Do not require `fopen("TTY:")` as the only API: CP/M-IDE shows **FILE* selection + IOBYTE seed** is how a real implementation works; freopen/name helpers are complementary for portable apps.  
- Migration PR still does not rewrite CP/M-IDE; it must **not break** the FILE names and dual-port pattern apps/implementations already use.


---

## 3. Target architecture (end state)

```text
libsrc/target/cpm/                    ← MIXED TREE (do not blur products)
  #
  # CLASSIC — all CPUs (z80, ixiy, z180, 8080, 8085, gbz80…),
  #           150+ subtypes, machine gfx, CRT0 specials, tape/media
  #
  fcntl/          classic FCB (multi-CPU)
  stdio/          consoles + stdrdr/stdpun/stdlst_dev (classic)
  graphics/ gsx/  machine graphics
  time/ *.lst     cpm.lst, cpm_8080.lst, machine lists
  (machine libs / subtype wiring stay classic)

  #
  # NEWLIB — Z80 and above only (moved from libsrc/newlib/target/cpm/)
  #          never linked into 8080/8085/gbz80 classic products
  #
  config*  cpm_crt.asm.m4  startup/
  driver/{terminal,character,file}/   # FCB bridge + char devices
  library/cpm_{sccz80,sdcc_ix}.lst

include (newlib):
  arch/cpm.h or cpm_device.h — IOBYTE bits + logical device name enums/strings
  (stdio already has stdrdr/stdpun/stdlst; ttyin/ttyout/ttyerr decls)
```

**App model (newlib):**

```text
Logical names (header):  CRT TTY LPT PTP PTR BAT UC1 UL1 UP1 UR1 UP2 UR2
        │
        │  map via IOBYTE (and BAT rule) to physical slot
        ▼
Physical FILE* / drivers:
  CON  → stdin / stdout / stderr
  RDR  → stdrdr
  PUN  → stdpun
  LST  → stdlst
  TTY stream (optional second port) → ttyin / ttyout / ttyerr
        │
        ▼
BDOS 2–6 / 10 …  (BIOS implements IOBYTE routing for that physical unit)
```

**ttyin / ttyout / ttyerr:** treat as the stdio **logical teletype triple** (always enumerate; instantiate when the CRT has a TTY binding — e.g. CON or RDR/PUN slot selecting TTY:, or an explicit second character device). `ttyerr` remains a **dup** of `ttyout` (same pattern as stderr→stdout).

---

## 4. Non-goals

| Non-goal | Why |
|----------|-----|
| Port newlib to 8080 / 8085 / gbz80 | Classic already covers **all** those CPUs for CP/M |
| Convert 150+ subtypes / machine gfx / CRT0 specials to newlib | Classic machine ownership; gfx and org/stack stay classic |
| Unify classic and newlib object lists under one glob | Would break multi-CPU isolation |
| Full BIOS implementation of all U* devices | BIOS/vendor; we expose names + stdio hooks |
| Implement real paper-tape / cassette hardware | Logical PTR/PTP + BDOS RDR/PUN; hardware is system-specific |
| Put tape or other media under newlib FCB `open` | FCB = disk files; tape and other file types stay separate |
| Merge classic/newlib cores or fcntl | Same as #3023 dual-stack rules |
| FatFs path router into FCB | `f_*` remains independent |

---

## 5. Phased work

### Phase C0 — Inventory + freeze gates

- Map classic vs newlib trees; name collisions (`stdio/`, `fcntl/`, drivers).
- **CPU matrix:** classic products for z80 / ixiy / z180 / 8080 / 8085 / (gbz80 if present) vs newlib Z80+ only.
- **Subtype surface:** note 150+ targets; sample gfx / CRT0 / forced-clib subtypes that must not be touched.
- **Media surface:** FCB disk vs tape/other file types vs character RDR/PUN/LST (classic already has `stdrdr_dev` / `stdpun_dev` / `stdlst_dev`).
- Document physical FILE* already present on newlib; list logical names **not** yet in headers; `tty*` gap.
- **Baselines (`test/suites/target_io`):** see §5.1 — keep classic **default subtype only** (Z80 + 8085 CLIB recipes already present); keep/extend **newlib** CP/M recipes (plain `+cpm -clib=new` and existing `+rc2014 -subtype=cpm`).

**Exit:** inventory written (including mixed-tree risk); `target_io` baselines green.

### Phase C1 — Tree move + path wiring (structural)

- Move newlib cpm under `libsrc/target/cpm/` **without** clobbering classic dirs (`fcntl/`, `stdio/`, `graphics/`, `gsx/`, classic `*.lst`).
- Prefer a clear newlib sub-layout (or strict list ownership) so “Z80+ only” objects are obviously separate from multi-CPU classic objects.
- `MIGRATED_TARGETS += cpm` when build works; update **only** newlib CLIB lines in `cpm.cfg` (paths to CRT0 / `-lcpm` / include); **do not** rewrite SUBTYPE lines.
- Isolation proof: classic multi-CPU lists (`cpm.lst`, `cpm_8080.lst`, machine lists) do **not** pull newlib objects; newlib lists do **not** pull classic fcntl/gfx.

**Exit:** `cpm.lib` builds from `../target/cpm`; classic multi-CPU products still build; no subtype regressions by design (untouched).

### Phase C2 — Logical device enumeration (headers)  **required by this note**

| Work | Detail |
|------|--------|
| Header | Add CP/M device API (prefer `include/_DEVELOPMENT` proto + common, e.g. `arch/cpm.h` or `cpm/devices.h`) |
| IOBYTE | Bit field masks/shifts for CON/RDR/PUN/LST; get/set via BDOS 7/8 wrappers if not already clean |
| Logical names | Enumerate at least: **CRT, TTY, LPT, PTP, PTR, BAT** (plus **UC1, UL1, UP1, UR1, UP2, UR2** for completeness) |
| Stdio FILE names | Physical: `stdin`/`stdout`/`stderr`, `stdrdr`, `stdpun`, `stdlst`. Teletype triple: **`ttyin` / `ttyout` / `ttyerr`** (must be part of the public device map) |
| Physical names | CON / RDR / PUN / LST ↔ existing streams; TTY stream ↔ `ttyin`/`ttyout`/`ttyerr` where instantiated |
| Mapping table | Constants matching Seasip IOBYTE grid (which logical assigns to which physical slot value 0..3) |
| Docs | Comment that **BIOS** performs physical binding; stdio drivers call BDOS physical functions |

**Exit:** headers usable from `+cpm -clib=new` apps; no behaviour change required yet beyond constants/API surface.

### Phase C3 — Stdio usability of named devices  **required direction**

Minimum viable behaviour for newlib (Z80-class):

| Capability | Approach |
|------------|----------|
| Access physical units via stdio | Already: printf→stdout/CON; fprintf(stdlst); fgetc(stdrdr); etc. |
| Teletype triple | **`ttyin` / `ttyout` / `ttyerr`**: enumerate and implement as stdio logical devices (TTY). Default CRT may leave them uninstantiated; when TTY is selected or a second port exists, wire character drivers + `m4_file_dup` for `ttyerr`→`ttyout` (same as #3023 multi-port) |
| Named logical devices | API such as `FILE *cpm_device_file(logical_id)` or `fopen("CRT:", "r+")` / `freopen` / `"TTY:"` that resolves to the right **FILE*** (`stdin`/`stdout`, `ttyin`/`ttyout`, `stdrdr`, …) and/or adjusts IOBYTE |
| BAT | Document/implement as IOBYTE CON=BAT (value 2): input path uses RDR unit, output uses LST unit — not a separate FDSTRUCT unless we add aliases |
| Serial abstraction | Keep physical drivers as **character_00** (and cons as character/console_01) so multi-port + `m4_file_dup` remains the model for `tty*` and any extra logical aliases |

**Preferred design (plan default) — two audiences, one vocabulary:**

| Audience | Needs |
|----------|--------|
| **CP/M implementation** (e.g. CP/M-IDE) | Physical port drivers; CRT maps `stdin`/`tty*` to hardware; BIOS maps IOBYTE logical → physical; shell seeds IOBYTE for ASM CP/M |
| **CP/M application** (`+cpm -clib=new`) | Portable names + FILE* + BDOS 7/8; does not program UART registers |

Shared design:

1. **Physical streams:** CON (+ stderr dup), RDR, PUN, LST; plus **`ttyin`/`ttyout`/`ttyerr`** when a second console path exists.  
2. **Logical names** enumerated (CRT, TTY, LPT, PTP, PTR, BAT, U*) + IOBYTE field helpers.  
3. **Usage patterns (both valid, both used in real systems):**
   - **Implementation/shell style (CP/M-IDE):** assign `input`/`output` to `stdin` or `ttyin`/`ttyout`; set IOBYTE seed for later ASM BIOS.  
   - **Portable app style:** `fopen`/`freopen`/`cpm_device_file("LPT:")` → FILE* +/or IOBYTE.  
4. **Binding:** prefer **(A)** names → FILE* + IOBYTE (BIOS does physical map). Extra drivers **(B)** only if needed.

CP/M-IDE is the reference for **implementation-side** dual-port + IOBYTE coherence; generic newlib +cpm is the **application-side** consumer of that model via BDOS.

**Exit:** documented API; at least CRT/TTY/LPT/PTP/PTR/BAT usable from C with stdio; **`ttyin`/`ttyout`/`ttyerr` named and bindable** as the TTY stdio triple; UC*/UP*/UR* enumerated even if they alias to the same physical drivers until BIOS defines them.

### Phase C4 — Link isolation + multi-CPU classic proof

Because classic CP/M is **all CPUs**, isolation must not rely on a broad classic subtype matrix:

- **Classic `target_io`:** **default subtype only** — existing `test_cpm_z80.com` and `test_cpm_8085.com` (`+cpm` default, classic CLIB z80 / 8085). **Do not** expand classic `target_io` across the 150+ machine subtypes, gfx containers, or forced-clib machines.
- Optional light classic **8080** and/or **z180** hello outside `target_io` if useful for isolation (not a full classic suite).
- Spot-check at most **one** known subtype container build if cheap; no full matrix.
- Newlib `+cpm -clib=new` / `sdcc_iy` smoke including device header use + **newlib `target_io`** (§5.1).
- **No newlib symbols** in classic 8080/8085 images; no classic fcntl objects in newlib `cpm.lib` map.

### Phase C5 — Tests

#### 5.1 `target_io` (required gate)

Location: `test/suites/target_io/`. Shared body: `io_tests.c` + `fcntl_native.c` (BDOS/FCB) or host backend.

**Existing recipes (keep as gates):**

| Recipe | Product | Role |
|--------|---------|------|
| `test_cpm_z80.com` | Classic `+cpm` default (Z80) | Classic multi-CPU coexist — **default subtype only** |
| `test_cpm_8085.com` | Classic `+cpm -clib=8085` default | Classic 8085 — **default subtype only** |
| `test_rc2014_cpm.com` | Newlib `+rc2014 -subtype=cpm -clib=new` | Newlib FCB bridge under host CP/M (Z80) |

**Add / promote for plain newlib `+cpm`:**

| Recipe | Product | Role |
|--------|---------|------|
| `test_cpm_new_z80.com` (name TBD) | **`+cpm -clib=new`** (Z80) | Primary newlib portable CP/M gate — BDOS FCB + serial |

Note: newlib CP/M is **Z80-class only**. There is no `+cpm -clib=new` 8085 product; classic **8085** remains covered by `test_cpm_8085.com` (default subtype). Do not invent a newlib-8085 CP/M `target_io` binary.

**Serial coverage (extend `io_tests` / recipes as needed):**

| Surface | Today | Extension where relevant |
|---------|--------|---------------------------|
| CON (`printf` / `scanf` on stdin/stdout) | Yes | Keep; confirm both classic default and newlib `+cpm` / rc2014-cpm |
| RDR / PUN / LST (`stdrdr` / `stdpun` / `stdlst`) | No dedicated tests | Add light newlib checks: write LST/PUN, read RDR if ticks BDOS allows; or compile/link smoke that references those FILE* |
| `ttyin` / `ttyout` / `ttyerr` | N/A until C3 wires them | When TTY triple exists on a CRT, add a serial path that uses them (newlib only) |
| Dual-port / IOBYTE | Not in suite | Optional later; not required for first FCB gate |

**Disk / fcntl coverage (extend as needed):**

| Call / behaviour | Today in `io_tests.c` | Extension where relevant |
|------------------|----------------------|---------------------------|
| `creat` / `write` / `close` | Yes | Keep |
| `open` / `read` | Yes | Keep |
| `lseek` (SEEK_SET / END + overwrite) | Yes | Keep; ensure newlib `+cpm` and rc2014-cpm both exercise it |
| Multi-fd concurrent open | Yes (`test_file_multi`) | Keep |
| `O_RDWR` / truncate / append flags | Partial | Add if `cpm_01_file` claims support (O_CREAT/O_TRUNC/O_APPEND) |
| `fopen` / `fread` / `fwrite` / `fclose` | No | **Add** for newlib (closes #3022 stdio path; needs `fopen_max`) |
| Large/cross-extent seek | Minimal | Optional stress if ticks CP/M extent behaviour is stable |
| FatFs `f_*` | Out of scope for plain `+cpm` | Hardware dual-stack only — not required in this suite for `+cpm` |

**Classic breadth rule:** only **default** classic CP/M subtype in `target_io`. No classic machine-subtype fan-out.

**Exit for C5 `target_io`:**  
`make -C test/suites/target_io` green for classic default Z80 + 8085, newlib `+cpm -clib=new`, and `+rc2014 -subtype=cpm`; extended serial/disk cases present for newlib where the CRT exposes them.

#### 5.2 Other gates

| Gate | Required |
|------|----------|
| `target_io` suite as in §5.1 | **Yes** |
| Newlib cpm rebuild + hello / device headers after C2 | **Yes** |
| Optional: unit test IOBYTE helpers / device name map (host or ticks) | Preferred after C2–C3 |
| Classic 8080 / z180 hello (outside target_io) | Optional isolation only |
| Full 150+ subtype matrix / all gfx / real tape or PTR hardware | **No** |

### Phase C6 — Docs light

- HANDOFF §13 status; short in-tree note under newlib cpm: **mixed tree** (classic all-CPU vs newlib Z80+), physical vs logical vs FCB vs FatFs vs tape/other media.
- Wiki File I/O (optional): one paragraph on CP/M character devices + IOBYTE; point that machine subtypes/gfx/tape stay classic.

---

## 6. Hard rules

1. Never overwrite classic `fcntl/`, `stdio/`, `graphics/`, `gsx/`, machine libs, or classic `*.lst`.  
2. Never link newlib objects into classic multi-CPU products (8080, 8085, gbz80, z180 classic CLIB, …).  
3. Never require newlib for any of the 150+ subtypes; subtypes stay classic unless the user already selects a newlib CLIB.  
4. One `open` owner for **disk** fcntl; character devices are separate FILEs; **tape/other media** are not silently folded into FCB `open`.  
5. `f_*` = FatFs only.  
6. Logical device **names** are portable; **U*** and machine binding are BIOS/system-specific.  
7. Machine **graphics** and **CRT0/org/stack** solutions remain classic.  
8. Reuse §12 FCB bridge; do not import classic fcntl C into newlib.

---

## 7. Risk register

| Risk | Mitigation |
|------|------------|
| Classic Make / globs pick up newlib Z80 objects into 8080/8085 builds | Explicit `*.lst`; no broad tree globs; C4 nm/map check |
| Newlib lists accidentally include classic fcntl or gfx | Separate list ownership; C1 isolation proof |
| Mixed-tree confusion for contributors | Tree layout + README/comment: classic all-CPU vs newlib Z80+ |
| Reviewer thinks 150 machines / gfx moved to newlib | PR text: CLIB-only migrate; subtypes/gfx/CRT0 untouched |
| Tape / other media expected under newlib `open` | Docs: FCB = disk; media types remain separate; RDR/PUN for stream tape-like I/O |
| Confusing logical names with extra hardware ports | Headers + docs: IOBYTE map, four physical BDOS units + optional `tty*` |
| BAT / U* over-engineering | Enumerate all; implement CRT/TTY/LPT/PTP/PTR/BAT first via IOBYTE+(A) |
| Breaking a CRT0-special subtype by cfg edit | Edit **only** newlib CLIB path lines in `cpm.cfg` |

---

## 8. Verification (summary)

| Check | Role |
|-------|------|
| `target_io` classic default Z80 + 8085 | Classic default-subtype only (not full classic matrix) |
| `target_io` newlib `+cpm -clib=new` | Primary newlib portable FCB + serial gate |
| `target_io` `+rc2014 -subtype=cpm` | Hardware newlib under host CP/M (existing) |
| `target_io` extended disk (`lseek`, multi-fd, optional `fopen`) | FCB depth on newlib |
| `target_io` extended serial (RDR/PUN/LST / `tty*` when wired) | Character devices on newlib |
| Newlib cpm rebuild + hello | Path wiring (Z80+) |
| Compile against new device headers | C2/C3 surface |
| Optional fopen("LPT:") / IOBYTE helper smoke | C3 |
| Map/nm: no newlib in classic non-Z80 image | Hard isolation |

---

## 9. Suggested order after approval

1. **C0** inventory (CPU matrix, subtype/gfx surface, media types, stdrdr/stdpun/stdlst + IOBYTE/`tty*` gap; freeze `target_io` baselines).  
2. **C1** tree move + cfg (newlib CLIB lines only) + list isolation.  
3. **C2** headers (logical + physical + IOBYTE).  
4. **C3** stdio binding (prefer IOBYTE + existing FILEs).  
5. **C4–C5** isolation + **`target_io`** (classic default Z80/8085 only; newlib `+cpm` + rc2014-cpm; extend serial + disk).  
6. **C6** docs (mixed tree + devices + media boundaries).  
7. **Delete this file** (`newlib_cpm_migration_plan.md`) before the PR is merged.

---

## 10. PR framing (later)

**Title sketch:** `newlib - migrate +cpm under libsrc/target/cpm; CP/M device names + IOBYTE for stdio`

**Lead:** Place newlib Z80+ CP/M beside classic in `libsrc/target/cpm/` **without** disturbing classic’s **all-CPU** products (8080/8085/z80/z180/gbz80…), **150+ subtypes**, machine **graphics/CRT0**, or **tape/other media**. Newlib remains CLIB-selected only. Physical BDOS devices already present; logical CRT/TTY/LPT/PTP/PTR/BAT (and U*) enumerated for stdio; `ttyin`/`ttyout`/`ttyerr` as TTY FILE triple; FCB dual-stack unchanged.

**Hygiene:** Remove `newlib_cpm_migration_plan.md` from the tree before merge (temporary working plan only).
