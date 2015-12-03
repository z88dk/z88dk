
; void *b_vector_append_block(b_vector_t *v, size_t n)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC b_vector_append_block_callee

EXTERN asm_b_vector_append_block

b_vector_append_block_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_b_vector_append_block
