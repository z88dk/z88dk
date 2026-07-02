/*
 * ir.c — IR constructors, dumpers, validation, op-metadata table.
 *
 * Type definitions in ir.h; rationale in src/80cc/.tmp/IR_DESIGN.md.
 *
 * Logic-light by design: anything that requires the full 80cc type
 * system (Kind enum decode, SYMBOL name resolution, etc.) goes through
 * small helpers that take only what's needed. The IR stays decoupled
 * from the AST machinery.
 */

#include "ir.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* ----- Op metadata table -------------------------------------------------
   One row per OpKind, indexed by the enum value. */

typedef struct {
    const char *name;
    int         is_aliased;       /* dst aliases src[0] (z80 two-op rule) */
    int         is_terminator;    /* ends a BB */
} OpInfo;

static const OpInfo op_table[] = {
    /* moves / loads */
    [IR_MOV]                = { "MOV",                  0, 0 },
    [IR_LD_IMM]             = { "LD_IMM",               0, 0 },
    [IR_LD_SYM]             = { "LD_SYM",               0, 0 },
    [IR_LD_STR]             = { "LD_STR",               0, 0 },
    [IR_LEA]                = { "LEA",                  0, 0 },
    [IR_LD_MEM]             = { "LD_MEM",               0, 0 },
    [IR_ST_MEM]             = { "ST_MEM",               0, 0 },

    /* aliased two-op arithmetic */
    [IR_ADD]                = { "ADD",                  1, 0 },
    [IR_SUB]                = { "SUB",                  1, 0 },
    [IR_RSUB]               = { "RSUB",                 1, 0 },
    [IR_AND]                = { "AND",                  1, 0 },
    [IR_OR]                 = { "OR",                   1, 0 },
    [IR_XOR]                = { "XOR",                  1, 0 },
    [IR_SHL]                = { "SHL",                  1, 0 },
    [IR_SHR]                = { "SHR",                  1, 0 },

    /* unary */
    [IR_NEG]                = { "NEG",                  1, 0 },
    [IR_NOT]                = { "NOT",                  1, 0 },
    [IR_INC]                = { "INC",                  1, 0 },
    [IR_DEC]                = { "DEC",                  1, 0 },

    /* conversions */
    [IR_CONV_ZX]            = { "CONV_ZX",              0, 0 },
    [IR_CONV_SX]            = { "CONV_SX",              0, 0 },
    [IR_CONV_TRUNC]         = { "CONV_TRUNC",           0, 0 },
    [IR_CONV_BYTE_TO_HIGH]  = { "CONV_BYTE_TO_HIGH",    0, 0 },

    /* rotates */
    [IR_ROTL]               = { "ROTL",                 1, 0 },
    [IR_ROTR]               = { "ROTR",                 1, 0 },

    /* shift-into-carry */
    [IR_SHL_INTO_CARRY]     = { "SHL_INTO_CARRY",       1, 0 },
    [IR_SHR_INTO_CARRY]     = { "SHR_INTO_CARRY",       1, 0 },

    /* comparisons */
    [IR_CMP_EQ]             = { "CMP_EQ",               0, 0 },
    [IR_CMP_NE]             = { "CMP_NE",               0, 0 },
    [IR_CMP_LT]             = { "CMP_LT",               0, 0 },
    [IR_CMP_LE]             = { "CMP_LE",               0, 0 },
    [IR_CMP_GT]             = { "CMP_GT",               0, 0 },
    [IR_CMP_GE]             = { "CMP_GE",               0, 0 },
    [IR_CMP_ULT]            = { "CMP_ULT",              0, 0 },
    [IR_CMP_ULE]            = { "CMP_ULE",              0, 0 },
    [IR_CMP_UGT]            = { "CMP_UGT",              0, 0 },
    [IR_CMP_UGE]            = { "CMP_UGE",              0, 0 },

    /* control flow */
    [IR_BR]                 = { "BR",                   0, 1 },
    /* BR_COND / BR_ZERO are NOT terminators — they fall through if the
       condition doesn't match. Each BB ends with an explicit IR_BR (or
       RET) for the fall-through, so correctness doesn't rely on BB
       array-emit order matching fall-through. */
    [IR_BR_COND]            = { "BR_COND",              0, 0 },
    [IR_BR_ZERO]            = { "BR_ZERO",              0, 0 },
    [IR_SWITCH]             = { "SWITCH",               0, 1 },
    [IR_RET]                = { "RET",                  0, 1 },

    /* calls */
    [IR_CALL]               = { "CALL",                 0, 0 },
    [IR_HCALL]              = { "HCALL",                0, 0 },
    [IR_ACC_BINOP]          = { "ACC_BINOP",            0, 0 },
    [IR_ACC_UNOP]           = { "ACC_UNOP",             0, 0 },
    [IR_ACC_CMP]            = { "ACC_CMP",              0, 0 },

    /* I/O */
    [IR_IN]                 = { "IN",                   0, 0 },
    [IR_OUT]                = { "OUT",                  0, 0 },

    /* Far */
    [IR_LD_FAR]             = { "LD_FAR",               0, 0 },
    [IR_ST_FAR]             = { "ST_FAR",               0, 0 },
    [IR_LD_FARSYM]          = { "LD_FARSYM",            0, 0 },

    /* Critical-section markers */
    [IR_CRITICAL_ENTER]     = { "CRITICAL_ENTER",       0, 0 },
    [IR_CRITICAL_LEAVE]     = { "CRITICAL_LEAVE",       0, 0 },

    /* Long stack-save markers — src[0] is the long vreg. PUSH reads
       src[0] (the live long in DEHL); POP defines src[0] (reborn in
       DEHL after the pop). */
    [IR_PUSH_DEHL_LONG]     = { "PUSH_DEHL_LONG",       0, 0 },
    [IR_POP_DEHL_LONG]      = { "POP_DEHL_LONG",        0, 0 },
    [IR_PUSH_ARG]           = { "PUSH_ARG",             0, 0 },

    [IR_POSTSTEP]           = { "POSTSTEP",             0, 0 },
    [IR_EXTRACT_BYTE]       = { "EXTRACT_BYTE",         0, 0 },
    [IR_MEMSET]             = { "MEMSET",               0, 0 },
    [IR_MEMCPY]             = { "MEMCPY",               0, 0 },
    [IR_STRCPY]             = { "STRCPY",               0, 0 },
    [IR_STRCHR]             = { "STRCHR",               0, 0 },

    /* misc */
    [IR_NOP]                = { "NOP",                  0, 0 },
    [IR_ASM]                = { "ASM",                  0, 0 },
    [IR_PHI]                = { "PHI",                  0, 0 },
};

int ir_op_is_aliased(OpKind kind)
{
    if (kind < 0 || kind >= IR_OP_COUNT) return 0;
    return op_table[kind].is_aliased;
}

int ir_op_is_terminator(OpKind kind)
{
    if (kind < 0 || kind >= IR_OP_COUNT) return 0;
    return op_table[kind].is_terminator;
}

/* Successor iteration covering IR_SWITCH's multi-way targets. For a
   switch-terminated BB the successors are target_bb[0..n) followed by
   default_bb; otherwise the plain succ[2] pair. */
static const SwitchInfo *bb_switch_term(const BB *bb)
{
    if (bb->n_ops <= 0) return NULL;
    const Op *last = &bb->ops[bb->n_ops - 1];
    return (last->kind == IR_SWITCH) ? last->sw : NULL;
}

int ir_bb_n_succ(const BB *bb)
{
    if (!bb) return 0;
    const SwitchInfo *sw = bb_switch_term(bb);
    if (sw) return sw->n_cases + 1;
    if (bb->succ[0] < 0) return 0;
    return (bb->succ[1] < 0) ? 1 : 2;
}

int ir_bb_succ_at(const BB *bb, int i)
{
    if (!bb || i < 0) return -1;
    const SwitchInfo *sw = bb_switch_term(bb);
    if (sw) {
        if (i < sw->n_cases) return sw->target_bb[i];
        if (i == sw->n_cases) return sw->default_bb;
        return -1;
    }
    return (i < 2) ? bb->succ[i] : -1;
}

const char *ir_op_name(OpKind kind)
{
    if (kind < 0 || kind >= IR_OP_COUNT) return "?op";
    const char *n = op_table[kind].name;
    return n ? n : "?op";
}

const char *ir_phys_name(PhysReg pr)
{
    switch (pr) {
    case IR_PR_NONE:   return "-";
    case IR_PR_A:      return "A";
    case IR_PR_HL:     return "HL";
    case IR_PR_DE:     return "DE";
    case IR_PR_BC:     return "BC";
    case IR_PR_IX:     return "IX";
    case IR_PR_IY:     return "IY";
    case IR_PR_DEHL:   return "DEHL";
    case IR_PR_AF_ALT: return "AF'";
    case IR_PR_HL_ALT: return "HL'";
    case IR_PR_DE_ALT: return "DE'";
    case IR_PR_BC_ALT: return "BC'";
    case IR_PR_SPILL:  return "spill";
    default:           return "?phys";
    }
}

/* ----- Constructors ----------------------------------------------------- */

static void *xmalloc(size_t n)
{
    void *p = calloc(1, n);
    if (!p) {
        fputs("ir: out of memory\n", stderr);
        abort();
    }
    return p;
}

static void *xrealloc(void *p, size_t n)
{
    void *q = realloc(p, n);
    if (!q && n != 0) {
        fputs("ir: out of memory (realloc)\n", stderr);
        abort();
    }
    return q;
}

Func *ir_func_new(SYMBOL *fn)
{
    Func *f = xmalloc(sizeof(*f));
    f->fn = fn;
    f->vregs = NULL;     f->n_vregs = 0; f->cap_vregs = 0;
    f->bbs   = NULL;     f->n_bbs   = 0; f->cap_bbs   = 0;
    f->frame_size = 0;
    f->slot_offsets = NULL; f->n_slots = 0;
    f->cpu = 0;
    f->abi = IR_ABI_SMALLC;
    f->is_interrupt = 0;
    f->interrupt_irq = -1;
    f->is_naked = 0;
    f->is_critical = 0;
    f->has_setjmp = 0;
    f->ns = NULL;
    f->word_home_vreg = -1;
    f->vreg_to_phys = NULL;
    f->vreg_spill_slot = NULL;
    f->live_ranges = NULL;
    return f;
}

void ir_func_free(Func *f)
{
    if (!f) return;
    for (int i = 0; i < f->n_bbs; i++) {
        BB *bb = &f->bbs[i];
        for (int j = 0; j < bb->n_ops; j++) {
            Op *o = &bb->ops[j];
            if (o->call) {
                free(o->call->args);
                free(o->call);
            }
            if (o->hcall) {
                free(o->hcall->args);
                free(o->hcall);
            }
            if (o->sw) {
                free(o->sw->values);
                free(o->sw->target_bb);
                free(o->sw);
            }
            if (o->mem.port) free(o->mem.port);
        }
        free(bb->ops);
        free(bb->pred);
        /* live_in/live_out are owned by ir_analysis.c, freed via its
           API (ir_free_liveness). */
    }
    free(f->bbs);
    free(f->vregs);
    free(f->slot_offsets);
    free(f->vreg_to_phys);
    free(f->vreg_spill_slot);
    free(f->live_ranges);
    free(f);
}

/* Kind → width in bytes. Fallback only: ir_build.c sets each vreg's
   width explicitly from the AST type info. */
static int kind_width(Kind k)
{
    (void)k;
    return 2; /* default to int; ir_build overrides */
}

int ir_vreg_new(Func *f, Kind k, SYMBOL *sym, uint8_t flags)
{
    if (f->n_vregs >= f->cap_vregs) {
        int cap = f->cap_vregs ? f->cap_vregs * 2 : 16;
        f->vregs = xrealloc(f->vregs, cap * sizeof(VReg));
        memset(&f->vregs[f->cap_vregs], 0,
               (cap - f->cap_vregs) * sizeof(VReg));
        f->cap_vregs = cap;
    }
    int id = f->n_vregs++;
    VReg *v = &f->vregs[id];
    v->id = id;
    v->kind = k;
    v->width = kind_width(k);
    v->sym = sym;
    v->flags = flags;
    return id;
}

int ir_bb_new(Func *f)
{
    if (f->n_bbs >= f->cap_bbs) {
        int cap = f->cap_bbs ? f->cap_bbs * 2 : 8;
        f->bbs = xrealloc(f->bbs, cap * sizeof(BB));
        memset(&f->bbs[f->cap_bbs], 0, (cap - f->cap_bbs) * sizeof(BB));
        f->cap_bbs = cap;
    }
    int id = f->n_bbs++;
    BB *bb = &f->bbs[id];
    bb->id = id;
    bb->label = NULL;
    bb->ops = NULL; bb->n_ops = 0; bb->cap_ops = 0;
    bb->succ[0] = -1; bb->succ[1] = -1;
    bb->pred = NULL; bb->n_pred = 0;
    bb->live_in = NULL; bb->live_out = NULL;
    bb->loop_depth = 0; bb->loop_header = 0;
    return id;
}

/* Source-location stash, stamped onto each emitted op. ir_build sets
   these at each statement boundary. */
static const char *ir_emit_file;
static int         ir_emit_line;

void ir_set_emit_loc(const char *file, int line)
{
    ir_emit_file = file;
    ir_emit_line = line;
}

void ir_get_emit_loc(const char **file, int *line)
{
    if (file) *file = ir_emit_file;
    if (line) *line = ir_emit_line;
}

Op *ir_op_emit(BB *bb, OpKind kind)
{
    if (bb->n_ops >= bb->cap_ops) {
        int cap = bb->cap_ops ? bb->cap_ops * 2 : 8;
        bb->ops = xrealloc(bb->ops, cap * sizeof(Op));
        memset(&bb->ops[bb->cap_ops], 0, (cap - bb->cap_ops) * sizeof(Op));
        bb->cap_ops = cap;
    }
    Op *op = &bb->ops[bb->n_ops++];
    memset(op, 0, sizeof(*op));
    op->kind = kind;
    op->dst = -1;
    op->src[0] = -1; op->src[1] = -1;
    op->label = -1;
    op->file = ir_emit_file;
    op->line = ir_emit_line;
    return op;
}

Op *ir_emit_mov(BB *bb, int dst, int src)
{
    Op *o = ir_op_emit(bb, IR_MOV);
    o->dst = dst; o->src[0] = src;
    return o;
}

Op *ir_emit_ld_imm(BB *bb, int dst, int64_t imm)
{
    Op *o = ir_op_emit(bb, IR_LD_IMM);
    o->dst = dst; o->imm = imm;
    return o;
}

Op *ir_emit_binop(BB *bb, OpKind kind, int dst, int src0, int src1)
{
    Op *o = ir_op_emit(bb, kind);
    o->dst = dst; o->src[0] = src0; o->src[1] = src1;
    return o;
}

Op *ir_emit_unop(BB *bb, OpKind kind, int dst, int src)
{
    Op *o = ir_op_emit(bb, kind);
    o->dst = dst; o->src[0] = src;
    return o;
}

/* Fill the first free succ slot. Lets a BB ending `BR_ZERO X; BR Y`
   register both targets. A third succ is silently dropped — never
   happens for well-formed IR (max two succs per BB). */
static void bb_add_succ(BB *bb, int target)
{
    if (bb->succ[0] < 0)      bb->succ[0] = target;
    else if (bb->succ[1] < 0) bb->succ[1] = target;
}

Op *ir_emit_br(BB *bb, int target_bb)
{
    Op *o = ir_op_emit(bb, IR_BR);
    o->label = target_bb;
    bb_add_succ(bb, target_bb);
    return o;
}

Op *ir_emit_br_cond(BB *bb, int src, int target_bb)
{
    Op *o = ir_op_emit(bb, IR_BR_COND);
    o->src[0] = src; o->label = target_bb;
    bb_add_succ(bb, target_bb);
    return o;
}

Op *ir_emit_br_zero(BB *bb, int src, int target_bb)
{
    Op *o = ir_op_emit(bb, IR_BR_ZERO);
    o->src[0] = src; o->label = target_bb;
    bb_add_succ(bb, target_bb);
    return o;
}

Op *ir_emit_ret(BB *bb, int src)
{
    Op *o = ir_op_emit(bb, IR_RET);
    o->src[0] = src;
    /* succ stays -1 — RET is a CFG sink. */
    return o;
}

/* ----- Dumpers ---------------------------------------------------------- */

void ir_dump_vreg(FILE *out, const Func *f, int vreg_id)
{
    if (vreg_id < 0) {
        fputs("-", out);
        return;
    }
    if (!f || vreg_id >= f->n_vregs) {
        fprintf(out, "v?%d", vreg_id);
        return;
    }
    const VReg *v = &f->vregs[vreg_id];
    fprintf(out, "v%d", v->id);
    /* Append the phys assignment if one exists. */
    if (f->vreg_to_phys && f->vreg_to_phys[vreg_id] != IR_PR_NONE) {
        fprintf(out, "[%s]", ir_phys_name(f->vreg_to_phys[vreg_id]));
    }
}

static void dump_memop(FILE *out, const Func *f, const MemOp *m)
{
    switch (m->kind) {
    case IR_MEM_FRAME:
        fprintf(out, "frame[slot=%d", m->slot);
        if (m->offset) fprintf(out, "+%d", m->offset);
        fputs("]", out);
        break;
    case IR_MEM_SYM:
        fprintf(out, "sym[%s",
                (m->sym ? "<sym>" : "<null>"));   /* name not resolved:
                                                     ir.c is decoupled
                                                     from SYMBOL */
        if (m->offset) fprintf(out, "+%d", m->offset);
        fputs("]", out);
        break;
    case IR_MEM_VREG:
        fputs("[", out);
        ir_dump_vreg(out, f, m->base);
        if (m->offset) fprintf(out, "+%d", m->offset);
        fputs("]", out);
        break;
    case IR_MEM_PORT:
        if (m->port) {
            fprintf(out, "port[%s,%s]",
                    m->port->kind == IR_PORT_KIND_8 ? "8" : "16",
                    m->port->sym ? "<sym>" : "<imm>");
        } else {
            fputs("port[<null>]", out);
        }
        break;
    case IR_MEM_POOL:
        fprintf(out, "pool[i_%d]", m->offset);
        break;
    default:
        fputs("mem?", out);
    }
}

void ir_dump_op(FILE *out, const Func *f, const Op *op)
{
    fprintf(out, "    %-18s", ir_op_name(op->kind));
    if (op->dst >= 0) {
        ir_dump_vreg(out, f, op->dst);
        fputs(" <- ", out);
    } else {
        fputs("           ", out);
    }
    switch (op->kind) {
    case IR_LD_IMM:
        fprintf(out, "%lld", (long long)op->imm);
        break;
    case IR_LD_MEM:
    case IR_ST_MEM:
    case IR_IN:
    case IR_OUT:
        dump_memop(out, f, &op->mem);
        if (op->kind == IR_ST_MEM || op->kind == IR_OUT) {
            fputs(", ", out);
            ir_dump_vreg(out, f, op->src[0]);
        }
        break;
    case IR_BR:
        fprintf(out, "BB%d", op->label);
        break;
    case IR_BR_COND:
    case IR_BR_ZERO:
        ir_dump_vreg(out, f, op->src[0]);
        fprintf(out, ", BB%d", op->label);
        break;
    case IR_RET:
        ir_dump_vreg(out, f, op->src[0]);
        break;
    case IR_CALL:
        if (op->call) {
            fprintf(out, "<call to %s, %d args>",
                    op->call->target ? "<sym>" : "<indirect>",
                    op->call->n_args);
        } else {
            fputs("<call ?>", out);
        }
        break;
    case IR_HCALL:
    case IR_ACC_BINOP:
    case IR_ACC_UNOP:
    case IR_ACC_CMP:
        if (op->hcall) {
            fprintf(out, "%s(%d args)",
                    op->hcall->name ? op->hcall->name : "?",
                    op->hcall->n_args);
        } else {
            fputs("<hcall ?>", out);
        }
        break;
    case IR_SWITCH:
        ir_dump_vreg(out, f, op->src[0]);
        if (op->sw) {
            for (int i = 0; i < op->sw->n_cases; i++)
                fprintf(out, "%s %lld→BB%d", i ? "," : "",
                        (long long)op->sw->values[i],
                        op->sw->target_bb[i]);
            fprintf(out, " default→BB%d", op->sw->default_bb);
        }
        break;
    case IR_ASM:
        fprintf(out, "<asm: %.40s...>", op->asm_text ? op->asm_text : "");
        break;
    default:
        if (op->src[0] >= 0) { ir_dump_vreg(out, f, op->src[0]); }
        if (op->src[1] >= 0) { fputs(", ", out); ir_dump_vreg(out, f, op->src[1]); }
        if (op->imm) fprintf(out, " (imm=%lld)", (long long)op->imm);
        break;
    }
    if (op->file && op->line) {
        fprintf(out, "   ; %s:%d", op->file, op->line);
    }
    fputc('\n', out);
}

void ir_dump_bb(FILE *out, const Func *f, const BB *bb)
{
    fprintf(out, "  BB%d", bb->id);
    if (bb->label) fprintf(out, " (.%s)", bb->label);
    if (bb->loop_depth) fprintf(out, " [loop_depth=%d%s]",
                                bb->loop_depth,
                                bb->loop_header ? ",header" : "");
    if (bb->n_pred) {
        fputs(" preds:", out);
        for (int i = 0; i < bb->n_pred; i++) fprintf(out, " BB%d", bb->pred[i]);
    }
    fputc('\n', out);
    for (int i = 0; i < bb->n_ops; i++) {
        ir_dump_op(out, f, &bb->ops[i]);
    }
    if (bb->succ[0] >= 0) {
        fprintf(out, "    ; succ: BB%d", bb->succ[0]);
        if (bb->succ[1] >= 0) fprintf(out, ", BB%d", bb->succ[1]);
        fputc('\n', out);
    }
}

void ir_dump_func(FILE *out, const Func *f)
{
    fprintf(out, "Func (sym=%p) abi=%d vregs=%d bbs=%d frame=%d\n",
            (void *)f->fn, (int)f->abi, f->n_vregs, f->n_bbs, f->frame_size);
    if (f->is_interrupt) fputs("  attrs: __interrupt\n", out);
    if (f->is_naked)     fputs("  attrs: __naked\n", out);
    if (f->is_critical)  fputs("  attrs: __critical\n", out);
    if (f->has_setjmp)   fputs("  attrs: contains setjmp\n", out);
    /* Live ranges: one line per vreg with [start,end] in linearised op
       index. Printed only when ir_compute_live_ranges has populated the
       table (opt-in, run by ir_lower_func). */
    if (f->live_ranges && f->n_vregs > 0) {
        fputs("  live ranges:\n", out);
        const struct { int start, end; } *lr = (const void *)f->live_ranges;
        for (int v = 0; v < f->n_vregs; v++) {
            if (lr[v].start < 0 && lr[v].end < 0) {
                fprintf(out, "    v%d: unused\n", v);
            } else {
                fprintf(out, "    v%d: [%d,%d]\n", v, lr[v].start, lr[v].end);
            }
        }
    }
    for (int i = 0; i < f->n_bbs; i++) {
        ir_dump_bb(out, f, &f->bbs[i]);
    }
}

/* ----- Validator -------------------------------------------------------- */

static int validate_fail(const char *msg, int bb_id, int op_idx)
{
    fprintf(stderr, "ir_validate: BB%d op[%d]: %s\n", bb_id, op_idx, msg);
    return -1;
}

int ir_validate(const Func *f)
{
    if (!f) return validate_fail("null func", -1, -1);
    if (f->n_bbs == 0) return validate_fail("function has no BBs", -1, -1);

    for (int i = 0; i < f->n_bbs; i++) {
        const BB *bb = &f->bbs[i];
        if (bb->id != i) return validate_fail("BB id mismatch", i, -1);
        if (bb->n_ops == 0) return validate_fail("empty BB", i, -1);

        /* Terminator must be the last op. */
        for (int j = 0; j < bb->n_ops; j++) {
            const Op *op = &bb->ops[j];
            int is_term = ir_op_is_terminator(op->kind);
            int is_last = (j == bb->n_ops - 1);
            if (is_term && !is_last)
                return validate_fail("terminator not last", i, j);
            if (!is_term && is_last
                && bb->succ[0] < 0 && op->kind != IR_RET)
                return validate_fail("non-terminator at end of BB with no succ", i, j);

            /* vreg ids in range. */
            if (op->dst >= f->n_vregs)
                return validate_fail("dst vreg out of range", i, j);
            for (int k = 0; k < 2; k++) {
                if (op->src[k] >= f->n_vregs)
                    return validate_fail("src vreg out of range", i, j);
            }

            /* Aliased-two-op rule: dst aliases src[0]. Vreg-id equality
               is the allocator's job, not enforced here; we only check
               that aliased ops have both dst and src[0]. */
            if (ir_op_is_aliased(op->kind)) {
                if (op->dst < 0 || op->src[0] < 0)
                    return validate_fail("aliased op missing dst or src[0]", i, j);
            }
        }

        /* Successor BB ids in range (covers IR_SWITCH targets). */
        int ns = ir_bb_n_succ(bb);
        for (int k = 0; k < ns; k++) {
            int s = ir_bb_succ_at(bb, k);
            if (s < 0 || s >= f->n_bbs)
                return validate_fail("succ BB out of range", i, -1);
        }
    }
    return 0;
}
