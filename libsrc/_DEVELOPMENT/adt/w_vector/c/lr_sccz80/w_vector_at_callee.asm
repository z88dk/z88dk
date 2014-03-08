
; void *w_vector_at(b_vector_t *v, size_t idx)

XDEF w_vector_at_callee

w_vector_at_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "../../z80/asm_w_vector_at.asm"
