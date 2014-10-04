
; size_t w_array_erase_range(w_array_t *a, size_t idx_first, size_t idx_last)

SECTION seg_code_w_array

PUBLIC _w_array_erase_range

_w_array_erase_range:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   INCLUDE "adt/w_array/z80/asm_w_array_erase_range.asm"
