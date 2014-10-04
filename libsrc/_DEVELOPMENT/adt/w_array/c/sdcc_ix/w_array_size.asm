
; size_t w_array_size(w_array_t *a)

PUBLIC _w_array_size

_w_array_size:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_w_array_size

   INCLUDE "adt/w_array/z80/asm_w_array_size.asm"
