
; int w_array_empty_fastcall(b_array_t *a)

SECTION code_adt_w_array

PUBLIC _w_array_empty_fastcall

defc _w_array_empty_fastcall = asm_w_array_empty

INCLUDE "adt/w_array/z80/asm_w_array_empty.asm"
