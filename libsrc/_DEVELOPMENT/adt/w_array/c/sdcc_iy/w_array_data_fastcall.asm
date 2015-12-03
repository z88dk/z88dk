
; void *w_array_data_fastcall(w_array_t *a)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC _w_array_data_fastcall

EXTERN asm_w_array_data

defc _w_array_data_fastcall = asm_w_array_data
