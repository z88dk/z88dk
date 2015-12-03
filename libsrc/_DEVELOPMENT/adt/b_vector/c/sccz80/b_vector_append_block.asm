
; void *b_vector_append_block(b_vector_t *v, size_t n)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC b_vector_append_block

EXTERN asm_b_vector_append_block

b_vector_append_block:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_b_vector_append_block
