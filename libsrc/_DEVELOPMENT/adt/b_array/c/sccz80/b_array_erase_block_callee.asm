
; size_t b_array_erase_block(b_array_t *a, size_t idx, size_t n)

SECTION seg_code_b_array

PUBLIC b_array_erase_block_callee

b_array_erase_block_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   INCLUDE "adt/b_array/z80/asm_b_array_erase_block.asm"
