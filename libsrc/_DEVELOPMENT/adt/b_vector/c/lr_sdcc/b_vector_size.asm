
; void *b_vector_size(b_vector_t *v)

XLIB b_vector_size

LIB asm_b_vector_size

b_vector_size:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_b_vector_size
