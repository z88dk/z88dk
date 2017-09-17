; int b_array_at(b_array_t *a, size_t idx)

SECTION code_clib
SECTION code_string

MODULE _b_array_at_callee_sdcc
GLOBAL _b_array_at_callee
GLOBAL b_array_at_callee

defc _b_array_at_callee = b_array_at_callee

