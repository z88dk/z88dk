
; _Noreturn void abort(void)

SECTION code_clib
SECTION code_stdlib

PUBLIC _abort

EXTERN asm_abort

defc _abort = asm_abort
