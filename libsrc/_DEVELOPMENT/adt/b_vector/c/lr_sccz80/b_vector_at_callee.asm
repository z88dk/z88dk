
; int b_vector_at(b_vector_t *v, size_t idx)

XDEF b_vector_at_callee

b_vector_at_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "../../z80/asm_b_vector_at.asm"
