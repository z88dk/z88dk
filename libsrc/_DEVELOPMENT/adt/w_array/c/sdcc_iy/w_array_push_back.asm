
; size_t w_array_push_back(w_array_t *a, void *item)

XDEF w_array_push_back

LIB w_array_append

w_array_push_back:

   jp w_array_append

   INCLUDE "adt/w_array/z80/asm_w_array_push_back.asm"
