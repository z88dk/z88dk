
; size_t b_vector_append_n(b_vector_t *v, size_t n, int c)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC b_vector_append_n

EXTERN asm_b_vector_append_n

b_vector_append_n:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   jp asm_b_vector_append_n
