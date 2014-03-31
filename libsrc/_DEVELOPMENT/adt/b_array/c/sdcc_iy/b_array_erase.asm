
; size_t b_array_erase(b_array_t *a, size_t idx)

XDEF b_array_erase

b_array_erase:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "adt/b_array/z80/asm_b_array_erase.asm"
