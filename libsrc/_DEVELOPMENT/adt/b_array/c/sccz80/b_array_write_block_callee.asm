
; size_t b_array_write_block(void *src, size_t n, b_array_t *a, size_t idx)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC b_array_write_block_callee

EXTERN asm_b_array_write_block

b_array_write_block_callee:

   pop af
   pop bc
   pop hl
   pop de
   exx
   pop hl
   exx
   push af
   
   jp asm_b_array_write_block
