
; int w_vector_reserve(w_vector_t *v, size_t n)

XDEF w_vector_reserve

w_vector_reserve:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "adt/w_vector/z80/asm_w_vector_reserve.asm"
