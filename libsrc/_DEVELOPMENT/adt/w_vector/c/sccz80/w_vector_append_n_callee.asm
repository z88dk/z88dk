
; size_t w_vector_append_n(b_vector_t *v, size_t n, void *item)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC w_vector_append_n_callee

EXTERN asm_w_vector_append_n

w_vector_append_n_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   jp asm_w_vector_append_n
