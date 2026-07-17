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
   frame pointer. c_framepointer_is_ix: 1=IX frame→spare IY, -1=sp-mode→IX (both
   free, pick IX). 808x/gbz80 have no index regs → gate on CPU. A platform can
   remove the spare from play: --reserve-regs-iy (the fp-mode spare) or, in
   sp-mode, --reserve-regs-ix. */
int ir_idx2_reg(void)
{
    if (!c_idx2_invariant) return IR_PR_NONE;
    if (opt_disabled("idx2")) return IR_PR_NONE;
    if (IS_808x() || IS_GBZ80()) return IR_PR_NONE;
    if (c_framepointer_is_ix == 1)                    /* frame IX → spare IY */
        return c_reserve_iy ? IR_PR_NONE : IR_PR_IY;
    return c_reserve_ix ? IR_PR_NONE : IR_PR_IX;      /* sp-mode → IX */
}

/* Second index-register home = IY, available ONLY in true sp-mode (no frame
   pointer): there IX is the idx2 spare and IY is otherwise free. In fp-modes
   one index is the frame and the other is idx2, so no third index exists.
   Needs index-half read/write/compare (ld iyl,c / sub iyl) → z80/z80n only
   (z180 traps the undocumented index-half opcodes). Opt-in via c_idx3_residency
   because some targets reserve IY. IY is callee-saved → the lowerer must
   push/pop it in the prologue when a value is homed here. */
int ir_idx3_reg(void)
{
    if (!c_idx3_residency) return IR_PR_NONE;
    if (opt_disabled("idx3")) return IR_PR_NONE;
    if (c_reserve_iy) return IR_PR_NONE;               /* IY reserved by platform */
    if (ir_idx2_reg() != IR_PR_IX) return IR_PR_NONE;  /* need IX as idx2 */
    if (c_framepointer_is_ix != -1) return IR_PR_NONE; /* IY is the frame */
    if (!(c_cpu == CPU_Z80 || IS_Z80N())) return IR_PR_NONE;
    return IR_PR_IY;
}

/* exx/alt-bank home for a loop-invariant word — sp-mode only, z80/z80n (the
   A-bridge compare uses `exx` + A/flags surviving the swap). Opt-in via
   c_exx_residency (targets may reserve the shadow set). Per-function gates
   (float/FA using the alt bank, far-helper calls that exx) are applied in the
   allocator where the Func is available. Uses BC' — HL'/DE' stay free as exx
   scratch / for a second invariant later. */
int ir_exx_reg(void)
{
    if (!c_exx_residency) return IR_PR_NONE;
    if (opt_disabled("exx")) return IR_PR_NONE;
    if (c_framepointer_is_ix != -1) return IR_PR_NONE;   /* sp-mode only */
    if (!(c_cpu == CPU_Z80 || IS_Z80N())) return IR_PR_NONE;
    return IR_PR_BC_ALT;
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
