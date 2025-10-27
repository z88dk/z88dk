
; void w_array_destroy_fastcall(w_array_t *a)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC _w_array_destroy_fastcall

EXTERN asm_w_array_destroy

defc _w_array_destroy_fastcall = asm_w_array_destroy
