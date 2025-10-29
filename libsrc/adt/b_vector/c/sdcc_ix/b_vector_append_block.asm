
; void *b_vector_append_block(b_vector_t *v, size_t n)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC _b_vector_append_block

EXTERN asm_b_vector_append_block

_b_vector_append_block:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_b_vector_append_block
