
; size_t w_array_append(w_array_t *a, void *item)

SECTION seg_code_w_array

PUBLIC _w_array_append

_w_array_append:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   INCLUDE "adt/w_array/z80/asm_w_array_append.asm"
