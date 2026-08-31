---
name: cpu-8085
description: >
  Intel 8085 assembly for z88dk: Zilog mnemonics, full opcode map (flags K/V,
  timings), and extended-instruction usage. Strong rule: stack-only locals and
  intermediates; static/BSS only for cross-call state. Prefer when writing or
  reviewing 8085 library asm, mapping Intel↔Zilog, choosing stack frames,
  K-flag loops, restoring float/integer divide, legal (de) stores,
  jr-as-jp synthetics, or /cpu-8085.
---

# CPU — 8085

Compatible extension of the Intel 8080 (April 1974). Same documented 8080 ops; ten extra ops in 8080 unused cells. **This skill is complete for 8085 work.** Load `cpu-8080` only when the binary must also run on 8080.

z88dk uses **Zilog mnemonics** for 8085 sources. Extended opcodes are first-class on every 8085. Design notes: https://feilipu.me/2021/09/27/8085-software/

## Conventions (always follow)

1. **Mnemonics are Zilog**, as in Z80 assembly — not Intel 8080/8085 names.
2. **Opcode bytes and timings are 8085**, not 8080 and not Z80.
3. **Undocumented / extended** opcodes are noted in tables (column or section).
4. Immediate forms: `*` = 8-bit immediate (d8), `**` = 16-bit immediate/address (d16/a16). These `*`/`**` are operand placeholders only.
5. For **LDHI** / **LDSI** equivalents (`ld de,hl+*` / `ld de,sp+*`), the 8-bit offset is **unsigned**.
6. Conditional cycle counts use `taken/not-taken` (e.g. `12/6`, `10/7`, `18/9`).

Prefer the full tables in [references/opcodes.md](references/opcodes.md). Use this skill body for rules, flags, mnemonic mapping, and undocumented ops.

Coding preferences for extended ops are in the **Extended instruction usage** section below.

## Sources

| Topic | Source |
|-------|--------|
| Zilog mnemonics & descriptions | [feilipu/8085-opcodes](https://gitlab.com/feilipu/8085-opcodes) `8085_instructions.html` |
| Flag effects (S Z K A P V C), timings | [pastraiser i8085 opcodes](https://pastraiser.com/cpu/i8085/i8085_opcodes.html) |

When sources conflict on **flags**, trust **pastraiser** (8085-specific K and V). When they conflict on **mnemonic spelling**, trust **8085_instructions.html** (Zilog).

## Registers

```
15 ...... 8  7 ...... 0
     A            F      → AF (PSW); Zilog: af
     B            C      → BC
     D            E      → DE
     H            L      → HL
15 ............... 0
        SP
        PC
```

Memory via HL is written `(hl)` (Intel `M`). Stack grows downward; `push` stores high byte first at `sp-1`, low at `sp-2`.

## Flag register (F)

| Bit | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
|-----|---|---|---|---|---|---|---|---|
|     | S | Z | K | A | 0 | P | V | C |

| Flag | Meaning |
|------|---------|
| **S** | Sign |
| **Z** | Zero |
| **K** | Undocumented; also **X5** / **UI** (underflow/overflow indicator) |
| **A** | Auxiliary carry (half-carry / AC) |
| **0** | Unused; always zero |
| **P** | Parity |
| **V** | Undocumented overflow |
| **C** | Carry |

Flag columns in tables are always **S Z K A P V C**:

- letter → that flag is affected as defined by the instruction
- `-` → unchanged
- `0` / `1` → forced clear / set

**Important:** On the Z80, P and V share one bit (P/V). On the **8085 they are separate bits** (P bit 2, V bit 1). Do not collapse them.

Condition codes for jumps/calls/returns:

| Zilog cc | Meaning |
|----------|---------|
| `nz` / `z` | Z clear / set |
| `nc` / `c` | C clear / set |
| `po` / `pe` | P odd / even (parity) |
| `p` / `m` | S clear (plus) / set (minus) |
| `nk` / `k` | K clear / set (undocumented) |
| `v` (rst v only) | V set |

## Intel → Zilog mnemonic map (primary)

Use Zilog in all generated/edited z88dk code. Intel names appear in fixtures and external sources; when importing external code, **translate to Zilog**.

| Intel | Zilog |
|-------|-------|
| `NOP` | `nop` |
| `LXI rp,d16` | `ld bc/de/hl/sp,**` |
| `STAX B/D` | `ld (bc),a` / `ld (de),a` |
| `LDAX B/D` | `ld a,(bc)` / `ld a,(de)` |
| `INX/DCX rp` | `inc/dec bc/de/hl/sp` |
| `INR/DCR r` | `inc/dec r` ; `M` → `(hl)` |
| `MVI r,d8` | `ld r,*` |
| `MOV r1,r2` | `ld r1,r2` |
| `RLC/RRC` | `rlca` / `rrca` |
| `RAL/RAR` | `rla` / `rra` |
| `DAD rp` | `add hl,bc/de/hl/sp` |
| `LDA/STA a16` | `ld a,(**)` / `ld (**),a` |
| `LHLD/SHLD a16` | `ld hl,(**)` / `ld (**),hl` |
| `DAA` | `daa` |
| `CMA` | `cpl` |
| `STC/CMC` | `scf` / `ccf` |
| `HLT` | `halt` |
| `ADD/ADC r` | `add a,r` / `adc a,r` |
| `SUB/SBB r` | `sub r` / `sbc a,r` |
| `ANA/XRA/ORA/CMP r` | `and r` / `xor r` / `or r` / `cp r` |
| `ADI/ACI/SUI/SBI` | `add a,*` / `adc a,*` / `sub *` / `sbc a,*` |
| `ANI/XRI/ORI/CPI` | `and *` / `xor *` / `or *` / `cp *` |
| `JMP/Jcc` | `jp **` / `jp cc,**` |
| `CALL/Ccc` | `call **` / `call cc,**` |
| `RET/Rcc` | `ret` / `ret cc` |
| `PCHL` | `jp (hl)` |
| `SPHL` | `ld sp,hl` |
| `XCHG` | `ex de,hl` |
| `XTHL` | `ex (sp),hl` |
| `PUSH/POP B\|D\|H\|PSW` | `push/pop bc\|de\|hl\|af` |
| `IN/OUT d8` | `in a,(*)` / `out (*),a` |
| `EI/DI` | `ei` / `di` |
| `RIM/SIM` | `rim` / `sim` (8085 only) |
| `RST n` | `rst 00h` … `rst 38h` |

### Undocumented / extended

| Op | Intel | Zilog | Bytes | Cycles | Flags (SZKAPVC) | Effect |
|----|-------|-------|-------|--------|-----------------|--------|
| `08` | DSUB | `sub hl,bc` | 1 | 10 | `SZKAPVC` | HL ← HL − BC |
| `10` | ARHL | `sra hl` | 1 | 7 | `-----0C` | Arithmetic right shift HL; V←0 |
| `18` | RDEL | `rl de` | 1 | 10 | `-----VC` | Rotate DE left through C |
| `28` | LDHI d8 | `ld de,hl+*` | 2 | 10 | `-------` | DE ← HL + unsigned * |
| `38` | LDSI d8 | `ld de,sp+*` | 2 | 10 | `-------` | DE ← SP + unsigned * |
| `CB` | RSTV | `rst v` | 1 | 12/6 | `-------` | If V set: push PC, PC←40h |
| `D9` | SHLX | `ld (de),hl` | 1 | 10 | `-------` | (DE)←L, (DE+1)←H |
| `DD` | JNK a16 | `jp nk,**` | 3 | 10/7 | `-------` | Jump if K=0 (also jnx5/jnui) |
| `ED` | LHLX | `ld hl,(de)` | 1 | 10 | `-------` | L←(DE), H←(DE+1) |
| `FD` | JK a16 | `jp k,**` | 3 | 10/7 | `-------` | Jump if K=1 (also jx5/jui) |

These are **not** standard Z80 opcodes at those encodings (Z80 uses `CB`/`DD`/`ED`/`FD` as prefixes). On 8085 they are single-byte (or 3-byte jump) instructions.

## Flag rules agents must not get wrong

| Group | Flags | Notes |
|-------|-------|-------|
| `inc`/`dec` **16-bit** (`inc bc` … `dec sp`) | `--K----` | Only **K** changes |
| `inc`/`dec` **8-bit** (incl. `(hl)`) | `SZKAPV-` | All but **C** |
| `rlca` / `rla` | `-----VC` | V and C |
| `rrca` / `rra` | `-----0C` | **V forced 0** |
| `add hl,rp` | `-----VC` | V and C (not C alone) |
| 8-bit ALU (`add`…`cp`, immediates) | `SZKAPVC` | Full set |
| `daa` | `SZKAPVC` | |
| `cpl` | `-------` | **No flags** (Z80 `cpl` sets H,N) |
| `sub hl,bc` (undoc) | `SZKAPVC` | Full set |
| `sra hl` (undoc) | `-----0C` | V←0, C from bit 0 |
| `rl de` (undoc) | `-----VC` | V and C |
| `scf` | `------1` | C←1 |
| `ccf` | `------C` | C toggled |
| `pop af` | `SZKAPVC` | Restores **all** flags including K,V. Bit 3 stays 0 |

Logical ops still use the full pastraiser mask `SZKAPVC` (how individual bits are computed is instruction-defined; do not invent Z80 N-flag behavior — 8085 has **no N flag**).

## Timing notes

Pastraiser T-states (8085 clocks). Not 8080 (many documented ops differ by 1T).

- Conditional **ret**: 12 taken / 6 not taken.
- Conditional **jp**: 10 / 7 (address bytes skipped when not taken).
- Conditional **call**: 18 / 9.
- `call **` 18, `ret` 10, `rst` 12.
- `halt` is **5**.
- `push` 12, `pop` 10.
- 8-bit ALU register **4**, `(hl)` 7, immediate 7.
- `ld r,r'` **4**, `ld r,(hl)` / `ld (hl),r` 7.
- 8-bit `inc`/`dec` r **4**; `(hl)` 10. 16-bit `inc`/`dec` rp **6**.
- `add hl,rp` 10, `ex de,hl` 4, `ex (sp),hl` **16**.
- `ld hl,(**)` / `ld (**),hl` 16; `ld a,(**)` / `ld (**),a` 13.
- `jp (hl)` / `ld sp,hl` 6.

## Coding rules for this project

1. Emit **Zilog** mnemonics only (`ld a,b` not `MOV A,B`; `jp nz,label` not `JNZ`).
2. Register pairs: `bc`, `de`, `hl`, `af`, `sp` — never Intel `B`, `D`, `H`, `PSW` in new code.
3. Use `(hl)`, `(bc)`, `(de)`, `(**)` for memory; never `M`.
4. Prefer undocumented ops when they clearly win (e.g. `sub hl,bc`, `ld hl,(de)`, `ld (de),hl`, `ld de,hl+*`) **and** the target assembler/CPU path supports them.
5. Never assume Z80 instruction timings or prefix opcodes exist on 8085. **`jr` / `jr cc` are allowed** in normal mode (synthetics on): z80asm emits `jp` / `jp cc` (3 bytes; cond `jp` is 10/7). Same source then assembles for Z80, where `jr` is native. **Strict** / `-no-synth` rejects `jr`. Do not expect a 2-byte relative branch (`18` is `rl de`).
6. When optimizing, consult [references/opcodes.md](references/opcodes.md) for exact size/cycle/flag data.
7. **Assembler support last resort:** fixtures `src/z80asm/dev/cpu/cpu_test_8085_{ok,err}.asm` (and `*_strict_*`). **ok** = z80asm accepts that source form (native, synthetic, or `call __z80asm__*`). **err** = rejected. **`_strict_`** = **synthetics forbidden**. Fixtures may include **Intel** spellings for external-compat testing; **z88dk always writes Zilog**. Full decode: **`tool-z80asm`**. `rg` only; do not bulk-read.

## Quick lookup

Full 16×16 opcode grid, Intel cross-ref, and macro helpers:

→ **[references/opcodes.md](references/opcodes.md)**

---

# Extended instruction usage

When and how to use the ten 8085 extended instructions. **Encodings, timings, and flags** are in **this skill** + [references/opcodes.md](references/opcodes.md) and `references/opcodes.md`.

Background: [8085 Software — Extended Instructions](https://feilipu.me/2021/09/27/8085-software/) (feilipu, 2021). Present on every 8085 (also Tundra CA80C85B).

**Always emit Zilog mnemonics** (project convention).

## Hard rule: stack variables, not static/BSS

**Static memory (BSS / `label: ds n` / fixed absolute cells) must only hold state that must survive across function calls.** Never use it for intermediate variable storage.

| Allowed in static/BSS | Forbidden in static/BSS |
|-----------------------|-------------------------|
| Values that **must outlive** the current call (true globals, module state, buffers callers re-enter later) | Locals, temps, intermediate results, scratch across a few instructions |
| MMIO, interrupt vectors, ROM constants | “Scratch” cells to avoid a push or stack frame |
| | Anything justified only by fewer cycles or easier coding |

- Function **locals, temporaries, and intermediate results** live **only on the stack** (arguments, return slots, pushes, explicit frames).
- Access with **`ld de,sp+*`**, **`ld hl,(de)`**, **`ld (de),hl`**, **`ld a,(de)`**, push/pop, **`ex (sp),hl`**.
- Prefer **pointers passed on the stack** over new static cells, even for long-lived data when the caller already owns the buffer.
- “Slightly fewer cycles” or “easier to write” is **not** enough justification for static/BSS scratch.

## Instruction preferences

| Zilog | Prefer for | Avoid / watch |
|-------|------------|----------------|
| `ld de,sp+*` | SP-relative address of a byte/word on the stack | `*` is **unsigned** 8-bit |
| `ld de,hl+*` | DE ← HL + unsigned offset (struct/buffer) | Same unsigned rule |
| `ld hl,(de)` / `ld (de),hl` | 16-bit load/store through DE | Not Z80 prefix encodings |
| `sub hl,bc` | 16-bit subtract; **== / !=**; signed compares with K | **No borrow-in**; not multi-word subtract chains |
| `sra hl` | Signed 16-bit arithmetic right shift | Clears V; C ← old bit 0 |
| `rl de` | Rotate DE left through C; ×2 on DE; 32-bit with HL | Pair with `add hl,hl` / `ex de,hl` as needed |
| `jp k,**` / `jp nk,**` | After 16-bit `dec`; signed compare outcomes | K after `dec rp` sets on **−1**, not on **0** |
| `rst v` | Branch to handler if V set | Vector **0040h** must exist |

## Core formulations

### 1. Stack access (primary working storage)

```asm
    ld  de,sp+n        ; n = unsigned offset (0…255)
    ld  hl,(de)        ; word load
    ld  a,(de)         ; byte load
    ld  (de),hl        ; word store
```

Often best: leave the pointer in **DE** and use `(de)` / `ld hl,(de)` without swapping. Second 32-bit value: keep it **on the stack**, not a shadow register bank.

### 2. HL ← SP+n — prefer extended over `ld hl,nn` / `add hl,sp`

Classic (any 16-bit offset):

```asm
    ld  hl,nn          ; 10c, 3B
    add hl,sp          ; 10c, 1B  → total 20c / 4B; sets V,C; DE preserved
```

**Unsigned 8-bit offset** — use `ld de,sp+n` (10c, 2B, no flags) plus `ex de,hl` (4c, 1B, no flags):

| Goal | Sequence | Bytes | Cycles | Flags | DE | Notes |
|------|----------|------:|-------:|-------|-----|-------|
| Pointer in DE, HL untouched | `ld de,sp+n` | 2 | **10** | none | = SP+n | Prefer when HL must stay |
| HL = SP+n, DE free | `ld de,sp+n` / `ex de,hl` | 3 | **14** | none | becomes old HL | **6c faster**, 1B smaller than classic |
| HL = SP+n, **preserve DE** | `ex de,hl` / `ld de,sp+n` / `ex de,hl` | 4 | **18** | none | restored | **2c faster** than classic; same size; no flag damage |

**DE-preserving form** (only final HL is the new value; DE restored; flags untouched):

```asm
    ex  de,hl          ; 4c   DE↔HL
    ld  de,sp+n        ; 10c  DE = SP+n  (old HL in DE is overwritten — OK)
    ex  de,hl          ; 4c   HL = SP+n, DE = original DE
```

Trace: start DE=D₀, HL=H₀ → after 1st `ex`: DE=H₀, HL=D₀ → after `ld de,sp+n`: DE=SP+n, HL=D₀ → after 2nd `ex`: **DE=D₀**, **HL=SP+n**.

Temporary use then restore previous HL (DE ends as SP+n, not original DE):

```asm
    ld  de,sp+n
    ex  de,hl          ; HL = SP+n, DE = old HL
    ; ... use HL ...
    ex  de,hl          ; HL restored; DE = SP+n
```

**Still prefer classic** when offset is not an unsigned 0…255, or when you need the **C/V** from `add hl,sp`.

### 3. Stack frame

```asm
    ; HL = SP+n (pick a sequence from §2)
    ; adjust HL as needed, then:
    ld  sp,hl
```

Document every slot. Drop consumed args in one epilogue:

```asm
    pop bc             ; return address — never pop af for this
    ; pop/discard arg words as required (pop af is OK here to discard only)
    push bc            ; return
```

**`pop af` and the return address:** F bit 3 is hardwired 0 on the 8085 (K and V **are** restored), so a word popped into AF can never be a faithful 16-bit value (`$FFFF` → `$FFF7`). **Never `pop af` the return address** (and never `push af` / `ret` a return path that depends on an intact address). **Do** use `pop af` to **discard** intermediate stack words on return when A/F need not be preserved — the corrupted F is irrelevant because the value is thrown away.

#### Multi-word frame rebuild (no `exx`)

Without alternate registers, a second long value lives **on the stack**, not in a shadow bank. When assembling a clean frame on top of junk:

1. **Push order vs layout.** Stack grows down. For layout top→bottom `W0, W1, W2` (W0 at lowest address / first pop), push **W2, then W1, then W0**. After `pop bc; pop de; pop hl` of pushed temps, restore with `push bc; push de; push hl` only if that matches the desired top word — verify with a depth diagram.
2. **Overlapping copy (memmove).** Copying a block upward when `dest = src + k` and `k < size` **overlaps**. Copy **high → low** (last byte first). Forward copy corrupts the tail.
3. **Raise SP over junk.** After a correct prefix of *N* good bytes sits above *J* junk bytes: copy the *N*-byte frame up by *J* (non-overlapping if *J ≥ N*, else high→low), then `ld hl,J` / `add hl,sp` / `ld sp,hl`.
4. **Product / result in BC·DE·HL while scrubbing.** Hold the full result in registers; do not park the return address in AF. Typical pattern: write result over a callee-owned slot, drop temps with SP math, then:

```asm
    pop hl             ; ret
    pop bc             ; result.bc
    pop de             ; result.ml
    ex  (sp),hl        ; HL = result.mh; (sp) = ret
    ex  de,hl          ; DE = mh, HL = ml
    ret                ; BC DEHL = result; only ret on stack
```

### 4. 16-bit compare and subtract — `sub hl,bc`

```asm
    ld  bc,de          ; if second operand is in DE
    sub hl,bc          ; HL − BC
    jp  z,equal        ; or jp nz,not_equal
```

Signed order (illustrative — tune K/Z/C to the relation):

```asm
    ld  bc,de
    sub hl,bc
    jp  k,...          ; use K together with Z/S/C as required
```

For multi-word subtract **with borrow**, use **`sub` / `sbc` through A**, not `sub hl,bc`.

### 5. Counted loops — K and pre-decrement

16-bit **`dec bc` / `dec de` / `dec hl` / `dec sp`** update **K** (not Z as the loop signal).

- K sets when the pair underflows to **−1**, **not** when it hits **0**
- **Pre-decrement** the counter; branch with **`jp k` / `jp nk`**

```asm
loop:
    ; body
    dec bc
    jp  nk,loop        ; adjust sense to match your initial count
```

Do not copy Z80 `dec bc; jp nz` semantics.

#### Alternative 16-bit counted loop structure.

Alternatively 16-bit loops can be created using the **`dec bc / inc b / inc c`** set up to create inner and outer loops, using any 16 bit register pair. Typically **`bc`** would be used, as **`hl`** and **`de`** have other priority uses.

```asm
    dec bc
    inc b
    inc c
loop:
    ; body, repeated BC times
    dec c
    jr  nz,loop        ; → jp nz on 8085; native jr on Z80
    dec b
    jr  nz,loop
```

**`jr nz` is allowed** in normal mode. Use it when the same source may also build for Z80. Strict mode: write `jp nz`. `jp k` / `jp nk` have no `jr` form (Z80 has no K).

### 6. Multiply / divide building blocks — `rl de` + `sub hl,bc`

Shift-add mul and restoring div center on:

- **`rl de`** (and often **`add hl,hl`**) to shift
- **`sub hl,bc`** / **`add hl,bc`** to trial-subtract and restore
- **`ccf`** into quotient bits when dividing

Partial **unroll** when the body is small. Entry style: public DE/HL form → **`ld bc,de`** (or `ld bc,hl`) → HL/BC core so callers that already have BC can join mid-routine.

#### Float divide (math32 / math16) — restoring wins

| Lesson | Detail |
|--------|--------|
| Prefer **restoring** `fsdiv` / `f16_div` over NR `fsinv`×mul for general `/` | z80 + 8085 cores; large TIMER win on divide-hot code (whetstone ~1.4×) |
| `fsinv` stays NR | Use for reciprocal-as-primitive; HW mul (z80n `mul de` / z180 `mlt`) helps **inv**, not the restoring loop |
| 8085 core | Stack-only second operand / temps; `sub hl,bc` + `rl de`; **no** EXX / IX / IY |
| Loop counter | Do not reuse the count register as a working BC/DE mid-loop (classic hang: never reaches `TIMER_STOP`) |
| Rem / count clobber | Keep remainder high and step count off the hot DEHL path (stack slots) |

#### `(de)` stores — only legal forms

On 8085, **`ld (de),r` / `ld (de),n` are illegal**. Valid: **`ld a,(de)`**, **`ld (de),a`**, **`ld hl,(de)`**, **`ld (de),hl`**, post-inc synthetics (`ld a,(de+)`). Prefer **`ld (de),hl`** for word stores; never invent Z80-style `(de),l`.

#### Style (math32/math16 library asm)

- Four-space indent; blank line **only** after unconditional `jr`/`jp` (not after every label).
- Prefer synthetics: `ld de,hl`, `ld bc,hl`, …; if DE is dead after a transfer, **`ex de,hl`** over `ld h,d` / `ld l,e`.

### 7. Shifts

**Signed 16-bit >>**

```asm
    sra hl
```

**Logical 16-bit >>** (no `srl hl`):

```asm
    sra hl
    ld  a,$7f
    and h
    ld  h,a            ; force bit 15 clear
```

**Logical multi-byte >>** (24/32-bit etc.): chain **`rra` through A** across bytes — not Z80 `srl`.

**32-bit <<** (value in DEHL):

```asm
    add hl,hl
    rl  de
```

**32-bit rotate** (sketch):

```asm
    rl  de
    ex  de,hl
    ; continue on the other half
```

**`rl de` as ×2 on DE** for table/struct scaling.

**Bitfield open/close on DE** (packed fields in D/E): open with **`rl de`**; repack with **`rra` via A** into D then E. Test a register for zero without destroying it: **`inc r` / `dec r` / `jp z`**.

### 8. Extra 16-bit slot — `ex (sp),hl`

Push a scratch word; **`ex (sp),hl`** swaps with it when AF/BC/DE/HL are full (16c). **Do not** use `push af`/`pop af` as a free 16-bit temp or to hold a return address: F bit 3 is hardwired 0 (`$FFFF` → `$FFF7` on the round trip). **`pop af` is fine only when the popped word is discarded** (e.g. clearing intermediates off the stack in an epilogue).

### 9. I/O and Z80-only ops to avoid

| Prefer on 8085 | Avoid (Z80-only or wrong) |
|----------------|---------------------------|
| `out (*),a` / `in a,(*)` (byte in A) | `outi`, `in r,(c)`, block I/O |
| `dec b` / `jr nz` (→ `jp nz`) | native `djnz` (`10` is `sra hl`) |
| Stack + DE for second long | `exx`, IX/IY as default temps |
| `sub hl,bc` | Assuming `sbc hl,de` exists |
| Open-coded extended-op sequences | Assuming Z80 library mul/div cores |

Assembler must be **8085-aware** (these encodings are not Z80 prefixes).

### 10. Synthetic opcodes

**z80asm** expands many **synthetic** source forms into short real-op sequences (no harmful flag/side effects for the forms below). They keep library code readable and portable across CPUs without `#if CPU` for the same transfer.

#### 16-bit register-pair copies (full set)

Synthetics of the form **`ld dst,src`** where **dst** and **src** are word register pairs. Each expands to **two 8-bit `ld`s** (high then low, or as the assembler tables define — e.g. `ld de,hl` → `ld d,h` / `ld e,l`).

| Allowed pairs | Forbidden as word-copy synthetics |
|---------------|-------------------------------------|
| **`bc`**, **`de`**, **`hl`** — **any → any** (including “same” pair) | **`af`**, **`sp`** (not part of this word-copy set) |

```asm
    ld  bc,de          ; B←D, C←E
    ld  bc,hl
    ld  de,bc
    ld  de,hl
    ld  hl,bc
    ld  hl,de
```

**Prefer these over hand-rolled two-byte moves** (`ld b,d` / `ld c,e`, …) and over swap dances when you only need to **park one pair**:

```asm
    ; Hold DEHL; need HL free for SP adjust — park lo only:
    ld  bc,hl          ; park lo; DE (hi) stays
    ld  hl,14
    add hl,sp
    ld  sp,hl
    ld  hl,bc          ; restore lo
```

Do **not** invent `ld bc,de` + `ex de,hl` + SP math + reverse swaps when `ld bc,hl` / `ld hl,bc` is enough.

Other common synthetics (not pair-copy): e.g. `ld a,(hl+)` (load + inc index).

**`jr` / `jr cc`:** allowed in **normal** mode as `jp` / `jp cc`. Use them when the same source may also build for Z80. **Strict** / `-no-synth` rejects `jr`. Cost as a 3-byte `jp` (cond 10/7), not as Z80’s 2-byte `jr`. `18` is native `rl de`, not `jr`.

**Strict** assemble (`*_strict_*` / `-no-synth`) **forbids** free synthetics — fixtures under `src/z80asm/dev/cpu/` (see **`tool-z80asm`**).

## Pitfalls

1. **`pop af` never for function return** — F bit 3 is hardwired 0, so AF cannot hold a correct return address. Use BC/DE/HL for the return word. **`pop af` is OK only to discard** intermediate stack values when the popped data is unused. AF is also not a clean 16-bit temp (`$FFFF` → `$FFF7`).
2. **`sub hl,bc` has no borrow-in** — multi-precision use A + `sbc`.
3. **K ≠ Z on 16-bit dec** — pre-dec + `jp k`/`jp nk`.
4. **Offsets on `ld de,sp+*` / `ld de,hl+*` are unsigned.**
5. **`rst v`** only if **0040h** is defined.
6. **`rla` / `rra` / `rlca` / `rrca` do not set Z** — never `rla; jp z,...`. Test with `or a` / `and a` / explicit mask first, or use `inc`/`dec` on a copy.
7. **No `exx`, IX, IY, native `djnz` / native `jr`.** `jr` **is allowed** in normal mode (→ `jp`; shared Z80 source). Strict: write `jp`. Second long operand on stack; counted loops via `dec b`/`jr nz` or K pre-dec (§5).
8. **Forward overlapping stack copy corrupts** — see multi-word frame rebuild above.
9. **No copt pass on library asm** — hand-written `libsrc/**` is assembled as-is. Remove copy-backs (`ld r,a` then `ld a,r`) and other dead moves yourself. Match the **target file’s** whitespace (spaces vs tabs); do not reformat to sccz80/copt tab style. **Before finalising** any hand-coded math16/math32 (or similar) edit: scan for copt-equivalent wins (`ex de,hl` / `ld bc,hl` instead of push/pop transfers; drop `ld a,e` after `ld e,a`; pair zeros → `ld hl,0`; etc.) and run the matching suite. Do **not** use `xor a` for `ld a,0` when CF must survive. Full checklist: **`tool-copt`** and **`methodology-measure`** (“Before finalising hand-coded library work”).
10. **Illegal `(de)` stores** — only `a` / `hl` / post-inc forms (§6). A “working” assemble that used faked `ld (de),l` means the toolchain or listing was not 8085-checked.
11. **`__CPU_INTEL__` is set for 8085.** 9-common `IF __CPU_INTEL__` takes the 8080-portable path and will not emit `rl de` / `sra hl`. Do not “fix” those files with `#if __CPU_8085__`. Fork into `7-8085/` and list the module first (`l/util/8085.lst`, `l/sccz80/8085.lst`). Existing forks: `l_lsl_dehl`, `l_asr_dehl`, `l_long_asr`, `l_small_atoul` / `htoul` / `otoul` / `utoa`, `l_gint1sp`…`l_gint8sp`.

## Preference order (when writing 8085-only code)

1. Stack-only locals/temps/intermediates; **static/BSS only for state that must survive across calls** — never intermediate storage.
2. **`ld de,sp+*`** for stack pointers; **`ex de,hl`** forms for HL←SP+n (see §2) over `ld hl,nn`/`add hl,sp` when offset is u8.
3. **`ld hl,(de)` / `ld (de),hl` / `ld a,(de)`** for stack traffic through DE.
4. **`sub hl,bc`** for 16-bit ==, !=, and signed compares with **K**.
5. **K + pre-dec** for 16-bit counted loops.
6. **`rl de`** for ×2, mul/div shifts, 32-bit with HL.
7. **`sra hl`** for signed 16-bit >>; logical multi-byte >> via A.
8. Fall back to 8080-portable sequences only when the binary must run without 8085 extended ops.

## Related

- Full opcode grid: [references/opcodes.md](references/opcodes.md)
- 8080-only jobs (no extras): `cpu-8080` — do not load both for one CPU
- How to read z80asm ok/err fixtures: `.agents/skills/tool-z80asm/SKILL.md` (`src/z80asm/dev/cpu/`)
- Measurement / A/B: `.agents/skills/methodology-measure/SKILL.md`
- copt vs library asm: `.agents/skills/tool-copt/SKILL.md`
- Design notes: https://feilipu.me/2021/09/27/8085-software/
