
; size_t b_vector_insert_n(b_vector_t *v, size_t idx, size_t n, int c)

SECTION code_adt_b_vector

PUBLIC _b_vector_insert_n

_b_vector_insert_n:

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
   
   INCLUDE "adt/b_vector/z80/asm_b_vector_insert_n.asm"
