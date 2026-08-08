---
name: library-math32
description: >
  math32 IEEE single float library: multi-CPU layout (asm/z80 vs asm/8085),
  products math32*.lib, rounding policy, div=restoring / inv=NR, force rebuild.
  Use when editing libsrc/math/float/math32 or A/B float divide/mul.
---

# Library — math32

Home: `libsrc/math/float/math32/`. Docs of record: `libsrc/math/float/math32/readme.md`.
Link via **`--math32`** (`-lmath32@{ZCC_LIBCPU}`).

## 0b. Math32 multi-CPU float library (layout + policy)

Home: `libsrc/math/float/math32/`. Products: `math32.lib` (plain z80) plus
`math32_{z80n,z180,r2ka,kc160,8085,…}.lib`. Link via **`--math32`**
(`-lmath32@{ZCC_LIBCPU}` — 8085 selects `math32_8085` automatically; no separate
`--math32_8085` flag).

### Layout

| Tree | Role |
|------|------|
| `asm/z80/` | Z80-family cores; shared by z80n/z180/r2ka/… when the lst points here |
| `asm/8085/` | Stack-only 8085 cores (no EXX / IX / IY); extended opcodes + synthetics |
| `c/asm/`, `c/8085/` | Higher functions (C → precompiled asm); 8085 higher via sccz80 only |
| `newlibfiles_*.lst` | Which modules land in each product |

**CPU-specific** = same *operation* name, different ISA file (same one-op-per-file
map as §0). Do not invent a second taxonomy for 8085.

### Rounding policy (do not mix casually)

| Class | Policy (current math32) |
|-------|-------------------------|
| **mul / sqr / div / poly / sqrt pack** | **IEEE RNE** on residual below the kept mantissa |
| **add / sub** | **Digi jam-sticky**: lost align/overflow bits → OR **1** into mant LSB; pack has no RNE residual |

Long add chains (e.g. n-body energy) are sensitive to add rounding: jam keeps
second-energy error ~1e−6 class; full RNE-on-add has been measured to worsen E1
(~5e−5 class) at higher cost. Prefer matching z80 and 8085 **policy** even when
engines are not bit-identical.

### Divide / inverse (current policy)

| Op | Algorithm | Notes |
|----|-----------|--------|
| **`div` / `m32_fsdiv`** | **Restoring** 24-bit mantissa | z80 + **8085** cores; z80n/z180 share z80 `asm/z80/f32_fsdiv.asm` |
| **`inv` / `m32_fsinv`** | Newton–Raphson | Still mul-heavy; HW mul helps inv only |
| math16 | Same split: restoring `asm_f16_div`, NR `asm_f16_inv` | |

Do **not** reintroduce NR trampoline `fsdiv` = `fsinv`+`fsmul` without A/B proof.
Docs: `math32/readme.md` § div/inv; measurement: **z88dk-tooling** § A/B.

### Micro-opt patterns that port

| Pattern | Idea | Notes |
|---------|------|--------|
| Implicit-1 CF | `ld a,255` / `add a,h` → CF=(exp≠0) instead of `or a` / `jr Z` / `scf` | ~8–9 T per unpack; works on Z80 and 8085 |
| Z80 non-callee stack load | 3×`pop` + 3×`push` vs `hl=sp+2` walk | ~8 T; 8085 stack-slot paths already different |
| Hot tiny helpers | Inline 2–4 insn jam sticky at call sites | Saves call/ret; size often net-neutral or smaller |
| Unused stack pad | Drop frame slots only after proving no SP offsets still use them | Remeasure; fix every `sp+N` comment |

Callee linkage: float helpers that pop a return address + stack args must be
**`call`’d**, not bare **`jp`** (floor/ceil class bugs). Keep that rule when
editing pack/add glue.

**Measure / rebuild / wiki:** **[z88dk-tooling](../z88dk-tooling/SKILL.md)**
(§ math32 rebuild, benches, wiki bold rules). Docs of record:
`libsrc/math/float/math32/readme.md`, `support/benchmarks/*/readme.txt`.

---

## Force rebuild (multi-CPU)

### Math32 / multi-CPU float libs (force rebuild)

Sources: `libsrc/math/float/math32/` (per-CPU under `asm/z80/`, `asm/8085/`, …).
Shared Z80-family add lives in `asm/z80/d32_fsadd.asm` and is assembled into
**each** of `math32.lib`, `math32_z80n.lib`, `math32_z180.lib`, `math32_r2ka.lib`,
`math32_kc160.lib`, … Changing that file requires **rebuilding every product that
lists it**, not only `math32_8085.lib`.

```bash
cd libsrc/math/float/math32
# force one object + relink (example: 8085 add)
rm -f obj/8085/math/float/math32/asm/8085/f32_fsadd.o ../../../math32_8085.lib
z88dk-z80asm -d -I"$ZCCCFG/.." -O=obj/8085/x/x/x -I.. -m8085 -D__CLASSIC \
  @newlibfiles_8085.lst
TYPE=8085 z88dk-z80asm -d -I"$ZCCCFG/.." -I.. -m8085 \
  -x../../../math32_8085 @math32.lst
cp -f ../../../math32_8085.lib ../../../lib/clibs/   # or: make -C libsrc install

# Z80-family products that share asm/z80/d32_fsadd.asm (repeat per CPU)
for cpu in z80 z80n z180 r2ka kc160; do
  lst=newlibfiles_${cpu}.lst
  case $cpu in z80) lst=newlibfiles_z80.lst; lib=math32 ;;
    *) lib=math32_$cpu ;; esac
  rm -f obj/$cpu/math/float/math32/asm/z80/d32_fsadd.o ../../../$lib.lib
  z88dk-z80asm -d -I"$ZCCCFG/.." -O=obj/$cpu/x/x/x -I.. -m$cpu -D__CLASSIC @$lst
  TYPE=$cpu z88dk-z80asm -d -I"$ZCCCFG/.." -I.. -m$cpu -x../../../$lib @math32.lst
  cp -f ../../../$lib.lib ../../../lib/clibs/
done
```

Or: `make -C libsrc/math/float/math32` then install all `math32*.lib` into
`lib/clibs/`. After install, **delete** suite/bench `.bin`/`.map` before remeasure.

Prove the object is current: `z88dk-z80nm lib/clibs/math32_8085.lib | rg 'f32_fsadd|ay16_njam'`.

---

## Related

- Half float: `library/math16`
- Measure / A/B: `methodology/measure`
- 8085 cores: `cpu/8085`
