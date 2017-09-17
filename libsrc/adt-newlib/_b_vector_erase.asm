; size_t b_vector_erase(b_vector_t *v, size_t idx)

SECTION code_clib
SECTION code_string

MODULE _b_vector_erase_sdcc
GLOBAL _b_vector_erase
GLOBAL b_vector_erase

defc _b_vector_erase = b_vector_erase

