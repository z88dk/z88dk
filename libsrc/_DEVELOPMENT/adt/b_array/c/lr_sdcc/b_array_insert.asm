
; size_t b_array_insert(b_array_t *a, size_t idx, int c)

XDEF b_array_insert

b_array_insert:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   INCLUDE "adt/b_array/z80/asm_b_array_insert.asm"
