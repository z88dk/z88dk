
; size_t b_array_capacity(b_array_t *a)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC b_array_capacity

EXTERN asm_b_array_capacity

defc b_array_capacity = asm_b_array_capacity
