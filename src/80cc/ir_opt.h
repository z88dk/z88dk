/*
 * ir_opt.h — IR-level optimisation passes.
 *
 * Run between ir_build (which emits the raw IR from the AST) and the
 * analysis/allocator pipeline. Each pass takes a `Func *` in-place and
 * mutates the IR.
 *
 * Decoupled from compiler internals — ir_opt links against ir.c +
 * ir.h only.
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
 * Common invalidation: IR_CALL / IR_HCALL / IR_ASM wipe the shadow.
 * A non-matching IR_ST_MEM drops alias-risk entries. Writes to a
 * tracked base or stored vreg invalidate the matching entry.
 * Volatile ops are never tracked nor forwarded.
 *
 * Tracks IR_MEM_SYM (sym+offset) and IR_MEM_VREG (base+offset). No
 * cross-BB tracking — table resets at BB boundary.
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
 * Detects loops via a back-edge scan (a successor with id ≤ current
 * BB id implies a back-edge into a loop header). For each loop with a
 * unique natural pre-header (the only outside predecessor of the
 * header), hoists invariant ops from the body to the pre-header,
 * placing them just before the pre-header's terminator.
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

/* LD_SYM + ADD/SUB imm fold.
 *
 * Pattern (per BB, adjacent ops):
 *   IR_LD_SYM  v_a <- sym+K1         (single use across function)
 *   IR_ADD     v_b <- v_a (imm=K2)   (literal RHS, src[1]==-1)
 * rewrites to
 *   IR_LD_SYM  v_b <- sym+(K1+K2)
 *
 * SUB analogous: new offset = K1 - K2. The original LD_SYM is marked
 * dead and compacted out at the end of the BB.
 *
 * Lowerer emits `ld hl,_sym+K` for IR_LD_SYM-with-offset (1 inst);
 * without this fold the same pattern emits `ld hl,_sym; ld de,K;
 * add hl,de` (5 inst) for every member access like `g.counter`.
 *
 * Returns the number of folds applied.
 */
int ir_opt_sym_offset_fold(Func *f);

/* Long (*p)++ fuse to l_long_inc_mhl.
 *
 * Pattern (per BB, three adjacent ops, all width 4):
 *   IR_LD_MEM  v_old <- [v_p, 0]      (MEM_VREG, offset 0)
 *   IR_ADD     v_new <- v_old (imm=1)
 *   IR_ST_MEM            [v_p, 0], v_new
 *
 * When both v_old and v_new have no uses outside the triple (the
 * discarded-result statement `(*p)++;` shape), rewrites to a single
 * IR_HCALL to l_long_inc_mhl. The helper increments the long at *HL
 * in place; lowers to one slot-load + one call (~5 inst), replacing
 * the inline ~30-inst long-LD/ADD/ST chain.
 *
 * Returns the number of triples fused.
 */
int ir_opt_long_inc_mhl(Func *f);

/* IR_MOV elimination via producer fusion.
 *
 * Pattern (per BB, two adjacent ops):
 *   <producer> v_t <- ...
 *   IR_MOV v_dst <- v_t       (v_t single-use, same width as v_dst)
 *
 * Rewrites the producer to write v_dst directly and drops the MOV.
 * Eliminates the producer's slot store + MOV's reload + MOV's store
 * triple (~14 bytes per fused pair).
 *
 * Returns the number of MOVs eliminated.
 */
int ir_opt_fuse_mov(Func *f);

/* Phase D — RPN-style stack preservation for long DEHL.
 *
 * For each BB, find a width-4 vreg whose def is followed by
 * intermediate DEHL-clobbering ops before the consumer. Insert
 * IR_PUSH_DEHL_LONG after the def and IR_POP_DEHL_LONG before
 * the use. The lowerer replaces the implicit slot-spill with a
 * `push de; push hl` (saves ~80T per intermediate long) and
 * tracks cur_sp_adjust through intervening sp-relative slot
 * reads.
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

#endif /* IR_OPT_H */
