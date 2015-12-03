
; void *w_array_data(w_array_t *a)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC _w_array_data

EXTERN _b_array_data

defc _w_array_data = _b_array_data
