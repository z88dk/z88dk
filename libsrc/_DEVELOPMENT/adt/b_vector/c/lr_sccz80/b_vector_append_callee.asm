
; size_t b_vector_append(b_vector_t *v, int c)

XDEF b_vector_append_callee

b_vector_append_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "../../z80/asm_b_vector_append.asm"
