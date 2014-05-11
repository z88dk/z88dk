
; size_t b_vector_erase_range(b_vector_t *v, size_t idx_first, size_t idx_last)

PUBLIC b_vector_erase_range

EXTERN b_array_erase_range

;defc b_vector_erase_range = b_array_erase_range

b_vector_erase_range:

   jp b_array_erase_range
