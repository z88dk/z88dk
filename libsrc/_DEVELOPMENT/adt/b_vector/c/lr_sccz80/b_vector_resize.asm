
; int b_vector_resize(b_vector_t *v, size_t n)

XLIB b_vector_resize

LIB asm_b_vector_resize

b_vector_resize:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_b_vector_resize
