---
name: tool-copt
description: >
  z88dk-copt text peephole optimiser: rule files lib/z80rules.*, what zcc applies
  by -O, and required hand-asm finalisation (library never runs copt). Use when
  writing sccz80 rules, reviewing compiler dumps, or cleaning library asm.
---

# Tool — copt (`z88dk-copt`)

Source: `src/copt/`. Man: `src/copt/copt.1`, `doc/copt.man`. Wiki: `wiki/tools/Tool---copt.md`.

## Peephole rules and codegen hygiene

`z88dk-copt` is z88dk’s **text peephole optimiser**: it reads assembly on
**stdin**, applies pattern → replacement rules from named files, and writes
improved assembly on **stdout**. `zcc` runs it on **compiler-generated** output
(sccz80 `.opt` / similar), not on hand-written library sources.

Source and man page: `src/copt/copt.c`, `src/copt/copt.1`. Rule files live under
`lib/z80rules.*` (plus target/CPU/user extras).

### What agents must remember when writing library asm

| Fact | Consequence |
|------|-------------|
| **Library `.asm` under `libsrc/` is assembled directly** | copt **never** runs on it in the normal build |
| **Dead moves stay dead** | Write clean sequences yourself (`ld b,a` then `ld a,b` is never cleaned up later) |
| **Whitespace is not a style war** | Match the **target file**: tabs vs spaces, column layout, comment style. Most classic `libsrc/l/sccz80/**` and math32 cores use **spaces** (often four-space indent). copt rule files and sccz80 dumps use **tabs** — that is only for matching those pipelines |
| **copt matches whole lines (mostly literal)** | Trailing comments, different spacing, or a space-indented library line will not match a tab rule. That is irrelevant when editing library sources in their native style |

Do **not** reformat a library file to “look like copt input”. Follow neighbours
in the same file. Do **do** apply the *semantic* lessons of the rules (remove
redundancies copt would drop on compiler output).

### How a rule is written

```text
	<pattern line 1>
	<pattern line 2>
	...
=
	<replacement line 1>
	...

```

- Blank line ends the rule. Lines starting with `;;` (column 0) are comments in
  the rule file.
- **`%1`…`%9`** — wildcards; same index must bind the same text within one fire.
- **`%%`** — literal `%`.
- **`%eval(...)`**, **`%check min <= %n <= max`**, **`%is` / `%not`**,
  **`%notSame`**, **`%cpu` / `%notcpu`** — preconditions (evaluated after binds).
- **`%title ...`** — label for debug; does not match source.
- **`%L` / `%M` / `%N`** in replacements — unique labels.
- **`%activate` / `%once`** — dynamic rule activation (advanced; see man page).

Matching walks the input **in reverse** along each candidate window so shorter
cascades can fire after a replacement without backing up far. Multiple passes
run until quiet (capped).

### CLI (manual experiments)

```bash
# Rules as argv; source on stdin. -m sets %cpu checks; -D prints firings.
z88dk-copt -m8085 [-D] lib/z80rules.9 lib/z80rules.2 lib/z80rules.1 \
  lib/z80rules.0 [lib/z80rules.8] < input.asm > output.asm
```

Expect **no change** if you feed space-indented, commented library asm into
rules written for sccz80 tab style — that is expected, not a broken tool.

### Which rule files `zcc` applies (classic sccz80 path)

Configured via `COPTEXE` / `COPTRULES*` (defaults in `src/zcc/zcc.c`):

| Peephole `-O` | Rule set (order matters) |
|--------------:|--------------------------|
| 0 | `z80rules.9` |
| 1 | `.9` + `.1` |
| 2 (common default in target `OPTIONS`) | `.9` + `.2` + `.1` |
| 3+ | `.9` + `.2` + `.1` + `.0` |

Also, when present:

| Config | Role |
|--------|------|
| `COPTRULESINLINE` → `z80rules.8` | sccz80 **inline ints** path only (`c_sccz80_inline_ints`); otherwise not loaded |
| `COPTRULESTARGET` | Target-specific (e.g. z88) |
| CPU map rules | CPU-specific if the file exists |
| `-custom-copt-rules=` | User file |

Other compilers have their own sets (`lib/sdcc/…`, `80cc_rules.1`,
`clang_rules.1`, …). This section is about the classic **z80rules.*** family.

Rough file roles:

| File | Role |
|------|------|
| `z80rules.9` | Intrinsics / RST-style substitutions (always first among the numbered set) |
| `z80rules.2` | Aggressive / higher-O peepholes (includes dead re-load into same dest) |
| `z80rules.1` | Large main sccz80 peephole set |
| `z80rules.0` | Extra / lower-priority patterns (linked as `COPTRULES3`) |
| `z80rules.8` | Inline common sccz80 helpers **and** a few general cleanups |
| `z80rules.frame` | Tiny frame-related snippet (not the main pipeline by itself) |

### Rules that matter for register hygiene (codegen lessons)

These teach what **not** to emit in hand-written cores either.

**Copy-back is a no-op** (`z80rules.8` — only if that file is loaded):

```asm
	ld	%1,%2
	ld	%2,%1
=
	ld	%1,%2
```

Example: `ld b,a` / `ld a,b` → keep only `ld b,a`. On 8085/8080/gbz80 long-div
prologue this is exactly the redundant high-byte re-load after building BC.

**Register-specific variant** already in `z80rules.0` (always available at `-O3+`):

```asm
	ld	l,a
	ld	a,l
=
	ld	l,a
```

Only **L↔A**, not a general B/C/D/E/H rule — so do not assume every copy-back is
stripped unless `.8` is active or you remove it by hand.

**Dead second load into the same destination** (`z80rules.2`):

```asm
	ld	%1,%2
	ld	%1,%3
=
	ld	%1,%3
```

**Implication for new code:** after `ld r,a` (or any `ld dst,src`), if the next
instruction only reloads `src` from `dst` so you can `or` / test the original,
**drop the reload** — `A` (or the source) still holds the value. Same for any
symmetric copy-back. copt may clean that on sccz80 output; **library authors
must**.

### Using copt knowledge while generating or reviewing code

1. **Hand-written `libsrc/**`**: write the optimised form yourself; match file
   whitespace/comments; never rely on a later copt pass.
2. **Compiler dumps / `.opt` / `.asm` from `zcc`**: expect copt to have already
   run; remaining slop is either not covered by rules, blocked by comments/labels
   between instructions, or needs a new rule / better frontend codegen.
3. **Proposing new copt rules**: put them in the right file for the intended `-O`
   level; use tab + sccz80 operand style so they match compiler output; add
   `%cpu` / `%notcpu` when a pattern is unsafe on 8080/8085/gbz80.
4. **Experimentation**: normalise a snippet to tab style **only in a temp file**
   if you want to see whether existing rules fire; do not commit that reformat
   into library sources that use spaces.
5. **A/B of “copt would fix this”**: if a library bug is a pure redundancy the
   rules already express, the fix is a one-line delete in the library — same
   binary effect as copt on compiler text, without depending on rule load order.

### Before finalising hand-coded library work (required)

Hand-written **math16 / math32 / sccz80 runtime** asm is **not** passed through
`z88dk-copt`. Before calling an edit done (and before staging / TIMER publish):

1. **Scan** the touched hand sources for **copt-equivalent** idioms (semantic
   matches to `lib/z80rules.{0,1,2,8}`, not mechanical tab reformatting).
2. **Apply** safe cleanups in the library file itself. Typical wins:

| Smell | Prefer |
|-------|--------|
| `ld r,a` then `ld a,r` (copy-back) | Drop second insn (`z80rules.8` / `.0`) |
| `add a,a` / `rla` then `ld e,a` then **`ld a,e`** before next shift/test | Drop `ld a,e` — **A** still holds the value |
| `ld b,a` then `ld a,b` when A unchanged | Drop `ld a,b` |
| `push de` / `pop hl` (DE→HL, DE dead) | `ex de,hl` (or `ld h,d` / `ld l,e` if DE must live) |
| `push hl` / `pop bc` (HL→BC) | synthetic **`ld bc,hl`** |
| Triple unstack ending `push hl` / `pop bc` / `pop de` / `pop hl` | `ld bc,hl` then two pops |
| `ld h,0` / `ld l,0` (and DE/BC pairs) | `ld hl,0` / `ld de,0` / `ld bc,0` |
| Dead second `ld` into same dest | Keep only the last load (`z80rules.2`) |

3. **Do not** blindly apply `ld a,0` → `xor a`: `ld` **preserves** flags; `xor a`
   **clears C**. Unsafe before `sbc` / `rla` / `rra` that need the prior carry
   (common in float sign / multiprecision negate paths).
4. **Skip** intentional stack peeks (`pop de` / `push de`) and real callee
   argument pushes — those are not dead transfers.
5. **Gate**: suite / probe on the CPUs that link the objects (e.g.
   `test_math32_8085.bin` after 8085 math32 edits).

Ignore sccz80/sdcc **generated** dumps under `c/asm/` for this scan; fix or
regenerate those only via the C sources / rebuild pipeline.

#

## Related

- `compiler-sccz80`, `methodology-measure`, `style-libsrc-layout`
