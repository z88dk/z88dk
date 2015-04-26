
; size_t w_array_erase_range_callee(w_array_t *a, size_t idx_first, size_t idx_last)

SECTION code_adt_w_array

PUBLIC _w_array_erase_range_callee

_w_array_erase_range_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   INCLUDE "adt/w_array/z80/asm_w_array_erase_range.asm"
