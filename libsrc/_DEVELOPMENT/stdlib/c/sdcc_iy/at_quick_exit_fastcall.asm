
; int at_quick_exit_fastcall(void (*func)(void))

SECTION code_stdlib

PUBLIC _at_quick_exit_fastcall

_at_quick_exit_fastcall:

   INCLUDE "stdlib/z80/asm_at_quick_exit.asm"
