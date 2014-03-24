
; size_t b_vector_read_block(void *dst, size_t n, b_vector_t *v, size_t idx)

XLIB b_vector_read_block

LIB b_array_read_block

;defc b_vector_read_block = b_array_read_block

b_vector_read_block:

   jp b_array_read_block
