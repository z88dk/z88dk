; int b_vector_at(b_vector_t *v, size_t idx)

SECTION code_clib
SECTION code_string

MODULE _b_vector_at_callee_sdcc
GLOBAL _b_vector_at_callee
GLOBAL b_vector_at_callee

defc _b_vector_at_callee = b_vector_at_callee

