
; int at_quick_exit(void (*func)(void))

XDEF at_quick_exit

at_quick_exit:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_at_quick_exit.asm"
