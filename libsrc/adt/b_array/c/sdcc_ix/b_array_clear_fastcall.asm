
; void b_array_clear_fastcall(b_array_t *a)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC _b_array_clear_fastcall

EXTERN asm_b_array_clear

defc _b_array_clear_fastcall = asm_b_array_clear
