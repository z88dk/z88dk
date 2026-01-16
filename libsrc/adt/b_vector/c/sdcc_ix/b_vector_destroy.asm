
; void b_vector_destroy(b_vector_t *v)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC _b_vector_destroy

EXTERN asm_b_vector_destroy

_b_vector_destroy:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_b_vector_destroy
