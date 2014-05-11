
; b_array_t *b_array_init(void *p, void *data, size_t capacity)

PUBLIC b_array_init_callee

b_array_init_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   INCLUDE "adt/b_array/z80/asm_b_array_init.asm"
