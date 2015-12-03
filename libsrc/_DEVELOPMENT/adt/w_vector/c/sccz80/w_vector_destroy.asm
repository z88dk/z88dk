
; void w_vector_destroy(w_vector_t *v)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC w_vector_destroy

EXTERN asm_w_vector_destroy

defc w_vector_destroy = asm_w_vector_destroy
