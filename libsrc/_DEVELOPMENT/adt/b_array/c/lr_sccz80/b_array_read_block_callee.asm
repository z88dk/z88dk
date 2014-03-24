
; size_t b_array_read_block(void *dst, size_t n, b_array_t *a, size_t idx)

XDEF b_array_read_block_callee

b_array_read_block_callee:

   pop af
   pop bc
   pop hl
   pop de
   exx
   pop de
   exx
   push af
   
   INCLUDE "adt/b_array/z80/asm_b_array_read_block.asm"
