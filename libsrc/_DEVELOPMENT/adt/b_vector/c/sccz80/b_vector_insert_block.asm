
; void *b_vector_insert_block(b_vector_t *v, size_t idx, size_t n)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC b_vector_insert_block

EXTERN asm_b_vector_insert_block

b_vector_insert_block:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   jp asm_b_vector_insert_block
