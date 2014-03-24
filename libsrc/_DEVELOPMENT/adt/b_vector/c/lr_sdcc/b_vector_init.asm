
; void *b_vector_init(void *p, size_t capacity, size_t max_size)

XDEF b_vector_init

b_vector_init:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af
   
   INCLUDE "adt/b_vector/z80/asm_b_vector_init.asm"
