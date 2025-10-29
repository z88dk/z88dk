
; size_t b_vector_write_block_callee(void *src, size_t n, b_vector_t *v, size_t idx)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC _b_vector_write_block_callee

EXTERN asm_b_vector_write_block

_b_vector_write_block_callee:

   pop af
   exx
   pop hl
   exx
   pop de
   pop hl
   pop bc
   push af

   jp asm_b_vector_write_block
