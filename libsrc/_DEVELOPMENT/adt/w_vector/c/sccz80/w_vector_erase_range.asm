
; size_t w_vector_erase_range(w_vector_t *v, size_t idx_first, size_t idx_last)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC w_vector_erase_range

EXTERN w_array_erase_range

defc w_vector_erase_range = w_array_erase_range
