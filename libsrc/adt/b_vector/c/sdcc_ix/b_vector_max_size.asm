
; void *b_vector_max_size(b_vector_t *v)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC _b_vector_max_size

EXTERN asm_b_vector_max_size

_b_vector_max_size:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_b_vector_max_size
