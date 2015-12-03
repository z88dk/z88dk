
; int b_vector_resize(b_vector_t *v, size_t n)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC b_vector_resize

EXTERN asm_b_vector_resize

b_vector_resize:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_b_vector_resize
