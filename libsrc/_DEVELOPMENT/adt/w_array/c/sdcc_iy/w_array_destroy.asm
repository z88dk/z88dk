
; void w_array_destroy(w_array_t *a)

XDEF w_array_destroy

LIB b_array_destroy

w_array_destroy:

   jp b_array_destroy

   INCLUDE "adt/w_array/z80/asm_w_array_destroy.asm"
