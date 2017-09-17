; size_t b_vector_append(b_vector_t *v, int c)

SECTION code_clib
SECTION code_string

MODULE _b_vector_append_callee_sdcc
GLOBAL _b_vector_append_callee
GLOBAL b_vector_append_callee

defc _b_vector_append_callee = b_vector_append_callee

