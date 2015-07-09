
; void b_array_destroy(b_array_t *a)

SECTION code_adt_b_array

PUBLIC b_array_destroy

EXTERN asm_b_array_destroy

defc b_array_destroy = asm_b_array_destroy
