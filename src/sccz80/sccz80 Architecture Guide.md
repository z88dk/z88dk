# sccz80 architecture guide

This is the architecture of sccz80 after the C90 work. It is the model to keep.
Later work maintains this model. It does not add a pass, a frame pointer, or a
second declaration grammar.

sccz80 reads C and writes assembly for several 8-bit CPUs. It has no
intermediate representation and no register allocator. `z88dk-copt` rewrites
the assembly after sccz80 has finished.

Read this before a change. Stack depth, CPU legality, and the call conventions
constrain every edit.

---

## 1. Where sccz80 sits

z88dk is a toolchain, not a compiler. A build runs a chain of separate executables,
each a standalone program, driven by `zcc`:

```
 source.c
    |
    v
 zcc                driver: picks CPU, target config, compiler, rule set, libs
    |
    v
 sccz80 (or 80cc / zsdcc)    C -> z80-family assembly text
    |
    v
 z88dk-copt         peephole text optimiser, driven by rules files
    |
    v
 z88dk-z80asm       assembler + linker, emits the final image
```

Consequences:

* **sccz80 contains no peephole optimiser.** Grep for `peep` or `rules` across
  `src/sccz80/*.c` and there are no hits. Every pattern-based optimisation is
  applied by `z88dk-copt` to the emitted text, using rule files under `lib/`.
  Optimisation work therefore splits cleanly into "emit better instruction
  sequences" (sccz80) and "recognise sequences after the fact" (copt rules).
* **sccz80 never links and never knows a target.** It knows a *CPU*, a handful of
  code-model flags, and where to write assembly. Memory maps, CRT, and libraries
  belong to `zcc` and `lib/`.
* **Three compilers share the back end.** `sccz80` (this one), `80cc` (IR based,
  `src/80cc/`), and `zsdcc` (patched SDCC). They are independent front ends, but
  they share `z88dk-copt` rule files, `z88dk-z80asm`, the library set, and the
  call/return conventions of the target libraries. Any convention change in
  sccz80 codegen is a cross-compiler, cross-library change.

---

## 2. Size and shape of the tree

20,347 lines in 27 files. 21 of those files are C. The counts are the sources
beside this guide, after the C90 declaration work. `codegen.c` is the largest
file. It emits the instructions.

| file | lines | role |
|---|---:|---|
| `codegen.c` | 6,224 | instruction emission |
| `declparse.c` | 2,645 | declarations and specifiers |
| `const.c` | 1,459 | literals, `sizeof`, folding |
| `plunge.c` | 1,441 | binary expressions |
| `primary.c` | 1,093 | primaries |
| `main.c` | 1,085 | options, CPU, driver |
| `expr.c` | 1,003 | expression precedence |
| `stmt.c` | 982 | statements |
| `callfunc.c` | 595 | call arguments |
| `declinit.c` | 591 | initialisers |
| `io.c` | 372 | character source |
| `cdbfile.c` | 368 | debug records |
| `preproc.c` | 363 | directives left after ucpp |
| `goto.c` | 226 | goto and labels |
| `error.c` | 201 | diagnostics |
| `lex.c` | 152 | scanner |
| `sym.c` | 141 | symbol table |
| `data.c` | 126 | data and bss |
| `cpp_invoke.c` | 94 | spawn `z88dk-ucpp` |
| `misc.c` | 76 | small helpers |
| `while.c` | 38 | loop helper |
| headers | 1,072 | `define.h` 500, `ccdefs.h` 373, `data.h` 80, `codegen.h` 63, `io.h` 48, `misc.h` 8 |

---

## 3. Front end: how C becomes a call into codegen

The front end is a single-pass recursive-descent parser with no intermediate
representation. It parses a construct and, as it goes, emits assembly. There is no
tree, no per-function IR, and no separate optimisation stage on the C side.

Flow for one translation unit:

1. **`cpp_invoke.c`** starts `z88dk-ucpp` on a direct compile. `--c1mode` reads
   the file as given. zcc passes `--c1mode` after its own ucpp run, on a normal
   sccz80 compile and on the sccz80 half of `-compiler=multi`. `-D`, `-U` and
   `-I` are forwarded. `Z80` and `SMALL_C` are predefined for the preprocessor
   and for the compiler's own conditionals.
2. **`io.c`** owns the character source after that. A comment that still reaches
   the lexer is reported as requiring the external preprocessor.
3. **`preproc.c`** handles the directives that remain: `#pragma`, `#undef`,
   `#ifdef` / `#ifndef` / `#else` / `#endif`, and `#` line markers.
4. **`lex.c`** produces tokens: identifiers, numbers, strings, punctuators. It is
   deliberately thin; most language knowledge lives in the parser.
5. **`declparse.c`** reads one declaration. Storage class, qualifiers, and
   type specifiers may stand in any C90 order. The rules are under
   Declaration specifiers below. `declinit.c` writes initialisers as data.
6. **`stmt.c`** dispatches statements. Each statement form immediately calls into
   codegen for its control flow, using labels allocated from a global counter.
7. **`expr.c`** holds the expression grammar as a precedence chain of mutually
   recursive functions — `heir1`, `heir1a`, `heir2`…`heir9`, `heira`, `heirb` —
   plus the integer promotion and conditional-join helpers
   (`arith_integer`, `integer_reg_width`, `widen_primary_to`, `retag_conditional`,
   `join_conditional`). Every binary operator ends up either folded at compile time
   (`const.c`) or emitted as a `binop` function pointer stored in the lvalue.
8. **`primary.c`** produces the leaves: identifiers, literals, and the operands a
   call needs.

The parser's state is the only state. No whole expression or function exists as
a data structure that a later pass could reorder. A choice is made when the
parser sees the construct, or it is lost.

### Declaration specifiers

`parse_type` in `declparse.c` reads one declaration. Storage class, type
qualifiers, and type specifiers may stand in any C90 order. One `DeclSpecs`
holds that declaration.

`storage` starts at -1. The caller then keeps its default storage.
`ataddress` starts at -1. `permit_storage` is set for a real declaration.
A nested declarator clears it, so a storage class there is an error.
`allow_at` allows `__at`. `banked` records one leading `__banked`.
`consumed` means a bad statement was diagnosed and skipped.

Before the type word, and in any order, the reader accepts these words.

- `const` and `volatile`. They set `isconst` and `isvolatile`.
- `extern`, `static`, and `typedef`. C90 allows one storage class. A second
  class is an error. The first class is kept.
- `auto` and `register`. In this position they are storage. After the type
  word the same spellings are names.
- An address-space name.
- One `__banked`.
- `__at(constant)` when `allow_at` is set.
- A function modifier in the wrong place. The compiler reports it and
  consumes it.

`__critical` is not in that modifier list. A block `__critical` is a statement
in `stmt.c`. On a function, `__critical` is a trailing attribute, in the same
place as `__z88dk_fastcall`, `__z88dk_callee`, and `__naked`. A leading
`__critical` at file scope is not a modifier. The compiler keeps the
missing-token diagnostic.

The integer words are `signed`, `unsigned`, `char`, `short`, `int`, and
`long`. They may mix with `const`, `volatile`, and the storage class.
`char` is 8 bits. One `long` is 32 bits. Two `long` words are 64 bits.
Any other word in this group is a 16-bit `int`. `short` is in that group.
`short` and `long` do not combine. A sign word alone does not finish the type.
`float`, a typedef, or `_Accum` can still apply. `int _Accum` and
`short _Accum` are 16 bits. One `long` and then `_Accum` is 32 bits.
`long double` is not a type. The leftover `double` stays a name.

`end_specs` still accepts `const` and `volatile` after the type word.
`static int const x` sets `isconst`. The object goes in `rodata_compiler`,
the same place as a leading `const`.

`__sfr` is an 8-bit port. `__sfr __banked` is a 16-bit port. `__at` supplies
the address. Words after the address are the cell type, not the port name.
The reader discards `const`, `volatile`, `unsigned`, `signed`, `char`,
`short`, `int`, and `long` there. `unsigned __sfr` keeps that order.
`__sfr __at` and then `__banked` also keeps the old order.

`enum`, `struct`, and `union` also keep a trailing qualifier on this
declaration.

`T = ...` is an error when `T` is a typedef. The diagnostic is
`Typedef '%s' is not a variable`. The skip stops at a semicolon that is not
inside quotes. A `}` that this skip did not open stays for the statement
parser. A bare `T;` emits nothing.

`dodeclare` uses the storage class from `DeclSpecs` when one was seen.
`declare_local` is the same reader inside a block.

---

## 4. Core data model

Four types carry the compiler. All are plain C structs, allocated from the parser's
own pools.

### `Kind` — the value type lattice

`KIND_VOID`, `KIND_CHAR`, `KIND_SHORT`, `KIND_INT`, `KIND_LONG`, `KIND_LONGLONG`,
`KIND_FLOAT`, `KIND_DOUBLE`, `KIND_FLOAT16`, `KIND_ACCUM16`, `KIND_ACCUM32`,
`KIND_ARRAY`, `KIND_PTR`, `KIND_CPTR`, `KIND_STRUCT`, `KIND_FUNC`, `KIND_ELLIPSES`,
`KIND_PORT8`, `KIND_PORT16`, `KIND_ENUM`, `KIND_CARRY`.

Classification is by predicate macro, never by arithmetic on the enum:
`kind_is_integer`, `kind_is_floating`, `kind_is_fixed`, `kind_is_decimal`. The
codegen ladder is ordered by width and kind; conversions walk that ladder.

Two generations of code live here and both are live: older code handles
`char`/`int`/`long` plus the `CONVERT_*` constant ladder in `codegen.c`; newer code
handles `long long`, the fixed-point accumulators, and float16 through
`zconvert_to_decimal` / `zconvert_from_decimal` /
`zconvert_stacked_to_decimal`. When reviewing conversions, check which generation a
given operator takes — mixing them is where width bugs have historically come from.

### `Type` — structure and size

Base `Kind`, byte `size`, signedness (`isunsigned`, `explicitly_signed`), qualifiers
(`const`, `volatile`), `isfar` for far pointers, name and namespace, `ptr`/`len` for
pointers and arrays, `value` for enums and short-call values, bitfield
`bit_offset`/`bit_size`, struct `tag`/`fields`/`offset`, and a function block with
`return_type`, `parameters`, and a `flags` word carrying calling-convention details
(fast call, short call, register args, `stdcall`, `z88dk_fastcall`, etc.).

### `SYMBOL` — storage

Linked per scope, with a `Kind`-typed value, a `Type`, a storage class (`auto`,
`static`, `extern`, `register`, parameter, global), an offset (`loc`/`offset`), a
namespace pointer, and flags. `NAMESIZE` bounds identifiers. Local variables are
stack slots. The offset is stored on the symbol and in the `loctab` array
(`NUMLOC` = 512 entries); `getloc` loads that offset, adjusted by `Zsp`, into
`HL` and adds `SP`. Exceeding `NUMLOC` is a hard error, not a fallback.

### `LVALUE` — the compiler's working register

This is the single most important structure in the compiler and the one reviews
should understand first. An `LVALUE` is simultaneously:

* the operand being computed — `symbol`, `ltype`, `val_type`, `offset`,
  `indirect_kind`, `ptr_type`, `is_const` / `const_val` / `int_const_val`;
* the *pending operation* — `binop`, a function pointer to the operator that should
  be emitted once both operands exist;
* a *deferred store* — `stage_add` and `stage_add_ltype` hold the address of a
  store whose value is not yet known, so that `x = a + b` can emit an
  inc/dec or in-place update instead of load/add/store.

That last field is how sccz80 does its only intra-expression optimisation. When an
expression turns out to be a dead-end constant or a simple update of memory, the
deferred store is either materialised or dropped. `expr.c` clears `stage_add` and
`binop` at roughly a dozen points; every one of those is a correctness boundary.

---

## 5. The code generation model

sccz80 targets a **small virtual machine** rather than a register allocator. This is
the principle that most determines what changes are cheap and what are not.

### Registers

* **Primary**: `HL` for 16-bit, `L`/`A` for 8-bit values. Holds the value just
  computed, or the low half of it.
* **Secondary**: `DE`. Holds the left operand of a binary operation while the right
  operand is being computed. `DE` and `HL` are swapped with `ex de,hl` when the
  order matters.
* **Spill**: the machine stack. Anything wider than 16 bits, anything needing three
  live operands, and all saved intermediate state goes to the stack in a defined
  order, low word first.
* **Accumulator**: `A`, used only for byte-sized results and comparisons.

`sccz80` has no register allocator and no live-range analysis. A function's local
frame is fixed at entry and addressed from `SP`, and every expression is
evaluated by pushing its left operand and folding into the right. There is no
index-register frame. `-frameix` and `-frameiy` are not options.

### Virtual stack pointer `Zsp`

`Zsp` is the compiler's model of the stack depth, in bytes, relative to a fixed
reference. It is *not* the CPU's `SP`. Every emission that changes stack depth must
maintain it in lockstep with the real stack, and `modstk(newsp, save, saveaf,
usebc)` is the only correct way to move between two depths: it computes the delta,
picks the cheapest legal instruction sequence for that delta and CPU (including
`pop`-based skips, `add sp,N` on CPUs that have it, and `inc sp`/`dec sp` chains),
and returns the new depth so the caller can update `Zsp`.

**Invariant:** after any codegen call returns, the emitted code must leave the real
stack at `Zsp` and `Zsp` must equal what the code left. A mismatch does not
necessarily fail immediately; it corrupts a later call or a return, which is why
stack-depth bugs surface far from their cause.

### Operating primitives

All binary operations follow the same shape, which is the heart of the architecture:

```
  <compute left>            -> primary
  push                      -> stack, Zsp += 2 (or 1..4 by width)
  <compute right>           -> primary
  pop into secondary        -> DE (or A/B, or stack for wide types)
  <emit op on pairing>
```

`putstk`/`puttos`/`put2tos` push the primary; `zpop`/`lpush`/`llpush`/`zpush` push
whole objects by `Kind`; `immed`/`immedlit` push an immediate; `getloc` loads a
local; `modstk` fixes depth. Everything else is a `Kind`-specialised operator:
separate code paths for 8-bit, 16-bit, 32-bit and 64-bit, for signed and unsigned,
and for the special cases (byte multiply, shifts by constant versus variable,
comparison to zero, and the fixed/floating ladder).

The practical rule a reviewer should apply: **an optimisation is cheap when it
removes emission inside one of these sequences, and expensive when it requires a
new kind of state**. Adding a live-range or choosing between two instruction
sequences with the same semantics is cheap (both operands already exist in known
places). Deferring a store across a call, reordering side effects, or keeping a
third value live outside the stack is expensive and usually illegal.

### lvalues, rvalues, and `stage_add`

`getloc` and friends compute an address. Whether that address is then (a) loaded
into the primary for an rvalue use or (b) held as a pending store address is what
`stage_add` records. `x++`, `x += n`, and `arr[i] = v` can all avoid the general
load/modify/store path when the store is provably the only consumer. This is
narrow by design: it is applied where the parser knows the result is discarded.

### Per-Kind operator surface

For each `Kind` width the compiler carries, as separate functions:
load, store, push, pop, convert up, convert down, add, subtract, multiply, divide,
modulo, and, or, xor, shift left, shift right, compare, negate, complement,
increment, decrement. Multipliers and dividers are not inline — divides and wide
multiplies call library routines (`l_asr`, `l_asr_u`, `l_mult`, …) chosen by width
and signedness.

---

## 6. Multi-CPU architecture

This is the part reviews most often underestimate. There is **one** code generator,
parameterised at a coarse granularity. It is a compile-time-constant bitmask plus
scattered conditional emission — not a backend abstraction layer.

### CPU identity

`c_cpu` is a bitmask of `CPU_*` values in `define.h`:

```
CPU_Z80 1, CPU_Z180 2, CPU_R2KA 4, CPU_R3K 8, CPU_Z80N 16, CPU_8080 32,
CPU_8085 64, CPU_GBZ80 128, CPU_EZ80_Z80 256, CPU_R4K 512, CPU_R6K 1024,
CPU_KC160 2048, CPU_KR580VM1 4096, CPU_R800 8192
CPU_RABBIT = R2KA|R3K|R4K|R6K
```

Note the shape: most CPUs are distinct bits (set one at a time), while Rabbit is a
*set*, because four Rabbit variants share codegen treatment. Predicates are macros
over that mask — `IS_8080()`, `IS_8085()`, `IS_808x()`, `IS_8080_CLASS()`,
`IS_GBZ80()`, `IS_Z80N()`, `IS_EZ80()`, `IS_KC160()`, `IS_R800()`,
`IS_KR580VM1()`, `CPU_POP_AF_IS_SAFE()`. Some of these exist for instruction
legality (`POP AF` is wrong on KR580VM1), some for cost (`add sp,N` exists on
Z180/Rabbit but not Z80), some for availability (no `IX` on 8080/8085).

### Where CPU knowledge is expressed

Three layers, deliberately separated:

**Layer 1 — instruction selection in `codegen.c`.** The CPU choices sit in this
file. Each one asks whether this CPU has the short form, and otherwise emits a
form the weaker CPU can run. Examples are `modstk` choosing `add sp,N`, a
`pop` skip, or an `inc sp` chain, `POP AF` substitution, and `LDIR`/`LDDR`
versus a byte loop. An 8085 sequence is used only where that CPU has the
instruction. Every fallback must be legal on the weakest CPU of the class.
The 8080 path has no undocumented opcode and no Z80-only instruction.

**Layer 2 — peephole rules per architecture.** `lib/arch/<cpu>/<cpu>_rules.1`.
The files that contain rules are `8085`, `gbz80`, `kc160`, `r800`, `rabbit`,
`z180`, and `ez80`. z80n loads `lib/arch/z80n/z80n_intrinsic` (nextreg and MMU).
`lib/arch/z80n/z80n_peephole` is the testsuite custom file. `z80`, `8080`, and
`vm1` are comment-only placeholders. `z80`, `z80_ixiy`, and `z80_strict` share
`lib/arch/z80/z80_rules.1`. copt leaves a comment-only file unchanged. zcc
warns when a named rules file is missing. The rules run *after* sccz80 has
finished, so they can exploit instruction sequences the compiler emitted
generically.

**Layer 3 — libraries and CRT per architecture.** `lib/arch/<cpu>/` and the
`libsrc/` build produce a separate pre-built library set per CPU. `zcc`'s
`cpu_map[]` table is the single place all three layers are wired together.

### The wiring table

`src/zcc/zcc.c` `cpu_map[CPU_TYPE_SIZE]` maps each CPU to a tuple:

```
{ z80asm flag, sccz80 flag, zsdcc flag, copt index, cpu rules file, lib suffix, sdcc triple }
```

That table is the authoritative statement of "what this CPU means to this
toolchain". Notably it records asymmetries that are real constraints, not
oversights — for instance zsdcc has no 8080 or 8085 port (`NULL` in the triple
slot), R800 objects stay z80-stamped so unmodified z80/MSX libraries link, and
KC160 is built through the z180 triple.

**Consequence for reviews:** there is no cheap way to add a CPU-specific
improvement. It lands in `codegen.c` behind a predicate, needs a fallback that is
legal on the neighbouring CPU class, and usually needs a matching rule-file or
`cpu_map` entry. Claiming an optimisation "for 8085" without showing the legal
fallback path is incomplete.

---

## 7. Peephole optimisation: copt

`z88dk-copt` is Christopher Fraser's peephole optimiser (`src/copt/copt.c`,
"copt version 1.00 (C) Copyright Christopher W. Fraser 1984"), extended with
variable substitution, regexp matching, `%activate`, and `%check`. It is a text
rewriter: pattern on the left, `=` separator, replacement on the right, applied to
a window of assembly lines until no rule fires or `MAX_PASS` (16) is reached.

### Rule language, in brief

* `%0` … `%9` are metavariables bound by the pattern and substituted in the
  replacement.
* `%eval(expr)` evaluates an RPN expression over bound values at rewrite time —
  this is how arithmetic on constants is folded (`%eval(%0 256 %%)` computes
  `%0 mod 256`).
* `%check` accepts or rejects a match on a condition; `%activate` enables a rule
  only in a context. The engine also carries named operators and a
  compiler-identity field, so a rule can be declared sound for one front end and
  not another.
* Rules are order-sensitive: the list order is the application order, and later
  files see the output of earlier ones.

### The chain sccz80 actually gets

From `fill_sccz80_copt_rules()`:

```
lib/z88dk_intrinsic                  always   (intrinsics and RST substitution)
  -O 0:  (nothing)
  -O 1:  lib/sccz80_rules.1
  -O 2:  lib/sccz80_rules.2, lib/sccz80_rules.1
  -O 3+: lib/sccz80_rules.2, lib/sccz80_rules.1, lib/sccz80_rules.3
  target rules        (from the target's config)
  cpu rules           (from cpu_map[], e.g. lib/arch/8085/8085_rules.1)
  lib/sccz80_inline                     (sccz80 op inlining, via -Ch)
  user rules
```

`sccz80_rules.1` is the main set. It runs at `-O 1`, and after `sccz80_rules.2`
at `-O 2` and `-O 3`. `ld a,0` becomes `xor a` in this file. A zero that must
survive that rewrite is written `ld a,0 ;carry`.

`sccz80_rules.2` runs first at `-O 2` and above. It folds
`ld hl,0 ;const` / `ld a,0 ;carry` / `rla` / `ld l,a` into the carry shift and
`ld h,0`. The `;carry` comment keeps the following `xor a` rule from matching.

`sccz80_rules.3` runs last, and only from `-O 3`. On 8085,
`ld hl,N ;const` / `add hl,sp` / `call l_gint` becomes `call l_gintNsp` for N
of 2, 3, 4, 5, 6 and 8. The general form becomes `call l_gintsp` on every other
CPU, vm1 included. The char and long stack folds still exclude vm1 and 8085.

A line that begins with `;` is a pattern. A banner begins with `;;`, so copt
does not treat it as a rule. A `;` later on an instruction is part of the match.
That is why `;const` and `;carry` stay on the lines above.

`-O` is the peephole level; `--opt-code-speed` is a different axis entirely and
lives in the compiler, not in copt. `80cc` uses a different chain
(`z88dk_intrinsic`, then `80cc_rules.1`, then target/cpu/user), which is why a rule that
helps one front end can be wrong for the other.

### What this means for review

* A missing optimisation may be a compiler issue **or** a rules-file issue. Check
  both before proposing a change; the cheap fix is usually a rule.
* A rules-file change is invisible to sccz80's own test suite unless the tests run
  the full `zcc` pipeline.
* Rules must remain correct under every `-O` level and every CPU whose chain
  includes them. A rule in `sccz80_rules.1` runs on 8080 too.
* Anything that changes emitted text must keep **`-O 0` output byte-identical**
  after the assembly suite drops `^;` lines. `;	Module compile time:` is one of
  those comments, printed from `ctime` in `gen_file_header`. The project treats
  the remaining peephole-off stream as a hard gate: it is the compiler's
  observable baseline, and regressions there invalidate every downstream
  comparison.

---

## 8. Optimisation inside the compiler

`sccz80` has one optimisation knob of its own, `c_speed_optimisation`, a bitmask of
`OPT_*` flags set by `--opt-code-speed` and by per-feature options:

```
OPT_LSHIFT32, OPT_RSHIFT32, OPT_ADD32, OPT_SUB16, OPT_SUB32,
OPT_INT_COMPARE, OPT_LONG_COMPARE, OPT_UCHAR_MULT, OPT_DOUBLE_CONST,
OPT_CHAR_COMPARE
```

The default is `OPT_RSHIFT32 | OPT_LSHIFT32`. Each flag enables a *longer* but
faster instruction sequence for one operator class — for example a straight-line
32-bit shift instead of a library call, or a hardware byte multiply where the CPU
has one. They are speed-for-size trades by construction, which is why they are
individually selectable and off by default.

This is the correct place to put "same semantics, faster sequence" work: the flags
are already plumbed through, and each one is a bounded change with an obvious
opt-out for reviewers who want the old size behaviour.

Beyond that, the only optimisation sccz80 performs is the `stage_add` deferred
store (§5) and constant folding in `const.c`. There is no common subexpression
elimination, no loop optimisation, no strength reduction, and no inlining. That is
the design, not an omission to be corrected.

---

## 9. Invariants

These hold the compiler together. A change that violates one is not a local fix.

1. **Stack discipline.** `Zsp` equals real stack depth after every codegen return,
   across every `Kind` and every CPU. Wide types are pushed low-word-first.
2. **Call/return conventions are shared.** Arguments go on the stack in the order
   the libraries expect, with the special forms (`fastcall` in registers,
   `shortcall` via `RST`, `stdcall`, register-specified args) preserved exactly.
   Changing one changes the ABI for sccz80, 80cc, zsdcc and the prebuilt libraries
   simultaneously.
3. **8080-class legality.** Code reachable on 8080/8085/VM1 uses no Z80-only
   instruction. `CPU_POP_AF_IS_SAFE()` and friends exist to encode this; new
   instruction choices need the legality question answered explicitly.
4. **Byte-identical `-O 0`.** The peephole-off assembly stream is the baseline.
5. **Kind conversions are total.** Every conversion has a defined result for every
   source kind, width and signedness, including the wide, fixed-point and float16
   paths, and including the narrowing directions.
6. **Constant folding agrees with runtime codegen.** `const.c` and the runtime
   paths must produce the same values; a fix to one without the other is a latent
   divergence that shows up only when a constant happens to be foldable.
7. **Diagnostics are non-fatal where the standard says so.** Errors accumulate and
   are reported; the compiler does not abort mid-function.

---

## 10. Where the risk concentrates

These are the places a change is most likely to go wrong.

* **`codegen.c` at 6,224 lines.** It is the largest file, and it is where
  instruction legality lives. A wrong or missing CPU predicate here is the
  usual shape of a codegen bug.
* **Parallel operator implementations.** For each width there are near-duplicate
  add/sub/mul/div/shift/compare paths with different staging. A fix applied to the
  16-bit path and not the 8-bit or 32-bit path is the single most common shape of
  regression, and it fails silently by producing a plausible wrong value.
* **The `LVALUE` deferred store and `binop` field.** Correctness depends on every
  parse path clearing or materialising pending state at the right moment. This is
  where the narrow-type and comparison bugs of recent history lived.
* **Two conversion generations.** `CONVERT_*` ladders and the newer
  `zconvert_*` functions coexist for different kinds. A conversion request that
  reaches the wrong generation takes a path that was never tested for it.
* **Rules files versus compiler output.** A rules change can repair or break
  codegen invisibly. Reviewing one without the other gives a false picture.
* **Library boundary.** Divides, wide multiplies and floating point call into
  prebuilt libraries whose behaviour for extreme operands is not part of the
  compiler's own tests.
* **`declparse.c`.** The declaration grammar is the C90 specifier reader in
  section 3. Do not put the storage class back in front of the type as a
  required order.

---

## 11. What "good" looks like for this compiler

The design targets are unusual and should be the yardstick for every proposal.

* **Code density first.** The product is 8-bit code loaded from cassette, ROM, or
  a disk image. A 4-byte saving across a program matters more than a cycle.
* **Ticks second.** On real hardware a wrong instruction choice is measurable; the
  project verifies against cycle-accurate emulation and per-CPU instruction cost.
* **Correctness over speed of compilation.** sccz80 is single-pass and fast; nobody
  is asking it to be faster if the price is any of the above.
* **Portability without abstraction tax.** One code generator, predicates at the
  point of emission, no virtual backend. The cost is conditional density; the
  benefit is that every CPU improvement is visible in one file.
* **The compiler emits honest generic code and lets copt specialise.** Anything
  that makes sccz80 itself emit CPU-specialised sequences must justify why a rule
  cannot do it.

A recommendation is in the spirit of this design when it makes an existing sequence
shorter, a predicate more precise, a duplicated path shared, or a dead path gone —
with no new global state, no new pass, and no change to the ABI.

---

## 12. The model to keep

These choices are the compiler. A later change keeps them.

1. One code generator. No intermediate representation. No register allocator.
   Locals are stack slots from `SP`. There is no IX or IY frame. `-frameix`
   and `-frameiy` are not options. `__z88dk_saveframe` saves the caller's IX.
   It is not a frame for locals.
2. A function that returns a struct returns a pointer in `HL`. The compiler
   warns and converts the return type. There is no hidden result pointer.
   An automatic assignment of two struct objects copies the bytes. A file-scope
   initialiser from a returned struct is not that copy.
3. Declaration specifiers follow section 3. Storage, qualifiers, and the type
   words may stand in any C90 order. One storage class is allowed. A second
   class is an error, and the first class is kept.
4. `__critical` is a statement and a trailing function attribute. It is not a
   type specifier. A block calls `l_push_di` and then `l_pop_ei`. Rabbit uses
   `ipset 3` and `ipres`.
5. A fastcall argument stays in the registers. The caller does not push it.
   It is not part of the stack cleanup count. A `__z88dk_callee` function pops
   the stacked arguments. The caller does not pop them.
6. `int` is 16 bits. A `char` promotes to `int` before an arithmetic operator.
   An integer constant is a `uint64_t` in `int_const_val`. The compiler does
   not keep that constant as a host floating value.
7. `sizeof` parses its operand and discards the code. sccz80 has no
   variable-length arrays.
8. When a struct tag is complete, `publish_struct_size` writes that size into
   types that already point at the tag.
9. Peephole rules stay in `z88dk-copt`, in the files named in section 7.
   The compiler does not grow a peephole pass.
10. Call conventions stay the library conventions. A change here changes
    sccz80, 80cc, zsdcc, and the libraries together.
