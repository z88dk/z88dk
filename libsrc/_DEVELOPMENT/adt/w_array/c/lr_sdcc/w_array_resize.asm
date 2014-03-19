
; int w_array_resize(w_array_t *a, size_t n)

XDEF w_array_resize

w_array_resize:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   INCLUDE "../../z80/asm_w_array_resize.asm"
