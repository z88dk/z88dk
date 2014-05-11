
; size_t b_vector_append(b_vector_t *v, int c)

PUBLIC b_vector_append_callee

b_vector_append_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "adt/b_vector/z80/asm_b_vector_append.asm"
