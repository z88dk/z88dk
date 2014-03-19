
; size_t w_array_append_n(w_array_t *a, size_t n, void *item)

XDEF w_array_append_n

w_array_append_n:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   INCLUDE "../../z80/asm_w_array_append_n.asm"
