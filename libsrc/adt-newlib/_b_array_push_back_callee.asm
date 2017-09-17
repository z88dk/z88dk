; size_t b_array_push_back(b_array_t *a, int c)

SECTION code_clib
SECTION code_string

MODULE _b_array_push_back_callee_sdcc
GLOBAL _b_array_push_back_callee
GLOBAL b_array_push_back_callee

defc _b_array_push_back_callee = b_array_push_back_callee

