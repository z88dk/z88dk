
; size_t w_array_push_back(w_array_t *a, void *item)

PUBLIC _w_array_push_back

EXTERN _w_array_append

_w_array_push_back:

   jp _w_array_append

   INCLUDE "adt/w_array/z80/asm_w_array_push_back.asm"
