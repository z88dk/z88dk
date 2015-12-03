
; size_t w_array_size_fastcall(w_array_t *a)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC _w_array_size

EXTERN asm_w_array_size

defc _w_array_size_fastcall = asm_w_array_size
