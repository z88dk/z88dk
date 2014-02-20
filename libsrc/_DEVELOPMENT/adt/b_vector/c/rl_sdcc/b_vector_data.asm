
; void *b_vector_data(b_vector_t *v)

XLIB b_vector_data

LIB asm_b_vector_data

b_vector_data:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_b_vector_data
