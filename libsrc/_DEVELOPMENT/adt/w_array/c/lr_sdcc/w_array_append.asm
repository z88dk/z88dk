
; size_t w_array_append(w_array_t *a, void *item)

XDEF w_array_append

w_array_append:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   INCLUDE "../../z80/asm_w_array_append.asm"
