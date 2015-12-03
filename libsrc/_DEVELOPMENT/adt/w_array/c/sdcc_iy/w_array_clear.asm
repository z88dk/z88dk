
; void w_array_clear(w_array_t *a)

SECTION code_clib
SECTION code_adt_w_array

PUBLIC _w_array_clear

EXTERN _b_array_clear

defc _w_array_clear = _b_array_clear
