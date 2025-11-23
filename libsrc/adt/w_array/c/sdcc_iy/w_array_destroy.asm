
; void w_array_destroy(w_array_t *a)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC _w_array_destroy

EXTERN _b_array_destroy

defc _w_array_destroy = _b_array_destroy
