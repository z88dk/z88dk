
; void b_array_clear(b_array_t *a)

SECTION seg_code_b_array

PUBLIC b_array_clear

defc b_array_clear = asm_b_array_clear

INCLUDE "adt/b_array/z80/asm_b_array_clear.asm"
