; size_t b_vector_append_n(b_vector_t *v, size_t n, int c)

SECTION code_clib
SECTION code_string

MODULE _b_vector_append_n_callee_sdcc
GLOBAL _b_vector_append_n_callee
GLOBAL b_vector_append_n_callee

defc _b_vector_append_n_callee = b_vector_append_n_callee

