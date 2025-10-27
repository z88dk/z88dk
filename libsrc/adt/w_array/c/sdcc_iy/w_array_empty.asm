
; int w_array_empty(b_array_t *a)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC _w_array_empty

EXTERN _b_array_empty

defc _w_array_empty = _b_array_empty
