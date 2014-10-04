
; size_t w_array_capacity(w_array_t *a)

SECTION seg_code_w_array

PUBLIC _w_array_capacity

_w_array_capacity:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "adt/w_array/z80/asm_w_array_capacity.asm"
