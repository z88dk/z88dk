
; void w_array_destroy_fastcall(w_array_t *a)

SECTION code_adt_w_array

PUBLIC _w_array_destroy_fastcall

defc _w_array_destroy_fastcall = asm_w_array_destroy

INCLUDE "adt/w_array/z80/asm_w_array_destroy.asm"
