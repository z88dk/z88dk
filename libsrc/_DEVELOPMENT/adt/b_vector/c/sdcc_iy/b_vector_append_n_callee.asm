
; size_t b_vector_append_n_callee(b_vector_t *v, size_t n, int c)

SECTION code_adt_b_vector

PUBLIC _b_vector_append_n_callee

_b_vector_append_n_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   INCLUDE "adt/b_vector/z80/asm_b_vector_append_n.asm"
