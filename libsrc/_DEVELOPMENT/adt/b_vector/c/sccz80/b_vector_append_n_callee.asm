
; size_t b_vector_append_n(b_vector_t *v, size_t n, int c)

SECTION seg_code_b_vector

PUBLIC b_vector_append_n_callee

b_vector_append_n_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   INCLUDE "adt/b_vector/z80/asm_b_vector_append_n.asm"
