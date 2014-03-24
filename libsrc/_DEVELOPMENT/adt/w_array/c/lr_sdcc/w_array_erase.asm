
; size_t w_array_erase(w_array_t *a, size_t idx)

XDEF w_array_erase

w_array_erase:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "adt/w_array/z80/asm_w_array_erase.asm"
