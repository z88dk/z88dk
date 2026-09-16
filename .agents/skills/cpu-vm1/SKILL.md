---
name: cpu-vm1
description: >
  KR580VM1 (КР580ВМ1) for z88dk: 8080-compatible plus RS/MB prefixes, H1L1,
  dual 64K banks, OF/MF flags, and ten extra ops. Use when writing or reviewing
  vm1 library asm, +test -clib=vm1 / +z80 -clib=vm1, -mvm1, pop-af bank traps,
  DSUB/LHLX/SHLX/DCMP, or /cpu-vm1. Not 8085 — LDSI/RDEL/ARHL encodings differ.
---

# CPU — KR580VM1

Soviet 8080 extension of the KR580VM80A. **Binary compatible with the 8080.** Every 8080 program runs unchanged. It is **not** an 8085: the two chips reuse the same undocumented opcode slots for different instructions.

z88dk writes **Zilog** mnemonics. The Russian document uses Intel-style names (DSUB, LHLX, ANX). Translate on the way in.

Classic path `libsrc/l/sccz80/7-vm1/`, products `vm1_crt0.lib` / `testvm1_clib.lib` / `vm1_clib.lib`. Assemble `-mvm1`. `zcc +test -clib=vm1` or `+z80 -clib=vm1`. Float: **`--math-mbf32`** (`mbf32_vm1.lib`). **No** `math32` / `math16` vm1 product — those 8085 cores use `ld de,sp+*` and `rl de`, which are **prefixes** on this CPU.

**This skill is complete for vm1 work.** Load `cpu-8080` only when the binary must also run on a plain 8080. Do not load `cpu-8085` for this CPU.

## Conventions (always follow)

1. **Never `pop af` unless the word is a previous `push af`.** Unknown bits in F bit 3 load MF and **swap the data RAM bank**. Matched `push af` … `pop af` is safe. Detail below.
2. **Mnemonics are Zilog** (`ld a,b`, `sub hl,bc`, `andl (hl)`). Do not emit Intel `MOV` / `DSUB` / `LHLX` in tree sources (fixtures may list Intel for compat).
3. **Opcode bytes and timings are 8080 + VM1 extras**, not Z80 or 8085.
4. Immediate forms: `*` = d8, `**` = d16/a16. Placeholders only.
5. Conditional cycle counts: the Russian tables list **taken only**. z88dk uses 8080 not-taken (`jp` always 10; `call` 17/11; `ret` 11/5).
6. Each prefix byte adds **4T**. Base timings match the 8080.
7. One major function per file under `libsrc`.

Human page of record: `doc/kr580vm1.md`. When that page and an external Russian source disagree, **the local page wins** (it already folds the errata). Assembler last resort: `cpu_test_vm1_ok.asm`.

## Sources

| Topic | Source |
|-------|--------|
| ISA, prefixes, flags, timings, errata | **`doc/kr580vm1.md`** (primary) |
| Secondary Russian | [emuverse КР580ВМ1/Система_команд](https://emuverse.ru/wiki/КР580ВМ1/Система_команд) |
| Raw radio86 wiki (JS shell — fetch storage) | `https://storage.googleapis.com/google-code-archive/v2/code.google.com/radio86/wiki/KP580BM1.wiki` |
| z80asm source forms | `src/z80asm/dev/cpu/cpu_test_vm1_ok.asm` / `_strict_ok.asm` |
| sccz80 overrides | `libsrc/l/sccz80/7-vm1/` |
| Emulator | `src/ticks/vm1_inst.c`, `-mvm1` in `ticks.c` |

8080-portable sequences, stack frames, and `jr`→`jp` synthetics: **`cpu-8080`**. This skill is the extras, the prefixes, MF, and the traps.

### Errata in the original Russian document

Resolved in `doc/kr580vm1.md` against emuverse and 8085 precedent. **Use the local encodings.**

| Claim in the radio86 / emuverse tables | Truth |
|----------------------------------------|--------|
| SHLX listed as `11001101` (`$CD`, 8080 `CALL`) | **`$D9`**, same as 8085 SHLX |
| SMF0/SMF1 tables show prefix `$38` (RS) | Prefix is **MB `$28`**: `smf0` = `$28 $00`, `smf1` = `$28 $7F` |
| JOF / cond. `jp` / cond. `call` “ELSE PC ← PC+1” | Address field is two bytes; skip both (z88dk `pc += 2` after the opcode) |
| ACI listed as `$EE` (that is `xri *`) | 8080 **`$CE`** |
| RAR listed as `$17` (that is `rla`) | 8080 **`$1F`** |
| CMA algorithm `A ← A` | Invert: `cpl` |

LHLX at `$ED` is listed correctly in the original.

## Registers

8080 set plus one extra pointer pair. No IX/IY, no `exx`, no AF′/BC′/DE′.

```
15 ...... 8  7 ...... 0
     A            F
     B            C
     D            E
     H            L      → HL   (pointer pair)
     H'           L'     → HL'  (H1L1; z88dk `h'` `l'` `hl'`)
15 ............... 0
        SP
        PC
```

H1L1 is **not** a Z80 shadow bank. There is no exchange. The **RS** prefix selects H1L1 as source, destination, or `(hl)` pointer for **one** following instruction. `ex de,hl` always uses real HL (document gives no RS form).

z88dk ticks parks HL′ in the unused Z80 `h_`/`l_` for the duration of one prefixed instruction.

## Flag register (F)

8080 layout plus OF and MF in bits the 8080 left constant / copies of A:

| Bit | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
|-----|---|---|---|---|---|---|---|---|
|     | S | Z | **OF** | AC | **MF** | P | 1 | CY |

| Flag | Meaning |
|------|---------|
| **S** | Sign |
| **Z** | Zero |
| **OF** | Signed overflow (carry into bit 7 xor carry out of bit 7). **Not** 8085 K |
| **AC** | Half-carry |
| **MF** | Data bank: 0 = main, 1 = additional |
| **P** | Parity (even). **Always parity**, not Z80 P/V |
| **1** | Unused; permanently 1 |
| **CY** | Carry |

OF occupies the same bit as 8085 **K**. They are not the same flag. Do not use `jp k` / `jp nk` — those encodings are DCMP D / JOF on this CPU.

Condition codes: `nz` `z` `nc` `c` `po` `pe` `p` `m`, plus **`of`** (`jp of,**`).

### Flag rules agents must not get wrong

Base 8080 ops keep 8080 SZAPC behaviour, plus OF as below. Bit 1 stays 1. MF only changes on `smf0` / `smf1` / `pop af`.

| Group | S Z OF AC P CY | Notes |
|-------|----------------|-------|
| 8-bit `add`/`adc`/`sub`/`sbc`/`inc`/`dec`/`cp` (and immediates) | ● ● ● ● ● ● (`inc`/`dec`: CY unchanged) | OF is 8-bit signed overflow |
| 8-bit `and`/`xor`/`or` (and immediates) | ● ● — 0 ● 0 | **Leave OF.** CY and AC cleared |
| `rlca`/`rrca`/`rla`/`rra` | — — ? — — ● | **C only** on 8080. Russian tables mark OF written; do not `jp of` after a rotate |
| `add hl,rp` (DAD) | — — — — — ● | **CY only.** CS form (`adc hl,rp`) same mask |
| `sub hl,bc/de` (DSUB) | ● ● — — — ● | **No OF.** S from bit 15. CS form consumes CY |
| `cp hl,bc/de` (DCMP) | ● ● — — — ● | Result discarded. **No OF.** CS form consumes CY |
| `andl`/`orl`/`xorl` (ANX/ORX/XRX) | ● ● — — ● 0 | CY cleared. OF and AC unchanged |
| `inc`/`dec` **16-bit** | — — ? — — — | Russian tables mark OF. **Z is not written.** Never `dec bc; jp nz`. Never `inc bc; jp of` as a count test |
| `daa` | 8080 SZAPC | Russian table (Z+CY only) is incomplete |
| `cpl` | — — — — — — | No flags |
| `scf`/`ccf` | — — — — — ● | |
| `smf0`/`smf1` | — — — — — — | **MF only** |
| `pop af` | all | Restores S Z OF AC **MF** P CY |

DSUB/DCMP **do not** set OF. Signed 16-bit order cannot use `jp of` the way 8085 uses `jp k` after `sub hl,bc`.

## Memory and MF

Two 64K banks. **Instructions fetch only from the main bank.** Data uses the bank named by MF. The MB prefix flips the bank for the **next** instruction only. `smf0` / `smf1` set MF until changed.

The document does not except the stack. z88dk therefore lets `push` / `pop` / `call` / `ret` follow MF. That is an inference. Changing MF between a `call` and its `ret` will not work.

## Hard rule: do not `pop af` of unknown contents

`pop af` loads **MF from bit 3** of the flags byte. MF selects the data RAM bank for **every** later data access (loads, stores, pushes, pops, `call`, `ret`). If that bit is not the MF you pushed, the CPU **switches bank**.

| Allowed | Forbidden (unknown F, so unknown MF) |
|---------|--------------------------------------|
| `push af` … later `pop af` of **that same word** (MF round-trips) | `pop af` to **discard** a stack slot |
| | `push bc` / `push de` / `push hl` then `pop af` as a 16-bit **move** |
| | `pop af` of a **return address** or any other non-PSW word |

The test is: **do you know this word is a PSW you pushed?** If not, do not pop it into AF. Bit 3 of arbitrary data is effectively random, so the bank swap is data-dependent and easy to miss in testing.

`sccz80` and `80cc` already suppress the unsafe idiom (`CPU_POP_AF_IS_SAFE()`). Hand-written asm must not invent it. Discard or move through BC/DE/HL.

A `pop af` of a **return address** is also broken on 8080/8085/gbz80 (hardwired flag bits). On VM1 it is worse: it can switch banks as well. Keep return addresses in BC/DE/HL.

## Prefixes

Up to two prefix bytes before any opcode. Opcode byte must not be `$28` or `$38`. A run of prefixes does not cancel. Interrupts are held off between a prefix and its instruction (same idea as Rabbit `altd`).

### RS — `$38`, 4T

Substitute HL′ for HL in the next instruction.

```asm
    ld  a,(hl')        ; 38 7E
    ld  a,h'
    ld  hl',nn
    push hl'
    add hl',bc
```

### MB / CS — `$28`, 4T

**MB** in front of a memory op: access the **other** data bank.

```asm
    mb ld a,(hl)       ; 28 7E   A ← other bank at HL
```

**CS** in front of `add hl,rp` / `sub hl,rp` / `cp hl,rp`: consume carry. z88dk folds CS into the mnemonic (no separate `cs` word in the source):

| Bare | Prefixed | Meaning |
|------|----------|---------|
| `add hl,bc` (`09`) | `adc hl,bc` (`28 09`) | HL ← HL + BC + CY |
| `sub hl,bc` (`08`) | `sbc hl,bc` (`28 08`) | HL ← HL − BC − CY |
| `cp hl,bc` (`CB`) | `cpc hl,bc` (`28 CB`) | flags from HL − BC − CY |

`cpc` is a **z88dk name**; the document has no Zilog spelling for compare-with-borrow.

Both prefixes: the human page shows **MB then RS** (`28 38 08` = `sbc hl',bc`). z80asm currently emits **RS then MB** for the CS+HL′ forms (`38 28 08`). Both orders are equivalent: one prefix selects the pair, the other consumes carry.

## Added instructions

Timings are **bare**; add 4T per prefix.

| Op | Zilog (write this) | Doc | T | Effect |
|----|--------------------|-----|--:|--------|
| `08` | `sub hl,bc` | DSUB B | 10 | HL ← HL − BC |
| `18` | `sub hl,de` | DSUB D | 10 | HL ← HL − DE |
| `10` | `andl (hl)` | ANX | 10 | (HL) ← (HL) & A |
| `20` | `orl (hl)` | ORX | 10 | (HL) ← (HL) \| A |
| `30` | `xorl (hl)` | XRX | 10 | (HL) ← (HL) ^ A |
| `CB` | `cp hl,bc` | DCMP B | 10 | flags from HL − BC |
| `DD` | `cp hl,de` | DCMP D | 10 | flags from HL − DE |
| `D9` | `ld (de),hl` | SHLX | 10 | (DE)←L, (DE+1)←H |
| `ED` | `ld hl,(de)` | LHLX | 10 | L←(DE), H←(DE+1) |
| `FD **` | `jp of,**` | JOF | 10 | jump if OF set |
| `28 00` | `smf0` | SMF0 | 8 | MF ← 0 |
| `28 7F` | `smf1` | SMF1 | 9 | MF ← 1 |

`andl` / `orl` / `xorl` are the assembler names. `ld (hl),and (hl)` (and the `or`/`xor` forms) is accepted: the preprocessor rewrites it to `andl`.

These sit in 8080 unused cells (`$x0`/`$x8` in the first quarter, and `$CB`/`$D9`/`$DD`/`$ED`/`$FD`). They are **not** Z80 prefixes at those bytes.

## Comparison with the 8085

Only DSUB B, SHLX, and LHLX match. Do **not** copy 8085 sequences that use the other slots.

| Op | 8085 | KR580VM1 |
|----|------|----------|
| `08` | `sub hl,bc` | `sub hl,bc` — same |
| `10` | `sra hl` | `andl (hl)` |
| `18` | `rl de` | `sub hl,de` |
| `20` | `rim` | `orl (hl)` |
| `28` | `ld de,hl+*` | **MB/CS prefix** |
| `30` | `sim` | `xorl (hl)` |
| `38` | `ld de,sp+*` | **RS prefix** |
| `CB` | `rst v` | `cp hl,bc` |
| `D9` | `ld (de),hl` | same |
| `DD` | `jp nk` | `cp hl,de` |
| `ED` | `ld hl,(de)` | same |
| `FD` | `jp k` | `jp of,**` |

There is **no** `ld de,sp+*` / `ld de,hl+*` / `rl de` / `sra hl` native. Frame addresses go through HL (`ld hl,nn` / `add hl,sp`). That is why vm1 trails 8085 on `l_gintNsp` and why math32/math16 8085 cores cannot be reused.

## Coding rules for this project

1. Emit **Zilog** only.
2. Register pairs: `bc`, `de`, `hl`, `hl'`, `af`, `sp`.
3. Prefer VM1 extras when they win: `cp hl,de`, `sub hl,de`, `ld hl,(de)`, `ld (de),hl`.
4. Never emit 8085 encodings for LDSI / LDHI / RDEL / ARHL / RSTV / JNK / JK.
5. Never `pop af` of unknown contents (discard, move, return address). Matched `push af`/`pop af` only.
6. **`jr` / `jr cc` are allowed** in normal mode: z80asm emits `jp` / `jp cc` (3 bytes, always 10T). Strict / `-no-synth` rejects `jr`. `$18` is `sub hl,de`, not a short branch.
7. Locals, temps, and intermediates live **on the stack**. Static/BSS only for state that must survive across calls. Same rule as `cpu-8080`.
8. **Assembler last resort:** `src/z80asm/dev/cpu/cpu_test_vm1_{ok,err}.asm` and `*_strict_*`. **ok** = accepted (native, synthetic, or `call __z80asm__*`). **err** = rejected. **`_strict_`** = synthetics forbidden. Fixtures list Intel spellings; **tree work is Zilog**. **`tool-z80asm`**. `rg` one mnemonic. Do not bulk-read `*_err.asm`.

Ticks: `z88dk-ticks -mvm1 binary` — CPU flag **before** the path. Disassemble: `z88dk-dis -mvm1`.

`$ED $FE` remains the ticks hook: `ld hl,(de)` with `$FE` next is a hook, not LHLX.

No `lib/arch/vm1/vm1_rules.1`. Missing CPU rules file means no extra peepholes; the build is correct.

`__CPU_INTEL__` is set (`-D__8080 -D__VM1`). 9-common `IF __CPU_INTEL__` takes the 8080-portable path. VM1 extras live in `7-vm1/` and `l/sccz80/vm1.lst`.

## Usage (from `libsrc/l/sccz80/7-vm1/`)

Cite the named file as the example. Every word extra **reads or writes DE**, so these helpers clobber DE. sccz80 does not keep DE live across them (checked against `lib/z80rules.*`).

### 1. 16-bit compare — `cp hl,de` (HL survives)

```asm
    cp  hl,de          ; l_eq.asm, l_ult.asm, …
    jp  z,equal
```

8085 needs `ld bc,de` / `sub hl,bc` because its DSUB only reaches BC. Here DCMP D is one byte and does not destroy HL.

### 2. Word load/store through DE — LHLX / SHLX

```asm
    ex  de,hl
    ld  hl,(de)        ; l_gint.asm / l_gintsp.asm
```

```asm
    ld  (de),hl        ; l_pint_pop.asm
```

`l_gintsp`: `add hl,sp` / `inc hl`×2 / `ex de,hl` / `ld hl,(de)` — no LDSI.

### 3. 16-bit subtract — `sub hl,de`

```asm
    ex  de,hl
    sub hl,de          ; l_sub.asm; CY is borrow (lib3d turn_left `ret nc`)
```

### 4. Second pointer — RS / `hl'`, not `exx`

Keep a second 16-bit pointer in HL′ and prefix the ops that need it. Do not invent `exx`.

### 5. Other data bank

MB for one access. Restore MF if the rest of the routine must stay on the original bank (`smf0`/`smf1`, or a matched `push af`/`pop af` of a known F).

## What 7-vm1 deliberately does not override

Signed `l_lt` / `l_le` / `l_gt` / `l_ge`: DSUB/DCMP do not set OF, so there is no `jp of` shortcut. Sign-flip + DCMP is larger and slower than 9-common. `l_asr` / `l_rlde` / `l_gint1sp`… need 8085 ARHL/RDEL/LDSI — leave 8080 forms.

## Synthetic opcodes (z80asm, normal mode)

Same **word-copy** family as other CPUs: `ld` among **`bc` / `de` / `hl`** (any → any) = two 8-bit loads. Prefer `ld bc,hl` … `ld hl,bc` to park a pair. **Not** `af` / `sp`.

Strict forbids free synthetics. Prefix forms (`adc hl,bc`, `ld a,(hl')`, `andl (hl)`) are **native**, not this set.

Do not use helper `call __z80asm__*` as the core of a hot hand-written routine. `sra hl` on this CPU is a helper (`cpu_test_vm1_ok.asm`); 8085 `sra hl` is a one-byte op.

## Pitfalls

1. **`pop af` of unknown contents swaps the data RAM bank** (F bit 3 → MF). Only a matched `push af`/`pop af` is safe.
2. **`$28` / `$38` are prefixes**, not LDHI/LDSI. Emitting 8085 `ld de,sp+n` here is an RS prefix plus whatever follows.
3. **`$10` is `andl (hl)`**, not `sra hl`. **`$18` is `sub hl,de`**, not `rl de`.
4. **OF ≠ K.** No `jp k` after 16-bit subtract.
5. **DSUB/DCMP leave OF alone.** Do not `jp of` after them for signed order.
6. **`call`/`ret` follow MF.** Do not change bank across a call.
7. **`ex de,hl` ignores RS.** HL′ is not swapped.
8. **`rla` / `rra` / `rlca` / `rrca` do not set Z.**
9. **16-bit `dec rr` does not set Z** (8080). No `dec bc; jp nz` as a count test. Test through A.
10. **No copt on library asm.** Scan dead moves yourself. `tool-copt`, `methodology-measure`.
11. **`--math32` / `--math16` are not vm1 products.** Use `--math-mbf32`.

## Preference order (vm1-only code)

1. Never `pop af` unless that word is a previous `push af`. Unknown F bit 3 swaps the data RAM bank.
2. `cp hl,de` / `sub hl,de` / `ld hl,(de)` / `ld (de),hl` over byte walks.
3. `hl'` + RS for a second pointer; stack for a second long (no `exx`).
4. `ld hl,nn` / `add hl,sp` for frames (no LDSI).
5. MB / `smf0`/`smf1` only when the other 64K bank is real.
6. Fall back to 8080-portable sequences for everything else.

## Assembler capability (last resort)

| File | Meaning |
|------|---------|
| `cpu_test_vm1_ok.asm` | Assembles; `;` comment = encoding |
| `cpu_test_vm1_err.asm` | Must fail |
| `*_strict_*` | Strict: synthetics forbidden |

**ok is not always one native opcode.** How to `rg`: skill **`tool-z80asm`**.

## Related

- Human ISA + errata: `doc/kr580vm1.md`
- 8080 base (no extras): `cpu-8080`
- 8085 extras (different map): `cpu-8085`
- Assembler: `tool-z80asm`
- Measure: `methodology-measure`, `tool-ticks` (`-mvm1` before the binary)
- Runtime: `libsrc/l/sccz80/7-vm1/`, `libsrc/l/sccz80/vm1.lst`
- Config: `lib/config/test.cfg` (`-clib=vm1`), `lib/config/z80.cfg`
