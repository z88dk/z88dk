
; size_t w_array_size(w_array_t *a)

XDEF w_array_size

w_array_size:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_w_array_size

   INCLUDE "../../z80/asm_w_array_size.asm"
