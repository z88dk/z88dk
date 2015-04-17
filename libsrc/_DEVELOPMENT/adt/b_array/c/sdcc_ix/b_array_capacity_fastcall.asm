
; size_t b_array_capacity_fastcall(b_array_t *a)

SECTION code_adt_b_array

PUBLIC _b_array_capacity_fastcall

defc _b_array_capacity_fastcall = asm_b_array_capacity

INCLUDE "adt/b_array/z80/asm_b_array_capacity.asm"
