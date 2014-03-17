
; size_t b_vector_insert_n(b_vector_t *v, size_t idx, size_t n, int c)

XDEF b_vector_insert_n

b_vector_insert_n:

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
   
   INCLUDE "../../z80/asm_b_vector_insert_n.asm"
