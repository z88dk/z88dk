
; size_t b_vector_append(b_vector_t *v, int c)

SECTION code_adt_b_vector

PUBLIC _b_vector_append

_b_vector_append:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "adt/b_vector/z80/asm_b_vector_append.asm"
