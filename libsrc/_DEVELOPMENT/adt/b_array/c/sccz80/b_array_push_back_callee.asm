
; size_t b_array_push_back(b_array_t *a, int c)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC b_array_push_back_callee

EXTERN b_array_append_callee

defc b_array_push_back_callee = b_array_append_callee
