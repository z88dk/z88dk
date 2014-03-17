
; b_array_t *b_array_init(void *p, void *data, size_t capacity)

XDEF b_array_init

b_array_init:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   INCLUDE "../../z80/asm_b_array_init.asm"
