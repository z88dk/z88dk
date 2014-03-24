
; w_vector_t *w_vector_init(void *p, size_t capacity, size_t max_size)

XDEF w_vector_init_callee

w_vector_init_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af
   
   INCLUDE "adt/w_vector/z80/asm_w_vector_init.asm"
