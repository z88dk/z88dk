
; int atexit_fastcall(void (*func)(void))

SECTION code_clib
SECTION code_stdlib

PUBLIC _atexit_fastcall

EXTERN asm_atexit

defc _atexit_fastcall = asm_atexit
