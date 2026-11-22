# ADR 0055 — A deref through a `&symbol` base becomes an absolute load

Status: **Accepted**, default on. `--opt-disable=sym-deref-fold` opts out.

Sibling of `ir_opt_sym_addr_fold`: that one folds the **address** form
(`&g + K` into one symbol immediate); this folds the **deref** of such an
address into the absolute `IR_MEM_SYM` load the same access gets when the
frontend sees it directly.

## Context

```
g.b                 ->  LD_MEM sym[&g+202]   ->  ld hl,(_g+202)     3 B
p = &g; ... p->b    ->  LD_MEM [v15+202]     ->  ld hl,_g+202       7 B
                                                 ld a,(hl+)
                                                 ld h,(hl); ld l,a
```

Both name the same link-time-constant address, so the second form is pure loss —
**4 bytes and ~20 T a site**. It appears whenever the base survives as its own
vreg: a `&g` that LICM hoisted to a preheader, or one CSE shared between several
member reads. `test/framework/test.c`, which is linked into **every** benchmark
binary, takes it **14 times** for `suite.setup` / `suite.teardown` / `suite.tests`.

## Decision

Rewrite `LD_MEM dst, [v + K]` to `LD_MEM dst, sym[&g + (o + K)]` when `v` has
exactly one def and that def is `LD_SYM &g + o`. The base vreg's use goes away;
when every use folds, DCE reclaims the `LD_SYM` and the allocator drops its slot.

Single-def is **function-wide**, for the same reason `sym_addr_fold`'s is: the
`LD_SYM` has usually been hoisted out of the block that derefs it.

## Exclusions, each of which would be a miscompile

* **`post_step != 0`** — the base is `p++`-stepped after the load. The absolute
  form has no base to step, so folding would silently drop the increment.
* **`bank_fn`, on the deref or the symbol** — an `__addressmod` access must call
  the page-in function, and the two mem kinds recover the namespace differently.
* **a symbol whose `ir_sym_prefix()` is not `_`** — the `IR_MEM_SYM` lowering
  hardcodes the underscore where `gen_ld_sym` asks. Only `__LIB__` FUNC symbols
  differ and their address is not dereferenced as data, but this routes *new*
  traffic onto that path, so do not rely on it.
* **a negative total offset** — it addresses outside the object, and the
  lowering spells the offset `+%d` (`_g+-4`).

`elem` and `volatile_` are preserved: the fold changes how the address is
formed, never the width or the number of accesses.
