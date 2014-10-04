
; int w_vector_reserve(w_vector_t *v, size_t n)

SECTION seg_code_w_vector

PUBLIC _w_vector_reserve

_w_vector_reserve:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "adt/w_vector/z80/asm_w_vector_reserve.asm"
