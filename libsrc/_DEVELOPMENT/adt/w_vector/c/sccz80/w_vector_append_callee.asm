
; size_t w_vector_append(b_vector_t *v, void *item)

SECTION code_adt_w_vector

PUBLIC w_vector_append_callee

w_vector_append_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "adt/w_vector/z80/asm_w_vector_append.asm"
