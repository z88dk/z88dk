
; size_t w_array_insert(w_array_t *a, size_t idx, void *item)

XDEF w_array_insert

w_array_insert:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af
   
   INCLUDE "adt/w_array/z80/asm_w_array_insert.asm"
