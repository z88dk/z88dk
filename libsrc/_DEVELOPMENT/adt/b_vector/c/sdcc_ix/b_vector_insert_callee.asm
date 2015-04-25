
; size_t b_vector_insert_callee(b_vector_t *v, size_t idx, int c)

SECTION code_adt_b_vector

PUBLIC _b_vector_insert_callee

_b_vector_insert_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af
   
   INCLUDE "adt/b_vector/z80/asm_b_vector_insert.asm"
