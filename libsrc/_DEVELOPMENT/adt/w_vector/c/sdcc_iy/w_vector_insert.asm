
; size_t w_vector_insert(w_vector_t *v, size_t idx, void *item)

PUBLIC _w_vector_insert

_w_vector_insert:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af
   
   INCLUDE "adt/w_vector/z80/asm_w_vector_insert.asm"
