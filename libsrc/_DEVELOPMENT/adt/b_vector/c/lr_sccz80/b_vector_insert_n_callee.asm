
; size_t b_vector_insert_n(b_vector_t *v, size_t idx, size_t n, int c)

XDEF b_vector_insert_n_callee

b_vector_insert_n_callee:

   pop hl
   pop bc
   ld a,c
   pop de
   pop bc
   ex (sp),hl
   
   INCLUDE "adt/b_vector/z80/asm_b_vector_insert_n.asm"
