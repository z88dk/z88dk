
; size_t b_vector_insert_n(b_vector_t *v, size_t idx, size_t n, int c)

SECTION seg_code_b_vector

PUBLIC _b_vector_insert_n

_b_vector_insert_n:

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
   
   INCLUDE "adt/b_vector/z80/asm_b_vector_insert_n.asm"
