
; size_t b_array_erase_range_callee(b_array_t *a, size_t idx_first, size_t idx_last)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC _b_array_erase_range_callee

EXTERN asm_b_array_erase_range

_b_array_erase_range_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   jp asm_b_array_erase_range
