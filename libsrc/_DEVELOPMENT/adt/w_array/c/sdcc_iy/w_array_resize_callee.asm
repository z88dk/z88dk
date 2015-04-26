
; int w_array_resize_callee(w_array_t *a, size_t n)

SECTION code_adt_w_array

PUBLIC _w_array_resize_callee

_w_array_resize_callee:

   pop af
   pop hl
   pop de
   push af
   
   INCLUDE "adt/w_array/z80/asm_w_array_resize.asm"
