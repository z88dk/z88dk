; size_t b_array_append(b_array_t *a, int c)

SECTION code_clib
SECTION code_string

MODULE _b_array_append_callee_sdcc
GLOBAL _b_array_append_callee
GLOBAL b_array_append_callee

defc _b_array_append_callee = b_array_append_callee

