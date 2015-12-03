
; w_vector_t *w_vector_init(void *p, size_t capacity, size_t max_size)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC _w_vector_init

EXTERN asm_w_vector_init

_w_vector_init:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   jp asm_w_vector_init
