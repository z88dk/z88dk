
; int atexit(void (*func)(void))

SECTION code_stdlib

PUBLIC atexit

atexit:

   INCLUDE "stdlib/z80/asm_atexit.asm"
