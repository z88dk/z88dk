; size_t b_array_insert_n(b_array_t *a, size_t idx, size_t n, int c)

SECTION code_clib
SECTION code_string

MODULE _b_array_insert_n_callee_sdcc
GLOBAL _b_array_insert_n_callee
GLOBAL b_array_insert_n_callee

defc _b_array_insert_n_callee = b_array_insert_n_callee

