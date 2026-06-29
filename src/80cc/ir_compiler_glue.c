/*
 * ir_compiler_glue.c — accessors that bridge the decoupled IR to the
 * rest of the 80cc compiler.
 *
 * ir.c / ir.h / ir_lower.c stay clean of compiler internals so
 * ir_selftest can build standalone. Anything needing the full type
 * system (SYMBOL fields, Kind decoding) lives here; the selftest
 * links its own stubs (ir_selftest.c) instead of this file.
 */

#include "ccdefs.h"   /* must precede ir.h: define.h's Kind enum wins */
#include "ir.h"
#include "ir_lower.h"
#include "ir_build.h"

const char *ir_sym_name(const SYMBOL *sym)
{
    return sym ? sym->name : "?";
}

/* LIBRARY-flagged functions skip the leading underscore (see dopref).
   Returns "" for those, "_" for everything else. */
const char *ir_sym_prefix(const SYMBOL *sym)
{
    if (sym && sym->ctype
        && (sym->ctype->flags & LIBRARY)
        && sym->ctype->kind == KIND_FUNC)
        return "";
    return "_";
}

/* c_cpu → IR_FEAT_* capability word (PATTERN_MATCHER_PLAN.md decision
   #1: feature bits, not CPU ids — they document WHY a pattern is gated
   and age better as Rabbit/KC160 variants accumulate). ir_build stamps
   the result onto each Func so the ccdefs-free IR layers never see
   c_cpu. Start from the full z80 set and strip what a target lacks. */
uint32_t ir_features_from_cpu(void)
{
    uint32_t feat = IR_FEAT_CB_BITOPS | IR_FEAT_EX_DE_HL
                  | IR_FEAT_IX | IR_FEAT_DJNZ;
    if (IS_808x())
        feat &= ~(IR_FEAT_CB_BITOPS | IR_FEAT_IX | IR_FEAT_DJNZ);
    if (IS_GBZ80())   /* LR35902 keeps the CB prefix */
        feat &= ~(IR_FEAT_EX_DE_HL | IR_FEAT_IX | IR_FEAT_DJNZ);
    return feat;
}

/* Bridge the lowerer's FILE* interface to the compiler's global
   `output` stream, so ir_build.c needn't drag <stdio.h> globals
   through its API. */
int ir_lower_to_output(Func *f)
{
    if (getenv("IR_DUMP"))
        ir_dump_func(stderr, f);
    /* Buffer the lowering and only flush on success. A mid-function
       lowering failure returns nonzero and the caller falls back to
       the walker — without buffering, the partially emitted asm
       stays in the output with dangling label references, followed
       by a duplicate walker body. */
    char *buf = NULL;
    size_t len = 0;
    FILE *mem = open_memstream(&buf, &len);
    if (!mem)
        return ir_lower_func(output, f);   /* degraded: direct emit */
    int rc = ir_lower_func(mem, f);
    fclose(mem);
    if (rc == 0 && buf)
        fwrite(buf, 1, len, output);
    free(buf);
    return rc;
}

/* Set IR_DUMP=1 in the environment to dump the IR for each function
   to stderr before lowering. Cheap diagnostic for inspecting the
   shape of generated IR without rebuilding. */
