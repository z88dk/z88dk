
; size_t w_vector_append_callee(b_vector_t *v, void *item)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC _w_vector_append_callee

EXTERN asm_w_vector_append

_w_vector_append_callee:

   pop af
   pop hl
   pop bc
   push af
   
   jp asm_w_vector_append
