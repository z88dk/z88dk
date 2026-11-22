
; _Noreturn void abort(void)

SECTION code_clib
SECTION code_stdlib

PUBLIC abort

EXTERN asm_abort

defc abort = asm_abort
