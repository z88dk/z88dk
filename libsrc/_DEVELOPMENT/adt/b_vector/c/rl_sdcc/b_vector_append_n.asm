
; size_t b_vector_append_n(b_vector_t *v, size_t n, int c)

XDEF b_vector_append_n

b_vector_append_n:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   INCLUDE "../../z80/asm_b_vector_append_n.asm"
