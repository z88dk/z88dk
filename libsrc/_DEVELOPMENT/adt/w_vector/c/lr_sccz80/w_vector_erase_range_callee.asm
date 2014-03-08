
; size_t w_vector_erase_range(w_vector_t *v, size_t idx_first, size_t idx_last)

XDEF w_vector_erase_range_callee

w_vector_erase_range_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af
   
   INCLUDE "../../z80/asm_w_vector_erase_range.asm"
