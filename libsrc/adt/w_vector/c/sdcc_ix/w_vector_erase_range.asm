
; size_t w_vector_erase_range(w_vector_t *v, size_t idx_first, size_t idx_last)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC _w_vector_erase_range

EXTERN _w_array_erase_range

defc _w_vector_erase_range = _w_array_erase_range
