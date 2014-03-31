
; w_vector_t *w_vector_init(void *p, size_t capacity, size_t max_size)

XDEF w_vector_init

w_vector_init:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   INCLUDE "adt/w_vector/z80/asm_w_vector_init.asm"
