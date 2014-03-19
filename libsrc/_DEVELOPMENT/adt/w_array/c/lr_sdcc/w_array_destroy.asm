
; void w_array_destroy(w_array_t *a)

XDEF w_array_destroy

LIB b_array_destroy

defc w_array_destroy = b_array_destroy

INCLUDE "../../z80/asm_w_array_destroy.asm"
