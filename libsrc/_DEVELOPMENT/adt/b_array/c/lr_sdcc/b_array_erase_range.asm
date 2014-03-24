
; size_t b_array_erase_range(b_array_t *a, size_t idx_first, size_t idx_last)

XDEF b_array_erase_range

b_array_erase_range:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af
   
   INCLUDE "adt/b_array/z80/asm_b_array_erase_range.asm"
