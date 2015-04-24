
; b_array_t *b_array_init_callee(void *p, void *data, size_t capacity)

SECTION code_adt_b_array

PUBLIC _b_array_init_callee

_b_array_init_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   INCLUDE "adt/b_array/z80/asm_b_array_init.asm"
