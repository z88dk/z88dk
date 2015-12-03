
; size_t w_vector_erase(w_vector_t *v, size_t idx)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC w_vector_erase_callee

EXTERN w_array_erase_callee

defc w_vector_erase_callee = w_array_erase_callee
