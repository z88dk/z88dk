
; int b_array_front(b_array_t *a)

XDEF _b_array_front

_b_array_front:

   pop af
   pop hl
   
   push hl
   push af
   
   jr asm_b_array_front
   
   INCLUDE "adt/b_array/z80/asm_b_array_front.asm"
