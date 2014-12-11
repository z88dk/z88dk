
; int w_vector_reserve(w_vector_t *v, size_t n)

SECTION code_adt_w_vector

PUBLIC w_vector_reserve_callee

w_vector_reserve_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "adt/w_vector/z80/asm_w_vector_reserve.asm"
