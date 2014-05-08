
; void *w_array_pop_back(w_array_t *a)

PUBLIC _w_array_pop_back

_w_array_pop_back:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "adt/w_array/z80/asm_w_array_pop_back.asm"
