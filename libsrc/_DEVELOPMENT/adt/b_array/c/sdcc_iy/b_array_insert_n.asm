
; size_t b_array_insert_n(b_array_t *a, size_t idx, size_t n, int c)

SECTION code_adt_b_array

PUBLIC _b_array_insert_n

_b_array_insert_n:

   pop af
   pop hl
   pop bc
   pop de
   pop ix
   
   push ix
   push de
   push bc
   push hl
   push af
   
   ld a,ixl
   
   INCLUDE "adt/b_array/z80/asm_b_array_insert_n.asm"
