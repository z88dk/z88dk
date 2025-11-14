
; int b_vector_resize(b_vector_t *v, size_t n)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC _b_vector_resize

EXTERN asm_b_vector_resize

_b_vector_resize:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_b_vector_resize
