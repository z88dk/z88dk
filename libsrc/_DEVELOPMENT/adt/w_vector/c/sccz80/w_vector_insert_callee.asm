
; size_t w_vector_insert(w_vector_t *v, size_t idx, void *item)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC w_vector_insert_callee

EXTERN asm_w_vector_insert

w_vector_insert_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   jp asm_w_vector_insert
