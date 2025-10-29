
; void *w_vector_front_fastcall(w_vector_t *v)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC _w_vector_front_fastcall

EXTERN asm_w_vector_front

defc _w_vector_front_fastcall = asm_w_vector_front
