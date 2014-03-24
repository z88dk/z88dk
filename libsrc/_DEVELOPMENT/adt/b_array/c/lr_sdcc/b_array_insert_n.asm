
; size_t b_array_insert_n(b_array_t *a, size_t idx, size_t n, int c)

XDEF b_array_insert_n

b_array_insert_n:

   pop af
   exx
   pop bc
   exx
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   exx
   push bc
   push af
   ld a,c
   exx
   
   INCLUDE "adt/b_array/z80/asm_b_array_insert_n.asm"
