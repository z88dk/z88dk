
; int b_array_empty(b_array_t *a)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC b_array_empty

EXTERN asm_b_array_empty

defc b_array_empty = asm_b_array_empty
