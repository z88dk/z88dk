
; void *w_array_front(w_array_t *a)

SECTION code_adt_w_array

PUBLIC _w_array_front

_w_array_front:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "adt/w_array/z80/asm_w_array_front.asm"
