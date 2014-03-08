
; w_vector_t *w_vector_init(void *p, size_t capacity, size_t max_size)

XDEF w_vector_init

w_vector_init:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af
   
   INCLUDE "../../z80/asm_w_vector_init.asm"
