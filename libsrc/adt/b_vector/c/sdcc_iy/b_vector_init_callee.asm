
; void *b_vector_init_callee(void *p, size_t capacity, size_t max_size)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC _b_vector_init_callee

EXTERN asm_b_vector_init

_b_vector_init_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   jp asm_b_vector_init
