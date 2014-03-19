
; int w_array_resize(w_array_t *a, size_t n)

XDEF w_array_resize

w_array_resize:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "../../z80/asm_w_array_resize.asm"
