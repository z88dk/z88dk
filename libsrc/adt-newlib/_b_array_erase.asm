; size_t b_array_erase(b_array_t *a, size_t idx)

SECTION code_clib
SECTION code_string

MODULE _b_array_erase_sdcc
GLOBAL _b_array_erase
GLOBAL b_array_erase

defc _b_array_erase = b_array_erase

