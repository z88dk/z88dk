
; b_array_t *b_array_init(void *p, void *data, size_t capacity)

PUBLIC _b_array_init

_b_array_init:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   INCLUDE "adt/b_array/z80/asm_b_array_init.asm"
