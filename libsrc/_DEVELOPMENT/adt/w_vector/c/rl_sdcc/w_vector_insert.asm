
; size_t w_vector_insert(w_vector_t *v, size_t idx, void *item)

XDEF w_vector_insert

w_vector_insert:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af
   
   INCLUDE "../../z80/asm_w_vector_insert.asm"
