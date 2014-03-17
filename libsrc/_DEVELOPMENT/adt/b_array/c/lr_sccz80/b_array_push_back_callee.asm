
; size_t b_array_push_back(b_array_t *a, int c)

XDEF b_array_push_back_callee

LIB b_array_append_callee

defc b_array_push_back_callee = b_array_append_callee

INCLUDE "../../z80/asm_b_array_push_back.asm"
