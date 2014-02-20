
; void *b_vector_init(void *p, size_t capacity, size_t max_size)

XDEF b_vector_init

b_vector_init:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   INCLUDE "../../z80/asm_b_vector_init.asm"
