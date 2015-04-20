
; size_t w_array_size_fastcall(w_array_t *a)

PUBLIC _w_array_size

defc _w_array_size_fastcall = asm_w_array_size

INCLUDE "adt/w_array/z80/asm_w_array_size.asm"
