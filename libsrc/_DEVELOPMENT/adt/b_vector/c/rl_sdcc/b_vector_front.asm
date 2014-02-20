
; int b_vector_front(b_vector_t *v)

XDEF b_vector_front

b_vector_front:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_b_vector_front.asm"
