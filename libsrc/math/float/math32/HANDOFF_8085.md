# Handoff: math32 8085 port

Use this file to start a new session. Point the agent at:

`/home/phillip/Z80/z88dk/libsrc/math/float/math32/HANDOFF_8085.md`

First-message paste file:

`libsrc/math/float/math32/HANDOFF_8085_FIRST_MESSAGE.txt`

**8085 coding skills (upstream):** https://github.com/feilipu/8085-skills  
Local clone: `/home/phillip/Z80/8085-skills` (`.grok/skills/opcode-reference`, `extended-usage`).

---

## Canonical workspace

| Item | Value |
|------|--------|
| Tree | **`/home/phillip/Z80/z88dk`** only |
| Branch | **`math32-8085`** |
| Do not use | Grok worktree `~/.grok/worktrees/z80-z88dk/…` (incomplete) |

## Git state

- **HEAD (committed):** `23a0fae3bd` — pow remove integer fast path (also frexp/ldexp ABI at `2987220e4c`)
- **Uncommitted (this work):** expanded 32-bit mul path
  - `asm/8085/f32_fsmul32.asm` (**new**) — `m32_fsmul24x32`, `m32_fsmul32x32`
  - `newlibfiles_8085.lst`, `math32_8085_common_asm.lst` — list entries
- **Leave unstaged:** `ext/regex`, `ext/Unity`, all `bench/` probe junk (`t*`, `probe_*`, `*.ram`), `*.wip`, handoff files unless asked to stage

Key commits:

| Commit | Topic |
|--------|--------|
| `23a0fae3bd` | pow drop integer fast path |
| `2987220e4c` | frexp/ldexp am9511-style core ABI + sccz80 bridges |
| `7e6e0d9746` | frexp/poly/ldexp/pow hardening, suite in `all` |
| `b1abca4993` | 1E fixes (f2long, div scrub, fmin/fmax, callees, math.c) |
| `e5ea0a6cb3` | 1D higher C sccz80 + helpers |
| `fc89f4fd1d` | Phase 2 sqrt/poly |
| `26af8236e2` | stack frames + RNE |
| `f09c1a4ef9` | add/normalize |
| `dad6007eec` | mul cores |

## Phase status

| Phase | Status |
|-------|--------|
| **0** Layout + lists + docs | **Done** |
| **1A** Scaffold `math32_8085.lib` | **Done** |
| **1B** Simple cores | **Done** |
| **1C** Arithmetic | **Done** — mul/add/div/conv/compare |
| **1D** Higher funcs (sccz80) | **Done** — `make -C c 8085` → `c/8085/` |
| **2** sqr / ldexp / sqrt / poly | **Done** (IEEE poly; expanded path next) |
| **1E** Full suite green | **Done** — `test_math32_8085` **16/16** |
| **log/exp/pow** | **Done** — frexp/ldexp ABI + no HL clobber |
| **Expanded mul** | **Done** — `m32_fsmul24x32` / `m32_fsmul32x32` |
| **Expanded add + normalize32** | **Done** — `m32_fsadd24x32` / `m32_fsadd32x32` / `m32_fsnormalize32` |
| **NR inv/div/sqrt** | **Done** — suite **16/16**; wide bench `bench/twide_nr` 34/34 |

## Verify (green light)

```bash
export PATH=/home/phillip/Z80/z88dk/bin:$PATH
export ZCCCFG=/home/phillip/Z80/z88dk/lib/config

# Rebuild 8085 lib (after asm/C changes)
cd /home/phillip/Z80/z88dk/libsrc/math/float/math32
# optional: make -C c 8085
z88dk-z80asm -d -I/home/phillip/Z80/z88dk/lib -O=obj/8085/x/x/x -I.. -m8085 -D__CLASSIC @newlibfiles_8085.lst
TYPE=8085 z88dk-z80asm -d -I/home/phillip/Z80/z88dk/lib -m8085 -x/home/phillip/Z80/z88dk/libsrc/math32_8085 @math32.lst
cp -f /home/phillip/Z80/z88dk/libsrc/math32_8085.lib /home/phillip/Z80/z88dk/lib/clibs/

# Suite
cd /home/phillip/Z80/z88dk/test/suites/math
rm -f test_math32_8085.bin
make test_math32_8085.bin
# expect: 16 run, 16 passed, 0 failed; Ticks ~1.2–1.3M

# Expanded-mul smoke (optional)
cd /home/phillip/Z80/z88dk/libsrc/math/float/math32/bench
zcc +test -vn -clib=8085 -compiler=sccz80 -D__MATH_MATH32 -fp-mode=ieee --math32 \
  tmul32c.c tmul32c_a.asm -o tmul32c.bin
z88dk-ticks -m8085 tmul32c.bin
# expect: probe=5500 PASS  (32x32 + 24x32 → 6.0 expanded)
```

### Math32 suite ticks (measured)

| CPU | Ticks | Result |
|-----|------:|--------|
| z80 | **959 172** | 16/16 |
| z180 | **616 418** | 16/16 |
| **8085** | **~1.3M** (post-mul32 ~1 317 163) | 16/16 |

### log/exp smoke (bench/tlogexp.c)

| Call | Result |
|------|--------|
| `log(4)` | 1.386294 |
| `log(2)` | 0.693147 |
| `exp(1)` | 2.718282 |
| `exp(ln2)` | ~2.0 |
| `pow(2,1.5)` | 2.828427 |
| `frexp(4)` | 0.5, exp=3 |
| `ldexp(0.5,3)` | 4.0 |

### Expanded mul smoke (`bench/tmul32c*`)

| Call | Result |
|------|--------|
| `m32_fsmul32x32` 3.0×2.0 | B=129, DEHL=`C0000000` (6.0) |
| `m32_fsmul24x32` IEEE 3.0 × exp 2.0 | same |
| Combined probe | **`0x5500` PASS** |

## What works (8085 production)

| Area | Notes |
|------|--------|
| mul/add/div/conv/compare | Stack-only; IEEE RNE on pack; restoring div |
| sqr / ldexp / sqrt / invsqrt | Quake + 3×NR; ret-under-y for final mul |
| f2long | Exp kept in **C** (A-based shifts clobber A) |
| fsdiv scrub | Fixed stack cleanup for 0/1 and specials (ftoa/printf) |
| frexp / ldexp | **Core ABI = am9511/Z80** `ret, x, arg2`; `_m32_*` / sccz80 bridge reverse like cam32; `ld de,sp+d` + `ld hl,(de)`; no AF |
| poly (Horner) | sccz80 order `ret,n,dptr,x`; preserve DEHL on exit (IEEE mul today) |
| log / exp | Higher C via frexp/poly/ldexp — verified |
| General pow | Original path: specials (0/±1/±0.5/±2) then `exp(log(x)*y)` |
| Higher C | `c/8085/m32_*.asm` via **sccz80 only** |
| fmin/fmax | C `__z88dk_callee` (`m32_fminf` / `m32_fmaxf`) |
| pow/fmod callees | Rotate ret under args; call C; drop args |
| Suite `math.c` | `approx_equal` **before** multi-float snprintf |
| **Expanded mul** | `m32_fsmul24x32` / `m32_fsmul32x32` + kernel `m32_mulu_32h_32x32` |
| **Expanded add** | `m32_fsadd24x32` / `m32_fsadd32x32` + `m32_fsnormalize32` |

**Naming:** new 8085 sources = **`f32_*`**. Public symbols **`m32_*`**. Float packing **DEHL**.

**Headers (8085 only):** `feilipu, 2026 July` + MPL. Do **not** strip Digi headers on Z80 / `m32_fmodf.c`.

## Expanded format (Z80-compatible)

Unpacked / expanded float (same as Z80 math32):

| Field | Location |
|-------|----------|
| exp | **B** |
| sign | **C[7]** |
| mantissa (hidden 1) | **DEHL** 32-bit |

### ABIs

**`m32_fsmul32x32`**
- enter: Y in B/C/DEHL; stack = `X.hl, X.de, X.bc, ret` (caller: `push bc; push de; push hl` of X)
- exit: product B/C/DEHL; X removed; only ret on stack

**`m32_fsmul24x32`**
- enter: Y in B/C/DEHL; stack = IEEE `X.HL, X.DE, ret` (caller: `push de; push hl` of IEEE DEHL)
- exit: product B/C/DEHL; X removed

**`m32_mulu_32h_32x32`**
- enter: DEHL = x; stack = `ret, y.HL, y.DE`
- exit: DEHL = high 32 of product; y removed

### Implementation notes (`f32_fsmul32.asm`)

- Shared **`mul_body`** frame: `Y(6) | ret | X(6)`.
- 24x32: expand IEEE X, rebuild clean frame on top of junk, **high→low** copy if dest overlaps, raise SP.
- Epilogue: write product over X slot, drop Y+temps, extract with `ex (sp),hl` / `ex de,hl` — **never AF**.
- Multi-word push order: after `pop bc; pop de; pop hl` of W2/W1/W0, use `push bc; push de; push hl` so stack is W0,W1,W2 (top first).

## Root cause fixed (log/exp)

Higher C is sccz80 **left-to-right**: for `frexpf(x,&e)` / `ldexpf(x,pw2)` stack is

`SP = ret, second_arg, x.HL, x.DE`

Cores previously assumed SDCC/Z80 order (`ret, x, second_arg`) and/or clobbered mant LSW (HL) with the return address when scrubbing the frame. Symptoms: `log(4)` wrong, `exp(1)→0`, frexp fraction with garbage low word.

**Fix (aligned with am9511):**
1. Core `m32_fs{frexp,ldexp}_callee` — same order as am9511/Z80: `SP = ret, x.HL, x.DE, arg2`; body from am9511 (`ld de,sp+d`, `ld hl,(de)`, `add hl,hl`); scrub without AF.
2. `_m32_frexpf` / `_m32_ldexpf` — sccz80 reverse then `call` core (same as `cam32_sccz80_*_callee`).
3. `cm32_sccz80_fs{frexp,ldexp}{_callee,}` — reverse like am9511 for all CPUs (ret in HL, not AF).

## Open issues / next

| Item | Notes |
|------|--------|
| Expanded poly path | Optional; wire `fsmul24x32` / `fsadd24x32` like Z80 `f32_fspoly.asm` |
| `bench/` probe junk | Remove on port completion (keep `twide_nr` as regression) |
| Commit | NR accuracy fix + sqrt pack if not yet committed |

## 8085 pitfalls (keep)

1. **`rla` does not set Z** — never `rla; jp Z`.
2. **Never park data/return addresses in AF** — F bit 3 hardwired 0 (`$FFFF`→`$FF7F`).
3. **Callee drop flag = explicit 0/1 word**, not raw `push af`.
4. **Compare ABI:** two rets under left for `m32_compare*`.
5. **`l_f32_swap`:** use `asm/8085/f32_l_swap.asm` (4-byte block), not stock Z80 swap.
6. **sccz80 left-to-right** float args: often `ret, right, left` or for poly `ret, n, dptr, x`; frexp/ldexp `ret, arg2, x`.
7. **Stack-only** — no BSS in 8085 cores.
8. No `exx` / IX/IY / `djnz` / Z80 bit ops. Prefer `ld de,sp+*`, `rl de`, `ex de,hl`, `ex (sp),hl`, `ld hl,(de)`.
9. **NR inv/div landed** (`f32_fsdiv.asm`): seed poly + 3×NR via expand mul/add; `fsdiv` = inv×mul. **IEEE push order** for stack copies: DE word then HL (`push de; push hl`).
10. **Do not clobber HL (mant LSW) with ret** when scrubbing frexp/ldexp frames.
11. **Overlapping stack memmove:** copy high→low when dest > src and ranges overlap.
12. **Multi-word push order:** verify top-of-stack word with a depth diagram.
13. Skills: https://github.com/feilipu/8085-skills

## Layout

```
math32/asm/          # shared 8080-safe (coeffs, const)
math32/asm/z80/      # Z80 cores
math32/asm/8085/     # 8085 twins — f32_*
math32/c/8085/       # sccz80-generated higher funcs (make -C c 8085)
math32/c/sccz80/     # sccz80 bridges (some need 8085-safe rewrites)
```

## NR inv / sqrt (landed, accurate)

| Symbol | File | Notes |
|--------|------|--------|
| `m32_fsinv_fastcall` / `m32_fsdiv` | `asm/8085/f32_fsdiv.asm` | Seed poly; **one reserved `−D'`** (copy each NR step); 3× NR; pack `X.exp−oexp+126` + residual round |
| `m32_fsinvsqrt` / `m32_fssqrt` | `asm/8085/f32_fssqrt.asm` | Quake; one reserved `−y`; 3× NR; residual round pack |

**Accuracy fix:** do **not** consume stacked `−D'`/`−y` under ret each step — push a working copy (same as keeping one reserved). Consuming under-ret copies broke later NR iterations.

Verify:
```bash
make -C test/suites/math test_math32_8085.bin   # 16/16
# wide bench
cd libsrc/math/float/math32/bench
zcc +test -vn -clib=8085 -compiler=sccz80 -D__MATH_MATH32 -fp-mode=ieee --math32 \
  twide_nr.c twide_nr_a.asm -o twide_nr.bin && z88dk-ticks -m8085 twide_nr.bin
# expect: ALL 34 PASSED
```

## Next priorities

1. Optional: expanded poly; clean old `bench/t*` junk (keep `twide_nr`).
2. Commit if not on HEAD.
