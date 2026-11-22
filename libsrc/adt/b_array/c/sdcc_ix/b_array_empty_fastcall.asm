
; int b_array_empty_fastcall(b_array_t *a)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC _b_array_empty_fastcall

EXTERN asm_b_array_empty

defc _b_array_empty_fastcall = asm_b_array_empty
