/*
 * ir_opt.h — IR-level optimisation passes.
 *
 * Run between ir_build and the analysis/allocator pipeline. Each pass
 * mutates a `Func *` in place.
 *
 * Decoupled from compiler internals — links against ir.c + ir.h only.
 */
#ifndef IR_OPT_H
#define IR_OPT_H

#include "ir.h"

/* Store-to-load forwarding + redundant-load elimination + dead-store
 * elimination — the three sub-passes share one shadow table.
 *
 *   3a — IR_ST_MEM addr, %v; ... IR_LD_MEM addr → %t  becomes
 *        IR_MOV %t <- %v (LD_MEM dropped to a register move).
 *
 *   3b — IR_LD_MEM addr → %t1; ... IR_LD_MEM addr → %t2  becomes
 *        IR_MOV %t2 <- %t1 (second load dropped to a register move).
 *
 *   3c — IR_ST_MEM addr, %v1; ... IR_ST_MEM addr, %v2  with no
 *        memory-touching read of `addr` in between drops the first
 *        store outright. (Forwarded reads don't keep the first store
 *        alive — they read the vreg directly, not memory.)
 *
 * Invalidation: IR_CALL / IR_HCALL / IR_ASM wipe the shadow; a
 * non-matching IR_ST_MEM drops alias-risk entries; writes to a tracked
 * base or stored vreg drop the matching entry. Volatile ops are never
 * tracked.
 *
 * Tracks IR_MEM_SYM (sym+offset) and IR_MEM_VREG (base+offset). Per-BB
 * only — the table resets at each BB boundary.
 *
 * Returns the number of LD_MEM ops rewritten plus the number of
 * ST_MEM ops eliminated.
 */
int ir_opt_st2ld(Func *f);

/* Arithmetic CSE (roadmap #3d).
 *
 * Per-BB common-subexpression elimination over the deterministic
 * arithmetic / comparison op set. Tracks (kind, src0, src1, imm,
 * width) → dst-vreg per BB. When a later op matches an existing entry,
 * the op is rewritten to IR_MOV from the prior dst.
 *
 * Eligible ops:
 *   IR_ADD, IR_SUB, IR_AND, IR_OR, IR_XOR, IR_SHL, IR_SHR
 *   IR_NEG, IR_NOT
 *   IR_CONV_ZX, IR_CONV_SX, IR_CONV_TRUNC, IR_CONV_BYTE_TO_HIGH
 *   IR_ROTL, IR_ROTR
 *   IR_CMP_*  (EQ/NE/LT/LE/GT/GE plus unsigned variants)
 *
 * Not eligible:
 *   IR_INC, IR_DEC — aliased mutation, not pure-functional.
 *   IR_MOV, IR_LD_IMM, IR_LD_*, IR_ST_*, IR_LEA — no value-recomputation gain.
 *   IR_CALL, IR_HCALL, IR_ASM, IR_BR_*, IR_RET, IR_CRITICAL_* — control flow / side effects.
 *
 * Invalidation: any write to a vreg (op->dst, or IR_CALL/IR_HCALL's
 * ret_vreg) invalidates entries whose src0/src1/dst equal that vreg.
 * IR_ASM wipes the table (unknown clobbers). No cross-BB tracking.
 *
 * Returns the number of ops rewritten to IR_MOV.
 */
int ir_opt_cse(Func *f);

/* Loop-invariant code motion (roadmap #3e).
 *
 * Detects loops via back-edge scan (a successor with id ≤ current BB
 * id is a back-edge into a loop header). For each loop with a unique
 * natural pre-header (the header's only outside predecessor), hoists
 * invariant ops from the body to just before the pre-header's
 * terminator.
 *
 * Current scope: constant/address-load ops that are always invariant
 * regardless of source vregs:
 *   IR_LD_IMM, IR_LD_SYM, IR_LD_STR, IR_LEA
 * (LEA's source is a local whose address is computed as sp+slot — the
 *  computation is invariant across the function lifetime.)
 *
 * Skips: arithmetic ops (extension), loops with multiple outside
 * predecessors (would need a synthesised pre-header), volatile ops.
 *
 * No cross-loop hoisting: a vreg hoisted out of one loop isn't
 * re-hoisted to an outer loop's pre-header. Future work.
 *
 * Returns the number of ops hoisted.
 */
int ir_opt_licm(Func *f);

/* Induction-variable strength reduction (roadmap #3f).
 *
 * For a natural loop with a unique pre-header and single latch, replaces
 * a recomputed indexed address `base + iv*scale` (the `SHL iv,s; ADD
 * base,t` an `a[i]`/`s[i].f` walk emits each iteration) with a stepped
 * pointer `p`: `p = base + K*scale` in the pre-header, `p += step*scale`
 * in the latch, every address use rewritten to `p`, the SHL/ADD NOPed.
 * The basic IV is left driving the exit test (no LFTR yet).
 *
 * Conservative — bails unless: the basic IV has one self-step in-loop
 * def + one LD_IMM pre-header init; the scale is 1 or a power of two; the
 * base is loop-invariant; the derived address is single-def, not
 * live-out, and every use is redirectable. IR_NO_IVSR opts out.
 *
 * Runs after LICM (loops found, invariants hoisted so `base` is clearly
 * invariant) and before CSE/DCE (CSE dedups duplicate inits, DCE clears
 * the NOPed SHL/ADD). Returns the number of derived IVs reduced.
 */
int ir_opt_ivsr(Func *f);

/* sym_offset_fold and vreg_offset_fold live in the ir_match table as
   symoff / vregoff_sym / vregoff_imm / vregoff_idx;
   --opt-disable=pattern:symoff etc. */

/* pack_bytes (little-endian 4-lane byte-pack → width-4 LD_MEM) lives
   in the ir_match packbytes phase as `packbytes`;
   --opt-disable=pattern:packbytes. */

/* extract_byte (SHR/AND/TRUNC chains → IR_EXTRACT_BYTE) lives in the
   ir_match late phase as xbyte / xbyte_b0 / xbyte_shr;
   --opt-disable=pattern:xbyte etc. */

/* fuse_poststep (MOV+INC/DEC → IR_POSTSTEP) lives in the ir_match
   early phase as the `poststep` pattern;
   --opt-disable=pattern:poststep. */

/* Dead pure-op elimination: side-effect-free ops whose dst has zero
 * function-wide uses, iterated to a fixed point. Returns removals. */
int ir_opt_dce(Func *f);

/* Remove basic blocks unreachable from the entry (bb 0). ir_build leaves
 * dead split/forwarding BBs behind; a dead BB whose id sits below its
 * successor forges a spurious back-edge, inflating the loop-depth /
 * back-edge scans that LICM and ir_alloc's residency picks depend on.
 * BFS from bb 0 over CFG successors (covers IR_SWITCH), free the dead BBs,
 * compact the array, and remap every stored BB id (succ[], branch
 * op->label, switch targets) + renumber bb->id to the new array index
 * (an invariant every id-indexed lowerer array relies on). Runs first so
 * every later pass sees a clean CFG. IR_NO_PRUNE opts out. Returns the
 * number of blocks removed. */
int ir_opt_prune_unreachable(Func *f);

/* Byte-width narrowing: a promoted int binop (add/sub/and/or/xor/shl)
 * whose result is only truncated back to a byte is re-typed width-1 so
 * ir_lower emits the 8-bit-in-A form. IR_NO_NARROW_BYTE opts out.
 * Returns the number of ops narrowed. */
int ir_opt_narrow_byte(Func *f);

/* Range-narrow a loop counter proven to fit [0,256) to a byte (width-1):
 * byte inc/dec step, 1-byte slot, int uses auto-widen. IR_NO_IV_NARROW opts
 * out. Returns the number of counters narrowed. */
int ir_opt_narrow_iv(Func *f);

/* Local (per-BB) copy propagation: rewrites src operands reading an
 * identity copy (MOV / same-width CONV_SX|ZX) to read the copy's source,
 * so the copy becomes dead (removed by a following DCE). Pairs with
 * narrow_byte, whose narrowed CONV operands are byte-identity copies that
 * would otherwise spill to a slot. Returns operands rewritten. */
int ir_opt_copy_prop(Func *f);

/* Coalesce a single-use width-1 copy `d <- t` by folding t into d (renaming
 * every def of t to d, dropping the now-identity copy), so a char-ternary
 * update chain writes the byte-home accumulator directly instead of a temp
 * that the merge copies in. Guarded by a Chaitin interference check (single-
 * use alone is not sufficient). IR_NO_COALESCE_COPIES opts out. Run after
 * narrow_byte + copy_prop, before ir_alloc. Returns copies coalesced. */
int ir_opt_coalesce_copies(Func *f);

/* Local (per-BB) constant folding + algebraic identity: track each vreg's
 * known constant and simplify `x op identity` (x+0, x-0, x|0, x^0, x&0,
 * x&all-ones, x<<0, x>>0, …) to a MOV or LD_IMM. Folds the `acc = 0;
 * acc op= …` idiom (e.g. `main`'s `res += f()`). Returns ops simplified. */
int ir_opt_const_fold(Func *f);

/* Reassociate a reduction's left-leaning add-tree (`acc += x0+x1+…+xk`)
   into k+1 direct accumulates `acc += xi`, in place (no op insertion). Frees
   the accumulator to stay in the word DE-home — the tree form computes the
   sub-sums through DE/HL, blocking residency. Gated on c_word_resident
   (inert when off ⇒ byte-identical). Returns chains reassociated. */
int ir_opt_reassoc_reduction(Func *f);

/* long_inc_mhl (the long (*p)++ triple → HCALL l_long_inc_mhl) lives
   in the ir_match table as `incmhl`; --opt-disable=pattern:incmhl. */

/* fuse_mov (producer + single-use MOV → producer writes the MOV's
   dst) lives in the ir_match early phase as the `movfuse` pattern;
   --opt-disable=pattern:movfuse. */

/* Clear IR_CALL / IR_HCALL ret_vregs that have zero function-wide
   uses (discarded results, e.g. bare `printf(...)`). Kills the
   post-call store and the result's frame slot. Returns the number
   of calls cleaned. */
int ir_opt_drop_dead_ret(Func *f);

/* RPN-style stack preservation for long DEHL.
 *
 * For each BB, find a width-4 vreg whose def is followed by
 * DEHL-clobbering ops before its consumer. Insert IR_PUSH_DEHL_LONG
 * after the def and IR_POP_DEHL_LONG before the use; the lowerer
 * swaps the implicit slot-spill for `push de; push hl` (~80T saved
 * per intermediate long) and tracks cur_sp_adjust through intervening
 * sp-relative slot reads.
 *
 * MVP — non-overlapping single-level pushes only:
 *   - dst width 4
 *   - function-wide use_count == 1
 *   - use in same BB, ≥ 2 ops after def
 *   - no branches/calls between def and use
 *   - producer kind in {LD_MEM, ADD/SUB/AND/OR/XOR, SHL/SHR,
 *     NEG/NOT, MOV, CONV_ZX/SX} (all call store_dehl_finalize)
 *   - consumer consumes via DEHL (ADD/SUB/AND/OR/XOR/SHL/SHR/
 *     NEG/NOT/ST_MEM/PUSH_DEHL_LONG)
 *   - non-overlapping with any previously-kept candidate
 *
 * Returns the number of (def, use) pairs annotated.
 */
int ir_opt_insert_long_pushes(Func *f);

/* fold_imm_conv lived here until it became the ir_match table's
   `immconv` pattern (LD_IMM + CONV_* → re-width'd LD_IMM); disable
   with --opt-disable=pattern:immconv. */

/* fuse_rotl (the ROTATE_LEFT triple → IR_ROTL) lives in the ir_match
   table as the `rotl` pattern; disable with --opt-disable=pattern:rotl. */

#endif /* IR_OPT_H */
