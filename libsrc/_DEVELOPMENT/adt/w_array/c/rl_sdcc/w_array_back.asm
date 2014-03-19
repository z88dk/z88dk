
; void *w_array_back(w_array_t *a)

XDEF w_array_back

w_array_back:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_w_array_back.asm"
