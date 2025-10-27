
; int w_array_empty_fastcall(b_array_t *a)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC _w_array_empty_fastcall

EXTERN asm_w_array_empty

defc _w_array_empty_fastcall = asm_w_array_empty
