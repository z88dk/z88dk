
; w_vector_t *w_vector_init(void *p, size_t capacity, size_t max_size)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC w_vector_init_callee

EXTERN asm_w_vector_init

w_vector_init_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af
   
   jp asm_w_vector_init
