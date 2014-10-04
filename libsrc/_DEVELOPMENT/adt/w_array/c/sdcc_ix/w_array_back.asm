
; void *w_array_back(w_array_t *a)

SECTION seg_code_w_array

PUBLIC _w_array_back

_w_array_back:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "adt/w_array/z80/asm_w_array_back.asm"
