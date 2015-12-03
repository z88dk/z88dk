
; size_t w_vector_erase_range_callee(w_vector_t *v, size_t idx_first, size_t idx_last)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC _w_vector_erase_range_callee

EXTERN _w_array_erase_range_callee

defc _w_vector_erase_range_callee = _w_array_erase_range_callee
