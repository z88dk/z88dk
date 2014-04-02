
; void w_array_destroy(w_array_t *a)

XDEF _w_array_destroy

LIB _b_array_destroy

_w_array_destroy:

   jp _b_array_destroy

   INCLUDE "adt/w_array/z80/asm_w_array_destroy.asm"
