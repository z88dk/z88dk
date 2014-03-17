
; size_t b_vector_append(b_vector_t *v, int c)

XLIB b_vector_append

LIB asm_b_vector_append

b_vector_append:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_b_vector_append
