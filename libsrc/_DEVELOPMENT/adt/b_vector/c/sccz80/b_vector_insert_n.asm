
; size_t b_vector_insert_n(b_vector_t *v, size_t idx, size_t n, int c)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC b_vector_insert_n

EXTERN asm_b_vector_insert_n

b_vector_insert_n:

   pop af
   pop ix
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push ix
   push af
   
   ld a,ixl   
   jp asm_b_vector_insert_n
