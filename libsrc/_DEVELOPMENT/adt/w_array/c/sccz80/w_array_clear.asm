
; void w_array_clear(w_array_t *a)

SECTION seg_code_w_array

PUBLIC w_array_clear

defc w_array_clear = asm_w_array_clear

INCLUDE "adt/w_array/z80/asm_w_array_clear.asm"
