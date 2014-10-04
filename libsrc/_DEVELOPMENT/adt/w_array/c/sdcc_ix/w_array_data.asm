
; void *w_array_data(w_array_t *a)

SECTION seg_code_w_array

PUBLIC _w_array_data

EXTERN _b_array_data

defc _w_array_data = _b_array_data

INCLUDE "adt/w_array/z80/asm_w_array_data.asm"
