/*
 * ir_build.h — AST → IR translator.
 *
 * Entry point invoked from declparse.c when --use-ir is set. Walks
 * the per-function AST and produces a Func* that ir_lower then turns
 * into z80 asm. Sits behind a feature flag — the legacy walker
 * (ast_codegen2.c) remains the default until Phase 7 cutover.
 *
 * Scope (Phase 1): grows incrementally toward making the CRC-16-CCITT
 * kernel in test/suites/intbench/intbench.c compile + run. Most C
 * constructs are not yet handled and will abort with a diagnostic.
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
