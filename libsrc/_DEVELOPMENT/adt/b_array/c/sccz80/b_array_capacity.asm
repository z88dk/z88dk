
; size_t b_array_capacity(b_array_t *a)

SECTION code_adt_b_array

PUBLIC b_array_capacity

defc b_array_capacity = asm_b_array_capacity

INCLUDE "adt/b_array/z80/asm_b_array_capacity.asm"
