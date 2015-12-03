
; w_vector_t *w_vector_init_callee(void *p, size_t capacity, size_t max_size)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC _w_vector_init_callee

EXTERN asm_w_vector_init

_w_vector_init_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   jp asm_w_vector_init
