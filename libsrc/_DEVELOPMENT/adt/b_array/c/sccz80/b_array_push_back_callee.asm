
; size_t b_array_push_back(b_array_t *a, int c)

SECTION seg_code_b_array

PUBLIC b_array_push_back_callee

EXTERN b_array_append_callee

defc b_array_push_back_callee = b_array_append_callee

INCLUDE "adt/b_array/z80/asm_b_array_push_back.asm"
