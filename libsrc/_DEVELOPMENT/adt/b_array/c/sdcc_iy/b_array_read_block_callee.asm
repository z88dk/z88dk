
; size_t b_array_read_block_callee(void *dst, size_t n, b_array_t *a, size_t idx)

SECTION code_adt_b_array

PUBLIC _b_array_read_block_callee

_b_array_read_block_callee:

   pop af
   exx
   pop de
   exx
   pop de
   pop hl
   pop bc
   push af

   INCLUDE "adt/b_array/z80/asm_b_array_read_block.asm"
