
; void *b_vector_insert_block_callee(b_vector_t *v, size_t idx, size_t n)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC _b_vector_insert_block_callee

EXTERN asm_b_vector_insert_block

_b_vector_insert_block_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af
   
   jp asm_b_vector_insert_block
