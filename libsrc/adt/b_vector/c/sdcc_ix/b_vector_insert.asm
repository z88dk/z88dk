
; size_t b_vector_insert(b_vector_t *v, size_t idx, int c)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC _b_vector_insert

EXTERN asm_b_vector_insert

_b_vector_insert:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af
   
   jp asm_b_vector_insert
