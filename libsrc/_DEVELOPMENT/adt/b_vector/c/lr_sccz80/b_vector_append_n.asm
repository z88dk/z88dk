
; size_t b_vector_append_n(b_vector_t *v, size_t n, int c)

XLIB b_vector_append_n

LIB asm_b_vector_append_n

b_vector_append_n:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   jp asm_b_vector_append_n
