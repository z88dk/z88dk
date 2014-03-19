
; w_array_t *w_array_init(void *p, void *data, size_t capacity)

XDEF w_array_init

w_array_init:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   INCLUDE "../../z80/asm_w_array_init.asm"
