
; size_t w_vector_insert_n_callee(w_vector_t *v, size_t idx, size_t n, void *item)

SECTION code_adt_w_vector

PUBLIC _w_vector_insert_n_callee, l0_w_vector_insert_n_callee

_w_vector_insert_n_callee:

   exx
   pop bc
   exx
   pop hl
   pop bc
   pop de
   pop af

l0_w_vector_insert_n_callee:

   exx
   push bc
   exx
   
   INCLUDE "adt/w_vector/z80/asm_w_vector_insert_n.asm"
