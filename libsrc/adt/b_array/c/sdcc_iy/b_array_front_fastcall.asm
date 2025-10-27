
; int b_array_front_fastcall(b_array_t *a)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC _b_array_front_fastcall

EXTERN asm_b_array_front

defc _b_array_front_fastcall = asm_b_array_front
