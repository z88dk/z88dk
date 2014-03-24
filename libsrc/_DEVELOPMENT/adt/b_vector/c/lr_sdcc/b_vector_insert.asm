
; size_t b_vector_insert(b_vector_t *v, size_t idx, int c)

XDEF b_vector_insert

b_vector_insert:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   INCLUDE "adt/b_vector/z80/asm_b_vector_insert.asm"
