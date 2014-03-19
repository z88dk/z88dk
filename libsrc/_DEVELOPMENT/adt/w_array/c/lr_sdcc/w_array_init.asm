
; w_array_t *w_array_init(void *p, void *data, size_t capacity)

XDEF w_array_init

w_array_init:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   INCLUDE "../../z80/asm_w_array_init.asm"
