
; int b_array_empty(b_array_t *a)

XDEF b_array_empty

b_array_empty:

   pop af
   pop hl
   
   push hl
   push af
   
   INCLUDE "adt/b_array/z80/asm_b_array_empty.asm"
