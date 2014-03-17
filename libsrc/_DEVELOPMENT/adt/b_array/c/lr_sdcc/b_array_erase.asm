
; size_t b_array_erase(b_array_t *a, size_t idx)

XDEF b_array_erase

b_array_erase:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "../../z80/asm_b_array_erase.asm"
