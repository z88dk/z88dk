
; int b_vector_reserve_callee(b_vector_t *v, size_t n)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC _b_vector_reserve_callee

EXTERN asm_b_vector_reserve

_b_vector_reserve_callee:

   pop af
   pop hl
   pop bc
   push af
   
   jp asm_b_vector_reserve
