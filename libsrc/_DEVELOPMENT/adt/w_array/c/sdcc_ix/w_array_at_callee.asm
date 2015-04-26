
; void *w_array_at_callee(w_array_t *a, size_t idx)

SECTION code_adt_w_array

PUBLIC _w_array_at_callee

_w_array_at_callee:

   pop af
   pop hl
   pop bc
   push af
   
   INCLUDE "adt/w_array/z80/asm_w_array_at.asm"
