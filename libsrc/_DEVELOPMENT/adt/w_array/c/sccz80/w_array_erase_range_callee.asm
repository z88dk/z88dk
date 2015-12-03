
; size_t w_array_erase_range(w_array_t *a, size_t idx_first, size_t idx_last)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC w_array_erase_range_callee

EXTERN asm_w_array_erase_range

w_array_erase_rangle_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af
   
   jp asm_w_array_erase_range
