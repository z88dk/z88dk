# PLAN — `-debug`: home named locals in their frame slot (local visibility)

Status: IMPLEMENTED (task 4). Goal: under `-debug`, every named C local is
readable at any source-line breakpoint.

Landed deviations from the sketch below: the memory-home mechanism is
**`IR_VREG_ADDR_TAKEN`**, not `VOLATILE`/a new flag — 80cc legitimately elides
never-escaped locals *including volatile ones* (register value, no store), so
only "escaped" (address-taken) forces a coherent slot that survives every pass.
No `forced_memory()` refactor was needed. cdb offsets are emitted post-lowering
from `vreg_spill_slot - frame_size` (locals) / front-end `sym->offset.i` (params,
frame-independent) in `ir_lower_to_output`; parse-time STKLOC emission is
deferred (`cdbfile.c`). Verified z80(IX)+8080+gbz80: locals, params, and
reassignment all resolve (`p s`==14 after `s=s+1`); suite byte-identical off.

--- original sketch ---

## Why it fails today

Two independent gaps:

1. **The value isn't in the slot.** 80cc's lowering is register/accumulator
   first. A local that fits in a register is never written to memory (even with
   `--opt-disable=all`: `int s=a+b+c` flows through DE/TOS into the next
   expression and is never stored to `ix-2`). So the cdb `,B,1,-2` points at a
   slot that holds nothing.
2. **The cdb offset is a guess.** `debug_write_symbol` runs at *parse* time
   (`sym.c` `addloc`) and emits `,B,1,<sym->offset.i>` — the front-end nominal
   frame offset, computed before the IR backend lays out the frame. It does not
   match the backend's actual slot placement (`vreg_spill_slot` / `slot_ix_off`).

## Architecture facts this plan relies on

- **One local = one vreg.** `ir_build.c` keeps a `sym_map` (SYMBOL* → vreg id);
  `s = a; s = b;` reuse the *same* vreg. So a named local is a single vreg with
  `VReg.sym != NULL` — one slot, one cdb record. (Compiler temps have `sym==NULL`;
  params carry `IR_VREG_PARAM`.)
- **`needs_slot`** (`ir_slots.c`) is 1 unless the vreg is register-resident
  (`vreg_to_phys[v] != IR_PR_SPILL`). Force a local to `PR_SPILL` ⇒ it gets a slot.
- **Slot sharing.** `ir_assign_slots` first-fits non-interfering same-width vregs
  into shared slots; `IR_VREG_PARAM`/`ADDR_TAKEN` are *pinned* (pass 0,
  `slot_excl`, own slot). Named locals are not pinned today.
- **`slot_ix_off(f, v)`** (`ir_lower.c:728`) already returns a slot's ix-relative
  offset (`vreg_spill_slot - frame_size`, locals negative) — the exact `(ix+d)`
  the code addresses through, hence the exact number the cdb `,B,1,d` needs.
- **Coherence machinery already exists.** `IR_VREG_VOLATILE` = "every access is a
  memory op": forces a slot, no residency, no lazy-spill deferral, no dead-store
  elision, and volatile stores are `;volatile`-stamped so copt keeps them.
- **Frame base is in place.** `-debug` already forces IX (or the
  `__debug_framepointer` chain on no-IX CPUs); `slot_ix_off` is relative to that
  base, and ticks resolves `,B,1,d` against it.

## Design

A **debug-home** mode for named locals, gated on `c_debug_adb_defc`, perf
irrelevant. Introduce a predicate `is_debug_home(f, v)` = `c_debug_adb_defc &&
f->vregs[v].sym != NULL && !(flags & (IR_VREG_PARAM | IR_VREG_PARAM_IN_PLACE))`
(i.e. a true body local). Give such vregs the same treatment `IR_VREG_VOLATILE`
gets, via a shared helper `forced_memory(v) = VOLATILE || DEBUG_HOME` at the
handful of sites that test `IR_VREG_VOLATILE`. Prefer a **new flag
`IR_VREG_DEBUG_HOME`** over reusing VOLATILE, to avoid overloading volatile's
MMIO semantics — but the code paths are the volatile ones.

Effect: each named local is slot-homed, never register-resident, stored on every
def and reloaded on every use ⇒ its slot is coherent at every op boundary, hence
at every C_LINE / breakpoint.

## Implementation steps

1. **Flag + predicate.** Add `IR_VREG_DEBUG_HOME` to `VRegFlags` (`ir.h`). Add
   `forced_memory(vr)` in `ir_build.c`/`ir_lower.c` = `VOLATILE || DEBUG_HOME`.
   Set `DEBUG_HOME` on body-local vregs at creation (`new_local_vreg`, when
   `c_debug_adb_defc`), or in a post-build pass over `sym_map`.

2. **Route the volatile code paths through `forced_memory`.** Every builder /
   lowerer / slot site currently gated on `IR_VREG_VOLATILE` (memory-access
   emission, residency exclusion, lazy-spill skip, dead-store-elision skip,
   `vol_stamp`) also honours `DEBUG_HOME`. Grep `IR_VREG_VOLATILE` and convert.

3. **Force `PR_SPILL` + pin the slot.** In the allocator (`ir_alloc.c`), skip
   register residency for `DEBUG_HOME` vregs. In `ir_slots.c`, add them to the
   pinned set (pass 0, `slot_excl`) so each keeps a dedicated, stable offset
   across its whole scope (no first-fit sharing → no cross-scope aliasing of the
   `,B,1,d` record). Frame grows; fine for debug.

4. **Reconcile the cdb offset (the crux) — defer local emission to post-lowering.**
   - In `sym.c` `addloc`, **skip** the STKLOC `debug_write_symbol` call when
     `c_debug_adb_defc` (params keep parse-time emission — they already resolve
     exactly via `sym->offset.i`, verified). Only true body locals move.
   - After a function is lowered (slots + `frame_size` + frame base final), walk
     its `DEBUG_HOME` vregs and emit each `S:L…,B,1,<d>` with
     `d = slot_ix_off(f, v)` — the real ix-relative offset. Reuse `sym->name`,
     `sym->level`, `sym->scope_block`, `sym->ctype` for the record body (same
     format as `debug_write_symbol`'s STKLOC branch; factor that body out so both
     paths share it).
   - No-IX CPUs: `slot_ix_off` is relative to the saved-fp slot, which is where
     `l_debug_push_frame` points `__debug_framepointer` — so the same `d` is
     valid there (confirm the ±sign against `param_caller_off`'s layout).

5. **Gating / soundness.** All behind `c_debug_adb_defc`; with `-debug` off,
   `DEBUG_HOME` is never set → byte-identical (ADR 0004). No new copt exposure
   (debug-home stores are `;volatile`-stamped like volatile).

## Open questions / risks

- **`slot_ix_off` sign & base vs no-IX.** Verify the cdb `d` from `slot_ix_off`
  matches what ticks computes against `__debug_framepointer` (built by
  `l_debug_push_frame`) as well as against IX. One end-to-end check per family.
- **Aggregate / addr-taken locals.** Already slot-homed (ADDR_TAKEN pinned);
  make sure the deferred emission covers them and doesn't double-emit.
- **Lexical scope blocks.** Keep `sym->scope_block`/`level` in the record so the
  debugger's `debug_symbol_valid` scoping still distinguishes same-named locals
  in sibling blocks (pinning already prevents slot aliasing, but the scope info
  should stay correct).
- **Params.** Leave as-is (parse-time, `sym->offset.i`) — verified correct. Only
  revisit if the deferred path is unified for consistency.
- **Frame size blow-up** on large functions (every local pinned) — acceptable for
  `-debug`; note it, don't optimise.

## Test plan

- `test/suites/long_ir`: a debug-locals test compiled `-debug`, driven through
  `z88dk-ticks -d -x <map>`: break at successive C_LINEs, `info locals` / `p s`,
  assert the printed values match after each assignment. Cover z80 (IX) + 8080 +
  gbz80 (`__debug_framepointer`), scalars + a reassigned local + nested-scope
  same-named locals + a long.
- Regression: full suite `COMPILER=80cc` non-debug must stay byte-identical.

## Not in scope

PC-ranged `R` (register) location records — a value's register home is per
live-range, which cdb can't cleanly encode, and ticks' `parse_address_space`
only handles B/C/E/Z. Debug-home sidesteps this by making the slot the single
stable home. (See the register-record discussion; deferred.)
