
; size_t b_array_erase(b_array_t *a, size_t idx)

SECTION code_adt_b_array

PUBLIC _b_array_erase

_b_array_erase:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "adt/b_array/z80/asm_b_array_erase.asm"
