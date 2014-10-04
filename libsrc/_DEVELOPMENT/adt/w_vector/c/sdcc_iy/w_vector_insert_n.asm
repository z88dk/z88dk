
; size_t w_vector_insert_n(w_vector_t *v, size_t idx, size_t n, void *item)

SECTION seg_code_w_vector

PUBLIC _w_vector_insert_n

_w_vector_insert_n:

   pop ix
   pop hl
   pop bc
   pop de
   pop af
   
   push af
   push de
   push bc
   push hl
   push ix
   
   INCLUDE "adt/w_vector/z80/asm_w_vector_insert_n.asm"
