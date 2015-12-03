
; int w_vector_resize(w_vector_t *v, size_t n)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC w_vector_resize_callee

EXTERN asm_w_vector_resize

w_vector_resize_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_w_vector_resize
