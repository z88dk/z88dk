
; int at_quick_exit(void (*func)(void))

XDEF _at_quick_exit

_at_quick_exit:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "stdlib/z80/asm_at_quick_exit.asm"
