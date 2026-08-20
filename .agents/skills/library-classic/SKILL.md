---
name: library-classic
description: >
  z88dk classic library world: libsrc/target and classic trees, multi-CPU
  (8080/8085/gbz80/…), fgets_cons line input, hybrid CRT traps, isolation from
  newlib. Use when working on classic clib, 8085 products, or hybrid consoles.
---

# Library — classic

## 1. Two library worlds (do not blur)

| World | Home | CPUs | Typical product |
|-------|------|------|-----------------|
| **Classic** | `libsrc/target/<name>/` (historic fcntl/stdio/gfx) + `libsrc/classic/` | Z80, IXIY, Z180, **8080**, **8085**, gbz80, … | `*_clib.lib`, `cpm8085_clib.lib`, … |
| **Newlib** | Was `libsrc/newlib/target/<name>/`; migrated → `libsrc/target/<name>/` beside classic | **Z80-class** (`-clib=new` / `sdcc_ix` / `sdcc_iy`) | `lib/clibs/{sccz80,sdcc_ix}/<target>.lib` |

**Hard rules**

1. Do **not** merge classic and newlib **stdio cores** or **fcntl `open` owners** in one link without a designed bridge.
2. Prefer sharing **device / thin driver** layers, not cores.
3. **CLIB** selects newlib; machine **SUBTYPE**s usually stay classic-owned (esp. CP/M’s 150+ machines).
4. After a path move, put the target name in `MIGRATED_TARGETS` in `libsrc/newlib/Makefile` so builds use `../target/<name>`.

**Mixed tree hazard:** when newlib Z80+ sources land under `libsrc/target/cpm/` next to classic multi-CPU code, isolation is **list ownership** (`*.lst`), never broad globs. Classic 8080/8085 images must never pull newlib objects (Z80-only opcodes / calling conventions).

---

## Classic I/O patterns (from target work)

### Hybrid classic+newlib consoles (rc2014-8085 lesson)

When a CRT mixes **classic** `fgetc_cons`/`fputc_cons` with newlib-style startup:

- FILE init flags must match classic expectations (**`18` / `20`** = `_IOSYSTEM|_IOREAD` / `_IOWRITE`).
- Wrong flags (`19`/`21` with spurious `_IOUNGETC`) made first `getchar` return NUL.
- Hybrid clib lists must **not** pull full newlib fcntl/stdio/threads.
- Build: classic `<stdio.h>` must win include order (`-I…/include` **before** `_DEVELOPMENT/common`) when the hybrid needs classic `stdin`/`stdout` objects.

### Cooked line input: newlib vs classic (general)

| World | Line API | Who echoes / edits |
|-------|----------|--------------------|
| **Newlib** | POSIX **`getline` / `getdelim`** | **console_01** (line mode, echo, BS, CR/LF cook) via tied oterm |
| **Classic** | **No `getline`** | **`fgets` on stdin → `fgets_cons`** (echo, DEL, optional soft cursor) |
| **Classic raw** | `fgetc` / `fgetc_cons` | **No** line editor — app must implement if needed |

**Rules of thumb**

1. **`getline` is newlib-only.** Never expect it on 8080/8085 classic products.
2. **One cook layer only.** If the driver/`fgets_cons` already echoes, do **not** also echo in app code (double echo).
3. Hybrid CRTs that only bind `fgetc_cons`/`fputc_cons` are **raw**. App-level line readers (e.g. shell `ya_getline`) are compensating for classic, not for the CPU.
4. Prefer **`fgets` / `fgets_cons`** on classic instead of reimplementing line edit. On serial targets, disable soft cursor if needed (`CLIB_DISABLE_FGETS_CURSOR=1` — already set for `rc2014-8085`).
5. Align dual-CPU apps (Z80 newlib + 8085 classic) at a **single call site** with `#ifdef`, not by linking newlib stdio into 8085 images.

### Dual-port FILE* vs classic `ttyin` macros

| | Newlib CRT | Classic hybrid (e.g. `uart85`) |
|--|------------|--------------------------------|
| Second port | Real drivers: `m4_rc_01_input_uartb(_ttyin, …)` etc. | Often **only** stdin/out/err → primary UART/ACIA |
| `ttyin` / `ttyout` in headers | `extern FILE *` | Classic macros → **`_sgoioblk[3]`…** slots |
| Meaning | Instantiated streams | **Declaration/slots ≠ working UARTB console** |

`fgetc` on classic special-cases **stdin** → `fgetc_cons`. Assigning `input = ttyin` does **not** create a second cooked port unless the CRT initialises that slot and a driver path exists. For dual-port on hybrid: either an **active-console** global in `fgetc_cons`, or real second-stream CRT work — do not copy newlib’s `input = ttyin` pattern blindly.

### CP/M IOBYTE seeds (firmware shells)

Shell may seed **`bios_iobyte`** before handing off to CCP; BIOS copies it to page-0 IOBYTE.

- CON is **low 2 bits** (CRT vs TTY, etc.).
- Hardware-specific high bits (e.g. 8085 module **LST → SOD**) may require seeds like **`0x81` / `0x80`**, not bare `1` / `0`. Match the BIOS `list`/`const` decode, not “Z80 values”.

---

## Agent rules

1. Classic **8080/8085** images must never pull newlib objects (Z80 opcodes / conventions).
2. Isolation is **list ownership** (`*.lst`), never broad globs over mixed trees.
3. Line input: **`fgets` → `fgets_cons`**; no `getline`.
4. Runtime: `libsrc/l/sccz80/7-8085/`, `8-8080/`, `8-gbz80/`, … → crt0 libs in `lib/clibs/`.

## Related

- Newlib world: `library-newlib`
- Layout: `style-libsrc-layout`
- Targets: `target-cpm`, `target-rc2014`; host TIMER / suites use `+test`
