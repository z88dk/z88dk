
; size_t b_array_insert(b_array_t *a, size_t idx, int c)

XDEF b_array_insert

b_array_insert:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af
   
   INCLUDE "adt/b_array/z80/asm_b_array_insert.asm"
