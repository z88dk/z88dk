
; void b_vector_destroy(b_vector_t *v)

SECTION code_adt_b_vector

PUBLIC _b_vector_destroy

_b_vector_destroy:

   pop af
   pop hl
   
   push hl
   push af
   
   INCLUDE "adt/b_vector/z80/asm_b_vector_destroy.asm"
