
; size_t b_array_append(b_array_t *a, int c)

SECTION seg_code_b_array

PUBLIC _b_array_append

_b_array_append:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "adt/b_array/z80/asm_b_array_append.asm"
