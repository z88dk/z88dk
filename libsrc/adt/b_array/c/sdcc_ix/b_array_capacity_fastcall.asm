
; size_t b_array_capacity_fastcall(b_array_t *a)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC _b_array_capacity_fastcall

EXTERN asm_b_array_capacity

defc _b_array_capacity_fastcall = asm_b_array_capacity
