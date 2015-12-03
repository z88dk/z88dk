
; size_t b_array_erase_range(b_array_t *a, size_t idx_first, size_t idx_last)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC b_array_erase_range

EXTERN asm_b_array_erase_range

b_array_erase_range:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af
   
   jp asm_b_array_erase_range
