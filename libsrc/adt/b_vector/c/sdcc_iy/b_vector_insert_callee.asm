
; size_t b_vector_insert_callee(b_vector_t *v, size_t idx, int c)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC _b_vector_insert_callee

EXTERN asm_b_vector_insert

_b_vector_insert_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af
   
   jp asm_b_vector_insert
