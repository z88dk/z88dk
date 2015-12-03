
; void w_vector_clear(w_vector_t *v)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC w_vector_clear

EXTERN asm_w_vector_clear

defc w_vector_clear = asm_w_vector_clear
