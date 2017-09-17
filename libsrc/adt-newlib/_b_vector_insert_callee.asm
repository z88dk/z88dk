; size_t b_vector_insert(b_vector_t *v, size_t idx, int c)

SECTION code_clib
SECTION code_string

MODULE _b_vector_insert_callee_sdcc
GLOBAL _b_vector_insert_callee
GLOBAL b_vector_insert_callee

defc _b_vector_insert_callee = b_vector_insert_callee

