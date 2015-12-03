
; size_t w_vector_push_back(w_vector_t *v, void *item)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC w_vector_push_back_callee

EXTERN w_vector_append_callee

defc w_vector_push_back_callee = w_vector_append_callee
