
; size_t b_vector_insert_n_callee(b_vector_t *v, size_t idx, size_t n, int c)

SECTION code_adt_b_vector

PUBLIC _b_vector_insert_n_callee, l0_b_vector_insert_n_callee

_b_vector_insert_n_callee:

   pop af
   pop hl
   pop bc
   pop de
   exx
   pop bc
   push af

l0_b_vector_insert_n_callee:

   ld a,c
   exx
   
   INCLUDE "adt/b_vector/z80/asm_b_vector_insert_n.asm"
