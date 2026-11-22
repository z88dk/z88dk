
; void *b_vector_init(void *p, size_t capacity, size_t max_size)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC _b_vector_init

EXTERN asm_b_vector_init

_b_vector_init:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   jp asm_b_vector_init
