
; size_t b_array_push_back(b_array_t *a, int c)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC _b_array_push_back

EXTERN _b_array_append

defc _b_array_push_back = _b_array_append
