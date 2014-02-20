
; size_t b_vector_erase(b_vector_t *v, size_t idx)

XLIB b_vector_erase

LIB asm_b_vector_erase

b_vector_erase:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_b_vector_erase
