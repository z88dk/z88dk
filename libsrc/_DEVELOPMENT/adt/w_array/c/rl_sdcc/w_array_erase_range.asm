
; size_t w_array_erase_range(w_array_t *a, size_t idx_first, size_t idx_last)

XDEF w_array_erase_range

w_array_erase_range:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   INCLUDE "../../z80/asm_w_array_erase_range.asm"
