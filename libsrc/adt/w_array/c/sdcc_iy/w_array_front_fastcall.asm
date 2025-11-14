
; void *w_array_front_fastcall(w_array_t *a)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC _w_array_front_fastcall

EXTERN asm_w_array_front

defc _w_array_front_fastcall = asm_w_array_front
