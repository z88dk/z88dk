
; int b_array_empty(b_array_t *a)

SECTION seg_code_b_array

PUBLIC _b_array_empty

_b_array_empty:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_b_array_empty
   
   INCLUDE "adt/b_array/z80/asm_b_array_empty.asm"
