---
name: tool-z80asm
description: >
  z88dk-z80asm assembler/linker/librarian: -mCPU, -x lib, synthetics, listings. Use when assembling libsrc or making .lib products.
---

# Tool — z80asm

| | |
|--|--|
| Binary | `z88dk-z80asm` |
| Help | z88dk-z80asm -h; deep docs wiki/tools/Tool---z80asm---*.md and src/z80asm/README.md |
| Wiki (local draft) | `wiki/tools/Tool---z80asm.md` |


## Agent essentials

| Need | Usage |
|------|--------|
| CPU | `-m8085` / `-mz80` / `-mz80n` / … |
| Library | `-x name` + `@list.lst` |
| Listing | `-l` → `.lis` (verify synthetics / illegal ops) |
| Object | default `.o`; `-d` date-based rebuild in library builds |
| `PHASE` / `DEPHASE` | Store bytes here; labels and `$` at a different run address. See below. |

### `PHASE` expression … `DEPHASE`

Assemble bytes at the **current storage PC** (the section, as the linker will place it). Resolve **labels and `$` / `ASMPC`** as if `ORG expression` were in effect.

Wiki: [Tool — z80asm — directives](https://github.com/z88dk/z88dk/wiki/Tool---z80asm---directives). Source: `src/z80asm/src/c/directives.c` (`asm_PHASE` / `asm_DEPHASE`), `codearea.c` (`asmpc_phase`).

**The linker has no knowledge of `PHASE`.** It is assembly-time only.

| | Inside `PHASE` | After `DEPHASE` (or never phased) |
|--|----------------|-------------------------------------|
| Bytes | Occupy space at the **storage** PC in the current `SECTION` | Same: storage PC continues after the PHASE’d bytes |
| Labels, `$` | Run address (`expression` + offset) | Storage / section address |
| Symbol type | **`TYPE_CONSTANT`** — absolute, **not relocated** | **`TYPE_ADDRESS`** — linker relocates with the section |
| Map file | `= $NNNN ; const, …` | `= $NNNN ; addr, …` |

That split **guarantees the PHASE’d code cannot run where it is stored.** Runtime must copy it to `expression` (typically `ldir`) before `call` / `jp` to those labels. `jr` still works (relative offset is the same in both spaces). `call` / `jp` to a PHASE label go to the **run** address, not the storage address.

```asm
    ld  hl, start          ; storage address (relocatable)
    ld  de, $8000          ; run address
    ld  bc, end-start      ; size of the PHASE’d bytes
    ldir
    jp  $8000
start:
    PHASE $8000
f1: ...                    ; f1 = $8000 (const), bytes sit at start
    DEPHASE
end:
```

**ROM-resident / in-situ code** (runs at its storage address: shell, FAT, IDE that is not LDIR’d) must **not** sit inside `PHASE`. Put it in another file/`SECTION` with no `PHASE`, or after `DEPHASE` in the same file. A second source with its own `SECTION` does not inherit a PHASE origin from an `INCLUDE` into a PHASE’d file.

`PHASE` / `DEPHASE` reset module-local `@` labels. `PHASE` address is 0…`$FFFF`. Nested `PHASE` replaces the phase PC; `DEPHASE` ends phasing for the section (logical `$` = storage PC again).

### Synthetic opcodes (normal mode)

Assembler **sugar** expanded to real ops (no harmful flag/side effects for the
documented forms). **Strict** / `-no-synth` forbids free synthetics.

**16-bit register-pair copies (full set)** — two 8-bit `ld`s each:

| Allowed | Forbidden in this set |
|---------|------------------------|
| **`ld`** among **`bc` / `de` / `hl`** — **any → any** (`ld bc,de`, `ld de,hl`, `ld hl,bc`, …) | **`af`**, **`sp`** |

Prefer these over hand two-byte moves and over swap dances when parking one pair
(`ld bc,hl` … work … `ld hl,bc`). Same family on 8080/8085/z80/z80n/z180/gbz80
(and related) in normal mode — coding rules still differ per **cpu-*** skill.

Other examples: `ld a,(hl+)` (load + inc). Listings (`-l`) show the expansion.
## CPU capability fixtures (how to read them)

**Question these answer:** “If I assemble this **source line** with `z88dk-z80asm -m<cpu>`, does the assembler accept it, and what does it emit?”

That is **assembler acceptance**, not a human ISA manual and not always a single native chip opcode. Library coding rules (e.g. 8085 stack-only, prefer true extended ops) can be stricter than “assembler accepts.”

### Where

Tree path (always prefer this checkout):

```text
src/z80asm/dev/cpu/
```

Same on GitHub: https://github.com/z88dk/z88dk/tree/master/src/z80asm/dev/cpu

Generated from opcode tables (`make` in that dir rebuilds them). Treat as **last resort** when skills or external opcode sites disagree with the toolchain.

### Which file for which CPU

| You assemble with | Read first |
|-------------------|------------|
| `-m8085` | `cpu_test_8085_ok.asm` / `cpu_test_8085_err.asm` |
| `-m8080` | `cpu_test_8080_ok.asm` / `cpu_test_8080_err.asm` |
| `-mz80` | `cpu_test_z80_ok.asm` / `cpu_test_z80_err.asm` |
| `-mz80n` | `cpu_test_z80n_ok.asm` / `cpu_test_z80n_err.asm` |
| `-mz180` | `cpu_test_z180_ok.asm` / `cpu_test_z180_err.asm` |
| `-mgbz80` | `cpu_test_gbz80_ok.asm` / `cpu_test_gbz80_err.asm` |
| other `-m…` | `cpu_test_<same-name>_ok.asm` / `_err.asm` |

| Filename piece | Meaning |
|----------------|---------|
| `*_ok.asm` | These **source forms assemble successfully** for that CPU |
| `*_err.asm` | These **source forms must fail** (comment `; Error`) |
| `*_strict_*` | Assembler in **strict mode** for that CPU (see below) |
| `*_ixiy_*` | IX/IY swap build variant |

Default library / zcc work uses the **non-`strict`** pair matching `-m` (synthetics allowed). Use `*_strict_*` only when checking **strict** assemble rules.

### Strict mode (`*_strict_*`)

**`strict` means the assembler is run in strict mode: synthetic opcodes are forbidden.**

| Mode | Synthetics (e.g. `ld de,hl` as two 8-bit loads, many multi-insn expansions) | Typical fixture |
|------|-----------------------------------------------------------------------------|-----------------|
| Normal (`cpu_test_8085_ok.asm`) | Allowed when the tables define them | multi-byte comments like `; EB 73 EB` or pair copies |
| Strict (`cpu_test_8085_strict_ok.asm`) | **Not** allowed as freeform synthetics | those forms move to `*_strict_err.asm` (`; Error`) |

Still legal in strict if they are **real CPU ops** (or accepted aliases of real ops), e.g. on 8085:

- `sub hl,bc` → `; 08` (extended)
- `ld de,sp+0` → `; 38 00` (extended; Intel alias `ldsi` exists for compat only)
- `ld de,hl+0` → `; 28 00` (extended LDHI — not the synthetic `ld de,hl` pair copy)

Strict rejects forms that only exist as assembler sugar, e.g. on 8085 strict: `ld de,hl` and `ld (de),l` → **Error** (see `cpu_test_8085_strict_err.asm`).

CLI: strict corresponds to the assembler’s strict CPU / no-synth-style path (fixtures are the ground truth; also note general `-no-synth` in help for disabling synthetics on non-strict runs).

### Mnemonics: Zilog everywhere; Intel only for external compatibility

**z88dk prefers Zilog mnemonics everywhere** (library, CRT, examples, agent-written asm). Emit `ld`, `jp`, `add a,*`, … — not `MOV` / `JMP` / `ADI`.

**z80asm** also accepts **Intel** mnemonics on **8080/8085** (and lists them in fixtures, especially `*_strict_ok.asm`) for **compatibility with external / third-party sources**, not as a z88dk house style.

| | Role |
|--|------|
| **Zilog** | Required style for all z88dk tree work |
| **Intel in z80asm** | Compatibility only — assembling foreign code or reading fixtures that prove both spellings encode the same op |

When bringing external Intel-syntax asm **into** this tree, **translate to Zilog**. Do not write new z88dk sources in Intel mnemonics because the assembler would accept them.

### Line format (both ok and err)

One instruction form per line, columns loosely:

```text
<asm source form>                 ; <result>
```

**On `*_ok.asm`, `<result>` is the expected encoding**, for example:

| Comment shape | What it means for agents |
|---------------|---------------------------|
| `; 08` | One native opcode byte `08` (example: 8085 `sub hl,bc`) |
| `; 38 00` | Two native bytes (example: 8085 `ld de,sp+0`; Intel name `ldsi` is compat-only) |
| `; 8E 23` | Multi-byte **inline expansion** (synthetic / multi-insn sequence emitted in place) |
| `; EB 73 EB` | Expansion using other real ops (example: 8085 `ld (de),l` via `ex de,hl` / `ld (hl),l` / `ex de,hl`) — **assembler OK**, not a one-byte `(de)` store |
| `; CD @__z80asm__sbc_hl_bc x` | **Not inline:** call to a z80asm **library helper** (`call` + relocatable symbol). Bigger/slower; only exists if that helper is linked |
| `; 10 FE` | Native Z80 `djnz` encoding on z80 (different CPU → different bytes for same mnemonic) |

**On `*_err.asm`:**

```text
exx                             ; Error
```

Means: with that `-m` CPU, this form is **illegal** — assembler must reject it. Do not emit it in sources for that CPU.

### How to query (do not bulk-read)

`*_err.asm` files are huge (tens of thousands of lines). **Never** read whole fixtures into context.

```bash
# Is this form accepted on 8085? What encoding?
rg -n 'sub hl, *bc|ld de,sp\+|ld \(de\),hl|exx' \
  src/z80asm/dev/cpu/cpu_test_8085_ok.asm \
  src/z80asm/dev/cpu/cpu_test_8085_err.asm

# Compare CPUs for one mnemonic
rg -n '^\s*mul de|^\s*mlt de' \
  src/z80asm/dev/cpu/cpu_test_z80_ok.asm \
  src/z80asm/dev/cpu/cpu_test_z80n_ok.asm \
  src/z80asm/dev/cpu/cpu_test_z180_ok.asm
```

Interpretation checklist:

1. **Only in `*_err.asm`** (for the mode you care about) → do not use.  
2. **Normal `*_ok.asm` + short hex** → native or allowed synthetic.  
3. **Normal `*_ok.asm` + `@__z80asm__…`** → helper `call`; usually avoid as the core of hand-written hot library code.  
4. **Strict `*_ok.asm`** → real ops / accepted aliases only; **no free synthetics**.  
5. **Strict `*_err.asm`** → includes many forms that **normal** mode still accepts (synthetics).  
6. **Same mnemonic, different CPUs** → encodings differ; check the file for **that** `-m`.  
7. **8080/8085 fixtures** may list **Intel** spellings for external-compat tests; **z88dk tree code uses Zilog only**.

### Worked examples (8085)

| Source form | Normal ok/err | Strict | Takeaway |
|-------------|---------|--------|----------|
| `sub hl,bc` | ok `; 08` | ok | Real extended op (Zilog — use this) |
| `sub hl,de` | ok via `@__z80asm__…` | (check fixture) | Helper, not one-chip op |
| `ld de,sp+0` | ok `; 38 00` | ok | Real extended (Zilog) |
| `ldsi 0` | ok `; 38 00` | ok | Same op, Intel name — compat only; write `ld de,sp+*` |
| `ld (de),hl` | ok `; D9` | ok | Real extended (Zilog) |
| `shlx` | ok `; D9` | ok | Intel name — do not emit in tree sources |
| `ld de,hl` (pair copy) | often ok as synthetic | **err** | Synthetic — forbidden in strict |
| `ld (de),l` | ok as expansion | **err** | Synthetic expansion — strict forbids; prefer `ld (de),hl` / `a` |
| `mov a,b` | ok (Intel) | ok | Assembler compat only — write `ld a,b` |
| `exx` | err | err | Not on 8085 |

### Decision order when unsure

1. Matching **cpu skill** (coding rules / house style).  
2. Neighbour sources under `libsrc/` for that CPU.  
3. **These fixtures** (`rg` only) to settle assembler accept/reject and encoding class.  
4. Optional: assemble a one-liner with `z88dk-z80asm -m<cpu> -l` and read the `.lis`.


## Condensed reference (from wiki / tree)

# Tool — z80asm (`z88dk-z80asm`)

**z80asm** is the z88dk relocatable macro assembler, linker, and librarian. It is not the same project as other tools named “z80asm” on the internet.

Normally you call it through **zcc**. Use the binary directly for pure asm projects, libraries, or debugging the link step.

## Quick start

```text
z88dk-z80asm file.asm
z88dk-z80asm -b file.o
z88dk-z80asm -xlibname.lib file1.o file2.o
z88dk-z80asm -h
```

Via zcc, assembler flags pass through **`-Ca`**.

## Capability summary

| Area | Support (this tree) |
|------|---------------------|
| CPUs | 8080/8085 (+ `_strict`), gbz80, z80/z80n, z180, ez80 / ez80_z80, Rabbit r2ka–r6k, r800, kc160 / kc160_z80 (see live `-m` list; `*` builds fat libraries) |
| Roles | assemble (`.asm`→`.o`), link (`-b`), library create (`-x`) / use (`-l`), incremental (`-d`) |
| Sections | multi-section binaries; `-split-bin`; section size symbols (historical changelog) |
| Floats in asm | `-float=` / `SETFLOAT` / `FLOAT` — genmath, math48, ieee16/32/64, z80, zx81, zx, z88, mbfs, mbf40, mbf64, am9511 |
| Synthetic opcodes | on by default; `-no-synth` disables |
| Preprocessor | MACRO, `#define`/`#undef`, `#ifdef` family, `file.asm.m4` + `-m4=`, `-raw-strings` |
| Labels | `.label` / `label:`; module-local `@label` (v2.4) |
| Appmake (direct) | `+zx`, `+zx81` only from the assembler help (full packaging is usually `zcc` / `z88dk-appmake`) |

## Subpages (detail)

| Page | Topic | Status |
|------|--------|--------|
| [command line](Tool---z80asm---command-line) | CLI flags | **verified** vs live `-h` |
| [directives](Tool---z80asm---directives) | ORG, SECTION, PHASE/DEPHASE, FLOAT, … | **verified** (includes `@labels`) |
| [preprocessor](Tool---z80asm---preprocessor) | `#define`, MACRO, ASSERT, IF | **verified** |
| [expressions](Tool---z80asm---expressions) | Operators, numbers, ASMPC | **verified** (2026-07-31 pass) |
| [environment](Tool---z80asm---environment) | `Z80ASM`, `ZCCCFG` | **verified** (2026-07-31 pass) |
| [input format](Tool---z80asm---input-format) | Source lines, labels, numbers | **verified** (2026-07-31 pass) |
| [old manual](Tool---z80asm---old-manual) | Historical prose | **imported** — keep for history; prefer verified pages |

When a subpage disagrees with **`z88dk-z80asm -h`** or `src/z80asm/`, the tool and source win.

… (full reference: in-tree wiki page and live tool help)


## Related

- Driver front end: `tool-zcc`
- Measurement: `methodology-measure`, `tool-ticks`
- Per-CPU coding skills: `cpu-8085`, `cpu-z80`, `cpu-z80n`, `cpu-z180`, `cpu-8080`, `cpu-gbz80` (capability authority remains `src/z80asm/dev/cpu/`)
