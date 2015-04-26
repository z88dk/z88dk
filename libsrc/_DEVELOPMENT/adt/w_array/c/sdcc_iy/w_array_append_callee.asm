
; size_t w_array_append_callee(w_array_t *a, void *item)

SECTION code_adt_w_array

PUBLIC _w_array_append_callee

_w_array_append_callee:

   pop af
   pop hl
   pop bc
   push af
   
   INCLUDE "adt/w_array/z80/asm_w_array_append.asm"
