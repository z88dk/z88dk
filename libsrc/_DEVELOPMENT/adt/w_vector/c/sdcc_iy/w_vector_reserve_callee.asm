
; int w_vector_reserve_callee(w_vector_t *v, size_t n)

SECTION code_adt_w_vector

PUBLIC _w_vector_reserve_callee

_w_vector_reserve_callee:

   pop af
   pop hl
   pop bc
   push af
   
   INCLUDE "adt/w_vector/z80/asm_w_vector_reserve.asm"
