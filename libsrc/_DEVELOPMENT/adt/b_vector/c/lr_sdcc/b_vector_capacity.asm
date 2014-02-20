
; size_t b_vector_capacity(b_vector_t *v)

XLIB b_vector_capacity

LIB asm_b_vector_capacity

b_vector_capacity:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_b_vector_capacity
