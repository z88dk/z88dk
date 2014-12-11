
; void *b_array_data(b_array_t *a)

SECTION code_adt_b_array

PUBLIC b_array_data

defc b_array_data = asm_b_array_data

INCLUDE "adt/b_array/z80/asm_b_array_data.asm"
