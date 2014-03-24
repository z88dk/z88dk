
; size_t b_array_push_back(b_array_t *a, int c)

XDEF b_array_push_back

LIB b_array_append

defc b_array_push_back = b_array_append

INCLUDE "adt/b_array/z80/asm_b_array_push_back.asm"
