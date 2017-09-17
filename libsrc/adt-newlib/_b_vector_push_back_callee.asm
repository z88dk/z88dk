; size_t b_vector_push_back(b_vector_t *v, int c)

SECTION code_clib
SECTION code_string

MODULE _b_vector_push_back_callee_sdcc
GLOBAL _b_vector_push_back_callee
GLOBAL b_vector_push_back_callee

defc _b_vector_push_back_callee = b_vector_push_back_callee

