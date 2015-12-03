
; void *b_array_insert_block(b_array_t *a, size_t idx, size_t n)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC b_array_insert_block_callee

EXTERN asm_b_array_insert_block

b_array_insert_block_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   jp asm_b_array_insert_block
