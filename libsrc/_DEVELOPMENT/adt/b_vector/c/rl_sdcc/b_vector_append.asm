
; size_t b_vector_append(b_vector_t *v, int c)

XDEF b_vector_append

b_vector_append:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "../../z80/asm_b_vector_append.asm"
