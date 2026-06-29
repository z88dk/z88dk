/*
 * ir_compiler_glue.c — accessors that bridge the decoupled IR to the
 * rest of the 80cc compiler.
 *
 * ir.c / ir.h / ir_lower.c stay clean of compiler internals so
 * ir_selftest can build standalone. Anything that needs the full
 * compiler type system (SYMBOL fields, Kind decoding, etc.) lives
 * here.
 *
 * The selftest links in its own stubs (see ir_selftest.c) instead of
 * this file.
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

/* Bridge the lowerer's FILE* interface to the compiler's global
   `output` stream. ir_build.c calls this so it doesn't need to drag
   <stdio.h> globals through its API. */
int ir_lower_to_output(Func *f)
{
    if (getenv("IR_DUMP"))
        ir_dump_func(stderr, f);
    return ir_lower_func(output, f);
}

/* Set IR_DUMP=1 in the environment to dump the IR for each function
   to stderr before lowering. Cheap diagnostic for inspecting the
   shape of generated IR without rebuilding. */
