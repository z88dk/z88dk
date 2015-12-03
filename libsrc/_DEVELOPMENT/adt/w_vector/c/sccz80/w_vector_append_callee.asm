
; size_t w_vector_append(b_vector_t *v, void *item)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC w_vector_append_callee

EXTERN asm_w_vector_append

w_vector_append_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   jp asm_w_vector_append
