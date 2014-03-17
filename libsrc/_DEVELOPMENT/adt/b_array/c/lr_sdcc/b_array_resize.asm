
; int b_array_resize(b_array_t *a, size_t n)

XDEF b_array_resize

b_array_resize:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   INCLUDE "../../z80/asm_b_array_resize.asm"
