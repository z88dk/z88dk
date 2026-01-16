
; void *w_vector_pop_back_fastcall(w_vector_t *v)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC _w_vector_pop_back_fastcall

EXTERN asm_w_vector_pop_back

defc _w_vector_pop_back_fastcall = asm_w_vector_pop_back
