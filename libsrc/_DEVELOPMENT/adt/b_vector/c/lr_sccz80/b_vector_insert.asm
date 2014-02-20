
; size_t b_vector_insert(b_vector_t *v, size_t idx, int c)

XLIB b_vector_insert

LIB asm_b_vector_insert

b_vector_insert:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   jp asm_b_vector_insert
