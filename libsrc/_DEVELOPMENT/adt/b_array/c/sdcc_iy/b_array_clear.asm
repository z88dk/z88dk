
; void b_array_clear(b_array_t *a)

SECTION code_adt_b_array

PUBLIC _b_array_clear

_b_array_clear:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_b_array_clear
   
   INCLUDE "adt/b_array/z80/asm_b_array_clear.asm"
