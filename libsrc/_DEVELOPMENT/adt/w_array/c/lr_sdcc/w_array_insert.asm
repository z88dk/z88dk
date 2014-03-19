
; size_t w_array_insert(w_array_t *a, size_t idx, void *item)

XDEF w_array_insert

w_array_insert:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   INCLUDE "../../z80/asm_w_array_insert.asm"
