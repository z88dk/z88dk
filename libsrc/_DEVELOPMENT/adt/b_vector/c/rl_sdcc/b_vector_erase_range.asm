
; size_t b_vector_erase_range(b_vector_t *v, size_t idx_first, size_t idx_last)

XDEF b_vector_erase_range

b_vector_erase_range:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   INCLUDE "../../z80/asm_b_vector_erase_range.asm"
