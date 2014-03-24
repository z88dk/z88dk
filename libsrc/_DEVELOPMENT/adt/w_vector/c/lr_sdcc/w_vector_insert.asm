
; size_t w_vector_insert(w_vector_t *v, size_t idx, void *item)

XDEF w_vector_insert

w_vector_insert:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   INCLUDE "adt/w_vector/z80/asm_w_vector_insert.asm"
