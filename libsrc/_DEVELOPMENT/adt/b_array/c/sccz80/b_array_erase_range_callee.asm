
; size_t b_array_erase_range(b_array_t *a, size_t idx_first, size_t idx_last)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC b_array_erase_range_callee

EXTERN asm_b_array_erase_range

b_array_erase_range_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af
   
   jp asm_b_array_erase_range
