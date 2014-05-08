
; size_t b_array_size(b_array_t *a)

PUBLIC _b_array_size

_b_array_size:

   pop af
   pop hl
   
   push hl
   push af
   
   INCLUDE "adt/b_array/z80/asm_b_array_size.asm"
