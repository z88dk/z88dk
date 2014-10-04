
; size_t w_array_append_n(w_array_t *a, size_t n, void *item)

SECTION seg_code_w_array

PUBLIC _w_array_append_n

_w_array_append_n:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   INCLUDE "adt/w_array/z80/asm_w_array_append_n.asm"
