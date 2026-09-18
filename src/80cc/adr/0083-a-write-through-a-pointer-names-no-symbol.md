# ADR 0083 — A write through a pointer names no symbol

Status: **Accepted**. A correctness fix, so it is **not gated**.

## Context

ADR 0082 closed one instance of a belief that only a redefinition cleared, in
`ir_opt_const_fold`, and said the same hole might be open elsewhere. It was —
in four more places, across three passes, and **two of them were wrong on
plain C with no address of a local anywhere in the function.**

The frontend spells a write's destination two different ways, and they collide
on `OP_DEREF(LOCAL_VAR)`:

```
a = v       (= (lv=a) v)                     OP_ASSIGN's left is an ADDRESS
*p = v      (= (deref (lv=p)) v)             ...so one deref is INDIRECT
a += v      (+= (deref (lv=a)) v)            a compound's left is an LVALUE
*p += v     (+= (deref (deref (lv=p))) v)    ...so one deref is DIRECT
```

`cse_walk_lvalue` served both operators and read the shape the compound way.
So for `*p = v` it believed a write of **p**:

* it invalidated `p`, which the store does not touch, and left standing every
  belief about what **p points at** — and
* the caller then **recorded the stored expression against `p`**, so

  ```c
  *p = a + x;        /* records (a + x) -> p */
  t  = a + x;        /* substituted: t = p  */
  ```

  handed `t` **the pointer**. `f(&slot, 3, 4)` returned `2028`, not `7`.

Three more, all the ADR 0082 shape — a call or an indirect store writes memory
without naming a symbol, and nothing was invalidated:

| where | what it did |
|---|---|
| `ir_opt_cse` | its table is invalidated by a **vreg write**. A call handed a local's address writes the local's **slot**, defining no vreg. `t1 = a + x; bump(&a); t2 = a + x;` → `t2 = t1` |
| `ast_cse_synthesize` | hoisted a shared subexpression to the top of a segment when no statement **directly** wrote a symbol it reads — an indirect store writes none |
| `ast_licm` | hoisted a loop invariant over an indirect store in the body, for the same reason |

A constant initialiser **hid** the `ir_opt_cse` case: const-fold rewrites the
first `a + x` into an immediate form (`ADD v0, imm=2`) that no longer matches
the second, so the table misses. It takes a non-constant initialiser to see it.

## Decision

One set of aliasing facts, computed per function in `ast_opt.c` and used by
every pass that holds a belief about a value.

**An address is not a value.** In this frontend a bare `(gv=g)` / `(lv=a)`
node IS an address, and a read of the object is a DEREF of one. No store can
change an address, so the question a pass must ask is not "does this candidate
mention a global" but "does it dereference anything a store could reach":

* `aopt_escaped` — every local whose address is taken **anywhere** in the
  function, collected in a pre-pass at `ast_opt_run` entry. An escape in an
  earlier statement still aliases this one, so a set built lexically during the
  walk is not enough.
* `aopt_write_is_indirect(lhs, addr_form)` — the spelling table above, with
  `addr_form` = 1 for `OP_ASSIGN` and 0 for the compound operators. This is
  the disambiguator the two spellings needed.
* `aopt_has_indirect_write(region)` — a call **or** a store through a computed
  address makes memory opaque.
* `aopt_reads_aliased_mem(expr)` — true unless every deref in `expr` is a
  non-escaped local's own lvalue. That is what an opaque write can have
  changed; `arr + i*6` is not.

Per pass:

* `cse_walk_lvalue` takes `addr_form`. Under `OP_ASSIGN` an `OP_DEREF`
  destination is reported as **indirect**: nothing is recorded against the
  pointer, and the env loses exactly its aliased half
  (`cse_env_invalidate_aliased`) rather than all of it.
* `ir_opt_cse` never **records** an entry whose operands — or whose result
  vreg — are `IR_VREG_ADDR_TAKEN` or `IR_VREG_VOLATILE`. This is ADR 0082's
  choice one pass along: an escaped local is spilled anyway, so the folding
  given up is small next to the cost of enumerating every op that can write
  through a pointer.
* `ast_cse_synthesize` (both pickers) treats an indirect store as exactly as
  opaque as a call, and asks `aopt_reads_aliased_mem` instead of "reads a
  global".
* `ast_licm` does the same for a loop body, and extends the `has_call` rule
  from globals to globals **and escaped locals**.

## Consequences

* the five reproducers agree with gcc in both frame modes, on z80, 8080,
  gbz80, 8085, ez80 and r4k
* `long_ir` **809/809 in both frame modes** (the seven new targets included);
  `enigma` prints `RXSEC` and `emu.c` scores its two `On The Path` hits, both
  in both modes
* corpus, 720 cells: **+497 bytes, 24 cells larger, 24 smaller**. Every larger
  cell is `md5`, which loses CSE across its pointer stores (+672); every
  smaller cell is `sortbench` (−175), which gains from the address-vs-value
  distinction the old "reads a global" test did not draw. Real files are
  level: `clisp` −7 fp / +3 sp, `adv_a` byte-identical in both modes
* the half that must keep working is pinned by value, not by reading asm: a
  write to a bare local still invalidates only that local, and `a += k` still
  means a write of `a` itself

Regression test `test/suites/long_ir/aliaswr.c`, seven targets. It fails on the
pre-change compiler and passes after.

**What was audited and is clean**, so a future sweep need not redo it:
`ast_const_propagate` (clears the whole env on any call, and invalidates its
escaped set on an `OP_DEREF` destination), `ast_dse` (has always had a proper
escape pre-pass), `ir_opt_addr_cse`, `ir_opt_coalesce_copies`, the `ivsr` /
`lftr` / `narrow-byte` / `reassoc` family (all already refuse
`IR_VREG_ADDR_TAKEN`), and the lowerer's register beliefs — probed with byte,
word and long locals, array and struct aliases, a global written through a
pointer, a pointer stored in a global and written by a later call, an escaped
array index, loops, and `volatile`, in both frame modes. The probes are
throwaway; the five shapes worth keeping are in `aliaswr.c`.
