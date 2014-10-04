
; size_t w_array_capacity(w_array_t *a)

SECTION seg_code_w_array

PUBLIC w_array_capacity

defc w_array_capacity = asm_w_array_capacity

INCLUDE "adt/w_array/z80/asm_w_array_capacity.asm"
