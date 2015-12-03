
; size_t w_array_push_back(w_array_t *a, void *item)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC _w_array_push_back

EXTERN _w_array_append

defc _w_array_push_back = _w_array_append
