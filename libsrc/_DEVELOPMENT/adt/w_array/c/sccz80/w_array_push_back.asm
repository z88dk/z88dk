
; size_t w_array_push_back(w_array_t *a, void *item)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC w_array_push_back

EXTERN w_array_append

defc w_array_push_back = w_array_append
