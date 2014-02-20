
; size_t b_vector_insert_n(b_vector_t *v, size_t idx, size_t n, int c)

XLIB b_vector_insert_n

LIB asm_b_vector_insert_n

b_vector_insert_n:

   pop af
   exx
   pop bc
   exx
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   exx
   push bc
   exx
   push af
   
   exx
   ld a,c
   exx
   
   jp asm_b_vector_insert_n
