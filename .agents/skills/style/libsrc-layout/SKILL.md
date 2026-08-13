---
name: style-libsrc-layout
description: >
  z88dk libsrc house rule: one major function (or one logical operation) per
  source file, including CPU-specific copies. Use when adding, splitting, or
  reorganising library asm/C under libsrc.
---

# Style — libsrc one major function per file

## 0. Library source layout — one major function per file

House style across z88dk **`libsrc/`** (classic and newlib): **one major function
(or one logical operation) per source file**. Do not invent a different layout
when adding or splitting library code.

### What counts as “one major function”

| In one file | Separate files |
|-------------|----------------|
| The operation’s public entry (or entries) | Unrelated operations (e.g. mul vs add) |
| **Callee** and non-callee / sccz80–sdcc glue for that op when they live with the core | Different ops “to save files” |
| f16 + f24 (or similar) variants of the **same** op | Pack/expand family may share a conversion file if that is the existing pattern for that library |
| Helpers that belong only to that op (local or `PUBLIC` if other modules call them) | Helpers that are really a second feature → own file |

Examples (math16-style, but the rule is general):

- `asm_f16_mul.asm` — half mul callee, f24 mul, integer mulu helper  
- `asm_f16_add.asm` — add/sub callee + f24 add  
- `asm_f16_compare.asm` — compare + compare_callee  

### Agent rules

1. **Match neighbours** in the same directory: filename ≈ symbol / operation name.
2. **Do not** merge unrelated ops into one `.asm`/`.c` to share a few lines.
3. **Do not** split a single op across files just to isolate a 10-line helper unless the tree already does that.
4. CPU-specific copies (`asm/z80/`, `asm/8085/`, `l/sccz80/7-8085/`, …) keep the **same one-op-per-file map**; implementations may differ by ISA, not by inventing a parallel file taxonomy.
5. List files (`.lst`) and products reference modules by path — one op per file keeps nm/map/hotspot attribution sane.

This is an **implicit z88dk library requirement**, not a math16-only note. Apply it to sccz80 runtime, float cores, target drivers, and new work under `libsrc/`.

---

## Related

- Math32 multi-CPU map: `library/math32`
- Classic vs newlib: `library/classic`, `library/newlib`
