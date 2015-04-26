
; size_t w_array_append_n_callee(w_array_t *a, size_t n, void *item)

SECTION code_adt_w_array

PUBLIC _w_array_append_n_callee

_w_array_append_n_callee:

   pop af
   pop hl
   pop de
   push af
   
   INCLUDE "adt/w_array/z80/asm_w_array_append_n.asm"
