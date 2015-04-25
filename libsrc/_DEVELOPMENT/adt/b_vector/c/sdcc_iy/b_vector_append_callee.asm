
; size_t b_vector_append_callee(b_vector_t *v, int c)

SECTION code_adt_b_vector

PUBLIC _b_vector_append_callee

_b_vector_append_callee:

   pop af
   pop hl
   pop bc
   push af
   
   INCLUDE "adt/b_vector/z80/asm_b_vector_append.asm"
