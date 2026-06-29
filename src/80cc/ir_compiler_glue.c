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

/* For a symbol in a named address space (__addressmod), return the page-in
   "bank function" that maps its bank into the address window. The lowerer
   must `call` it before accessing the symbol. Contract (matching sdcc):
   the bank function preserves ALL registers, so the access is transparent —
   no register/cache clobber. Returns NULL for the default address space. */
const SYMBOL *ir_sym_bank_fn(const SYMBOL *sym)
{
    if (!sym || !sym->ctype || !sym->ctype->namespace)
        return NULL;
    namespace *ns = get_namespace(sym->ctype->namespace);
    return ns ? ns->bank_function : NULL;
}

/* As ir_sym_bank_fn but keyed on a namespace NAME — for indirect
   (array/pointer) access where the namespace is carried on the pointee /
   element type rather than on a symbol. Returns NULL for the default space. */
const SYMBOL *ir_namespace_bank_fn(const char *ns_name)
{
    if (!ns_name)
        return NULL;
    namespace *ns = get_namespace(ns_name);
    return ns ? ns->bank_function : NULL;
}

/* c_cpu → IR_FEAT_* capability word (PATTERN_MATCHER_PLAN.md decision
   #1: feature bits, not CPU ids — they document WHY a pattern is gated
   and age better as Rabbit/KC160 variants accumulate). ir_build stamps
   the result onto each Func so the ccdefs-free IR layers never see
   c_cpu. Start from the full z80 set and strip what a target lacks. */
uint32_t ir_features_from_cpu(void)
{
    uint32_t feat = IR_FEAT_CB_BITOPS | IR_FEAT_EX_DE_HL
                  | IR_FEAT_IX | IR_FEAT_DJNZ | IR_FEAT_OVERFLOW_FLAG
                  | IR_FEAT_JR;
    if (IS_808x())   /* P flag is parity, not overflow; no relative jumps */
        feat &= ~(IR_FEAT_CB_BITOPS | IR_FEAT_IX | IR_FEAT_DJNZ
                  | IR_FEAT_OVERFLOW_FLAG | IR_FEAT_JR);
    if (IS_8085())   /* undocumented LDSI+LHLX/SHLX sp-rel ld/st; DSUB+K signed compare */
        feat |= IR_FEAT_SP_REL_DEPTR | IR_FEAT_DSUB;
    if (IS_GBZ80())   /* LR35902 keeps the CB prefix; no overflow/sign flags */
        feat &= ~(IR_FEAT_EX_DE_HL | IR_FEAT_IX | IR_FEAT_DJNZ
                  | IR_FEAT_OVERFLOW_FLAG);
    if (c_cpu & CPU_RABBIT) {          /* and/or/sub hl,de, bool hl, rr hl */
        feat |= IR_FEAT_HL_DE_LOGIC | IR_FEAT_BOOL_HL | IR_FEAT_PAIR_ROT;
        feat |= IR_FEAT_CRIT_IP;       /* no di/ei: __critical via ipset/ipres */
    }
    if (c_cpu & (CPU_R4K | CPU_R6K))   /* native `xor/sub/cp hl,de` */
        feat |= IR_FEAT_HL_DE_LOGIC4;
    if (c_cpu & CPU_RABBIT)            /* ld hl,(sp+N), N 0..255, HL only */
        feat |= IR_FEAT_SP_REL_HL | IR_FEAT_SP_REL_WIDE;
    if (IS_KC160())                    /* ld hl/de/bc,(sp+d), d signed byte */
        feat |= IR_FEAT_SP_REL_HL | IR_FEAT_SP_REL_PAIRS;
    if (IS_EZ80() || IS_KC160())       /* native word-wise ld hl,(ix+d) */
        feat |= IR_FEAT_IX_WORD;
    if ((c_cpu & CPU_RABBIT) || IS_GBZ80())   /* add sp,d (signed byte) */
        feat |= IR_FEAT_ADD_SP_IMM;
    if (IS_EZ80())                            /* lea ix+d; ld r,(hl) word */
        feat |= IR_FEAT_LEA | IR_FEAT_LD_HL_IND;
    if (IS_Z80N())                            /* Spectrum Next extra ALU ops */
        feat |= IR_FEAT_ADD_PAIR_IMM | IR_FEAT_ADD_PAIR_A
              | IR_FEAT_BARREL_SHIFT;
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
