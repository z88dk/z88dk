
; size_t w_vector_insert_callee(w_vector_t *v, size_t idx, void *item)

SECTION code_adt_w_vector

PUBLIC _w_vector_insert_callee

_w_vector_insert_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af
   
   INCLUDE "adt/w_vector/z80/asm_w_vector_insert.asm"
