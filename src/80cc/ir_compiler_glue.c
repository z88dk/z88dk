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

/* Spare index register for a loop-invariant resident — the one opposite the
   frame pointer. c_framepointer_is_ix: 1=IX frame→spare IY, 0=IY frame→spare
   IX, -1=sp-mode→IX (both free, pick IX). 808x/gbz80 have no index regs →
   gate on CPU. */
int ir_idx2_reg(void)
{
    if (!c_idx2_invariant) return IR_PR_NONE;
    if (getenv("IR_NO_IDX2")) return IR_PR_NONE;
    if (IS_808x() || IS_GBZ80()) return IR_PR_NONE;
    if (c_framepointer_is_ix == 1) return IR_PR_IY;   /* frame IX → spare IY */
    return IR_PR_IX;                                  /* frame IY, or sp-mode → IX */
}

/* Bridge the lowerer's FILE* interface to the compiler's global
   `output` stream, so ir_build.c needn't drag <stdio.h> globals
   through its API. */
int ir_lower_to_output(Func *f)
{
    if (getenv("IR_DUMP"))
        ir_dump_func(stderr, f);
    /* Buffer the lowering and only flush on success. A mid-function
       lowering failure returns nonzero (fatal in the caller); without
       buffering, the partially emitted asm would land in the output
       with dangling label references. */
    /* Buffer to a temp file rather than open_memstream — the latter is POSIX-
       only and absent on mingw/Windows. Copy to `output` only on success. */
    FILE *mem = tmpfile();
    if (!mem)
        return ir_lower_func(output, f);   /* degraded: direct emit */
    int rc = ir_lower_func(mem, f);
    if (rc == 0) {
        rewind(mem);
        char chunk[4096];
        size_t n;
        while ((n = fread(chunk, 1, sizeof chunk, mem)) > 0)
            fwrite(chunk, 1, n, output);
    }
    fclose(mem);
    return rc;
}

/* Set IR_DUMP=1 in the environment to dump the IR for each function
   to stderr before lowering. Cheap diagnostic for inspecting the
   shape of generated IR without rebuilding. */
