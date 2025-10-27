
; int w_vector_reserve_callee(w_vector_t *v, size_t n)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC _w_vector_reserve_callee

EXTERN asm_w_vector_reserve

_w_vector_reserve_callee:

   pop af
   pop hl
   pop bc
   push af
   
   jp asm_w_vector_reserve
