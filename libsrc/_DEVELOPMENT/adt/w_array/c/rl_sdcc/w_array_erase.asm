
; size_t w_array_erase(w_array_t *a, size_t idx)

XDEF w_array_erase

w_array_erase:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "../../z80/asm_w_array_erase.asm"
