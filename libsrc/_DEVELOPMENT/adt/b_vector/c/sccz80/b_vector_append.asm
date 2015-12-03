
; size_t b_vector_append(b_vector_t *v, int c)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC b_vector_append

EXTERN asm_b_vector_append

b_vector_append:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_b_vector_append
