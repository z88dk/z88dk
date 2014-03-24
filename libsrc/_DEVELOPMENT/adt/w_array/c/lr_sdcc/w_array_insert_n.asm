
; size_t w_array_insert_n(w_array_t *a, size_t idx, size_t n, void *item)

XDEF w_array_insert

w_array_insert:

   exx
   pop bc
   exx
   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   exx
   push bc
   exx
   
   INCLUDE "adt/w_array/z80/asm_w_array_insert.asm"
