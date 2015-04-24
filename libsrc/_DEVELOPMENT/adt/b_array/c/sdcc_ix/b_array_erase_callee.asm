
; size_t b_array_erase_callee(b_array_t *a, size_t idx)

SECTION code_adt_b_array

PUBLIC _b_array_erase_callee

_b_array_erase_callee:

   pop af
   pop hl
   pop bc
   push af
   
   INCLUDE "adt/b_array/z80/asm_b_array_erase.asm"
