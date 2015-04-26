
; w_vector_t *w_vector_init_callee(void *p, size_t capacity, size_t max_size)

SECTION code_adt_w_vector

PUBLIC _w_vector_init_callee

_w_vector_init_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   INCLUDE "adt/w_vector/z80/asm_w_vector_init.asm"
