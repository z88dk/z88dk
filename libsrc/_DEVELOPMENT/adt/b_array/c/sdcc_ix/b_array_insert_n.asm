
; size_t b_array_insert_n(b_array_t *a, size_t idx, size_t n, int c)

SECTION seg_code_b_array

PUBLIC _b_array_insert_n

_b_array_insert_n:

   pop af
   pop hl
   pop bc
   pop de
   exx
   pop bc
   
   push bc
   exx
   push de
   push bc
   push hl
   push af
   
   exx
   ld a,c
   exx
   
   INCLUDE "adt/b_array/z80/asm_b_array_insert_n.asm"
