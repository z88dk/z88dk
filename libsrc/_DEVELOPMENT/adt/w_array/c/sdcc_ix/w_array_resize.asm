
; int w_array_resize(w_array_t *a, size_t n)

PUBLIC _w_array_resize

_w_array_resize:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "adt/w_array/z80/asm_w_array_resize.asm"
