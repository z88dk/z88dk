
; size_t b_vector_erase(b_vector_t *v, size_t idx)

XDEF b_vector_erase_callee

b_vector_erase_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "../../z80/asm_b_vector_erase.asm"
