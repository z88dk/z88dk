
; size_t w_vector_insert(w_vector_t *v, size_t idx, void *item)

PUBLIC w_vector_insert_callee

w_vector_insert_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   INCLUDE "adt/w_vector/z80/asm_w_vector_insert.asm"
