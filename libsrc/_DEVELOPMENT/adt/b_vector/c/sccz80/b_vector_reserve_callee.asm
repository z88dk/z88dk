
; int b_vector_reserve(b_vector_t *v, size_t n)

SECTION seg_code_b_vector

PUBLIC b_vector_reserve_callee

b_vector_reserve_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "adt/b_vector/z80/asm_b_vector_reserve.asm"
