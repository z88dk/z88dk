
; int w_array_empty(b_array_t *a)

PUBLIC _w_array_empty

EXTERN _b_array_empty

_w_array_empty:

   jp _b_array_empty

   INCLUDE "adt/w_array/z80/asm_w_array_empty.asm"
