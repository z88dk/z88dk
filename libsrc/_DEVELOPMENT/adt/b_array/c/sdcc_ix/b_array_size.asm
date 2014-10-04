
; size_t b_array_size(b_array_t *a)

SECTION seg_code_b_array

PUBLIC _b_array_size

_b_array_size:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_b_array_size
   
   INCLUDE "adt/b_array/z80/asm_b_array_size.asm"
