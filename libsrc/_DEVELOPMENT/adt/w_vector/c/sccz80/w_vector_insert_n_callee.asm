
; size_t w_vector_insert_n(w_vector_t *v, size_t idx, size_t n, void *item)

SECTION code_adt_w_vector

PUBLIC w_vector_insert_n_callee

w_vector_insert_n_callee:

   pop ix
   pop af
   pop de
   pop bc
   pop hl
   push ix
   
   INCLUDE "adt/w_vector/z80/asm_w_vector_insert_n.asm"
