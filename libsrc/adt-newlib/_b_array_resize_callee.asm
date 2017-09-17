; int b_array_resize(b_array_t *a, size_t n)

SECTION code_clib
SECTION code_string

MODULE _b_array_resize_callee_sdcc
GLOBAL _b_array_resize_callee
GLOBAL b_array_resize_callee

defc _b_array_resize_callee = b_array_resize_callee

