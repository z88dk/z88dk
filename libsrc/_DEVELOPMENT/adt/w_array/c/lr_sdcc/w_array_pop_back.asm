
; void *w_array_pop_back(w_array_t *a)

XDEF w_array_pop_back

w_array_pop_back:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "../../z80/asm_w_array_pop_back.asm"
