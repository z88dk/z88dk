
; int atexit(void (*func)(void))

SECTION code_clib
SECTION code_stdlib

PUBLIC atexit

EXTERN asm_atexit

defc atexit = asm_atexit
