
; int b_array_front(b_array_t *a)

XDEF b_array_front

b_array_front:

   pop af
   pop hl
   
   push hl
   push af
   
   jr asm_b_array_front
   
   INCLUDE "../../z80/asm_b_array_front.asm"
