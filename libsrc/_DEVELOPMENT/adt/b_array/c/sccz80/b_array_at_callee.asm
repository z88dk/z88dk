
; int b_array_at(b_array_t *a, size_t idx)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC b_array_at_callee

EXTERN asm_b_array_at

b_array_at_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_b_array_at
