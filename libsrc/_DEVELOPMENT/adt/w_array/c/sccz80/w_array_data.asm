
; void *w_array_data(w_array_t *a)

SECTION code_adt_w_array

PUBLIC w_array_data

defc w_array_data = asm_w_array_data

INCLUDE "adt/w_array/z80/asm_w_array_data.asm"
