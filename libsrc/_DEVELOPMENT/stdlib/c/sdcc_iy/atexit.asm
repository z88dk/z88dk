
; int atexit(void (*func)(void))

XDEF atexit

atexit:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "stdlib/z80/asm_atexit.asm"
