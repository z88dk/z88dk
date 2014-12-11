
; size_t w_array_size(w_array_t *a)

SECTION code_adt_w_array

PUBLIC w_array_size

defc w_array_size = asm_w_array_size

INCLUDE "adt/w_array/z80/asm_w_array_size.asm"
