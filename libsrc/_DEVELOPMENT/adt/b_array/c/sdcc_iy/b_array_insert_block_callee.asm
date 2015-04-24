
; void *b_array_insert_block_callee(b_array_t *a, size_t idx, size_t n)

SECTION code_adt_b_array

PUBLIC _b_array_insert_block_callee

_b_array_insert_block_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af
   
   INCLUDE "adt/b_array/z80/asm_b_array_insert_block.asm"
