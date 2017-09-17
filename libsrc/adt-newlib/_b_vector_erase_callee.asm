; size_t b_vector_erase(b_vector_t *v, size_t idx)

SECTION code_clib
SECTION code_string

MODULE _b_vector_erase_callee_sdcc
GLOBAL _b_vector_erase_callee
GLOBAL b_vector_erase_callee

defc _b_vector_erase_callee = b_vector_erase_callee

