
; size_t w_vector_append_n_callee(b_vector_t *v, size_t n, void *item)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC _w_vector_append_n_callee

EXTERN asm_w_vector_append_n

_w_vector_append_n:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   jp asm_w_vector_append_n
