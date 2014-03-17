
; int b_vector_reserve(b_vector_t *v, size_t n)

XDEF b_vector_reserve

b_vector_reserve:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jr asm_b_vector_reserve
   
   INCLUDE "../../z80/asm_b_vector_reserve.asm"
