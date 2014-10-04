
; w_vector_t *w_vector_init(void *p, size_t capacity, size_t max_size)

SECTION seg_code_w_vector

PUBLIC w_vector_init_callee

w_vector_init_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af
   
   INCLUDE "adt/w_vector/z80/asm_w_vector_init.asm"
