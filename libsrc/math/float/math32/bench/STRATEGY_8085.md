# 8085 math32 critical-path strategy notes

Measured with `z88dk-ticks -m8085` (start/end labels around kernel call).

## Multiplication — 24×24 high-32 (IEEE mantissa / `m32_fsmul`)

| ID | Kernel | Dense `FFFFFF×FFFFFF` | Sparse `800000×800000` | Notes |
|----|--------|----------------------:|-----------------------:|-------|
| **A1** | 3× **24×8 unrolled** + lead-zero skip | **3096** | **1494** | **Shipped** as `f32_8085_mulu_32h_24x24.asm` |
| A2 | 3× 24×8 loop | — | — | Smaller code; keep under `bench/` if size build needed |
| A3 | 32h via zero-extended 32×32 | ~4074+ | — | Correct but slower; not used for IEEE mul |
| A4 | 9×8×8 schoolbook | — | — | Not competitive without HW 8×8 |

**Decision:** **A1** for production `m32_mulu_32h_24x24` / `m32_fsmul`.

Golden: `HLDE = (x*y) >> 16` for 24-bit unsigned x,y (top 32 of 48-bit product).

## Multiplication — 32×32 high-32 (poly / Newton / expanded mantissa)

| ID | Kernel | Dense `FFFFFFFF×FFFFFFFF` | Notes |
|----|--------|--------------------------:|-------|
| **B1** | 4× **16×16** (Runer112) + mid carries | **4074** | **Shipped** as `f32_8085_mulu_32h_32x32.asm` |

**Decision:** **B1** for `m32_mulu_32h_32x32`. Used by expanded float mul.

Golden: `DEHL = (x*y) >> 32`.

ABI: enter `DEHL=x`; stack `ret, y.HL=y0, y.DE=y1` (caller `push de; push hl` of y); exit high 32, y removed.

**Note:** Runer112 `mulu_32_16x16` bit0 path must use multiplicand bit0 in CF (not product overflow) — see Z80 original `rr e` / `ld e,a` sequence. 8085 emulates without `rr e` / `rl b`.

## Expanded mantissa mul (NR / accurate poly path) — **shipped**

| Symbol | File | Status |
|--------|------|--------|
| `m32_fsmul32x32` | `asm/8085/f32_fsmul32.asm` | **PASS** 3.0×2.0 → 6.0 expanded |
| `m32_fsmul24x32` | same | **PASS** IEEE 3.0 × exp 2.0 → 6.0 |
| `m32_fsadd32x32` / `24x32` | `asm/8085/f32_fsadd32.asm` | **PASS** 1+2, 2+2, 3+(−1), 1+(−1) |
| `m32_fsnormalize32` | `asm/8085/f32_fsnormalize32.asm` | **PASS** wide probe `tadd32c` |
| `m32_fsnormalize` (24-bit) | `asm/8085/f32_fsnormalize.asm` | **PASS** wide probe `tnorm24c`; fix: no `jp M` after `rla` |

Unpacked expanded: B=exp, C[7]=sign, DEHL=32-bit mant.  
24-bit unpack: H=0, mant L:D:E, B=sign, C=exp → IEEE DEHL.

Wide probes (bench, unstaged):
```bash
zcc +test -vn -clib=8085 -compiler=sccz80 -D__MATH_MATH32 -fp-mode=ieee --math32 \
  tnorm24c.c tnorm24c_a.asm -o tnorm24c.bin && z88dk-ticks -m8085 tnorm24c.bin
zcc +test -vn -clib=8085 -compiler=sccz80 -D__MATH_MATH32 -fp-mode=ieee --math32 \
  tadd32c.c tadd32c_a.asm -o tadd32c.bin && z88dk-ticks -m8085 tadd32c.bin
```

## Full `m32_fsmul_callee` (pack + mul + unpack)

| Case | Cycles |
|------|-------:|
| 3.0 × 3.0 (example finite) | **2702** |

Uses A1 mantissa mul; sticky LSB round; signed zero / Inf specials.

## Normalize (add path, later)

| Strategy | Status |
|----------|--------|
| Tree (Z80 port) | In tree `f32_fsnormalize.asm` |
| Simple loop | `bench/norm_loop.asm` optional ticks later |

## Tooling

```bash
export PATH=$HOME/Z80/z88dk/bin:$PATH
z80asm -m8085 -b -m -o=bench.bin bench.asm
z88dk-ticks -m8085 bench.bin -x bench.map -start start -end end
```

## Files

| File | Symbol |
|------|--------|
| `asm/8085/f32_8085_mulu_32h_24x24.asm` | `m32_mulu_32h_24x24`, `m32_sqr_32h_24x24` |
| `asm/8085/f32_8085_mulu_32h_32x32.asm` | `m32_mulu_32h_32x32` |
| `asm/8085/f32_fsmul.asm` | `m32_fsmul`, `m32_fsmul_callee` |


## Addition / div / conv / compare (Phase 1C)

| Op | File | Status |
|----|------|--------|
| add/sub | `f32_fsadd.asm` | **Goldens pass** (`bench/test_fsadd.asm`) |
| div/inv | `f32_fsdiv.asm` | **Goldens pass** — 24-bit restoring (not Newton) |
| conv | `f32_fsconv.asm` | **Goldens pass** |
| compare | `f32_fscompare.asm` | **Goldens pass** — watch 8085 `rla` not setting Z |

Normalize pack (`normdone0`) was fixed: must place exp in H before sign merge.

## Phase 2 — sqr / ldexp / sqrt / poly

| Op | File | Status |
|----|------|--------|
| sqr | `f32_fssqr.asm` | **Goldens pass** (RNE, save exp across mul) |
| ldexp | `f32_fsldexp.asm` | Ported (stack-only) |
| invsqrt/sqrt | `f32_fssqrt.asm` | **Goldens pass** — Quake + 3×NR via fsmul/fsadd/fsdiv2 |
| poly | `f32_fspoly.asm` | **Goldens pass** — Horner with fsmul/fsadd |

### Div strategy gate (6.0 / 3.0, z88dk-ticks -m8085)

| Path | Cycles | Result |
|------|-------:|--------|
| **Restoring `fsdiv_callee`** | **12021** | 2.0 |
| `fsinv` (restoring) + `fsmul` | 17310 | 2.0 |

**Decision:** keep **restoring `fsdiv`**. Inv+mul only wins if inv is a true NR-class reciprocal (not another restoring divide). Revisit when/if a Newton `fsinv` is added.

### Callee flag pitfall (mul/add/div)

Do **not** `push af` for the callee drop flag and then read the **F** byte: when F==0 (common after bit-hack / `or a`), left is not dropped and the stack corrupts. Store an explicit word `L=0/1` via `push bc` after `ld b,0; ld c,a`.
