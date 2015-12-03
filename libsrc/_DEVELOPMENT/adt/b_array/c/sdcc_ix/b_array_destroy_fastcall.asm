
; void b_array_destroy_fastcall(b_array_t *a)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC _b_array_destroy_fastcall

EXTERN asm_b_array_destroy

defc _b_array_destroy_fastcall = asm_b_array_destroy 
