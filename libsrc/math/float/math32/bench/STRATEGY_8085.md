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

**Decision:** **B1** for `m32_mulu_32h_32x32`. Required for poly accuracy (`m32_fsmul24x32` / `m32_fsmul32x32` later).

Golden: `DEHL = (x*y) >> 32`.

ABI: enter `DEHL=x`; stack `ret, y.HL=y0, y.DE=y1` (caller `push de; push hl` of y); exit high 32, y removed.

**Note:** Runer112 `mulu_32_16x16` bit0 path must use multiplicand bit0 in CF (not product overflow) — see Z80 original `rr e` / `ld e,a` sequence. 8085 emulates without `rr e` / `rl b`.

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
