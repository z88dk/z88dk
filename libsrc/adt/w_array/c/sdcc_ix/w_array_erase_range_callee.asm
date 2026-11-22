
; size_t w_array_erase_range_callee(w_array_t *a, size_t idx_first, size_t idx_last)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC _w_array_erase_range_callee

EXTERN asm_w_array_erase_range

_w_array_erase_range_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   jp asm_w_array_erase_range
