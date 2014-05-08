
; void w_array_clear(w_array_t *a)

PUBLIC _w_array_clear

EXTERN _b_array_clear

_w_array_clear:

   jp _b_array_clear

   INCLUDE "adt/w_array/z80/asm_w_array_clear.asm"
