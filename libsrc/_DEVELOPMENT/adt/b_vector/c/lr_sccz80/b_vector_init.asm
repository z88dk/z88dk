
; void *b_vector_init(void *p, size_t capacity, size_t max_size)

XLIB b_vector_init

LIB asm_b_vector_init

b_vector_init:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af
   
   jp asm_b_vector_init
