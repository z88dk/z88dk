
; size_t w_vector_erase(w_vector_t *v, size_t idx)

XDEF w_vector_erase_callee

w_vector_erase_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "../../z80/asm_w_vector_erase.asm"
