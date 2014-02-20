
; size_t b_vector_append_n(b_vector_t *v, size_t n, int c)

XDEF b_vector_append_n_callee

b_vector_append_n_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   INCLUDE "../../z80/asm_b_vector_append_n.asm"
