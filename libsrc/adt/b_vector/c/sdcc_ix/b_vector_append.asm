
; size_t b_vector_append(b_vector_t *v, int c)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC _b_vector_append

EXTERN asm_b_vector_append

_b_vector_append:

   pop af
   pop hl
   pop bc
   
   push bc
   push hl
   push af
   
   jp asm_b_vector_append
