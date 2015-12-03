
; size_t b_vector_append_n(b_vector_t *v, size_t n, int c)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC _b_vector_append_n

EXTERN asm_b_vector_append_n

_b_vector_append_n:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   jp asm_b_vector_append_n
