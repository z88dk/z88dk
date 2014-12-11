
; size_t b_vector_insert(b_vector_t *v, size_t idx, int c)

SECTION code_adt_b_vector

PUBLIC b_vector_insert_callee

b_vector_insert_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   INCLUDE "adt/b_vector/z80/asm_b_vector_insert.asm"
