
; int w_vector_resize(w_vector_t *v, size_t n)

PUBLIC w_vector_resize_callee

w_vector_resize_callee:

   pop hl
   pop de
   ex (sp),hl
   
   INCLUDE "adt/w_vector/z80/asm_w_vector_resize.asm"
