
; int b_array_front(b_array_t *a)

SECTION code_adt_b_array

PUBLIC _b_array_front

_b_array_front:

   pop af
   pop hl
   
   push hl
   push af
   
   INCLUDE "adt/b_array/z80/asm_b_array_front.asm"
