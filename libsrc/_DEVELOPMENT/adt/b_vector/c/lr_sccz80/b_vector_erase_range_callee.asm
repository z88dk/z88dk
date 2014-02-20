
; size_t b_vector_erase_range(b_vector_t *v, size_t idx_first, size_t idx_last)

XDEF b_vector_erase_range_callee

b_vector_erase_range_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af
   
   INCLUDE "../../z80/asm_b_vector_erase_range.asm"
