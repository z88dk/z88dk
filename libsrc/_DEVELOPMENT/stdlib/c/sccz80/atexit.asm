
; int atexit(void (*func)(void))

SECTION seg_code_stdlib

PUBLIC atexit

atexit:

   INCLUDE "stdlib/z80/asm_atexit.asm"
