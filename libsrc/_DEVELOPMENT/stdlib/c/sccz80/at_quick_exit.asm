
; int at_quick_exit(void (*func)(void))

SECTION seg_code_stdlib

PUBLIC at_quick_exit

at_quick_exit:

   INCLUDE "stdlib/z80/asm_at_quick_exit.asm"
