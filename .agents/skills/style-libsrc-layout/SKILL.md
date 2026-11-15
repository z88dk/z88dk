---
name: style-libsrc-layout
description: >
  z88dk libsrc house rule: one major function (or one logical operation) per
  source file, including CPU-specific copies. Every code, rodata, data, or
  bss block names a CRT section. A file may hold several sections when code
  and data are mixed. Use when adding, splitting, or reorganising library
  asm/C under libsrc.
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

## CRT section on every block

Every code, rodata, initialized-data, or uninitialised block has a `SECTION` before its first byte. With no section, those bytes sit in `""` and the linker leaves them in an unordered place.

Take the name from the CRT section list for classic or newlib. Prefer a name that is on both lists.

| Kind | Classic | Newlib | Names on both, for a driver |
|------|---------|--------|------------------------------|
| Code | `lib/crt/classic/crt_section_code.inc` | `lib/crt/newlib/crt_memory_model_z80.inc` and the z180 model | `code_driver`, `code_clib`, `code_compiler`, `code_user` |
| Constants | `crt_section_rodata.inc`. `rodata_driver` is in the code list so it stays in low memory | inside `CODE` in the same memory model | `rodata_driver`, `rodata_clib`, `rodata_compiler`, `rodata_user` |
| Initialized data | `crt_section_data.inc` | `DATA` in the memory model | `data_driver`, `data_clib`, `data_compiler`, `data_user` |
| Uninitialised, zeroed | `crt_section_bss.inc` | `BSS` in the memory model | `bss_driver`, `bss_clib`, `bss_compiler`, `bss_user` |

There is no separate code-uninitialised section. Storage that must survive the call, and that the CRT zeroes, is a `bss_*` section. `defb` / `defw` the program writes is `data_*`. Bytes that are only read are `rodata_*`.

A file may contain more than one `SECTION`. Switch when code and data are mixed in that file. Do not leave the code unsectioned because a later data block already has a section. Do not put a writable or constant block in the code section just to keep one name for the file.

```asm
    SECTION code_driver

    ret

    SECTION data_driver

slot:
    defb    0
```

Keep a constant in the code section when a `jr`, `jr cc`, or `djnz` in that file spans it. Those branches stay in one file and one section. `INCLUDE` text is that same unit and keeps the parent's section. Do not put a `SECTION` in an include that the parent includes after choosing one. A `ld hl,name` of a label in another section is a normal relocatable address.

Do not invent a name the CRT lists do not contain.

---

## Related

- Math32 multi-CPU map: `library-math32`
- Classic vs newlib: `library-classic`, `library-newlib`
