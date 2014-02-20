
; size_t b_vector_append(b_vector_t *v, int c)

XLIB b_vector_append
XDEF b_vector_push_back

LIB asm_b_vector_append

b_vector_append:
b_vector_push_back:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_b_vector_append
