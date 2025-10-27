
; size_t w_vector_insert_n_callee(w_vector_t *v, size_t idx, size_t n, void *item)

SECTION code_clib
SECTION code_adt_w_vector

PUBLIC _w_vector_insert_n_callee

EXTERN asm_w_vector_insert_n

_w_vector_insert_n_callee:

   pop ix
   pop hl
   pop bc
   pop de
   pop af
   push ix
   
   jp asm_w_vector_insert_n
