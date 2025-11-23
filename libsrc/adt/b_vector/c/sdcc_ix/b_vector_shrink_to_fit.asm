
; int b_vector_shrink_to_fit(b_vector_t *v)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC _b_vector_shrink_to_fit

EXTERN asm_b_vector_shrink_to_fit

_b_vector_shrink_to_fit:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_b_vector_shrink_to_fit
