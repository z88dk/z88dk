
; int b_vector_reserve(b_vector_t *v, size_t n)

XDEF b_vector_reserve_callee

b_vector_reserve_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "../../z80/asm_b_vector_reserve.asm"
