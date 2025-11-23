
; void *w_array_pop_back_fastcall(w_array_t *a)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC _w_array_pop_back_fastcall

EXTERN asm_w_array_pop_back

defc _w_array_pop_back_fastcall = asm_w_array_pop_back
