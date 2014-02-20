
; int b_vector_resize(b_vector_t *v, size_t n)

XDEF b_vector_resize

b_vector_resize:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "../../z80/asm_b_vector_resize.asm"
