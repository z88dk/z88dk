
; void *b_vector_init_callee(void *p, size_t capacity, size_t max_size)

SECTION code_adt_b_vector

PUBLIC _b_vector_init_callee

_b_vector_init_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   INCLUDE "adt/b_vector/z80/asm_b_vector_init.asm"
