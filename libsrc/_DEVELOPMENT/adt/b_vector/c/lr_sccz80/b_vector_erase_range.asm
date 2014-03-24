
; size_t b_vector_erase_range(b_vector_t *v, size_t idx_first, size_t idx_last)

XLIB b_vector_erase_range

LIB b_array_erase_range

;defc b_vector_erase_range = b_array_erase_range

b_vector_erase_range:

   jp b_array_erase_range
