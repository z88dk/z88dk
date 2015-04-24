
; size_t b_array_erase_range_callee(b_array_t *a, size_t idx_first, size_t idx_last)

SECTION code_adt_b_array

PUBLIC _b_array_erase_range_callee

_b_array_erase_range_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   INCLUDE "adt/b_array/z80/asm_b_array_erase_range.asm"
