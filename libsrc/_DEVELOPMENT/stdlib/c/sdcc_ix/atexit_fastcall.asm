
; int atexit_fastcall(void (*func)(void))

SECTION code_stdlib

PUBLIC _atexit_fastcall

_atexit_fastcall:

   INCLUDE "stdlib/z80/asm_atexit.asm"
