
; size_t b_vector_write_block(void *src, size_t n, b_vector_t *v, size_t idx)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC b_vector_write_block_callee

EXTERN asm_b_vector_write_block

b_vector_write_block_callee:

   pop af
   pop bc
   pop hl
   pop de
   exx
   pop hl
   exx
   push af
   
   jp asm_b_vector_write_block
