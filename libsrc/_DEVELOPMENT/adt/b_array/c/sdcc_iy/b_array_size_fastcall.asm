
; size_t b_array_size_fastcall(b_array_t *a)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC _b_array_size

EXTERN asm_b_array_size

defc _b_array_size_fastcall = asm_b_array_size
