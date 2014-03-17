
; size_t b_vector_append(b_vector_t *v, int c)

XDEF b_vector_append

b_vector_append:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "../../z80/asm_b_vector_append.asm"
