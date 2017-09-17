; int b_vector_resize(b_vector_t *v, size_t n)

SECTION code_clib
SECTION code_string

MODULE _b_vector_resize_callee_sdcc
GLOBAL _b_vector_resize_callee
GLOBAL b_vector_resize_callee

defc _b_vector_resize_callee = b_vector_resize_callee

