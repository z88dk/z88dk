
; void *w_array_data(w_array_t *a)

XDEF _w_array_data

LIB _b_array_data

_w_array_data:

   jp _b_array_data

   INCLUDE "adt/w_array/z80/asm_w_array_data.asm"
