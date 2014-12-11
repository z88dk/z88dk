
; int b_array_resize(b_array_t *a, size_t n)

SECTION code_adt_b_array

PUBLIC _b_array_resize

_b_array_resize:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   INCLUDE "adt/b_array/z80/asm_b_array_resize.asm"
