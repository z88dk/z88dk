
; size_t b_vector_append_callee(b_vector_t *v, int c)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC _b_vector_append_callee

EXTERN asm_b_vector_append

_b_vector_append_callee:

   pop af
   pop hl
   pop bc
   push af
   
   jp asm_b_vector_append
