
; size_t b_vector_append_n_callee(b_vector_t *v, size_t n, int c)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC _b_vector_append_n_callee

EXTERN asm_b_vector_append_n

_b_vector_append_n_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   jp asm_b_vector_append_n
