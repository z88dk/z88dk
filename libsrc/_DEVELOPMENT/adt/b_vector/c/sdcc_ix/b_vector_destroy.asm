
; void b_vector_destroy(b_vector_t *v)

XDEF _b_vector_destroy

_b_vector_destroy:

   pop af
   pop hl
   
   push hl
   push af

   jr asm__b_vector_destroy
   
   INCLUDE "adt/b_vector/z80/asm_b_vector_destroy.asm"
