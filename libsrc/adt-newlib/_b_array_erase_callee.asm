; size_t b_array_erase(b_array_t *a, size_t idx)

SECTION code_clib
SECTION code_string

MODULE _b_array_erase_callee_sdcc
GLOBAL _b_array_erase_callee
GLOBAL b_array_erase_callee

defc _b_array_erase_callee = b_array_erase_callee

