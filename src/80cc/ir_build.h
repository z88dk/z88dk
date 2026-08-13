/*
 * ir_build.h — AST → IR translator.
 *
 * Entry point from declparse.c: walks the per-function AST into a Func*
 * that ir_lower turns into z80 asm. The IR is the sole codegen path.
 *
 * Unhandled C constructs abort with a diagnostic.
 */

#ifndef IR_BUILD_H
#define IR_BUILD_H

#include "ir.h"

/* Compile one function via the IR pipeline. Returns 0 on success,
   non-zero on any failure (build, validate, or lower). Writes asm
   to the global output stream the rest of the compiler uses. */
int ir_generate_code(struct node_s *body, SYMBOL *fn);

/* Lower a Func to the compiler's main output file. Wraps the FILE*
   handoff so the public API doesn't drag <stdio.h> in. Defined in
   ir_compiler_glue.c so it can reach the file handle. */
int ir_lower_to_output(Func *f);

#endif /* IR_BUILD_H */
