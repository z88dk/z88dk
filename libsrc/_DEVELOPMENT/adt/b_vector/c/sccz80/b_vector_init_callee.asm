
; void *b_vector_init(void *p, size_t capacity, size_t max_size)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC b_vector_init_callee

EXTERN asm_b_vector_init

b_vector_init_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af
   
   jp asm_b_vector_init
