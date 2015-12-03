
; size_t b_vector_append_n(b_vector_t *v, size_t n, int c)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC b_vector_append_n_callee

EXTERN asm_b_vector_append_n

b_vector_append_n_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   jp asm_b_vector_append_n
