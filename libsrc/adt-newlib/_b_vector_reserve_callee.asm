; int b_vector_reserve(b_vector_t *v, size_t n)

SECTION code_clib
SECTION code_string

MODULE _b_vector_reserve_callee_sdcc
GLOBAL _b_vector_reserve_callee
GLOBAL b_vector_reserve_callee

defc _b_vector_reserve_callee = b_vector_reserve_callee

