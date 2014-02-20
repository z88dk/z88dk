
; void *b_vector_append_block(b_vector_t *v, size_t n)

XLIB b_vector_append_block

LIB asm_b_vector_append_block

b_vector_append_block:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_b_vector_append_block
