
; void w_array_destroy(w_array_t *a)

SECTION seg_code_w_array

PUBLIC _w_array_destroy

EXTERN _b_array_destroy

defc _w_array_destroy = _b_array_destroy

INCLUDE "adt/w_array/z80/asm_w_array_destroy.asm"
