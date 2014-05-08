
; size_t w_array_insert_n(w_array_t *a, size_t idx, size_t n, void *item)

PUBLIC _w_array_insert_n

_w_array_insert_n:

   pop ix
   pop hl
   pop bc
   pop de
   pop af
   
   push af
   push de
   push bc
   push hl
   push ix
      
   INCLUDE "adt/w_array/z80/asm_w_array_insert_n.asm"
